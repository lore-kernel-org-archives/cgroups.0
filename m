From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 09/19] zonefs: remove duplicate cleanup in zonefs_fill_super
Date: Wed, 13 Sep 2023 08:10:03 -0300
Message-ID: <20230913111013.77623-10-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qveFDVPX/ugxM2Qs1ozl01Z3CU43frG5SeTOC5Qmlyc=; b=B11guw1T4ocUFQYK2XEc78rKRR
        4BX2AUC9ts69y4WjCdC7i+Mm0E3i7DHSevrLRJOTcT7nNMf/XDVaZyoQnVLzmJr9jF98g0s2HcjHl
        DbTo2r+XXvTFwBSBFaGG2w+1saDxkxKG4pE7gudop41xIj6mNvgGcD8UcyammKEV8uEEb97jQmtCg
        0OMJ2aYT/Hh6qc0c91wqGJGePklhQDYXL/svyeUYQnkJuqKPKQ7S3d1MKIjMUiqMU4hBhDkCQhxlA
        SVqZAVS2ZngKlTfEuQROYXaxEv0DYzfaSX02U/1nXPOTh14k4sUpvBvjSs1v//ljzSbZ6oNBJrqRI
        o6AEoW8Q==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When ->fill_super fails, ->kill_sb is called which already cleans up
the inodes and zgroups.

Drop the extra cleanup code in zonefs_fill_super.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/zonefs/super.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 9d1a9808fbbba6..35b2554ce2ac2e 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1309,13 +1309,12 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	/* Initialize the zone groups */
 	ret = zonefs_init_zgroups(sb);
 	if (ret)
-		goto cleanup;
+		return ret;
 
 	/* Create the root directory inode */
-	ret = -ENOMEM;
 	inode = new_inode(sb);
 	if (!inode)
-		goto cleanup;
+		return -ENOMEM;
 
 	inode->i_ino = bdev_nr_zones(sb->s_bdev);
 	inode->i_mode = S_IFDIR | 0555;
@@ -1333,7 +1332,7 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_root = d_make_root(inode);
 	if (!sb->s_root)
-		goto cleanup;
+		return -ENOMEM;
 
 	/*
 	 * Take a reference on the zone groups directory inodes
@@ -1341,19 +1340,9 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	ret = zonefs_get_zgroup_inodes(sb);
 	if (ret)
-		goto cleanup;
-
-	ret = zonefs_sysfs_register(sb);
-	if (ret)
-		goto cleanup;
-
-	return 0;
-
-cleanup:
-	zonefs_release_zgroup_inodes(sb);
-	zonefs_free_zgroups(sb);
+		return ret;
 
-	return ret;
+	return zonefs_sysfs_register(sb);
 }
 
 static struct dentry *zonefs_mount(struct file_system_type *fs_type,
-- 
2.39.2

