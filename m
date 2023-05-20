From: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Sat, 20 May 2023 08:09:26 -0700
Message-ID: <ZGjipm8ycoEJGj5z@google.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <ZFLdDyHoIdJSXJt+@google.com>
 <874josz4rd.fsf@nvidia.com>
 <ZFPP71czDDxMPLQK@google.com>
 <877ctm518f.fsf@nvidia.com>
 <ZFbZZPkSpsKMe8iR@google.com>
 <87ttwnkzap.fsf@nvidia.com>
 <ZFuvhP5qGPivokc0@google.com>
 <87jzxe9baj.fsf@nvidia.com>
 <ZF6rACJzilA06oe+@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684595370;
        bh=4zgFLqedrPYhCRx9gtDlB2omoSFlFonZfeeZY1IDdSs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kzEZFk0VO9ueKp77ylIn0iukDF8ZkxVEl5p/Kr9aMczqAZV9awU1UJj6f0bkjHPVo
         4SbCmQr0PhPmDtzoHyfnJ4X1eIdoU7tN1NfIRojKxmCbAl7gY2iWtXT5zBaMsGtsV5
         P376lvmh971ZdlsO81uAsWt3iDDzpj6pOp3+imrGT2+oA4tXubFVWqir63wJudT8QF
         AF71gt/jR2ymlz/bLVIWOMJuN8nqzffSMBWHNYb6yi+udBUSpGu1lxQO32LfwPRw/R
         zjxN+xEFT4tE8DNwP8dyMjf4Yqgbp/4Msc4/IoKWXojOJoqK/b7dNaDT08CwaVMFe6
         OwNy5mhKqEj5w==
Content-Disposition: inline
In-Reply-To: <ZF6rACJzilA06oe+-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, May 12, 2023 at 06:09:20PM -0300, Jason Gunthorpe wrote:
> On Fri, May 12, 2023 at 06:45:13PM +1000, Alistair Popple wrote:
> 
> > However review comments suggested it needed to be added as part of
> > memcg. As soon as we do that we have to address how we deal with shared
> > memory. If we stick with the original RLIMIT proposal this discussion
> > goes away, but based on feedback I think I need to at least investigate
> > integrating it into memcg to get anything merged.
> 
> Personally I don't see how we can effectively solve the per-page
> problem without also tracking all the owning memcgs for every
> page. This means giving each struct page an array of memcgs
> 
> I suspect this will be too expensive to be realistically
> implementable.

Agree. To get the precise shared usage count, it needs to track
the usage at the page level.

It is possible to track just <smemcg,memcg> pair at the
leaf node of the memcg. At the parent memcg it needs to avoid
counting the same page twice. So it does need to track per page
memcgs set that it belongs to.


Chris

> If it is done then we may not even need a pin controller on its own as
> the main memcg should capture most of it. (althought it doesn't
> distinguish between movable/swappable and non-swappable memory)
> But this is all being done for the libvirt people, so it would be good
> to involve them
> 
> Jason
> 
