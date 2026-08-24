Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7219E401A0B
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 11:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787570107; cv=none; b=ukkwtuYcD0UKs+mxZWDt0K3grpUaEtiKMlrfHhqL7P0GbdFuLikVI7On8hzRDtfviCh1qvBhvmq45MhZHS2RdMWpapzEpP+DSZdLNlZHPjyErQYpH2RGUWU4yFa064z9nAMMqZqm1UaeE5K3rvtT9MbjU2bEqc9XHhr66LXyvEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787570107; c=relaxed/simple;
	bh=oRJiAzViir+kVKHmOKnk6SlV+utqT2r3sgM5NS339/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rqOdzHo8HwAJuSzW68xyGqZznhP1LmaUPJRmVLvMs3zUvQQiql+JZ3KzfpvdW47PVyPayoXL117YGWXH+RZKKYrLUcm+yr9AhJhOF03sg/RwszM1nms7Z0zg9o+kBDsh/RGYnBvHeH8R6S5Nr/guMldcHO8VKzkeKGq9E76slXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A6UPhr0E; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A6UPhr0E"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15d3cd51b2so499515866b.3
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 04:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787570104; x=1788174904; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w6C0CZnkn3wpgcl7INjKPJg3z/EOZac/GnIdlTsK7Uk=;
        b=A6UPhr0ESK+MKSMSLgbDSir05TtVEm5VNHxKipO6D677BZLFS3tu2pyRTiFSAHX3fB
         URqJrSOsA32fMMN1Jlp1rXr8+i0mo0IQb5Wa4tUOwZ9y32VXqCqkLvY+9MH/QqDCkvqD
         dsKQBYTdk1opK6zcSj3RJ7plGbfJuKAWCNANNK8twwHJzQF4f5IYf5GQ+FJvwuBePm8o
         JrIFvURwk71Xl2JJKAyE0P8ZpyR2PDMo3A1ya6ZPEtW6jr41cba3bQ8opc2uUp8Dt8eO
         pkwENcIZP9Fl37Gs6fVbhf7jtl68V6fnLmdbTD+b2E+7nf9KPCTf8gVYXQbE7OaVWbGb
         IYpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787570104; x=1788174904;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w6C0CZnkn3wpgcl7INjKPJg3z/EOZac/GnIdlTsK7Uk=;
        b=eGHy4871Dj8oyTmqQiDRw/HO1c6VoBevI+BgbmUBQfthyLA3y3rB0h3z6mWWB9Iu9F
         N3SdHm5eUWpSYDJclGYPnTZRyou+rnN0MxEB8S9ayfwUT/jRnqAm2yydVF2D7NNKQCwK
         2PNboncnIDNrZXWHHqPkMRBXw8/cvA2N8isTPmRFrOEkm1vX4Uj4xB2aaVIKJPMSJaKH
         pPCMZDYCSDqQG02Bc7zfpVNR8PByXzigfLx6ETVrtEU/BkU/f66QK5a4xeMTOu5bk+jj
         CA7zcJT2u/Xd3KeTK5ZeSubASJ2HB3K/1nOtaKhnvX0GOxZ0MfECMLTfvJ2hHiPTrLP1
         tu5Q==
X-Forwarded-Encrypted: i=1; AHgh+RpFc01DvbVA0M4K321HTHCeGJEtxm3qs2tDnpHeKOpeRd4QtuTE7pcLGVXcGsaZffPneb2JQGmF@vger.kernel.org
X-Gm-Message-State: AFuF++kI3fMzFZDO7fHrB3SpinBG1109it2oDYSh836o4oXOyI42pOIC
	3Ay2aofnMalZepOPggtXFRZAUyNeUKlsBbksFLIIpgW3d55gK4o/L9WN6VnOv3OoT/Q=
X-Gm-Gg: AR+sD10X3A5IqGH3MVpr4nDM/l8ZeZO10xqm/DS2XLaQ3LhZulsSLQa4vMBTWIn8NLk
	u25p2LhG/wCLNSSvGJa8BdJ8nYbxTEC9mm1hGv9aIbo17c37ZvGdMF330LIhs5FSR8LuzxYNX56
	3XjHsrkaef3m+XcfvnL/Sf8FOBZ4E9v3mvET91HGrVdP+O0L2ORndXnF/KVKIKt1SF71hAJxjyA
	EunymEuCP+rvJSsCd1B1vtLLWeaZ4MwkEj8ctwbHIxL4GDqGwRnOVU95ztKDGd3PPOrgBp2xq0U
	1UvSv2qzOwDDRZGu3zyNlRIhpai5If3LKD4f/OF1KRGLl76refq//XBD86OTcmma+/381Ty3T8b
	tlIB/3zGoCSPtzMAglHZ1nVYd+SfV6Hhh5V3myxnB9Du43C4WKG6bj9+qelNLTpFaqZbx3tKnnD
	aTEMQ+ChpjSigGhTpllLwdjIZmYWe4lvP1lDVzsMdNaBNyMDQH3ABw8fxGEEXiK/K3mLpCia11b
	Q==
X-Received: by 2002:a17:907:72c3:b0:c20:2d38:e518 with SMTP id a640c23a62f3a-c249238c382mr2060850266b.2.1787570103710;
        Mon, 24 Aug 2026 04:15:03 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59e025158sm8989092a12.11.2026.08.24.04.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 04:15:03 -0700 (PDT)
Date: Mon, 24 Aug 2026 13:15:01 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: chenglingfei@foxmail.com
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: cgroup-v2: fix misc.events key format description
Message-ID: <aowmLvkC3xed2QQI@localhost.localdomain>
References: <20260824-master-v1-1-6866b77e1f62@foxmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4gvoy4outf2w4u4m"
Content-Disposition: inline
In-Reply-To: <20260824-master-v1-1-6866b77e1f62@foxmail.com>


--4gvoy4outf2w4u4m
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] docs: cgroup-v2: fix misc.events key format description
MIME-Version: 1.0

Hi Lingfei.

On Mon, Aug 24, 2026 at 06:55:04PM +0800, Cheng Lingfei via B4 Relay <devnu=
ll+chenglingfei.foxmail.com@kernel.org> wrote:
>    misc.events
> -	A read-only flat-keyed file which exists on non-root cgroups. The
> -	following entries are defined. Unless specified otherwise, a value
> -	change in this file generates a file modified event. All fields in
> -	this file are hierarchical.
> +        A read-only flat-keyed file which exists on non-root cgroups. It
> +        shows, per resource, the number of times the resource usage of t=
he
> +        cgroup and its children was about to go over the max boundary.
> +        Unless specified otherwise, a value change in this file generate=
s a
> +        file modified event. All fields in this file are hierarchical::
> =20
> -	  max
> -		The number of times the cgroup's resource usage was
> -		about to go over the max boundary.
> +          $ cat misc.events
> +          res_a.max 0
> +          res_b.max 0
> +
> +        Each entry is keyed by the resource name suffixed with ``.max``.

I reckon the docs won't list the key names verbatim. The proposed change
somewhat hides the potentiality of multiple types of events.
To correct the printed key name, I think a smaller change would make do.

@@ -2991,7 +2991,7 @@ resources (res_a and res_b) are registered then:
 	change in this file generates a file modified event. All fields in
 	this file are hierarchical.
=20
-	  max
+	  <res>.max
 		The number of times the cgroup's resource usage was
 		about to go over the max boundary.
=20

Thanks,
Michal

--4gvoy4outf2w4u4m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaownsBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ai4uQD/RrY84oBJ8Bs84pOzH7FB
rHTP8CDMfg5CJTS6eAoPcsUA/2X9rTi382aQqXYBW9yPdA2hZ1iwAX8sR7Z3vN8L
JMUO
=NO3C
-----END PGP SIGNATURE-----

--4gvoy4outf2w4u4m--
