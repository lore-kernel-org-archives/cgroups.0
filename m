From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Wed, 27 Mar 2013 18:32:23 +0100
Message-ID: <20130327173223.GQ16579@dhcp22.suse.cz>
References: <1364373399-17397-1-git-send-email-mhocko@suse.cz>
 <20130327145727.GD29052@cmpxchg.org>
 <20130327151104.GK16579@dhcp22.suse.cz>
 <51530E1E.3010100@parallels.com>
 <20130327153220.GL16579@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130327153220.GL16579-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 27-03-13 16:32:20, Michal Hocko wrote:
> On Wed 27-03-13 19:19:58, Glauber Costa wrote:
> > On 03/27/2013 07:11 PM, Michal Hocko wrote:
> > > On Wed 27-03-13 10:58:25, Johannes Weiner wrote:
> > >> On Wed, Mar 27, 2013 at 09:36:39AM +0100, Michal Hocko wrote:
> > > [...]
> > >>> +	/*
> > >>> +	 * kmem_cache_create_memcg duplicates the given name and
> > >>> +	 * cgroup_name for this name requires RCU context.
> > >>> +	 * This static temporary buffer is used to prevent from
> > >>> +	 * pointless shortliving allocation.
> > >>> +	 */
> > >>> +	if (!tmp_name) {
> > >>> +		tmp_name = kmalloc(PAGE_SIZE, GFP_KERNEL);
> > >>> +		WARN_ON_ONCE(!tmp_name);
> > >>
> > >> Just use the page allocator directly and get a free allocation failure
> > >> warning. 
> > > 
> > > WARN_ON_ONCE is probably pointless.
> > > 
> > >> Then again, order-0 pages are considered cheap enough that they never
> > >> even fail in our current implementation.
> > >>
> > >> Which brings me to my other point: why not just a simple single-page
> > >> allocation?
> > > 
> > > No objection from me. I was previously thinking about the "proper"
> > > size for something that is a file name. So I originally wanted to use
> > > PATH_MAX instead but ended up with PAGE_SIZE for reasons I do not
> > > remember now.
> > 
> > theoretically, this is PATH_MAX + max cache name.
> 
> So do you prefer kmalloc(PATH_MAX) or the page allocator directly as
> Johannes suggests? I agree tha kamlloc(PAGE_SIZE) looks weird.

Removed WARN_ON_ONCE as suggested by Johannes and kept kmalloc with
PATH_MAX used instead of PAGE_SIZE. I've kept Glauber's acked-by but I
can remove it.
---
From 982470e1dc60c84b89a00dae22ef209628887b98 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Wed, 27 Mar 2013 18:28:42 +0100
Subject: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()

As cgroup supports rename, it's unsafe to dereference dentry->d_name
without proper vfs locks. Fix this by using cgroup_name() rather than
dentry directly.

Also open code memcg_cache_name because it is called only from
kmem_cache_dup which frees the returned name right after
kmem_cache_create_memcg makes a copy of it. Such a short-lived
allocation doesn't make too much sense. So replace it by a static
buffer as kmem_cache_dup is called with memcg_cache_mutex.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Acked-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 mm/memcontrol.c |   63 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 53b8201..db81f2a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3214,52 +3214,53 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
 	schedule_work(&cachep->memcg_params->destroy);
 }
 
-static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
-{
-	char *name;
-	struct dentry *dentry;
-
-	rcu_read_lock();
-	dentry = rcu_dereference(memcg->css.cgroup->dentry);
-	rcu_read_unlock();
-
-	BUG_ON(dentry == NULL);
-
-	name = kasprintf(GFP_KERNEL, "%s(%d:%s)", s->name,
-			 memcg_cache_id(memcg), dentry->d_name.name);
-
-	return name;
-}
+/*
+ * This lock protects updaters, not readers. We want readers to be as fast as
+ * they can, and they will either see NULL or a valid cache value. Our model
+ * allow them to see NULL, in which case the root memcg will be selected.
+ *
+ * We need this lock because multiple allocations to the same cache from a non
+ * will span more than one worker. Only one of them can create the cache.
+ */
+static DEFINE_MUTEX(memcg_cache_mutex);
 
+/*
+ * Called with memcg_cache_mutex held
+ */
 static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
 					 struct kmem_cache *s)
 {
-	char *name;
 	struct kmem_cache *new;
+	static char *tmp_name = NULL;
 
-	name = memcg_cache_name(memcg, s);
-	if (!name)
-		return NULL;
+	lockdep_assert_held(&memcg_cache_mutex);
+
+	/*
+	 * kmem_cache_create_memcg duplicates the given name and
+	 * cgroup_name for this name requires RCU context.
+	 * This static temporary buffer is used to prevent from
+	 * pointless shortliving allocation.
+	 */
+	if (!tmp_name) {
+		tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
+		if (!tmp_name)
+			return NULL;
+	}
+
+	rcu_read_lock();
+	snprintf(tmp_name, PAGE_SIZE, "%s(%d:%s)", s->name,
+			 memcg_cache_id(memcg), cgroup_name(memcg->css.cgroup));
+	rcu_read_unlock();
 
-	new = kmem_cache_create_memcg(memcg, name, s->object_size, s->align,
+	new = kmem_cache_create_memcg(memcg, tmp_name, s->object_size, s->align,
 				      (s->flags & ~SLAB_PANIC), s->ctor, s);
 
 	if (new)
 		new->allocflags |= __GFP_KMEMCG;
 
-	kfree(name);
 	return new;
 }
 
-/*
- * This lock protects updaters, not readers. We want readers to be as fast as
- * they can, and they will either see NULL or a valid cache value. Our model
- * allow them to see NULL, in which case the root memcg will be selected.
- *
- * We need this lock because multiple allocations to the same cache from a non
- * will span more than one worker. Only one of them can create the cache.
- */
-static DEFINE_MUTEX(memcg_cache_mutex);
 static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 						  struct kmem_cache *cachep)
 {
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
