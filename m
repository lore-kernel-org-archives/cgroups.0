From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.2-rc1
Date: Fri, 26 Jun 2015 11:56:39 -0400
Message-ID: <20150626155639.GG15805@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=J2EWZDrDFFoHRPDQY0efP6rRrZQ6WjcjjVBMCXQ8368=;
        b=rowdrUOSx9gwFWidHPlw+ADfOUqFSx8PHkTy2jzqeWP2W0QOMH1iiaKcWzmgEsDwN9
         Sy8oFI+VNv/GR8a17CKDq+vkEStdFGP6AwBipZu/Ihvd0mQrpk4/cSHF7Ugmf/pDbk2I
         CRyIcyt89D3JHYHEZ/lzEGYnLe0/IITtJCWHIIgMsWA4n2rI1Y4q7v/RvwaLuX4qclL+
         ZiT2mVsSEKjQ9NyyVipazQwuTjnt4+pkTDICw9O9e77ncKg1qW2DUPkuPbwQHMyj5h+q
         +EYKL+XseiKsh+4LXebzNTXWfAiRHRVAjrtKS/2vsDYpNmV0PPlIOiNeBJuNerznTJUC
         VJ2Q==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

* threadgroup_lock got reorganized so that its users can pick the
  actual locking mechanism to use.  Its only user - cgroups - is
  updated to use a percpu_rwsem instead of per-process rwsem.  This
  makes things a bit lighter on hot paths and allows cgroups to
  perform and fail multi-task (a process) migrations atomically.
  Multi-task migrations are used in several places including the
  unified hierarchy.

* Delegation rule and documentation added to unified hierarchy.  This
  will likely be the last interface update from the cgroup core side
  for unified hierarchy before lifting the devel mask.

* Some groundwork for the pids controller which is scheduled to be
  merged in the coming devel cycle.

Thanks.

The following changes since commit 27cf3a16b2535a490f8cf1d29a6634f1c70f7831:

  Merge branch 'upstream' of git://git.infradead.org/users/pcmoore/audit (2015-04-22 14:49:23 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.2

for you to fetch changes up to 8a0792ef8e01f03cb43806c6a87738bde34df713:

  cgroup: add delegation section to unified hierarchy documentation (2015-06-18 16:54:28 -0400)

----------------------------------------------------------------
Aleksa Sarai (4):
      cgroup: switch to unsigned long for bitmasks
      cgroup: use bitmask to filter for_each_subsys
      cgroup: replace explicit ss_mask checking with for_each_subsys_which
      cgroup: fix uninitialised iterator in for_each_subsys_which

Arnd Bergmann (1):
      cgroup: add seq_file forward declaration for struct cftype

Chen Hanxiao (1):
      cgroup: fix some comment typos

Tejun Heo (10):
      cgroup: separate out include/linux/cgroup-defs.h
      cgroup: reorganize include/linux/cgroup.h
      sched, cgroup: reorganize threadgroup locking
      sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem
      cgroup: simplify threadgroup locking
      MAINTAINERS: add a cgroup core co-maintainer
      kernfs: make kernfs_get_inode() public
      cgroup: separate out cgroup_procs_write_permission() from __cgroup_procs_write()
      cgroup: require write perm on common ancestor when moving processes on the default hierarchy
      cgroup: add delegation section to unified hierarchy documentation

 Documentation/cgroups/unified-hierarchy.txt |  102 ++-
 MAINTAINERS                                 |    1 +
 fs/kernfs/kernfs-internal.h                 |    1 -
 include/linux/cgroup-defs.h                 |  501 +++++++++++++
 include/linux/cgroup.h                      | 1051 ++++++++-------------------
 include/linux/init_task.h                   |    8 -
 include/linux/kernfs.h                      |    5 +
 include/linux/sched.h                       |   65 +-
 init/Kconfig                                |    1 +
 kernel/cgroup.c                             |  273 +++----
 kernel/fork.c                               |    4 -
 11 files changed, 1050 insertions(+), 962 deletions(-)
 create mode 100644 include/linux/cgroup-defs.h

-- 
tejun
