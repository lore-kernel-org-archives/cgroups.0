From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Mon, 22 Apr 2013 08:57:44 -0700
Message-ID: <20130422155744.GD12543@htj.dyndns.org>
References: <20130420002620.GA17179@mtj.dyndns.org>
 <20130420031611.GA4695@dhcp22.suse.cz>
 <20130421022321.GE19097@mtj.dyndns.org>
 <20130421124554.GA8473@dhcp22.suse.cz>
 <20130422043939.GB25089@mtj.dyndns.org>
 <20130422151908.GF18286@dhcp22.suse.cz>
 <20130422155703.GC12543@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=mTDcZhCpsj8bqtz4ALhM2M5nxXRpE0qdYlEIxBWabhY=;
        b=N/LGppTol8jAHS5yrnSOoMGxA+1AjrbCsc/jXZrhmSK2C0IJC6vpfIgM768m/SZ3qh
         Mb2JvpZRWP5TdEbeAPJhevX2sMxPRDp1oNNYZL9+Fx3DdLCCcyApTcUj44BerhhI+6qv
         57uc7j+FJLENp95oimS9q4xY8Ca5R6ITjI6IWFvEXrPR6nJWphwGLRGMopMkUmz5ic43
         7LC0TpCgQ5o6eFPh8NTFB7d4BGR1lLPAerynKsfxrOd0SxTn/G/MdZvy9ak32oLnwtk0
         GbFnz0FySBSL76dijyvwK35MWJCslzXLB2KvRPvwzxNqO3izeIpqddCjg93lucBVF7eL
         uy8g==
Content-Disposition: inline
In-Reply-To: <20130422155703.GC12543-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Apr 22, 2013 at 08:57:03AM -0700, Tejun Heo wrote:
> On Mon, Apr 22, 2013 at 05:19:08PM +0200, Michal Hocko wrote:
> > We can try to be clever during the outside pressure and prefer
> > reclaiming over soft limit groups first. Which we used to do and will
> > do after rework as well. As a side effect of that a properly designed
> > hierachy with opt-in soft limited groups can actually accomplish some
> > isolation is a nice side effect but no _guarantee_.
> 
> Okay, so it *is* a soft limit.  Good.  If so, a subtree going over the
> limit of course forces reclaim on its children even though their
> individual configs aren't over limit.  It's exactly the same as
> hardlimit.  There doesn't need to be any difference and there's
> nothing questionable or interesting about it.
> 
> Also, then, a cgroup which has been configured explicitly shouldn't be
                                ^
				not

> disadvantaged compared to a cgroup with a limit configured.  ie. the
> current behavior of giving maximum to the knob on creation is the
> correct one.  The knob should create *extra* pressure.  It shouldn't
> lessen the pressure.  When populated weith other cgroups with limits
> configured, it would change the relative pressure felt by each but in
> general it's a limiting mechanism not an isolation one.  I think the
> bulk of confusion is coming from this, so please make that abundantly
> clear.
> 
> And, if people want a mechanism for isolation / lessening of pressure,
> which looks like a valid use case to me, add another knob for that
> which is prioritized under both hard and soft limits.  That is the
> only sensible way to do it.
> 
> Alright, no complaint anymore.  Thanks.
> 
> -- 
> tejun

-- 
tejun
