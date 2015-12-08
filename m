From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.4-rc4
Date: Tue, 8 Dec 2015 11:50:53 -0500
Message-ID: <20151208165053.GG30240@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=SFrCW69ZkYuzoFJFl/SW8PsK5TdL5HUJmRM7POQxEI0=;
        b=zco3TsrlOqb4PQfPwaJm35HmsfrRDFX/n1Iz92ZmqPk59gTY1Srhni16i+7PUd173K
         oqkHAi6gPOz3qcDE61UhyHpT+C1MlDeXzQAuicC3K1YjMcfBWMhWv8XKo007nYlP+ZFp
         DLRvwB9Rf0oDsfaFLdDIv3i6Z7GEx5KfAfRzaspLc+UPv1BaQXO+swsd1f72azfljAWe
         NISD7w7giDFkHBTV40KQXE90V6M5xjbMfDBvuoZvuW4E0DV87T8EkebcO9DDXO9gzpD/
         fv8xJWVdyygpcKTqOMig2m8ej56UDyhhOYR4cGKQywfESq5tiMpOe6aph0VFWmrRCZYy
         NCGQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Linus.

More change than I'd have liked at this stage.  The pids controller
and the changes made to cgroup core to support it introduced and
revealed several important issues.

* Assigning membership to a newly created task and migrating it can
  race leading to incorrect accounting.  Oleg fixed it by widening
  threadgroup synchronization.  It looks like we'll be able to merge
  it with a different percpu rwsem which is used in fork path making
  things simpler and cheaper.

* The recent change to extend cgroup membership to zombies (so that
  pid accounting can extend till the pid is actually released) missed
  pinning the underlying data structures leading to use-after-free.
  Fixed.

* v2 hierarchy was calling subsystem callbacks with the wrong target
  cgroup_subsys_state based on the incorrect assumption that they
  share the same target.  pids is the first controller affected by
  this.  Subsys callbacks updated so that they can deal with
  multi-target migrations.

Thanks.

The following changes since commit 527e9316f8ec44bd53d90fb9f611fa7ffff52bb9:

  Linux 4.4-rc4 (2015-12-06 15:43:12 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.4-fixes

for you to fetch changes up to 0b98f0c04245877ae0b625a7f0aa55b8ff98e0c4:

  Merge branch 'master' into for-4.4-fixes (2015-12-07 10:09:03 -0500)

----------------------------------------------------------------
Oleg Nesterov (2):
      cgroup: pids: fix race between cgroup_post_fork() and cgroup_migrate()
      cgroup: pids: kill pids_fork(), simplify pids_can_fork() and pids_cancel_fork()

Tejun Heo (6):
      cgroup: fix cftype->file_offset handling
      cgroup: make css_set pin its css's to avoid use-afer-free
      cgroup_freezer: simplify propagation of CGROUP_FROZEN clearing in freezer_attach()
      cgroup: fix handling of multi-destination migration from subtree_control enabling
      cgroup_pids: don't account for the root cgroup
      Merge branch 'master' into for-4.4-fixes

 block/blk-cgroup.c           |  6 +--
 include/linux/cgroup-defs.h  | 13 ++----
 include/linux/cgroup.h       | 47 ++++++++++-----------
 kernel/cgroup.c              | 99 ++++++++++++++++++++++++++++++++++----------
 kernel/cgroup_freezer.c      | 23 +++++-----
 kernel/cgroup_pids.c         | 77 +++++++++-------------------------
 kernel/cpuset.c              | 33 +++++++++------
 kernel/events/core.c         |  6 +--
 kernel/fork.c                |  9 ++--
 kernel/sched/core.c          | 12 +++---
 mm/memcontrol.c              | 45 ++++++++++----------
 net/core/netclassid_cgroup.c |  6 ++-
 net/core/netprio_cgroup.c    |  9 ++--
 13 files changed, 202 insertions(+), 183 deletions(-)

-- 
tejun
