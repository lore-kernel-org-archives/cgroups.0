From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Fri, 12 May 2023 18:09:20 -0300
Message-ID: <ZF6rACJzilA06oe+@nvidia.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <ZFLdDyHoIdJSXJt+@google.com>
 <874josz4rd.fsf@nvidia.com>
 <ZFPP71czDDxMPLQK@google.com>
 <877ctm518f.fsf@nvidia.com>
 <ZFbZZPkSpsKMe8iR@google.com>
 <87ttwnkzap.fsf@nvidia.com>
 <ZFuvhP5qGPivokc0@google.com>
 <87jzxe9baj.fsf@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x55qt4WozEzcvVLV3w9xOL/S4v7cSAQ9J++ugA59PIU=;
 b=JBC+OGjC14bwo3BIV2VZvGdajWc8KoK7lcPuZS7YeNCSIYm9O3FJq0Ri47/Tw69v8V30loe5NY8Sqlynqs9bsy60M9/Jp0h1N82XgrkVa28gurGiYFNVcvogHKZvsx6WMM0MKnQJyLsXdxtuaPSXsu0Y42CAeopzqOMOs9STCxzg4f7fbBw9vkUjA5s03HrXUxj5ZCJQNHJ/jeu+60WN4u8fJ3xcaxdEyh/ZEVZ0b2APFO907hONzl6OW9+AYOrdQs50GtwrZEMd4KAirDAjc3FTdOJ89muyX6baEVVmXVS/tqMRHu+DoaLOcM10cr4KOrun9xfKLuRPpi/jf2Udow==
Content-Disposition: inline
In-Reply-To: <87jzxe9baj.fsf-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, May 12, 2023 at 06:45:13PM +1000, Alistair Popple wrote:

> However review comments suggested it needed to be added as part of
> memcg. As soon as we do that we have to address how we deal with shared
> memory. If we stick with the original RLIMIT proposal this discussion
> goes away, but based on feedback I think I need to at least investigate
> integrating it into memcg to get anything merged.

Personally I don't see how we can effectively solve the per-page
problem without also tracking all the owning memcgs for every
page. This means giving each struct page an array of memcgs

I suspect this will be too expensive to be realistically
implementable.

If it is done then we may not even need a pin controller on its own as
the main memcg should capture most of it. (althought it doesn't
distinguish between movable/swappable and non-swappable memory)

But this is all being done for the libvirt people, so it would be good
to involve them

Jason
