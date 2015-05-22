From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 50/51] mpage: make __mpage_writepage() honor cgroup writeback
Date: Fri, 22 May 2015 17:14:04 -0400
Message-ID: <1432329245-5844-51-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uRsaEDP9nmh455/F+sCDNCaI6EnJuSqTsUGMBkr/ioY=;
        b=XkPxix89Yvez4JxzILedkMO9NU975D072l3ouggjhTs+smm5IciyI36ps321b1fglm
         MSV2XR4CoKzQwUqli/JxPIiStFyUFPSWcBUKj+D2F5i/1hpWfyBl4rVCWMAJ5y5y6cDk
         3EIq+gU7bHvpy1b5nhbzCC1LdDHyMTZp0EcY2RlF2H12W94GV9X6Ehj9wUS+FvRhFHFI
         pd4oAllK9350h7Eh4F+ANDn7YSlRoKARiStTW6GYjskFlpeyN8GYa2IeLm1GYIQKCt6L
         WpHuwZHIFdZ3nnfgRCUnp3mq9NPk/DNXj+v+7mkHk6i7TiNdZwv1P/baHP+sDRibr2vW
         j94g==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>

__mpage_writepage() is used to implement mpage_writepages() which in
turn is used for ->writepages() of various filesystems.  All writeback
logic is now updated to handle cgroup writeback and the block cgroup
to issue IOs for is encoded in writeback_control and can be retrieved
from the inode; however, __mpage_writepage() currently ignores the
blkcg indicated by the inode and issues all bio's without explicit
blkcg association.

This patch updates __mpage_writepage() so that the issued bio's are
associated with inode_to_writeback_blkcg_css(inode).

v2: Updated for per-inode wb association.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/mpage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/mpage.c b/fs/mpage.c
index 3e79220..a3ccb0b 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -605,6 +605,8 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 				bio_get_nr_vecs(bdev), GFP_NOFS|__GFP_HIGH);
 		if (bio == NULL)
 			goto confused;
+
+		bio_associate_blkcg(bio, inode_to_wb_blkcg_css(inode));
 	}
 
 	/*
-- 
2.4.0
