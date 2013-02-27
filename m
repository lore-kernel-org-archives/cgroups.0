From: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH] memcg: implement low limits
Date: Wed, 27 Feb 2013 14:11:19 +0400
Message-ID: <16331361959879@webcorp2g.yandex-team.ru>
References: <8121361952156@webcorp1g.yandex-team.ru> <xr93y5eacgmj.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1361959879;
	bh=uQmVUZmfZlayHYWmjenj7FMn1gU8Vu2IVOudI85nXnw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=IGRoVaDhcm8ij+CDFEVhZsazQBxXiEFx0lFUbYlua3PcFo7KExDtIJAEJHnrwCSkj
	 IIqCVmVUsaH0jUv4pmyBiRTCK4pamIgzQGMDTy42pWbMTUfbpPXyE2rdsauDiiDpAm
	 5QIV6NJ+1pcxNCjCMuXEKoYTZTsnfNBokpO8eXGU=
In-Reply-To: <xr93y5eacgmj.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner-Arquette <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org" <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

> So the new low limit is not a rigid limit. =9AGlobal reclaim can recl=
aim
> from a cgroup when its usage is below low_limit_in_bytes although suc=
h
> reclaim is less aggressive than when usage is above low_limit_in_byte=
s.
> Correct?

That's true.
But such reclaim occurs only on very small reclaiming priorities,=20
so it's not a common behavior. It's mostly a protection against=20
a case when all cgroups are under low limit (a results of wrong cgroups=
 configuration).

>
> Why doesn't memcg reclaim (i.e. !global_reclaim) also consider
> low_limit_in_bytes?

=46or some configurations (for instance, low_limit_in_bytes =3D=3D limi=
t_in_bytes) it will work ugly.
May be it's better to introduce some restrictions on setting memcg limi=
ts, but it will be
a much more significant change from a user's point of view.

>
> Do you have demonstration of how this improves system operation?

Assume, you have a machine with some production processes (db, web serv=
ers, etc) and a set=20
of additional helper processes. You have to protect production processe=
s from steeling theirs=20
memory by other processes.
You have constant memory starvation, so kswapd works fast permanently. =
The production processes=20
use, for instance, 80-90% of all physical memory.
Setting low limit for production cgroup to 80% of physical memory solve=
s this problem easily and secure.

And I see no possibility to solve this task with current hard- and soft=
 limits.
So, even if I set hard limit for all other processes to 20% of physical=
 memory, it doesn't mean that=20
production cgroup will not been scanned/reclaimed. Some magic with soft=
 limits can help in some cases,=20
but it's much more complex in configuration (see below).

> Why is soft_limit insufficient?


1) If I want to grant (and protect) some amount of memory to a cgroup, =
i have to set soft limits for=20
all other cgroups. I must consider total amount of memory, number of cg=
roups, theirs soft and hard limits.
Low limits provide an easier interface.
2) It works only on DEF_PRIORITY priority.
3) Also, it can be so, that my preferable cgroup is higher above it's s=
oft limit than=20
other cgroups (and it's hard to control), so it will be reclaimed more =
intensively than necessary.

>> =9ASigned-off-by: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
>> =9A---
>> =9A=9Ainclude/linux/memcontrol.h =9A| =9A=9A=9A7 +++++
>> =9A=9Ainclude/linux/res_counter.h | =9A=9A17 +++++++++++
>> =9A=9Akernel/res_counter.c =9A=9A=9A=9A=9A=9A=9A| =9A=9A=9A2 ++
>> =9A=9Amm/memcontrol.c =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A| =9A=9A67=
 +++++++++++++++++++++++++++++++++++++++++++
>> =9A=9Amm/vmscan.c =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A| =
=9A=9A=9A5 ++++
>> =9A=9A5 files changed, 98 insertions(+)
>
> Need to update Documentation/cgroups/memory.txt explaining the extern=
al
> behavior of this new know and how it interacts with soft_limit_in_byt=
es.

Will do.

Thank you!

--
Regards,
Roman
