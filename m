From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.15-fixes 2/2] cgroup_freezer: replace
 freezer->lock with freezer_mutex
Date: Mon, 5 May 2014 18:39:41 -0400
Message-ID: <20140505223941.GV11231@htj.dyndns.org>
References: <20140505223557.GU11231@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XxsWYIPCsU3a9TvD6ISEdzsB2olgF+UCEG4P8V+KcjM=;
        b=BebHBhtGHXnEWxKAqkbnqVktdzFgj1EBDPSNPR3seAHaZqjr28bf9i8ZBy92p54CHt
         xH0bhkLD3ni+/I6V+FfMWUXJrj9/bUk/kW+xCUf8C4jpSEr8otn9UANECpn9mM55KKYw
         ud+xjsZL8HT0tgTsiBZsOulH9vdKAf5Y5IFaGUcVj32VlJVW5C9UDfPUUsqiNlyPQK8/
         5uJakP/dPXNQ+eT1CX4AhCDZXdwcFI9y75/ge8EBRyomXK8SjanlXd/dgf7nTS6+f33A
         unm0Z28xFpuFlmXrK+NPFy3m8atwyJ4uHh48l4SCBOzemiFpcZjq1c6dGTveEzZAz1tW
         E51w==
Content-Disposition: inline
In-Reply-To: <20140505223557.GU11231-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>

Hello,

So, I apparently missed this one while converting css_set_rwlock to
css_set_rwsem.  I thought about reverting that change but concluded
that it'd be better to update locking from cgroup_freezer side.  It
always bothered me that cgroup_freezer was walking all tasks in cgroup
sub-hierarchies under IRQ-safe spinlock.  In general, freezer has been
using way more intricate locking than required for it.

This patch converts cgroup_freezer to use a shared mutex instead of
per-cgroup spinlock for locking and fixes the rwsem-from-atomic issue
at the same time.

Thanks.
------ 8< ------
From 77f01328c3e6d1eae95426543e338674e597e06a Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 5 May 2014 18:35:12 -0400

After 96d365e0b86e ("cgroup: make css_set_lock a rwsem and rename it
to css_set_rwsem"), css task iterators requires sleepable context as
it may block on css_set_rwsem.  I missed that cgroup_freezer was
iterating tasks under IRQ-safe spinlock freezer->lock.  This leads to
errors like the following on freezer state reads and transitions.

  BUG: sleeping function called from invalid context at /work
 /os/work/kernel/locking/rwsem.c:20
  in_atomic(): 0, irqs_disabled(): 0, pid: 462, name: bash
  5 locks held by bash/462:
   #0:  (sb_writers#7){.+.+.+}, at: [<ffffffff811f0843>] vfs_write+0x1a3/0x1c0
   #1:  (&of->mutex){+.+.+.}, at: [<ffffffff8126d78b>] kernfs_fop_write+0xbb/0x170
   #2:  (s_active#70){.+.+.+}, at: [<ffffffff8126d793>] kernfs_fop_write+0xc3/0x170
   #3:  (freezer_mutex){+.+...}, at: [<ffffffff81135981>] freezer_write+0x61/0x1e0
   #4:  (rcu_read_lock){......}, at: [<ffffffff81135973>] freezer_write+0x53/0x1e0
  Preemption disabled at:[<ffffffff81104404>] console_unlock+0x1e4/0x460

  CPU: 3 PID: 462 Comm: bash Not tainted 3.15.0-rc1-work+ #10
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
   ffff88000916a6d0 ffff88000e0a3da0 ffffffff81cf8c96 0000000000000000
   ffff88000e0a3dc8 ffffffff810cf4f2 ffffffff82388040 ffff880013aaf740
   0000000000000002 ffff88000e0a3de8 ffffffff81d05974 0000000000000246
  Call Trace:
   [<ffffffff81cf8c96>] dump_stack+0x4e/0x7a
   [<ffffffff810cf4f2>] __might_sleep+0x162/0x260
   [<ffffffff81d05974>] down_read+0x24/0x60
   [<ffffffff81133e87>] css_task_iter_start+0x27/0x70
   [<ffffffff8113584d>] freezer_apply_state+0x5d/0x130
   [<ffffffff81135a16>] freezer_write+0xf6/0x1e0
   [<ffffffff8112eb88>] cgroup_file_write+0xd8/0x230
   [<ffffffff8126d7b7>] kernfs_fop_write+0xe7/0x170
   [<ffffffff811f0756>] vfs_write+0xb6/0x1c0
   [<ffffffff811f121d>] SyS_write+0x4d/0xc0
   [<ffffffff81d08292>] system_call_fastpath+0x16/0x1b

freezer->lock used to be used in hot paths but that time is long gone
and there's no reason for the lock to be IRQ-safe spinlock or even
per-cgroup.  In fact, given the fact that a cgroup may contain large
number of tasks, it's not a good idea to iterate over them while
holding IRQ-safe spinlock.

Let's simplify locking by replacing per-cgroup freezer->lock with
global freezer_mutex.  This also makes the comments explaining the
intricacies of policy inheritance and the locking around it as the
states are protected by a common mutex.

The conversion is mostly straight-forward.  The followings are worth
mentioning.

* freezer_css_online() no longer needs double locking.

* freezer_attach() now performs propagation simply while holding
  freezer_mutex.  update_if_frozen() race no longer exists and the
  comment is removed.

* freezer_fork() now tests whether the task is in root cgroup using
  the new task_css_is_root() without doing rcu_read_lock/unlock().  If
  not, it grabs freezer_mutex and performs the operation.

* freezer_read() and freezer_change_state() grab freezer_mutex across
  the whole operation and pin the css while iterating so that each
  descendant processing happens in sleepable context.

Fixes: 96d365e0b86e ("cgroup: make css_set_lock a rwsem and rename it to css_set_rwsem")
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup_freezer.c | 112 ++++++++++++++++++++----------------------------
 1 file changed, 46 insertions(+), 66 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 2bc4a22..12ead0b 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -21,6 +21,7 @@
 #include <linux/uaccess.h>
 #include <linux/freezer.h>
 #include <linux/seq_file.h>
+#include <linux/mutex.h>
 
 /*
  * A cgroup is freezing if any FREEZING flags are set.  FREEZING_SELF is
@@ -42,9 +43,10 @@ enum freezer_state_flags {
 struct freezer {
 	struct cgroup_subsys_state	css;
 	unsigned int			state;
-	spinlock_t			lock;
 };
 
+static DEFINE_MUTEX(freezer_mutex);
+
 static inline struct freezer *css_freezer(struct cgroup_subsys_state *css)
 {
 	return css ? container_of(css, struct freezer, css) : NULL;
@@ -93,7 +95,6 @@ freezer_css_alloc(struct cgroup_subsys_state *parent_css)
 	if (!freezer)
 		return ERR_PTR(-ENOMEM);
 
-	spin_lock_init(&freezer->lock);
 	return &freezer->css;
 }
 
@@ -110,14 +111,7 @@ static int freezer_css_online(struct cgroup_subsys_state *css)
 	struct freezer *freezer = css_freezer(css);
 	struct freezer *parent = parent_freezer(freezer);
 
-	/*
-	 * The following double locking and freezing state inheritance
-	 * guarantee that @cgroup can never escape ancestors' freezing
-	 * states.  See css_for_each_descendant_pre() for details.
-	 */
-	if (parent)
-		spin_lock_irq(&parent->lock);
-	spin_lock_nested(&freezer->lock, SINGLE_DEPTH_NESTING);
+	mutex_lock(&freezer_mutex);
 
 	freezer->state |= CGROUP_FREEZER_ONLINE;
 
@@ -126,10 +120,7 @@ static int freezer_css_online(struct cgroup_subsys_state *css)
 		atomic_inc(&system_freezing_cnt);
 	}
 
-	spin_unlock(&freezer->lock);
-	if (parent)
-		spin_unlock_irq(&parent->lock);
-
+	mutex_unlock(&freezer_mutex);
 	return 0;
 }
 
@@ -144,14 +135,14 @@ static void freezer_css_offline(struct cgroup_subsys_state *css)
 {
 	struct freezer *freezer = css_freezer(css);
 
-	spin_lock_irq(&freezer->lock);
+	mutex_lock(&freezer_mutex);
 
 	if (freezer->state & CGROUP_FREEZING)
 		atomic_dec(&system_freezing_cnt);
 
 	freezer->state = 0;
 
-	spin_unlock_irq(&freezer->lock);
+	mutex_unlock(&freezer_mutex);
 }
 
 static void freezer_css_free(struct cgroup_subsys_state *css)
@@ -175,7 +166,7 @@ static void freezer_attach(struct cgroup_subsys_state *new_css,
 	struct task_struct *task;
 	bool clear_frozen = false;
 
-	spin_lock_irq(&freezer->lock);
+	mutex_lock(&freezer_mutex);
 
 	/*
 	 * Make the new tasks conform to the current state of @new_css.
@@ -197,21 +188,13 @@ static void freezer_attach(struct cgroup_subsys_state *new_css,
 		}
 	}
 
-	spin_unlock_irq(&freezer->lock);
-
-	/*
-	 * Propagate FROZEN clearing upwards.  We may race with
-	 * update_if_frozen(), but as long as both work bottom-up, either
-	 * update_if_frozen() sees child's FROZEN cleared or we clear the
-	 * parent's FROZEN later.  No parent w/ !FROZEN children can be
-	 * left FROZEN.
-	 */
+	/* propagate FROZEN clearing upwards */
 	while (clear_frozen && (freezer = parent_freezer(freezer))) {
-		spin_lock_irq(&freezer->lock);
 		freezer->state &= ~CGROUP_FROZEN;
 		clear_frozen = freezer->state & CGROUP_FREEZING;
-		spin_unlock_irq(&freezer->lock);
 	}
+
+	mutex_unlock(&freezer_mutex);
 }
 
 /**
@@ -228,9 +211,6 @@ static void freezer_fork(struct task_struct *task)
 {
 	struct freezer *freezer;
 
-	rcu_read_lock();
-	freezer = task_freezer(task);
-
 	/*
 	 * The root cgroup is non-freezable, so we can skip locking the
 	 * freezer.  This is safe regardless of race with task migration.
@@ -238,24 +218,18 @@ static void freezer_fork(struct task_struct *task)
 	 * to do.  If we lost and root is the new cgroup, noop is still the
 	 * right thing to do.
 	 */
-	if (!parent_freezer(freezer))
-		goto out;
+	if (task_css_is_root(task, freezer_cgrp_id))
+		return;
 
-	/*
-	 * Grab @freezer->lock and freeze @task after verifying @task still
-	 * belongs to @freezer and it's freezing.  The former is for the
-	 * case where we have raced against task migration and lost and
-	 * @task is already in a different cgroup which may not be frozen.
-	 * This isn't strictly necessary as freeze_task() is allowed to be
-	 * called spuriously but let's do it anyway for, if nothing else,
-	 * documentation.
-	 */
-	spin_lock_irq(&freezer->lock);
-	if (freezer == task_freezer(task) && (freezer->state & CGROUP_FREEZING))
+	mutex_lock(&freezer_mutex);
+	rcu_read_lock();
+
+	freezer = task_freezer(task);
+	if (freezer->state & CGROUP_FREEZING)
 		freeze_task(task);
-	spin_unlock_irq(&freezer->lock);
-out:
+
 	rcu_read_unlock();
+	mutex_unlock(&freezer_mutex);
 }
 
 /**
@@ -281,22 +255,22 @@ static void update_if_frozen(struct cgroup_subsys_state *css)
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
-
-	spin_lock_irq(&freezer->lock);
+	lockdep_assert_held(&freezer_mutex);
 
 	if (!(freezer->state & CGROUP_FREEZING) ||
 	    (freezer->state & CGROUP_FROZEN))
-		goto out_unlock;
+		return;
 
 	/* are all (live) children frozen? */
+	rcu_read_lock();
 	css_for_each_child(pos, css) {
 		struct freezer *child = css_freezer(pos);
 
 		if ((child->state & CGROUP_FREEZER_ONLINE) &&
 		    !(child->state & CGROUP_FROZEN))
-			goto out_unlock;
+			return;
 	}
+	rcu_read_unlock();
 
 	/* are all tasks frozen? */
 	css_task_iter_start(css, &it);
@@ -317,21 +291,29 @@ static void update_if_frozen(struct cgroup_subsys_state *css)
 	freezer->state |= CGROUP_FROZEN;
 out_iter_end:
 	css_task_iter_end(&it);
-out_unlock:
-	spin_unlock_irq(&freezer->lock);
 }
 
 static int freezer_read(struct seq_file *m, void *v)
 {
 	struct cgroup_subsys_state *css = seq_css(m), *pos;
 
+	mutex_lock(&freezer_mutex);
 	rcu_read_lock();
 
 	/* update states bottom-up */
-	css_for_each_descendant_post(pos, css)
+	css_for_each_descendant_post(pos, css) {
+		if (!css_tryget(pos))
+			continue;
+		rcu_read_unlock();
+
 		update_if_frozen(pos);
 
+		rcu_read_lock();
+		css_put(pos);
+	}
+
 	rcu_read_unlock();
+	mutex_unlock(&freezer_mutex);
 
 	seq_puts(m, freezer_state_strs(css_freezer(css)->state));
 	seq_putc(m, '\n');
@@ -373,7 +355,7 @@ static void freezer_apply_state(struct freezer *freezer, bool freeze,
 				unsigned int state)
 {
 	/* also synchronizes against task migration, see freezer_attach() */
-	lockdep_assert_held(&freezer->lock);
+	lockdep_assert_held(&freezer_mutex);
 
 	if (!(freezer->state & CGROUP_FREEZER_ONLINE))
 		return;
@@ -414,31 +396,29 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
 	 * descendant will try to inherit its parent's FREEZING state as
 	 * CGROUP_FREEZING_PARENT.
 	 */
+	mutex_lock(&freezer_mutex);
 	rcu_read_lock();
 	css_for_each_descendant_pre(pos, &freezer->css) {
 		struct freezer *pos_f = css_freezer(pos);
 		struct freezer *parent = parent_freezer(pos_f);
 
-		spin_lock_irq(&pos_f->lock);
+		if (!css_tryget(pos))
+			continue;
+		rcu_read_unlock();
 
-		if (pos_f == freezer) {
+		if (pos_f == freezer)
 			freezer_apply_state(pos_f, freeze,
 					    CGROUP_FREEZING_SELF);
-		} else {
-			/*
-			 * Our update to @parent->state is already visible
-			 * which is all we need.  No need to lock @parent.
-			 * For more info on synchronization, see
-			 * freezer_post_create().
-			 */
+		else
 			freezer_apply_state(pos_f,
 					    parent->state & CGROUP_FREEZING,
 					    CGROUP_FREEZING_PARENT);
-		}
 
-		spin_unlock_irq(&pos_f->lock);
+		rcu_read_lock();
+		css_put(pos);
 	}
 	rcu_read_unlock();
+	mutex_unlock(&freezer_mutex);
 }
 
 static int freezer_write(struct cgroup_subsys_state *css, struct cftype *cft,
-- 
1.9.0
