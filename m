From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: fix race between blkcg_bio_issue_check
 and cgroup_rmdir
Date: Wed, 7 Feb 2018 13:38:11 -0800
Message-ID: <20180207213811.GF695913@devbig577.frc2.facebook.com>
References: <6f136c90-faa9-4bc0-b02f-3a112b4d8360@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gV5ERurDM3UcRzGfTDyeupn+Ng+EeNgRDbBTdKvxOcU=;
        b=AWiG+10iCAwkDig4oOeiwusQfDlJRTgMenDoyJwvOy1eyeFOa4hx2DK+X0pLFdlVG0
         I81AjOcyxoeUoa2F1iQ7MJw2EQirKD7EliGu953+iBzubp/QqhbmR9FhZHqXKc1yKQOh
         uLUBu0DL1APFBi4HukbxWXY+eavBiaWDWoLQIQVsU4dSw/y6RpFipHmn9WFc7MVSgJp2
         ht8C0VzUOGLzZ5mu5sBveOQSn+sKkU0ESzc/sJYO5mbq0j9DCO3kaahy0TUpg4oQIUSk
         9oaahe9fYtDqm3mtf4w+hkVwSjfSFrGKIBH7TtSTF1P159zNAfmQBriq/6a4y3VSVWFj
         XRFg==
Content-Disposition: inline
In-Reply-To: <6f136c90-faa9-4bc0-b02f-3a112b4d8360-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, xuejiufei <jiufei.xue-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Caspar Zhang <caspar-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Joseph.

On Wed, Feb 07, 2018 at 04:40:02PM +0800, Joseph Qi wrote:
> writeback kworker
>   blkcg_bio_issue_check
>     rcu_read_lock
>     blkg_lookup
>     <<< *race window*
>     blk_throtl_bio
>       spin_lock_irq(q->queue_lock)
>       spin_unlock_irq(q->queue_lock)
>     rcu_read_unlock
> 
> cgroup_rmdir
>   cgroup_destroy_locked
>     kill_css
>       css_killed_ref_fn
>         css_killed_work_fn
>           offline_css
>             blkcg_css_offline
>               spin_trylock(q->queue_lock)
>               blkg_destroy
>               spin_unlock(q->queue_lock)

Ah, right.  Thanks for spotting the bug.

> Since rcu can only prevent blkg from releasing when it is being used,
> the blkg->refcnt can be decreased to 0 during blkg_destroy and schedule
> blkg release.
> Then trying to blkg_get in blk_throtl_bio will complains the WARNING.
> And then the corresponding blkg_put will schedule blkg release again,
> which result in double free.
> This race is introduced by commit ae1188963611 ("blkcg: consolidate blkg
> creation in blkcg_bio_issue_check()"). Before this commit, it will lookup
> first and then try to lookup/create again with queue_lock. So revive
> this logic to fix the race.

The change seems a bit drastic to me.  Can't we do something like the
following instead?

blk_throtl_bio()
{
	... non throttled cases ...

	/* out-of-limit, queue to @tg */

	/*
	 * We can look up and retry but the race window is tiny here.
	 * Just letting it through should be good enough.
	 */
	if (!css_tryget(blkcg->css))
		goto out;

	... actual queueing ...
	css_put(blkcg->css);
	...
}

Thanks.

-- 
tejun
