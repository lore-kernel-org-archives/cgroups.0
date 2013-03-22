From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Fri, 22 Mar 2013 10:31:41 +0100
Message-ID: <20130322093141.GE31457@dhcp22.suse.cz>
References: <514A60CD.60208@huawei.com>
 <20130321090849.GF6094@dhcp22.suse.cz>
 <20130321102257.GH6094@dhcp22.suse.cz>
 <514BB23E.70908@huawei.com>
 <20130322080749.GB31457@dhcp22.suse.cz>
 <514C1388.6090909@huawei.com>
 <514C14BF.3050009@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <514C14BF.3050009@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

On Fri 22-03-13 12:22:23, Glauber Costa wrote:
> On 03/22/2013 12:17 PM, Li Zefan wrote:
> >> GFP_TEMPORARY groups short lived allocations but the mem cache is not
> >> > an ideal candidate of this type of allocations..
> >> > 
> > I'm not sure I'm following you...
> > 
> > char *memcg_cache_name()
> > {
> > 	char *name = alloc();
> > 	return name;
> > }
> > 
> > kmem_cache_dup()
> > {
> > 	name = memcg_cache_name();
> > 	kmem_cache_create_memcg(name);
> > 	free(name);
> > }
> > 
> > Isn't this a short lived allocation?
> > 
> 
> Hi,
> 
> Thanks for identifying and fixing this.
> 
> Li is right. The cache name will live long, but this is because the
> slab/slub caches will strdup it internally. So the actual memcg
> allocation is short lived.

OK, I have totally missed that. Sorry about the confusion. Then all the
churn around the allocation is pointless, no?
What about:
---
From 7ed7f53bb597e8cb40d9ac91ce16142fb60f1e93 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 22 Mar 2013 10:22:54 +0100
Subject: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()

As cgroup supports rename, it's unsafe to dereference dentry->d_name
without proper vfs locks. Fix this by using cgroup_name() rather than
dentry directly.

Also open code memcg_cache_name because it is called only from
kmem_cache_dup which frees the returned name right after
kmem_cache_create_memcg makes a copy of it. Such a short-lived
allocation doesn't make too much sense. So replace it by a static
buffer as kmem_cache_dup is called with memcg_cache_mutex.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 53b8201..9452b56 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3214,40 +3214,29 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
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
-
+/*
+ * Called with memcg_cache_mutex held
+ */
 static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
 					 struct kmem_cache *s)
 {
 	char *name;
 	struct kmem_cache *new;
+	static char tmp_name[PAGE_SIZE];
 
-	name = memcg_cache_name(memcg, s);
-	if (!name)
-		return NULL;
+	lockdep_assert_held(&memcg_cache_mutex);
+
+	rcu_read_lock();
+	tmp_name = snprintf(tmp_name, sizeof(tmp_name), "%s(%d:%s)", s->name,
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
 
-- 
1.7.10.4


-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
