From: Glauber Costa <glommer@openvz.org>
Subject: [PATCH v6 16/31] drivers: convert shrinkers to new count/scan API
Date: Sun, 12 May 2013 22:13:37 +0400
Message-ID: <1368382432-25462-17-git-send-email-glommer@openvz.org>
References: <1368382432-25462-1-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1368382432-25462-1-git-send-email-glommer@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Kent Overstreet <koverstreet@google.com>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, John Stultz <john.stultz@linaro.org>, David Rientjes <rientjes@google.com>, Jerome Glisse <jglisse@redhat.com>, Thomas Hellstrom <thellstrom@vmware.com>

From: Dave Chinner <dchinner@redhat.com>

Convert the driver shrinkers to the new API. Most changes are
compile tested only because I either don't have the hardware or it's
staging stuff.

FWIW, the md and android code is pretty good, but the rest of it
makes me want to claw my eyes out.  The amount of broken code I just
encountered is mind boggling.  I've added comments explaining what
is broken, but I fear that some of the code would be best dealt with
by being dragged behind the bike shed, burying in mud up to it's
neck and then run over repeatedly with a blunt lawn mower.

Special mention goes to the zcache/zcache2 drivers. They can't
co-exist in the build at the same time, they are under different
menu options in menuconfig, they only show up when you've got the
right set of mm subsystem options configured and so even compile
testing is an exercise in pulling teeth.  And that doesn't even take
into account the horrible, broken code...

[ glommer: fixes for i915, android lowmem, zcache, bcache ]
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Glauber Costa <glommer@openvz.org>
Acked-by: Mel Gorman <mgorman@suse.de>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Kent Overstreet <koverstreet@google.com>
CC: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
CC: John Stultz <john.stultz@linaro.org>
CC: David Rientjes <rientjes@google.com>
CC: Jerome Glisse <jglisse@redhat.com>
CC: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/i915/i915_dma.c           |  4 +-
 drivers/gpu/drm/i915/i915_gem.c           | 67 ++++++++++++++++++++++---=
------
 drivers/gpu/drm/ttm/ttm_page_alloc.c      | 48 ++++++++++++++--------
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c  | 55 ++++++++++++++++---------
 drivers/md/bcache/btree.c                 | 43 ++++++++++----------
 drivers/md/bcache/sysfs.c                 |  2 +-
 drivers/md/dm-bufio.c                     | 65 +++++++++++++++++++------=
-----
 drivers/staging/android/ashmem.c          | 45 ++++++++++++++-------
 drivers/staging/android/lowmemorykiller.c | 40 ++++++++++--------
 drivers/staging/zcache/zcache-main.c      | 29 ++++++++-----
 10 files changed, 256 insertions(+), 142 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_=
dma.c
index 3b315ba..cfe3373 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1669,7 +1669,7 @@ int i915_driver_load(struct drm_device *dev, unsign=
ed long flags)
 	return 0;
=20
 out_gem_unload:
-	if (dev_priv->mm.inactive_shrinker.shrink)
+	if (dev_priv->mm.inactive_shrinker.scan_objects)
 		unregister_shrinker(&dev_priv->mm.inactive_shrinker);
=20
 	if (dev->pdev->msi_enabled)
@@ -1705,7 +1705,7 @@ int i915_driver_unload(struct drm_device *dev)
=20
 	i915_teardown_sysfs(dev);
=20
-	if (dev_priv->mm.inactive_shrinker.shrink)
+	if (dev_priv->mm.inactive_shrinker.scan_objects)
 		unregister_shrinker(&dev_priv->mm.inactive_shrinker);
=20
 	mutex_lock(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_=
gem.c
index 6165535..6b17122 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -53,10 +53,12 @@ static void i915_gem_object_update_fence(struct drm_i=
915_gem_object *obj,
 					 struct drm_i915_fence_reg *fence,
 					 bool enable);
=20
-static int i915_gem_inactive_shrink(struct shrinker *shrinker,
+static long i915_gem_inactive_count(struct shrinker *shrinker,
 				    struct shrink_control *sc);
+static long i915_gem_inactive_scan(struct shrinker *shrinker,
+				   struct shrink_control *sc);
 static long i915_gem_purge(struct drm_i915_private *dev_priv, long targe=
t);
-static void i915_gem_shrink_all(struct drm_i915_private *dev_priv);
+static long i915_gem_shrink_all(struct drm_i915_private *dev_priv);
 static void i915_gem_object_truncate(struct drm_i915_gem_object *obj);
=20
 static inline void i915_gem_object_fence_lost(struct drm_i915_gem_object=
 *obj)
@@ -1729,15 +1731,20 @@ i915_gem_purge(struct drm_i915_private *dev_priv,=
 long target)
 	return __i915_gem_shrink(dev_priv, target, true);
 }
=20
-static void
+static long
 i915_gem_shrink_all(struct drm_i915_private *dev_priv)
 {
 	struct drm_i915_gem_object *obj, *next;
+	long freed =3D 0;
=20
 	i915_gem_evict_everything(dev_priv->dev);
=20
-	list_for_each_entry_safe(obj, next, &dev_priv->mm.unbound_list, gtt_lis=
t)
+	list_for_each_entry_safe(obj, next, &dev_priv->mm.unbound_list, gtt_lis=
t) {
+		if (obj->pages_pin_count =3D=3D 0)
+			freed +=3D obj->base.size >> PAGE_SHIFT;
 		i915_gem_object_put_pages(obj);
+	}
+	return freed;
 }
=20
 static int
@@ -4203,7 +4210,8 @@ i915_gem_load(struct drm_device *dev)
=20
 	dev_priv->mm.interruptible =3D true;
=20
-	dev_priv->mm.inactive_shrinker.shrink =3D i915_gem_inactive_shrink;
+	dev_priv->mm.inactive_shrinker.scan_objects =3D i915_gem_inactive_scan;
+	dev_priv->mm.inactive_shrinker.count_objects =3D i915_gem_inactive_coun=
t;
 	dev_priv->mm.inactive_shrinker.seeks =3D DEFAULT_SEEKS;
 	register_shrinker(&dev_priv->mm.inactive_shrinker);
 }
@@ -4426,8 +4434,8 @@ static bool mutex_is_locked_by(struct mutex *mutex,=
 struct task_struct *task)
 #endif
 }
=20
-static int
-i915_gem_inactive_shrink(struct shrinker *shrinker, struct shrink_contro=
l *sc)
+static long
+i915_gem_inactive_count(struct shrinker *shrinker, struct shrink_control=
 *sc)
 {
 	struct drm_i915_private *dev_priv =3D
 		container_of(shrinker,
@@ -4435,9 +4443,8 @@ i915_gem_inactive_shrink(struct shrinker *shrinker,=
 struct shrink_control *sc)
 			     mm.inactive_shrinker);
 	struct drm_device *dev =3D dev_priv->dev;
 	struct drm_i915_gem_object *obj;
-	int nr_to_scan =3D sc->nr_to_scan;
 	bool unlock =3D true;
-	int cnt;
+	long cnt;
=20
 	if (!mutex_trylock(&dev->struct_mutex)) {
 		if (!mutex_is_locked_by(&dev->struct_mutex, current))
@@ -4449,15 +4456,6 @@ i915_gem_inactive_shrink(struct shrinker *shrinker=
, struct shrink_control *sc)
 		unlock =3D false;
 	}
=20
-	if (nr_to_scan) {
-		nr_to_scan -=3D i915_gem_purge(dev_priv, nr_to_scan);
-		if (nr_to_scan > 0)
-			nr_to_scan -=3D __i915_gem_shrink(dev_priv, nr_to_scan,
-							false);
-		if (nr_to_scan > 0)
-			i915_gem_shrink_all(dev_priv);
-	}
-
 	cnt =3D 0;
 	list_for_each_entry(obj, &dev_priv->mm.unbound_list, gtt_list)
 		if (obj->pages_pin_count =3D=3D 0)
@@ -4470,3 +4468,36 @@ i915_gem_inactive_shrink(struct shrinker *shrinker=
, struct shrink_control *sc)
 		mutex_unlock(&dev->struct_mutex);
 	return cnt;
 }
+static long
+i915_gem_inactive_scan(struct shrinker *shrinker, struct shrink_control =
*sc)
+{
+	struct drm_i915_private *dev_priv =3D
+		container_of(shrinker,
+			     struct drm_i915_private,
+			     mm.inactive_shrinker);
+	struct drm_device *dev =3D dev_priv->dev;
+	int nr_to_scan =3D sc->nr_to_scan;
+	long freed;
+	bool unlock =3D true;
+
+	if (!mutex_trylock(&dev->struct_mutex)) {
+		if (!mutex_is_locked_by(&dev->struct_mutex, current))
+			return 0;
+
+		if (dev_priv->mm.shrinker_no_lock_stealing)
+			return 0;
+
+		unlock =3D false;
+	}
+
+	freed =3D i915_gem_purge(dev_priv, nr_to_scan);
+	if (freed < nr_to_scan)
+		freed +=3D __i915_gem_shrink(dev_priv, nr_to_scan,
+							false);
+	if (freed < nr_to_scan)
+		freed +=3D i915_gem_shrink_all(dev_priv);
+
+	if (unlock)
+		mutex_unlock(&dev->struct_mutex);
+	return freed;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/t=
tm_page_alloc.c
index bd2a3b4..83058a2 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -377,28 +377,28 @@ out:
 	return nr_free;
 }
=20
-/* Get good estimation how many pages are free in pools */
-static int ttm_pool_get_num_unused_pages(void)
-{
-	unsigned i;
-	int total =3D 0;
-	for (i =3D 0; i < NUM_POOLS; ++i)
-		total +=3D _manager->pools[i].npages;
-
-	return total;
-}
-
 /**
  * Callback for mm to request pool to reduce number of page held.
+ *
+ * XXX: (dchinner) Deadlock warning!
+ *
+ * ttm_page_pool_free() does memory allocation using GFP_KERNEL.  that m=
eans
+ * this can deadlock when called a sc->gfp_mask that is not equal to
+ * GFP_KERNEL.
+ *
+ * This code is crying out for a shrinker per pool....
  */
-static int ttm_pool_mm_shrink(struct shrinker *shrink,
-			      struct shrink_control *sc)
+static long
+ttm_pool_shrink_scan(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
 {
 	static atomic_t start_pool =3D ATOMIC_INIT(0);
 	unsigned i;
 	unsigned pool_offset =3D atomic_add_return(1, &start_pool);
 	struct ttm_page_pool *pool;
 	int shrink_pages =3D sc->nr_to_scan;
+	long freed =3D 0;
=20
 	pool_offset =3D pool_offset % NUM_POOLS;
 	/* select start pool in round robin fashion */
@@ -408,14 +408,30 @@ static int ttm_pool_mm_shrink(struct shrinker *shri=
nk,
 			break;
 		pool =3D &_manager->pools[(i + pool_offset)%NUM_POOLS];
 		shrink_pages =3D ttm_page_pool_free(pool, nr_free);
+		freed +=3D nr_free - shrink_pages;
 	}
-	/* return estimated number of unused pages in pool */
-	return ttm_pool_get_num_unused_pages();
+	return freed;
+}
+
+
+static long
+ttm_pool_shrink_count(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
+	unsigned i;
+	long count =3D 0;
+
+	for (i =3D 0; i < NUM_POOLS; ++i)
+		count +=3D _manager->pools[i].npages;
+
+	return count;
 }
=20
 static void ttm_pool_mm_shrink_init(struct ttm_pool_manager *manager)
 {
-	manager->mm_shrink.shrink =3D &ttm_pool_mm_shrink;
+	manager->mm_shrink.count_objects =3D &ttm_pool_shrink_count;
+	manager->mm_shrink.scan_objects =3D &ttm_pool_shrink_scan;
 	manager->mm_shrink.seeks =3D 1;
 	register_shrinker(&manager->mm_shrink);
 }
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/t=
tm/ttm_page_alloc_dma.c
index b8b3943..b3b4f99 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -918,19 +918,6 @@ int ttm_dma_populate(struct ttm_dma_tt *ttm_dma, str=
uct device *dev)
 }
 EXPORT_SYMBOL_GPL(ttm_dma_populate);
=20
-/* Get good estimation how many pages are free in pools */
-static int ttm_dma_pool_get_num_unused_pages(void)
-{
-	struct device_pools *p;
-	unsigned total =3D 0;
-
-	mutex_lock(&_manager->lock);
-	list_for_each_entry(p, &_manager->pools, pools)
-		total +=3D p->pool->npages_free;
-	mutex_unlock(&_manager->lock);
-	return total;
-}
-
 /* Put all pages in pages list to correct pool to wait for reuse */
 void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
 {
@@ -1002,18 +989,31 @@ EXPORT_SYMBOL_GPL(ttm_dma_unpopulate);
=20
 /**
  * Callback for mm to request pool to reduce number of page held.
+ *
+ * XXX: (dchinner) Deadlock warning!
+ *
+ * ttm_dma_page_pool_free() does GFP_KERNEL memory allocation, and so at=
tention
+ * needs to be paid to sc->gfp_mask to determine if this can be done or =
not.
+ * GFP_KERNEL memory allocation in a GFP_ATOMIC reclaim context woul dbe=
 really
+ * bad.
+ *
+ * I'm getting sadder as I hear more pathetical whimpers about needing p=
er-pool
+ * shrinkers
  */
-static int ttm_dma_pool_mm_shrink(struct shrinker *shrink,
-				  struct shrink_control *sc)
+static long
+ttm_dma_pool_shrink_scan(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
 {
 	static atomic_t start_pool =3D ATOMIC_INIT(0);
 	unsigned idx =3D 0;
 	unsigned pool_offset =3D atomic_add_return(1, &start_pool);
 	unsigned shrink_pages =3D sc->nr_to_scan;
 	struct device_pools *p;
+	long freed =3D 0;
=20
 	if (list_empty(&_manager->pools))
-		return 0;
+		return -1;
=20
 	mutex_lock(&_manager->lock);
 	pool_offset =3D pool_offset % _manager->npools;
@@ -1029,18 +1029,35 @@ static int ttm_dma_pool_mm_shrink(struct shrinker=
 *shrink,
 			continue;
 		nr_free =3D shrink_pages;
 		shrink_pages =3D ttm_dma_page_pool_free(p->pool, nr_free);
+		freed +=3D nr_free - shrink_pages;
+
 		pr_debug("%s: (%s:%d) Asked to shrink %d, have %d more to go\n",
 			 p->pool->dev_name, p->pool->name, current->pid,
 			 nr_free, shrink_pages);
 	}
 	mutex_unlock(&_manager->lock);
-	/* return estimated number of unused pages in pool */
-	return ttm_dma_pool_get_num_unused_pages();
+	return freed;
+}
+
+static long
+ttm_dma_pool_shrink_count(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
+	struct device_pools *p;
+	long count =3D 0;
+
+	mutex_lock(&_manager->lock);
+	list_for_each_entry(p, &_manager->pools, pools)
+		count +=3D p->pool->npages_free;
+	mutex_unlock(&_manager->lock);
+	return count;
 }
=20
 static void ttm_dma_pool_mm_shrink_init(struct ttm_pool_manager *manager=
)
 {
-	manager->mm_shrink.shrink =3D &ttm_dma_pool_mm_shrink;
+	manager->mm_shrink.count_objects =3D &ttm_dma_pool_shrink_count;
+	manager->mm_shrink.scan_objects =3D &ttm_dma_pool_shrink_scan;
 	manager->mm_shrink.seeks =3D 1;
 	register_shrinker(&manager->mm_shrink);
 }
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 36688d6..e305f96 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -599,24 +599,12 @@ static int mca_reap(struct btree *b, struct closure=
 *cl, unsigned min_order)
 	return 0;
 }
=20
-static int bch_mca_shrink(struct shrinker *shrink, struct shrink_control=
 *sc)
+static long bch_mca_scan(struct shrinker *shrink, struct shrink_control =
*sc)
 {
 	struct cache_set *c =3D container_of(shrink, struct cache_set, shrink);
 	struct btree *b, *t;
 	unsigned long i, nr =3D sc->nr_to_scan;
-
-	if (c->shrinker_disabled)
-		return 0;
-
-	if (c->try_harder)
-		return 0;
-
-	/*
-	 * If nr =3D=3D 0, we're supposed to return the number of items we have
-	 * cached. Not allowed to return -1.
-	 */
-	if (!nr)
-		return mca_can_free(c) * c->btree_pages;
+	long freed =3D 0;
=20
 	/* Return -1 if we can't do anything right now */
 	if (sc->gfp_mask & __GFP_WAIT)
@@ -629,14 +617,14 @@ static int bch_mca_shrink(struct shrinker *shrink, =
struct shrink_control *sc)
=20
 	i =3D 0;
 	list_for_each_entry_safe(b, t, &c->btree_cache_freeable, list) {
-		if (!nr)
+		if (freed >=3D nr)
 			break;
=20
 		if (++i > 3 &&
 		    !mca_reap(b, NULL, 0)) {
 			mca_data_free(b);
 			rw_unlock(true, b);
-			--nr;
+			freed++;
 		}
 	}
=20
@@ -647,7 +635,7 @@ static int bch_mca_shrink(struct shrinker *shrink, st=
ruct shrink_control *sc)
 	if (list_empty(&c->btree_cache))
 		goto out;
=20
-	for (i =3D 0; nr && i < c->bucket_cache_used; i++) {
+	for (i =3D 0; i < c->bucket_cache_used; i++) {
 		b =3D list_first_entry(&c->btree_cache, struct btree, list);
 		list_rotate_left(&c->btree_cache);
=20
@@ -656,14 +644,26 @@ static int bch_mca_shrink(struct shrinker *shrink, =
struct shrink_control *sc)
 			mca_bucket_free(b);
 			mca_data_free(b);
 			rw_unlock(true, b);
-			--nr;
+			freed++;
 		} else
 			b->accessed =3D 0;
 	}
 out:
-	nr =3D mca_can_free(c) * c->btree_pages;
 	mutex_unlock(&c->bucket_lock);
-	return nr;
+	return freed;
+}
+
+static long bch_mca_count(struct shrinker *shrink, struct shrink_control=
 *sc)
+{
+	struct cache_set *c =3D container_of(shrink, struct cache_set, shrink);
+
+	if (c->shrinker_disabled)
+		return 0;
+
+	if (c->try_harder)
+		return 0;
+
+	return mca_can_free(c) * c->btree_pages;
 }
=20
 void bch_btree_cache_free(struct cache_set *c)
@@ -732,7 +732,8 @@ int bch_btree_cache_alloc(struct cache_set *c)
 		c->verify_data =3D NULL;
 #endif
=20
-	c->shrink.shrink =3D bch_mca_shrink;
+	c->shrink.count_objects =3D bch_mca_count;
+	c->shrink.scan_objects =3D bch_mca_scan;
 	c->shrink.seeks =3D 4;
 	c->shrink.batch =3D c->btree_pages * 2;
 	register_shrinker(&c->shrink);
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 4d9cca4..fa8d048 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -535,7 +535,7 @@ STORE(__bch_cache_set)
 		struct shrink_control sc;
 		sc.gfp_mask =3D GFP_KERNEL;
 		sc.nr_to_scan =3D strtoul_or_return(buf);
-		c->shrink.shrink(&c->shrink, &sc);
+		c->shrink.scan_objects(&c->shrink, &sc);
 	}
=20
 	sysfs_strtoul(congested_read_threshold_us,
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index d489dfd..cdafc63 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1383,62 +1383,80 @@ static int __cleanup_old_buffer(struct dm_buffer =
*b, gfp_t gfp,
 				unsigned long max_jiffies)
 {
 	if (jiffies - b->last_accessed < max_jiffies)
-		return 1;
+		return 0;
=20
 	if (!(gfp & __GFP_IO)) {
 		if (test_bit(B_READING, &b->state) ||
 		    test_bit(B_WRITING, &b->state) ||
 		    test_bit(B_DIRTY, &b->state))
-			return 1;
+			return 0;
 	}
=20
 	if (b->hold_count)
-		return 1;
+		return 0;
=20
 	__make_buffer_clean(b);
 	__unlink_buffer(b);
 	__free_buffer_wake(b);
=20
-	return 0;
+	return 1;
 }
=20
-static void __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
-		   struct shrink_control *sc)
+static long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
+		   gfp_t gfp_mask)
 {
 	int l;
 	struct dm_buffer *b, *tmp;
+	long freed =3D 0;
=20
 	for (l =3D 0; l < LIST_SIZE; l++) {
-		list_for_each_entry_safe_reverse(b, tmp, &c->lru[l], lru_list)
-			if (!__cleanup_old_buffer(b, sc->gfp_mask, 0) &&
-			    !--nr_to_scan)
-				return;
+		list_for_each_entry_safe_reverse(b, tmp, &c->lru[l], lru_list) {
+			freed +=3D __cleanup_old_buffer(b, gfp_mask, 0);
+			if (!--nr_to_scan)
+				break;
+		}
 		dm_bufio_cond_resched();
 	}
+	return freed;
 }
=20
-static int shrink(struct shrinker *shrinker, struct shrink_control *sc)
+static long
+dm_bufio_shrink_scan(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
 {
 	struct dm_bufio_client *c =3D
-	    container_of(shrinker, struct dm_bufio_client, shrinker);
-	unsigned long r;
-	unsigned long nr_to_scan =3D sc->nr_to_scan;
+	    container_of(shrink, struct dm_bufio_client, shrinker);
+	long freed;
=20
 	if (sc->gfp_mask & __GFP_IO)
 		dm_bufio_lock(c);
 	else if (!dm_bufio_trylock(c))
-		return !nr_to_scan ? 0 : -1;
+		return -1;
=20
-	if (nr_to_scan)
-		__scan(c, nr_to_scan, sc);
+	freed  =3D __scan(c, sc->nr_to_scan, sc->gfp_mask);
+	dm_bufio_unlock(c);
+	return freed;
+}
=20
-	r =3D c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];
-	if (r > INT_MAX)
-		r =3D INT_MAX;
+static long
+dm_bufio_shrink_count(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
+	struct dm_bufio_client *c =3D
+	    container_of(shrink, struct dm_bufio_client, shrinker);
+	long count;
+
+	if (sc->gfp_mask & __GFP_IO)
+		dm_bufio_lock(c);
+	else if (!dm_bufio_trylock(c))
+		return 0;
=20
+	count =3D c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];
 	dm_bufio_unlock(c);
+	return count;
=20
-	return r;
 }
=20
 /*
@@ -1540,7 +1558,8 @@ struct dm_bufio_client *dm_bufio_client_create(stru=
ct block_device *bdev, unsign
 	__cache_size_refresh();
 	mutex_unlock(&dm_bufio_clients_lock);
=20
-	c->shrinker.shrink =3D shrink;
+	c->shrinker.count_objects =3D dm_bufio_shrink_count;
+	c->shrinker.scan_objects =3D dm_bufio_shrink_scan;
 	c->shrinker.seeks =3D 1;
 	c->shrinker.batch =3D 0;
 	register_shrinker(&c->shrinker);
@@ -1627,7 +1646,7 @@ static void cleanup_old_buffers(void)
 			struct dm_buffer *b;
 			b =3D list_entry(c->lru[LIST_CLEAN].prev,
 				       struct dm_buffer, lru_list);
-			if (__cleanup_old_buffer(b, 0, max_age * HZ))
+			if (!__cleanup_old_buffer(b, 0, max_age * HZ))
 				break;
 			dm_bufio_cond_resched();
 		}
diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/a=
shmem.c
index 3240d34..951d944 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -341,27 +341,28 @@ out:
 /*
  * ashmem_shrink - our cache shrinker, called from mm/vmscan.c :: shrink=
_slab
  *
- * 'nr_to_scan' is the number of objects (pages) to prune, or 0 to query=
 how
- * many objects (pages) we have in total.
+ * 'nr_to_scan' is the number of objects to scan for freeing.
  *
  * 'gfp_mask' is the mask of the allocation that got us into this mess.
  *
- * Return value is the number of objects (pages) remaining, or -1 if we =
cannot
+ * Return value is the number of objects freed or -1 if we cannot
  * proceed without risk of deadlock (due to gfp_mask).
  *
  * We approximate LRU via least-recently-unpinned, jettisoning unpinned =
partial
  * chunks of ashmem regions LRU-wise one-at-a-time until we hit 'nr_to_s=
can'
  * pages freed.
  */
-static int ashmem_shrink(struct shrinker *s, struct shrink_control *sc)
+static long
+ashmem_shrink_scan(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
 {
 	struct ashmem_range *range, *next;
+	long freed =3D 0;
=20
 	/* We might recurse into filesystem code, so bail out if necessary */
-	if (sc->nr_to_scan && !(sc->gfp_mask & __GFP_FS))
+	if (!(sc->gfp_mask & __GFP_FS))
 		return -1;
-	if (!sc->nr_to_scan)
-		return lru_count;
=20
 	mutex_lock(&ashmem_mutex);
 	list_for_each_entry_safe(range, next, &ashmem_lru_list, lru) {
@@ -374,17 +375,34 @@ static int ashmem_shrink(struct shrinker *s, struct=
 shrink_control *sc)
 		range->purged =3D ASHMEM_WAS_PURGED;
 		lru_del(range);
=20
-		sc->nr_to_scan -=3D range_size(range);
-		if (sc->nr_to_scan <=3D 0)
+		freed +=3D range_size(range);
+		if (--sc->nr_to_scan <=3D 0)
 			break;
 	}
 	mutex_unlock(&ashmem_mutex);
+	return freed;
+}
=20
+static long
+ashmem_shrink_count(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
+	/*
+	 * note that lru_count is count of pages on the lru, not a count of
+	 * objects on the list. This means the scan function needs to return th=
e
+	 * number of pages freed, not the number of objects scanned.
+	 */
 	return lru_count;
 }
=20
 static struct shrinker ashmem_shrinker =3D {
-	.shrink =3D ashmem_shrink,
+	.count_objects =3D ashmem_shrink_count,
+	.scan_objects =3D ashmem_shrink_scan,
+	/*
+	 * XXX (dchinner): I wish people would comment on why they need on
+	 * significant changes to the default value here
+	 */
 	.seeks =3D DEFAULT_SEEKS * 4,
 };
=20
@@ -690,14 +708,11 @@ static long ashmem_ioctl(struct file *file, unsigne=
d int cmd, unsigned long arg)
 		if (capable(CAP_SYS_ADMIN)) {
 			struct shrink_control sc =3D {
 				.gfp_mask =3D GFP_KERNEL,
-				.nr_to_scan =3D 0,
+				.nr_to_scan =3D LONG_MAX,
 			};
=20
 			nodes_setall(sc.nodes_to_scan);
-
-			ret =3D ashmem_shrink(&ashmem_shrinker, &sc);
-			sc.nr_to_scan =3D ret;
-			ashmem_shrink(&ashmem_shrinker, &sc);
+			ashmem_shrink_scan(&ashmem_shrinker, &sc);
 		}
 		break;
 	}
diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/=
android/lowmemorykiller.c
index fe74494..d23bfea 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -66,7 +66,15 @@ static unsigned long lowmem_deathpending_timeout;
 			pr_info(x);			\
 	} while (0)
=20
-static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
+static long lowmem_count(struct shrinker *s, struct shrink_control *sc)
+{
+	return global_page_state(NR_ACTIVE_ANON) +
+		global_page_state(NR_ACTIVE_FILE) +
+		global_page_state(NR_INACTIVE_ANON) +
+		global_page_state(NR_INACTIVE_FILE);
+}
+
+static long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
 {
 	struct task_struct *tsk;
 	struct task_struct *selected =3D NULL;
@@ -92,19 +100,17 @@ static int lowmem_shrink(struct shrinker *s, struct =
shrink_control *sc)
 			break;
 		}
 	}
-	if (sc->nr_to_scan > 0)
-		lowmem_print(3, "lowmem_shrink %lu, %x, ofree %d %d, ma %hd\n",
-				sc->nr_to_scan, sc->gfp_mask, other_free,
-				other_file, min_score_adj);
-	rem =3D global_page_state(NR_ACTIVE_ANON) +
-		global_page_state(NR_ACTIVE_FILE) +
-		global_page_state(NR_INACTIVE_ANON) +
-		global_page_state(NR_INACTIVE_FILE);
-	if (sc->nr_to_scan <=3D 0 || min_score_adj =3D=3D OOM_SCORE_ADJ_MAX + 1=
) {
-		lowmem_print(5, "lowmem_shrink %lu, %x, return %d\n",
-			     sc->nr_to_scan, sc->gfp_mask, rem);
-		return rem;
+
+	lowmem_print(3, "lowmem_scan %lu, %x, ofree %d %d, ma %hd\n",
+			sc->nr_to_scan, sc->gfp_mask, other_free,
+			other_file, min_score_adj);
+
+	if (min_score_adj =3D=3D OOM_SCORE_ADJ_MAX + 1) {
+		lowmem_print(5, "lowmem_scan %lu, %x, return 0\n",
+			     sc->nr_to_scan, sc->gfp_mask);
+		return 0;
 	}
+
 	selected_oom_score_adj =3D min_score_adj;
=20
 	rcu_read_lock();
@@ -154,16 +160,18 @@ static int lowmem_shrink(struct shrinker *s, struct=
 shrink_control *sc)
 		lowmem_deathpending_timeout =3D jiffies + HZ;
 		send_sig(SIGKILL, selected, 0);
 		set_tsk_thread_flag(selected, TIF_MEMDIE);
-		rem -=3D selected_tasksize;
+		rem +=3D selected_tasksize;
 	}
-	lowmem_print(4, "lowmem_shrink %lu, %x, return %d\n",
+
+	lowmem_print(4, "lowmem_scan %lu, %x, return %d\n",
 		     sc->nr_to_scan, sc->gfp_mask, rem);
 	rcu_read_unlock();
 	return rem;
 }
=20
 static struct shrinker lowmem_shrinker =3D {
-	.shrink =3D lowmem_shrink,
+	.scan_objects =3D lowmem_scan,
+	.count_objects =3D lowmem_count,
 	.seeks =3D DEFAULT_SEEKS * 16
 };
=20
diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcach=
e/zcache-main.c
index 522cb8e..bbfcd4f 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1140,23 +1140,19 @@ static bool zcache_freeze;
  * pageframes in use.  FIXME POLICY: Probably the writeback should only =
occur
  * if the eviction doesn't free enough pages.
  */
-static int shrink_zcache_memory(struct shrinker *shrink,
-				struct shrink_control *sc)
+static long scan_zcache_memory(struct shrinker *shrink,
+			       struct shrink_control *sc)
 {
 	static bool in_progress;
-	int ret =3D -1;
-	int nr =3D sc->nr_to_scan;
 	int nr_evict =3D 0;
 	int nr_writeback =3D 0;
 	struct page *page;
 	int  file_pageframes_inuse, anon_pageframes_inuse;
-
-	if (nr <=3D 0)
-		goto skip_evict;
+	long freed =3D 0;
=20
 	/* don't allow more than one eviction thread at a time */
 	if (in_progress)
-		goto skip_evict;
+		return 0;
=20
 	in_progress =3D true;
=20
@@ -1176,6 +1172,7 @@ static int shrink_zcache_memory(struct shrinker *sh=
rink,
 		if (page =3D=3D NULL)
 			break;
 		zcache_free_page(page);
+		freed++;
 	}
=20
 	zcache_last_active_anon_pageframes =3D
@@ -1192,13 +1189,22 @@ static int shrink_zcache_memory(struct shrinker *=
shrink,
 #ifdef CONFIG_ZCACHE_WRITEBACK
 		int writeback_ret;
 		writeback_ret =3D zcache_frontswap_writeback();
-		if (writeback_ret =3D=3D -ENOMEM)
+		if (writeback_ret !=3D -ENOMEM)
+			freed++;
+		else
 #endif
 			break;
 	}
 	in_progress =3D false;
=20
-skip_evict:
+	return freed;
+}
+
+static long count_zcache_memory(struct shrinker *shrink,
+				struct shrink_control *sc)
+{
+	int ret =3D -1;
+
 	/* resample: has changed, but maybe not all the way yet */
 	zcache_last_active_file_pageframes =3D
 		global_page_state(NR_LRU_BASE + LRU_ACTIVE_FILE);
@@ -1212,7 +1218,8 @@ skip_evict:
 }
=20
 static struct shrinker zcache_shrinker =3D {
-	.shrink =3D shrink_zcache_memory,
+	.scan_objects =3D scan_zcache_memory,
+	.count_objects =3D count_zcache_memory,
 	.seeks =3D DEFAULT_SEEKS,
 };
=20
--=20
1.8.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
