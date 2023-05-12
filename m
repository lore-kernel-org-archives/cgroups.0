From: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Date: Fri, 12 May 2023 05:51:40 +0000
Message-ID: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
 <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com>
 <IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <20230511211338.oi4xwoueqmntsuna@google.com>
 <CH3PR11MB734512D5836DBA1F1F3AE7CDFC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB7345F99927E27ED49EEFC6E5FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512050429.22du3gt6rrq6e37a@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683870721; x=1715406721;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a0YRRNH6Jem08syi0+ULqPbhpNskb9dPUuFUAJrKZg0=;
  b=ZQ9e5tNqg2/KLoe0a9BTLS+uyrlzCFh7QcuMF8KdA5hRujRFiAHrdY1d
   YSBbRLLyp1cPO/8kBo4wOrAs5eHA+L5319lsC4A+ZHuXVFc0JJKJyYI76
   suBDDEWDX41Vz9G7VcIJ9aYYc+3c4f54lF09e5W1dmr8wQhZKVLr9VD8I
   u6b4cpcVK5NZxDeq5ORKlX079SRw+Na/yRT97L2NtUy4mALlt9Z2y1cEB
   +Td+sQ5DKiprcLmsjeMDVkRVPd80Ug/fYCs7w8kAD9prw9Xt1k7QihjSq
   cTEv9fDkQcC3PcqbkoUaj/+LpVGhu/RV+IFApbmG62NfSmpMakS2DXxLF
   A==;
In-Reply-To: <20230512050429.22du3gt6rrq6e37a-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <Brandeburg-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



> -----Original Message-----
> From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Sent: Friday, May 12, 2023 1:07 PM
> To: Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Linux MM <linux-
> mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>; Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Paolo Abeni
> <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> Brandeburg-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org; Brandeburg, Jesse <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> Srinivas, Suresh <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Chen, Tim C
> <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; You, Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a pro=
per
> size
>=20
> On Fri, May 12, 2023 at 03:23:45AM +0000, Zhang, Cathy wrote:
> > Remove the invalid mail addr added unintentionally.
> >
>=20
> Sorry that was my buggy script.
>=20
> [...]
> > >
> > > Hi Shakeel,
> > >
> > > Run with the temp change you provided,  the output shows it comes to
> > > drain_stock_1(), Here is the call trace:
> > >
> > >      8.96%  mc-worker        [kernel.vmlinux]            [k] page_cou=
nter_cancel
> > >             |
> > >              --8.95%--page_counter_cancel
> > >                        |
> > >                         --8.95%--page_counter_uncharge
> > >                                   drain_stock_1
> > >                                   __refill_stock
> > >                                   refill_stock
> > >                                   |
> > >                                    --8.88%--try_charge_memcg
> > >                                              mem_cgroup_charge_skmem
> > >                                              |
> > >                                               --8.87%--__sk_mem_raise=
_allocated
> > >                                                         __sk_mem_sche=
dule
> > >                                                         |
> > >                                                         |--5.37%--tcp=
_try_rmem_schedule
> > >                                                         |          tc=
p_data_queue
> > >                                                         |          tc=
p_rcv_established
> > >                                                         |          tc=
p_v4_do_rcv
> >
>=20
> Thanks a lot. This tells us that one or both of following scenarios are
> happening:
>=20
> 1. In the softirq recv path, the kernel is processing packets from multip=
le
> memcgs.
>=20
> 2. The process running on the CPU belongs to memcg which is different fro=
m
> the memcgs whose packets are being received on that CPU.

Thanks for sharing the points, Shakeel! Is there any trace records you want=
 to
collect?

>=20
> BTW have you seen this performance issue when you run the client and
> server on different machines? I am wondering if RFS would be good enough
> for such scenario and we only need to worry about the same machine case.

The same test scenario is tried between two machines which are on the same
network but with network topology, both of the two machines are with 1Gbit =
NIC.
There is no hot paths observed, but it might because that the systems are
not so busy, for memtier shows the average transfer speed is down to a few
tenth of original on the same machine.
