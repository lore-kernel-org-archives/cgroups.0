From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v7 00/11] per-cgroup cpu-stat
Date: Wed, 29 May 2013 15:03:11 +0400
Message-ID: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Peter et. al,

I am coming again with this series, hoping this is a better time for you all to
look at it.

I am *not* going as far as marking cpuacct deprecated, because I think it
deserves a special discussion (even though my position in this matter is widely
known), but all the infrastructure to make it happen is here. But after this,
it should be a matter of setting a flag (or not).

Through this patchset I am making cpu cgroup provide the same functionality of
cpuacct, and now with a more clear semantics, I attempt to provide userspace
with enough information to reconstruct per-container version of files like
"/proc/stat". In particular, we are interested in knowing the per-cgroup slices
of user time, system time, wait time, number of processes, and a variety of
statistics.

To make sure we can count nr of switches correctly, I am ressurecting one of
Peter's patches that apparently got nowhere in the past.

Glauber Costa (8):
  don't call cpuacct_charge in stop_task.c
  sched: adjust exec_clock to use it as cpu usage metric
  cpuacct: don't actually do anything.
  sched: document the cpu cgroup.
  sched: account guest time per-cgroup as well.
  sched: record per-cgroup number of context switches
  sched: change nr_context_switches calculation.
  sched: introduce cgroup file stat_percpu

Peter Zijlstra (1):
  sched: Push put_prev_task() into pick_next_task()

Tejun Heo (2):
  cgroup: implement CFTYPE_NO_PREFIX
  cgroup, sched: let cpu serve the same files as cpuacct

 Documentation/cgroups/cpu.txt |  99 +++++++++++
 include/linux/cgroup.h        |   1 +
 kernel/cgroup.c               |  16 +-
 kernel/sched/core.c           | 385 ++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/cputime.c        |  33 +++-
 kernel/sched/fair.c           |  39 ++++-
 kernel/sched/idle_task.c      |   9 +-
 kernel/sched/rt.c             |  42 +++--
 kernel/sched/sched.h          |  35 +++-
 kernel/sched/stop_task.c      |   8 +-
 10 files changed, 626 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/cgroups/cpu.txt

-- 
1.8.1.4
