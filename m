From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v5.1-rc1
Date: Wed, 6 Mar 2019 10:41:53 -0800
Message-ID: <20190306184153.GI50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=wWCXir4r1pXpp0Hmlieqg9dse5cFF3K/PCHaVFhMfhQ=;
        b=tRFLglF0sRpWn57v0VTg/oj/p1a+1b2gTkJcO76E9XuUyIu1KSElPmoDfq+o5uo+2Z
         HEKfjhTMkBEO7AY14hcLp8M12DnSF8HP7LTWLOALgLYKoAAXoerB0IjirLdFxWxnZwPN
         GkExV8yLjuT3HwlLs1nuJfdJU1C0Vu4MvtHk+tch5PtjVkTteupp3cH5HAO4uCePDy7w
         EggH+bUSFlHd8dRaG9jdViZhR26eqj43gQ5A+zTOG3aD0XiHn+LJgf8XG6oJ/ZzwMJvw
         K4t36jIyNtk6PQDigVaWwf2Xog3PENqkgB31LsJEbqiZVcyafHnAPzay4aKM/8Xvkl/h
         MZyw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Linus.

* Oleg's pids controller accounting update which gets rid of rcu delay
  in pids accounting updates.

* rstat (cgroup hierarchical stat collection mechanism) optimization.

* Doc updates.

Thanks.

The following changes since commit af0c9af1b3f66052c369d08be3f60fa9a9559e48:

  fs/dcache: Track & report number of negative dentries (2019-01-30 11:02:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.1

for you to fetch changes up to 6a613d24effcb875271b8a1c510172e2d6eaaee8:

  cpuset: remove unused task_has_mempolicy() (2019-02-19 06:26:02 -0800)

----------------------------------------------------------------
Andrea Parri (1):
      MAINTAINERS: Update cgroup entry

Masahiro Yamada (1):
      cpuset: remove unused task_has_mempolicy()

Oleg Nesterov (1):
      cgroup/pids: turn cgroup_subsys->free() into cgroup_subsys->release() to fix the accounting

Randy Dunlap (1):
      Documentation: cgroup-v2: eliminate markup warnings

Tejun Heo (1):
      cgroup, rstat: Don't flush subtree root unless necessary

Tibor Billes (1):
      cgroup: add documentation for pids.events file

 Documentation/admin-guide/cgroup-v2.rst |  2 +-
 Documentation/cgroup-v1/pids.txt        |  3 +++
 MAINTAINERS                             |  5 +++--
 include/linux/cgroup-defs.h             |  2 +-
 include/linux/cgroup.h                  |  2 ++
 kernel/cgroup/cgroup.c                  | 15 +++++++++------
 kernel/cgroup/cpuset.c                  | 13 -------------
 kernel/cgroup/pids.c                    |  4 ++--
 kernel/cgroup/rstat.c                   | 10 ++++++----
 kernel/exit.c                           |  1 +
 10 files changed, 28 insertions(+), 29 deletions(-)

-- 
tejun
