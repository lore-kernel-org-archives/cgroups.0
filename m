From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v3 0/6] per cgroup /proc/stat statistics
Date: Wed, 30 May 2012 13:48:31 +0400
Message-ID: <1338371317-5980-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hi

This is a rework of my v2 series taking into account Paul
Turner's comments. All the series is the same except for
the patch that collets nr_switches that is now completely reworked.

It is out of schedule(), relegated to a scheduler hook. Only difference
from Paul's suggestion is that I added a new one, instead of messing with
put_prev_task + pick_next_task pairs. In the patchset that adds it,
I'll try to argue for my solution.

Hope this is acceptable, and please let me know of any other concerns.

v2:
* completely reworked nr_switches gathering
* separated per-se sleep_start to be more clear about it

Glauber Costa (6):
  measure exec_clock for rt sched entities
  account guest time per-cgroup as well.
  expose fine-grained per-cpu data for cpuacct stats
  add a new scheduler hook for context switch
  Also record sleep start for a task group
  expose per-taskgroup schedstats in cgroup

 include/linux/sched.h |    1 +
 kernel/sched/core.c   |  166 +++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/fair.c   |   42 ++++++++++++-
 kernel/sched/rt.c     |   20 ++++++
 kernel/sched/sched.h  |    6 ++
 5 files changed, 228 insertions(+), 7 deletions(-)

-- 
1.7.10.2
