From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.20-rc1
Date: Mon, 1 Aug 2022 07:05:59 -1000
Message-ID: <YugH95n04DM6yRta@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc;
        bh=/GdX+TR/Dtbf4gZ83aEvjO8naUsD3U4cGz+frlvpnOI=;
        b=o49/EjuQpvSTcPsbZwuHWglxkwKdt473C3AZnhHy9r95Q0aLNcUJsXd7JMPC1RZLDB
         UThRymlZAgKSpv7WLErK8CBS11UOIaaKAUnZ32jfIfULDBS9ODMUNx7BZdTY2zF0Kmzm
         tE399kMtdOorrioGu8LSAJLHUPlcKNrtz1VDKC0nPSLULkKrGHCLoM5vO35C1eeED3Rw
         PeS8Ex5Xzfz1Quw2pmDzulr5CJ6vs8LucMdBAfQvwUwe9XE00Wohi+Dxm0W7VM60P3J5
         lsvT7HDn7Ow3XiGODf4hEGrNtCMGA6wqThEn+fli4G0eMV5qHv4obY0Gd1PVZBj2rjfo
         GQdg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

The following changes since commit e71e60cd74df9386c3f684c54888f2367050b831:

  Merge tag 'dma-mapping-5.19-2022-06-06' of git://git.infradead.org/users/hch/dma-mapping (2022-06-06 17:56:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-5.20

for you to fetch changes up to 265792d0dede9259f0ca56bb3efcc23eceee7d01:

  cgroup: Skip subtree root in cgroup_update_dfl_csses() (2022-07-28 07:26:30 -1000)

----------------------------------------------------------------
Several core optimizations:

* threadgroup_rwsem write locking is skipped when configuring controllers in
  empty subtrees. Combined with CLONE_INTO_CGROUP, this allows the common
  static usage pattern to not grab threadgroup_rwsem at all (glibc still
  doesn't seem ready for CLONE_INTO_CGROUP unfortunately).

* threadgroup_rwsem used to be put into non-percpu mode by default due to
  latency concerns in specific use cases. There's no reason for everyone
  else to pay for it. Make the behavior optional.

* psi no longer allocates memory when disabled.

along with some code cleanups.

----------------------------------------------------------------
Chen Wandun (1):
      psi: dont alloc memory for psi by default

Lin Feng (2):
      cgroup.c: add helper __cset_cgroup_from_root to cleanup duplicated codes
      cgroup.c: remove redundant check for mixable cgroup in cgroup_migrate_vet_dst

Tejun Heo (4):
      cgroup: Elide write-locking threadgroup_rwsem when updating csses on an empty subtree
      cgroup: Add "no" prefixed mount options
      cgroup: Make !percpu threadgroup_rwsem operations optional
      cgroup: remove "no" prefixed mount options

Waiman Long (1):
      cgroup: Skip subtree root in cgroup_update_dfl_csses()

 Documentation/admin-guide/cgroup-v2.rst |   8 ++
 include/linux/cgroup-defs.h             |  21 ++++-
 include/linux/cgroup.h                  |   2 +-
 init/Kconfig                            |  10 +++
 kernel/cgroup/cgroup-internal.h         |   1 +
 kernel/cgroup/cgroup-v1.c               |  17 +++-
 kernel/cgroup/cgroup.c                  | 136 ++++++++++++++++++++------------
 kernel/sched/psi.c                      |  19 +++--
 8 files changed, 151 insertions(+), 63 deletions(-)
