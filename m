From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/15] cfq-iosched: make new_cfqq variable bool
Date: Mon,  1 Oct 2012 15:32:50 -0400
Message-ID: <1349119976-26837-10-git-send-email-vgoyal@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349119976-26837-1-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Make new_cfqq bool. Also set the variable in the beginning of function.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a929e2d..76f020f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1622,7 +1622,7 @@ static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	unsigned long rb_key;
 	struct cfq_rb_root *st;
 	int left;
-	int new_cfqq = 1;
+	bool new_cfqq = RB_EMPTY_NODE(&cfqq->rb_node);
 
 	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
 	if (cfq_class_idle(cfqq)) {
@@ -1649,8 +1649,7 @@ static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
 	}
 
-	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
-		new_cfqq = 0;
+	if (!new_cfqq) {
 		/*
 		 * same position, nothing more to do
 		 */
-- 
1.7.7.6
