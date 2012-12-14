From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 03/12] blkcg: cosmetic updates to blkg_create()
Date: Fri, 14 Dec 2012 14:41:16 -0800
Message-ID: <1355524885-22719-4-git-send-email-tj@kernel.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
	:references; bh=ttK6rpMn46XLosLwclArUKarCMx1eIlOWQGVL2gEttE=;
	b=kvFRN2NdnIfopmWwSaHYOYKqp0bt6bEJknrlMV28iFKQDDw7rRpeU4v9EywSp2N41M
	GGkbM8767LpvkttkXRJsQKashUd8RMTzLKDKnPnY6LgznX6eBAAp7rbMC0OJzy/EQPiE
	YBcY0sHrdwjvepMfSngQ4WTJ9+jDoQcy8t3OgSeXHkiMslAeu5uy8ndIenHAWc+HnDEy
	bkZf0+cOi6NTdrHzRI991RQcNlSPUPmLBOWnjvsRkmwg1Xtz4TD2H2Z6xTdO5z0Ol2D7
	F24tokaHDTta2qrS03MMcmeW84vqxlt2UEwP47DK1rXCyTAtZLjc5ZuFCUQHLCT4wF86
	MdHQ==
In-Reply-To: <1355524885-22719-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

* Rename out_* labels to err_*.

* Do ERR_PTR() conversion once in the error return path.

This patch is cosmetic and to prepare for the hierarchy support.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-cgroup.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ffbd237..fde2286 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -187,16 +187,16 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 
 	/* blkg holds a reference to blkcg */
 	if (!css_tryget(&blkcg->css)) {
-		blkg = ERR_PTR(-EINVAL);
-		goto out_free;
+		ret = -EINVAL;
+		goto err_free_blkg;
 	}
 
 	/* allocate */
 	if (!new_blkg) {
 		new_blkg = blkg_alloc(blkcg, q, GFP_ATOMIC);
 		if (unlikely(!new_blkg)) {
-			blkg = ERR_PTR(-ENOMEM);
-			goto out_put;
+			ret = -ENOMEM;
+			goto err_put_css;
 		}
 	}
 	blkg = new_blkg;
@@ -213,12 +213,11 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	if (!ret)
 		return blkg;
 
-	blkg = ERR_PTR(ret);
-out_put:
+err_put_css:
 	css_put(&blkcg->css);
-out_free:
+err_free_blkg:
 	blkg_free(new_blkg);
-	return blkg;
+	return ERR_PTR(ret);
 }
 
 /**
-- 
1.7.11.7
