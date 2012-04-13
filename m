From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] blkcg: implement per-queue policy activation
Date: Fri, 13 Apr 2012 11:17:05 -0700
Message-ID: <20120413181705.GD12233@google.com>
References: <1334273380-30233-1-git-send-email-tj@kernel.org>
 <1334273380-30233-8-git-send-email-tj@kernel.org>
 <20120413181257.GG26383@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=yNB+oxN7ZSaMO7ncQqDnNVvhwIx3GwOMgKJ5b8/z/wY=;
        b=Xd2X0iagPu7PkyK3mqY4h/xPvRYiVGVSS6RvRwbF79In5SnLbnPRGElBg1iCW4AhTN
         I8wEc67gvyGq5FZA7tfZxep8MCoO8GC37Ut6fj2RSGVaKT5cZi8IjY04JVj/12oterwo
         qtpEBQ3AUTdXLZ9IaBsPlZ1U0sUlyccFe+JIuUy+sDhDCe8d++0SabOZ1ihNz6qliKXN
         XGs6ps8Sbnhl1NTTsM13SYX03+JwS3OkC3BSdvBNO5FoudY5/NEwfPoo3Bb3v29/mm+b
         z0JTpwIEFHYecUBqlTtLW5mZ7h8hh/uqsDK3uuHrpHwemEKvAAmyReWdM+NxK9hUxxR/
         nUCA==
Content-Disposition: inline
In-Reply-To: <20120413181257.GG26383-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello,

On Fri, Apr 13, 2012 at 02:12:57PM -0400, Vivek Goyal wrote:
> On Thu, Apr 12, 2012 at 04:29:39PM -0700, Tejun Heo wrote:
> 
> [..]
> > diff --git a/block/elevator.c b/block/elevator.c
> > index be3ab6d..6a55d41 100644
> > --- a/block/elevator.c
> > +++ b/block/elevator.c
> > @@ -896,8 +896,6 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
> >  	ioc_clear_queue(q);
> >  	spin_unlock_irq(q->queue_lock);
> >  
> > -	blkg_destroy_all(q, false);
> > -
> 
> So now groups don't reclaimed until either cgroup is deleted or queue
> exits. So if BLK_DEV_THROTTLE=n and cfq is switched out, blkg created
> by CFQ policy will not be reclaimed (despite the fact nobody is using
> them).

It's not difficult to change.  We can just trigger reclaim if no
policy is enabled for the queue.  Hmmm... yeah, that's gonna be like
five line change.  I'll add it.

Thanks.

-- 
tejun
