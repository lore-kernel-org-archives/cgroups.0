From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH v13 09/16] fs: consolidate {nr,free}_cached_objects args in shrink_control
Date: Mon, 9 Dec 2013 12:05:50 +0400
Message-ID: <43660b83b58531ccf4d45f626283484441441943.1386571280.git.vdavydov@parallels.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <cover.1386571280.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dchinner@redhat.com, hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, glommer@openvz.org, glommer@gmail.com, vdavydov@parallels.com, Al Viro <viro@zeniv.linux.org.uk>

We are going to make the FS shrinker memcg-aware. To achieve that, we
will have to pass the memcg to scan to the nr_cached_objects and
free_cached_objects VFS methods, which currently take only the NUMA node
to scan. Since the shrink_control structure already holds the node, and
the memcg to scan will be added to it as we introduce memcg-aware
vmscan, let us consolidate the methods' arguments in this structure to
keep things clean.

Thanks to David Chinner for the tip.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/super.c         |    8 +++-----
 fs/xfs/xfs_super.c |    6 +++---
 include/linux/fs.h |    6 ++++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index a039dba..8f9a81b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -76,7 +76,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 		return SHRINK_STOP;
 
 	if (sb->s_op->nr_cached_objects)
-		fs_objects = sb->s_op->nr_cached_objects(sb, sc->nid);
+		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_count(&sb->s_inode_lru, sc);
 	dentries = list_lru_count(&sb->s_dentry_lru, sc);
@@ -96,8 +96,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	if (fs_objects) {
 		fs_objects = mult_frac(sc->nr_to_scan, fs_objects,
 								total_objects);
-		freed += sb->s_op->free_cached_objects(sb, fs_objects,
-						       sc->nid);
+		freed += sb->s_op->free_cached_objects(sb, sc, fs_objects);
 	}
 
 	drop_super(sb);
@@ -116,8 +115,7 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 		return 0;
 
 	if (sb->s_op && sb->s_op->nr_cached_objects)
-		total_objects = sb->s_op->nr_cached_objects(sb,
-						 sc->nid);
+		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_count(&sb->s_dentry_lru, sc);
 	total_objects += list_lru_count(&sb->s_inode_lru, sc);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f317488..06d155d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1524,7 +1524,7 @@ xfs_fs_mount(
 static long
 xfs_fs_nr_cached_objects(
 	struct super_block	*sb,
-	int			nid)
+	struct shrink_control	*sc)
 {
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
@@ -1532,8 +1532,8 @@ xfs_fs_nr_cached_objects(
 static long
 xfs_fs_free_cached_objects(
 	struct super_block	*sb,
-	long			nr_to_scan,
-	int			nid)
+	struct shrink_control	*sc,
+	long			nr_to_scan)
 {
 	return xfs_reclaim_inodes_nr(XFS_M(sb), nr_to_scan);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 121f11f..b367d54 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1619,8 +1619,10 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
-	long (*nr_cached_objects)(struct super_block *, int);
-	long (*free_cached_objects)(struct super_block *, long, int);
+	long (*nr_cached_objects)(struct super_block *,
+				  struct shrink_control *);
+	long (*free_cached_objects)(struct super_block *,
+				    struct shrink_control *, long);
 };
 
 /*
-- 
1.7.10.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
