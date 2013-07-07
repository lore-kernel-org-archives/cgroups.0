From: Glauber Costa <glommer@gmail.com>
Subject: [PATCH v10 04/16] memcg: move stop and resume accounting functions
Date: Sun,  7 Jul 2013 11:56:44 -0400
Message-ID: <1373212616-11713-5-git-send-email-glommer@openvz.org>
References: <1373212616-11713-1-git-send-email-glommer@openvz.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=q2qZ/yh13fmtOEzTkf51/RWkm3ee5Hb3+Vrfkv8lexc=;
        b=s2Lk22uzRDe6we+4kHnQsDn1XjUjSDQnv2yNuLc9LW6BgT3UsGzpSkQvsBIG9wRRcA
         esru3NJr0iwp9CJw4byYELs0BOjkQjSO9VhUTFtJs1C4lXwofx2dUIttdFUt2URK6g43
         aFPQKSenbtRp/I0Q6ivae+lf0o62V5gkP/HIH8tiAzf+QU8cDfl5vz7tTiZtItuySJpJ
         2UxKyrRKdOx+Quow0p3Vz2jDwpSzxcnnwdBtOFy+FUBtViihREDGjSf/JhOQ/BVNXIrL
         Lw+/4xr2GkuhZnpjpTcelOfRuEUhLc0WqkV2FdrD828ZSiG0FoX/X2mNwxUJW8fuDiNF
         p8Xw==
In-Reply-To: <1373212616-11713-1-git-send-email-glommer@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, mgorman@suse.de, david@fromorbit.com, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suze.cz, hannes@cmpxchg.org, hughd@google.com, gthelen@google.com, akpm@linux-foundation.org, Glauber Costa <glommer@openvz.org>, Michal Hocko <mhocko@suse.cz>

I need to move this up a bit, and I am doing it in a separate patch just to
reduce churn in the patch that needs it.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/memcontrol.c | 63 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eda075b4..a5581ef 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2991,6 +2991,38 @@ static struct kmem_cache *memcg_params_to_cache(struct memcg_cache_params *p)
 	return cachep->memcg_params->memcg_caches[memcg_cache_idx(p->memcg)];
 }
 
+/*
+ * During the creation a new cache, we need to disable our accounting mechanism
+ * altogether. This is true even if we are not creating, but rather just
+ * enqueing new caches to be created.
+ *
+ * This is because that process will trigger allocations; some visible, like
+ * explicit kmallocs to auxiliary data structures, name strings and internal
+ * cache structures; some well concealed, like INIT_WORK() that can allocate
+ * objects during debug.
+ *
+ * If any allocation happens during memcg_kmem_get_cache, we will recurse back
+ * to it. This may not be a bounded recursion: since the first cache creation
+ * failed to complete (waiting on the allocation), we'll just try to create the
+ * cache again, failing at the same point.
+ *
+ * memcg_kmem_get_cache is prepared to abort after seeing a positive count of
+ * memcg_kmem_skip_account. So we enclose anything that might allocate memory
+ * inside the following two functions.
+ */
+static inline void memcg_stop_kmem_account(void)
+{
+	VM_BUG_ON(!current->mm);
+	current->memcg_kmem_skip_account++;
+}
+
+static inline void memcg_resume_kmem_account(void)
+{
+	VM_BUG_ON(!current->mm);
+	current->memcg_kmem_skip_account--;
+}
+
+
 #ifdef CONFIG_SLABINFO
 static int mem_cgroup_slabinfo_read(struct cgroup *cont, struct cftype *cft,
 					struct seq_file *m)
@@ -3265,37 +3297,6 @@ out:
 	kfree(s->memcg_params);
 }
 
-/*
- * During the creation a new cache, we need to disable our accounting mechanism
- * altogether. This is true even if we are not creating, but rather just
- * enqueing new caches to be created.
- *
- * This is because that process will trigger allocations; some visible, like
- * explicit kmallocs to auxiliary data structures, name strings and internal
- * cache structures; some well concealed, like INIT_WORK() that can allocate
- * objects during debug.
- *
- * If any allocation happens during memcg_kmem_get_cache, we will recurse back
- * to it. This may not be a bounded recursion: since the first cache creation
- * failed to complete (waiting on the allocation), we'll just try to create the
- * cache again, failing at the same point.
- *
- * memcg_kmem_get_cache is prepared to abort after seeing a positive count of
- * memcg_kmem_skip_account. So we enclose anything that might allocate memory
- * inside the following two functions.
- */
-static inline void memcg_stop_kmem_account(void)
-{
-	VM_BUG_ON(!current->mm);
-	current->memcg_kmem_skip_account++;
-}
-
-static inline void memcg_resume_kmem_account(void)
-{
-	VM_BUG_ON(!current->mm);
-	current->memcg_kmem_skip_account--;
-}
-
 static void kmem_cache_destroy_work_func(struct work_struct *w)
 {
 	struct kmem_cache *cachep;
-- 
1.8.2.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
