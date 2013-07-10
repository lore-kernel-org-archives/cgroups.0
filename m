From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Tue, 9 Jul 2013 20:50:24 -0700
Message-ID: <20130710035024.GA28461@htj.dyndns.org>
References: <51DC0CE2.2050906@openvz.org>
 <20130709131605.GB2478@htj.dyndns.org>
 <20130709131646.GC2478@htj.dyndns.org>
 <51DC136E.6020901@openvz.org>
 <20130709134558.GD2478@htj.dyndns.org>
 <20130709141833.GA2237@redhat.com>
 <20130709142908.GE2478@htj.dyndns.org>
 <20130709145430.GB2237@redhat.com>
 <20130709150815.GG2478@htj.dyndns.org>
 <20130710030955.GA3569@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rUKcU2Er55NxF2H5ClIUB575Gv70abBBhqP0egPS6Ys=;
        b=mQxmtSIOzLdvlPcBxmDwBF1iWjIxc1dd9ZB2T4nGoCvegolKgDAioHzjx9baUlrN8K
         NXR/MJ90YRNqYxSxOi8E22fzQM3/EWpCUfcxfv7XF7DnqmcPQ9o5GeKVNjt6utq/MyRM
         oQu7B4Q8scmEVgBwKgSM6Y6WT48tRjhYtKVJns5NZIBINK26RQOvbBM2ukOHSTP7tRoT
         BzGSlRYWXQIGCOscOYs2KhgEDjqhCUSvGVFIf9Xqj74iWqwZOsJMwVWy2lZzdsE37Mji
         n/3PG7hlW9JY43e/LkyDHjIesczBJpKrsvCuOSOi+1wvHLBToZ7M4PQ9SY3ptSWGVrDf
         5Wig==
Content-Disposition: inline
In-Reply-To: <20130710030955.GA3569-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hello,

On Tue, Jul 09, 2013 at 11:09:55PM -0400, Vivek Goyal wrote:
> Stacking drivers are pretty important ones and we expect throttling
> to work with them. By throttling bio, a single hook worked both for
> request based drivers and bio based drivers.

Oh yeah, sure, we have them working now, so there's no way to break
them but that doesn't mean it's a good overall design.  I don't have a
good answer for this one.  The root cause is having the distinction
between bio and rq based drivers.  With the right constructs, I
suspect we probably could have done away with bio based drivers, but,
well, that's all history now.

> So looks like for bio based drivers you want bio throttling and for
> request based drviers, request throttling and define a separate hook
> in blk_queue_bio(). A generic hook probably can check the type of request
> queue and not throttle bio if it is request based queue and ultimately
> request queue based hook will throttle it.
> 
> So in a cgroup we blkio.throttle.io_serviced will have stats for
> bio/request depending on type of device.
> 
> And we will need to modify throttling logic so that it can handle
> both bio and request throttling. Not sure how much of code can be
> shared for bio/request throttling.

I'm not sure how much (de)multiplexing and sharing we'd be doing but
I'm afraid there's gonna need to be some.  We really can't use the
same logic for SSDs and rotating rusts after all and it probably would
be best to avoid contaminating SSD paths with lots of guesstimating
logics necessary for rotating rusts.

> I am not sure about request based multipath driver and it might
> require some special handling.

If it's not supported now, I'll be happy with just leaving it alone
and telling mp users to configure the underlying queues.

> Is it roughly inline with what you have been thinking.

I'm hoping to keep it somewhat manageable at least.  I wouldn't mind
leaving stacking driver and cfq-iosched support as they are while only
supporting SSD devices with new code.  It's all pie in the sky at this
point and none of this matters before we fix the bdi and writeback
issue anyway.

Thanks.

-- 
tejun
