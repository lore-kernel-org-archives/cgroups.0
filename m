From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/7] res_counter: add a function
 res_counter_move_parent().
Date: Wed, 18 Apr 2012 10:03:37 -0700
Message-ID: <20120418170337.GH19975@google.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
 <4F86BA66.2010503@jp.fujitsu.com>
 <20120416223157.GE12421@google.com>
 <4F8E678A.8000805@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=tmltBXl/3W2+L+8Wgv/KiumtOauX+PiYZZs4fb51aaU=;
        b=vMSVZ4amNqpeihxF0Q6BCf+KFhE/2W2N/7C1ySMZdbgiafMkRyv6GDD4sxqkpT4CEB
         8hUU9ZgokctuVFTRLkZ/De4Bc6P+HbIPSQ/f3FJ2CNknKHgmibjYZWNZBvJbsRn/jxz2
         8Q2aC1UMXXPhvFb4YTASBnyqbJJH0ekV8jQ2sArjGKO25FIZMUtragwmMLqOtjHKyBlO
         HTnNeC+hYWzsAhtGST/B+G6kyLWS+PKua4owZMyL94KXfpyn1oxtDlIUQnb3xJXvJOQj
         EPfxCyxPCzE2b78r4DmdMQd3WWJZnV5ubtf6abe1jYekua9H4SHovXIRDWV23NLIW9mf
         TEOA==
Content-Disposition: inline
In-Reply-To: <4F8E678A.8000805-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed, Apr 18, 2012 at 04:04:42PM +0900, KAMEZAWA Hiroyuki wrote:
> (2012/04/17 7:31), Tejun Heo wrote:
> 
> > On Thu, Apr 12, 2012 at 08:20:06PM +0900, KAMEZAWA Hiroyuki wrote:
> >> +/*
> >> + * In hierarchical accounting, child's usage is accounted into ancestors.
> >> + * To move local usage to its parent, just forget current level usage.
> >> + */
> >> +void res_counter_move_parent(struct res_counter *counter, unsigned long val)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +	BUG_ON(!counter->parent);
> >> +	spin_lock_irqsave(&counter->lock, flags);
> >> +	res_counter_uncharge_locked(counter, val);
> >> +	spin_unlock_irqrestore(&counter->lock, flags);
> >> +}
> > 
> > On the second thought, do we need this at all?  It's as good as doing
> > nothing after all, no?
> > 
> 
> 
> I considered that, but I think it may make it hard to debug memcg leakage.
> I'd like to confirm res->usage == 0 at removal of memcg.

Hmmm... then let's name it res_counter_reset() or something.  I feel
very confused about the function name.

Thanks.

-- 
tejun
