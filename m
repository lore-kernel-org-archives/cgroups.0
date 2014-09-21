From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH -mm 14/14] fs: make shrinker memcg aware
Date: Sun, 21 Sep 2014 19:14:46 +0400
Message-ID: <9569ab6091089fd8eee19744de0b6f4f278663b1.1411301245.git.vdavydov@parallels.com>
References: <cover.1411301245.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <cover.1411301245.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@gmail.com>, Suleiman Souhlal <suleiman@google.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

Now, to make any list_lru-based shrinker memcg aware we should only
initialize its list_lru as memcg-enabled. Let's do it for the general FS
shrinker (super_block::s_shrink) and mark it as memcg aware.

There are other FS-specific shrinkers that use list_lru for storing
objects, such as XFS and GFS2 dquot cache shrinkers, but since they
reclaim objects that are shared among different cgroups, there is no
point making them memcg aware.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 fs/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index a82e97b0b8b9..9c765d3a14f3 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -189,9 +189,9 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	INIT_HLIST_BL_HEAD(&s->s_anon);
 	INIT_LIST_HEAD(&s->s_inodes);
 
-	if (list_lru_init(&s->s_dentry_lru, false))
+	if (list_lru_init(&s->s_dentry_lru, true))
 		goto fail;
-	if (list_lru_init(&s->s_inode_lru, false))
+	if (list_lru_init(&s->s_inode_lru, true))
 		goto fail;
 
 	init_rwsem(&s->s_umount);
@@ -227,7 +227,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	s->s_shrink.scan_objects = super_cache_scan;
 	s->s_shrink.count_objects = super_cache_count;
 	s->s_shrink.batch = 1024;
-	s->s_shrink.flags = SHRINKER_NUMA_AWARE;
+	s->s_shrink.flags = SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE;
 	return s;
 
 fail:
-- 
1.7.10.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
