From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 49/49] ext2: enable cgroup writeback support
Date: Mon,  6 Apr 2015 15:58:38 -0400
Message-ID: <1428350318-8215-50-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y4aYNQ1Buh7bgCEqFGm9JIWYwJ5CnKzv7xnmzB9pkTQ=;
        b=WegkvGTmGkkOzK1um6VPBh3ZQDV5vbER4As3oz/rggndk53u5U674rIQfVicpwB1uL
         XjTDajarI49larnT8CgdrdNpIIMtAVxq0F7ju77fvyYIiZW7X7ZyaXym8qQpDJZAYEO/
         5rFnN6IhA/Y0rDln6eHwQPaZP3QNF2+PI37r7U9EUVNkEidUr8OuVZzkCMBMrQVh3ikS
         fSOrxsg3H3wW72tnjGuzChGPPjHaV6/oU+J9QZn3ls7/2JaLAmVuHRByW+f087VB/ean
         BRSptCk4ClACf84hILGJ2jnPrTi5CiGP3a6UQvf6xiwH98iHyHhLwhVGN4104yhHBm8P
         JsRA==
In-Reply-To: <1428350318-8215-1-git-send-email-tj@kernel.org>
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
