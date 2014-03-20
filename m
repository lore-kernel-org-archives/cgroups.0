From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC 0/4] Migrate timers away from cpuset on setting cpuset.quiesce
Date: Thu, 20 Mar 2014 19:18:57 +0530
Message-ID: <cover.1395322529.git.viresh.kumar@linaro.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

For networking platforms we need to provide one isolated CPU per user space data
plane thread. These CPUs should not be interrupted by kernel at all unless
userspace has requested for some syscalls. And so must live in isolated mode.
Currently, there are background kernel activities that are running on almost
every CPU, like: timers/hrtimers/watchdogs/etc, and these are required to be
migrated to other CPUs.

This patchset tries to migrate un-pinned timers away in the first attempt. And
support for migrating others like hrtimers/workqueues/etc would be added later.

This has only went through basic testing currently on ARM Samsung Exynos board
which only has two CPUs. Separate cpusets were created for these two CPUs and
then timers were migrated from one cpuset to other.

This option was earlier suggested by Peter Z. here.

https://lkml.org/lkml/2014/1/15/186

Please provide your inputs on how this can be improved..

Viresh Kumar (4):
  timer: track pinned timers with TIMER_PINNED flag
  timer: don't migrate pinned timers
  timer: create timer_quiesce_cpu() for cpusets.quiesce option
  cpuset: Add cpusets.quiesce option

 include/linux/timer.h | 10 +++---
 kernel/cpuset.c       | 56 +++++++++++++++++++++++++++++++
 kernel/timer.c        | 92 +++++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 136 insertions(+), 22 deletions(-)

-- 
1.7.12.rc2.18.g61b472e
