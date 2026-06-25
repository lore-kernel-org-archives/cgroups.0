Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA1A2ECE93
	for <cgroups@vger.kernel.org>; Thu, 25 Jun 2026 08:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782375810; cv=none; b=ZXPcHm/nProlg4ioJBGJCoW/efTfhGYTAVL4ErorqJRNDXl3CV7eYZ4ZMXB3JMzGccddKdnP+lHQInK+92MlL1KKVrNP/LscESno3fNFN4yZbzTrNukFT1RaGCUf206UwPUundjhrVxnE7qRgYSdp5Uq2oaMLMq3OG0opQXJzs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782375810; c=relaxed/simple;
	bh=/TVcjFpY9ymsJcczpiXFMMolxxWt9nj/DstrmpaSufs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBnwN5ze5C5qOPQEv9Lr7n0SGTKQMUmcl+TFxMtu62QJgpZQShQP9tbz0oTOlvYTEEMxyPN1kMWLe8ffPVo8PAYYcyBN3s+rltyNR5PudjZS7LRyeWCxNhOUzg+KbU4IJrHiDeTYfs5eJ3arnLq9EN81NRsaxMUhCLvhVCiGHfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=W6fplq8n; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="W6fplq8n"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490b8ac62baso5586995e9.0
        for <cgroups@vger.kernel.org>; Thu, 25 Jun 2026 01:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782375807; x=1782980607; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E2p+Jg6tBRRqzoSuzYoMs3fkx6AeDBpOlq7Y8Lm6x6k=;
        b=W6fplq8n8iYE1a4c4AshKDUJ7lgPb3aDZgJ0xJeuk3Kf9Ofw061HG2CRYWZXIV72TK
         bawVIYADNlN8jmX/RlzxdvRkwbpubR5eTkJOgFJEb1JlSdqATn8SY7Yzc3ZyZj0SIs5n
         h/ecxscUlv5bw249Be9PK8GwuwwMcvaaO0FCMFXtXhwVjFvS1U8TELz3tkxpeMj5MS8a
         DZVUuQodmrBIGt8D3P1DGXYcNXRn4fXLxPCOBeAeE7hPgwXeEclX+5pLyIhMb1Nn/qvE
         v5lR4SteDvbEtAAb3TlNLxl61Ng90nQzKt0YHov3X27W4r7ll1HJru3RaUqeiE8+id+7
         tq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782375807; x=1782980607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E2p+Jg6tBRRqzoSuzYoMs3fkx6AeDBpOlq7Y8Lm6x6k=;
        b=oXnzjUBHMdJQBzGKuPFYEHrS8mZcKcT3ml6E8NAwi0wnD2zyx1wEa8F33A/yFsju/c
         8XCoLAh2mVmnzbFkzZ+hBSKc3NJ8cO64pXWXXDqGZ0/qRjolRUrJ+njt5QWl3hMHHj4S
         aphkG7ySeWT+TTo1gMggiM0EQ6FvPbasBpbA5+PlRXt+jseSFDtQ4gFta9pToVRRmZ5K
         cfufzzI7HeOn4eUszPmSY0eRTG5SCGDcrB3RZzGa/NhiruiXbaUNzrSmg0/U6dszwFQG
         mf1HR/tRutFT2cb3uychi6QQRERaHUjWi/m6jPdPT0RS/3991aoXMyaTwFU2WP1tHlK/
         pvdQ==
X-Forwarded-Encrypted: i=1; AFNElJ8CBcwmDQID0FLmIUbqaQGd4hrFXrue0drJgFxAswXV2Wc4BZCSIlDx5MIyl5RvGpied6qN6Fbe@vger.kernel.org
X-Gm-Message-State: AOJu0YwjfQEGQwGOoi298vgCmc5kPETSmIw4xH2VOyUCwp7Eh3aTxq7J
	q5w7U88xf7pDf05afm9LdGK5bl7wZy8ZgXWlnSn7B6nvqbCh0zW86Tarb1ITl51VOo0=
X-Gm-Gg: AfdE7ck0BuxnpfvhSNNAwgLGm+7X5HmmfR20iOuP21UKR8wHa0GZZKCRx3DDpYcpMkk
	u5z76phZ+Exr0yXo9VAM/e1n87Q54po9u4U2wsmxu2Kpw1ac+MmbkOJz6mKladvmLsRC54p+12c
	I57PKxNzBOeKehtG1IaJN7ixfd0/+kqC5KVq3p8bTGhm53SffgjTL6RiN8m5F2L7fErdrv/GYjR
	BiebZKkXw+RmD9fPohQ8p/FAFTTkmGvSosxZVQU0PR3wIoHvSVClFD/FMQNkkS5PoF24SjyWK13
	kssXd2iz23MQWP4dCyIMSh62kueklwB/mtIMJfo0ywhO1So110KeO3LkFPwon/kEwsDPmyg/gpB
	kbyuAR0uAKOSMr4Wy5AK6XCz6lLU3RWhzngkxT/2QdSnJU4uPXS/lmvoT0XSRdqvg2QZf7+ut3a
	Py6YosNK+aZwBjCJhHgg==
X-Received: by 2002:a05:600c:638e:b0:490:7df7:9190 with SMTP id 5b1f17b1804b1-492663ea3d3mr15651405e9.8.1782375804387;
        Thu, 25 Jun 2026 01:23:24 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492660a333asm41965875e9.3.2026.06.25.01.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 01:23:23 -0700 (PDT)
Date: Thu, 25 Jun 2026 10:23:22 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Joe Simmons-Talbott <joest@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/cgroup: Adjust cpu test duration based on HZ
Message-ID: <ajzjLsBNS7rNZV2x@localhost.localdomain>
References: <20260624160358.430354-1-joest@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="omrw3ip3e232dwpc"
Content-Disposition: inline
In-Reply-To: <20260624160358.430354-1-joest@redhat.com>


--omrw3ip3e232dwpc
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] selftests/cgroup: Adjust cpu test duration based on HZ
MIME-Version: 1.0

Hi.

On Wed, Jun 24, 2026 at 12:03:57PM -0400, Joe Simmons-Talbott <joest@redhat=
=2Ecom> wrote:
> +/*
> + * Best effort attempt to get the kernel's HZ value from the config.
> + * Return the HZ value if found otherwise return -1 to indicate failure.
> + */
> +static long
> +_get_config_hz(void)

drop underscore from the static function

> +{
> +	long hz =3D -1;

use the default 1000 here to simplify the callers

> +	FILE *f;
> +	char cmd[256] =3D "zcat /proc/config.gz 2>/dev/null | grep '^CONFIG_HZ=
=3D'";
> +
> +	f =3D popen(cmd, "r");
> +
> +	if (!f)
> +		return hz;
> +
> +	if (fscanf(f, "CONFIG_HZ=3D%ld", &hz) =3D=3D EOF)
> +		goto out;
> +
> +out:
> +	pclose(f);
> +	return hz;
> +}
> +
>  /*
>   * This test creates a cgroup with some maximum value within a period, a=
nd
>   * verifies that a process in the cgroup is not overscheduled.
> @@ -646,15 +670,21 @@ test_cpucg_nested_weight_underprovisioned(const cha=
r *root)
>  static int test_cpucg_max(const char *root)
>  {
>  	int ret =3D KSFT_FAIL;
> +	long hz =3D _get_config_hz();
>  	long quota_usec =3D 1000;
>  	long default_period_usec =3D 100000; /* cpu.max's default period */
> -	long duration_seconds =3D 1;
> +	long duration_seconds;
> =20
> -	long duration_usec =3D duration_seconds * USEC_PER_SEC;
> +	long duration_usec;
>  	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
>  	char *cpucg;
>  	char quota_buf[32];
> =20
> +	if (hz =3D=3D -1)
> +		hz =3D 1000;
> +	duration_seconds =3D 1000 / hz;
> +	duration_usec =3D duration_seconds * USEC_PER_SEC;

I'd do the calculation in usecs

	duration_usec =3D duration_seconds * USEC_PER_SEC * 1000 / hz;

so that actual duration is more precise (for hz=3D300 which is the only
that doesn't divide 1000)

All in all, make the adjustments for HZ with less code (since I expect
this will need adjustments for SMPs in future).

Thanks,
Michal

--omrw3ip3e232dwpc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajzldhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhG5AEAsiaZILB8jz1XPZq6anV8
Hc6J1Y5Pv7YWDyBDDQXko2EA/3VvrRbv6LPfgIy+hXnRfjhjxl4i1e2WobK0WYIe
V/0A
=0a5l
-----END PGP SIGNATURE-----

--omrw3ip3e232dwpc--
