From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 05/31] dcache: remove dentries from LRU before putting on dispose list
Date: Thu,  9 May 2013 00:22:53 +0400
Message-ID: <1368044599-3383-6-git-send-email-glommer@openvz.org>
References: <1368044599-3383-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368044599-3383-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

One of the big problems with modifying the way the dcache shrinker
and LRU implementation works is that the LRU is abused in several
ways. One of these is shrink_dentry_list().

Basically, we can move a dentry off the LRU onto a different list
without doing any accounting changes, and then use dentry_lru_prune()
to remove it from what-ever list it is now on to do the LRU
accounting at that point.

This makes it -really hard- to change the LRU implementation. The
use of the per-sb LRU lock serialises movement of the dentries
between the different lists and the removal of them, and this is the
only reason that it works. If we want to break up the dentry LRU
lock and lists into, say, per-node lists, we remove the only
serialisation that allows this lru list/dispose list abuse to work.

To make this work effectively, the dispose list has to be isolated
from the LRU list - dentries have to be removed from the LRU
*before* being placed on the dispose list. This means that the LRU
accounting and isolation is completed before disposal is started,
and that means we can change the LRU implementation freely in
future.

This means that dentries *must* be marked with DCACHE_SHRINK_LIST
when they are placed on the dispose list so that we don't think that
parent dentries found in try_prune_one_dentry() are on the LRU when
the are actually on the dispose list. This would result in
accounting the dentry to the LRU a second time. Hence
dentry_lru_prune() has to handle the DCACHE_SHRINK_LIST case
differently because the dentry isn't on the LRU list.

[ v2: don't decrement nr unused twice, spotted by Sha Zhengju ]
Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Acked-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
---
 fs/dcache.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 10 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 6649764..26fd63d 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -331,7 +331,6 @@ static void dentry_lru_add(struct dentry *dentry)
 static void __dentry_lru_del(struct dentry *dentry)
 {
 	list_del_init(&dentry->d_lru);
-	dentry->d_flags &= ~DCACHE_SHRINK_LIST;
 	dentry->d_sb->s_nr_dentry_unused--;
 	this_cpu_dec(nr_dentry_unused);
 }
@@ -341,6 +340,8 @@ static void __dentry_lru_del(struct dentry *dentry)
  */
 static void dentry_lru_del(struct dentry *dentry)
 {
+	BUG_ON(dentry->d_flags & DCACHE_SHRINK_LIST);
+
 	if (!list_empty(&dentry->d_lru)) {
 		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 		__dentry_lru_del(dentry);
@@ -352,6 +353,12 @@ static void dentry_lru_del(struct dentry *dentry)
  * Remove a dentry that is unreferenced and about to be pruned
  * (unhashed and destroyed) from the LRU, and inform the file system.
  * This wrapper should be called _prior_ to unhashing a victim dentry.
+ *
+ * Check that the dentry really is on the LRU as it may be on a private dispose
+ * list and in that case we do not want to call the generic LRU removal
+ * functions. This typically happens when shrink_dcache_sb() clears the LRU in
+ * one go and then try_prune_one_dentry() walks back up the parent chain finding
+ * dentries that are also on the dispose list.
  */
 static void dentry_lru_prune(struct dentry *dentry)
 {
@@ -359,21 +366,28 @@ static void dentry_lru_prune(struct dentry *dentry)
 		if (dentry->d_flags & DCACHE_OP_PRUNE)
 			dentry->d_op->d_prune(dentry);
 
-		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
-		__dentry_lru_del(dentry);
-		spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
+		if ((dentry->d_flags & DCACHE_SHRINK_LIST))
+			list_del_init(&dentry->d_lru);
+		else {
+			spin_lock(&dentry->d_sb->s_dentry_lru_lock);
+			__dentry_lru_del(dentry);
+			spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
+		}
+		dentry->d_flags &= ~DCACHE_SHRINK_LIST;
 	}
 }
 
 static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
 {
+	BUG_ON(dentry->d_flags & DCACHE_SHRINK_LIST);
+
 	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 	if (list_empty(&dentry->d_lru)) {
 		list_add_tail(&dentry->d_lru, list);
-		dentry->d_sb->s_nr_dentry_unused++;
-		this_cpu_inc(nr_dentry_unused);
 	} else {
 		list_move_tail(&dentry->d_lru, list);
+		dentry->d_sb->s_nr_dentry_unused--;
+		this_cpu_dec(nr_dentry_unused);
 	}
 	spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 }
@@ -815,12 +829,18 @@ static void shrink_dentry_list(struct list_head *list)
 		}
 
 		/*
+		 * The dispose list is isolated and dentries are not accounted
+		 * to the LRU here, so we can simply remove it from the list
+		 * here regardless of whether it is referenced or not.
+		 */
+		list_del_init(&dentry->d_lru);
+
+		/*
 		 * We found an inuse dentry which was not removed from
-		 * the LRU because of laziness during lookup.  Do not free
-		 * it - just keep it off the LRU list.
+		 * the LRU because of laziness during lookup. Do not free it.
 		 */
 		if (dentry->d_count) {
-			dentry_lru_del(dentry);
+			dentry->d_flags &= ~DCACHE_SHRINK_LIST;
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
@@ -872,6 +892,8 @@ relock:
 		} else {
 			list_move_tail(&dentry->d_lru, &tmp);
 			dentry->d_flags |= DCACHE_SHRINK_LIST;
+			this_cpu_dec(nr_dentry_unused);
+			sb->s_nr_dentry_unused--;
 			spin_unlock(&dentry->d_lock);
 			if (!--count)
 				break;
@@ -885,6 +907,27 @@ relock:
 	shrink_dentry_list(&tmp);
 }
 
+/*
+ * Mark all the dentries as on being the dispose list so we don't think they are
+ * still on the LRU if we try to kill them from ascending the parent chain in
+ * try_prune_one_dentry() rather than directly from the dispose list.
+ */
+static void
+shrink_dcache_list(
+	struct list_head *dispose)
+{
+	struct dentry *dentry;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(dentry, dispose, d_lru) {
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags |= DCACHE_SHRINK_LIST;
+		spin_unlock(&dentry->d_lock);
+	}
+	rcu_read_unlock();
+	shrink_dentry_list(dispose);
+}
+
 /**
  * shrink_dcache_sb - shrink dcache for a superblock
  * @sb: superblock
@@ -899,8 +942,16 @@ void shrink_dcache_sb(struct super_block *sb)
 	spin_lock(&sb->s_dentry_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		list_splice_init(&sb->s_dentry_lru, &tmp);
+
+		/*
+		 * account for removal here so we don't need to handle it later
+		 * even though the dentry is no longer on the lru list.
+		 */
+		this_cpu_sub(nr_dentry_unused, sb->s_nr_dentry_unused);
+		sb->s_nr_dentry_unused = 0;
+
 		spin_unlock(&sb->s_dentry_lru_lock);
-		shrink_dentry_list(&tmp);
+		shrink_dcache_list(&tmp);
 		spin_lock(&sb->s_dentry_lru_lock);
 	}
 	spin_unlock(&sb->s_dentry_lru_lock);
-- 
1.8.1.4
