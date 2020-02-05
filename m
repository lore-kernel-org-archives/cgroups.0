From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mm, memcg: fix build error around the usage of kmem_caches
Date: Wed,  5 Feb 2020 12:03:35 -0500
Message-ID: <1580922215-5272-1-git-send-email-laoar.shao@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BpKT67FLDttHow1r3K4wuKV8cB597M2lQmxM3PivZvk=;
        b=brNPJ8bc7c6wFuqJgrS1FFBkILkxYNu0YhqjEyJ1g6cXJT7J7RE1XxdExWiWTzVNQ2
         O16cxlFkBHFKZAdktZey/jmg6fFkZ393oJzaucgu9b8RGTBsTVlIHogCWnIw61Sg2yGu
         OdKiBSAx+cx2fGz9i5Lny5MWk+HwwyxwAicOtQ27Jf3PVoy21aOiJPxGG7qvtx805Ixi
         b+m5JOOUL1SI5HIQ5rhWj5JDMJXGEoTwcU7gSB5RKAmN6y09v+pYZtUyqmjzgI2NnutI
         eAadYYs8sScqxUHq1dOfRz6EMyFO8F/qMMatvhbXRCInJZcGuKBfleOiEc0lCCzbgcsJ
         /G3A==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

When I manually set default n to MEMCG_KMEM in init/Kconfig, bellow error
occurs,

mm/slab_common.c: In function 'memcg_slab_start':
mm/slab_common.c:1530:30: error: 'struct mem_cgroup' has no member named
'kmem_caches'
  return seq_list_start(&memcg->kmem_caches, *pos);
                              ^
mm/slab_common.c: In function 'memcg_slab_next':
mm/slab_common.c:1537:32: error: 'struct mem_cgroup' has no member named
'kmem_caches'
  return seq_list_next(p, &memcg->kmem_caches, pos);
                                ^
mm/slab_common.c: In function 'memcg_slab_show':
mm/slab_common.c:1551:16: error: 'struct mem_cgroup' has no member named
'kmem_caches'
  if (p == memcg->kmem_caches.next)
                ^
  CC      arch/x86/xen/smp.o
mm/slab_common.c: In function 'memcg_slab_start':
mm/slab_common.c:1531:1: warning: control reaches end of non-void function
[-Wreturn-type]
 }
 ^
mm/slab_common.c: In function 'memcg_slab_next':
mm/slab_common.c:1538:1: warning: control reaches end of non-void function
[-Wreturn-type]
 }
 ^

That's because kmem_caches is defined only when CONFIG_MEMCG_KMEM is set,
while memcg_slab_start() will use it no matter CONFIG_MEMCG_KMEM is defined
or not.

By the way, the reason I mannuly undefined CONFIG_MEMCG_KMEM is to verify
whether my some other code change is still stable when CONFIG_MEMCG_KMEM is
not set. Unfortunately, the existing code has been already unstable since
v4.11.

Fixes: bc2791f857e1 ("slab: link memcg kmem_caches on their associated memory cgroup")
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c  | 2 ++
 mm/slab_common.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6f6dc8712e39..43f0125b45bb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4723,6 +4723,7 @@ static struct cftype mem_cgroup_legacy_files[] = {
 		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
+#ifdef CONFIG_MEMCG_KMEM
 #if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
 	{
 		.name = "kmem.slabinfo",
@@ -4731,6 +4732,7 @@ static struct cftype mem_cgroup_legacy_files[] = {
 		.seq_stop = memcg_slab_stop,
 		.seq_show = memcg_slab_show,
 	},
+#endif
 #endif
 	{
 		.name = "kmem.tcp.limit_in_bytes",
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 1907cb2903c7..5282f881d2f5 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1521,7 +1521,7 @@ void dump_unreclaimable_slab(void)
 	mutex_unlock(&slab_mutex);
 }
 
-#if defined(CONFIG_MEMCG)
+#if defined(CONFIG_MEMCG_KMEM)
 void *memcg_slab_start(struct seq_file *m, loff_t *pos)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-- 
2.14.1

