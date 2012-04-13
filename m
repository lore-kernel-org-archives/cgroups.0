From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] blkcg: implement per-queue policy activation
Date: Fri, 13 Apr 2012 14:12:57 -0400
Message-ID: <20120413181257.GG26383@redhat.com>
References: <1334273380-30233-1-git-send-email-tj@kernel.org>
 <1334273380-30233-8-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1334273380-30233-8-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Thu, Apr 12, 2012 at 04:29:39PM -0700, Tejun Heo wrote:

[..]
> diff --git a/block/elevator.c b/block/elevator.c
> index be3ab6d..6a55d41 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -896,8 +896,6 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
>  	ioc_clear_queue(q);
>  	spin_unlock_irq(q->queue_lock);
>  
> -	blkg_destroy_all(q, false);
> -

So now groups don't reclaimed until either cgroup is deleted or queue
exits. So if BLK_DEV_THROTTLE=n and cfq is switched out, blkg created
by CFQ policy will not be reclaimed (despite the fact nobody is using
them).

This is not necessarily bad, just thought of clarifying that it is the
design intent.

Thanks
Vivek
