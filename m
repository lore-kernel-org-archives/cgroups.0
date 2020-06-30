From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH][next] blk-cgroup: clean up indentation
Date: Tue, 30 Jun 2020 16:54:41 +0100
Message-ID: <20200630155441.518850-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

There is a statement that is indented one level too deeply, fix it
by removing a tab.

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1ce94afc03bc..748c4b2a9273 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1837,7 +1837,7 @@ void blk_cgroup_bio_start(struct bio *bio)
 	 */
 	if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
 		bio_set_flag(bio, BIO_CGROUP_ACCT);
-			bis->cur.bytes[rwd] += bio->bi_iter.bi_size;
+		bis->cur.bytes[rwd] += bio->bi_iter.bi_size;
 	}
 	bis->cur.ios[rwd]++;
 
-- 
2.27.0

