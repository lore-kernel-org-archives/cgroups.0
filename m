From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Tue, 13 Nov 2018 18:47:55 +0000
Message-ID: <20181113184751.GB21629@tower.DHCP.thefacebook.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com>
 <20181113020817.GE2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Lel8MKI8xhKqjJtieJLMC7F6nlut3cYi69ZtXKkHRPo=;
 b=ABQJcbpdogckOJ/O0gqyaSh7D0zlnZSb0bXS4jM0IyVYZ/ItCmXs3FGtbpSwq0MAX8St
 SYHsmFOJh1CsWD/BkaFYEIsa3MB+0tEMpQHLXXqEjq198hw0YLL0t4BjaHKRAr6glPsV
 JVzEIrob6ZB1M1pypg6RkVDm+4bj5OYSVRE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lel8MKI8xhKqjJtieJLMC7F6nlut3cYi69ZtXKkHRPo=;
 b=dkk/GGpO8BYnmHPJm9cf1cx0fT6ERDqligpqwOw2E4rEdXv6sleF9otnayWgQOBVGWqey41IY6+Sppa2DsdVntLmWJyfFrJRM4prnyPAP6bpoTA8b5w43KdlScnQS4KmoGQaFyU55j2/X5SUFpddFqgP6XEeIeQrcQM6GhJqqU8=
In-Reply-To: <20181113020817.GE2509588@devbig004.ftw2.facebook.com>
Content-Language: en-US
Content-ID: <7BD574971B796A4B9810A6D5276B8C7A@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guroan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>

On Mon, Nov 12, 2018 at 06:08:17PM -0800, Tejun Heo wrote:
> (cc'ing Linus, Andrew, Ingo for the addition of a new task state)
>=20
> Hello,
>=20
> On Mon, Nov 12, 2018 at 03:04:19PM -0800, Roman Gushchin wrote:
> > Cgroup v1 implements the freezer controller, which provides an ability
> > to stop the workload in a cgroup and temporarily free up some
> > resources (cpu, io, network bandwidth and, potentially, memory)
> > for some other tasks. Cgroup v2 lacks this functionality.
> >=20
> > This patch implements freezer for cgroup v2. However the functionality
> > is similar, the interface is different to cgroup v1: it follows
> > cgroup v2 interface principles.
> >=20
> > Key differences are:
> > 1) There is no separate controller: the functionality is always
> > available and is represented by cgroup.freeze and cgroup.events
> > cgroup control files.
> > 2) The desired state is defined by the cgroup.freeze control file.
> > Any hierarchical configuration is allowed.
> > 3) The interface is asynchronous. The actual state is available
> > using cgroup.events control file ("frozen" field). There are no
> > dedicated transitional states.
> > 4) It's allowed to make any changes with the cgroup hierarchy
> > (create new cgroups, remove old cgroups, move tasks between cgroups)
> > no matter if some cgroups are frozen.
> > 5) Tasks in a frozen cgroup can be killed.
>=20
> I think it'd be worthwhile to explain that tasks are now frozen in a
> state which is essentially equivalent to the job control stop state
> but which can only be controlled by the freezer and its interactions
> with ptrace.

Agreed.

>=20
> Oleg, I'd really appreciate if you can review the signal delivery /
> ptrace parts of the patch.
>=20
> > diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> > index 22254c1fe1c5..600165d0f5a2 100644
> > --- a/include/linux/cgroup-defs.h
> > +++ b/include/linux/cgroup-defs.h
> > @@ -63,6 +63,12 @@ enum {
> >  	 * specified at mount time and thus is implemented here.
> >  	 */
> >  	CGRP_CPUSET_CLONE_CHILDREN,
> > +
> > +	/* Control group has to be frozen. */
> > +	CGRP_FREEZE,
> > +
> > +	/* Cgroup is frozen. */
> > +	CGRP_FROZEN,
> >  };
> > =20
> >  /* cgroup_root->flags */
> > @@ -314,6 +320,27 @@ struct cgroup_rstat_cpu {
> >  	struct cgroup *updated_next;		/* NULL iff not on the list */
> >  };
> > =20
> > +struct cgroup_freezer_state {
> > +	/* Should the cgroup actually be frozen?
> > +	 * (protected by cgroup_mutex)
> > +	 */
> > +	int e_freeze;
> > +
> > +	/* Fields below are protected by css_set_lock */
> > +
> > +	/* Number of frozen descendant cgroups */
> > +	int nr_frozen_descendants;
> > +
> > +	/* Number of tasks to freeze */
> > +	int nr_tasks_to_freeze;
> > +
> > +	/* Number of frozen tasks */
> > +	int nr_frozen_tasks;
> > +
> > +	/* Used for delayed notifications */
> > +	struct work_struct notify_work;
> > +};
> > +
> >  struct cgroup {
> >  	/* self css with NULL ->ss, points back to this cgroup */
> >  	struct cgroup_subsys_state self;
> > @@ -442,6 +469,12 @@ struct cgroup {
> >  	/* If there is block congestion on this cgroup. */
> >  	atomic_t congestion_count;
> > =20
> > +	/* Should the cgroup and its descendants be frozen. */
> > +	bool freeze;
>=20
> Why not have this in freezer too?

I thought that this variable is just the state of the cgroup.freeze knob,
where the freezer field contains the internal state of the freezer, and
can in theory be allocated dynamically.

Not a strong preference, I can move it there too, if you prefer to.

>=20
> > +	/* Used to store internal freezer state */
> > +	struct cgroup_freezer_state freezer;
> > +
> >  	/* ids of the ancestors at each level including self */
> >  	int ancestor_ids[];
> >  };
> > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> > index 32c553556bbd..8f7e82b05bf8 100644
> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -871,4 +871,46 @@ static inline void put_cgroup_ns(struct cgroup_nam=
espace *ns)
> >  		free_cgroup_ns(ns);
> >  }
> > =20
> > +#ifdef CONFIG_CGROUPS
> > +
> > +static inline bool cgroup_frozen(struct task_struct *task)
> > +{
> > +	bool ret;
> > +
> > +	rcu_read_lock();
> > +	ret =3D test_bit(CGRP_FREEZE, &task_dfl_cgroup(task)->flags);
> > +	rcu_read_unlock();
> > +
> > +	return ret;
> > +}
> > +
> > +static inline bool cgroup_task_in_freezer(struct task_struct *task)
> > +{
> > +	return task->frozen;
> > +}
>=20
> I think the above are pretty confusing.  CGRP_FREEZE is frozen and
> task->frozen is cgroup_task_in_freezer()?  Can't they be e.g.
> cgroup_task_freeze() (or freezing, which probably is clearer) and
> cgroup_task_frozen()?

Yeah, looks good to me, will rename.

>=20
> > +void cgroup_freezer_enter(void);
> > +void cgroup_freezer_leave(void);
>=20
> So, if we use freeze, freezing, frozen instead, the aboves can be
> cgroup_frozen_enter() and cgroup_frozen_leave() (or begin/end).

Idk, maybe cgroup_enter_frozen()/cgroup_leave_frozen() ?

>=20
> > +void cgroup_freeze(struct cgroup *cgrp, bool freeze);
> > +void cgroup_notify_frozen_fn(struct work_struct *work);
>=20
> This doesn't need to be exported outside of cgroup proper, right?
>=20
> > +void cgroup_notify_frozen(struct cgroup *cgrp, bool frozen);
> > +void cgroup_queue_notify_frozen(struct cgroup *cgrp);
> > +void cgroup_freezer_migrate_task(struct task_struct *task, struct cgro=
up *src,
> > +				 struct cgroup *dst);
>=20
> Ditto.  Do these need to be exposed outside freezer or cgroup proper?

Yeah, makes sense, will remove.

>=20
> > +
> > +#else /* !CONFIG_CGROUPS */
> > +
> > +static inline bool cgroup_task_in_freezer(struct task_struct *task)
> > +{
> > +	return false;
> > +}
> > +static inline void cgroup_freezer_enter(void) { }
> > +static inline void cgroup_freezer_leave(void) { }
> > +static inline bool cgroup_frozen(struct task_struct *task)
> > +{
> > +	return false;
> > +}
> > +
> > +#endif /* !CONFIG_CGROUPS */
> > +
> >  #endif /* _LINUX_CGROUP_H */
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 977cb57d7bc9..8ef5d3174e50 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -83,7 +83,8 @@ struct task_group;
> >  #define TASK_WAKING			0x0200
> >  #define TASK_NOLOAD			0x0400
> >  #define TASK_NEW			0x0800
> > -#define TASK_STATE_MAX			0x1000
> > +#define TASK_FROZEN			0x1000
> > +#define TASK_STATE_MAX			0x2000
>=20
> We should also cc linux-api@vger.kernel.org as this is visible from
> userland, I think.

Ok.

>=20
> >  /* Convenience macros for the sake of set_current_state: */
> >  #define TASK_KILLABLE			(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
> > @@ -733,6 +734,8 @@ struct task_struct {
> >  #ifdef CONFIG_CGROUPS
> >  	/* disallow userland-initiated cgroup migration */
> >  	unsigned			no_cgroup_migration:1;
> > +	/* task is in the cgroup freezer loop */
>=20
> The above comment isn't strictly true, right?

Why so?

It actually means that the task is looping somewhere in the signal delivery=
 loop
after entering cgroup_freezer_enter() and before cgroup_freezer_leave().

Maybe simple "task is frozen by the cgroup freezer"?

>=20
> > +	unsigned			frozen:1;
> >  #endif
> >  #ifdef CONFIG_BLK_CGROUP
> >  	/* to be used once the psi infrastructure lands upstream. */
> > diff --git a/include/linux/sched/jobctl.h b/include/linux/sched/jobctl.=
h
> > index 98228bd48aee..6c49455dcfe6 100644
> > --- a/include/linux/sched/jobctl.h
> > +++ b/include/linux/sched/jobctl.h
> > @@ -18,6 +18,7 @@ struct task_struct;
> >  #define JOBCTL_TRAP_NOTIFY_BIT	20	/* trap for NOTIFY */
> >  #define JOBCTL_TRAPPING_BIT	21	/* switching to TRACED */
> >  #define JOBCTL_LISTENING_BIT	22	/* ptracer is listening for events */
> > +#define JOBCTL_TRAP_FREEZE_BIT	23	/* trap for cgroup freezer */
> > =20
> >  #define JOBCTL_STOP_DEQUEUED	(1UL << JOBCTL_STOP_DEQUEUED_BIT)
> >  #define JOBCTL_STOP_PENDING	(1UL << JOBCTL_STOP_PENDING_BIT)
> > @@ -26,8 +27,10 @@ struct task_struct;
> >  #define JOBCTL_TRAP_NOTIFY	(1UL << JOBCTL_TRAP_NOTIFY_BIT)
> >  #define JOBCTL_TRAPPING		(1UL << JOBCTL_TRAPPING_BIT)
> >  #define JOBCTL_LISTENING	(1UL << JOBCTL_LISTENING_BIT)
> > +#define JOBCTL_TRAP_FREEZE	(1UL << JOBCTL_TRAP_FREEZE_BIT)
> > =20
> > -#define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)
> > +#define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY | \
> > +				 JOBCTL_TRAP_FREEZE)
> >  #define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
> > =20
> >  extern bool task_set_jobctl_pending(struct task_struct *task, unsigned=
 long mask);
> > diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
> > index 8d5689ca94b9..5d7a76bfbbb7 100644
> > --- a/kernel/cgroup/Makefile
> > +++ b/kernel/cgroup/Makefile
> > @@ -1,5 +1,5 @@
> >  # SPDX-License-Identifier: GPL-2.0
> > -obj-y :=3D cgroup.o rstat.o namespace.o cgroup-v1.o
> > +obj-y :=3D cgroup.o rstat.o namespace.o cgroup-v1.o freezer.o
> > =20
> >  obj-$(CONFIG_CGROUP_FREEZER) +=3D legacy_freezer.o
> >  obj-$(CONFIG_CGROUP_PIDS) +=3D pids.o
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index ef3442555b32..4cffaae075af 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -2358,6 +2358,10 @@ static int cgroup_migrate_execute(struct cgroup_=
mgctx *mgctx)
> >  			css_set_move_task(task, from_cset, to_cset, true);
> >  			put_css_set_locked(from_cset);
> >  			from_cset->nr_tasks--;
> > +
> > +			cgroup_freezer_migrate_task(task,
> > +						    from_cset->dfl_cgrp,
> > +						    to_cset->dfl_cgrp);
> >  		}
> >  	}
> >  	spin_unlock_irq(&css_set_lock);
> > @@ -3401,8 +3405,11 @@ static ssize_t cgroup_max_depth_write(struct ker=
nfs_open_file *of,
> > =20
> >  static int cgroup_events_show(struct seq_file *seq, void *v)
> >  {
> > -	seq_printf(seq, "populated %d\n",
> > -		   cgroup_is_populated(seq_css(seq)->cgroup));
> > +	struct cgroup *cgrp =3D seq_css(seq)->cgroup;
> > +
> > +	seq_printf(seq, "populated %d\n", cgroup_is_populated(cgrp));
> > +	seq_printf(seq, "frozen %d\n", test_bit(CGRP_FROZEN, &cgrp->flags));
> > +
> >  	return 0;
> >  }
> > =20
> > @@ -3449,6 +3456,40 @@ static int cpu_stat_show(struct seq_file *seq, v=
oid *v)
> >  	return ret;
> >  }
> > =20
> > +static int cgroup_freeze_show(struct seq_file *seq, void *v)
> > +{
> > +	struct cgroup *cgrp =3D seq_css(seq)->cgroup;
> > +
> > +	seq_printf(seq, "%d\n", cgrp->freeze);
> > +
> > +	return 0;
> > +}
> > +
> > +static ssize_t cgroup_freeze_write(struct kernfs_open_file *of,
> > +				   char *buf, size_t nbytes, loff_t off)
> > +{
> > +	struct cgroup *cgrp;
> > +	ssize_t ret;
> > +	int freeze;
> > +
> > +	ret =3D kstrtoint(strstrip(buf), 0, &freeze);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (freeze < 0 || freeze > 1)
> > +		return -ERANGE;
> > +
> > +	cgrp =3D cgroup_kn_lock_live(of->kn, false);
> > +	if (!cgrp)
> > +		return -ENOENT;
> > +
> > +	cgroup_freeze(cgrp, freeze);
> > +
> > +	cgroup_kn_unlock(of->kn);
> > +
> > +	return nbytes;
> > +}
> > +
> >  static int cgroup_file_open(struct kernfs_open_file *of)
> >  {
> >  	struct cftype *cft =3D of->kn->priv;
> > @@ -4574,6 +4615,12 @@ static struct cftype cgroup_base_files[] =3D {
> >  		.name =3D "cgroup.stat",
> >  		.seq_show =3D cgroup_stat_show,
> >  	},
> > +	{
> > +		.name =3D "cgroup.freeze",
> > +		.flags =3D CFTYPE_NOT_ON_ROOT,
> > +		.seq_show =3D cgroup_freeze_show,
> > +		.write =3D cgroup_freeze_write,
> > +	},
> >  	{
> >  		.name =3D "cpu.stat",
> >  		.flags =3D CFTYPE_NOT_ON_ROOT,
> > @@ -4899,11 +4946,20 @@ static struct cgroup *cgroup_create(struct cgro=
up *parent)
> >  	if (ret)
> >  		goto out_idr_free;
> > =20
> > +	INIT_WORK(&cgrp->freezer.notify_work, cgroup_notify_frozen_fn);
> > +	cgrp->freezer.e_freeze =3D parent->freezer.e_freeze;
> > +	if (cgrp->freezer.e_freeze)
> > +		set_bit(CGRP_FROZEN, &cgrp->flags);
> > +
> >  	for (tcgrp =3D cgrp; tcgrp; tcgrp =3D cgroup_parent(tcgrp)) {
> >  		cgrp->ancestor_ids[tcgrp->level] =3D tcgrp->id;
> > =20
> > -		if (tcgrp !=3D cgrp)
> > +		if (tcgrp !=3D cgrp) {
> >  			tcgrp->nr_descendants++;
> > +
> > +			if (cgrp->freezer.e_freeze)
> > +				tcgrp->freezer.nr_frozen_descendants++;
> > +		}
> >  	}
> > =20
> >  	if (notify_on_release(parent))
> > @@ -5190,6 +5246,8 @@ static int cgroup_destroy_locked(struct cgroup *c=
grp)
> >  	for (tcgrp =3D cgroup_parent(cgrp); tcgrp; tcgrp =3D cgroup_parent(tc=
grp)) {
> >  		tcgrp->nr_descendants--;
> >  		tcgrp->nr_dying_descendants++;
> > +		if (cgrp->freezer.e_freeze)
> > +			tcgrp->freezer.nr_frozen_descendants--;
> >  	}
> > =20
> >  	cgroup1_check_for_release(parent);
> > @@ -5642,6 +5700,23 @@ void cgroup_post_fork(struct task_struct *child)
> >  			cset->nr_tasks++;
> >  			css_set_move_task(child, NULL, cset, false);
> >  		}
> > +
> > +		if (unlikely(cgroup_frozen(child) &&
> > +			     (child->flags & ~PF_KTHREAD))) {
>=20
> I don't think we need explicit PF_KTHREAD test here.  We don't allow
> kthreads in non-root cgroups anyway and if we wanna change that there
> are a bunch of other things which need updating anyway.

Don't we? I think we do. I've proposed a patch to fix this some time ago
(https://lkml.org/lkml/2017/10/12/556), but was NAKed by Peter.

>=20
> > +			struct cgroup *cgrp;
> > +			unsigned long flags;
> > +
> > +			if (lock_task_sighand(child, &flags)) {
> > +				cgrp =3D cset->dfl_cgrp;
> > +				cgrp->freezer.nr_tasks_to_freeze++;
> > +				WARN_ON_ONCE(cgrp->freezer.nr_tasks_to_freeze <
> > +					     cgrp->freezer.nr_frozen_tasks);
> > +				child->jobctl |=3D JOBCTL_TRAP_FREEZE;
> > +				signal_wake_up(child, false);
> > +				unlock_task_sighand(child, &flags);
> > +			}
> > +		}
> > +
> >  		spin_unlock_irq(&css_set_lock);
> >  	}
> > =20
> > @@ -5690,6 +5765,24 @@ void cgroup_exit(struct task_struct *tsk)
> >  		spin_lock_irq(&css_set_lock);
> >  		css_set_move_task(tsk, cset, NULL, false);
> >  		cset->nr_tasks--;
> > +
> > +		if (unlikely(cgroup_frozen(tsk) &&
> > +			     (tsk->flags & ~PF_KTHREAD))) {
>=20
> Ditto.
>=20
> > +			struct cgroup *frozen_cgrp =3D cset->dfl_cgrp;
> > +
> > +			frozen_cgrp->freezer.nr_tasks_to_freeze--;
> > +
> > +			WARN_ON(tsk->frozen);
>=20
> Why not WARN_ON_ONCE here too?

My bad, will fix.

>=20
> > +			WARN_ON_ONCE(frozen_cgrp->freezer.nr_tasks_to_freeze <
> > +				     0);
> > +			WARN_ON_ONCE(frozen_cgrp->freezer.nr_tasks_to_freeze <
> > +				     frozen_cgrp->freezer.nr_frozen_tasks);
> > +
> > +			if (frozen_cgrp->freezer.nr_frozen_tasks =3D=3D
> > +			    frozen_cgrp->freezer.nr_tasks_to_freeze)
> > +				cgroup_queue_notify_frozen(frozen_cgrp);
> > +		}
> > +
> >  		spin_unlock_irq(&css_set_lock);
> >  	} else {
> >  		get_css_set(cset);
> > diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
> > new file mode 100644
> > index 000000000000..b81e215e2cce
> > --- /dev/null
> > +++ b/kernel/cgroup/freezer.c
> > @@ -0,0 +1,247 @@
> > +//SPDX-License-Identifier: GPL-2.0
> > +#include <linux/cgroup.h>
> > +#include <linux/sched.h>
> > +#include <linux/sched/task.h>
> > +#include <linux/sched/signal.h>
> > +
> > +#include "cgroup-internal.h"
> > +
> > +void cgroup_notify_frozen(struct cgroup *cgrp, bool frozen)
> > +{
> > +	int delta =3D 1;
> > +
> > +	lockdep_assert_held(&cgroup_mutex);
> > +
> > +	/*
> > +	 * Did we race with fork() or exit()? Np, everything is still frozen.
> > +	 */
> > +	if (frozen =3D=3D test_bit(CGRP_FROZEN, &cgrp->flags))
> > +		return;
> > +
> > +	if (frozen)
> > +		set_bit(CGRP_FROZEN, &cgrp->flags);
> > +	else
> > +		clear_bit(CGRP_FROZEN, &cgrp->flags);
>=20
> I'm not sure this is wrong but it feels a bit weird to tie the actual
> state transition to notification.  Wouldn't it be more
> straight-forward if CGRP_FROZEN bit is purely determined by whether
> the tasks are frozen or not and the notification just checks that
> against the last notified state and generate a notification if they're
> different?

So, maybe cgroup_notify_frozen() is not the best name, maybe
cgroup_propagate_frozen() better reflects what's happening here.
We need to recalc the state of ancestor cgroups, and we have to do it
with cgroup_mutex held, this is why we do it from the delayed work
context (on hot paths).

The first pat of the function can be probably separated and called
immediately. Is this what you're suggesting?

>=20
> > +	cgroup_file_notify(&cgrp->events_file);
> > +
> > +	while ((cgrp =3D cgroup_parent(cgrp))) {
> > +		if (frozen) {
> > +			cgrp->freezer.nr_frozen_descendants +=3D delta;
> > +			if (!test_bit(CGRP_FROZEN, &cgrp->flags) &&
> > +			    test_bit(CGRP_FREEZE, &cgrp->flags) &&
> > +			    cgrp->freezer.nr_frozen_descendants =3D=3D
> > +			    cgrp->nr_descendants) {
> > +				set_bit(CGRP_FROZEN, &cgrp->flags);
> > +				cgroup_file_notify(&cgrp->events_file);
> > +				delta++;
> > +			}
> > +		} else {
> > +			cgrp->freezer.nr_frozen_descendants -=3D delta;
> > +			if (test_bit(CGRP_FROZEN, &cgrp->flags)) {
> > +				clear_bit(CGRP_FROZEN, &cgrp->flags);
> > +				cgroup_file_notify(&cgrp->events_file);
> > +				delta++;
> > +			}
> > +		}
> > +	}
> > +}
>=20
> So that all these state transitions are synchronous with the actual
> freezing events and we can just queue per-cgroup work items all the
> way to the top if the new state is different from the last one
> cgroup-by-cgroup?

Hm, Idk. Why it's better?

>=20
> > +void cgroup_notify_frozen_fn(struct work_struct *work)
> > +{
> > +	struct cgroup *cgrp =3D container_of(work, struct cgroup,
> > +					   freezer.notify_work);
> > +
> > +	mutex_lock(&cgroup_mutex);
> > +	cgroup_notify_frozen(cgrp, true);
> > +	mutex_unlock(&cgroup_mutex);
> > +
> > +	css_put(&cgrp->self);
> > +}
> > +
> > +void cgroup_queue_notify_frozen(struct cgroup *cgrp)
> > +{
> > +	if (work_pending(&cgrp->freezer.notify_work))
> > +		return;
> > +
> > +	css_get(&cgrp->self);
> > +	schedule_work(&cgrp->freezer.notify_work);
> > +}
> > +
> > +void cgroup_freezer_enter(void)
> > +{
> > +	long state =3D current->state;
> > +	struct cgroup *cgrp;
> > +
> > +	if (!current->frozen) {
>=20
> I think this needs a lot more comments explaining what's going on.
> It's really subtle that this is where the frozen state is becoming
> sticky until the task breaks out of the signal delivery path.

Agreed.

>=20
> > +		spin_lock_irq(&css_set_lock);
> > +		current->frozen =3D true;
> > +		cgrp =3D task_dfl_cgroup(current);
> > +		cgrp->freezer.nr_frozen_tasks++;
> > +
> > +		WARN_ON_ONCE(cgrp->freezer.nr_tasks_to_freeze <
> > +			     cgrp->freezer.nr_frozen_tasks);
> > +
> > +		if (cgrp->freezer.nr_tasks_to_freeze =3D=3D
> > +		    cgrp->freezer.nr_frozen_tasks)
> > +			cgroup_queue_notify_frozen(cgrp);
> > +		spin_unlock_irq(&css_set_lock);
> > +	}
> > +
> > +	/* refrigerator */
> > +	set_current_state(TASK_WAKEKILL | TASK_INTERRUPTIBLE | TASK_FROZEN);
> > +	clear_thread_flag(TIF_SIGPENDING);
>=20
> The toggling of TIF_SIGPENDING needs explanation too.
>=20
> > +	schedule();
> > +	recalc_sigpending();
> > +
> > +	set_current_state(state);
> > +}
> > +
> > +void cgroup_freezer_leave(void)
> > +{
> > +	struct cgroup *cgrp;
> > +
> > +	spin_lock_irq(&css_set_lock);
> > +	cgrp =3D task_dfl_cgroup(current);
> > +	cgrp->freezer.nr_frozen_tasks--;
> > +	WARN_ON_ONCE(cgrp->freezer.nr_frozen_tasks < 0);
> > +	current->frozen =3D false;
> > +	spin_unlock_irq(&css_set_lock);
> > +}
> > +
> > +static void cgroup_do_freeze(struct cgroup *cgrp, bool freeze)
> > +{
> > +	struct css_task_iter it;
> > +	struct task_struct *task;
> > +	unsigned long flags;
> > +
> > +	lockdep_assert_held(&cgroup_mutex);
> > +
> > +	spin_lock_irq(&css_set_lock);
> > +	if (freeze) {
> > +		cgrp->freezer.nr_tasks_to_freeze =3D __cgroup_task_count(cgrp);
> > +		set_bit(CGRP_FREEZE, &cgrp->flags);
> > +	} else {
> > +		clear_bit(CGRP_FREEZE, &cgrp->flags);
> > +		cgroup_notify_frozen(cgrp, false);
> > +	}
> > +	spin_unlock_irq(&css_set_lock);
> > +
> > +	css_task_iter_start(&cgrp->self, 0, &it);
> > +	while ((task =3D css_task_iter_next(&it))) {
> > +		if (task->flags & PF_KTHREAD)
> > +			continue;
>=20
> WARN_ON_ONCE?

Unfortunately, no. See comments above.

>=20
> > +		if (!lock_task_sighand(task, &flags))
> > +			continue;
>=20
> So, this gotta be a dying task.  A comment wouldn't hurt.

Agree.

>=20
> > +		if (freeze) {
> > +			task->jobctl |=3D JOBCTL_TRAP_FREEZE;
> > +			signal_wake_up(task, false);
> > +		} else {
> > +			task->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
> > +			wake_up_process(task);
>=20
> Again, a comment explaining why one's signal_wake_up() and the other's
> wake_up_process() would be great.
>=20
> > +		}
> > +
> > +		unlock_task_sighand(task, &flags);
> > +	}
> > +	css_task_iter_end(&it);
> > +
> > +	if (freeze && cgrp->nr_descendants =3D=3D
> > +	    cgrp->freezer.nr_frozen_descendants) {
> > +		spin_lock_irq(&css_set_lock);
> > +		WARN_ON_ONCE(cgrp->freezer.nr_tasks_to_freeze <
> > +			     cgrp->freezer.nr_frozen_tasks);
> > +		if (cgrp->freezer.nr_tasks_to_freeze =3D=3D
> > +		    cgrp->freezer.nr_frozen_tasks)
> > +			cgroup_notify_frozen(cgrp, true);
> > +		spin_unlock_irq(&css_set_lock);
>=20
> I think notification handling would be easier if we separate out state
> transitions and notifications.

Hm, really? I mean the notification part is really simple: every time
we do the state transition (set or clear CGRP_FROZEN flag), we call
cgroup_file_notify(). That's it.

I can wrap it to a helper function though, might be looking better.
E.g. cgroup_set/clear_frozen(), which will toggle the bit and call
cgroup_file_notify() if necessary.

>=20
> > +	}
> > +}
> > +
> > +void cgroup_freezer_migrate_task(struct task_struct *task,
> > +				 struct cgroup *src, struct cgroup *dst)
> > +{
> > +	unsigned long flags;
> > +
> > +	lockdep_assert_held(&css_set_lock);
> > +
> > +	if (task->flags & PF_KTHREAD)
> > +		return;
> > +
> > +	if (test_bit(CGRP_FREEZE, &src->flags) || task->frozen)
> > +		src->freezer.nr_tasks_to_freeze--;
> > +	if (test_bit(CGRP_FREEZE, &dst->flags) || task->frozen)
> > +		dst->freezer.nr_tasks_to_freeze++;
> > +
> > +	if (task->frozen) {
> > +		src->freezer.nr_frozen_tasks--;
> > +		dst->freezer.nr_frozen_tasks++;
> > +	}
> > +
> > +	if (test_bit(CGRP_FREEZE, &src->flags) =3D=3D
> > +	    test_bit(CGRP_FREEZE, &dst->flags))
> > +		return;
> > +
> > +	if (lock_task_sighand(task, &flags)) {
> > +		if (test_bit(CGRP_FREEZE, &dst->flags))
> > +			task->jobctl |=3D JOBCTL_TRAP_FREEZE;
> > +		else
> > +			task->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
>=20
> How are these flags synchronized?

Using the css_set_lock.

>=20
> > +		signal_wake_up(task, false);
>=20
> Here, we're using signal_wake_up() for both transitions unlike the
> earlier spot.

Yeah, let me check it out.

>=20
> > +		unlock_task_sighand(task, &flags);
> > +	}
> > +}
> > +
> > +void cgroup_freeze(struct cgroup *cgrp, bool freeze)
> > +{
> > +	struct cgroup_subsys_state *css;
> > +	struct cgroup *dsct;
> > +	bool applied =3D false;
> > +
> > +	lockdep_assert_held(&cgroup_mutex);
> > +
> > +	/*
> > +	 * Nothing changed? Just exit.
> > +	 */
> > +	if (cgrp->freeze =3D=3D freeze)
> > +		return;
> > +
> > +	cgrp->freeze =3D freeze;
> > +
> > +	/*
> > +	 * Propagate changes downwards the cgroup tree.
> > +	 */
> > +	css_for_each_descendant_pre(css, &cgrp->self) {
> > +		dsct =3D css->cgroup;
> > +
> > +		if (cgroup_is_dead(dsct))
> > +			continue;
> > +
> > +		if (freeze) {
> > +			dsct->freezer.e_freeze++;
> > +			/*
> > +			 * Already frozen because of ancestor's settings?
> > +			 */
> > +			if (dsct->freezer.e_freeze > 1)
> > +				continue;
> > +		} else {
> > +			dsct->freezer.e_freeze--;
> > +			/*
> > +			 * Still frozen because of ancestor's settings?
> > +			 */
> > +			if (dsct->freezer.e_freeze > 0)
> > +				continue;
> > +
> > +			WARN_ON_ONCE(dsct->freezer.e_freeze < 0);
> > +		}
> > +
> > +		/*
> > +		 * Do change actual state: freeze or unfreeze.
> > +		 */
> > +		cgroup_do_freeze(dsct, freeze);
> > +		applied =3D true;
> > +	}
> > +
> > +	if (!applied)
> > +		cgroup_file_notify(&cgrp->events_file);
> > +}
> > diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> > index 21fec73d45d4..5e484e2480e5 100644
> > --- a/kernel/ptrace.c
> > +++ b/kernel/ptrace.c
> > @@ -400,6 +400,12 @@ static int ptrace_attach(struct task_struct *task,=
 long request,
> > =20
> >  	spin_lock(&task->sighand->siglock);
> > =20
> > +	/*
> > +	 * Kick the process to get it out of the refrigerator.
> > +	 */
> > +	if (cgroup_frozen(task))
> > +		wake_up_process(task);
> > +
> >  	/*
> >  	 * If the task is already STOPPED, set JOBCTL_TRAP_STOP and
> >  	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index 5843c541fda9..6d7f0654f60d 100644
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -326,6 +326,11 @@ void task_clear_jobctl_pending(struct task_struct =
*task, unsigned long mask)
> >  	if (mask & JOBCTL_STOP_PENDING)
> >  		mask |=3D JOBCTL_STOP_CONSUME | JOBCTL_STOP_DEQUEUED;
> > =20
> > +	/*
> > +	 * JOBCTL_TRAP_FREEZE is set and cleared from cgroup side,
> > +	 * don't touch it here.
> > +	 */
> > +	mask &=3D ~JOBCTL_TRAP_FREEZE;
>=20
> It's a bit weird to toggle the bit from here.  Can't we do this from
> the callers?

Probably, not. But we might exclude JOBCTL_TRAP_FREEZE from the
JOBCTL_PENDING_MASK, and it will be enough.

>=20
> >  	task->jobctl &=3D ~mask;
> > =20
> >  	if (!(task->jobctl & JOBCTL_PENDING_MASK))
> > @@ -2252,7 +2257,7 @@ static bool do_signal_stop(int signr)
> >  }
> > =20
> >  /**
> > - * do_jobctl_trap - take care of ptrace jobctl traps
> > + * do_jobctl_trap - take care of ptrace and cgroup freezer jobctl trap=
s
> >   *
> >   * When PT_SEIZED, it's used for both group stop and explicit
> >   * SEIZE/INTERRUPT traps.  Both generate PTRACE_EVENT_STOP trap with
> > @@ -2268,20 +2273,35 @@ static bool do_signal_stop(int signr)
> >   */
> >  static void do_jobctl_trap(void)
> >  {
> > +	struct sighand_struct *sighand =3D current->sighand;
> >  	struct signal_struct *signal =3D current->signal;
> >  	int signr =3D current->jobctl & JOBCTL_STOP_SIGMASK;
> > =20
> > -	if (current->ptrace & PT_SEIZED) {
> > -		if (!signal->group_stop_count &&
> > -		    !(signal->flags & SIGNAL_STOP_STOPPED))
> > -			signr =3D SIGTRAP;
> > -		WARN_ON_ONCE(!signr);
> > -		ptrace_do_notify(signr, signr | (PTRACE_EVENT_STOP << 8),
> > -				 CLD_STOPPED);
> > -	} else {
> > -		WARN_ON_ONCE(!signr);
> > -		ptrace_stop(signr, CLD_STOPPED, 0, NULL);
> > -		current->exit_code =3D 0;
> > +	if (current->jobctl & (JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)) {
> > +		if (current->ptrace & PT_SEIZED) {
> > +			if (!signal->group_stop_count &&
> > +			    !(signal->flags & SIGNAL_STOP_STOPPED))
> > +				signr =3D SIGTRAP;
> > +			WARN_ON_ONCE(!signr);
> > +			ptrace_do_notify(signr,
> > +					 signr | (PTRACE_EVENT_STOP << 8),
> > +					 CLD_STOPPED);
> > +		} else {
> > +			WARN_ON_ONCE(!signr);
> > +			ptrace_stop(signr, CLD_STOPPED, 0, NULL);
> > +			current->exit_code =3D 0;
> > +		}
> > +	} else if (current->jobctl & JOBCTL_TRAP_FREEZE) {
> > +		/*
> > +		 * Enter the freezer, unless the task is about to exit.
> > +		 */
> > +		if (fatal_signal_pending(current)) {
> > +			current->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
> > +		} else {
> > +			spin_unlock_irq(&sighand->siglock);
> > +			cgroup_freezer_enter();
> > +			spin_lock_irq(&sighand->siglock);
> > +		}
>=20
> We'll need a healthy amount of explanation in terms of how freezer
> interacts with jobctl stop and ptrace.

Sure, will add lot more comments, once we'll agree on the actual implementa=
tion
in the thread with Oleg.

Thank you for the code review!
