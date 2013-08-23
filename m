From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OOPS in cfq/blkcgroups if CFQ_GROUP_IOSCHED is not set
Date: Fri, 23 Aug 2013 13:24:24 -0400
Message-ID: <20130823172424.GN3277@htj.dyndns.org>
References: <CAOMFOmV-k_0RxNwY2JEXn9sHmsoJYArWwURNj1-Srph=FzbFUQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1rvCUxQS+J5RhCp+mdqDHmrqmL+Ir6OVJ1Bll5tpsjo=;
        b=r1AJTcweZ7xlVLE0K4+HygQsIA4jqRm8Z6D+DX4w20YEbFladOlRaAH1MbOssfK4BA
         EXmOEvrvlTzP458+UiYG2H33VUOBJaSs/dW4sMts+gIqr45zcCgSqVEY9N8KYWNtndjf
         Ddoz+0bZ1Y7017k5EutEVOu2wKnnXwThpCdKFGrnhBzlcHY0fmhPEz/3TlRNlnzrfkUl
         5MASyk9/AvMj9s6XMSo8CjyqrxeQfqBhJpLvrpl+HgZjsSmphIOsRmPlFksTCQXyciGs
         H/EjaWfdW9J8xGlevduJKxPw5BkL8oD+nVlf0bGKyBppfDYr+SxTEuEO27UQxVteohqR
         4DdA==
Content-Disposition: inline
In-Reply-To: <CAOMFOmV-k_0RxNwY2JEXn9sHmsoJYArWwURNj1-Srph=FzbFUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Aug 21, 2013 at 10:05:58PM -0700, Anatol Pomozov wrote:
> blkcg_activate_policy(q, &blkcg_policy_cfq);
> 
> And this function is important for blockcg because it sets root_blkg:
> 
> q->root_blkg = blkg;
> 
> If root_blkg is not set then it is NULL and later it confuses function
> __blk_queue_next_rl that has following check:
> 
> if (ent == &q->root_blkg->q_node)
> 
> it intends to skip unintialized request list structures that
> correspond to root_blkg cgroup. But because q->root_blkg is NULL the
> code fails to filter it out and returns invalid requests_list back to
> the user. The caller tries to use unintialized spinlock and crashes.

Does the folowing patch fix the problem you're seeing?  Very lightly
tested.

Thanks.

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index e90c7c1..4e491d9 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -235,8 +235,13 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	blkg->online = true;
 	spin_unlock(&blkcg->lock);
 
-	if (!ret)
+	if (!ret) {
+		if (blkcg == &blkcg_root) {
+			q->root_blkg = blkg;
+			q->root_rl.blkg = blkg;
+		}
 		return blkg;
+	}
 
 	/* @blkg failed fully initialized, use the usual release path */
 	blkg_put(blkg);
@@ -335,6 +340,15 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 		rcu_assign_pointer(blkcg->blkg_hint, NULL);
 
 	/*
+	 * If root blkg is destroyed.  Just clear the pointer since root_rl
+	 * does not take reference on root blkg.
+	 */
+	if (blkcg == &blkcg_root) {
+		blkg->q->root_blkg = NULL;
+		blkg->q->root_rl.blkg = NULL;
+	}
+
+	/*
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
 	 */
@@ -360,13 +374,6 @@ static void blkg_destroy_all(struct request_queue *q)
 		blkg_destroy(blkg);
 		spin_unlock(&blkcg->lock);
 	}
-
-	/*
-	 * root blkg is destroyed.  Just clear the pointer since
-	 * root_rl does not take reference on root blkg.
-	 */
-	q->root_blkg = NULL;
-	q->root_rl.blkg = NULL;
 }
 
 /*
@@ -970,8 +977,6 @@ int blkcg_activate_policy(struct request_queue *q,
 		ret = PTR_ERR(blkg);
 		goto out_unlock;
 	}
-	q->root_blkg = blkg;
-	q->root_rl.blkg = blkg;
 
 	list_for_each_entry(blkg, &q->blkg_list, q_node)
 		cnt++;


-- 
tejun
