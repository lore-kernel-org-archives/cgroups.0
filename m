From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/15] cfq-iosched: Rename few functions related to selecting workload
Date: Mon,  1 Oct 2012 15:32:45 -0400
Message-ID: <1349119976-26837-5-git-send-email-vgoyal@redhat.com>
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

choose_st() selects/sets both wl_class and wl_type.  Rename it to
choose_wl_class_and_type() to make it very clear.

cfq_choose_wl() only selects and sets wl_type. It is easy to confuse
it with choose_st(). So rename it to cfq_choose_wl_type() to make
it clear what does it do.

Just renaming. No functionality change.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5eb3ed2..9657924 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2486,7 +2486,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 	}
 }
 
-static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
+static enum wl_type_t cfq_choose_wl_type(struct cfq_data *cfqd,
 			struct cfq_group *cfqg, enum wl_class_t wl_class)
 {
 	struct cfq_queue *queue;
@@ -2509,7 +2509,8 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 	return cur_best;
 }
 
-static void choose_st(struct cfq_data *cfqd, struct cfq_group *cfqg)
+static void
+choose_wl_class_and_type(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	unsigned slice;
 	unsigned count;
@@ -2547,7 +2548,7 @@ static void choose_st(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 new_workload:
 	/* otherwise select new workload type */
-	cfqd->wl_type = cfq_choose_wl(cfqd, cfqg, cfqd->wl_class);
+	cfqd->wl_type = cfq_choose_wl_type(cfqd, cfqg, cfqd->wl_class);
 	st = st_for(cfqg, cfqd->wl_class, cfqd->wl_type);
 	count = st->count;
 
@@ -2616,7 +2617,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 	} else
 		cfqd->workload_expires = jiffies - 1;
 
-	choose_st(cfqd, cfqg);
+	choose_wl_class_and_type(cfqd, cfqg);
 }
 
 /*
-- 
1.7.7.6
