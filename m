From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC][PATCH 0/2] Android style loosening of cgroup attach permissions
Date: Wed, 20 May 2015 20:41:12 -0700
Message-ID: <1432179674-19154-1-git-send-email-john.stultz@linaro.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>

As a heads up, this is just a first RFC and not a submission.

Android currently loosens the cgroup attchment permissions, allowing
tasks with CAP_SYS_NICE to be able to allow tasks to move arbitrary
tasks across cgroups.

At first glance, overloading CAP_SYS_NICE seems a bit hackish, but this
shows that there is a active and widely deployed use for different cgroup
attachment rules then what is currently available.

I've tried to rework the patches so this attachment policy is build
time configurable, and wanted to send them out for review so folks
might give their thoughts on this implementation and what they might
see as a better way to go about achieving the same goal.

Thoughts and feedback would be appriciated!

thanks
-john

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Cc: Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>

Colin Cross (1):
  cgroup: Add generic cgroup subsystem permission checks

Rom Lemarchand (1):
  cgroup: Add a memcg and cpu cg allow_attach policy for Android

 Documentation/cgroups/cgroups.txt |  9 +++++++++
 include/linux/cgroup.h            | 14 ++++++++++++++
 init/Kconfig                      |  7 +++++++
 kernel/Makefile                   |  1 +
 kernel/cgroup.c                   | 39 ++++++++++++++++++++++++++++++++++++---
 kernel/cgroup_nice_attach.c       | 29 +++++++++++++++++++++++++++++
 kernel/sched/core.c               |  3 +++
 mm/memcontrol.c                   |  3 +++
 8 files changed, 102 insertions(+), 3 deletions(-)
 create mode 100644 kernel/cgroup_nice_attach.c

-- 
1.9.1
