From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 44/45] mpage: make __mpage_writepage() honor cgroup writeback
Date: Tue,  6 Jan 2015 16:26:21 -0500
Message-ID: <1420579582-8516-45-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r4EO6mI3xHOFRnn+yNVzTgCFcfpDdTtDovIMXrbqfbQ=;
        b=COai3s+oCvuNupkKjYpCLzTsi7RoYsdl2EfWoqQArkubjz3v5Dy8jCfkacJPV7LLqC
         qWBj6ZYQCPSpKBnaTHim76UrOwHh5zyx9A5cDen8LgSCHoG4clX1g9KuZQu+eOQl+sgO
         /pUoWTkOS4f+ajYjBQJj9O6+qoHNzd8n77WKauWv1qU4cr7D+Q4k5xtuzOLmQ7OJlfn/
         eCrIvHBMJZuoC7AvpdBMYOj4gMMIiary8rM0jDWFC8Pt+SAqJNRnl+8QLYV4Ya6wG6OQ
         OOOC3Cww7JByt1JrXI+RZFlhMaRbibvXlHeUseUbxO1ZUZcQxzGG28jHBuXpYmSCxvJJ
         IU3w==
In-Reply-To: <1420579582-8516-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

__mpage_writepage() is used to implement mpage_writepages() which in
turn is used for ->writepages() of various filesystems.  All writeback
logic is now updated to handle cgroup writeback and the block cgroup
to issue IOs for is encoded in writeback_control and can be retrieved
using wbc_blkcg_css(); however, __mpage_writepage() currently ignores
the blkcg indicated by wbc and issues all bio's without explicit blkcg
association.

This patch updates __mpage_writepage() so that the issued bio's are
associated with wbc_blkcg_css().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
---
 fs/mpage.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/mpage.c b/fs/mpage.c
index 587c7ed..84921b2 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -595,6 +595,8 @@ page_is_mapped:
 
 alloc_new:
 	if (bio == NULL) {
+		struct cgroup_subsys_state *blkcg_css;
+
 		if (first_unmapped == blocks_per_page) {
 			if (!bdev_write_page(bdev, blocks[0] << (blkbits - 9),
 								page, wbc)) {
@@ -606,6 +608,10 @@ alloc_new:
 				bio_get_nr_vecs(bdev), GFP_NOFS|__GFP_HIGH);
 		if (bio == NULL)
 			goto confused;
+
+		blkcg_css = wbc_blkcg_css(wbc);
+		if (blkcg_css)
+			bio_associate_blkcg(bio, blkcg_css);
 	}
 
 	/*
-- 
2.1.0
