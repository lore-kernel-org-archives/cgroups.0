Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9281B477982
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127675; cv=none; b=CYgibADHHyqPEjwIWfZFboLTAQF4/Kqvd5Rzg+/iGkocI+a14JWE2RCT5y9PW9I1zzFsi6znKXysWAGTqzQa7fg+LeikjPEGKdLWDyPz/ddYkGwaA4ZzEnpueRzsSuMNmtJhjBRW7/y3HIfjv+1xfozrVUmJjr7vpKiETnVql7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127675; c=relaxed/simple;
	bh=qKOrk4ZpdygBcHTzM6yIeZBltWpVde0shkwhzwQGYhA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J9C61/vnPbax+P+RnQwqGBgdsXfNtauhKRTdPC1ZiW4nPjXdEvpjKjRRe70sn/Gaoy02WdOTcvTPWo6kNGqZrf9JCPcPWL3aleyfKG+tdr7TCjfeKZnMTrMHEPJY3DHOE1YosPcVuPoGMX0ZPNFaHivylBEP/EWbmH257GGyyso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qqf5DJPc; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qqf5DJPc"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4758bd3731bso1736341f8f.0
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 08:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784127672; x=1784732472; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vz9m2fMjwxafHbkl7XFVNeLKmdyS/JjM0NsjBw69d7Q=;
        b=Qqf5DJPc5CdeBvy/0ptDwxy5dU90Ijv+srMNJ6eNoO6OnFNuxv7ObcsKSBt0vVo4iV
         x2FW9NKrVHxi4S2DultftFzA1KnOildBIR2pV/jUJmFQi8D/xbVZl89wdttcpUT980us
         MyUm8edk4ciE6tVHVWTNSkAy98LYzq3dBbwMzwhqYk16i4uEJrayNqZ2Hexr1zik38o4
         UQVYWCzdAsQF39e87D6bXvmL0A8kjd5hcIANZQeGyaN5JpBQFbDsmtUU0iaqmwNHLR0o
         6u8bb+U1/Fxz27BDpWnZxBbXgNnIQy6bgGTEZYBCKpgozd3pe2lzHYrhZ0YUk3Ka3eos
         7JHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784127672; x=1784732472;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vz9m2fMjwxafHbkl7XFVNeLKmdyS/JjM0NsjBw69d7Q=;
        b=P9BIiee+mKgBhS7p3/f8g337jqDrMvLOzOhswZACKM9Sq7IbgEjsQpRuwSviKtu+ML
         44p/BrHd3VjE/ZnoizxXiO4eO1ynWoP85ELsuup23zYtYqxtyYDnuoWgquiHWtEey+fR
         z+do/y64rM6JZU/7HcEEq/atQvhyrZMg+MMbMKL4Nhy76ZckRgdCa+bSmofduHhTq9O/
         QOMX0Bxu3sGRhZc9cI19sWU6NupMCC8xF4rzVDBvtRXutCD8zilaAz0EknX07/3Lj9k+
         HIuk3iyJBO1dpvSYjw/1oLJdlfZGJH1w4cmJbGnO0jMi7XjotIcGTj5ElCGJGwOl5Z7Q
         v2Ww==
X-Forwarded-Encrypted: i=1; AHgh+RpP1Whrw3PM0X08U4WQwuLutTqTycDDen8GI89UthlmT6KSzRjzPOqTzY7bBq7aYRuM566xQlNL@vger.kernel.org
X-Gm-Message-State: AOJu0YxY8x9KurXPZIwUnrpTXaCF+FkvUHivoa+YSalOuGKlgkOK58aW
	9mT3SVSq31gSqZBgxvSl9fMTqlN8qgnGjufRz2daLSKHw1CxqGS2thS6
X-Gm-Gg: AfdE7ckDuDGa1FmqD48d4BbGgMPI4i9NUgUWJH68JLeHRMjJWTZm/l11KHdrd6bGn15
	bGWJq6CDwSGgehm1YSsPJsOlChzFPX0yPdQfdL7byd4HLIM5y9DKUZrQEBIa6z1CwEhHTngSFd9
	UoY9vn6+wXSWvGaFVC67xElP86sEPVBQTN17FjQXW2fGrODKw/7LtnQ9L1anuHHlzPQvuRpcEVJ
	HBgpy03RnZIaf3cOGwI+iu/loLWK1n4c3GB4K1bO33iQSYqMrA4rkQif/3CL0Tpar6v2mz71zkh
	HtnYXYyKevZjMv5nzClzxusWhJK5r0xSLuUnSDBpXELdUIkCw8s4wCVwUJ36N6tVzL3R/zqva0p
	OpLFyR8DbWDoxZ6Ik98SnF87jmeQfJ/ld7iaidpM3PKnbpXNbqnm3GdiICNixZebi5iVSUJxAfY
	f1Q5ZMhtxMjrSg3932G/YdnsZHGirRUNzI6Jcwb4r3qNvzOPZyMQ==
X-Received: by 2002:a05:6000:4810:b0:47e:96f6:ab7f with SMTP id ffacd0b85a97d-47f2dcc1174mr24109536f8f.16.1784127671424;
        Wed, 15 Jul 2026 08:01:11 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a63esm17501217f8f.9.2026.07.15.08.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 08:01:10 -0700 (PDT)
Date: Wed, 15 Jul 2026 16:01:09 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: axboe@kernel.dk, tj@kernel.org, josef@toxicpanda.com,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] blk-throttle: fix divide-by-zero on legacy iops limit
 of 0
Message-ID: <20260715160109.51f553a7@pumpkin>
In-Reply-To: <882fbac2-bd42-44a7-8fba-b387b3f0fb2b@linux.dev>
References: <20260714103552.1335658-1-cui.tao@linux.dev>
	<20260714123754.7a88a65b@pumpkin>
	<882fbac2-bd42-44a7-8fba-b387b3f0fb2b@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Jul 2026 20:44:19 +0800
Tao Cui <cui.tao@linux.dev> wrote:

> =E5=9C=A8 2026/7/14 19:37, David Laight =E5=86=99=E9=81=93:
...
> >>  	tg_update_slice(tg, rw);
> >> @@ -1386,7 +1391,8 @@ static ssize_t tg_set_conf(struct kernfs_open_fi=
le *of,
> >>  	if (is_u64)
> >>  		*(u64 *)((void *)tg + of_cft(of)->private) =3D v;
> >>  	else
> >> -		*(unsigned int *)((void *)tg + of_cft(of)->private) =3D v;
> >> +		*(unsigned int *)((void *)tg + of_cft(of)->private) =3D
> >> +			min_t(u64, v, UINT_MAX); =20
> >=20
> > The LHS casts look horrid - there has to be a nicer way to do that.
> >=20
> > And you don't need min_t() a plain min() will be fine.
> >  =20
> Hi David,
>=20
> Both done in v2 =E2=80=94 introduced a void *field local so the writes re=
ad
> *(u64 *)field / *(unsigned int *)field, and switched to
> min(v, (u64)UINT_MAX).

You don't need the cast either.

	David

>=20
> Thanks,
> Tao
> > 	David
> >=20
> >=20
> >  =20
> >> =20
> >>  	tg_conf_updated(tg, false);
> >>  	ret =3D 0; =20
> >  =20
>=20

