Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FB442A175
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 11:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892112; cv=none; b=eP8rAGYqlgAk0nUG8Xne4fnVm9VcBaZeSTMh5eLlpG+MbnscgTjysr85q4nAs+TkRHyFjvtyXQGc77LG1Yv06ST5QtL4kq85cWXshlqxhMzm+eZamo6AoghnZ4JeXxZqn52nUj3XhFaTOyRG4lgyuWzQLQcf5tCTGjGY418zjv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892112; c=relaxed/simple;
	bh=YGGOVXEqea3GPNNbncSJ3TBlrL4MxJVLMV0LKqpWNwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7we2vx31odVtxDzSF2AP61Upf0diOTpInTcgl/g40PKzkNBLJIrVD27loaKR0QKesUDY5O7mfr3PWKYHk72CaTN8rz/QKAbDWAZ2EM/bD2SBFGwTpfL/ePD4PngNoYaNdwXZDZJC5K8JZsdLUHblIFXCdtOaHUjPIbdRzFSHOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Km21oI2G; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Km21oI2G"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4954afac04bso3577595e9.0
        for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 04:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784892109; x=1785496909; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QbZk7VXNsE8q/TG/Qql8FFHe7uCMGrC8uJ2Nzsh+oeU=;
        b=Km21oI2GY7dMvsxThkKgxh5Et8VjCQoWmgyuZfzmG9qA03HJlMkudxZZoHMR1mSP+E
         jhaE0bi2laQc7ZngdWJf6RWZwz5eqtvc5jgp6kLHFiMzAQZY5B4tRW9SI0n7abuDu0xC
         HD4nHuYlgFTxKgf7QBAbkSR3Wu3200XUHVDjkX5sa1JD2e4Qo5kSgAE3eXY/vLUtJRr1
         1VdBLc+b+okwB/6LrvyMLvLJMje503ZPehUYEbsHcRDOrEtKJ3MhpTJ8Dprh/WfU8zpN
         4uBUYBxs8wuWH6hSLejMXSA7C77zwJEz6tJotOTBu72xiuXOFWbDgNOPEs64V5ultfOu
         MEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784892109; x=1785496909;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QbZk7VXNsE8q/TG/Qql8FFHe7uCMGrC8uJ2Nzsh+oeU=;
        b=E6+/lN9oK99T76Us+3pRk6Im/28yMJPTVxcBEpurzVUWD7TLRD994LHBem364wx/QS
         qSb+rDzcsAyQG64EMnQe+l9zM0X4JODf+rgUEP7yp2tTWjJvcqUZ71Z+gv1Wm2U5Vym1
         yOjpovVN7pjaCHOzrQMRARcGUGOk8uDqpuwA5+vXbbQXproTGOwKbdLxRsvuxLk62Vzp
         /zzs/+jVVe3U8xJPDAdsWZMKDLsaGWVTo4Xtz8aNsmfJJ6PhFwpEHiA+SHQrP7QXwEMC
         3uJj8sIIjBC17QSBvHTOM4KyWk2rVIVVe2QsMWnlo6cMgx71IHXtu7zBxYLTUI40hXa8
         jvKg==
X-Forwarded-Encrypted: i=1; AHgh+RpKzW3TkzFgaEkgkyLjCJCYSL3oq+CD8Pkr4cms+dBv1sWRrgWn9Umm3+1V9yxJOYvraH6f+DCz@vger.kernel.org
X-Gm-Message-State: AOJu0YxfrmE9v+BhvLfMcl/+0XA6yBWv0Rg0vjXUwdN4xFF3Be762mJw
	FiJ3wkD14TRPif74e2zF2mYcUi5gN3vAvTXOzSw0iQZHfdlQdKfPPBdSK8ZXBDg80GQ=
X-Gm-Gg: AR+sD11Z7RvvdDjcQq2cH9urAjdqYDbd9tNpU1sn6K69N3Gcm9ECf9jBq3zUMz0FErV
	rva/So3V6ZvfGsLIYj1wsjgkzuNzMGznb8JhJiBoLXRckwJ5N2Q0by6AIn4OMKdJIHynmdqpJaG
	7/H42GFUGuacyvhF1kfE5KX7KDDP5e9whjiMGvmIJEb0U0N019Ng5C5wM4cFomeFv0X4d4smhsk
	6v+xROooCfMnCMOWMzUx24yVBmUlJwcNO+ruTlpYRZMketIvHlde/h+7HWK4GRMVrHfoi+3GSIB
	KJzAfdWVGF1bAz1+V4uWsU8Qn+1gTKjtBMhsoSy3pLnHS6iIQR347/mPLxrWJloFr6RCLem1L8G
	cJvalMPzx0X5ihhQKE5148jOJ6C3SlXCXZx5B9CTTr/6JEvU6kz2sgnKLYUpx4h/toRZoK6R5Sn
	8HVlY9wQ==
X-Received: by 2002:a05:600c:1914:b0:495:4d00:2fc0 with SMTP id 5b1f17b1804b1-49573ccb598mr84264935e9.12.1784892108828;
        Fri, 24 Jul 2026 04:21:48 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957af786e4sm63578405e9.8.2026.07.24.04.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 04:21:48 -0700 (PDT)
Date: Fri, 24 Jul 2026 13:21:46 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: tj@kernel.org, skhan@linuxfoundation.org, hannes@cmpxchg.org, 
	corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Docs/admin-guide/cgroup-v2: document hierarchical
 cpu.max throttling behavior
Message-ID: <amNJyZQj0p38zlDe@localhost.localdomain>
References: <20260724102500.276525-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eeashxwvkr36aub6"
Content-Disposition: inline
In-Reply-To: <20260724102500.276525-1-sunshaojie@kylinos.cn>


--eeashxwvkr36aub6
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH] Docs/admin-guide/cgroup-v2: document hierarchical
 cpu.max throttling behavior
MIME-Version: 1.0

Hi.

On Fri, Jul 24, 2026 at 06:25:00PM +0800, Shaojie Sun <sunshaojie@kylinos.cn> wrote:
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 14b8c571c0d1..3572d3e7f688 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst

> +	                                       and the resulting
> +	throttling may reflect the combined effect of multiple levels
> +	rather than any single level's limit alone (this differs from
> +	other Limits-type controllers such as memory.max and io.max,
> +	where the most restrictive limit along the hierarchy is
> +	applied).

I'm not sure from the description what the "combined effect" is.
Can you give an example where the cpu.max differs from that Limits-type
semantics?

Thanks,
Michal

--eeashxwvkr36aub6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCamNKxhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ahs0AD9E2MJd6AyaFbuNaCfPXmW
S6gY1qooua7uU6SnpxVthncA/RwC5B6BM4buZiOSDvt0gD85O1/7fNIv0yv0Erkc
JIsD
=wpPc
-----END PGP SIGNATURE-----

--eeashxwvkr36aub6--
