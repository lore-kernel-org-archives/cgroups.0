From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v3.18-rc1
Date: Wed, 8 Oct 2014 11:10:58 -0400
Message-ID: <20141008151058.GC8184@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=Qoy+munP7uJfGKy4R2kTn48ZC4gNnKTUZanyXS7cBzs=;
        b=iAfvbbIoAhsbLvaH2GkF0utshWKeQuIsPNCmagFuL1Ubq48P3at0f3N9t2igARralo
         BpzUCLpW8o0qmN77S0pyDAK78qIHv7/meokfoR8L2qdqo2VvfB5UT+Z/8d8i8ZGY3Q2p
         9WXC5TkIlCm+X9X0y2fjbicG0u74/Qnk1zAjelF7f7RM6AkQcYu/vhBdTlIm9tPHUrZZ
         QQEL1NmWRvMhlUvPkstGOf3K6FEbv04PX3cHhaF7JvY/Zf5Xyfhu6l9B1aLOBhTFPk1O
         Ux4/pLwl/ed7q+LZCJrw0jiULxBGHW7ybug66OJHU9zxuxFqm9qLrpLlNrVMnGQaGrqA
         1n+g==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

Hello, Linus.

Nothing too interesting.  Just a handful of cleanup patches.  The pull
of for-3.17-fixes was to put follow-up cleanups on top of a fix patch.

Thanks.

The following changes since commit aa32362f011c6e863132b16c1761487166a4bad2:

  cgroup: check cgroup liveliness before unbreaking kernfs (2014-09-05 01:36:19 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.18

for you to fetch changes up to e756c7b698604f11a979f2781d06eb7b80aba363:

  Revert "cgroup: remove redundant variable in cgroup_mount()" (2014-09-26 00:16:23 -0400)

----------------------------------------------------------------
Dongsheng Yang (1):
      cgroup: fix a typo in comment.

Li Zefan (3):
      cgroup: remove some useless forward declarations
      cgroup: remove redundant code in cgroup_rmdir()
      cgroup: remove bogus comments

Tejun Heo (1):
      Merge branch 'for-3.17-fixes' of ra.kernel.org:/.../tj/cgroup into for-3.18

Zefan Li (9):
      cgroup: use a per-cgroup work for release agent
      cgroup: simplify proc_cgroup_show()
      cpuset: simplify proc_cpuset_show()
      cgroup: remove redundant check in cgroup_ino()
      perf/cgroup: Remove perf_put_cgroup()
      cgroup: remove CGRP_RELEASABLE flag
      cgroup: fix missing unlock in cgroup_release_agent()
      cgroup: remove redundant variable in cgroup_mount()
      Revert "cgroup: remove redundant variable in cgroup_mount()"

 fs/proc/base.c         |  39 ++---------
 include/linux/cgroup.h |  26 ++-----
 include/linux/cpuset.h |   3 +-
 kernel/cgroup.c        | 184 ++++++++++++++-----------------------------------
 kernel/cpuset.c        |  15 +---
 kernel/events/core.c   |   7 +-
 mm/memory-failure.c    |   2 +-
 7 files changed, 71 insertions(+), 205 deletions(-)

-- 
tejun
