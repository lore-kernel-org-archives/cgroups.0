From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 45/45] ext2: enable cgroup writeback support
Date: Tue,  6 Jan 2015 16:26:22 -0500
Message-ID: <1420579582-8516-46-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=di3Op3CLTZ1LwQ00+MSkg1cXEWkOuIa5D0bpSBz+BZE=;
        b=IxLsrJwN+9+M0TuIg6OMeB8hFHCjpUpCHE7tBMZrk6scur4S/2eLHZHyx7RqZ6EGMV
         49HRIfSW75VbW9vpAj9Mr0PdeEWV6gbONvETRMps3eDZctMn5XlbwvJ6G4I3YhvpxDfa
         czCawl1onCtSf+hlaqtsES0ZIYbi4pz/osoNzBYSrCLSvgmSztkS+9Of26xOeiwDwsmp
         jdWuzNMsPqngBiZxQZqs4nXDpTFzG5Xs8tkySIuQaa2pLWR2RBb4ArpneGlPs4Zb6GP/
         +NezrKeoslY+8sfa2oYtS33lUfC48DZFYTJwCjmzbst+hACM6I+f8ZEZl+17G3IwU12S
         KSWg==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org

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
index ae55fdd..dc3f27e 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1546,7 +1546,7 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext2_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_CGROUP_WRITEBACK,
 };
 MODULE_ALIAS_FS("ext2");
 
-- 
2.1.0

