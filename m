From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] memcg: ratify and consolidate over-charge handling
Date: Mon, 14 Sep 2015 15:56:08 -0400
Message-ID: <20150914195608.GF25369@htj.duckdns.org>
References: <20150913201416.GC25369@htj.duckdns.org>
 <20150913201442.GD25369@htj.duckdns.org>
 <20150914193225.GA26273@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=F7MMLb9nbxFdrbZOXdJ9FuElKDxMFr6BtZRiVkcxSVo=;
        b=FIv7Hn5PcipcLK6d/jx8m2nJia4qW4r2aBqN01Fv8c+nIc6ZcGqM7KohL889FkXAXE
         oAZYLZlaVymDrzypzbNsr4fLA09Y7jnzILKE8ovaGvij1+MLHOf24Z94xgV5ta238CmR
         RwBo7GNkX7QeyJ9MDw03/A8qS9odlcvThPXiatGE3q1wrUFbsfXmeUGyM7T8dvjOxyX3
         UajtK6+lkjTfhNNx+zOk2nIarDS/h54HYszGpInlck00wLUDIGBI0tVV7PHb/Bf4F7xc
         LP7iNBhhwISDw/HXRgQjiI477X7ujjUeV6f3QPbzzq2+TsoUXoIpHgDTDU1mS9Vvv9nn
         XlGw==
Content-Disposition: inline
In-Reply-To: <20150914193225.GA26273-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Michal.

On Mon, Sep 14, 2015 at 09:32:25PM +0200, Michal Hocko wrote:
> >   mem_cgroup_try_charge() needs to switch
> >   the returned cgroup to the root one.
> > 
> > The reality is that in memcg there are cases where we are forced
> > and/or willing to go over the limit.  Each such case needs to be
> > scrutinized and justified but there definitely are situations where
> > that is the right thing to do.  We alredy do this but with a
> > superficial and inconsistent disguise which leads to unnecessary
> > complications.
> >
> > This patch updates try_charge() so that it over-charges and returns 0
> > when deemed necessary.  -EINTR return is removed along with all
> > special case handling in the callers.
> 
> OK the code is easier in the end, although I would argue that try_charge
> could return ENOMEM for GFP_NOWAIT instead of overcharging (this would
> e.g. allow precharge to bail out earlier). Something for a separate patch I
> guess.

Hmm... GFP_NOWAIT is failed unless it also has __GFP_NOFAIL.

> Anyway I still do not like usage > max/hard limit presented to userspace
> because it looks like a clear breaking of max/hard limit semantic. I
> realize that we cannot solve the underlying problem easily or it might
> be unfeasible but we should consider how to present this state to the
> userspace.
> We have basically 2 options AFAICS. We can either document that a
> _temporal_ breach of the max/hard limit is allowed or we can hide this
> fact and always present max(current,max).
> The first one might be better for an easier debugging and it is also
> more honest about the current state but the definition of the hard limit
> is a bit weird. It also exposes implementation details to the userspace.
> The other choice is clearly lying but users shouldn't care about the
> implementation details and if the state is really temporal then the
> userspace shouldn't even notice. There is also a risk that somebody is
> already depending on current < max which happened to work without kmem
> until now.
> This is something to be solved in a separate patch I guess but we
> should think about that. I am not entirely clear on that myself but I am
> more inclined to the first option and simply document the potential
> corner case and temporal breach.

I'm pretty sure we don't wanna lie.  Just document that temporal
small-scale breaches may happen.  I don't even think this is an
implementation detail.  The fact that we have separate high and max
limits is already admitting that this is inherently different from
global case and that memcg is consciously and actively making
trade-offs regarding handling of global and local memory pressure and
I think that's the right thing to do and something inherent to what
memcg is doing here.

Thanks.

-- 
tejun
