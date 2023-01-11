From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Wed, 11 Jan 2023 09:36:25 +0800
Message-ID: <53b30ac8-d608-ba0b-8b1b-7fe5cfed6d61@huaweicloud.com>
References: <20221227125502.541931-1-yukuai1@huaweicloud.com>
 <20221227125502.541931-2-yukuai1@huaweicloud.com>
 <Y7XzUee5Bq+DoIC1@slm.duckdns.org>
 <c63ee2ad-23d5-3be0-c731-28494398b391@huaweicloud.com>
 <Y7cX0SJ0y6+EIY5Q@slm.duckdns.org>
 <7dcdaef3-65c1-8175-fea7-53076f39697f@huaweicloud.com>
 <Y7iCId3pnEnLqY8G@slm.duckdns.org>
 <875eb43e-202d-5b81-0bff-ef0434358d99@huaweicloud.com>
 <Y7xbpidpq7+DqJan@slm.duckdns.org>
 <a71f997f-6cae-d57b-85dd-2fd499d238f6@huaweicloud.com>
 <Y72wF/b0/xNRmP7f@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y72wF/b0/xNRmP7f-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/01/11 2:36, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Tue, Jan 10, 2023 at 09:39:44AM +0800, Yu Kuai wrote:
>> As I tried to explain before, we can make sure blkg_free() is called
>> in order, but blkg_free() from remove cgroup can concurrent with
>> deactivate policy, and we can't guarantee the order of ioc_pd_free()
>> that is called both from blkg_free() and blkcg_deactivate_policy().
>> Hence I don't think #3 is possible.
>=20
> Hahaha, sorry that I keep forgetting that. This doesn't really feel like
> that important or difficult part of the problem tho. Can't it be solved by
> synchronizing blkg free work item against the deactivate path with a mute=
x?
>=20

I'm not sure, of course this can fix the problem, but two spinlock
'blkcg->lock' and 'q->queue_lock' are used to protect blkg_destroy()
currently, add a mutex=A3=A8disk level?) requires a refactor, which seems
complex to me.

Thanks,
Kuai

