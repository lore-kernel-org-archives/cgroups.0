Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394414908BF
	for <cgroups@vger.kernel.org>; Thu,  8 Oct 2026 13:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791464881; cv=none; b=Rbd1EXCTiZ6Lnau2D95ITn8k7uLqVKywIvo4LkZ4ZiyCB9V5Vnr58bfP9G6mL8Z0aXYmwEvh+L1Rx1vpe97W7wm3vqByuyIJ9FDZ1f5lsWvSXuP/7XAZIzxHKrA9Gju6zHe2sX8vJXEaFfGawQ6majvAwL2qZV9niuyvzzmW+ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791464881; c=relaxed/simple;
	bh=Gz9C11+9Zp58xNuRM2Vm21CGjXUuPrkVen+5nIPVuR4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XliklhCGN6O4SrTr9ihpgfOjVSeeHN3D6Dt6lmagtpSJQN6uQOET0TNXzV37Uf7lc3P8939Pt3hKJn7jJW1IHBbOvElrYhg3440ZKBfAk9uCrALzphz7Xv77W3ciPWeCzKXegOAosaCBmuPaleYjz+NLnYpagxwGLM5uHig2h7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=e6DqwodE; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="e6DqwodE"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cd1e069cb19so490524a12.0
        for <cgroups@vger.kernel.org>; Thu, 08 Oct 2026 06:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791464879; x=1792069679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LiXfPAQPFSbSP24ib82bI63pr5adZXqMwD4tgxbX+Go=;
        b=e6DqwodEuIfGl7LAT++BwV9yGOURUt9MIgIvkwW4ntGvNG1ifiA6OfaM6Uu8GDF0Ii
         M4PTW4CNQ2jRQP61lLKV6AWvE5fLqdwm1RBEG2F9pDXllqgtzYqgQFCGWhZxUHREsqmz
         vJE/ssuxD5PKqEwtHSVOXRktdl0fra3rRVd7fJTxHfqdENjVDsV9duuBljlvwWIj8EVG
         Swp99D36c4f40A5hEIscLqhASqYwkGjxSaGRF557Vrs6JUT2GiuBr5utPd8bv+Ki+5qF
         3pXMNrMUYImkrc8DTcFTR3r8LHhN8JqLKhD4rfrzgnvRP3VD4sucDCXdubVaWUuWfxIh
         7OOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791464879; x=1792069679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LiXfPAQPFSbSP24ib82bI63pr5adZXqMwD4tgxbX+Go=;
        b=Jd6QmhcJfR3nKtzXJlry5EK3KCh32wqDy2gRLXXbMoF5Eq5Z12fjNtfb0bhiMc64Le
         OMD9T7ehUBwSdAYqtAu3RZIim8BkIzo1f0jb391YSJRzDl+bQbCAn2m8LkgfRbkEMee9
         vlnMGgyGQIH2OPs6hjGzlpTmOuUIwFkwLxZFR83bzgnqstlzGPWY3c8T2zoyOc9kMPAQ
         24EElXzbw08G8HRLoI7cfDOhBkZSyRT10/+rS0h/HZemsYgf+mDdHRP1o0QgCO3fvMOJ
         sNcarSAEMwtz/wxtjQeZGY78N247EiLlNwjCdOMXhPbUS9gbLcuVy+hQRVKJ514jbJbd
         MkrA==
X-Forwarded-Encrypted: i=1; AKwUvBxErZxaZpmoL89TJvyJlPouMJNGuJqaeUlFy381f1YMxVuLyxqU/zAalFH5YM2Ckw2sIX8ppY81@vger.kernel.org
X-Gm-Message-State: AFq9FYJBtDoiS2Ngk++jxZ7rQ7BJJYyWyW/dTtzt8nqUlJyQ180idSe2
	7JBYN+867UHqihSWdw1TBmLcoh6GaXoyJp4+BE+oKcuIJfYnSMVBuNzB7RFflfAZZpo=
X-Gm-Gg: AYBFou0AgD9xHJDt/YGMQ1thjESGOsTt8RL3nL45gwTVenq4U9Wzfi6+a5Xr6AimvXj
	7rCV14zYGllbb+hVrC4OjqtPZSlf9m5C/fOtUQGkRX0dVgpCzvCvvs+qwsUKm5zb7CrQ8JsLzih
	R0bYE8nBP1qrnGfmLtXVs4m0JnT12EtZuV27aq03Ua54hfiTi6MFBTZhM/Or01dnpvr/xOyCuAr
	yTWpICdRbKfVOT5nngJI/G8aPKVvdhvOz/PAbnZ2SpPac8MwqRVkL9SXFLobyGlYCfpWvca8VnG
	B89oxKh+e2Ow/lAtCpLZQCxM3+j68yAU/nuCRLXCuyiYRhUaV5eWRa3KXRuZANxir38TH46uD5t
	yvzlYTEJwFFhQOEZMUCOOb/97pFDF3Jh/yy+N9sVVAdH3Z+6vf2/g+OxTBtBeZlXNDMbH75MlOF
	TxTiEU1MXfncL1i2xdu8cqrkDSOsXlu9WktSeCrRAAH2skfn/lVYX/I1mfn8RsTM15R4pXT4vZJ
	g==
X-Received: by 2002:a17:90b:5746:b0:3a4:b2e7:f01e with SMTP id 98e67ed59e1d1-3a8a1188428mr4342599a91.52.1791464874824;
        Thu, 08 Oct 2026 06:07:54 -0700 (PDT)
Received: from localhost ([106.38.226.37])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9d94ef876sm4168336a91.0.2026.10.08.06.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 06:07:54 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: axboe@kernel.dk,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	tj@kernel.org
Subject: [PATCH] fs: account filesystem bdev caches as kernel files
Date: Thu,  8 Oct 2026 21:07:47 +0800
Message-Id: <20261008130747.2868338-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Filesystems such as ext4 use buffer heads to cache shared metadata in
the bdev mapping. Charging these pages to individual memcgs can trigger
foreign writeback of the bdev inode's entire owner wb, including
unrelated file data.

Following the proposal in the linked discussion, set AS_KERNEL_FILE on
the bdev mapping while it is used by a filesystem, so newly allocated
cache pages are accounted to the root memcg. Empty the mapping before
changing the flag to keep folio insertion and removal accounting
consistent.

Multiple EROFS superblocks can share an extra data device. For example,
two metadata images on /dev/loop0 and /dev/loop1 can reference the same
data blob on /dev/loop2:

  mount -t erofs -o ro,device=/dev/loop2 /dev/loop0 /mnt/a
  mount -t erofs -o ro,device=/dev/loop2 /dev/loop1 /mnt/b

Unmounting /mnt/a must not clear AS_KERNEL_FILE on /dev/loop2 while
/mnt/b still uses it. Keep the flag set until the last filesystem user
releases the device.

bd_openers includes raw-device opens that may outlive filesystem
users, while bd_holders also counts partition claims on the whole
device. Neither counts filesystem users of this mapping, so add
bd_fs_users, protected by the bdev inode's i_rwsem.

Update this count in fs_bdev_register() and fs_bdev_unregister().
These hooks cover both device-open helpers and callers such as btrfs
that unregister a device and close it separately, without calling
fs_bdev_file_release().

Buffered access to the mounted raw device also charges new cache
pages to the root memcg. Such access is normally restricted to
privileged users. Pages cached in ordinary file mappings retain their
existing memcg accounting.

For filesystems that cache metadata in the bdev mapping, the benefit
is expected to be most pronounced when multiple cgroups perform
buffered overwrites alongside direct I/O on the same bandwidth-limited
device, such as an HDD. Frequent foreign writeback
reduces write coalescing, producing additional I/O that can saturate
the device. Direct I/O bypasses the page cache and competes with this
writeback traffic for device bandwidth.

An ext4 test combined repeated buffered overwrites of a 256 MiB file
with foreground direct writes, while four source memcgs generated
metadata and buffered writes. Device write bandwidth was capped at
200 MiB/s. In one baseline/patched pair, background file write I/O,
including final sync, fell from 6.178 GiB to 1.652 GiB (-73.3%).
Foreground bandwidth rose from 149.70 MiB/s to 184.19 MiB/s (+23.0%),
and completion time fell from 109.444 s to 88.951 s (-18.7%).

Link: https://lore.kernel.org/cgroups/20260925064444.3944820-1-sunjunchao@bytedance.com/T/#m55ee048deb0aad4d1f2293978f25ee6904a5725a
Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 block/bdev.c              |  2 +-
 fs/super.c                | 59 +++++++++++++++++++++++++++++++++++++--
 include/linux/blk_types.h |  1 +
 include/linux/blkdev.h    |  1 +
 4 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..766e170286ca 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -79,7 +79,7 @@ static void bdev_write_inode(struct block_device *bdev)
 }
 
 /* Kill _all_ buffers and pagecache , dirty or not.. */
-static void kill_bdev(struct block_device *bdev)
+void kill_bdev(struct block_device *bdev)
 {
 	struct address_space *mapping = bdev->bd_mapping;
 
diff --git a/fs/super.c b/fs/super.c
index 9d4025213521..7d271bb4cc6d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/memcontrol.h>
+#include <linux/pagemap.h>
 #include <linux/rhashtable.h>
 #include <linux/mount.h>
 #include <linux/security.h>
@@ -1644,6 +1645,55 @@ static struct super_dev *super_dev_lookup(dev_t dev, struct super_block *sb)
 	return NULL;
 }
 
+/*
+ * Filesystem metadata is shared across users and should be accounted to the
+ * root cgroup. Charging it to individual cgroups can trigger foreign writeback
+ * of the bdev inode's entire owner wb, including unrelated file data. For
+ * buffered overwrites, premature writeback reduces write coalescing and
+ * competes with foreground I/O, particularly on bandwidth-limited devices.
+ * This foreign writeback problem primarily affects filesystems such as
+ * ext4 that cache metadata in the bdev mapping using buffer heads.
+ *
+ * Raw buffered I/O also uses kernel-file accounting while a filesystem uses
+ * the device. This is independent of CONFIG_BLK_DEV_WRITE_MOUNTED: writes to
+ * a mounted device are dangerous administrative operations, and charging
+ * their cache to the root cgroup is acceptable.
+ */
+static void fs_bdev_set_kernel_file(struct block_device *bdev, bool enable)
+{
+	struct address_space *mapping = bdev->bd_mapping;
+	struct inode *inode = mapping->host;
+
+	inode_lock(inode);
+	/*
+	 * Multiple superblocks can share an extra device, as in EROFS.
+	 * Switch accounting only for the first user and the last release.
+	 * Raw openers may outlive all filesystem users, so bd_openers cannot
+	 * determine when to restore ordinary page-cache accounting.
+	 * Count at registration/unregistration: btrfs can unregister a device
+	 * and close it separately, bypassing fs_bdev_file_release().
+	 */
+	if (enable) {
+		if (bdev->bd_fs_users++)
+			goto out;
+	} else {
+		if (--bdev->bd_fs_users)
+			goto out;
+	}
+
+	filemap_invalidate_lock(mapping);
+	/* Folio removal must use the same accounting mode as insertion. */
+	sync_blockdev(bdev);
+	kill_bdev(bdev);
+	if (enable)
+		set_bit(AS_KERNEL_FILE, &mapping->flags);
+	else
+		clear_bit(AS_KERNEL_FILE, &mapping->flags);
+	filemap_invalidate_unlock(mapping);
+out:
+	inode_unlock(inode);
+}
+
 static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
 {
 	struct super_dev *sb_dev __free(kfree) = NULL;
@@ -1654,7 +1704,7 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
 		sb_dev = super_dev_lookup(dev, sb);
 		if (sb_dev && refcount_inc_not_zero(&sb_dev->sd_ref)) {
 			retain_and_null_ptr(sb_dev);
-			return 0;
+			goto registered;
 		}
 	}
 
@@ -1674,7 +1724,11 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
 	}
 
 	retain_and_null_ptr(sb_dev);
-	return err;
+	if (err)
+		return err;
+registered:
+	fs_bdev_set_kernel_file(file_bdev(bdev_file), true);
+	return 0;
 }
 
 /**
@@ -1765,6 +1819,7 @@ void fs_bdev_unregister(struct file *bdev_file, struct super_block *sb)
 	sb_dev = super_dev_lookup(dev, sb);
 	rcu_read_unlock();
 	super_dev_put(sb_dev);
+	fs_bdev_set_kernel_file(file_bdev(bdev_file), false);
 }
 EXPORT_SYMBOL_GPL(fs_bdev_unregister);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 98e21b4cbf32..19daea93bdec 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -58,6 +58,7 @@ struct block_device {
 	struct address_space	*bd_mapping;	/* page cache */
 
 	atomic_t		bd_openers;
+	unsigned int		bd_fs_users; /* Protected by bd_mapping->host->i_rwsem. */
 	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
 	void *			bd_claiming;
 	void *			bd_holder;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4f7905c3412b..f84dff95eae7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1706,6 +1706,7 @@ bool disk_live(struct gendisk *disk);
 unsigned int block_size(struct block_device *bdev);
 
 #ifdef CONFIG_BLOCK
+void kill_bdev(struct block_device *bdev);
 void invalidate_bdev(struct block_device *bdev);
 int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
-- 
2.39.5

