From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/4] selftests: memcg: Expect no low events in
 unprotected sibling
Date: Wed, 18 May 2022 17:54:44 +0200
Message-ID: <20220518155444.GB22503@blackbody.suse.cz>
References: <20220512174452.tr34tuh4k5jm6qjs@dev0025.ash9.facebook.com>
 <20220513171811.730-1-mkoutny@suse.com>
 <20220513171811.730-3-mkoutny@suse.com>
 <Yn6pWPodGPlz+D8G@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652889286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fT6DJGA2cOSTPqSQ5kMo5BIA56bUH+3rlEL1RMSElmw=;
        b=aWoZP/8KOjx9GL8rIoYGs6MZgz48DGxy4SoNyCoki2pVbuV9gffBgLWkZpR5smgYoFlh0h
        hD3/PDiDEcNjj4m7KDuM6QwX/pIbSn0SH8uV6l7rVl8wbLYKF1Hl/E+/6/2W1k561Cwvqv
        fWdHnKJVpUyT5CPfddB82CRcJiWz+nA=
Content-Disposition: inline
In-Reply-To: <Yn6pWPodGPlz+D8G@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

Hi.

On Fri, May 13, 2022 at 11:54:16AM -0700, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> Hm, what are our plans here? Are we going to fix it soon-ish, or there
> is still no agreement on how to proceed?

Here are some of my ideas in random order so far and comments:

0) mask memory.events:low
-> not a real fix

1) don't do SWAP_CLUSTER_MAX roundup
-> won't solve sudden lift of protection

2) instead of SWAP_CLUSTER_MAX over-reclaim, do same under-reclaim
-> same problem as 1)

3) update children_low_usage transactionally (after reclaim round is done)
- ???

4) don't recursively distribute residual protection in the same reclaim round
- ???

5) iterate siblings from highest to lowest protection 
- not a solution

6) assign only >SWAP_CLUSTER_MAX of residuum
- need more info

I'm discouraged by possible complexity of 3) or 4), while 6) is what I'd
like to look more into.

HTH,
Michal

