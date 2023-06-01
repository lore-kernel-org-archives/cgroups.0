From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Thu, 1 Jun 2023 05:21:51 +0200
Message-ID: <CANn89iLPbd3JDvFCgvZO_1sppCyFDFQ_fqJy3kKBAucJrbm_vw@mail.gmail.com>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com> <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
 <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020> <20230517162447.dztfzmx3hhetfs2q@google.com>
 <ZHcJUF4f9VcnyGVt@xsang-OptiPlex-9020> <20230531194520.qhvibyyaqg7vwi6s@google.com>
 <CH3PR11MB73454186CA28AE6ACCEA9674FC499@CH3PR11MB7345.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685589723; x=1688181723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qStCg7KeACsi2KVI6FrJ4HwOilw06iHPCAkOe/uQA0Q=;
        b=F+a3gWbqc5yvzXtyB3N2bGHooXmHV7Le8S7sW/yVCLU1xCJkFBNuoEDREeMI6S9a/u
         lEROE+8+MoRFn4wAK/rstppBHdPTTqAgNqGrFvTfpI9msilONOo3t8TLTVwLryJfLfPR
         ZIP4335XuiBknLIzEDoiQkYlG1esppjFJCpnROVgTEvdgS1jX0CBispLOZR21JAYON0+
         yZL9aEcdajnFvUdH8HjETBefVAUJ3Osp5WDLyoJOYd9jkttb/DB7HSDDnxoxexiFXXOd
         4DL2z1hWQ6cii5dD8B6ar/6dErmSUvHLdtgMEUIsXjyEaXPpt0mzvHis8tbBNdpUNcqy
         E0fA==
In-Reply-To: <CH3PR11MB73454186CA28AE6ACCEA9674FC499-WQKEFoXy4NEXvLLfv6NhPJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Sang, Oliver" <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Tang, Feng" <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Li, Philip" <philip.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Liu, Yujie" <yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, Jun 1, 2023 at 4:48=E2=80=AFAM Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>=
 wrote:
>
>
>
> > -----Original Message-----
> > From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Sent: Thursday, June 1, 2023 3:45 AM
> > To: Sang, Oliver <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Yin, Fengwei
> > <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Tang, Feng <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Eric Dumazet
> > <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>; Cgroups
> > <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>;
> > davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Brandeburg, Jesse
> > <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Srinivas, Suresh
> > <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Chen, Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; You,
> > Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> > netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Li, Philip <philip.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Liu, Yujie
> > <yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> > Hi Oliver,
> >
> > On Wed, May 31, 2023 at 04:46:08PM +0800, Oliver Sang wrote:
> > [...]
> > >
> > > we applied below patch upon v6.4-rc2, so far, we didn't spot out
> > > performance impacts of it to other tests.
> > >
> > > but we found -7.6% regression of netperf.Throughput_Mbps
> > >
> >
> > Thanks, this is what I was looking for. I will dig deeper and decide ho=
w to
> > proceed (i.e. improve this patch or work on long term approach).
>
> Hi Shakeel,
> If I understand correctly, I think the long-term goal you mentioned is to
> implement a per-memcg per-cpu cache or a percpu_counter solution, right?
> A per-memcg per-cpu cache solution can avoid the uncharge overhead and
> reduce charge overhead, while the percpu_counter solution can help avoid
> the charge overhead ultimately. It seems both are necessary and complex.
>
> The above is from memory side, regarding to our original proposal that is=
 to
> tune the reclaim threshold from network side, Eric and you worry about th=
at
> it might re-introduce the OOM issue. I see the following two interfaces i=
n
> network stack, which indicate the memory usage status, so is it possible =
to
> tune the reclaim threshold to smaller when enter memory pressure and set
> it to 64K when leave memory pressure? How do you think?
>         void                    (*enter_memory_pressure)(struct sock *sk)=
;
>         void                    (*leave_memory_pressure)(struct sock *sk)=
;
>

No it is not possible to reclaim 'the threshold' when 10,000,000
sockets are alive and kept
a budget around 64KB.
We do not have a shrinker and we do not want one.
The only sensible solution is per-cpu cache.
This was done in core TCP stack, a similar solution is needed in
memcg, if memcg has to be used.
