From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v2 8/9] block: fix null-pointer dereference in
 ioc_pd_init
Date: Thu, 1 Dec 2022 18:23:16 +0800
Message-ID: <431dcb3f-4572-7fd0-9e5d-90b6c34d577c@huaweicloud.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-9-linan122@huawei.com>
 <Y4fCE7XxcpDfWyDJ@slm.duckdns.org>
 <9ca2b7ab-7fd3-a9a3-12a6-021a78886b54@huaweicloud.com>
 <Y4h94m8QMPtS4xJV@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y4h94m8QMPtS4xJV-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2022/12/01 18:11, Tejun Heo =D0=B4=B5=C0:
> On Thu, Dec 01, 2022 at 10:12:13AM +0800, Yu Kuai wrote:
>> 1) By mentioning that "del_gendisk() is quiescing the queue", do you
>> suggest to add rcu_read_lock()? This seems wrong because blk_iocost_init
>> requires memory allocation.
>=20
> Quiescing uses SRCU so that should be fine but I'm not sure whether this =
is
> the right one to piggyback on. Jens should have a better idea.
>=20
> Thanks.
>=20

Currently SRCU is used if BLK_MQ_F_BLOCKING set, otherwise RCU is used.

dispatch:
#define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops) \
do {                                                            \
         if ((q)->tag_set->flags & BLK_MQ_F_BLOCKING) {          \
                 int srcu_idx;                                   \
                                                                 \
                 might_sleep_if(check_sleep);                    \
                 srcu_idx =3D srcu_read_lock((q)->tag_set->srcu);  \
                 (dispatch_ops);                                 \
                 srcu_read_unlock((q)->tag_set->srcu, srcu_idx); \
         } else {                                                \
                 rcu_read_lock();                                \
                 (dispatch_ops);                                 \
                 rcu_read_unlock();                              \
         }                                                       \
} while (0)

quiesce:
void blk_mq_wait_quiesce_done(struct blk_mq_tag_set *set)
{
         if (set->flags & BLK_MQ_F_BLOCKING)
                 synchronize_srcu(set->srcu);
         else
                 synchronize_rcu();
}

Thanks,
Kuai

