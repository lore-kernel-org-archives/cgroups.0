Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E034519906
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 17:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788800834; cv=none; b=AkuGKIf1hppjzqnq3f+aVWD7TGDaA2AdYivicW1jmLs/kIxVRKP2kvG2UC779S+2YTHO1EBTn+bedicWkfKgHiiqD0xXuoCGNRErAiYfEXwj+oOSRySa7weO2AY+wHERgYn3ItKN9+H+LDuJL1Vr9A4/Ysyzhcgzq/AUnceW5Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788800834; c=relaxed/simple;
	bh=hF56qCTi739DT8nr2jvT+BipglmVctIpYXsJfZQZh8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tj6+THh2R/BY1o/I41+R5h6e8N7SssHUvQthRszyz3nFV/xPjmA7IpfibZXkR0ccofg8dS+Udq4/+uQrv/n7XLpz1Mp65JMnVofuwEX+q5AJaKyWrigD3j9yM2elFb5bT3g2ZvtXT1UAY2/BMInQJVNJtGijYl/fvCDM4OLLah0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KlDeTZIn; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KlDeTZIn"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso32180495e9.1
        for <cgroups@vger.kernel.org>; Mon, 07 Sep 2026 10:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788800830; x=1789405630; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hF56qCTi739DT8nr2jvT+BipglmVctIpYXsJfZQZh8Y=;
        b=KlDeTZInmXjx0/cNo5crrqemQ4lLhw/W/OB2hDD4QeSL/gnNNuH9Ykd38YellQT0cC
         mXqhSfU9Uhz8TxggOtWEtRphS2FrLzIe5KsNaogzlg41NMFjqtUT697ipFXCE35T6AM8
         t4Y60S3HXDGKSL+6wNh/n9B2VPpdeYsrxg2cadTVlQv00AM5l68JXMEJh1VMNTrqb9ms
         YUtsuW6h+GGRqH0ahspEb+7gNLhdgOBKeb+YlyIMajeLb0iRRp+r+Rm1j8irjWJS/wsA
         +1wMAUGGqaK9+r9TZ4lZ4fvTyN3m87ZvKdW/hHDKlRWd0+GpSuBWVMwyKCg3gUnwo7zw
         m42g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788800830; x=1789405630;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hF56qCTi739DT8nr2jvT+BipglmVctIpYXsJfZQZh8Y=;
        b=Nfl4oUtUE8weA/zgVWOqjtECvKM23F5fk65iPS8+HukYSSHvi0+afLZ9oquaLBRpmi
         LGCVo691a+XDK7VB1uHZGltcKq9afnRx0w1CSFNzTb0vnLIdiED8ImopBdiUTx7EoneX
         Drw9Kvu7RYIQwhnr9ivW9YAKWPO08ijpmHG8FVPNcPzLVYbVk0c74yCXC1lId9twOfzR
         fgx++m7ca1+8u0oL8MWKi89lb61UnYOBUJM7Kh9INrVa6IjgYrbifhpV5C/K42CeRhom
         ddMAYiy+wqpLXPjE3lcx1H85OMUuyI8VEUVXEyfOFAQNBLU9vikPxgwvFLwPrNbWQxxP
         CJmQ==
X-Forwarded-Encrypted: i=1; AKwUvBz+xdXafBo4kcIa1lqm6FwCU2t2DeLdcIv9QhQHH83VlXlFm0wcsa8qaAH6Ckbzicb506qJ6n0L@vger.kernel.org
X-Gm-Message-State: AFuF++naMwVPw9YUPBCCEQdbhMLRxINvipmQCQL/hmz4Ha1IbQOthZtP
	U52ddwmDirCoWxdvsd3SrI3zNsxq3fIyV+fPhDrktKY5w24IcsaobD2NmLY9ams5NzhTIycKtBD
	rWwA48xs=
X-Gm-Gg: AYBFou1K3Bvnq2qOReYh7mINPiNxn9Z3RA7jtjsM33/1ELmLAlkixgomXbtryp5iSNA
	suvwQEwqzXkuKhdx+415aowadAkZzGboO5Lv6HrvZeNMBQuBppy0NLke6n7gRaYAw+Z5Bhthz4k
	dQ6yS/dNwOQQTlQDxHNS0haPjBZqsYEjMqF06MJ4TjiMh/c3jpvKycKQcsMOJtZeIbkjJLc6FTB
	s5SksAPk7eZ4O3ZfmCwuojapx326lXwD/TFbdrq8LNPTpQWJHNOHX12iQBaGB/c79J+aJnrQdxk
	Vx2mkXSV4QHBHIrUBB0X9VnvAx/+jgeLlZ9NpWXx7rZGbWfzUaU8nUqA2C9i89K2DiyfzFQplsc
	wdcpSy8eD8Q2VxnFpHvT9z/Rvu9WpwfpEbOoA4rVm6rnXD6nLmPCCf1HZjtKIr/Zd9ZKNV+PG9M
	WOlA4PPxrbOT4B6V4e3iKqViKEECZxnVaW0w0OSepTPIo0E286DRGkIFFGwgt2x3s=
X-Received: by 2002:a05:600c:3b99:b0:499:bf0e:95c8 with SMTP id 5b1f17b1804b1-49cf81fb72amr256160685e9.1.1788800829897;
        Mon, 07 Sep 2026 10:07:09 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d15918fb3sm25060275e9.0.2026.09.07.10.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 10:07:09 -0700 (PDT)
Date: Mon, 7 Sep 2026 19:07:07 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Dan Schatzberg <dschatzberg@meta.com>, 
	Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org, Noah Elias Feldt <N.Feldt@mittwald.de>, 
	Salvatore Bonaccorso <carnil@debian.org>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] cgroup: Avoid iteration of dying tasks with zero
 refcount
Message-ID: <ap7u0VaI7JVAIq7K@localhost.localdomain>
References: <20260907170345.45316-1-mkoutny@suse.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jtnc6cwmahlcj6p2"
Content-Disposition: inline
In-Reply-To: <20260907170345.45316-1-mkoutny@suse.com>


--jtnc6cwmahlcj6p2
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] cgroup: Avoid iteration of dying tasks with zero
 refcount
MIME-Version: 1.0

On Mon, Sep 07, 2026 at 07:03:44PM +0200, Michal Koutn=FD <mkoutny@suse.com=
> wrote:
> cgroup_task_release() is not synced via css_set_lock hence the race
> possibility. (I'm not 100% convinced about this LLM-assisted
> interleaving, multiple css_task_iter_next() calls may be involved with
> css_set_lock released.)

This paragraph should be editted out too because of

> Changes from v1 (https://lore.kernel.org/r/20260902161653.1051794-1-mkout=
ny@suse.com)
> - add css_set_lock release to sequence diagram

(Sorry for multi-messaging.)

Michal

--jtnc6cwmahlcj6p2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCap7vNxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhioQEAmJhHHhGjIo7Om5IAREUA
o0BeFqPGwj+N8w9xPavgGs0BAJ2+iIXGFwdVXInVdS+Qs/Dz2jNb/b3impZkCl5P
p/MF
=DHgd
-----END PGP SIGNATURE-----

--jtnc6cwmahlcj6p2--
