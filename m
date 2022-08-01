From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/2] sched, cgroup/cpuset: Keep user set cpus affinity
Date: Mon,  1 Aug 2022 11:41:22 -0400
Message-ID: <20220801154124.2011987-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659368511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6aGAsmftLF/0dvg9tasEyfV88rlFwnKcqNhuGDzyxe4=;
        b=H9alO73+1jg9xAuRK+5yRhXxiLEA3apU9186ezlO0fcJ+gy4X++oasUHfyxA5xffjyWdHM
        jGRHcDRdplC+yNUT5zwxDsaQI9HBqtElBfy7giMzrSwRKV1NEdDojVYSsCjuMApCflbkCJ
        VlbTzxtGetv/R0vyBdz8q8aKVGtESPQ=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

v2:
 - Rework the v1 patch by extending the semantics of user_cpus_ptr to
   store user set cpus affinity and keeping to it as much as possible.

The user_cpus_ptr field is added by commit b90ca8badbd1 ("sched:
Introduce task_struct::user_cpus_ptr to track requested affinity")
which uses it narrowly to allow keeping cpus affinity intact with
asymmetric cpu setup.

This patchset extends user_cpus_ptr to store user set cpus affinity
via sched_setaffinity() API. With that information avaiable, it will
enable cpuset to keep cpus afinity as close to what the user wants as
possible within the cpu list constraint of the current cpuset.

Waiman Long (2):
  sched: Use user_cpus_ptr for saving user provided cpumask in
    sched_setaffinity()
  cgroup/cpuset: Keep user set cpus affinity

 include/linux/sched.h  |  1 +
 kernel/cgroup/cpuset.c | 24 ++++++++++++--
 kernel/sched/core.c    | 71 ++++++++++++++++++++++++++++++------------
 kernel/sched/sched.h   |  1 -
 4 files changed, 74 insertions(+), 23 deletions(-)

-- 
2.31.1

