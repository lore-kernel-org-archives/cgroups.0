From: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Date: Fri, 12 May 2023 02:38:46 +0000
Message-ID: <CH3PR11MB734512D5836DBA1F1F3AE7CDFC759@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
 <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com>
 <IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <20230511211338.oi4xwoueqmntsuna@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683859130; x=1715395130;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YpSODKnMTBnfb3N0AHUEPGQQ8u9heGeBOGBq9g5+d2A=;
  b=IUNXvS/PQwn0HKRS2Gw8DiSxxwFZ/DX/UzMxUQ6EdPdFCtrMLiKAA4Re
   ymgwKE8vIK8eC2AXCrfORfUFfbdZVTIe2KCQD2K3EQ4KDn8gp3DqhSwmH
   G7KCiCixNuWeYfbWBRtRioT+qAVeHqGX5ENffgarcesrqgFzb7gG0xKW1
   YrKG6DGmnwf4HX9uM7BqrKXn7B2tdYSGOizhX7YQrGcXXqVR+sO67Vphl
   3OgfXb2u9bisP1aAXEDt8O0ttMeMRL4klyeNwJ454UjGuiNAEt7NeaKbX
   VNtpEMxsSpeedYyqLEnWJr9JiaPQWtbX9S5oYAOXg4LVRCZf6xn4uhznb
   w==;
In-Reply-To: <20230511211338.oi4xwoueqmntsuna-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Zhang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <Zhang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <Brandeburg-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <Srinivas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <Chen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <You-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



> -----Original Message-----
> From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Sent: Friday, May 12, 2023 5:19 AM
> To: Zhang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org; Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Linux MM <linux-
> mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>; Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Paolo Abeni
> <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> Brandeburg-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org; Brandeburg, Jesse <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> Srinivas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org; Srinivas, Suresh <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> Chen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org; Chen, Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; You-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org;
> You, Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a pro=
per
> size
>=20
> On Thu, May 11, 2023 at 09:26:46AM +0000, Zhang, Cathy wrote:
> >
> [...]
> >
> >      8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter=
_cancel
> >             |
> >              --8.97%--page_counter_cancel
> >                        |
> >                         --8.97%--page_counter_uncharge
> >                                   drain_stock
> >                                   __refill_stock
> >                                   refill_stock
> >                                   |
> >                                    --8.91%--try_charge_memcg
> >                                              mem_cgroup_charge_skmem
>=20
> I do want to understand for above which specific condition in __refill_st=
ock is
> causing to drain stock in the charge code path. Can you please re-run and
> profile your test with following code snippet (or use any other mechanism
> which can answer the question)?
>=20
> From f1d91043f21f4b29717c78615b374d79fc021d1f Mon Sep 17 00:00:00
> 2001
> From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Date: Thu, 11 May 2023 20:00:19 +0000
> Subject: [PATCH] Debug drain on charging.
>=20
> ---
>  mm/memcontrol.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c index
> d31fb1e2cb33..4c1c3d90a4a3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2311,6 +2311,16 @@ static void drain_local_stock(struct work_struct
> *dummy)
>  		obj_cgroup_put(old);
>  }
>=20
> +static noinline void drain_stock_1(struct memcg_stock_pcp *stock) {
> +	drain_stock(stock);
> +}
> +
> +static noinline void drain_stock_2(struct memcg_stock_pcp *stock) {
> +	drain_stock(stock);
> +}
> +
>  /*
>   * Cache charges(val) to local per_cpu area.
>   * This will be consumed by consume_stock() function, later.
> @@ -2321,14 +2331,14 @@ static void __refill_stock(struct mem_cgroup
> *memcg, unsigned int nr_pages)
>=20
>  	stock =3D this_cpu_ptr(&memcg_stock);
>  	if (READ_ONCE(stock->cached) !=3D memcg) { /* reset if necessary */
> -		drain_stock(stock);
> +		drain_stock_1(stock);
>  		css_get(&memcg->css);
>  		WRITE_ONCE(stock->cached, memcg);
>  	}
>  	stock->nr_pages +=3D nr_pages;
>=20
>  	if (stock->nr_pages > MEMCG_CHARGE_BATCH)
> -		drain_stock(stock);
> +		drain_stock_2(stock);
>  }
>=20
>  static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages=
)
> --
> 2.40.1.606.ga4b1b128d6-goog

Hi Shakeel,

Run with the temp change you provided,  the output shows it comes to drain_=
stock_1(),
Here is the call trace:

     8.96%  mc-worker        [kernel.vmlinux]            [k] page_counter_c=
ancel
            |
             --8.95%--page_counter_cancel
                       |
                        --8.95%--page_counter_uncharge
                                  drain_stock_1
                                  __refill_stock
                                  refill_stock
                                  |
                                   --8.88%--try_charge_memcg
                                             mem_cgroup_charge_skmem
                                             |
                                              --8.87%--__sk_mem_raise_alloc=
ated
                                                        __sk_mem_schedule
                                                        |
                                                        |--5.37%--tcp_try_r=
mem_schedule
                                                        |          tcp_data=
_queue
                                                        |          tcp_rcv_=
established
                                                        |          tcp_v4_d=
o_rcv

