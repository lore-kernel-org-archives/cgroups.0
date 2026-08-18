Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930E32E6CB8
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 18:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076134; cv=none; b=C8Ut1bc+yka5ZGg4bf0WkIieYsrDbMZ9IIL2GjzuIhGXZMs0uRRPAmnr3+QPOfwJg5qTo3HFA9tbyXh2VvixtheauHcCqrZhDCpZr+iTSzSGv+k9cXYloN3nkjoxDeIOsxTx2poJny4wjN0xyvFtdC94bmuKFHv2+GVCTzmpYz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076134; c=relaxed/simple;
	bh=Qc4bVGCe3qEMGnA+qbnabGF8zvEkX45WHKJN4kW6+50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p1N0vJXQicVleMXUofgJZkzkVFyHHTgHM643mu//QP0ESt+v5959fYcFT7m9EznXdma3WMyiMv2KsvVFjIcnin+8SgA+xbjpBaswvAMNWScM9Hl9PZfEV7jE5maTFCf40y/69FYHB9T+p+aEJT1eb1EU5ifEXRGAkZ3dqtrKRBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oV7HAAOi; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oV7HAAOi"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8201447e8cdso3144617b3.3
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 11:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787076132; x=1787680932; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0hjtRsV2yPEQoUBARtT7YBGNucy1E88OECHhZ/RQsBs=;
        b=oV7HAAOiUbnZxOXIXxjUvaPqWTchPgQOFdBQJ0k6ApCp/nPmrjb3gdAvdRtw5IlNiv
         rBLDiQ6sgb4q2z3C4oVycLw5zVVHiqEr7dHegdTPL/LqJtc2mM+fWtrR8L8CSbbB1bSO
         59I6FMHZndyvEPRFWkjP9W/CjPlQ9bo0aYkoFnmdb6rqnVjhyMiAchSZnLjd3Mo/cS50
         oTy8A4JNdoa9HHKv4yQbzNFg/5kiKbsGRxg03bNEQwgQmMjXmlbgnDJ+yWfh4BFTRoZs
         XPYknuFu0GnYPK9PSne4QxO3Csob657OPgEZM/pMYQTy4MtIrl164C2CcOSOpTVbnF85
         x6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787076132; x=1787680932;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0hjtRsV2yPEQoUBARtT7YBGNucy1E88OECHhZ/RQsBs=;
        b=OcWpoMDuwsXcjKQ7QKKhlyDWSMlKgf4MuVhaooQR7Zsz+DTU5wc9bqOaWCNe+BxZjQ
         wdXSG1JhmqzzfDT+hmGCJKUp4qipWTsNbG9dEq/ziN2koWm9zr9dlZ5UFFhxP1CFgRCO
         PzTcMicWtO/P2ZGdbM8YkzsMBdW0Q4aA7w438ld915KAFm6N88cbdq4w9ryRijG0ckdR
         W/lo5s3Gfs89Vk2dgTtsz4I8QU3VfNTt7tHFKsfbpoM2pRGRs7xKFZNPuK/lhOQFKXHO
         RPUo+qtv/1Zw9V+grE53lrsSnBoqqWPxCNQ2eiTIy09/9qaelBD9vvJ0ZNLlYdrDKT5u
         tdLA==
X-Forwarded-Encrypted: i=1; AHgh+RqC4Q3HRahlQUlCpMIYQDBw9j524UpIsgwcxyFye6TnjVXDPohYufpxNHDhFial0afxuKusP2Mm@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2gQn5wWChqLPODd5w4XX1AVjk/q3Md1uwB12nsIVDaBR2z4Jf
	A9hkAoWyqBMA2t2yH4d/g2NXQIdszcMU5OxQHMqlsJlgJpMexjUf8azr
X-Gm-Gg: AR+sD10aullkcOeKhkNuQpC7xzVWwyaQ3ztrME45mulnAJs84wYFmAb3RqFWBJKn6Fz
	yeFl5qc+aus+ZuIIMf4Mv0cDe4oMCb/sEnnlpMvBVTgDGIs1iwoTCwsf4xmRFTsLcovR/tGmnz5
	Eo/lhxCfGzODILGZUv39ZYGq8rOr2kOj+1VEVgo3S0YQcPSxJCQgY1GaYZFAgACQpKrd112IP7Y
	/T783gudPG6630NwqNehMNaW9EfYrdeD29f8YfZMjZOCSb27XJbBWw0FP/4KA96phnl8XuWj7uA
	GoyANBG2BhkfS+3x7kYG6re9fD6fuf1vrXjie8hoDYsOKjOdDHDQZHCs7jCOVKre8O5DQIPkHyx
	jGqZNbJxygqkq8J1HHqIIKJojeRcgEyoxA/v94SPNdxk1tJY3jBsxNh9fIa/BzwNaZJ7F8gUL63
	NLh6wvJRskeqM9FyBbsTg8kX7f6e/K8ZcWCIS0gSqgDpayg+jpJVnjkfDQrhmQqls=
X-Received: by 2002:a05:690c:350e:b0:7ff:87e1:34d1 with SMTP id 00721157ae682-8370f33b484mr155068337b3.11.1787076132532;
        Tue, 18 Aug 2026 11:02:12 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8421ef77f60sm14519087b3.34.2026.08.18.11.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 11:02:10 -0700 (PDT)
Message-ID: <6335b664-a04c-40c5-ab95-ba459bf582ab@gmail.com>
Date: Tue, 18 Aug 2026 14:02:06 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [systemd-devel] Purpose of init.scope
To: SCOTT FIELDS <Scott.Fields@kyndryl.com>,
 Lennart Poettering <lennart@poettering.net>
Cc: systemd development <systemd-devel@lists.freedesktop.org>,
 Linux cgroups development <cgroups@vger.kernel.org>,
 Alyssa Ross <hi@alyssa.is>
References: <b6dd3b7a-18ba-4b0a-bc5f-9c92d8b2aa7f@gmail.com>
 <aoHfAHdsX6kE9msj@gardel-login>
 <IA1PR14MB782409DC6E8D76E14EE156238AA72@IA1PR14MB7824.namprd14.prod.outlook.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <IA1PR14MB782409DC6E8D76E14EE156238AA72@IA1PR14MB7824.namprd14.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------tJ1aTkv5a38fEaCDqNperDmH"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------tJ1aTkv5a38fEaCDqNperDmH
Content-Type: multipart/mixed; boundary="------------DI3aLEw6nTplXocJLEjNjXb6";
 protected-headers="v1"; hp="clear"
Message-ID: <6335b664-a04c-40c5-ab95-ba459bf582ab@gmail.com>
Date: Tue, 18 Aug 2026 14:02:06 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [systemd-devel] Purpose of init.scope
To: SCOTT FIELDS <Scott.Fields@kyndryl.com>,
 Lennart Poettering <lennart@poettering.net>
Cc: systemd development <systemd-devel@lists.freedesktop.org>,
 Linux cgroups development <cgroups@vger.kernel.org>,
 Alyssa Ross <hi@alyssa.is>
References: <b6dd3b7a-18ba-4b0a-bc5f-9c92d8b2aa7f@gmail.com>
 <aoHfAHdsX6kE9msj@gardel-login>
 <IA1PR14MB782409DC6E8D76E14EE156238AA72@IA1PR14MB7824.namprd14.prod.outlook.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <IA1PR14MB782409DC6E8D76E14EE156238AA72@IA1PR14MB7824.namprd14.prod.outlook.com>

--------------DI3aLEw6nTplXocJLEjNjXb6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 8/17/26 07:32, SCOTT FIELDS wrote:
> For anyone interested:
>=20
> https://github.com/systemd/systemd/pull/1116
>=20
> "This moves PID 1 into a new "init.scope" implicit scope unit in the ro=
ot
> slice. This is necessary since on the unified hierarchy cgroups may
> either contain subgroups or processes but not both. PID 1 hence has to
> move out of the root cgroup (strictly speaking the root cgroup is the
> only one where processes and subgroups are still allowed, but in order
> to support containers nicey, we move PID 1 into the new scope in all
> cases.) This new unit is also used on legacy hierarchy setups. It's
> actually pretty useful on all systems, as it can then be used to filter=

> journal messages coming from PID 1, and so on."

Oh, that explains why PID 1 is not just left in the root cgroup.  I misse=
d
the container use-case.

The project I am working on will never run in a container so that is not
a concern.

> On Mi, 29.07.26 16:13, Demi Marie Obenour (demiobenour@gmail.com) wrote=
:
>=20
>> What is the purpose of having PID 1 in init.scope?=C2=A0 Is it functio=
nally
>> necessary, or is it solely for consistency with when systemd is
>> running in a container or as a user service manager?
>=20
> PID 1 needs to live somehwere, so that's where we put it. Where else
> would you put it?
>=20
> Lennart
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------DI3aLEw6nTplXocJLEjNjXb6--

--------------tJ1aTkv5a38fEaCDqNperDmH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmqEnh8ACgkQszaHOrMp
8lMEUBAAgwB1AXgKbOgHubj8pVWQH4uP+n+WLSRRyUhCsmZDiVjD/5m97TxTv/ZJ
QLzlViSL3j1GXpqT/ynZjLCWkkGZdoiybILIEiCh1BlkMqbTpr5Xan6UA38mc3q8
8J2wBB3c5bXneSmLrTktd0CrifODmFoDOFEfRxnkEZyvfuC4J2L+aYCVXJXfnqJB
zoA8EUErZpMPoyykrqkP8zlwSMCUcIL2VozE6rSV+07TddHgOQTZRrZ9Il/BWm1D
o5w5nUU4pvaCp1YI7SOS0yG/afp8YPAQw4vBYrsQBJ+CN3N+lgZ/dEDBGd/UAu1v
C4256iBzJazzqFSYtkKZuSXxDgIA927dtitU+G9X1QwTLQzBzgKtgoo5063lwlmV
PRSl8jrRr5TbY6DGlrP0M/hg5i71Z8Ul5mTvoH5ixhk56WlHwjwrRopMI4k/tZEm
naEYSbalcMt1cmyCSI4/FGFpmVs/oND1yqhCXeKY5bkAyKaUEcQKBrohi/a2GOTW
7O7821RPxfQXCTTi8sywARvGTDhfmAYhgkk+RMiuJ/WGrf9xhAoB4ND9nQJvUZu/
ubY5SsKkGuY9pGp/ezg9EUB+isO2OgnLjJxmQVWK36EOQHjInA6rDLiLFH+GA2oz
rg/gfcvEKe2XBSAUiWkFQY1l+oiwrm/oHiCRm1FPFKFJEorBoKE=
=Ic6I
-----END PGP SIGNATURE-----

--------------tJ1aTkv5a38fEaCDqNperDmH--
