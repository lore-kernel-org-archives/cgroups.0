From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC][PATCH 0/2] Another pass at Android style loosening of cgroup attach permissions
Date: Mon,  3 Oct 2016 21:41:28 -0700
Message-ID: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=SbOiMLqSHNhxUChuurnoMYhpYke4OROGEO6Zz5KQNJo=;
        b=QXwX1GqVT+Gbw0QuWk5aJRDcqpIp9LQ6a0ihZJQd3rSOpI7P49295MzsKCqPImNi9j
         ZPzQfzSGKeBq5gHoz4Pyv2Z3n7dkOvUppA6v/4qiY03eQpmI6di+6mWQef85tbjfpdhD
         zngFEOkaDsXLw+Bge04xNgMCCx+fslPMTOlSE=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

As a heads up, this is just a first RFC and not a submission.

I wanted to send this out again, as the last time I submitted this
(https://marc.info/?l=linux-kernel&m=143217972215192&w=2) the
discussion got out into the separate issue of how Android at one
time abused memcg (but I believe now memcg is no longer used).

So for this revision, I've removed any memcg usage so we can try
to focus on just the actively used cpuset and cpuctrl cgroups.

Android currently loosens the cgroup attchment permissions, allowing
tasks with CAP_SYS_NICE to be able to allow tasks to move arbitrary
tasks across cgroups.

Android currently uses cgroups to bound tasks in various states (ie:
foreground applications, background applications, audio application,
system audio, and system tasks), to specific cpus as well as to limit
cpu time. This allows for things like audio applications to be
SCHED_FIFO but not run-away hogging infinite cpu, and background task
cpu usage to be similarly cputime limited, and kept to only low-power
cpus.

The migration of a task from the foreground to background, or to
elevate a task to audio priority, may be done by system service that
does not run as root. So this patch allows processes with CAP_SYS_NICE
to be able to migrate tasks between cgroups.  I suspect if there was a
specific cap (CAP_SYS_CHANGE_CGROUP) for this, it would be usable here,
but in its absence, they've overloaded CAP_SYS_NICE for this use.

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
Cc: Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Colin Cross (1):
  cgroup: Add generic cgroup subsystem permission checks

Rom Lemarchand (1):
  cgroup: Add a allow_attach policy for Android

 Documentation/cgroup-v1/cgroups.txt |  9 ++++++
 include/linux/cgroup-defs.h         |  1 +
 include/linux/cgroup.h              | 16 ++++++++++
 init/Kconfig                        |  7 +++++
 kernel/cgroup.c                     | 61 +++++++++++++++++++++++++++++++++++--
 kernel/cpuset.c                     |  3 ++
 kernel/sched/core.c                 |  3 ++
 7 files changed, 98 insertions(+), 2 deletions(-)

-- 
1.9.1
