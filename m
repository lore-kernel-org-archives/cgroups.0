From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] blk-throttle: enable io throttle for root in cgroup
 v2
Date: Thu, 27 Jan 2022 10:36:38 +0800
Message-ID: <235b0757-d322-2b6e-3ab6-ecc8c82f8f1e@huawei.com>
References: <20220114093000.3323470-1-yukuai3@huawei.com>
 <YfGE9L4i7DtNTo08@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YfGE9L4i7DtNTo08-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/01/27 1:29, Tejun Heo =D0=B4=B5=C0:
> On Fri, Jan 14, 2022 at 05:30:00PM +0800, Yu Kuai wrote:
>> RFC patch: https://lkml.org/lkml/2021/9/9/1432
>>
>> There is a proformance problem in our environment:
>>
>> A host can provide a remote device to difierent client. If one client is
>> under high io pressure, other clients might be affected.
>>
>> Limit the overall iops/bps(io.max) from the client can fix the problem,
>> however, config files do not exist in root cgroup currently, which makes
>> it impossible.
>>
>> This patch enables io throttle for root cgroup:
>>   - enable "io.max" and "io.low" in root
>>   - don't skip root group in tg_iops_limit() and tg_bps_limit()
>>   - don't skip root group in tg_conf_updated()
>>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Yeah, I'm kinda split. It's a simple change with some utility, but it's a=
lso
> something which doesn't fit with the cgroup feature or interface. It's
> regulating the whole system behavior. There's no reason for any of the
> control "groups" to be involved here and semantically the interface would
> fit a lot better under /proc, /sys or some other system-wide location. He=
re
> are some points to consider:
>=20
> * As a comparison, it'd be rather absurd to enable memory.max at system r=
oot
>    in terms of interface and most likely break whole lot of mm operations.
>=20
> * Resource control knobs of a cgroup belong to the parent as the parent is
>    responsible for divvying up the available resources to its children. H=
ere
>    too, the knobs are making sense because there's a higher level parent
>    (whether that's hypervisor or some network server).
>=20
> Is your use case VMs or network attached storage?
>=20
Hi,

In our case, the disk is provided by server, and such disk can be shared
by multipul clients. Thus for the client side, the server is a higher
level parent.

Theoretically, limit the io from server for each client is feasible,
however, the main reason we don't want to do this is the following
shortcoming:

client can still send io to server unlimited, we can just limit the
amount of io that can complete from server, which might cause too much
pressure on the server side.

Thanks,
Kuai
