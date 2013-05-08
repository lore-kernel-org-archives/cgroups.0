From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 03/31] dcache: convert dentry_stat.nr_unused to per-cpu counters
Date: Thu,  9 May 2013 00:22:51 +0400
Message-ID: <1368044599-3383-4-git-send-email-glommer@openvz.org>
References: <1368044599-3383-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368044599-3383-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Before we split up the dcache_lru_lock, the unused dentry counter
needs to be made independent of the global dcache_lru_lock. Convert
it to per-cpu counters to do this.

[ v5: comment about possible cpus ]
Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
---
 fs/dcache.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index e689268..5000595 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -118,8 +118,10 @@ struct dentry_stat_t dentry_stat = {
 };
 
 static DEFINE_PER_CPU(unsigned int, nr_dentry);
+static DEFINE_PER_CPU(unsigned int, nr_dentry_unused);
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+/* scan possible cpus instead of online and avoid worrying about CPU hotplug. */
 static int get_nr_dentry(void)
 {
 	int i;
@@ -129,10 +131,20 @@ static int get_nr_dentry(void)
 	return sum < 0 ? 0 : sum;
 }
 
+static int get_nr_dentry_unused(void)
+{
+	int i;
+	int sum = 0;
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
 	return proc_dointvec(table, write, buffer, lenp, ppos);
 }
 #endif
@@ -312,7 +324,7 @@ static void dentry_lru_add(struct dentry *dentry)
 		spin_lock(&dcache_lru_lock);
 		list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
 		dentry->d_sb->s_nr_dentry_unused++;
-		dentry_stat.nr_unused++;
+		this_cpu_inc(nr_dentry_unused);
 		spin_unlock(&dcache_lru_lock);
 	}
 }
@@ -322,7 +334,7 @@ static void __dentry_lru_del(struct dentry *dentry)
 	list_del_init(&dentry->d_lru);
 	dentry->d_flags &= ~DCACHE_SHRINK_LIST;
 	dentry->d_sb->s_nr_dentry_unused--;
-	dentry_stat.nr_unused--;
+	this_cpu_dec(nr_dentry_unused);
 }
 
 /*
@@ -360,7 +372,7 @@ static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
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
