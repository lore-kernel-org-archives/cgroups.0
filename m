From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 48/48] ext2: enable cgroup writeback support
Date: Mon, 23 Mar 2015 00:54:59 -0400
Message-ID: <1427086499-15657-49-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y4aYNQ1Buh7bgCEqFGm9JIWYwJ5CnKzv7xnmzB9pkTQ=;
        b=CsLMqSDW5klDUAVmVwQEg6EbZnqO9hPSHs+oBTQmlOHjvN4MOCld7l5V2KWC1ERCmx
         G1pkqirPrYomL8k1poZ4vCuLcTdF/lOwNXdVIqipwZIvb7SaLKTyqRjC79QWBf0Hq/aW
         1v6oM7u/1EjXYLiiV4Fk0nbelt0F2mtRMHLRloGByxWEBwUHxEISFi27XP+wLjbtJ3T6
         JymengyjCj2HJWWt9MU0bm07PtZwsJvZgs4x5+iNebCRvxS3Lh0nc5g+BQT8ADgDkKRt
         maVbJXB3nNLvLpBJQXLp5K4K1ZU3NkI+19la7hyWkcJMileV5wt6mMFtR1EosXFDoh6s
         w4zw==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org

Writeback now supports cgroup writeback and the generic writeback,
buffer, libfs, and mpage helpers that ext2 uses are all updated to
work with cgroup writeback.

This patch enables cgroup writeback for ext2 by adding
FS_CGROUP_WRITEBACK to its ->fs_flags.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index d0e746e..549219d 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1543,7 +1543,7 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext2_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_CGROUP_WRITEBACK,
 };
 MODULE_ALIAS_FS("ext2");
 
-- 
2.1.0
