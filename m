Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D0542BE99;
	Thu, 16 Jul 2026 15:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784214790; cv=none; b=Nn7XFyMhhEdA/+IYbv1qXxi5PtLVvvIGq8a5uJ70oqPWkch2TAT72nZW8UoaN3oh9zGY3uAOB48Gw36J7tocm8945GE9+mUdtbCdFxIp3ubpPKYv3/RNDv8eEvwiJJLaFFLemlVXFDIJxDNZPXHXgnoO291O+VeAHW+u653EDZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784214790; c=relaxed/simple;
	bh=Mtsz1JGp7yKeDrv4+ghvZjPGCW+AsmqDWuXcpGJjRrw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=B0sBvaDuMeuWCixRBJR/CHfu4plbfChEDFs6MS7fHy6IQQtEm7HBgs+JE19LhPkVLd8/1ubAaEAyEp/dMYaiOiyZ4uNLCQrLfU9xmcjGlqnUvE5QU29V4RqxIcg/cofrVWTXVdnE/EN6ghVp0nQG9SQegF/OEO/JRUWGcWduwA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mLcDqsB/; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mLcDqsB/"
Date: Thu, 16 Jul 2026 23:10:53 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784214783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uEVjuKEE313Wr7qI4skNtlbA5prDr65jRKZqQQtE1M0=;
	b=mLcDqsB/5yz7fx+VLqJAWp2xiZS1jaLV8JMfwTBB2eKxKwFxOvgP8WfGVrMqfRS+0ZY4Yu
	kRkGyqMVtxg2VPEmEx+v+WdZiVLOsmOifXQNr1KXtrGrC01zCZ+u0Y7XtKuQacd86UOe+p
	vPHOSXHxNnLJrK4yEKCR7FSf9pWeG9Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
To: David Laight <david.laight.linux@gmail.com>
CC: axboe@kernel.dk, tj@kernel.org, josef@toxicpanda.com, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_blk-throttle=3A_fix_divid?=
 =?US-ASCII?Q?e-by-zero_on_legacy_iops_limit_of_0?=
In-Reply-To: <20260715160109.51f553a7@pumpkin>
References: <20260714103552.1335658-1-cui.tao@linux.dev> <20260714123754.7a88a65b@pumpkin> <882fbac2-bd42-44a7-8fba-b387b3f0fb2b@linux.dev> <20260715160109.51f553a7@pumpkin>
Message-ID: <476584BB-6659-49D9-B4F6-7C84A35BD73D@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT



=E4=BA=8E 2026=E5=B9=B47=E6=9C=8815=E6=97=A5 GMT+08:00 23:01:09=EF=BC=8CDa=
vid Laight <david=2Elaight=2Elinux@gmail=2Ecom> =E5=86=99=E9=81=93=EF=BC=9A
>On Wed, 15 Jul 2026 20:44:19 +0800
>Tao Cui <cui=2Etao@linux=2Edev> wrote:
>
>> =E5=9C=A8 2026/7/14 19:37, David Laight =E5=86=99=E9=81=93:
>=2E=2E=2E
>> >>  	tg_update_slice(tg, rw);
>> >> @@ -1386,7 +1391,8 @@ static ssize_t tg_set_conf(struct kernfs_open_=
file *of,
>> >>  	if (is_u64)
>> >>  		*(u64 *)((void *)tg + of_cft(of)->private) =3D v;
>> >>  	else
>> >> -		*(unsigned int *)((void *)tg + of_cft(of)->private) =3D v;
>> >> +		*(unsigned int *)((void *)tg + of_cft(of)->private) =3D
>> >> +			min_t(u64, v, UINT_MAX); =20
>> >=20
>> > The LHS casts look horrid - there has to be a nicer way to do that=2E
>> >=20
>> > And you don't need min_t() a plain min() will be fine=2E
>> >  =20
>> Hi David,
>>=20
>> Both done in v2 =E2=80=94 introduced a void *field local so the writes =
read
>> *(u64 *)field / *(unsigned int *)field, and switched to
>> min(v, (u64)UINT_MAX)=2E
>
>You don't need the cast either=2E

Noted, this will be done in the next version=2E

Thanks,
Tao
>
>	David
>
>>=20
>> Thanks,
>> Tao
>> > 	David
>> >=20
>> >=20
>> >  =20
>> >> =20
>> >>  	tg_conf_updated(tg, false);
>> >>  	ret =3D 0; =20
>> >  =20
>>=20
>
