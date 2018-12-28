From: Tejun Heo <tj@kernel.org>
Subject: [GIT UPDATED PULL] cgroup changes for v4.21-rc1
Date: Fri, 28 Dec 2018 10:41:17 -0800
Message-ID: <20181228184117.GN2509588@devbig004.ftw2.facebook.com>
References: <20181228021605.GI2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sBbL421+bYwi0jfrEuusHOcZ6XbW1Wn1tPoDDCiEq9Q=;
        b=YTevJs64nf8i+6b4/NpUDS5FnWgMpJ2fGRIZ8evVuVsIMQs+N35qXrctyvWKo782OO
         uMM5zYz0Ssdt7GzUke8fN6attT8DOFo+71CLw0J/2VeD0BEpsqXJ1uYRr7OOIAMI4obM
         gVy6wuX4tWrXblpLa+r1OZvV6tX05S/YGFODZqIHIokeTmm/Wr4FpjkUikUsh+g4VXA6
         ri5fwHrvH2W3DTL62JLg4wg2uSNwiuzTijduPH90bnq+juenyqc0pdd0DdCVIgRTZXbp
         RmbprbCU7FhZk7rdNdVrxhvr9AR083bdwBnfhr9TuGzhNRPYdt3NUw97S9LmmAq44msW
         4stA==
Content-Disposition: inline
In-Reply-To: <20181228021605.GI2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

Hello, Linus.

Updated cgroup pull request for v4.21.  The last two bullets are the
additions.

* Waiman's cgroup2 cpuset support has been finally merged closing one
  of the last remaining feature gaps.

* cgroup.procs could show non-leader threads when cgroup2 threaded
  mode was used in certain ways.  I forgot to push the fix during the
  last cycle.

* A patch to fix mount option parsing when all mount options have been
  consumed by someone else (LSM).

* cgroup_no_v1 boot param can now block named cgroup1 hierarchies too.

Thanks.

The following changes since commit f2ce1065e767fc7da106a5f5381d1e8f842dc6f4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-11-19 09:24:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.21

for you to fetch changes up to 3fc9c12d27b4ded4f1f761a800558dab2e6bbac5:

  cgroup: Add named hierarchy disabling to cgroup_no_v1 boot param (2018-12-28 10:34:12 -0800)

----------------------------------------------------------------
Ondrej Mosnacek (1):
      cgroup: fix parsing empty mount option string

Tejun Heo (5):
      cpuset: Minor cgroup2 interface updates
      cgroup: Add .__DEBUG__. prefix to debug file names
      cgroup: fix CSS_TASK_ITER_PROCS
      Merge branch 'for-4.20-fixes' into for-4.21
      cgroup: Add named hierarchy disabling to cgroup_no_v1 boot param

Waiman Long (12):
      cpuset: Enable cpuset controller in default hierarchy
      cpuset: Define data structures to support scheduling partition
      cpuset: Simply allocation and freeing of cpumasks
      cpuset: Add new v2 cpuset.sched.partition flag
      cpuset: Add an error state to cpuset.sched.partition
      cpuset: Track cpusets that use parent's effective_cpus
      cpuset: Make CPU hotplug work with partition
      cpuset: Make generate_sched_domains() work with partition
      cpuset: Expose cpus.effective and mems.effective on cgroup v2 root
      cpuset: Use descriptive text when reading/writing cpuset.sched.partition
      cpuset: Add documentation about the new "cpuset.sched.partition" flag
      cpuset: Expose cpuset.cpus.subpartitions with cgroup_debug

Yangtao Li (1):
      cgroup: remove unnecessary unlikely()

YueHaibing (1):
      cpuset: Remove set but not used variable 'cs'

 Documentation/admin-guide/cgroup-v2.rst         | 182 ++++-
 Documentation/admin-guide/kernel-parameters.txt |   8 +-
 include/linux/cgroup-defs.h                     |   1 +
 kernel/cgroup/cgroup-internal.h                 |   2 +
 kernel/cgroup/cgroup-v1.c                       |  14 +-
 kernel/cgroup/cgroup.c                          |  60 +-
 kernel/cgroup/cpuset.c                          | 944 ++++++++++++++++++++++--
 kernel/cgroup/debug.c                           |   4 +-
 8 files changed, 1115 insertions(+), 100 deletions(-)

-- 
tejun
