From: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] blk-throttle: use READ/WRITE directly
Date: Wed, 16 Oct 2013 18:56:52 +0800
Message-ID: <1381921012-12114-1-git-send-email-zhiguohong@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=k46kPUpg224cKkXSOQxuhsiCidR+SI813p77KMTqNQo=;
        b=mmf6U/2Nm+lehvdym9xU7Kqv1f52dO7T/i2yqg6gjs7Ze+YMoPVZtFcrwRzBuBrdg6
         g7U88T6jRvISQs6nnLg7X6RhXhA8g2gijW9nqNiKOMhhiZVkUae/Wx+f33xaM381I1ps
         g6qNGrjU0DRt+kXQbkLoxbZbq//wZ62ytmUD5G7BvHk3BapcojzpspwXq07WX6q/8N8C
         eA0tQXZNZuWsrTWseGsWq0ouAbWhDdVMlgoZl+siw3jl8mShn9MgvWQRa++rog0KxNtk
         d2aI+Ooc5n4m5MPowiEJLle43LSZoELPc719OWJTIK7vslEfGjiZV/m59OR8A+fJmUsM
         mJ6Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

To save some instructions

Signed-off-by: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/blk-throttle.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8331aba..f4fb859 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1120,7 +1120,7 @@ static int throtl_dispatch_tg(struct throtl_grp *tg)
 	while ((bio = throtl_peek_queued(&sq->queued[READ])) &&
 	       tg_may_dispatch(tg, bio, NULL)) {
 
-		tg_dispatch_one_bio(tg, bio_data_dir(bio));
+		tg_dispatch_one_bio(tg, READ);
 		nr_reads++;
 
 		if (nr_reads >= max_nr_reads)
@@ -1130,7 +1130,7 @@ static int throtl_dispatch_tg(struct throtl_grp *tg)
 	while ((bio = throtl_peek_queued(&sq->queued[WRITE])) &&
 	       tg_may_dispatch(tg, bio, NULL)) {
 
-		tg_dispatch_one_bio(tg, bio_data_dir(bio));
+		tg_dispatch_one_bio(tg, WRITE);
 		nr_writes++;
 
 		if (nr_writes >= max_nr_writes)
@@ -1605,9 +1605,9 @@ static void tg_drain_bios(struct throtl_service_queue *parent_sq)
 		throtl_dequeue_tg(tg);
 
 		while ((bio = throtl_peek_queued(&sq->queued[READ])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio));
+			tg_dispatch_one_bio(tg, READ);
 		while ((bio = throtl_peek_queued(&sq->queued[WRITE])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio));
+			tg_dispatch_one_bio(tg, WRITE);
 	}
 }
 
-- 
1.8.1.2
