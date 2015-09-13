From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] memcg: collect kmem bypass conditions into
 __memcg_kmem_bypass()
Date: Sun, 13 Sep 2015 16:14:16 -0400
Message-ID: <20150913201416.GC25369@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=7XzzX1G+JGh4afzndGvSVQ8dz4Q8Ix68I/tqonQ+Yrk=;
        b=Xo3fpmJAglKKHZmf3cmifHHVYjfayQYQEqYMr21K7PvuOimdXS5XozhimvyXFVoUe/
         2vG2dZ8pexuB8837ll2Rn74A3g2qPFQDXfJqbz6y0Og0abz4FxrwkBhGW1JBJn35TQfB
         qYebnsHoavk62JufB76WJpvmvZ3/prlCfEdxsc8qCl39/KIQhvJJmW1TEMw2L2vQkX8g
         zjgfnfj2hP6QGXDEbQrAvJ78IJyxaZaJeFf+HU52bcuMkSlQ6eSM40W4Y7SUsV68zgfA
         UsD7NCqv/woyDwpCbPjdJOYyaqoWWsG5/A/GIZSnhskmkWB+93kH5igZcFm0+55BXtUH
         Srpw==
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, vdavydov@parallels.com, kernel-team@fb.com

memcg_kmem_newpage_charge() and memcg_kmem_get_cache() are testing the
same series of conditions to decide whether to bypass kmem accounting.
Collect the tests into __memcg_kmem_bypass().

This is pure refactoring.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello,

These three patches are on top of mmotm as of Sep 13th and the two
patches from the following thread.

 http://lkml.kernel.org/g/20150913185940.GA25369@htj.duckdns.org

Thanks.

 include/linux/memcontrol.h |   46 +++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -776,20 +776,7 @@ int memcg_charge_kmem(struct mem_cgroup
 		      unsigned long nr_pages);
 void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned long nr_pages);
 
-/**
- * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
- * @gfp: the gfp allocation flags.
- * @memcg: a pointer to the memcg this was charged against.
- * @order: allocation order.
- *
- * returns true if the memcg where the current task belongs can hold this
- * allocation.
- *
- * We return true automatically if this allocation is not to be accounted to
- * any memcg.
- */
-static inline bool
-memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
+static inline bool __memcg_kmem_bypass(gfp_t gfp)
 {
 	if (!memcg_kmem_enabled())
 		return true;
@@ -811,6 +798,26 @@ memcg_kmem_newpage_charge(gfp_t gfp, str
 	if (unlikely(fatal_signal_pending(current)))
 		return true;
 
+	return false;
+}
+
+/**
+ * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
+ * @gfp: the gfp allocation flags.
+ * @memcg: a pointer to the memcg this was charged against.
+ * @order: allocation order.
+ *
+ * returns true if the memcg where the current task belongs can hold this
+ * allocation.
+ *
+ * We return true automatically if this allocation is not to be accounted to
+ * any memcg.
+ */
+static inline bool
+memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
+{
+	if (__memcg_kmem_bypass(gfp))
+		return true;
 	return __memcg_kmem_newpage_charge(gfp, memcg, order);
 }
 
@@ -853,17 +860,8 @@ memcg_kmem_commit_charge(struct page *pa
 static __always_inline struct kmem_cache *
 memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
-	if (!memcg_kmem_enabled())
-		return cachep;
-	if (gfp & __GFP_NOACCOUNT)
-		return cachep;
-	if (gfp & __GFP_NOFAIL)
+	if (__memcg_kmem_bypass(gfp))
 		return cachep;
-	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
-		return cachep;
-	if (unlikely(fatal_signal_pending(current)))
-		return cachep;
-
 	return __memcg_kmem_get_cache(cachep);
 }
 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
