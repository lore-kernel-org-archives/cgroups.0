From: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Date: Thu, 1 Jun 2023 02:48:04 +0000
Message-ID: <CH3PR11MB73454186CA28AE6ACCEA9674FC499@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com>
 <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
 <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020>
 <20230517162447.dztfzmx3hhetfs2q@google.com>
 <ZHcJUF4f9VcnyGVt@xsang-OptiPlex-9020>
 <20230531194520.qhvibyyaqg7vwi6s@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685587688; x=1717123688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tTJ1vvZADbL8vUVkExWcnitnFYjIscYcfqdFABJhLdM=;
  b=epapZFmjYn6sNqcIZEE09w5a/MsZZRWS3T7nEitxGPt/qOj3fa49Lm3+
   /WCWuKGf2flF/KwXKEgXE7eEBnECgRf4lEBMtI01W+7P9hHpiZL9fXm5i
   esd+hcLyjl5IvuHrzYqjnk7b8dlmdDnS/ePIEWMPUeCNcPH0jsq/I9P8C
   NI3MumFHrCU2qo6Lv8uaceIQQWWb3oyjX/hHJ6KH4cKhsUmLUREAfzeV+
   EAqjusUrcInXnHSc60kjxLndfpMUc8mBL4TaEot7AJ0Ckg8JIqVfUIQIw
   GJR88ey/VYkL+kogJllGaskVxIdBvXfMvn9gm8ENUJnQDEVMVynwkvNT5
   w==;
In-Reply-To: <20230531194520.qhvibyyaqg7vwi6s-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Sang, Oliver" <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Tang, Feng" <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Li, Philip" <philip.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Liu, Yujie" <yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>



> -----Original Message-----
> From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Sent: Thursday, June 1, 2023 3:45 AM
> To: Sang, Oliver <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Yin, Fengwei
> <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Tang, Feng <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Eric Dumazet
> <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>; Cgroups
> <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>;
> davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Brandeburg, Jesse
> <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Srinivas, Suresh
> <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Chen, Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; You,
> Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Li, Philip <philip.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Liu, Yujie
> <yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a pro=
per
> size
>=20
> Hi Oliver,
>=20
> On Wed, May 31, 2023 at 04:46:08PM +0800, Oliver Sang wrote:
> [...]
> >
> > we applied below patch upon v6.4-rc2, so far, we didn't spot out
> > performance impacts of it to other tests.
> >
> > but we found -7.6% regression of netperf.Throughput_Mbps
> >
>=20
> Thanks, this is what I was looking for. I will dig deeper and decide how =
to
> proceed (i.e. improve this patch or work on long term approach).

Hi Shakeel,
If I understand correctly, I think the long-term goal you mentioned is to
implement a per-memcg per-cpu cache or a percpu_counter solution, right?
A per-memcg per-cpu cache solution can avoid the uncharge overhead and
reduce charge overhead, while the percpu_counter solution can help avoid
the charge overhead ultimately. It seems both are necessary and complex.

The above is from memory side, regarding to our original proposal that is t=
o
tune the reclaim threshold from network side, Eric and you worry about that
it might re-introduce the OOM issue. I see the following two interfaces in
network stack, which indicate the memory usage status, so is it possible to
tune the reclaim threshold to smaller when enter memory pressure and set
it to 64K when leave memory pressure? How do you think?
        void                    (*enter_memory_pressure)(struct sock *sk);
        void                    (*leave_memory_pressure)(struct sock *sk);

