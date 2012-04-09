From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v2 0/5] per-cgroup /proc/stat statistics
Date: Mon,  9 Apr 2012 19:25:10 -0300
Message-ID: <1334010315-4453-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lxc-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Hi,

This patch aims at allowing userspace to recreate the most important
contents of /proc/stat per-cgroup. It exports the data needed for it
from the guts of the scheduler, and then anyone can parse it and
present it to a container in a meaningful way. Again, the kernel won't
get involved in this directly.

Part of it will come from the cpu cgroup. Another part, from the cpuacct
cgroup. Data is exported in cgroup files stat_percpu. They are just like
the normal stat files, but with a cpuXXX value before the actual data
field. As so, they are also extensible. So if anyone wants to give a
shot at values I am currently ignoring (as iowait) in the future, we
at least won't have a format problem.

Let me know what you think.

Glauber Costa (5):
  measure exec_clock for rt sched entities
  account guest time per-cgroup as well.
  record nr_switches per task_group
  expose fine-grained per-cpu data for cpuacct stats
  expose per-taskgroup schedstats in cgroup

 kernel/sched/core.c  |  214 ++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/fair.c  |   27 ++++++-
 kernel/sched/rt.c    |    5 +
 kernel/sched/sched.h |    6 ++
 4 files changed, 245 insertions(+), 7 deletions(-)

-- 
1.7.7.6
