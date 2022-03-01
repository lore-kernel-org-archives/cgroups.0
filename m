From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v9] block: cancel all throttled bios in del_gendisk()
Date: Tue, 1 Mar 2022 21:54:28 +0800
Message-ID: <836f0686-4ac8-327d-2bab-64a762ea8673@huawei.com>
References: <20220210115637.1074927-1-yukuai3@huawei.com>
 <YhuyBgZSS6m/Mwu6@infradead.org> <Yhxnkg0AEaj36t+a@T590>
 <YhyYpWHGVhs3J/dk@infradead.org> <Yh31bQu3gbXoDBuK@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Yh31bQu3gbXoDBuK@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2022/03/01 18:29, Ming Lei =D0=B4=B5=C0:
> On Mon, Feb 28, 2022 at 01:40:53AM -0800, Christoph Hellwig wrote:
>> On Mon, Feb 28, 2022 at 02:11:30PM +0800, Ming Lei wrote:
>>>> FYI, this crashed left rigt and center when running xfstests with
>>>> traces pointing to throtl_pending_timer_fn.
>>>
>>> Can you share the exact xfstests test(fs, test)? Or panic log?
>>>
>>> I can't reproduce it when running './check -g auto' on XFS, meantime
>>> tracking throtl_pending_timer_fn().
>>
>>  From a quick run using f2fs:
>>
>> generic/081 files ... [  316.487861] run fstests generic/081 at 2022-02-=
28 09:38:40
>=20
> Thanks for providing the reproducer.
>=20
> The reason is that the pending timer is deleted in blkg's release
> handler, so the timer can still be live after request queue is released.
>=20
> The patch of 'block: cancel all throttled bios in del_gendisk()' should j=
ust
> make it easier to trigger.
>=20
> After patch of "block: move blkcg initialization/destroy into disk alloca=
tion/
> release handler" lands, the issue can be fixed easily by:

Hi,

Thanks for locating this problem,

Perhaps this patch should wait for the problem to be solved.

Thanks,
Kuai
>=20
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index fa063c6c0338..e8d4be5e1de3 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -82,6 +82,7 @@ static void blkg_free(struct blkcg_gq *blkg)
>   		if (blkg->pd[i])
>   			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
>  =20
> +	blk_put_queue(blkg->q);
>   	free_percpu(blkg->iostat_cpu);
>   	percpu_ref_exit(&blkg->refcnt);
>   	kfree(blkg);
> @@ -297,9 +298,10 @@ static struct blkcg_gq *blkg_create(struct blkcg *bl=
kcg,
>   	blkg->online =3D true;
>   	spin_unlock(&blkcg->lock);
>  =20
> -	if (!ret)
> +	if (!ret && blk_get_queue(q))
>   		return blkg;
> -
> +	else if (!ret)
> +		ret =3D -ENODEV;
>   	/* @blkg failed fully initialized, use the usual release path */
>   	blkg_put(blkg);
>   	return ERR_PTR(ret);
>=20
>=20
> Thanks,
> Ming
>=20
> .
>=20
