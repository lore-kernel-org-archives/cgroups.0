From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v2 7/9] blk-iocost: fix UAF in ioc_pd_free
Date: Tue, 6 Dec 2022 15:53:31 +0800
Message-ID: <aa924294-2f54-1b53-fc6e-e4f8fa019b14@huaweicloud.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-8-linan122@huawei.com>
 <Y4fAJpKcVL7Q9hgY@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y4fAJpKcVL7Q9hgY-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun!

=D4=DA 2022/12/01 4:42, Tejun Heo =D0=B4=B5=C0:
> On Wed, Nov 30, 2022 at 09:21:54PM +0800, Li Nan wrote:
>> 	T1		     T2			T3
>>    //delete device
>>    del_gendisk
>>     bdi_unregister
>>      bdi_remove_from_list
>>       synchronize_rcu_expedited
>>
>> 		         //rmdir cgroup
>> 		         blkcg_destroy_blkgs
>> 		          blkg_destroy
>> 		           percpu_ref_kill
>> 		            blkg_release
>> 		             call_rcu
>>     rq_qos_exit
>>      ioc_rqos_exit
>>       kfree(ioc)
>> 					   __blkg_release
>> 					    blkg_free
>> 					     blkg_free_workfn
>> 					      pd_free_fn
>> 					       ioc_pd_free
>> 						spin_lock_irqsave
>> 						 ->ioc is freed
>>
>> Fix the problem by moving the operation on ioc in ioc_pd_free() to
>> ioc_pd_offline(), and just free resource in ioc_pd_free() like iolatency
>> and throttle.
>>
>> Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> I wonder what we really wanna do is pinning ioc while blkgs are still aro=
und
> but I think this should work too.
>=20

I just found that this is not enough, other problems still exist:

t1:	=09
bio_init
  bio_associate_blkg
   //get blkg->refcnt
......
submit_bio
  blk_throtl_bio
  // bio is throttlled, user thread can exit
  			t2:
			// blkcg online_pin is zero
			blkcg_destroy_blkgs
			 blkg_destroy
			  ioc_pd_offline
			   list_del_init(&iocg->active_list)
t3:
ioc_rqos_throttle
  blkg_to_iocg
  // got the iocg that is offlined
   iocg_activate
   // acitvate the iocg again

For consequence, kernel can crash due to access unexpected
address. Fortunately, bfq already handle similar problem by checking
blkg->online in bfq_bio_bfqg(), this problem can be fixed by checking
it in iocg_activate().

BTW, I'm still working on checking if other policies have the same
problem.

Thanks,
Kuai

