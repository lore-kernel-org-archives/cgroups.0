From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v4 03/19] move print_slabinfo_header to slab_common.c
Date: Fri, 12 Oct 2012 17:40:57 +0400
Message-ID: <1350049273-17213-4-git-send-email-glommer@parallels.com>
References: <1350049273-17213-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350049273-17213-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

The header format is highly similar between slab and slub. The main
difference lays in the fact that slab may optionally have statistics
added here in case of CONFIG_SLAB_DEBUG, while the slub will stick them
somewhere else.

By making sure that information conditionally lives inside a
globally-visible CONFIG_DEBUG_SLAB switch, we can move the header
printing to a common location.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Acked-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
CC: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/slab.c        | 24 ------------------------
 mm/slab.h        |  2 --
 mm/slab_common.c | 23 +++++++++++++++++++++++
 mm/slub.c        | 10 ----------
 4 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index e35970a..864a9e9 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4262,30 +4262,6 @@ out:
 }
 
 #ifdef CONFIG_SLABINFO
-
-void print_slabinfo_header(struct seq_file *m)
-{
-	/*
-	 * Output format version, so at least we can change it
-	 * without _too_ many complaints.
-	 */
-#if STATS
-	seq_puts(m, "slabinfo - version: 2.1 (statistics)\n");
-#else
-	seq_puts(m, "slabinfo - version: 2.1\n");
-#endif
-	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> "
-		 "<objperslab> <pagesperslab>");
-	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
-	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
-#if STATS
-	seq_puts(m, " : globalstat <listallocs> <maxobjs> <grown> <reaped> "
-		 "<error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow>");
-	seq_puts(m, " : cpustat <allochit> <allocmiss> <freehit> <freemiss>");
-#endif
-	seq_putc(m, '\n');
-}
-
 int slabinfo_show(struct seq_file *m, void *p)
 {
 	struct kmem_cache *cachep = list_entry(p, struct kmem_cache, list);
diff --git a/mm/slab.h b/mm/slab.h
index 4156d21..e9ba23f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -74,8 +74,6 @@ int __kmem_cache_shutdown(struct kmem_cache *);
 
 struct seq_file;
 struct file;
-void print_slabinfo_header(struct seq_file *m);
-
 int slabinfo_show(struct seq_file *m, void *p);
 
 ssize_t slabinfo_write(struct file *file, const char __user *buffer,
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 11ecab4..bb4d751 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -200,6 +200,29 @@ int slab_is_available(void)
 }
 
 #ifdef CONFIG_SLABINFO
+static void print_slabinfo_header(struct seq_file *m)
+{
+	/*
+	 * Output format version, so at least we can change it
+	 * without _too_ many complaints.
+	 */
+#ifdef CONFIG_DEBUG_SLAB
+	seq_puts(m, "slabinfo - version: 2.1 (statistics)\n");
+#else
+	seq_puts(m, "slabinfo - version: 2.1\n");
+#endif
+	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> "
+		 "<objperslab> <pagesperslab>");
+	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
+	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
+#ifdef CONFIG_DEBUG_SLAB
+	seq_puts(m, " : globalstat <listallocs> <maxobjs> <grown> <reaped> "
+		 "<error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow>");
+	seq_puts(m, " : cpustat <allochit> <allocmiss> <freehit> <freemiss>");
+#endif
+	seq_putc(m, '\n');
+}
+
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
 	loff_t n = *pos;
diff --git a/mm/slub.c b/mm/slub.c
index 55304ed..91e1f3b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5394,16 +5394,6 @@ __initcall(slab_sysfs_init);
  * The /proc/slabinfo ABI
  */
 #ifdef CONFIG_SLABINFO
-void print_slabinfo_header(struct seq_file *m)
-{
-	seq_puts(m, "slabinfo - version: 2.1\n");
-	seq_puts(m, "# name            <active_objs> <num_objs> <object_size> "
-		 "<objperslab> <pagesperslab>");
-	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
-	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
-	seq_putc(m, '\n');
-}
-
 int slabinfo_show(struct seq_file *m, void *p)
 {
 	unsigned long nr_partials = 0;
-- 
1.7.11.4
