From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET RFC] cpu,cpuacct: make cpu serve cpuacct files and deprecate cpuacct
Date: Wed, 19 Sep 2012 15:43:42 -0700
Message-ID: <1348094625-4471-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=R7BdWQRFLns4dQu7mLIqrbGua9frUyDLdnJs9TJA+VA=;
        b=TjfqoZ8XcQjdiwuU/kF/PmAICilxWO/YhBJ5fG0OKDnCgLT6nI/7K3m4x/FDLrfCq9
         Cr+7athrppL9mqd8RHoXseh0U2TaMfUIbK4ZM+h/a32XlE3Sq9zlO9ldCA7C4Lc8Z7yb
         zxWKEikYZxmDtl8T8wq/XZFpDMXtxdS95RR/r/a8c4fQRgwxkFEOxfrWh8fjdX0ABCC+
         Vu0fJrhq6phVk0bm4woz8oUnq3HK/UN+pzS6n6osLl5F+C1Iqy4XBBw7fTN19XSgsG/F
         e4vwPDmgmD2dtcF8sybtroeQgbLT2FxWqBor7NsXRVKfrGdIOh/ScRi5lsKd/S9ovDsO
         +b8Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org, mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org, davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello,

This is an attempt at allowing quick deprecation and removal of
cpuacct.  The patchset makes cpu serve the same cpuacct.* files and
updates cgroup core such that it ignores cpuacct if requested to be
co-mounted with cpu whether CONFIG_CGROUP_CPUACCT is enabled or not.

This de-couples cpuacct deprecation on kernel side from userland
transition as long as userland is co-mounting cpu and cpuacct.  In
this series, cpuacct implementation is simply copied into cpu, the
goal being to provide base for proper optimization (most likely
periodic collection of stats across the hierarchy).

I didn't try to maintain everything the same.  /proc/cgroups and
/proc/PID/cgroup may mis-represent or miss cpuacct entry.  Faking it
completely is doable too but I'd like to keep it as simple as
possible.

* If cpuacct is not used, nothing changes of course.

* If cpuacct is requested to be co-mounted with cpu, cpuacct is not
  used.  It doesn't matter whether CONFIG_CGROUP_CPUACCT is enabled or
  not.  cpu will provide cpusage.* statistics.

* If cpuacct is requested to be mounted separately and cpuacct is
  enabled, cgroup whines before mounting it.  If cpuacct is disabled,
  it fails.

I think the resulting behavior isn't too crazy and it should allow us
to remove anything cpuacct related fairly soon.

Longer term, I'd prefer to be able to drop the compatibility hack from
cgroup core too although I don't think that's too urgent.  I think
userland can either create symlinks for compatibility -
e.g. /sys/fs/cgroup/cpuacct and /sys/fs/cgroup/cpu,cpucct both
pointing to /sys/fs/cgroup/cpu - whether cpuacct exists or not, or
just ignore anything cpuacct related.

This series is based on for-3.7-hierarchy 8c7f6edbda0 ("cgroup: mark
subsystems with broken hierarchy...") and also available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-deprecate-cpuacct

 include/linux/cgroup.h   |    1 
 init/Kconfig             |   11 ++
 kernel/cgroup.c          |   57 ++++++++++++-
 kernel/sched/core.c      |  196 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/fair.c      |    1 
 kernel/sched/rt.c        |    1 
 kernel/sched/sched.h     |    7 +
 kernel/sched/stop_task.c |    1 
 8 files changed, 269 insertions(+), 6 deletions(-)

Thanks.

--
tejun
