From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] blk-throtl: avoid double charge of bio IOPS due to split
Date: Mon, 10 Jan 2022 16:29:23 +0800
Message-ID: <1641803363-27550-1-git-send-email-brookxu.cn@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ZbHmoJTvhu1ZJHvYjVegih6S2199NdYzTfdyg0if26A=;
        b=HYBLvzRW8JYt51HdI/oGR7NhCjlv3HKUo+3R8MK/A2QmXDOpfeXDrE4OjEKm9hyr/f
         z5hX0nD3/ELjvCIWF3aW7LoLRpbBM3CKM9oC0yCAspprbuIglE0aPyjqcHkod9waOtca
         jACUuUUMU78auMMafwnfGwvnN7p3AZGIQrnJFXjhJgW9a6cjPA5f4TfMTLNcrk6/lSrj
         dBnOaXvOggkJTMyvlJqd2KtzgMZ/4mtVYVoAjFAQ2Bkc0sZySQB6oQ8/btLK5dPWlvZ/
         2ywGopmL+wwuf31otpzF9BsUiYay3Gy7Ib/XhmoOHpMu6jaer01guxfqSmTd4wrbNiol
         Fb3g==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

After commit 900e08075202("block: move queue enter logic into
blk_mq_submit_bio()"), submit_bio_checks() moved to __submit_bio_fops()
and blk_mq_submit_bio(). The IOs go through blk_mq_submit_bio()
may be splited before entering blk-throtl, so we need to check
whether the BIO is throttled, and only update the io_split_cnt
for the THROTTLED bio to avoid double charge.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/blk-throttle.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 39bb6e6..2b12fc7 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2049,6 +2049,9 @@ void blk_throtl_charge_bio_split(struct bio *bio)
 	struct throtl_service_queue *parent_sq;
 	bool rw = bio_data_dir(bio);
 
+	if (!bio_flagged(bio, BIO_THROTTLED))
+		return;
+
 	do {
 		if (!parent->has_rules[rw])
 			break;
-- 
1.8.3.1

