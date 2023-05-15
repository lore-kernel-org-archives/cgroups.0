From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Mon, 15 May 2023 12:50:31 -0700
Message-ID: <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com> <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com> <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684180242; x=1686772242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9rBJ3Z6bMHq4Ea+F9E390Qio2yO4hD5BQLQUaMJTwA=;
        b=zuGmhQqWoc00Zv+gSniT0ih5yLMGbWSeEIuQWzHekcnhvcSP3KRGL9187CcmxOPax+
         MtLWl4dMw6+fJkaOFeH/pb6g8aCL788Q5ZZGDWgqcMRScbxYfgV/MyGdvNzRfE8+31f1
         nD2iSIsiwu4VYaNTTBv35fZqIEC2HvSxslyNnPR+trOvrP/gt6qnD8VQaqzf8VrVJmwg
         y0ds0jsLE2nvp5xBk9c9AGFPD1mhBoCLZEtzLWpFD8Q5hCJvGHjz1E9xXVphXw1eCiQQ
         rVpBywpzQX9RwqIMhWYO9rCR4/kJ///SolL7aMR4r8Xqev9LMV6pO/WIocrN3XFUtjjU
         aOWA==
In-Reply-To: <CH3PR11MB7345E9EAC5917338F1C357C0FC789-WQKEFoXy4NEXvLLfv6NhPJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yin Fengwei <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

+Feng, Yin and Oliver

On Sun, May 14, 2023 at 11:27=E2=80=AFPM Zhang, Cathy <cathy.zhang-ral2JQCrhuE@public.gmane.org=
m> wrote:
>
>
>
> > -----Original Message-----
> > From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Sent: Monday, May 15, 2023 12:13 PM
> > To: Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Linux MM <linux-
> > mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>; Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Paolo Abeni
> > <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> > Brandeburg, Jesse <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Srinivas, Suresh
> > <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Chen, Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; You,
> > Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> > netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> > On Sun, May 14, 2023 at 8:46=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel=
.com>
> > wrote:
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > Sent: Saturday, May 13, 2023 1:17 AM
> > > > To: Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Eric Dumazet
> > > > <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>; Cgroups
> > > > <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>;
> > > > davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Brandeburg-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org;
> > > > Brandeburg, Jesse <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Srinivas, Suresh
> > > > <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Chen, Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> > > > You, Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> > > > netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as
> > > > a proper size
> > > >
> > > > On Fri, May 12, 2023 at 05:51:40AM +0000, Zhang, Cathy wrote:
> > > > >
> > > > >
> > > > [...]
> > > > > >
> > > > > > Thanks a lot. This tells us that one or both of following
> > > > > > scenarios are
> > > > > > happening:
> > > > > >
> > > > > > 1. In the softirq recv path, the kernel is processing packets
> > > > > > from multiple memcgs.
> > > > > >
> > > > > > 2. The process running on the CPU belongs to memcg which is
> > > > > > different from the memcgs whose packets are being received on t=
hat
> > CPU.
> > > > >
> > > > > Thanks for sharing the points, Shakeel! Is there any trace record=
s
> > > > > you want to collect?
> > > > >
> > > >
> > > > Can you please try the following patch and see if there is any
> > improvement?
> > >
> > > Hi Shakeel,
> > >
> > > Try the following patch, the data of 'perf top' from system wide
> > > indicates that the overhead of page_counter_cancel is dropped from 15=
.52%
> > to 4.82%.
> > >
> > > Without patch:
> > >     15.52%  [kernel]            [k] page_counter_cancel
> > >     12.30%  [kernel]            [k] page_counter_try_charge
> > >     11.97%  [kernel]            [k] try_charge_memcg
> > >
> > > With patch:
> > >     10.63%  [kernel]            [k] page_counter_try_charge
> > >      9.49%  [kernel]            [k] try_charge_memcg
> > >      4.82%  [kernel]            [k] page_counter_cancel
> > >
> > > The patch is applied on the latest net-next/main:
> > > befcc1fce564 ("sfc: fix use-after-free in
> > > efx_tc_flower_record_encap_match()")
> > >
> >
> > Thanks a lot Cathy for testing. Do you see any performance improvement =
for
> > the memcached benchmark with the patch?
>
> Yep, absolutely :- ) RPS (with/without patch) =3D +1.74

Thanks a lot Cathy.

Feng/Yin/Oliver, can you please test the patch at [1] with other
workloads used by the test robot? Basically I wanted to know if it has
any positive or negative impact on other perf benchmarks.

[1] https://lore.kernel.org/all/20230512171702.923725-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
/

Thanks in advance.
