From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v5.15-rc1
Date: Tue, 31 Aug 2021 06:42:31 -1000
Message-ID: <YS5b98kN6updRd3u@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=rwAwM/f7xCIyGLgjKw6m0UR3ux/e/UzH0gwF7myxEvs=;
        b=RtiK3a37eisNqkkGWXt1I8MV2kdXnD1XVPVaVV6mupWtT3nOV6gHiuOQEAyEv/GOQN
         p42bXin7ZQM16TLp8lqEsd5zj4Di4GIeqRW7kL+/Q1G4tUFtxEw1knySBj+AmjeW9TaD
         GUSoTNudWD645aJPMJlSXRp2wFaLJckFB3c/S2N/05himiolQyj3NbrXRzi7Np+pA9rY
         S6KqzkWz1qu0m0FyBpQj61Hp+wMJAzJFDC4ziRPiNj4nh4TBW3j/d7vD/zPyp8wUcyLj
         Uw3sSHQCmxdq4nEqzoJDQpVVI2DBu1zXV39PZk/MrVwM2+djG/qk0/d2i00+81jeKiRq
         avew==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello, Linus.

Two cpuset behavior changes:

* cpuset on cgroup2 is changed to enable memory migration based on nodemask
  by default.

* A notification is generated when cpuset partition state changes.

All other patches are minor fixes and clenaups.

Thanks.

The following changes since commit d936eb23874433caa3e3d841cfa16f5434b85dcf:

  Revert "Makefile: Enable -Wimplicit-fallthrough for Clang" (2021-07-15 18:05:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.15

for you to fetch changes up to d20d30ebb199354729c64c86945ed25c66ff4991:

  cgroup: Avoid compiler warnings with no subsystems (2021-08-30 07:36:43 -1000)

----------------------------------------------------------------
Kees Cook (1):
      cgroup: Avoid compiler warnings with no subsystems

Nicolas Saenz Julienne (1):
      cgroup/cpuset: Avoid memory migration when nodemasks match

Randy Dunlap (1):
      cgroup: cgroup-v1: clean up kernel-doc notation

Sebastian Andrzej Siewior (1):
      cgroup: Replace deprecated CPU-hotplug functions.

Waiman Long (5):
      cgroup/cpuset: Miscellaneous code cleanup
      cgroup/cpuset: Fix a partition bug with hotplug
      cgroup/cpuset: Fix violation of cpuset locking rule
      cgroup/cpuset: Enable event notification when partition state changes
      cgroup/cpuset: Enable memory migration for cpuset v2

zhaoxiaoqiang11 (1):
      cgroup: remove cgroup_mount from comments

 Documentation/admin-guide/cgroup-v2.rst |  11 +++
 kernel/cgroup/cgroup-v1.c               |   8 +-
 kernel/cgroup/cgroup.c                  |  27 ++++--
 kernel/cgroup/cpuset.c                  | 162 +++++++++++++++++++++-----------
 4 files changed, 144 insertions(+), 64 deletions(-)

-- 
tejun
