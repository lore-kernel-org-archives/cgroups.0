From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] mm: fix page cache convergence regression
Date: Fri, 24 May 2019 11:31:48 -0400
Message-ID: <20190524153148.18481-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xax+Itit2redxrlh2xu6KH2UMjJ3BZeeSxkOY3WyROU=;
        b=z485kAr9blKJo6NBcbFr+fn20i1azeIo3+m7fUvokaeqRUDgcc0Eo9zWEeVNtRD1lh
         y8wnAE4K60RClRAnK0p7rP6oJCWY56aQWFQyaaetR3chFQKdoud5UkTqffwxDnZrBC1c
         AKlGkIuVvJuetDxg4BKn90i8pRVi3aL3y5jwHOYTBIpTXcGfK/RFsXGI6ixujey85UfO
         RtIEsCCVTd7dqNaA4HkMOE5TGlTeIruWEdryqC1zR9XDeidfqPF5zSyeCCEzzgzUgrO7
         /xBYTJd7bBwfT2YNxIrnTJ7MrR6t2ftIbdJShesXRo+8/jmZqk7VE/n94cYHv6ZpW0HQ
         6uOw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Since a28334862993 ("page cache: Finish XArray conversion"), on most
major Linux distributions, the page cache doesn't correctly transition
when the hot data set is changing, and leaves the new pages thrashing
indefinitely instead of kicking out the cold ones.

On a freshly booted, freshly ssh'd into virtual machine with 1G RAM
running stock Arch Linux:

[root@ham ~]# ./reclaimtest.sh
+ dd of=workingset-a bs=1M count=0 seek=600
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ ./mincore workingset-a
153600/153600 workingset-a
+ dd of=workingset-b bs=1M count=0 seek=600
+ cat workingset-b
+ cat workingset-b
+ cat workingset-b
+ cat workingset-b
+ ./mincore workingset-a workingset-b
104029/153600 workingset-a
120086/153600 workingset-b
+ cat workingset-b
+ cat workingset-b
+ cat workingset-b
+ cat workingset-b
+ ./mincore workingset-a workingset-b
104029/153600 workingset-a
120268/153600 workingset-b

workingset-b is a 600M file on a 1G host that is otherwise entirely
idle. No matter how often it's being accessed, it won't get cached.

While investigating, I noticed that the non-resident information gets
aggressively reclaimed - /proc/vmstat::workingset_nodereclaim. This is
a problem because a workingset transition like this relies on the
non-resident information tracked in the page cache tree of evicted
file ranges: when the cache faults are refaults of recently evicted
cache, we challenge the existing active set, and that allows a new
workingset to establish itself.

Tracing the shrinker that maintains this memory revealed that all page
cache tree nodes were allocated to the root cgroup. This is a problem,
because 1) the shrinker sizes the amount of non-resident information
it keeps to the size of the cgroup's other memory and 2) on most major
Linux distributions, only kernel threads live in the root cgroup and
everything else gets put into services or session groups:

[root@ham ~]# cat /proc/self/cgroup
0::/user.slice/user-0.slice/session-c1.scope

As a result, we basically maintain no non-resident information for the
workloads running on the system, thus breaking the caching algorithm.

Looking through the code, I found the culprit in the above-mentioned
patch: when switching from the radix tree to xarray, it dropped the
__GFP_ACCOUNT flag from the tree node allocations - the flag that
makes sure the allocated memory gets charged to and tracked by the
cgroup of the calling process - in this case, the one doing the fault.

To fix this, allow xarray users to specify per-tree gfp flags that
supplement the hardcoded gfp flags inside the xarray expansion code.
This is analogous to the radix tree API. Then restore the page cache
tree annotation that passes the __GFP_ACCOUNT flag during expansions.

With this patch applied, the page cache correctly converges on new
workingsets again after just a few iterations:

[root@ham ~]# ./reclaimtest.sh
+ dd of=workingset-a bs=1M count=0 seek=600
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ ./mincore workingset-a
153600/153600 workingset-a
+ dd of=workingset-b bs=1M count=0 seek=600
+ cat workingset-b
+ ./mincore workingset-a workingset-b
124607/153600 workingset-a
87876/153600 workingset-b
+ cat workingset-b
+ ./mincore workingset-a workingset-b
81313/153600 workingset-a
133321/153600 workingset-b
+ cat workingset-b
+ ./mincore workingset-a workingset-b
63036/153600 workingset-a
153600/153600 workingset-b

Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 fs/inode.c             | 1 +
 include/linux/xarray.h | 2 ++
 lib/xarray.c           | 8 ++++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index e9d18b2c3f91..3b454d2119c4 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -362,6 +362,7 @@ EXPORT_SYMBOL(inc_nlink);
 static void __address_space_init_once(struct address_space *mapping)
 {
 	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ);
+	mapping->i_pages.xa_gfp = __GFP_ACCOUNT;
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 0e01e6129145..cbbf76e4c973 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -292,6 +292,7 @@ struct xarray {
 	spinlock_t	xa_lock;
 /* private: The rest of the data structure is not to be used directly. */
 	gfp_t		xa_flags;
+	gfp_t		xa_gfp;
 	void __rcu *	xa_head;
 };
 
@@ -374,6 +375,7 @@ static inline void xa_init_flags(struct xarray *xa, gfp_t flags)
 {
 	spin_lock_init(&xa->xa_lock);
 	xa->xa_flags = flags;
+	xa->xa_gfp = 0;
 	xa->xa_head = NULL;
 }
 
diff --git a/lib/xarray.c b/lib/xarray.c
index 6be3acbb861f..324be9534861 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -298,6 +298,7 @@ bool xas_nomem(struct xa_state *xas, gfp_t gfp)
 		xas_destroy(xas);
 		return false;
 	}
+	gfp |= xas->xa->xa_gfp;
 	xas->xa_alloc = kmem_cache_alloc(radix_tree_node_cachep, gfp);
 	if (!xas->xa_alloc)
 		return false;
@@ -325,6 +326,7 @@ static bool __xas_nomem(struct xa_state *xas, gfp_t gfp)
 		xas_destroy(xas);
 		return false;
 	}
+	gfp |= xas->xa->xa_gfp;
 	if (gfpflags_allow_blocking(gfp)) {
 		xas_unlock_type(xas, lock_type);
 		xas->xa_alloc = kmem_cache_alloc(radix_tree_node_cachep, gfp);
@@ -358,8 +360,10 @@ static void *xas_alloc(struct xa_state *xas, unsigned int shift)
 	if (node) {
 		xas->xa_alloc = NULL;
 	} else {
-		node = kmem_cache_alloc(radix_tree_node_cachep,
-					GFP_NOWAIT | __GFP_NOWARN);
+		gfp_t gfp;
+
+		gfp = GFP_NOWAIT | __GFP_NOWARN | xas->xa->xa_gfp;
+		node = kmem_cache_alloc(radix_tree_node_cachep, gfp);
 		if (!node) {
 			xas_set_err(xas, -ENOMEM);
 			return NULL;
-- 
2.21.0

