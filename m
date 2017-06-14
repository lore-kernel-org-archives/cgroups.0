From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/7] cgroup: fix lockdep warning in debug controller
Date: Wed, 14 Jun 2017 16:08:42 -0400
Message-ID: <20170614200842.15174-8-tj@kernel.org>
References: <20170614200842.15174-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gdLfVCVfm4L6pDIG7A7+oUPvQacE/8RjGnWP4ieINeQ=;
        b=LVX+M18vRb/BEkxBgEZhlK246Xrs1AeGZOwAyCJ7DcBcHqVDSUrUh8NcUvrGuDBQYt
         J5639uTn74FuO1qoXjcEVq7+cAMkG3A+KHyzZ8qrd0uTJ1APqTj0xsZwXYLbbOVt/8/c
         P+KDrN6hQdkRKDP6bSVPadEhY/WNo9Eh7xHIBklWOXGlRWmW3ydiVddvafs+yriTWzvm
         /VjCsBM8/cNRgRgqxDHSGHA2VEMHQ0DrsEBe0OEbrpJZ0iwTJUc7ZDGFA+3tuGhT4bj/
         UTH3t4SVLQzBDq4u0umpfWY+VI4qXcy9saioDipv2WtuWolOrNpTst1KkeVR5c6YoVkI
         vi0A==
In-Reply-To: <20170614200842.15174-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

The debug controller grabs cgroup_mutex from interface file show
functions which can deadlock and triggers lockdep warnings.  Fix it by
using cgroup_kn_lock_live()/cgroup_kn_unlock() instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/debug.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index 163fdbd7adf6..dac46af22782 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -38,12 +38,15 @@ static u64 debug_taskcount_read(struct cgroup_subsys_state *css,
 
 static int current_css_set_read(struct seq_file *seq, void *v)
 {
+	struct kernfs_open_file *of = seq->private;
 	struct css_set *cset;
 	struct cgroup_subsys *ss;
 	struct cgroup_subsys_state *css;
 	int i, refcnt;
 
-	mutex_lock(&cgroup_mutex);
+	if (!cgroup_kn_lock_live(of->kn, false))
+		return -ENODEV;
+
 	spin_lock_irq(&css_set_lock);
 	rcu_read_lock();
 	cset = rcu_dereference(current->cgroups);
@@ -65,7 +68,7 @@ static int current_css_set_read(struct seq_file *seq, void *v)
 	}
 	rcu_read_unlock();
 	spin_unlock_irq(&css_set_lock);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_kn_unlock(of->kn);
 	return 0;
 }
 
@@ -174,13 +177,17 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 
 static int cgroup_subsys_states_read(struct seq_file *seq, void *v)
 {
-	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	struct kernfs_open_file *of = seq->private;
+	struct cgroup *cgrp;
 	struct cgroup_subsys *ss;
 	struct cgroup_subsys_state *css;
 	char pbuf[16];
 	int i;
 
-	mutex_lock(&cgroup_mutex);
+	cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!cgrp)
+		return -ENODEV;
+
 	for_each_subsys(ss, i) {
 		css = rcu_dereference_check(cgrp->subsys[ss->id], true);
 		if (!css)
@@ -196,7 +203,8 @@ static int cgroup_subsys_states_read(struct seq_file *seq, void *v)
 			  (unsigned long)css, css->id,
 			  atomic_read(&css->online_cnt), pbuf);
 	}
-	mutex_unlock(&cgroup_mutex);
+
+	cgroup_kn_unlock(of->kn);
 	return 0;
 }
 
@@ -221,12 +229,17 @@ static void cgroup_masks_read_one(struct seq_file *seq, const char *name,
 
 static int cgroup_masks_read(struct seq_file *seq, void *v)
 {
-	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	struct kernfs_open_file *of = seq->private;
+	struct cgroup *cgrp;
+
+	cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!cgrp)
+		return -ENODEV;
 
-	mutex_lock(&cgroup_mutex);
 	cgroup_masks_read_one(seq, "subtree_control", cgrp->subtree_control);
 	cgroup_masks_read_one(seq, "subtree_ss_mask", cgrp->subtree_ss_mask);
-	mutex_unlock(&cgroup_mutex);
+
+	cgroup_kn_unlock(of->kn);
 	return 0;
 }
 
-- 
2.13.0

