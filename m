From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Mon, 25 Mar 2013 10:06:29 +0100
Message-ID: <20130325090629.GN2154@dhcp22.suse.cz>
References: <514A60CD.60208@huawei.com>
 <20130321090849.GF6094@dhcp22.suse.cz>
 <20130321102257.GH6094@dhcp22.suse.cz>
 <514BB23E.70908@huawei.com>
 <20130322080749.GB31457@dhcp22.suse.cz>
 <514C1388.6090909@huawei.com>
 <514C14BF.3050009@parallels.com>
 <20130322093141.GE31457@dhcp22.suse.cz>
 <514EAC41.5050700@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <514EAC41.5050700-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Sun 24-03-13 15:33:21, Li Zefan wrote:
> >> Thanks for identifying and fixing this.
> >>
> >> Li is right. The cache name will live long, but this is because the
> >> slab/slub caches will strdup it internally. So the actual memcg
> >> allocation is short lived.
> > 
> > OK, I have totally missed that. Sorry about the confusion. Then all the
> > churn around the allocation is pointless, no?
> > What about:
> > ---
> >>From 7ed7f53bb597e8cb40d9ac91ce16142fb60f1e93 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > Date: Fri, 22 Mar 2013 10:22:54 +0100
> > Subject: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
> > 
> > As cgroup supports rename, it's unsafe to dereference dentry->d_name
> > without proper vfs locks. Fix this by using cgroup_name() rather than
> > dentry directly.
> > 
> > Also open code memcg_cache_name because it is called only from
> > kmem_cache_dup which frees the returned name right after
> > kmem_cache_create_memcg makes a copy of it. Such a short-lived
> > allocation doesn't make too much sense. So replace it by a static
> > buffer as kmem_cache_dup is called with memcg_cache_mutex.
> > 
> 
> I doubt it's a win to add 4K to kernel text size instead of adding
> a few extra lines of code... but it's up to you.

I will leave the decision to Glauber. The updated version which uses
kmalloc for the static buffer is bellow.

> > Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > ---
> >  mm/memcontrol.c |   33 +++++++++++----------------------
> >  1 file changed, 11 insertions(+), 22 deletions(-)
> ...
> >  static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
> >  					 struct kmem_cache *s)
> >  {
> >  	char *name;
> >  	struct kmem_cache *new;
> > +	static char tmp_name[PAGE_SIZE];
> >  
> > -	name = memcg_cache_name(memcg, s);
> > -	if (!name)
> > -		return NULL;
> > +	lockdep_assert_held(&memcg_cache_mutex);
> > +
> > +	rcu_read_lock();
> > +	tmp_name = snprintf(tmp_name, sizeof(tmp_name), "%s(%d:%s)", s->name,
> > +			 memcg_cache_id(memcg), cgroup_name(memcg->css.cgroup));
> 
> I guess you didn't turn on CONFIG_MEMCG_KMEM?

dohh. Friday effect...

> snprintf() returns a int value.
[...]
---
From 6f5d4c08cde5c82ac9432608adf517916ab54634 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Mon, 25 Mar 2013 10:04:02 +0100
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
---
 mm/memcontrol.c |   64 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 53b8201..3a75f2c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3214,52 +3214,54 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
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
+		tmp_name = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		WARN_ON_ONCE(!tmp_name);
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
