From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/9] cfq-iosched: fix oom cfq_queue ref leak in cfq_set_request()
Date: Tue,  7 Jul 2015 11:35:55 -0400
Message-ID: <1436283361-3889-4-git-send-email-tj@kernel.org>
References: <1436283361-3889-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aBRutXkLY0cEIN0fDiZ3wzVD5+L44RBs9R/T/py2pnA=;
        b=unwvGI9/2mMJTjmd3fE0cecti7rMtIDePDxbzq/TC5XMGnQRAE1NHuACIJlTeSgl/z
         SqNgy5l2Ngw8aqk3uKR30afxv8B0VZzzUoxA4+mCAhCAF1fLnySrNUcbAdbZTjp5p+jE
         nhjaEIFvm7M/O2ZbVOZm3Q9XL3J/+H9GgY+0dIhcP+J1EDHiVthjIFBVr8ujC24McdwP
         6PjxuUAgl51lj8hbZ9Zy93V/HaRb0Bc+/mZtmG4iuhKoGJCXO7kmBhNElq/8JOWRxdk0
         iS5vcM5WK+Bftr/muX2xa4qgZxfZzcLSK4E8oqlQ7k52gYEwnxXiYD5PVk0XutuWWwiz
         qQkg==
In-Reply-To: <1436283361-3889-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>, Arianna Avanzini <avanzini.arianna@gmail.com>

If the cfq_queue cached in cfq_io_cq is the oom one, cfq_set_request()
replaces it by invoking cfq_get_queue() again without putting the oom
queue leaking the reference it was holding.  While oom queues are not
released through reference counting, they're still reference counted
and this can theoretically lead to the reference count overflowing and
incorrectly invoke the usual release path on it.

Fix it by making cfq_set_request() put the ref it was holding.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 block/cfq-iosched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index baf0b70..8acfb7a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -4299,6 +4299,8 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
+		if (cfqq)
+			cfq_put_queue(cfqq);
 		cfqq = cfq_get_queue(cfqd, is_sync, cic, bio, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	} else {
-- 
2.4.3
