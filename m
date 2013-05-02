From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Date: Thu, 2 May 2013 11:29:33 -0700
Message-ID: <20130502182933.GN19814@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130502173428.GA4771@redhat.com>
 <20130502175701.GL19814@mtj.dyndns.org>
 <20130502181747.GH30020@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=3A4QXzxJuEAJWiRLnIeAii4OxKpsbWi2+ahtFd28Y+8=;
        b=W2DPJrEhK/oKP+UXevBuiiKsbSmwU6xMi/T3FfB0fcYnbfkw/eSt+kQ66gSQnJ1Ty5
         y+bOrPL7z+5MiVX1SI66l8xaKeqy8KSkoPB609ehKmACp0/21ofYWuQiLZac00/w2Ghn
         j1skaSj6Mh9sGry/8hQ692ateec4I5fUf+0+zBW0wciOJcLm/qHrMLTM4U8czcyPbUw+
         dcuqqCK4SrB1eqDclrZjBcBI3Zx86GCVsMvZg9UQrOfYBlXVqWm71IP5ASHPiK+oUG23
         5yVWzY/0ONmLLNauBTt7n7ZLZImPYvJcwmtOEIBrf3Ooq5ZMDvsib6WRPLwI2pLrsRSa
         VYVg==
Content-Disposition: inline
In-Reply-To: <20130502181747.GH30020-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Vivek.

On Thu, May 02, 2013 at 02:17:48PM -0400, Vivek Goyal wrote:
> Sorry, did not understand how did you arrive at 15% penalty. I think
> in worst case it will be 50%. Assume size of bio is 1MB. So it will

Oh, that's the number I got by running test.

> wait for 1 second in child group and then it will wait again for
> another second in parent group. Assume next bio gets queued only
> after first bio gets dispatched. 
> 
> That means each 1MB bio will wait for 2 second which will lead to
> effective rate of .5MB/second.

Then the scheduling algorithm is broken in itself regardless of
hierarchy.  That means an issuer which issues at exact the exactly
configured pace gets penalized, right?

> > I don't particularly like doing that as a separate step, maybe we can
> > just push the child's start time to the parent while dispatching?
> > Does that sound doable to you?
> 
> May be. But climbing the ladder has unfairness problems too. We might
> have to rethink about the hierarchical algorithm altogether.

Meh, it's not different from flat case.  It gives workable enough
fairness from the simple fact that the queues at each layer are FIFO.
Beyond that, as long as the limits are honored, it's fine.  If this
thing is going to be used for high-bandwidth applications, it should
probably get reimplemented as per-cpu token distributing hierarchy,
but blk-throttle is not gonna hold back the whole cgroup hierarchy
support.  If you want to reimplement the whole thing, please feel free
to do so afterwards.

Thanks.

-- 
tejun
