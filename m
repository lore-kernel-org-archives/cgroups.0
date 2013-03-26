From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Tue, 26 Mar 2013 12:35:58 +0400
Message-ID: <51515DEE.70105@parallels.com>
References: <514A60CD.60208@huawei.com> <20130321090849.GF6094@dhcp22.suse.cz> <20130321102257.GH6094@dhcp22.suse.cz> <514BB23E.70908@huawei.com> <20130322080749.GB31457@dhcp22.suse.cz> <514C1388.6090909@huawei.com> <514C14BF.3050009@parallels.com> <20130322093141.GE31457@dhcp22.suse.cz> <514EAC41.5050700@huawei.com> <20130325090629.GN2154@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------000309060002060402080600"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130325090629.GN2154@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

--------------000309060002060402080600
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

>>
>> I doubt it's a win to add 4K to kernel text size instead of adding
>> a few extra lines of code... but it's up to you.
> 
> I will leave the decision to Glauber. The updated version which uses
> kmalloc for the static buffer is bellow.
> 
I prefer to allocate dynamically here. But although I understand why we
need to call cgroup_name, I don't understand what is wrong with
kasprintf if we're going to allocate anyway. It will allocate a string
just big enough. A PAGE_SIZE'd allocation is a lot more likely to fail.

Now, if we really want to be smart here, we can do something like what
I've done for the slub attribute buffers, that can actually have very
long values.

allocate a small buffer that will hold 80 % > of the allocations (256
bytes should be enough for most cache names), and if the string is
bigger than this, we allocate. Once we allocate, we save it in a static
pointer and leave it there. The hope here is that we may be able to
live without ever allocating in many systems.

> +
> +	/*
> +	 * kmem_cache_create_memcg duplicates the given name and
> +	 * cgroup_name for this name requires RCU context.
> +	 * This static temporary buffer is used to prevent from
> +	 * pointless shortliving allocation.
> +	 */
The comment is also no longer true if you don't resort to a static buffer.

The following (untested) patch implements the idea I outlined above.

What do you guys think ?


--------------000309060002060402080600
Content-Type: text/x-patch;
	name="0001-memcg-fix-memcg_cache_name-to-use-cgroup_name.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-memcg-fix-memcg_cache_name-to-use-cgroup_name.patch"

From 9bbcc5e0e3da5200abdd3499806f356868481925 Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer@parallels.com>
Date: Tue, 26 Mar 2013 12:30:09 +0400
Subject: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()

As cgroup supports rename, it's unsafe to dereference dentry->d_name
without proper vfs locks. Fix this by using cgroup_name() rather than
dentry directly.

This patch also takes the opportunity to be smarter about string
allocation. Most strings related to cache names will be relatively
small, including with the addition of the memcg suffix. Therefore
we try our best to use a buffer that may hold all allocations. If
we can't, we allocate a page. And leave it there for the rest of
the life of the system. While this is slightly more code-complex,
it makes us run less into the risk of failed allocations, which
is always a good thing.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 mm/memcontrol.c | 73 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 29 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0f67257..1821d2f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3462,31 +3462,56 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
 	schedule_work(&cachep->memcg_params->destroy);
 }
 
-static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
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
+static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
+					 struct kmem_cache *s)
 {
-	char *name;
-	struct dentry *dentry;
+	const char *cgname; /* actual cache name */
+	char *name = NULL; /* actual cache name */
+	char buf[256]; /* stack buffer for small allocations */
+	int buf_len;
+	static char *buf_name; /* pointer to a page, if we ever need */
+	struct kmem_cache *new;
+
+	lockdep_assert_held(&memcg_cache_mutex);
 
 	rcu_read_lock();
-	dentry = rcu_dereference(memcg->css.cgroup->dentry);
+	cgname = cgroup_name(memcg->css.cgroup);
 	rcu_read_unlock();
 
-	BUG_ON(dentry == NULL);
-
-	name = kasprintf(GFP_KERNEL, "%s(%d:%s)", s->name,
-			 memcg_cache_id(memcg), dentry->d_name.name);
-
-	return name;
-}
-
-static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
-					 struct kmem_cache *s)
-{
-	char *name;
-	struct kmem_cache *new;
+	if (strlen(name) < sizeof(buf)) {
+		name = buf;
+		buf_len = 256;
+	} else if (buf_name != NULL) {
+		name = buf_name;
+		buf_len = PAGE_SIZE;
+	} else {
+		/*
+		 * We will now reuse this page, so no need to free that.  Will
+		 * only go away at root memcg destruction, although we could
+		 * free it when all non-root memcg goes away if we really
+		 * wanted the trouble.
+		 */
+		buf_name = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!buf_name)
+			return NULL;
+		name = buf_name;
+		buf_len = PAGE_SIZE;
+	}
 
-	name = memcg_cache_name(memcg, s);
-	if (!name)
+	if (snprintf(name, buf_len, "%s(%d:%s)", s->name,
+				memcg_cache_id(memcg), cgname))
 		return NULL;
 
 	new = kmem_cache_create_memcg(memcg, name, s->object_size, s->align,
@@ -3495,19 +3520,9 @@ static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
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
1.8.1.4


--------------000309060002060402080600--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
