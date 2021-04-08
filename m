From: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: memcg: performance degradation since v5.9
Date: Thu, 8 Apr 2021 15:39:48 -0400
Message-ID: <20210408193948.vfktg3azh2wrt56t@gabell>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=QeU/q9380e80Rz0CC5FjllV+AOsJl7M6jz+GbnL7t8w=;
        b=UCDJolFimoL+NxnS37SOwTtKFfp41/J8K9Gpd75YJQ5t5CMTZ7ROpQN4lw4LU6kU08
         G5K/Fu8dgEYESSgnb3yomS0eUa5z6DTHd9sy+nfLSEIxBsm8yjl7HT85sqjkFVWVimRz
         cr1oK/FtKtnYJ3Xd7xggvgfnUcYf15fWoVlBLUN7P9bXNJYYmdDF3ESN3/gubPKmXrIx
         b717SDMcc9V02KLW+0woKoYsMzO6wT30+hGPmJv2XHEOXNha/trpBTZdAJRn9JKA/vdt
         j76Zli5u1HhRM68iyGSqiz1RJT1xvLm5iEg2I8fj3LZJKiskVMtH6wK0F93Z7p0fwGJ8
         2Ksw==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello,

I detected a performance degradation issue for a benchmark of PostgresSQL [1],
and the issue seems to be related to object level memory cgroup [2].
I would appreciate it if you could give me some ideas to solve it.

The benchmark shows the transaction per second (tps) and the tps for v5.9
and later kernel get about 10%-20% smaller than v5.8.

The benchmark does sendto() and recvfrom() system calls repeatedly,
and the duration of the system calls get longer than v5.8.
The result of perf trace of the benchmark is as follows:

  - v5.8

   syscall            calls  errors  total       min       avg       max       stddev
                                     (msec)    (msec)    (msec)    (msec)        (%)
   --------------- --------  ------ -------- --------- --------- ---------     ------
   sendto            699574      0  2595.220     0.001     0.004     0.462      0.03%
   recvfrom         1391089 694427  2163.458     0.001     0.002     0.442      0.04%

  - v5.9

   syscall            calls  errors  total       min       avg       max       stddev
                                     (msec)    (msec)    (msec)    (msec)        (%)
   --------------- --------  ------ -------- --------- --------- ---------     ------
   sendto            699187      0  3316.948     0.002     0.005     0.044      0.02%
   recvfrom         1397042 698828  2464.995     0.001     0.002     0.025      0.04%

  - v5.12-rc6

   syscall            calls  errors  total       min       avg       max       stddev
                                     (msec)    (msec)    (msec)    (msec)        (%)
   --------------- --------  ------ -------- --------- --------- ---------     ------
   sendto            699445      0  3015.642     0.002     0.004     0.027      0.02%
   recvfrom         1395929 697909  2338.783     0.001     0.002     0.024      0.03%

I bisected the kernel patches, then I found the patch series, which add
object level memory cgroup support, causes the degradation.

I confirmed the delay with a kernel module which just runs
kmem_cache_alloc/kmem_cache_free as follows. The duration is about
2-3 times than v5.8.

   dummy_cache = KMEM_CACHE(dummy, SLAB_ACCOUNT);
   for (i = 0; i < 100000000; i++)
   {
           p = kmem_cache_alloc(dummy_cache, GFP_KERNEL);
           kmem_cache_free(dummy_cache, p);
   }

It seems that the object accounting work in slab_pre_alloc_hook() and
slab_post_alloc_hook() is the overhead.

cgroup.nokmem kernel parameter doesn't work for my case because it disables
all of kmem accounting.

The degradation is gone when I apply a patch (at the bottom of this email)
that adds a kernel parameter that expects to fallback to the page level
accounting, however, I'm not sure it's a good approach though...

I use the kernel config which is based on Fedora33 kernel.
The related configs are as follows:

  CONFIG_CGROUPS=y
  CONFIG_MEMCG=y
  CONFIG_MEMCG_KMEM=y
  CONFIG_SLUB=y

I would appreciate it if you could give me advices and ideas to
reduce the overhead.

[1]: https://www.postgresql.org/docs/10/pgbench.html
[2]: https://lore.kernel.org/linux-mm/20200623174037.3951353-1-guro-b10kYP2dOMg@public.gmane.org/

---
 include/linux/memcontrol.h |  2 ++
 mm/memcontrol.c            | 10 ++++++++++
 mm/slab.h                  |  9 +++++++++
 3 files changed, 21 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0c04d39a7967..d447bfc8cf5e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1597,6 +1597,8 @@ extern int memcg_nr_cache_ids;
 void memcg_get_cache_ids(void);
 void memcg_put_cache_ids(void);
 
+extern bool memcg_obj_account_disabled;
+
 /*
  * Helper macro to loop through all memcg-specific caches. Callers must still
  * check if the cache is valid (it is either valid or NULL).
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e064ac0d850a..cc07d89bc449 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -400,6 +400,16 @@ void memcg_put_cache_ids(void)
  */
 DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
+
+bool memcg_obj_account_disabled __read_mostly;
+
+static int __init memcg_obj_account_disable(char *s)
+{
+	memcg_obj_account_disabled = true;
+	pr_debug("object memory cgroup account disabled\n");
+	return 1;
+}
+__setup("cgroup.nomemobj", memcg_obj_account_disable);
 #endif
 
 static int memcg_shrinker_map_size;
diff --git a/mm/slab.h b/mm/slab.h
index 076582f58f68..7f7f7867f636 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -270,6 +270,9 @@ static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
 	if (!(flags & __GFP_ACCOUNT) && !(s->flags & SLAB_ACCOUNT))
 		return true;
 
+	if (memcg_obj_account_disabled)
+		return true;
+
 	objcg = get_obj_cgroup_from_current();
 	if (!objcg)
 		return true;
@@ -309,6 +312,9 @@ static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 	if (!memcg_kmem_enabled() || !objcg)
 		return;
 
+	if (memcg_obj_account_disabled)
+		return;
+
 	flags &= ~__GFP_ACCOUNT;
 	for (i = 0; i < size; i++) {
 		if (likely(p[i])) {
@@ -346,6 +352,9 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s_orig,
 	if (!memcg_kmem_enabled())
 		return;
 
+	if (memcg_obj_account_disabled)
+		return;
+
 	for (i = 0; i < objects; i++) {
 		if (unlikely(!p[i]))
 			continue;
-- 
2.27.0

Thanks!
Masa
