From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Wed, 26 Sep 2012 15:10:46 -0700
Message-ID: <20120926221046.GA10453@mtj.dyndns.org>
References: <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com>
 <50634105.8060302@parallels.com>
 <20120926180124.GA12544@google.com>
 <50634FC9.4090609@parallels.com>
 <20120926193417.GJ12544@google.com>
 <50635B9D.8020205@parallels.com>
 <20120926195648.GA20342@google.com>
 <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NzmyvMv7X4WeiQGWWPUIviK4WHbgqtxNEZSKnsWABU4=;
        b=bB84eSRYthCV0TnIx/pxXOpB2Y+z3WdTtkQ5nUatiTCl7K2Qmp2lcVcW04GO8kxbxl
         zM/hSb0qIZM7T6wu2VJH+3K/UVWXe4whcSeyCLh+rb75rLhilCoyuezAGlBEMUP9Ra6d
         ANLDfbbsoz6yhbGoPCR3ilPLMacxiSPjx5ce0EsJclDe5tNKfqkO8Qpz9YtwRNOGduhL
         5I1F5c7xn33VafjvhxD0XVM/hQlO20nNvSK5lVV/Bn1q3W/TiGc3YVeSimuIm6imHNk4
         hp/EKp2LL6KMeXgqWVx80DHBcXF86lA2iw71apcjsxNyBNYcPNY1PrIHCeVfGehb7fJc
         HUHQ==
Content-Disposition: inline
In-Reply-To: <50637298.2090904-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Glauber.

On Thu, Sep 27, 2012 at 01:24:40AM +0400, Glauber Costa wrote:
> "kmem_accounted" is not a switch. It is an internal representation only.
> The semantics, that we discussed exhaustively in San Diego, is that a
> group that is not limited is not accounted. This is simple and consistent.
> 
> Since the limits are still per-cgroup, you are actually proposing more
> user-visible complexity than me, since you are adding yet another file,
> with its own semantics.

I was confused.  I thought it was exposed as a switch to userland (it
being right below .use_hierarchy tripped red alert).  This is internal
flag dependent upon kernel limit being set.  My apologies.

So, the proposed behavior is to allow enabling kmemcg anytime but
ignore what happened inbetween?  Where the knob is changes but the
weirdity seems all the same.  What prevents us from having a single
switch at root which can only be flipped when there's no children?

Backward compatibility is covered with single switch and I really
don't think "you can enable limits for kernel memory anytime but we
don't keep track of whatever happened before it was flipped the first
time because the first time is always special" is a sane thing to
expose to userland.  Or am I misunderstanding the proposed behavior
again?

Thanks.

-- 
tejun
