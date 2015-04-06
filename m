From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 48/49] mpage: make __mpage_writepage() honor cgroup writeback
Date: Mon,  6 Apr 2015 15:58:37 -0400
Message-ID: <1428350318-8215-49-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qi6fTLlBmmMn0loeK4Kt5MDFabz2aiXEo7lrLCuuRu4=;
        b=Dt8zo8n14Hgfob6THiewQCqQnNpMFEX/qteOuByRqcXkCz+Od038MWNbn9cJNNwK6v
         FFIwQWv9O22AcIgPamQ2WO5qrQZJJNzbeDk5hhpx/qtcxSdhgxFhM6pXQ76b3okxN1p0
         DiFYl4Wv1xXieLInitMIXgZ+zMu82kkrZktksD37sU/tvIyHtAAeDCSiiu/gXfAR7lvh
         4PgUNtNMTA2KohA8tNgsne8Xy7vl/e0xmtRa+8PxmvPVda955sosE2hi6KIvfJgkQI+h
         VyuZJAFfK5EqxgAHPNQLET1EUFDCNTLH+0d+DPQ1WPXFNJ9WNsHzt7j4DD3hDEcV/gsW
         Q7MQ==
In-Reply-To: <1428350318-8215-1-git-send-email-tj@kernel.org>
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
