From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Fri, 13 Jan 2023 09:25:11 +0800
Message-ID: <ac95dfb8-b1b6-8916-bde8-1edb573e7ca5@huaweicloud.com>
References: <Y7iCId3pnEnLqY8G@slm.duckdns.org>
 <875eb43e-202d-5b81-0bff-ef0434358d99@huaweicloud.com>
 <Y7xbpidpq7+DqJan@slm.duckdns.org>
 <a71f997f-6cae-d57b-85dd-2fd499d238f6@huaweicloud.com>
 <Y72wF/b0/xNRmP7f@slm.duckdns.org>
 <53b30ac8-d608-ba0b-8b1b-7fe5cfed6d61@huaweicloud.com>
 <Y77s0f741mFfGlTO@slm.duckdns.org>
 <4aeef320-c6c8-d9b4-8826-d58f00ea6264@huaweicloud.com>
 <Y8CrloCDGhbU42OH@slm.duckdns.org>
 <efa1c73b-e94f-373f-e535-2cfc32ce2433@huaweicloud.com>
 <Y8CwwghZ0adMsHFC@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y8CwwghZ0adMsHFC-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/01/13 9:15, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Fri, Jan 13, 2023 at 09:10:25AM +0800, Yu Kuai wrote:
>>> only activate the policy when the controller is actually enabled. So, i=
dk.
>>> What's wrong with synchronizing the two removal paths? blkcg policies a=
re
>>> combinations of cgroups and block device configurations, so having exit
>>> paths from both sides is kinda natural.
>>
>> I still can't figure out how to synchronizing them will a mutex. Maybe
>> I'm being foolish...
>=20
> Hmm... can't you just use e.g. per-bdev mutex which is grabbed by both
> blkg_free_workfn() and blkcg_deactivate_policy()?
>=20

I think hold the lock in blkg_free_workfn() is too late, pd_free_fn()
for parent from blkcg_deactivate_policy() can be called first.

t1: remove cgroup t1/t2
blkcg_destroy_blkgs
  blkg_destroy
   percpu_ref_kill(&blkg->refcnt)
    blkg_release
     blkg_free
      schedule_work(&blkg->free_work)
      // t1 is done

t2: handle t1 from removing device
blkcg_deactivate_policy
  pd_free_fn
  // free parent
				t3: from t1
				blkg_free_workfn
				 pd_free_fn
				 // free child

Thanks,
Kuai

