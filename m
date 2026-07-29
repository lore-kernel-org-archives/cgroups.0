Received: from va-2-59.ptr.blmpb.com (va-2-59.ptr.blmpb.com [209.127.231.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8F639CCFC
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 07:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785311795; cv=none; b=rcF66rBOuKUAwf8u6XQJMDm6PdCvRM4mLy1vwyCN/R0mGCctyMOklB0CH+eMG6wNvPgMVjPLeg7muWfSUFFPb2o0wmF9R5CGXz+MJ5YbHYH6haGaeAdnO3qiswRxKJFK6HZ1CCaQrM93RIWnlMmk09H9ybBSjgmItYga+aHzqmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785311795; c=relaxed/simple;
	bh=GFC6cvYFjCy8PcEpi9iezeUy+GTVK7D3TMjp65uxQPk=;
	h=From:Message-Id:Mime-Version:In-Reply-To:References:To:Date:
	 Content-Type:Cc:Subject; b=KPTj+sb1KobKReLag+6LcUGN64RmWF4me76HLZumbNLrgvoePL92OXDRpHgNBRBmkRSJTD3kRFWdNsemn//xNdHrUmg6Yl2+/AnInZs20x5V8Z+mCKpYPGbwxHZPponcMIt8oqBwPNVgo4GBRGnM+XPOsLmiKuMYR0yS/DkYkCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=lqqEy/uo; arc=none smtp.client-ip=209.127.231.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="lqqEy/uo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785311781;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=kMuVRy2VKQURb6Pvns2GhsmiAIEC+KLV2+/wuVD8+2w=;
 b=lqqEy/uo7EjZIfLXA6MOObVyXanQaAFlMpScOgGRtMGYw3FxS6bfy21K2IJEqBaadXKeqq
 RMa0gTwpL3VujajaqtajIuKU6ESJEMwcx9m8Tv6ehhDvkNQQ9lKhqxcYe/I3GJj2nebEwH
 zzqPaSG8IDNZ8xQDShXL5eJJuVCerMPp7MP6JmhRyO7jpLTuGWJ83DlU/pBi8u5kxZn1jX
 0kJbj+mCpVQwkgrjArjoSGcYPnpnzy7ceNEyHXxyRbOYcOY/lQPMvFLZroi1Mb5Vs7i+1h
 VQ3Rsz4pkrKmLnO2lV9G7rF+M3MlB8u3K0rM9q9w6Hfz8jiuTAXMPkVDNFyLlA==
X-Lms-Return-Path: <lba+26a69b224+a3cc13+vger.kernel.org+yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <4540fd5c-ecea-433a-9bfb-f314b3933e3f@fygo.io>
Reply-To: yukuai@fygo.io
User-Agent: Mozilla Thunderbird
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <45ea6216-a6f6-4828-afd3-8acea8b949ab@linux.dev>
References: <20260724123037.3004560-1-yukuai@kernel.org> <20260724123037.3004560-8-yukuai@kernel.org> <45ea6216-a6f6-4828-afd3-8acea8b949ab@linux.dev>
To: "Tao Cui" <cui.tao@linux.dev>, <axboe@kernel.dk>, <tj@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Date: Wed, 29 Jul 2026 15:56:16 +0800
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Wed, 29 Jul 2026 07:56:20 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc: <hch@lst.de>, <dongsheng.yang@linux.dev>, <cengku@gmail.com>, 
	<josef@toxicpanda.com>, <nilay@linux.ibm.com>, <ming.lei@redhat.com>, 
	<linux-block@vger.kernel.org>, <cgroups@vger.kernel.org>
Subject: Re: [RFC PATCH v2 7/8] bfq: avoid blkg lookup from locked cgroup update

Hi,

=E5=9C=A8 2026/7/29 15:33, Tao Cui =E5=86=99=E9=81=93:
>
> =E5=9C=A8 2026/7/24 20:30, Yu Kuai =E5=86=99=E9=81=93:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> bfq_bio_bfqg() is called while bfqd->lock is held from the merge and
>> request insertion paths.  It walks bio->bi_blkg and its parent chain to
>> find the closest online BFQ group, and re-associates the bio by looking
>> the chosen blkg up again through bio_associate_blkg_from_css().
>>
>> Now that blkg creation runs under q->blkcg_mutex from the sleepable subm=
it
>> path, bio_associate_blkg_from_css() can sleep on a lookup miss, which BF=
Q
>> must not do while holding bfqd->lock.  The blkg BFQ wants is already in
>> hand from the ancestry walk, so update bio->bi_blkg by swapping referenc=
es
>> to that existing blkg directly instead of looking it up again by css.
>>
> Just checking the new bfq helper that swaps a bio's blkg: it does the
> blkg_put() without the NULL guard the old helper had.  Is there any path
> where BFQ could see a bio that hasn't been associated yet (bi_blkg =3D=3D=
 NULL)?
> The fallback branch calls it unconditionally, so if such a path exists it
> would crash.  My reading is the bio is always associated before it reache=
s
> BFQ, so it can't happen -- but wanted to ask in case I'm missing a path.

You're not missing. Bio must associate a blkg before submitting, you can se=
e
lots of places will deference bio's blkg directly.

>
> Thanks,
> Tao
>
>> Signed-off-by: Yu Kuai <yukuai@fygo.io>
>> ---
>>   block/bfq-cgroup.c | 16 +++++++++++++---
>>   1 file changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
>> index 42614aa78cd4..8a3ff9510386 100644
>> --- a/block/bfq-cgroup.c
>> +++ b/block/bfq-cgroup.c
>> @@ -604,6 +604,16 @@ static void bfq_link_bfqg(struct bfq_data *bfqd, st=
ruct bfq_group *bfqg)
>>   	}
>>   }
>>  =20
>> +static void bfq_bio_update_blkg(struct bio *bio, struct blkcg_gq *blkg)
>> +{
>> +	if (bio->bi_blkg =3D=3D blkg)
>> +		return;
>> +
>> +	blkg_get(blkg);
>> +	blkg_put(bio->bi_blkg);
>> +	bio->bi_blkg =3D blkg;
>> +}
>> +
>>   struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
>>   {
>>   	struct blkcg_gq *blkg =3D bio->bi_blkg;
>> @@ -616,13 +626,13 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bf=
qd, struct bio *bio)
>>   		}
>>   		bfqg =3D blkg_to_bfqg(blkg);
>>   		if (bfqg->pd.online) {
>> -			bio_associate_blkg_from_css(bio, &blkg->blkcg->css);
>> +			bfq_bio_update_blkg(bio, blkg);
>>   			return bfqg;
>>   		}
>>   		blkg =3D blkg->parent;
>>   	}
>> -	bio_associate_blkg_from_css(bio,
>> -				&bfqg_to_blkg(bfqd->root_group)->blkcg->css);
>> +	blkg =3D bfqg_to_blkg(bfqd->root_group);
>> +	bfq_bio_update_blkg(bio, blkg);
>>   	return bfqd->root_group;
>>   }
>>  =20

--=20
Thanks,
Kuai
