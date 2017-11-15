From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.15-rc1
Date: Wed, 15 Nov 2017 11:03:47 -0800
Message-ID: <20171115190347.GB983427@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=RJX6PmP9+6KQPnHLfZE172ZrRiljwWIUYnWy2I1z8M0=;
        b=szuatRZi05J0Oz7UJkiOMiemuvZMmfSjQqxnDNMRYH3pmIfkblvJd+kSFG3Xk1wuoI
         03PLvR1iJXzERaiNoO1ImSuUiKUVR6YkxTkTd5iElQfMlRW0MT8QcHn0PvZTfHIaHFlO
         cJ8i2THbsXAJGfzYrWqAEB5ETgkL1H3qYSVF/X9Is3I6PJtf3st+9zBB1jKqZPsuQKBN
         OE+LuhMTnSRuXUFDxEztxoqmjmy4efK3kkFwqyBftAOTgThel4fUejiYAfYyQV103b5x
         Y3pwRRXiCP7FFSFqFY4vwryXuzQxLityohrjZtYAc7/uvbSPTzm02IVwI/rIb4IxT2be
         lI5A==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Linus.

cgroup changes for v4.15-rc1.  cgroup2 cpu controller support is
finally merged.

* Basic cpu statistics support to allow monitoring by default without
  the CPU controller enabled.

* cgroup2 cpu controller support.

* /sys/kernel/cgroup files to help dealing with new / optional
  features.

The merge causes conflicts in two files - kernel/cgroup/Makefile and
kernel/cgorup/cpuacct.h.  Both are trivial conflicts from the license
identifier addition.  Makefile resolution is trivial and cpuacct.h no
longer exists.

Please expect another merge conflict with the bpf changes.  It's
caused by two additions to the cgroup_create() error handling path.
The resolution in the linux-next is correct.

  https://marc.info/?l=linux-next&m=150757433124201&w=2

Thanks.

The following changes since commit e19b205be43d11bff638cad4487008c48d21c103:

  Linux 4.14-rc2 (2017-09-24 16:38:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.15

for you to fetch changes up to 5f2e673405b742be64e7c3604ed4ed3ac14f35ce:

  cgroup: export list of cgroups v2 features using sysfs (2017-11-06 12:01:57 -0800)

----------------------------------------------------------------
Chao Yu (1):
      MAINTAINERS: relocate cpuset.c

Roman Gushchin (2):
      cgroup: export list of delegatable control files using sysfs
      cgroup: export list of cgroups v2 features using sysfs

Tejun Heo (9):
      sched/cputime: Expose cputime_adjust()
      cpuacct: Introduce cgroup_account_cputime[_field]()
      cgroup: Implement cgroup2 basic CPU usage accounting
      cgroup: statically initialize init_css_set->dfl_cgrp
      sched/cputime: Add dummy cputime_adjust() implementation for CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
      sched: Misc preps for cgroup unified hierarchy interface
      sched: Implement interface for cgroup unified hierarchy
      cgroup, sched: Move basic cpu stats from cgroup.stat to cpu.stat
      cgroup: mark @cgrp __maybe_unused in cpu_stat_show()

 Documentation/cgroup-v2.txt     |  42 ++---
 MAINTAINERS                     |   2 +-
 include/linux/cgroup-defs.h     |  59 +++++++
 include/linux/cgroup.h          |  58 +++++++
 include/linux/sched/cputime.h   |   3 +-
 kernel/cgroup/Makefile          |   2 +-
 kernel/cgroup/cgroup-internal.h |   9 ++
 kernel/cgroup/cgroup.c          | 157 ++++++++++++++++++-
 kernel/cgroup/stat.c            | 334 ++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c             | 174 ++++++++++++++++++++-
 kernel/sched/cpuacct.h          |  17 --
 kernel/sched/cputime.c          |  14 +-
 kernel/sched/deadline.c         |   2 +-
 kernel/sched/fair.c             |   2 +-
 kernel/sched/rt.c               |   2 +-
 kernel/sched/sched.h            |   2 +-
 kernel/sched/stop_task.c        |   2 +-
 17 files changed, 821 insertions(+), 60 deletions(-)
 create mode 100644 kernel/cgroup/stat.c
 delete mode 100644 kernel/sched/cpuacct.h

-- 
tejun
