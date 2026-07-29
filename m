Received: from va-2-47.ptr.blmpb.com (va-2-47.ptr.blmpb.com [209.127.231.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F034307B7
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 07:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785311412; cv=none; b=hRZRjwriBGNGy4SL4QeRuRsF+YWlSpzzPhIphVVUvMfS3ohXMl9D3/5X2+kB3rCxBEEk1p12B7CgWmSKmeVefnGZQA9dyoOAn2D5LRH2gqHTeQ5O19htaoQvdDg1VMmov1+AZKmhdZoeDSEvY7XnE+7W12Qr+l77SEia51d769g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785311412; c=relaxed/simple;
	bh=KC3Wo11Ct+2uOiHT7HPByS9+84fqXgjLK4ohlHd3ku0=;
	h=In-Reply-To:Message-Id:Content-Type:To:From:Subject:Date:
	 Mime-Version:References:Cc; b=c9+2397dBNANXBhrdsmSGazQmJk3581G0OoGIu5T1PPGx2P3pYz8ruNv6Yq9RIJwmaILOFwJCzx+bgc7n2t2Drm7SSxvou3wjaNpJQS2TLUaXhPXepMh7AcnYMynmVqsL6qq4/7O4ykVQ86sCHOHljhSLTHPW5nmgMFg7NjegDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=XKx9EqKp; arc=none smtp.client-ip=209.127.231.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="XKx9EqKp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785311386;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=AxmneLfrzuVTrA/cdKZxrYsiTIoO5HvjDIhZsSYs+6A=;
 b=XKx9EqKp/d7Bxkqtw+t1o+esXHyepasRIqKDDMCNT33VKZxHNF1xSgnWK+byEDonJNjIM5
 FSRAFmoHSbNWgqg5Q5834Jc8nVwxwD6E3DLBt0kZbXPrP77UEd1Xioy47ceMKac7xai3vS
 LnFelmSGHBsPCTUX8dKQoPKIdYQnYH5o49iq+ZQ9ADzQFHYpXuAOaHRR7/ecYent+GPbTj
 lkzp7D7NwWAB65D2I+EfiOoZ51QVTrKPP4ZOAbt/4O0Z0ql7q9EsD2uXQBRg4D18yOTmQV
 F0n1CRcUbuOC8gWsC4Su4xs3OXNDdS5quxRCNvAbbFIDAl9QJ4VmM7WDLay43g==
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a69b09a+f5f5c4+vger.kernel.org+yukuai@fygo.io>
In-Reply-To: <166abc44-f725-4181-9fc9-f808f4894a17@linux.dev>
Message-Id: <09ad2dfb-bc21-4a72-a239-9e5e3fc38312@fygo.io>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Wed, 29 Jul 2026 07:49:45 +0000
Content-Transfer-Encoding: quoted-printable
To: "Tao Cui" <cui.tao@linux.dev>, <axboe@kernel.dk>, <tj@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [RFC PATCH v2 1/8] block: associate blkg in submit_bio instead of bio_set_dev
Date: Wed, 29 Jul 2026 15:49:41 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260724123037.3004560-1-yukuai@kernel.org> <20260724123037.3004560-2-yukuai@kernel.org> <166abc44-f725-4181-9fc9-f808f4894a17@linux.dev>
Reply-To: yukuai@fygo.io
Cc: <hch@lst.de>, <dongsheng.yang@linux.dev>, <cengku@gmail.com>, 
	<josef@toxicpanda.com>, <nilay@linux.ibm.com>, <ming.lei@redhat.com>, 
	<linux-block@vger.kernel.org>, <cgroups@vger.kernel.org>

Hi,

=E5=9C=A8 2026/7/29 15:23, Tao Cui =E5=86=99=E9=81=93:
>
> =E5=9C=A8 2026/7/24 20:30, Yu Kuai =E5=86=99=E9=81=93:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> bio_set_dev(), bio_init() and bio_reset() associate a bio with a blkg fo=
r
>> its target queue. That association may have to create a new blkg, and
>> currently there are lots of callers that are under atomic context.
>>
>> Move the association out of those helpers and into the submit path, whic=
h
>> is always sleepable (submit_bio_noacct() already does might_sleep()):
>>
>>    - submit_bio() associates new I/O before bio_set_ioprio(), whose
>>      blkcg_set_ioprio() reads the policy from bio->bi_blkg.
>>
>>    - submit_bio_noacct() (re)associates when a bio has no blkg yet or wa=
s
>>      remapped to a different queue.  blk_throtl_bio() and the rq_qos
>>      throttlers (iocost, iolatency) pair bio->bi_blkg with the queue of
>>      bio->bi_bdev, so a remapped bio must be reassociated to the new que=
ue.
>>
>>    - bio_set_dev() no longer associates; instead it drops the existing b=
lkg
>>      when the device changes, since that blkg is tied to the old queue.
>>      bio_init()/bio_reset() leave bi_blkg NULL.
>>
> Hi Yu Kuai,
>
> Thanks for the v2 rework.  One thing I wanted to flag: with association
> moved out of bio_set_dev(), blkcg_punt_bio_submit() can be reached with
> bio->bi_blkg =3D=3D NULL.  btrfs compressed writeback builds its bio with=
out
> going through the generic submit_bio() (it uses btrfs_submit_bio()), so t=
he
> new association never runs for it, and the bio_set_dev() in
> btrfs_submit_dev_bio() no longer fills bi_blkg in.
>
> I reproduced it on this tree -- btrfs with compress=3Dzstd, write dirty d=
ata
> from a non-root cgroup, sync:
>
>    BUG: kernel NULL pointer dereference, address 0x30
>    Workqueue: btrfs-worker btrfs_work_helper
>    RIP: 0010:blkcg_punt_bio_submit+0xf/0x80
>    Call Trace:
>     btrfs_submit_bio+0x79/0x1a0
>     btrfs_work_helper+0x141/0x360
>
> 0x30 is the offset of ->parent in struct blkcg_gq, and RBX (bio->bi_blkg)
> is NULL at the fault, so it's the `if (blkg->parent)` read.  Regular
> buffered writeback looked fine -- wbc_init_bio() sets bi_blkg early -- so=
 it
> seems limited to the compressed path.

Thanks for the tests. Yes, I already know the problem, and replied a few da=
ys
ago. :)

>
>> Introduce bio_disassociate_blkg() to drop a bio's blkg reference and use=
 it
>> from bio_set_dev(), bio_uninit() and the bio freeing path, replacing the=
ir
>> open-coded blkg_put().
>>
>> This is the first step to convert protecting blkg with blkcg_mutex.
>>
>> Signed-off-by: Yu Kuai <yukuai@fygo.io>
>> ---
>>   block/bio.c         | 18 ++----------------
>>   block/blk-cgroup.c  | 18 ++++++++++++++++++
>>   block/blk-core.c    | 21 +++++++++++++++++++++
>>   include/linux/bio.h |  7 +++++--
>>   4 files changed, 46 insertions(+), 18 deletions(-)
>>
>> diff --git a/block/bio.c b/block/bio.c
>> index 6a2f6fc3413e..ea030c5e39a4 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -179,12 +179,7 @@ static inline gfp_t try_alloc_gfp(gfp_t gfp)
>>  =20
>>   void bio_uninit(struct bio *bio)
>>   {
>> -#ifdef CONFIG_BLK_CGROUP
>> -	if (bio->bi_blkg) {
>> -		blkg_put(bio->bi_blkg);
>> -		bio->bi_blkg =3D NULL;
>> -	}
>> -#endif
>> +	bio_disassociate_blkg(bio);
>>   	if (bio_integrity(bio))
>>   		bio_integrity_free(bio);
>>  =20
>> @@ -235,8 +230,6 @@ void bio_init(struct bio *bio, struct block_device *=
bdev, struct bio_vec *table,
>>   #ifdef CONFIG_BLK_CGROUP
>>   	bio->bi_blkg =3D NULL;
>>   	bio->issue_time_ns =3D 0;
>> -	if (bdev)
>> -		bio_associate_blkg(bio);
>>   #ifdef CONFIG_BLK_CGROUP_IOCOST
>>   	bio->bi_iocost_cost =3D 0;
>>   #endif
>> @@ -280,8 +273,6 @@ void bio_reset(struct bio *bio, struct block_device =
*bdev, blk_opf_t opf)
>>   	atomic_set(&bio->__bi_remaining, 1);
>>   	bio->bi_io_vec =3D bv;
>>   	bio->bi_bdev =3D bdev;
>> -	if (bio->bi_bdev)
>> -		bio_associate_blkg(bio);
>>   	bio->bi_opf =3D opf;
>>   }
>>   EXPORT_SYMBOL(bio_reset);
>> @@ -1803,17 +1794,12 @@ void bio_endio(struct bio *bio)
>>   		goto again;
>>   	}
>>  =20
>> -#ifdef CONFIG_BLK_CGROUP
>>   	/*
>>   	 * Release cgroup info.  We shouldn't have to do this here, but quite
>>   	 * a few callers of bio_init fail to call bio_uninit, so we cover up
>>   	 * for that here at least for now.
>>   	 */
>> -	if (bio->bi_blkg) {
>> -		blkg_put(bio->bi_blkg);
>> -		bio->bi_blkg =3D NULL;
>> -	}
>> -#endif
>> +	bio_disassociate_blkg(bio);
>>  =20
>>   	if (bio->bi_end_io)
>>   		bio->bi_end_io(bio);
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index d9676126c5b5..618e5566fa52 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -2170,6 +2170,24 @@ void bio_clone_blkg_association(struct bio *dst, =
struct bio *src)
>>   }
>>   EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
>>  =20
>> +/**
>> + * bio_disassociate_blkg - disassociate a bio from its blkg
>> + * @bio: target bio
>> + *
>> + * Drop the blkg reference held by @bio and clear the association.  Thi=
s is
>> + * used when a bio's target device changes (e.g. via bio_set_dev()): th=
e old
>> + * blkg is tied to the previous request_queue, so it is dropped here an=
d the
>> + * bio is reassociated to the new queue from the submit path.
>> + */
>> +void bio_disassociate_blkg(struct bio *bio)
>> +{
>> +	if (bio->bi_blkg) {
>> +		blkg_put(bio->bi_blkg);
>> +		bio->bi_blkg =3D NULL;
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(bio_disassociate_blkg);
>> +
>>   static int blk_cgroup_io_type(struct bio *bio)
>>   {
>>   	if (op_is_discard(bio->bi_opf))
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 365641266c9e..8103643b39fc 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -822,6 +822,20 @@ void submit_bio_noacct(struct bio *bio)
>>  =20
>>   	might_sleep();
>>  =20
>> +	/*
>> +	 * Associate the bio with a blkg for its target queue here, where it i=
s
>> +	 * safe to sleep, instead of in bio_set_dev()/bio_init() which may run
>> +	 * under a spinlock.  bio_set_dev() no longer associates, so a freshly
>> +	 * allocated or remapped bio has no blkg until it reaches the submit p=
ath.
>> +	 * Reassociate only when the bio was remapped to a different queue sin=
ce
>> +	 * it was last associated; blk_throtl_bio() and the rq_qos throttlers
>> +	 * rely on bio->bi_blkg matching the queue of bio->bi_bdev.
>> +	 */
>> +#ifdef CONFIG_BLK_CGROUP
>> +	if (!bio->bi_blkg || bio->bi_blkg->q !=3D q)
>> +		bio_associate_blkg(bio);
>> +#endif
>> +
>>   	/*
>>   	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
>>   	 * if queue does not support NOWAIT.
>> @@ -958,6 +972,13 @@ void submit_bio(struct bio *bio)
>>   		count_vm_events(PGPGOUT, bio_sectors(bio));
>>   	}
>>  =20
>> +	/*
>> +	 * bio_set_ioprio() -> blkcg_set_ioprio() reads the policy from
>> +	 * bio->bi_blkg, so associate the blkg (for new I/O, the first time) b=
efore
>> +	 * it runs.  This is the sleepable entry point for new I/O; remapped b=
ios
>> +	 * that reach submit_bio_noacct() directly are reassociated there.
>> +	 */
>> +	bio_associate_blkg(bio);
>>   	bio_set_ioprio(bio);
>>   	submit_bio_noacct(bio);
>>   }
>> diff --git a/include/linux/bio.h b/include/linux/bio.h
>> index 8f33f717b14f..7a7509c8a59a 100644
>> --- a/include/linux/bio.h
>> +++ b/include/linux/bio.h
>> @@ -507,6 +507,7 @@ void bio_associate_blkg(struct bio *bio);
>>   void bio_associate_blkg_from_css(struct bio *bio,
>>   				 struct cgroup_subsys_state *css);
>>   void bio_clone_blkg_association(struct bio *dst, struct bio *src);
>> +void bio_disassociate_blkg(struct bio *bio);
>>   void blkcg_punt_bio_submit(struct bio *bio);
>>   #else	/* CONFIG_BLK_CGROUP */
>>   static inline void bio_associate_blkg(struct bio *bio) { }
>> @@ -515,6 +516,7 @@ static inline void bio_associate_blkg_from_css(struc=
t bio *bio,
>>   { }
>>   static inline void bio_clone_blkg_association(struct bio *dst,
>>   					      struct bio *src) { }
>> +static inline void bio_disassociate_blkg(struct bio *bio) { }
>>   static inline void blkcg_punt_bio_submit(struct bio *bio)
>>   {
>>   	submit_bio(bio);
>> @@ -524,10 +526,11 @@ static inline void blkcg_punt_bio_submit(struct bi=
o *bio)
>>   static inline void bio_set_dev(struct bio *bio, struct block_device *b=
dev)
>>   {
>>   	bio_clear_flag(bio, BIO_REMAPPED);
>> -	if (bio->bi_bdev !=3D bdev)
>> +	if (bio->bi_bdev !=3D bdev) {
>>   		bio_clear_flag(bio, BIO_BPS_THROTTLED);
>> +		bio_disassociate_blkg(bio);
>> +	}
>>   	bio->bi_bdev =3D bdev;
>> -	bio_associate_blkg(bio);
>>   }
>>  =20
>>   /*

--=20
Thanks,
Kuai
