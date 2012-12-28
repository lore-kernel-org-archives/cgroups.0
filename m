From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 07/24] blkcg: fix minor bug in blkg_alloc()
Date: Fri, 28 Dec 2012 12:35:29 -0800
Message-ID: <1356726946-26037-8-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
	:in-reply-to:references;
	bh=d7ze4NdUnVreuMDXWxifBlsv/V2FgF85Uumod6yKf/I=;
	b=uNK9wwwS6J9Y/CbDgEFh56pjPR4kpIv/PeBN5xhbDhLDE6xP/+TiMniOD9rkFzxCmJ
	aa7kLeykvSXizXXOvRdekoVnWZD5ESksTPNEYR6sOLDusGrnYYpGzNyag2lTpjrsdu2K
	hcz23IN8HSlKrzQ3M4OoJASDQiyXZQKMJsJCMHD++ukT+4ovMj4DFjjJDH/M1J2k4XMZ
	jYPxI1rQNNmRo0TqMjZl2KjiaafVGBIuUgb0ja/2htoZIp/41gBPfcz6nO/eJvF+8ke1
	cnY1/+C2BLMKV9Hhr3zNtJGczIrTcNf7XB7gA6zLhXsYcBCbzwQSZChgL4bgsyPyZNNW
	PL3A==
In-Reply-To: <1356726946-26037-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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

blkg_alloc() was mistakenly checking blkcg_policy_enabled() twice.
The latter test should have been on whether pol->pd_init_fn() exists.
This doesn't cause actual problems because both blkcg policies
implement pol->pd_init_fn().  Fix it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b8858fb..7ef747b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -114,7 +114,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 		pd->blkg = blkg;
 
 		/* invoke per-policy init */
-		if (blkcg_policy_enabled(blkg->q, pol))
+		if (pol->pd_init_fn)
 			pol->pd_init_fn(blkg);
 	}
 
-- 
1.8.0.2
