From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 01/11] blkcg: fix blkg_alloc() failure path
Date: Thu, 26 Apr 2012 14:59:11 -0700
Message-ID: <1335477561-11131-2-git-send-email-tj@kernel.org>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
	:references; bh=LW8Y4Ap9vbyvnv4ZNSjv8RjPwKyVE1yFyn4rTXRgmaY=;
	b=u1seEokzCpy0SZ8vhBM2JFZKQPn4bVc6rZ7bkAu5gZdkdtzTF5sBrZJSXFTdjPy8d8
	hS8M2JXn9iq8N0TCHM5wJjSiZOCm6yBVrWpPqPHwf5tRp0/Flz+9ybhtefKCfooZ3QhA
	3yq9L5i4jwCjlPHowGOt26ZKlDLWydrlDjyX1Up76NLkuUjyVOZy9Mrolu40wFYiFyCI
	JMaI3RUWMIMwB1ScpbzRpGm/eMmBWlkZOF7fvHs7njEb3s3+gEAz78hMV63m8dI4SJy5
	p4bRnmPMc7WFFLQON6pL/9seQDTdhYBjocxUhbm1kJij8LRNLXCwIZcsUc4r0tL3WQQ+
	/G2w==
In-Reply-To: <1335477561-11131-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

When policy data allocation fails in the middle, blkg_alloc() invokes
blkg_free() to destroy the half constructed blkg.  This ends up
calling pd_exit_fn() on policy datas which didn't go through
pd_init_fn().  Fix it by making blkg_alloc() call pd_init_fn()
immediately after each policy data allocation.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 02cf633..4ab7420 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -125,12 +125,8 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q)
 
 		blkg->pd[i] = pd;
 		pd->blkg = blkg;
-	}
-
-	/* invoke per-policy init */
-	for (i = 0; i < BLKCG_MAX_POLS; i++) {
-		struct blkcg_policy *pol = blkcg_policy[i];
 
+		/* invoke per-policy init */
 		if (blkcg_policy_enabled(blkg->q, pol))
 			pol->pd_init_fn(blkg);
 	}
-- 
1.7.7.3
