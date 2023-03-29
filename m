From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/6] sched/deadline: cpuset: Rework DEADLINE bandwidth restoration
Date: Wed, 29 Mar 2023 14:55:52 +0200
Message-ID: <20230329125558.255239-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680094578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Bfp+uWRbOwM8a2jDGBZKgrnhrhJwiLY7EtO8YbQJdLo=;
        b=SmrIqzSxRYXn+p3LnuhTdtMpFEpq3odXtWHwTCxMIeM7+72pj5Oq4CuI6c3rT5HUJ3+DSh
        9WLcya6pZjfZx/yj2iia08BzMajcQNxhRp+C25FA4bSlBIDZtoab5YbJviE60OG5F2XIX6
        c86oj7l4I0zUy8t6jTGVIEZnp4iu0Yw=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Qais reported [1] that iterating over all tasks when rebuilding root
domains for finding out which ones are DEADLINE and need their bandwidth
correctly restored on such root domains can be a costly operation (10+
ms delays on suspend-resume). He proposed we skip rebuilding root
domains for certain operations, but that approach seemed arch specific
and possibly prone to errors, as paths that ultimately trigger a rebuild
might be quite convoluted (thanks Qais for spending time on this!).

To fix the problem

 01/06 - Rename functions deadline with DEADLINE accounting (cleanup
         suggested by Qais) - no functional change
 02/06 - Bring back cpuset_mutex (so that we have write access to cpusets
         from scheduler operations - and we also fix some problems
         associated to percpu_cpuset_rwsem)
 03/06 - Keep track of the number of DEADLINE tasks belonging to each cpuset
 04/06 - Create DL BW alloc, free & check overflow interface for bulk
         bandwidth allocation/removal - no functional change 
 05/06 - Fix bandwidth allocation handling for cgroup operation
         involving multiple tasks
 06/06 - Use this information to only perform the costly iteration if
         DEADLINE tasks are actually present in the cpuset for which a
         corresponding root domain is being rebuilt

With respect to the RFC posting [2]

 1 - rename DEADLINE bandwidth accounting functions - Qais
 2 - call inc/dec_dl_tasks_cs from switched_{to,from}_dl - Qais
 3 - fix DEADLINE bandwidth allocation with multiple tasks - Waiman,
     contributed by Dietmar

This set is also available from

https://github.com/jlelli/linux.git deadline/rework-cpusets

Best,
Juri

1 - https://lore.kernel.org/lkml/20230206221428.2125324-1-qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org/
2 - https://lore.kernel.org/lkml/20230315121812.206079-1-juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/

Dietmar Eggemann (2):
  sched/deadline: Create DL BW alloc, free & check overflow interface
  cgroup/cpuset: Free DL BW in case can_attach() fails

Juri Lelli (4):
  cgroup/cpuset: Rename functions dealing with DEADLINE accounting
  sched/cpuset: Bring back cpuset_mutex
  sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets
  cgroup/cpuset: Iterate only if DEADLINE tasks are present

 include/linux/cpuset.h  |  12 ++-
 include/linux/sched.h   |   4 +-
 kernel/cgroup/cgroup.c  |   4 +
 kernel/cgroup/cpuset.c  | 232 ++++++++++++++++++++++++++--------------
 kernel/sched/core.c     |  41 ++++---
 kernel/sched/deadline.c |  67 +++++++++---
 kernel/sched/sched.h    |   2 +-
 7 files changed, 240 insertions(+), 122 deletions(-)

-- 
2.39.2

