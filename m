From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: punt high overage reclaim to
 return-to-userland path
Date: Fri, 28 Aug 2015 16:44:32 -0400
Message-ID: <20150828204432.GA11089@htj.dyndns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-4-git-send-email-tj@kernel.org>
 <20150828163611.GI9610@esperanza>
 <20150828164819.GL26785@mtj.duckdns.org>
 <20150828203231.GL9610@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MHLUIV3jKK31+5z3hCO4s/6i9+FlHahn4IrjAVn7M/M=;
        b=F9R5gzhAioTRW9UMbUx+PaKtI8Vs45q/EJjfQ7WCAlS2TVgvwqT58YCqjevZR2UAeR
         0GrcyiOygY6BpXnz3DH14gkUCOeHlg7LfuCcg/FKJQ1OvsYQq8WOyimHUqmSztBTjfq8
         H7ZtlHM4+CAupYKOiRoWUChXJgD7k1zHD576HD9HHLvRhbj+E4fvLXxi5RInCM8f79ir
         neEf/rtoQJhO2sHpY1MvhwYyaK/lvVt8D53PerAJ0fJxDxdScDrR1880L0CBWXNI6upw
         I4EnPsFU5JDBP+2btB3QP1OzvmaS4ZRUFZcYAeT9hIAJRB8qz0AaN6rKoPpg9mY2MrNH
         z6kw==
Content-Disposition: inline
In-Reply-To: <20150828203231.GL9610@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Fri, Aug 28, 2015 at 11:32:31PM +0300, Vladimir Davydov wrote:
> What kind of workload should it be then? `find` will constantly invoke
> d_alloc, which issues a GFP_KERNEL allocation and therefore is allowed
> to perform reclaim...
> 
> OK, I tried to reproduce the issue on the latest mainline kernel and ...
> succeeded - memory.current did occasionally jump up to ~55M although
> memory.high was set to 32M. Hmm, strange... Started to investigate.
> Printed stack traces and found that we don't invoke memcg reclaim on
> normal GFP_KERNEL allocations! How is that? The thing is there was a
> commit that made SLUB (not VFS or any other kmem user, but core SLUB)
> try to allocate high order slab pages w/o __GFP_WAIT for performance
> reasons. That broke kmemcg case. Here it goes:

Ah, cool, so it was a bug from slub.  Punting to return path still has
some niceties but if we can't consistently get rid of stack
consumption it's not that attractive.  Let's revisit it later together
with hard limit reclaim.

Thanks.

-- 
tejun
