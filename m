From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Sat, 6 Oct 2012 11:19:24 +0900
Message-ID: <20121006021924.GB2601@localhost>
References: <50637298.2090904@parallels.com>
 <20120927120806.GA29104@dhcp22.suse.cz>
 <20120927143300.GA4251@mtj.dyndns.org>
 <20120927144307.GH3429@suse.de>
 <20120927145802.GC4251@mtj.dyndns.org>
 <50649B4C.8000208@parallels.com>
 <20120930082358.GG10383@mtj.dyndns.org>
 <50695817.2030201@parallels.com>
 <20121003225458.GE19248@localhost>
 <506D7922.1050108@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vUP2y3FZgLEDeUlJCa/AgY0KCRG0ecs/CZuCHL2G6DU=;
        b=WaoD5Az+y9oe95mV/AsZwvfA228Nm7E7V4IKCJf6xEej4BDBsoMW5jp/j9J0fDRltG
         W+OxyNq0RrGzQRdeoUJscd/d7OkzFWKMPigogw1fvOavPYmrw7ItAjCXiwsjKLA/dLKX
         KTZrpLdz1eI8WsIZYW6FWxV0jLBrb/F5oHiAm+0HfLEvSV9E1zLjP29qrUBHXrmhN4sH
         ks31yJmwklhA3xbACeHdBCTm0gCrMJ5pLyVg7L6VAb+F7sG6Nsx8EpL1luLxWwetK6Dh
         oJ9FbAwopZuV21A2qGyQPkWz6+eOKw3xmMXlLUlKRVGDm3Q56ypkQHe76xmMcb9XYR88
         ij6A==
Content-Disposition: inline
In-Reply-To: <506D7922.1050108-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Glauber.

On Thu, Oct 04, 2012 at 03:55:14PM +0400, Glauber Costa wrote:
> I don't want to bloat unrelated kmem_cache structures, so I can't embed
> a memcg array in there: I would have to have a pointer to a memcg array
> that gets assigned at first use. But if we don't want to have a static
> number, as you and christoph already frowned upon heavily, we may have
> to do that memcg side as well.
> 
> The array gets bigger, though, because it pretty much has to be enough
> to accomodate all css_ids. Even now, they are more than the 400 I used
> in this patchset. Not allocating all of them at once will lead to more
> complication and pointer chasing in here.

I don't think it would require more pointer chasing.  At the simplest,
we can just compare the array size each time.  If you wanna be more
efficient, all arrays can be kept at the same size and resized when
the number of memcgs cross the current number.  The only runtime
overhead would be one pointer deref which I don't think can be avoided
regardless of the indexing direction.

Thanks.

-- 
tejun
