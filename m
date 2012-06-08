From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] Add a __GFP_SLABMEMCG flag
Date: Fri, 8 Jun 2012 14:31:07 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1206081430380.4213@router.home>
References: <1339148601-20096-1-git-send-email-glommer@parallels.com> <1339148601-20096-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1339183870; bh=1ygLXs6A27r9mPsqPMP7pNTvs8zpaRkLsH9JfugnWJ0=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=vHcjKOZzQepL915Y1PY9J1qy7TsZLbspEmECzRwsE/I5lQ6qD15bcTp1lqGrf6rSkuqCCdlH4a8AdddGH4xdjRfO9NW38LGavYuuHQwplJjnQNJKR0hSP62ENeLHhjFpyer0DM6Wmc3eti4fiOviUG34Krg9E7cyOGpHBw0DAig=
In-Reply-To: <1339148601-20096-3-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbeck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, 8 Jun 2012, Glauber Costa wrote:

>   */
>  #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
>
> -#define __GFP_BITS_SHIFT 25	/* Room for N __GFP_FOO bits */
> +#define __GFP_BITS_SHIFT 26	/* Room for N __GFP_FOO bits */
>  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))

Please make this conditional on CONFIG_MEMCG or so. The bit can be useful
in particular on 32 bit architectures.
