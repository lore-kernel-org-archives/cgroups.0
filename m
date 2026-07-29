Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C997C44E66A
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 11:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325992; cv=none; b=YJVMY8gWstpEkhGWm+LbHWI4SailrNnjlnpKJBO5OmIjpAdMbXmt4kxeneu5YxsCQRv4HCLi1vHAtrViqnguZDMgCI0ptCNeqzDhHrfmAqDMnRRETe5MlO4QePrQBDj92ZDAUZoWtrxbLO9v4SviLOVEuBVNnqPhV1q4EQrGb0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325992; c=relaxed/simple;
	bh=xn0A3G+imlHjwbqfECgVG5w3y8DU5IaW0X0jzxdqVrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lrd1sXKTUDpIzOIbBzFcYlsoNLbxgjI5yOZx1WeLyeFAd7VCL7+fiDZvbiGYtNPIP1DqZk2BCXPdq55jdYFQtD/byzM0zU7zgJwdVQjIVKGQj+z9A4WYWbpvSdPGDkSHEW9INByYqEFpByO3EXCgPKzfhe2XabT5VSeYLwmo3Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YzAB7CkW; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YzAB7CkW"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4798bea72f9so593799f8f.1
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 04:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785325989; x=1785930789; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xn0A3G+imlHjwbqfECgVG5w3y8DU5IaW0X0jzxdqVrI=;
        b=YzAB7CkW391OXrZ5+bJrfWkj9d/BD97KmWpGFWSiQdd1dtnLaLSTd/JJzqwip2l7VE
         yJhOA+PZ5lPEERw8pRQDG++qEjVRE/ToWJY3EkdmxGpI89akSpNo/kLob0nQkAcH99lm
         3hqPPrVaIbmaRCt5YM31hg5ML2tO+ZOH4xdUaMtD7TMUiAlMCe0xIfrLMe7JItYE3Yt8
         ta9TlVI+U9jxl9Y6MnD15Hz1npIQhQlLHk6P4H0F79zbn7BmmQEViRctW/3/d1HjetkE
         DpoCGW/i8QKHaQxT/qNO/h0ltVopVeGpGwiaT+5txdcjQt3gLlbz/uXIxtQfUDjBJsA6
         gNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785325989; x=1785930789;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xn0A3G+imlHjwbqfECgVG5w3y8DU5IaW0X0jzxdqVrI=;
        b=PwAdpJ6RL3SV4QX9csBBkzcituTIK07DWMLRmn5ITUjoDLajzBP1+cIm0lvJPWkNDm
         YSoH9p/jfGUxKhloRkD4PTjQQ8rQqLNUw+Z7i0srqB4g3IL32CZjrKjqgJXLDgOdcuAu
         wV0KWuPe5fbg+E7kc3okJHwjqdfpNNXvsimFokbyN7MK1qbQX0neDFQ1CFSPk15xvM8f
         0c2bWx7QpYyHmpThtMDYGffL/K2sy+O2zGSFDmZQubaWP/RuvXSqdpv2zK10ZeG78Y8h
         mWVxc+UqtU/o4oxi/nblgrRwvovrTgE9g1VOgYnG/rr6aDv8Tiwugl2Yqq4YCdwM2MNL
         qdTg==
X-Forwarded-Encrypted: i=1; AHgh+RoLiFaqAN4vg9OXkTP4WcdM4TxLJocFif/0n6ERiVl8w9dhNwLiXYH+zrH4/6a1rcrtFgYK460V@vger.kernel.org
X-Gm-Message-State: AOJu0Yz363YSsexvDeLNMOmW6D36epytMGun60o2NyV5/4k6XpIFXHVj
	gaMwT+bDgU5//lNnElj863Ma4Fda3wE530zNW1HB5HIlvUP8tSfDXopqvUS4TMWmwj0=
X-Gm-Gg: AR+sD11EUxwr7Hf0qtvUFOItb7Hhlx+GYMwhOXfW6KmYZkHRD/7kR874q4zC7+SRDqi
	pYceKtonDkgB2ar8uQ89kLvP0HAel8jyp0PD//hjogdWi0FBDRPdBhRRGN0swuqEleIZdtJhuO6
	mH1Ojdhyr8fGtqw+qb3hD/ueFUsrnK1ZllSkxGtfgVLIS9YZAFdrjuhq1d+xWK2APN5/yBDqVqE
	d22uICvVh7lhxCuj7bicKWgmZfzj/vXxxpD30L8FRmXYW5ZtK7LzpCFF7XPQA3Ic6CXn8ozr4jL
	osD27xh885qtTrzTcpVi0uZlQCANkD10gB7Q2DrfRmhO0kl1dxebP82mSJfOY+BjhoXh/Z3M9Bf
	UXO2mf6OzOHU/eofyI4agxvLG03UI8k3JKpszXdrgXn3sVKtWWzRKJ5nTWiOCJidRlJSIqqD0iq
	fh4Frl8HoZ1fJOKL1y1La2T5DZjEiH1ZjnrctdaorLiIR5GCFBwo+hU8iYGYU8gjPM
X-Received: by 2002:a05:6000:4716:b0:462:e086:35f with SMTP id ffacd0b85a97d-47fb1ed8339mr7235562f8f.21.1785325988938;
        Wed, 29 Jul 2026 04:53:08 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b19653sm7730772f8f.30.2026.07.29.04.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 04:53:08 -0700 (PDT)
Date: Wed, 29 Jul 2026 13:53:06 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: tj@kernel.org, hannes@cmpxchg.org, shuah@kernel.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests/cgroup: write explicit period to cpu.max
 in max tests
Message-ID: <amnocemHk8WMUnyi@localhost.localdomain>
References: <20260729100451.689458-1-sunshaojie@kylinos.cn>
 <20260729100451.689458-3-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="piybutfk75vjrsrz"
Content-Disposition: inline
In-Reply-To: <20260729100451.689458-3-sunshaojie@kylinos.cn>


--piybutfk75vjrsrz
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 2/2] selftests/cgroup: write explicit period to cpu.max
 in max tests
MIME-Version: 1.0

Hi.

Here I cannot appreciate the changes.

On Wed, Jul 29, 2026 at 06:04:51PM +0800, Shaojie Sun <sunshaojie@kylinos.cn> wrote:
> The cpu.max interface accepts "quota period" as two values, but
> test_cpucg_max and test_cpucg_max_nested only wrote the quota,
> relying on the kernel default period of 100ms.

Yes. Is that a problem?

> Write both values explicitly so that the period can be easily
> adjusted for testing purposes and the remainder logic becomes
> genuinely useful.

I have yet to see a system where the default period is modified.
Therefore, I wouldn't open that box with non-default periods
unnecessarily.

Thanks,
Michal

--piybutfk75vjrsrz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCamnpnhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ail5gD/fGsAYBJwbk2uztBZqwSE
MMwWF6gfM7FfiSKb+4t7vcgBALL32jYxI+iP0Qwr9ps5a9eA/iQFxErZIKHCIWeF
r4sG
=8BAZ
-----END PGP SIGNATURE-----

--piybutfk75vjrsrz--
