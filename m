From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 3/4] block/rq_qos: use a global mutex to protect
 rq_qos apis
Date: Thu, 5 Jan 2023 09:35:21 +0800
Message-ID: <df2f7a60-467f-08ce-2a3e-1dc7853424aa@huaweicloud.com>
References: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
 <20230104085354.2343590-4-yukuai1@huaweicloud.com>
 <Y7XyIzGptuqO8EAt@slm.duckdns.org> <Y7YZnM/nqb0gxOei@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y7YZnM/nqb0gxOei-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/01/05 8:28, Tejun Heo =D0=B4=B5=C0:
> Hello, again.
>=20
> On Wed, Jan 04, 2023 at 11:39:47AM -1000, Tejun Heo wrote:
>>> 2) rq_qos_add() and blkcg_activate_policy() is not atomic, if
>>>     rq_qos_exit() is done before blkcg_activate_policy(),
>>>     null-ptr-deference can be triggered.
>>
>> I'm not sure this part does. I think it'd be better to guarantee that de=
vice
>> destruction is blocked while these configuration operations are in progr=
ess
>> which can be built into blkg_conf helpers.
>=20
> A bit more explanation:
>=20
> Usually, this would be handled in the core - when a device goes away, its
> sysfs files get shut down before stuff gets freed and the sysfs file remo=
val
> waits for in-flight operations to finish and prevents new ones from
> starting, so we don't have to worry about in-flight config file operations
> racing against device removal.
>=20
> Here, the problem isn't solved by that because the config files live on
> cgroupfs and their lifetimes are not coupled with the block devices'. So,=
 we
> need to synchronize manually. And, given that, the right place to do is t=
he
> blkg config helpers cuz they're the ones which establish the connection
> between cgroup and block layer.

Thanks for the explanation, I agree with that.
>=20
> Can you please take a look at the following patchset I just posted:
>=20
>    https://lkml.kernel.org/r/20230105002007.157497-1-tj-DgEjT+Ai2ygdnm+yR=
OfE0A@public.gmane.org
>=20
> After that, all these configuration operations are wrapped between
> blkg_conf_init() and blkg_conf_exit() which probably are the right place =
to
> implement the synchronization.

I see that, blkg_conf_init() and blkg_conf_exit() is good, however there
are some details I want to confirm:

1) rq_qos_add() can be called from iocost/iolatency, where
blkg_conf_init() will be called first, while rq_qos_add() can also be
called from wbt, where there is no blkg_conf_init(). Hence it seems to
me we need two locks here, one to protect rq_qos apis; one to
synchronize policy configuration and device removal.

2) If you agree with 1), it seems better to use the other lock in device
level, consider that there is no need to synchronize confituration for
different devices.

Thanks,
Kuai
>=20
> Thanks.
>=20

