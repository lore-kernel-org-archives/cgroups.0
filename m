From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net] net-memcg: avoid stalls when under memory pressure
Date: Fri, 21 Oct 2022 09:28:16 -0700
Message-ID: <CANn89iKTi5TYyFOOpgw3P0eTi1Gqn4k-eX+xRTX78Q4sAunm2Q@mail.gmail.com>
References: <20221021160304.1362511-1-kuba@kernel.org> <CALvZod4eezAXpehT4jMiQry4JQ5igJs7Nwi1Q+YhVpDcQ8BMRA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7YjWeeaWgFLjAUGfmbgfIRsxpgHwo4UFKZK7Wbeepqc=;
        b=nhtvYWkC/E6D/cIGPS18+wj1i0pHBYcpmU0hy9O0Pp5A+fU1yw4uOqmMducUyy3f61
         U5PsWm9tGudNevxozXKS0i/TJEq4h0eCCyumGVqYt3buxcvadP5BtyOLjw5O+qkq3wMF
         befLRzDim+g6by/CrI4F8pTKUjKxX59Ew0RUfG75dSJFy2Kk8D5Z+feSTy5egaXSkwc+
         tZhZJT8vgxej1wTeLMjHsHsxe5f170hJuhFhG9GfgIdlPdYmBLiFnCraha/n+SShSMHK
         Coe2ZbUe84V9YSL/8Y7w/g48SawI//8r3wAT+/R1JG6FNilju3K69fXmUUaCJ3ib1d6t
         rCLA==
In-Reply-To: <CALvZod4eezAXpehT4jMiQry4JQ5igJs7Nwi1Q+YhVpDcQ8BMRA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ncardwell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ycheng-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Fri, Oct 21, 2022 at 9:26 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Fri, Oct 21, 2022 at 9:03 AM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > As Shakeel explains the commit under Fixes had the unintended
> > side-effect of no longer pre-loading the cached memory allowance.
> > Even tho we previously dropped the first packet received when
> > over memory limit - the consecutive ones would get thru by using
> > the cache. The charging was happening in batches of 128kB, so
> > we'd let in 128kB (truesize) worth of packets per one drop.
> >
> > After the change we no longer force charge, there will be no
> > cache filling side effects. This causes significant drops and
> > connection stalls for workloads which use a lot of page cache,
> > since we can't reclaim page cache under GFP_NOWAIT.
> >
> > Some of the latency can be recovered by improving SACK reneg
> > handling but nowhere near enough to get back to the pre-5.15
> > performance (the application I'm experimenting with still
> > sees 5-10x worst latency).
> >
> > Apply the suggested workaround of using GFP_ATOMIC. We will now
> > be more permissive than previously as we'll drop _no_ packets
> > in softirq when under pressure. But I can't think of any good
> > and simple way to address that within networking.
> >
> > Link: https://lore.kernel.org/all/20221012163300.795e7b86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
> > Suggested-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Fixes: 4b1327be9fe5 ("net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()")
> > Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> > CC: weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
> > CC: shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
> > CC: ncardwell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
> > CC: ycheng-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
> > ---
> >  include/net/sock.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 9e464f6409a7..22f8bab583dd 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -2585,7 +2585,7 @@ static inline gfp_t gfp_any(void)
> >
> >  static inline gfp_t gfp_memcg_charge(void)
> >  {
> > -       return in_softirq() ? GFP_NOWAIT : GFP_KERNEL;
> > +       return in_softirq() ? GFP_ATOMIC : GFP_KERNEL;
> >  }
> >
>
> How about just using gfp_any() and we can remove gfp_memcg_charge()?

How about keeping gfp_memcg_charge() and adding a comment on its intent ?

gfp_any() is very generic :/
