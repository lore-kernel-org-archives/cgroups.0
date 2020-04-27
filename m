From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 3/4] mm/slub: Fix another circular locking dependency in slab_attr_store()
Date: Mon, 27 Apr 2020 19:56:20 -0400
Message-ID: <20200427235621.7823-4-longman@redhat.com>
References: <20200427235621.7823-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588031810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=hKMGvop5RUwWSaAIrxGf06+2WG92KPK2um2wWjE0aqI=;
        b=FgUaCwP5/4VVeP3CbMFUJg5qVFyi5aOIZ+d0dW4mbXXR4u7MmWFDuCvFdr7yJZPKMaSpBc
        rZ33PARjnls7yRfjBV9zNPEqnm60/Z/5LBXMAyQlwmjD92KSgUSptL2Yw05q8L7IQ/7wVy
        6aX1kAX+53fNi1jCA6qX+3uIREXwyVM=
In-Reply-To: <20200427235621.7823-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Qian Cai <cai@lca.pw>, Waiman Long <longman@redhat.com>

It turns out that switching from slab_mutex to memcg_cache_ids_sem in
slab_attr_store() does not completely eliminate circular locking dependency
as shown by the following lockdep splat when the system is shut down:

[ 2095.079697] Chain exists of:
[ 2095.079697]   kn->count#278 --> memcg_cache_ids_sem --> slab_mutex
[ 2095.079697]
[ 2095.090278]  Possible unsafe locking scenario:
[ 2095.090278]
[ 2095.096227]        CPU0                    CPU1
[ 2095.100779]        ----                    ----
[ 2095.105331]   lock(slab_mutex);
[ 2095.108486]                                lock(memcg_cache_ids_sem);
[ 2095.114961]                                lock(slab_mutex);
[ 2095.120649]   lock(kn->count#278);
[ 2095.124068]
[ 2095.124068]  *** DEADLOCK ***

To eliminate this possibility, we have to use trylock to acquire
memcg_cache_ids_sem. Unlikely slab_mutex which can be acquired in
many places, the memcg_cache_ids_sem write lock is only acquired
in memcg_alloc_cache_id() to double the size of memcg_nr_cache_ids.
So the chance of successive calls to memcg_alloc_cache_id() within
a short time is pretty low. As a result, we can retry the read lock
acquisition a few times if the first attempt fails.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            |  5 +++++
 mm/slub.c                  | 25 +++++++++++++++++++++++--
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d275c72c4f8e..9285f14965b1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1379,6 +1379,7 @@ extern struct workqueue_struct *memcg_kmem_cache_wq;
 extern int memcg_nr_cache_ids;
 void memcg_get_cache_ids(void);
 void memcg_put_cache_ids(void);
+int  memcg_tryget_cache_ids(void);
 
 /*
  * Helper macro to loop through all memcg-specific caches. Callers must still
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5beea03dd58a..9fa8535ff72a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -279,6 +279,11 @@ void memcg_get_cache_ids(void)
 	down_read(&memcg_cache_ids_sem);
 }
 
+int memcg_tryget_cache_ids(void)
+{
+	return down_read_trylock(&memcg_cache_ids_sem);
+}
+
 void memcg_put_cache_ids(void)
 {
 	up_read(&memcg_cache_ids_sem);
diff --git a/mm/slub.c b/mm/slub.c
index 44cb5215c17f..cf2114ca27f7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -34,6 +34,7 @@
 #include <linux/prefetch.h>
 #include <linux/memcontrol.h>
 #include <linux/random.h>
+#include <linux/delay.h>
 
 #include <trace/events/kmem.h>
 
@@ -5572,6 +5573,7 @@ static ssize_t slab_attr_store(struct kobject *kobj,
 	    !list_empty(&s->memcg_params.children)) {
 		struct kmem_cache *c, **pcaches;
 		int idx, max, cnt = 0;
+		int retries = 3;
 		size_t size, old = s->max_attr_size;
 		struct memcg_cache_array *arr;
 
@@ -5585,9 +5587,28 @@ static ssize_t slab_attr_store(struct kobject *kobj,
 			old = cmpxchg(&s->max_attr_size, size, len);
 		} while (old != size);
 
-		memcg_get_cache_ids();
-		max = memcg_nr_cache_ids;
+		/*
+		 * To avoid the following circular lock chain
+		 *
+		 *   kn->count#278 --> memcg_cache_ids_sem --> slab_mutex
+		 *
+		 * We need to use trylock to acquire memcg_cache_ids_sem.
+		 *
+		 * Since the write lock is acquired only in
+		 * memcg_alloc_cache_id() to double the size of
+		 * memcg_nr_cache_ids. The chance of successive
+		 * memcg_alloc_cache_id() calls within a short time is
+		 * very low except at the beginning where the number of
+		 * memory cgroups is low. So we retry a few times to get
+		 * the memcg_cache_ids_sem read lock.
+		 */
+		while (!memcg_tryget_cache_ids()) {
+			if (retries-- <= 0)
+				return -EBUSY;
+			msleep(100);
+		}
 
+		max = memcg_nr_cache_ids;
 		pcaches = kmalloc_array(max, sizeof(void *), GFP_KERNEL);
 		if (!pcaches) {
 			memcg_put_cache_ids();
-- 
2.18.1

