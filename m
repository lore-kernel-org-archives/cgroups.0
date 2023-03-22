From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Subject: [RFC PATCH 0/2] sched/cpuset: Fix DL BW accounting in case can_attach() fails
Date: Wed, 22 Mar 2023 14:59:57 +0100
Message-ID: <20230322135959.1998790-1-dietmar.eggemann@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luca Abeni <luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org>, Tommaso Cucinotta <tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I followed Longman's idea to add a `deadline task transfer count` into
cpuset and only update the `dl task count` in cpuset_attach().

Moreover, I switched from per-task DL BW request to a per-cpuset one.
This way we don't have to free per-task in case xxx_can_attach() fails.

The DL BW freeing is handled in cpuset_cancel_attach() for the case
`multiple controllers and one of the non-cpuset can_attach() fails`.

Only lightly tested on cgroup v1 with exclusive cpusets so far.

Dietmar Eggemann (2):
  sched/deadline: Create DL BW alloc, free & check overflow interface
  cgroup/cpuset: Free DL BW in case can_attach() fails

 include/linux/sched.h   |  4 ++-
 kernel/cgroup/cpuset.c  | 55 +++++++++++++++++++++++++++++++++++++----
 kernel/sched/core.c     | 19 +++-----------
 kernel/sched/deadline.c | 53 +++++++++++++++++++++++++++++----------
 kernel/sched/sched.h    |  2 +-
 5 files changed, 97 insertions(+), 36 deletions(-)

-- 
2.25.1

