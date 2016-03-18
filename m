From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.6-rc1
Date: Fri, 18 Mar 2016 14:59:01 -0400
Message-ID: <20160318185901.GE20028@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=yhOanCdGAaHSZpaJOOm0oqcQTRX7njYPWgrvWEln8rs=;
        b=1IuF7c3NuiZZusw4n9Sa0qLt3yYGi1suCMi0LHsiPM8rsnJ3JK6qTp0r5MgyBq148q
         aOwZpeWflGVx7uGg5fWUQN1lt99V3JOdz6lSJ4wcw/RYwHx33KP1lmqKjc3au810YUJF
         MHDufvzfn/Bn0Bt1mGidViZPxEBTzaRjm0AE4PNJ0ifVkF3u1K/dD1QNis5PCksbYIoZ
         kwi0R+RsmvLPoMHHZRkcgG42HlYMk8nQdaU6jLKtyhcWLKNbrHbTSa69ujd05sD4nR09
         /+1PvMAiVe1grNsHL0bEk0oZ0DHLJu5N8mBuv7xPdzdtCsS3gzGI9DbtQ9d/HEHuDU6N
         LMkg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello, Linus.

cgroup changes for v4.6-rc1.  No userland visible behavior changes in
this pull request.  I'll send out a separate pull request for the
addition of cgroup namespace support.

* The biggest change is the revamping of cgroup core task migration
  and controller handling logic.  There are quite a few places where
  controllers and tasks are manipulated.  Previously, many of those
  places implemented custom operations for each specific use case
  assuming specific starting conditions.  While this worked, it makes
  the code fragile and difficult to follow.

  Bulk of this pull request restructures these operations so that most
  related operations are performed through common helpers which
  implement recursive (subtrees are always processed consistently) and
  idempotent (they make cgroup hierarchy converge to the target state
  rather than performing operations assuming specific starting
  conditions).  This makes the code a lot easier to understand, verify
  and extend.

* Implicit controller support is added.  This is primarily for using
  perf_event on the v2 hierarchy so that perf can match cgroup v2 path
  without requiring the user to do anything special.  The kernel
  portion of perf_event changes is acked but userland changes are
  still pending review.

* cgroup_no_v1= boot parameter added to ease testing cgroup v2 in
  certain environments.

* There is a regression introduced during v4.4 devel cycle where
  attempts to migrate zombie tasks can mess up internal object
  management.  This was fixed earlier this week and included in this
  pull request w/ stable cc'd.

* Misc non-critical fixes and improvements.

Thanks.

The following changes since commit 9a2ddda572a002633a64b1ae5f4bc49cfcbf495f:

  Documentation: cgroup: Fix 'cgroup-legacy' -> 'cgroup-v1' (2016-01-29 06:11:57 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.6

for you to fetch changes up to cfe02a8a973e7e5f66926b8ae38dfce404b19e29:

  cgroup: avoid false positive gcc-6 warning (2016-03-16 13:32:23 -0700)

----------------------------------------------------------------
Arnd Bergmann (1):
      cgroup: avoid false positive gcc-6 warning

Haosdent Huang (1):
      cgroup: remove stale item in cgroup-v1 document INDEX file.

Johannes Weiner (2):
      cgroup: provide cgroup_nov1= to disable controllers in v1 mounts
      cgroup: document cgroup_no_v1=

Li Bin (1):
      kernel/Makefile: remove the useless CFLAGS_REMOVE_cgroup-debug.o

Parav Pandit (2):
      cgroup: Trivial correction to reflect controller.
      Documentation: cgroup v2: Trivial heading correction.

Tejun Heo (35):
      cgroup: fix error return value of cgroup_addrm_files()
      Revert "cgroup: add cgroup_subsys->css_e_css_changed()"
      cgroup: s/child_subsys_mask/subtree_ss_mask/
      cgroup: convert for_each_subsys_which() to do-while style
      cgroup: use do_each_subsys_mask() where applicable
      cgroup: make cgroup subsystem masks u16
      cgroup: s/cgrp_dfl_root_/cgrp_dfl_/
      cgroup: convert cgroup_subsys flag fields to bool bitfields
      cgroup: make css_tryget_online_from_dir() also recognize cgroup2 fs
      cgroup: use ->subtree_control when testing no internal process rule
      cgroup: re-hash init_css_set after subsystems are initialized
      cgroup: suppress spurious de-populated events
      cgroup: separate out interface file creation from css creation
      cgroup: explicitly track whether a cgroup_subsys_state is visible to userland
      cgroup: reorder operations in cgroup_mkdir()
      cgroup: factor out cgroup_create() out of cgroup_mkdir()
      cgroup: introduce cgroup_control() and cgroup_ss_mask()
      cgroup: factor out cgroup_drain_offline() from cgroup_subtree_control_write()
      cgroup: factor out cgroup_apply_control_disable() from cgroup_subtree_control_write()
      cgroup: factor out cgroup_apply_control_enable() from cgroup_subtree_control_write()
      cgroup: make cgroup_drain_offline() and cgroup_apply_control_{disable|enable}() recursive
      cgroup: introduce cgroup_{save|propagate|restore}_control()
      cgroup: factor out cgroup_{apply|finalize}_control() from cgroup_subtree_control_write()
      cgroup: combine cgroup_mutex locking and offline css draining
      cgroup: use cgroup_apply_enable_control() in cgroup creation path
      cgroup: reimplement rebind_subsystems() using cgroup_apply_control() and friends
      cgroup: make cgroup_calc_subtree_ss_mask() take @this_ss_mask
      cgroup: allocate 2x cgrp_cset_links when setting up a new root
      cgroup: update css iteration in cgroup_update_dfl_csses()
      cgroup: fix incorrect destination cgroup in cgroup_update_dfl_csses()
      cgroup: move migration destination verification out of cgroup_migrate_prepare_dst()
      cgroup: make cgroup[_taskset]_migrate() take cgroup_root instead of cgroup
      cgroup: use css_set->mg_dst_cgrp for the migration target cgroup
      cgroup: implement cgroup_subsys->implicit_on_dfl
      cgroup: ignore css_sets associated with dead cgroups during migration

Vladimir Davydov (1):
      cgroup: reset css on destruction

Xiubo Li (1):
      cgroup: fix a mistake in warning message

 Documentation/cgroup-v1/00-INDEX    |    2 -
 Documentation/cgroup-v2.txt         |    8 +-
 Documentation/kernel-parameters.txt |    5 +
 include/linux/cgroup-defs.h         |   46 +-
 init/Kconfig                        |    4 +-
 kernel/Makefile                     |    3 +-
 kernel/cgroup.c                     | 1168 +++++++++++++++++++++--------------
 kernel/cpuset.c                     |    2 +-
 kernel/sched/core.c                 |    2 +-
 kernel/sched/cpuacct.c              |    2 +-
 10 files changed, 738 insertions(+), 504 deletions(-)

-- 
tejun
