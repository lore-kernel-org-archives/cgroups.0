From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC - TAKE TWO - 02/12] block, bfq: add full hierarchical
 scheduling and cgroups support
Date: Fri, 30 May 2014 11:39:43 -0400
Message-ID: <20140530153943.GC24871@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-3-git-send-email-paolo.valente@unimore.it>
 <20140530153718.GB24871@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QASZS4q9bW0LWtLlkrOJw18NEXuvHa6j1ssmgpGcM8w=;
        b=JXIyAIFAE8ax3RKKRmcyGXLoEIuBqXaZe85n597ErvHfK3emAB3JuniFch8EtORpgH
         Z96C21GXqn/eZ/pQEM6jIwAfkskKugqYVdKN7+Xv1V3LpV5734hMH6ToaJ5pEwvTkyYv
         abYGPkOZKYVFoTEAaPypK7K8TYnYksxBMhPyQl/k75ITWoiyX7vIxD4AExBPn46kuXHq
         L4eohkKQZ7Xnut69WCL9vGqVjjoD6WCJPd6BjidZwKWtHcZXUUVPQEgNNZQM5I+H1oBO
         wLcF9jxSXPBQmLnUHm18qksYh70eeu2w1vd6CC2sHzysf4K2cGgDwhCPT2/TR2tYLebO
         i48g==
Content-Disposition: inline
In-Reply-To: <20140530153718.GB24871-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paolo Valente <posta_paolo-whZMOeQn8C0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 30, 2014 at 11:37:18AM -0400, Tejun Heo wrote:
> On Thu, May 29, 2014 at 11:05:33AM +0200, Paolo Valente wrote:
> > diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> > index 768fe44..cdd2528 100644
> > --- a/include/linux/cgroup_subsys.h
> > +++ b/include/linux/cgroup_subsys.h
> > @@ -39,6 +39,10 @@ SUBSYS(net_cls)
> >  SUBSYS(blkio)
> >  #endif
> >  
> > +#if IS_ENABLED(CONFIG_CGROUP_BFQIO)
> > +SUBSYS(bfqio)
> > +#endif
> 
> So, ummm, I don't think this is a good idea.  Why aren't you plugging
> into the blkcg infrastructure as cfq does?  Why does it need to be a
> separate controller?

If there's something which doesn't work for bfq in blkcg, please let
me know.  I'd be happy to make it work.

Thanks.

-- 
tejun
