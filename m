From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/15] cfq-iosched: Get rid of unnecessary local variable
Date: Mon,  1 Oct 2012 15:32:46 -0400
Message-ID: <1349119976-26837-6-git-send-email-vgoyal@redhat.com>
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

Use of local varibale "n" seems to be unnecessary. Remove it. This brings
it inline with function __cfq_group_st_add(), which is also doing the
similar operation of adding a group to a rb tree.

No functionality change here.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9657924..573e668 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1655,8 +1655,6 @@ static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfqq->st = st;
 	p = &st->rb.rb_node;
 	while (*p) {
-		struct rb_node **n;
-
 		parent = *p;
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 
@@ -1664,13 +1662,11 @@ static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		 * sort by key, that represents service time.
 		 */
 		if (time_before(rb_key, __cfqq->rb_key))
-			n = &(*p)->rb_left;
+			p = &parent->rb_left;
 		else {
-			n = &(*p)->rb_right;
+			p = &parent->rb_right;
 			left = 0;
 		}
-
-		p = n;
 	}
 
 	if (left)
-- 
1.7.7.6
