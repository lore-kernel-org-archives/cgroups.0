From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v3.16-rc1
Date: Mon, 9 Jun 2014 14:25:51 -0400
Message-ID: <20140609182551.GE22540@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=uz8gMBmDacZJFUQC7ke9Xr8bdYpMEcAT+YSVfkO7n+g=;
        b=GpeOOvD+Jmnd4bwe4gjnZXiMHssxmV1lbDzJYtosIZGePiFilkzwMuza/oU9FC09xC
         JbbrqeVDDGEjQ0hVO+r+b8kKGSM6yebbUJNdtRBmU43XpwczveYrT62Ss9K0aAcEfT4e
         /wtnE9HII7TlEN729yMlenrmfAqwDoi549thrbaQlMplbgbv8v2l6G8K71t+WMxsjvFJ
         bIsCloJ72e4JUGV0QlL52B4FxDElj/IvBiXDrj4p8wdjEfoCF0e4rX7k3+7FcroKESaB
         YOBfwhX2p8kZpx4UuDQreI8IkFu2u0CEnieNjnUqLcAJMD+jBPfI4csJvmALzOfddxZf
         Nrpg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Hello, Linus.

A lot of activities on cgroup side.  Heavy restructuring including
locking simplification took place to improve the code base and enable
implementation of the unified hierarchy, which currently exists behind
a __DEVEL__ mount option.  The core support is mostly complete but
individual controllers need further work.  To explain the design and
rationales of the the unified hierarchy
Documentation/cgroups/unified-hierarchy.txt is added.

Another notable change is css (cgroup_subsys_state - what each
controller uses to identify and interact with a cgroup) iteration
update.  This is part of continuing updates on css object lifetime and
visibility.  cgroup started with reference count draining on removal
way back and is now reaching a point where csses behave and are
iterated like normal refcnted objects albeit with some complexities to
allow distinguishing the state where they're being deleted.  The css
iteration update isn't taken advantage of yet but is planned to be
used to simplify memcg significantly.

During the devel cycle, cgroup for-3.16 branch pulled in
driver-core-next and percpu/for-3.16 to receive the necessary kernfs
and percpu_ref updates, respectively.  As such, it'd be probably best
to merge those two branches before cgroup/for-3.16.

Pulling cgroup/for-3.16 into the current master 963649d735c8 ("Merge
tag 'for-linus-3.16-merge-window' of
git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs") causes
four conflicts.  The conflicts are caused by the following two commits
in cgroup/for-3.16.

  ec903c0c858e ("cgroup: rename css_tryget*() to css_tryget_online*()")
  5c9d535b893f ("cgroup: remove css_parent()")

Both, in themselves, are trivial.  The former renames css_tryget() to
css_tryget_online() to clarify that the function is special in that it
cares about whether the css is online or not and make room for the
normal tryget.  The latter removes css_parent() which was added as a
temporary wrapper while transitioning from cgroup to css as the
primary construct of hierarchical structure that controllers see.

All four conflicts can be resolved by taking the code from master side
and then making the appropriate substitutions performed by the above
two commits - css_tryget() to css_tryget_online() and css_parent(css)
to css->parent.

1. With 6f6acb00514c ("memcg: fix swapcache charge from kernel thread context")

CONFLICT 1

  static struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
  {
	  struct mem_cgroup *memcg = NULL;

	  rcu_read_lock();
	  do {
		  /*
		   * Page cache insertions can happen withou an
		   * actual mm context, e.g. during disk probing
		   * on boot, loopback IO, acct() writes etc.
		   */
		  if (unlikely(!mm))
			  memcg = root_mem_cgroup;
  <<<<<<< HEAD
		  else {
			  memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
			  if (unlikely(!memcg))
				  memcg = root_mem_cgroup;
		  }
	  } while (!css_tryget(&memcg->css));
  =======
	  } while (!css_tryget_online(&memcg->css));
  >>>>>>> c731ae1d0f02a300697a8b1564780ad28a6c2013
	  rcu_read_unlock();
	  return memcg;
  }

RESOLUTION 1

  static struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
  {
	  struct mem_cgroup *memcg = NULL;

	  rcu_read_lock();
	  do {
		  /*
		   * Page cache insertions can happen withou an
		   * actual mm context, e.g. during disk probing
		   * on boot, loopback IO, acct() writes etc.
		   */
		  if (unlikely(!mm))
			  memcg = root_mem_cgroup;
		  else {
			  memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
			  if (unlikely(!memcg))
				  memcg = root_mem_cgroup;
		  }
	  } while (!css_tryget_online(&memcg->css));
	  rcu_read_unlock();
	  return memcg;
  }


2. With 688eb988d15a ("vmscan: memcg: always use swappiness of the reclaimed memcg")

CONFLICT 2

  int mem_cgroup_swappiness(struct mem_cgroup *memcg)
  {
	  /* root ? */
  <<<<<<< HEAD
	  if (mem_cgroup_disabled() || !css_parent(&memcg->css))
  =======
	  if (!memcg->css.parent)
  >>>>>>> c731ae1d0f02a300697a8b1564780ad28a6c2013
		  return vm_swappiness;

	  return memcg->swappiness;
  }

RESOLUTION 2

  int mem_cgroup_swappiness(struct mem_cgroup *memcg)
  {
	  /* root ? */
	  if (mem_cgroup_disabled() || !memcg->css.parent)
		  return vm_swappiness;

	  return memcg->swappiness;
  }


3-4. With 3dae7fec5e88 ("mm: memcontrol: remove hierarchy restrictions for swappiness and oom_control")

CONFLICT 3

  static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
					 struct cftype *cft, u64 val)
  {
	  struct mem_cgroup *memcg = mem_cgroup_from_css(css);
  <<<<<<< HEAD
  =======
	  struct mem_cgroup *parent = mem_cgroup_from_css(memcg->css.parent);

	  if (val > 100 || !parent)
		  return -EINVAL;
  >>>>>>> c731ae1d0f02a300697a8b1564780ad28a6c2013

	  if (val > 100)
		  return -EINVAL;

	  if (css_parent(css))
		  memcg->swappiness = val;
	  else
		  vm_swappiness = val;

	  return 0;
  }

RESOLUTION 3

  static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
					 struct cftype *cft, u64 val)
  {
	  struct mem_cgroup *memcg = mem_cgroup_from_css(css);

	  if (val > 100)
		  return -EINVAL;

	  if (css->parent)
		  memcg->swappiness = val;
	  else
		  vm_swappiness = val;

	  return 0;
  }

CONFLICT 4

  static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
	  struct cftype *cft, u64 val)
  {
	  struct mem_cgroup *memcg = mem_cgroup_from_css(css);
  <<<<<<< HEAD
  =======
	  struct mem_cgroup *parent = mem_cgroup_from_css(memcg->css.parent);
  >>>>>>> c731ae1d0f02a300697a8b1564780ad28a6c2013

	  /* cannot set to root cgroup and only 0 and 1 are allowed */
	  if (!css_parent(css) || !((val == 0) || (val == 1)))
		  return -EINVAL;

	  memcg->oom_kill_disable = val;
	  if (!val)
		  memcg_oom_recover(memcg);

	  return 0;
  }

RESOLUTION 4

  static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
	  struct cftype *cft, u64 val)
  {
	  struct mem_cgroup *memcg = mem_cgroup_from_css(css);

	  /* cannot set to root cgroup and only 0 and 1 are allowed */
	  if (!css->parent || !((val == 0) || (val == 1)))
		  return -EINVAL;

	  memcg->oom_kill_disable = val;
	  if (!val)
		  memcg_oom_recover(memcg);

	  return 0;
  }

Just in case, the merged result is available in the following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge-for-3.16

Thanks.

The following changes since commit 36e9d2ebcc15d029b33f42a36146ab5a5bcfcfe7:

  cgroup: fix rcu_read_lock() leak in update_if_frozen() (2014-05-13 11:28:30 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.16

for you to fetch changes up to c731ae1d0f02a300697a8b1564780ad28a6c2013:

  cgroup: disallow disabled controllers on the default hierarchy (2014-06-05 09:52:51 -0400)

----------------------------------------------------------------
Christoph Lameter (1):
      percpu: Replace __get_cpu_var with this_cpu_ptr

Fabian Frederick (3):
      kernel/cgroup.c: fix 2 kernel-doc warnings
      kernel/cpuset.c: kernel-doc fixes
      kernel/cpuset.c: convert printk to pr_foo()

Jianyu Zhan (3):
      cgroup: clean up obsolete comment for parse_cgroupfs_options()
      cgroup: remove orphaned cgroup_pidlist_seq_operations
      cgroup: replace pr_warning with preferred pr_warn

Joe Perches (1):
      cgroup: Use more current logging style

Li Zefan (2):
      cgroup: don't destroy the default root
      cgroup: disallow disabled controllers on the default hierarchy

Michal Hocko (1):
      memcg: remove tasks/children test from mem_cgroup_force_empty()

Tejun Heo (72):
      cgroup: cgroup_apply_cftypes() shouldn't skip the default hierarhcy
      cgroup: update cgroup->subsys_mask to ->child_subsys_mask and restore cgroup_root->subsys_mask
      cgroup: introduce effective cgroup_subsys_state
      cgroup: implement cgroup->e_csets[]
      cgroup: make css_next_child() skip missing csses
      cgroup: reorganize css_task_iter
      cgroup: teach css_task_iter about effective csses
      cgroup: cgroup->subsys[] should be cleared after the css is offlined
      cgroup: allow cgroup creation and suppress automatic css creation in the unified hierarchy
      cgroup: add css_set->dfl_cgrp
      cgroup: update subsystem rebind restrictions
      cgroup: prepare migration path for unified hierarchy
      cgroup: implement dynamic subtree controller enable/disable on the default hierarchy
      Merge branch 'driver-core-next' of git://git.kernel.org/.../gregkh/driver-core into for-3.16
      cgroup: implement cgroup.populated for the default hierarchy
      cgroup: add documentation about unified hierarchy
      cgroup: make flags and subsys_masks unsigned int
      cgroup, memcg: allocate cgroup ID from 1
      cgroup: protect cgroup_root->cgroup_idr with a spinlock
      cgroup: use RCU free in create_css() failure path
      cgroup: update init_css() into init_and_link_css()
      cgroup, memcg: implement css->id and convert css_from_id() to use it
      cgroup: remove unused CGRP_SANE_BEHAVIOR
      percpu-refcount: rename percpu_ref_tryget() to percpu_ref_tryget_live()
      percpu-refcount: implement percpu_ref_tryget()
      Merge branch 'for-3.16' of git://git.kernel.org/.../tj/percpu into for-3.16
      Merge branch 'for-3.15-fixes' of git://git.kernel.org/.../tj/cgroup into for-3.16
      cgroup: fix offlining child waiting in cgroup_subtree_control_write()
      cgroup: cgroup_idr_lock should be bh
      cgroup: css_release() shouldn't clear cgroup->subsys[]
      cgroup: update and fix parsing of "cgroup.subtree_control"
      cgroup: use restart_syscall() for retries after offline waits in cgroup_subtree_control_write()
      cgroup: use release_agent_path_lock in cgroup_release_agent_show()
      cgroup: rename css_tryget*() to css_tryget_online*()
      cgroup: implement cftype->write()
      cgroup: replace cftype->write_string() with cftype->write()
      cgroup: replace cftype->trigger() with cftype->write()
      cgroup: convert "tasks" and "cgroup.procs" handle to use cftype->write()
      cgroup: remove cgroup->control_kn
      cgroup: reorganize cgroup_create()
      cgroup: collapse cgroup_create() into croup_mkdir()
      cgroup: grab cgroup_mutex earlier in cgroup_subtree_control_write()
      cgroup: move cgroup->kn->priv clearing to cgroup_rmdir()
      cgroup: factor out cgroup_kn_lock_live() and cgroup_kn_unlock()
      cgroup: use cgroup_kn_lock_live() in other cgroup kernfs methods
      cgroup: nest kernfs active protection under cgroup_mutex
      cgroup: remove cgroup_tree_mutex
      cgroup: use restart_syscall() for mount retries
      cgroup: rename cgroup->dummy_css to ->self and move it to the top
      cgroup: separate out cgroup_has_live_children() from cgroup_destroy_locked()
      cgroup: move check_for_release(parent) call to the end of cgroup_destroy_locked()
      cgroup: move cgroup->sibling unlinking to cgroup_put()
      cgroup: remove cgroup_destory_css_killed()
      cgroup: bounce css release through css->destroy_work
      cgroup: enable refcnting for root csses
      cgroup: use cgroup->self.refcnt for cgroup refcnting
      cgroup: skip refcnting on normal root csses and cgrp_dfl_root self css
      cgroup: remove css_parent()
      memcg: update memcg_has_children() to use css_next_child()
      device_cgroup: remove direct access to cgroup->children
      cgroup: remove cgroup->parent
      cgroup: move cgroup->sibling and ->children into cgroup_subsys_state
      cgroup: link all cgroup_subsys_states in their sibling lists
      cgroup: move cgroup->serial_nr into cgroup_subsys_state
      cgroup: introduce CSS_RELEASED and reduce css iteration fallback window
      cgroup: iterate cgroup_subsys_states directly
      cgroup: use CSS_ONLINE instead of CGRP_DEAD
      cgroup: convert cgroup_has_live_children() into css_has_online_children()
      device_cgroup: use css_has_online_children() instead of has_children()
      cgroup: implement css_tryget()
      cgroup: clean up MAINTAINERS entries
      cgroup: disallow debug controller on the default hierarchy

 Documentation/cgroups/memory.txt            |    6 
 Documentation/cgroups/unified-hierarchy.txt |  359 +++++
 MAINTAINERS                                 |   47 
 block/bio.c                                 |    2 
 block/blk-cgroup.c                          |    2 
 block/blk-cgroup.h                          |    2 
 block/blk-throttle.c                        |   32 
 block/cfq-iosched.c                         |   28 
 include/linux/cgroup.h                      |  272 ++--
 include/linux/cgroup_subsys.h               |   11 
 include/linux/percpu-refcount.h             |   34 
 include/linux/percpu.h                      |    2 
 kernel/cgroup.c                             | 1895 +++++++++++++++++-----------
 kernel/cgroup_freezer.c                     |   26 
 kernel/cpuset.c                             |   46 
 kernel/events/core.c                        |    3 
 kernel/sched/core.c                         |    2 
 kernel/sched/cpuacct.c                      |    2 
 mm/hugetlb_cgroup.c                         |   37 
 mm/memcontrol.c                             |  188 +-
 net/core/netclassid_cgroup.c                |    2 
 net/core/netprio_cgroup.c                   |   14 
 net/ipv4/tcp_memcontrol.c                   |   31 
 security/device_cgroup.c                    |   33 
 24 files changed, 2035 insertions(+), 1041 deletions(-)

-- 
tejun
