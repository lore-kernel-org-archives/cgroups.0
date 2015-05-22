From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 51/51] ext2: enable cgroup writeback support
Date: Fri, 22 May 2015 17:14:05 -0400
Message-ID: <1432329245-5844-52-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UfsaxijxrcTsGo3cB/zVhnq+kkOtHzGVrqCz9DoSuUQ=;
        b=jdvngrDoDllsTe0xt06rhck0Hrp4HXkMD0j93bNylsbEIb9PDUDZPPPJEyJSlLmdu3
         ywabkEwgWpsvz51Fta8ipFi/3674jjEt1oQq9Hrsrx7PTqJxxK8/jkRlLStUzwDR8LcW
         GnelWYfERb/f97vrrxk5fXnn8zud4+HQ7b6t61CRdI/EWJToiJ6dj8GJwwcP0Cqy73o3
         IE2eX5KG28NbfrHExf8dWPDxV9cb16I8AaWhW5GGZwxa+x0IBK1e64/0R+mxpY6AhKjR
         80bOdBlkUiOkSNhM3v3ar59U/NErIYpDKPw11ef1EiMWWfjDonGJbqYF4MWdXaWaE8yZ
         e+gQ==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org

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
2.4.0
