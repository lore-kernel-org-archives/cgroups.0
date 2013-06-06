From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v11 03/25] dcache: convert dentry_stat.nr_unused to per-cpu counters
Date: Fri,  7 Jun 2013 00:34:36 +0400
Message-ID: <1370550898-26711-4-git-send-email-glommer@openvz.org>
References: <1370550898-26711-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370550898-26711-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mhocko-Y4LbUc7mvzI@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Before we split up the dcache_lru_lock, the unused dentry counter
needs to be made independent of the global dcache_lru_lock. Convert
it to per-cpu counters to do this.

[ v11: updated comments about the handcrafted percpu implementation ]
[ v5: comment about possible cpus ]
Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
---
 fs/dcache.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index aca4e4b..0466dbd 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -118,8 +118,22 @@ struct dentry_stat_t dentry_stat = {
 };
 
 static DEFINE_PER_CPU(long, nr_dentry);
+static DEFINE_PER_CPU(long, nr_dentry_unused);
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+
+/*
+ * Here we resort to our own counters instead of using generic per-cpu counters
+ * for consistency with what the vfs inode code does. We are expected to harvest
+ * better code and performance by having our own specialized counters.
+ *
+ * Please note that the loop is done over all possible CPUs, not over all online
+ * CPUs. The reason for this is that we don't want to play games with CPUs going
+ * on and off. If one of them goes off, we will just keep their counters.
+ *
+ * glommer: See cffbc8a for details, and if you ever intend to change this,
+ * please update all vfs counters to match.
+ */
 static long get_nr_dentry(void)
 {
 	int i;
@@ -129,10 +143,20 @@ static long get_nr_dentry(void)
 	return sum < 0 ? 0 : sum;
 }
 
+static long get_nr_dentry_unused(void)
+{
+	int i;
+	long sum = 0;
+	for_each_possible_cpu(i)
+		sum += per_cpu(nr_dentry_unused, i);
+	return sum < 0 ? 0 : sum;
+}
+
 int proc_nr_dentry(ctl_table *table, int write, void __user *buffer,
 		   size_t *lenp, loff_t *ppos)
 {
 	dentry_stat.nr_dentry = get_nr_dentry();
+	dentry_stat.nr_unused = get_nr_dentry_unused();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 #endif
@@ -312,7 +336,7 @@ static void dentry_lru_add(struct dentry *dentry)
 		spin_lock(&dcache_lru_lock);
 		list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
 		dentry->d_sb->s_nr_dentry_unused++;
-		dentry_stat.nr_unused++;
+		this_cpu_inc(nr_dentry_unused);
 		spin_unlock(&dcache_lru_lock);
 	}
 }
@@ -322,7 +346,7 @@ static void __dentry_lru_del(struct dentry *dentry)
 	list_del_init(&dentry->d_lru);
 	dentry->d_flags &= ~DCACHE_SHRINK_LIST;
 	dentry->d_sb->s_nr_dentry_unused--;
-	dentry_stat.nr_unused--;
+	this_cpu_dec(nr_dentry_unused);
 }
 
 /*
@@ -343,7 +367,7 @@ static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
 	if (list_empty(&dentry->d_lru)) {
 		list_add_tail(&dentry->d_lru, list);
 		dentry->d_sb->s_nr_dentry_unused++;
-		dentry_stat.nr_unused++;
+		this_cpu_inc(nr_dentry_unused);
 	} else {
 		list_move_tail(&dentry->d_lru, list);
 	}
-- 
1.8.1.4
