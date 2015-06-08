From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/8] cfq-iosched: fix oom cfq_queue ref leak in cfq_set_request()
Date: Mon,  8 Jun 2015 17:59:28 +0900
Message-ID: <1433753973-23684-4-git-send-email-tj@kernel.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XTC0SZcJyzFUxmwO2reurztz8ne7kFdWWHaRAK1Ho2E=;
        b=iuzoFzq6CBxJe0WdDTW6xcBDwr8Ea0YA4qsWX0AGLXDRbS6nQeBonEkQjp/ej21uGj
         r6Ia5xmMOqJfVNI68S3yLKERyssPZ2DXi1r2xeviJFY6qHUgAPr+WHY3ssZpj1+VtWzy
         zV2Ti0yfpzhQaN5lRVE/wMM7/r+gdvzj9zL9eyJkusPpOylui/RNoXa0r26yuGpN+Mti
         9IPxShofXzfiw3gJoOhXd8rmctxl3aqFfTN4twCJLIjOdySC6gXk6USTJvvU17Uk9hjY
         DEYGnPY92XZ6UwI3yf259pUHGfS0ycv41tL1aNwCro2lMReJqdj5mQH2pZ+UUkcUgsVD
         wX4A==
In-Reply-To: <1433753973-23684-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

If the cfq_queue cached in cfq_io_cq is the oom one, cfq_set_request()
replaces it by invoking cfq_get_queue() again without putting the oom
queue leaking the reference it was holding.  While oom queues are not
released through reference counting, they're still reference counted
and this can theoretically lead to the reference count overflowing and
incorrectly invoke the usual release path on it.

Fix it by making cfq_set_request() put the ref it was holding.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/cfq-iosched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index c7b33aa..e0a34ba 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -4231,6 +4231,8 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
+		if (cfqq)
+			cfq_put_queue(cfqq);
 		cfqq = cfq_get_queue(cfqd, is_sync, cic, bio, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	} else {
-- 
2.4.2
