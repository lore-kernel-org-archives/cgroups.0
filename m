From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 47/48] mpage: make __mpage_writepage() honor cgroup writeback
Date: Mon, 23 Mar 2015 00:54:58 -0400
Message-ID: <1427086499-15657-48-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qi6fTLlBmmMn0loeK4Kt5MDFabz2aiXEo7lrLCuuRu4=;
        b=PYVRCCQMnRYhw8247xzkFIoi8AHyA2jdKakA9sHHob7Yq0/fCv82Dd4to7JWP6bv+C
         IHhs9nLnM5P2wa0JRZZ9twBUAOkB/x7LxMkNdFUovfElrWyiGwcMeMm+AEusiDqnEmj5
         y+JgC96Qt81l0h3KvflcXbNsfY3FUqBnvM+NVD7DnCBLOB78cjy0rGGTLCSDSgHxfN+W
         EU3ryVFEYUl5KdX5Y7WXBIg3jH1whN9goiuPq56sPslk7nzd4QdR7Pv93doT+/HJdwfD
         5RdE4Js5uWzqlcaQti+4rexktim+5i20W2DE93ZhKBvxYrB/uAIv2ESqv+Rl6x1pqYVl
         N24A==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>

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
@@ -605,6 +605,8 @@ alloc_new:
 				bio_get_nr_vecs(bdev), GFP_NOFS|__GFP_HIGH);
 		if (bio == NULL)
 			goto confused;
+
+		bio_associate_blkcg(bio, inode_to_wb_blkcg_css(inode));
 	}
 
 	/*
-- 
2.1.0
