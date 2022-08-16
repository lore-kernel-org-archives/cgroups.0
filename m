From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/3] sched, cgroup/cpuset: Keep user set cpus affinity
Date: Tue, 16 Aug 2022 11:11:16 -0400
Message-ID: <20220816151119.29534-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660662698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jEYRKj1nlSqtCrHOWIArTdrELJ6+dwpREnZJE+d8OE8=;
        b=NlhGKQg5Fnfz2cejt3KVKddjp9zO/GJ3dOkfIY9H+biFvjT6LRyU/x7L3rzD0aUQsxQwgV
        3PwFjJqaPPRwI6hg7qBu5j8BK+lp4s99H1BR9NCYRmMa87pSISXqjAtDZVTkeFdFOeRNR+
        HHIDldqEF2KXr0TTTBVuCQpZtefUF84=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

v4:
 - Update patch 1 to make sched_setaffinity() the only function to
   update user_cpus_ptr to make the logic simpler and
   easier to understand. restrict_cpus_allowed_ptr() and
   relax_compatible_cpus_allowed_ptr() will just use it if present.

v3:
 - Attach a new patch 2 to introduce a copy_user_cpus_mask() to copy
   out user masks with lock protection & use it in patch 3.

v2:
 - Rework the v1 patch by extending the semantics of user_cpus_ptr to
   store user set cpus affinity and keeping to it as much as possible.

The user_cpus_ptr field is added by commit b90ca8badbd1 ("sched:
Introduce task_struct::user_cpus_ptr to track requested affinity")
which uses it narrowly to allow keeping cpus affinity intact with
asymmetric cpu setup.

This patchset extends user_cpus_ptr to store user set cpus affinity via
sched_setaffinity() API. With that information avaiable, it will enable
cpuset to keep cpus afinity as close to what the user wants as possible
within the cpu list constraint of the current cpuset. Otherwise some
change to the cpuset hierarchy may reset the cpumask of the tasks in
the affected cpusets to the default cpuset value even if those tasks
have cpus affinity explicitly set by the users before.

It also means that once sched_setaffinity() is called, user_cpus_ptr
will remain allocated until the task exits.

Waiman Long (3):
  sched: Use user_cpus_ptr for saving user provided cpumask in
    sched_setaffinity()
  sched: Provide copy_user_cpus_mask() to copy out user mask
  cgroup/cpuset: Keep user set cpus affinity

 include/linux/sched.h  |   1 +
 kernel/cgroup/cpuset.c |  28 +++++++++-
 kernel/sched/core.c    | 119 ++++++++++++++++++++++++-----------------
 kernel/sched/sched.h   |   1 -
 4 files changed, 98 insertions(+), 51 deletions(-)

-- 
2.31.1

