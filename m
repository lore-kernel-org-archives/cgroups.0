Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545352609EE;
	Wed, 24 Jun 2026 04:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782275538; cv=none; b=c1QMXuw3U0B9WDzgSOSPZkVSrSXXQ2af+r9Pj0LKsz5gpOiHnyt8Yh7B2j17AI2GsMwS3dmJGGIaFnIIveaWetmLYnCucipFaXvgM7wMF7sKxTr1xdZUyBkm0Hzft5aLe6ldUf8VZIv1lIQW6CTqNW1VSLHW6Fpj674vx2GzhKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782275538; c=relaxed/simple;
	bh=MaGlivGFSzOdBp6Y7/8vEL3ekTgG1EOiUnycebev6+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wv1CiOrPSnTT8W/vnknbzp+UcczPPkNdjkHMnqu3cIduhaBATkCjRcVxUVr10i7ya4I2VzYPEeFkeMprHzGgip5LTD4tZU9BXCyaW27FWhIWYlVMRCmfausG5ocI3oTiAQ8/zzRDI/7WZU7OCf037nzMS6RbJ4OkRnCzF54uehE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OI/OFz9D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OI/OFz9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BA01F000E9;
	Wed, 24 Jun 2026 04:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782275537;
	bh=LBhmepcwPAdQionL9hmPZMgzcc89UpJpdK93qrjxZJo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OI/OFz9DymW+iYnLZeYRRldiKNHw0HgtGF2VlN4i5hyPAVwJe+ax1XsOyElWBq/aS
	 U7rq4r8fhPlyoIrJydvW6RGcIywyyj2L79UgobqC1ckM/VGQ6caHxeef6n7HGFpIbk
	 Nhvx2luzsJbOQMsiAHbHXyEjKfKS8Mi/gnI40pLklfLuRoAbrX+F652MWVp2PWrxCI
	 zk7IEcI1E+Yn7Os6gUiz2tzGST3u4ZEwX49xcKc2AtnbUugo00+Fjrb0MoDCtsx2G8
	 xjd4GMt6eldAY+RFljA354JxREf70W+lAlFg4CYlgIJwf7SskbkPVPEaVZ36kQcHXc
	 9Fr0klbnH5fNA==
Message-ID: <a3393f60-4ada-4768-a369-900350c97cf6@kernel.org>
Date: Wed, 24 Jun 2026 13:32:09 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
To: Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Guopeng Zhang <guopeng.zhang@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260623082614.81621-1-guopeng.zhang@linux.dev>
 <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
 <5be54565-00be-4c05-91ca-0825fa925167@kylinos.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <5be54565-00be-4c05-91ca-0825fa925167@kylinos.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------9edyMpZu0YLeoI6wTH0LWs7N"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------9edyMpZu0YLeoI6wTH0LWs7N
Content-Type: multipart/mixed; boundary="------------QRl4NJCYxXXLAPrioGkZRTFF";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Guopeng Zhang <guopeng.zhang@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <a3393f60-4ada-4768-a369-900350c97cf6@kernel.org>
Subject: Re: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
References: <20260623082614.81621-1-guopeng.zhang@linux.dev>
 <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
 <5be54565-00be-4c05-91ca-0825fa925167@kylinos.cn>
In-Reply-To: <5be54565-00be-4c05-91ca-0825fa925167@kylinos.cn>

--------------QRl4NJCYxXXLAPrioGkZRTFF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/23/26 6:02 PM, Guopeng Zhang wrote:
> =E5=9C=A8 2026/6/23 16:42, Harry Yoo =E5=86=99=E9=81=93:
>>
>> On 6/23/26 5:26 PM, Guopeng Zhang wrote:
>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>
>>> A patch filename was accidentally inserted into the comment describin=
g
>>> the nr_bytes field of struct obj_stock_pcp. Remove it.
>> nit: perhaps add something like
>> "Fix a typo in the comment (target -> targets)"?
> Hi Harry,

Hi Guopeng,

> Thanks for the review and the Ack.
>=20
> Yes, I also fixed the "target -> targets" typo, but missed mentioning i=
t
> in the commit message.

No worries :)
It's not a big deal, just wanted to mention.

> I'll be more careful about describing all changes
> clearly next time.

Thanks!

> If a respin is needed, I'll add it to the commit
> message and carry your Acked-by.

I guess it's okay to not respin for this.

Thanks!

> Thanks,
> Guopeng
>=20
>>> No functional change.
>>>
>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>> ---
>> FWIW,
>> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>>
>> Thanks!
>>
>>>  mm/memcontrol.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 6dc4888a90f3..3eedfc4e84a0 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -2039,7 +2039,7 @@ struct obj_stock_pcp {
>>>  	/*
>>>  	 * On rare archs with 256KiB base page size (hexagon and powerpc 44=
x)
>>>  	 * keep nr_bytes to unsigned int as uint16_t cannot represent the f=
ull
>>> -e patches/memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch	 * sub-=
page remainder. Such archs are not cacheline optimization target.
>>> +	 * sub-page remainder. Such archs are not cacheline optimization ta=
rgets.
>>>  	 */
>>>  	unsigned int nr_bytes[NR_OBJ_STOCK];
>>>  #else

--=20
Cheers,
Harry / Hyeonggon

--------------QRl4NJCYxXXLAPrioGkZRTFF--

--------------9edyMpZu0YLeoI6wTH0LWs7N
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajtdyQAKCRCGXBN6rc5S
1vnvAP9byEYeRrjQ2Dz1Xv7nHkARJWKR43ZTTZCNji2vF2IMAAEAloDAjd2BL2GK
jiEpldoBcQUH1F0yDwUYGCFqNNuI6wI=
=MgY7
-----END PGP SIGNATURE-----

--------------9edyMpZu0YLeoI6wTH0LWs7N--
