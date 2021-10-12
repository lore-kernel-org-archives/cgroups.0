From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: check blkcg policy is enabled in
 blkg_create()
Date: Tue, 12 Oct 2021 09:09:03 +0800
Message-ID: <93193221-fbad-444f-c325-9f19d4c5931b@huawei.com>
References: <20211008072720.797814-1-yukuai3@huawei.com>
 <20211011152318.GA61605@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20211011152318.GA61605-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 2021/10/11 23:23, Michal Koutn=C3=BD wrote:
> Hello.
>=20
> On Fri, Oct 08, 2021 at 03:27:20PM +0800, Yu Kuai <yukuai3-hv44wF8Li93QT0=
dZR+AlfA@public.gmane.org> wrote:
>> This is because blkg_alloc() is called from blkg_conf_prep() without
>> holding 'q->queue_lock', and elevator is exited before blkg_create():
>  =20
> IIUC the problematic interleaving is this one (I've noticed `blkg->pd[i]
> =3D NULL` to thread 2 call trace):

The new blkg will not add to blkg_list untill pd_init_fn() is done in
blkg_create(), thus blkcg_deactivate_policy() can't access this blkg.
>=20
>> thread 1                            thread 2
>> blkg_conf_prep
>>   spin_lock_irq(&q->queue_lock);
>>   blkg_lookup_check -> return NULL
>>   spin_unlock_irq(&q->queue_lock);
>>
>>   blkg_alloc
>>    blkcg_policy_enabled -> true
>>    pd =3D ->pd_alloc_fn
>>                                     blk_mq_exit_sched
>>                                      bfq_exit_queue
>>                                       blkcg_deactivate_policy
>>                                        spin_lock_irq(&q->queue_lock);
>>                                        __clear_bit(pol->plid, q->blkcg_p=
ols);
>>
>                                          pol->pd_free_fn(blkg->pd[i]);
>                                          blkg->pd[i] =3D NULL;
>>
>>                                        spin_unlock_irq(&q->queue_lock);
>>                                      q->elevator =3D NULL;
>      blkg->pd[i] =3D pd
>>    spin_lock_irq(&q->queue_lock);
>>     blkg_create
>>      if (blkg->pd[i])
>>       ->pd_init_fn -> q->elevator is NULL
>>    spin_unlock_irq(&q->queue_lock);
>=20
> In high-level terms, is this a race between (blk)io controller attribute
> write and a device scheduler (elevator) switch?
> If so, I'd add it to the commit message.
>=20
>> Fix the problem by checking that policy is still enabled in
>> blkg_create().
>=20
> Is this sufficient wrt some other q->elevator users later?
>=20
>> @@ -252,6 +266,9 @@ static struct blkcg_gq *blkg_create(struct blkcg *bl=
kcg,
>>   		goto err_free_blkg;
>>   	}
>>  =20
>=20
> I'd add a comment here like:
>=20
>> Re-check policies are still enabled, since the caller blkg_conf_prep()
>> temporarily drops q->queue_lock and we can race with
>> blk_mq_exit_sched() removing policies.

Thanks for your advice.

Best regards,
Kuai
>=20
>> +	if (new_blkg)
>> +		blkg_check_pd(q, new_blkg);
>> +
>=20
> Thanks,
> Michal
> .
>=20
