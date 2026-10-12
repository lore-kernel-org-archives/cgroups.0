Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A3948D890
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 12:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791809119; cv=none; b=qB2+gtpBdSb301pVDKsa65PG9X/+iH0lROxsE9T+eJ2/d9w7ZNQcQgSDI+cic9ZCEl5+ugCaU+cXfsuZut2Ugaw2nfTo0DPbL5oiVa6PBXHldkMF+XOUP91xxlpE5fiZlxsSRUcJCY/vqlH0iYl4XYHbhKRL/sZ2/RLnOnrGf7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791809119; c=relaxed/simple;
	bh=Bvm8tSdfsJWIwE5zHlPE8PH2QA6rnOT5LTtUAz4GQ9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n6AihAj1xyTJXbVGQkv/9FlEvWD+QWH8lYzQuG6Y+TGR+MYTEfTSiPGSLtDalpLuO946LUvzZCPrMts3uwhEQ6l1UCVTgaXEvenH0FKh31c210f+YmNui0AdGSXaPkcnhJbzzyk7Za4WfV6rUGlgoPxsrizaDUd20ijltzFht70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VEfMtRMp; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VEfMtRMp"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48c4be28b82so1781118f8f.2
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 05:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791809110; x=1792413910; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pxDcCA7hpgDYYxgdhqPc+1ZwblatM2CFgvbhhZn3Nj4=;
        b=VEfMtRMpsggQy3puOiUSX0dKP35vsg1vWFgbvvyS8sDLdRba+W6UkvZxLrVufPWojG
         eSpcAmc6NKmZa9KHx5mPBW8IZ9XWrV0zS+S+IHVs72hqDeuAuAAKBRdaU1O8DIa8SleZ
         D+fanidesGpX+dghqX7aHfz7DvlUzxUiRDLsyF3bV6tlM+dwyB54qqQWtmzR+PnZx9+x
         GTg5M47zesywqSbDi1CAPJFJnC+mN3AgTNfAdya/S33R2Tn00X9EB/TjoU/FIFu/mY8K
         K0a+t5d7Zp/vlyNHr6DvX9MjUibmqcNe6SkJT3mSAsN2emPCiKGfufcjJ9OCwpKCvyzJ
         T70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791809110; x=1792413910;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pxDcCA7hpgDYYxgdhqPc+1ZwblatM2CFgvbhhZn3Nj4=;
        b=VVCWXH64fWp4ULC06+ITGAt70k5NnJDAMG0FUqeT2GJBY53k73XHpkUbZW29kyyoq6
         Yh+U+QRRJhY/5SEaPOnT0EL1nIUKAEt8UhdpQOuJKcJElyubYld2dZ1az+vzAtCHZZg2
         soblaCpTXYIf0UlyOcdKTBliuXbXOcSHRfGS+Xn2BEA4dnhTdbx7J+gEJ9pU/wRrnQiX
         GX/0bkYJsjDErYaQl93mKhFnUCGlsB5vJ+TKNq5YsuR6lXIME696CZDy+SnU2bZ9HW+n
         C+oZVsXVRzVEt5LqVip9rj2f9OxoN+nY7EMJEfyYbPrlleEyK4Z97FjS2yYD1Q50nHNB
         cEmg==
X-Forwarded-Encrypted: i=1; AKwUvBzU06UGv/l8PFQfyNtNJaBABPR9uaZc+z18rMoUrAPCB2kHzOrm0CYJ+GscFAvzCcUC4JwBkBYD@vger.kernel.org
X-Gm-Message-State: AFq9FYIq/UFMFEWNbTUQ2GUZjV13uf37Z/15HIXRgcrfWNya1rjxaO9L
	lv7xtF46KxBoJSl0nsGrvAL3S9np5N3AVZT79WIJP2Yt0atA4srZ3GUf+yCMZX+JPfs=
X-Gm-Gg: AYBFou2cUtd90T5L7KLNPVJ4PVAY+rCw9fWzjnzgzbViCmWf00gUEUR8q6hrZ3xL4Pc
	3KOWgEAyujkr2qpJUjDGoIinDhM2OaO2V8ROTOTtB6f+H2BiF2ywIK96xefX1JhsP+IQlPh3M67
	LOkKgXQO2Uv5hw6Ov6AwUotx3qWcrx4cLGeGrJIKDugrE1PRhifLQU+U0HMLa9UkqGj/hkC7sZB
	16J42NVSBR66+rU6Ox1+oYLQbDm5sGq/gUZtHuyZYMOKctztQOA/DXQe77Q2i4ok0UT+AWnkyP5
	4eZTexekwMZnFF/FEVQpdSr3dDskZCqoPxxbggPbhKX5Kv9bZI0qBRQsRTTxKXDp9JZVMpl4ATo
	g0eLSrSqKSTHcFo/LHv/qlWYVV0LZgmK7MOeBgA7hHE7hxsJ2/SMUmpDNPkzkYoF1YdbEumhKDe
	jM2iu9Nt/TG+z1/GeqxbLDr5p5gvWGTD8MlRImam/qO0gmH4ZLPOGcoPThcgFqWT+wcxQyVdsq2
	w==
X-Received: by 2002:a05:6000:160e:b0:487:27f9:842 with SMTP id ffacd0b85a97d-48dbace9d4fmr11992821f8f.55.1791809110413;
        Mon, 12 Oct 2026 05:45:10 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9ac02cfsm18344889f8f.39.2026.10.12.05.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 05:45:09 -0700 (PDT)
Date: Mon, 12 Oct 2026 14:45:07 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Amir Goldstein <amir73il@gmail.com>, "T.J. Mercier" <tjmercier@google.com>, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] selftests/cgroup: free the paths returned by cg_control()
Message-ID: <20261012-grumbling-spearman-3a313ae31198@there>
References: <20261011223358.2327625-10-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lgnee3ewncxbl2us"
Content-Disposition: inline
In-Reply-To: <20261011223358.2327625-10-sashal@kernel.org>


--lgnee3ewncxbl2us
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] selftests/cgroup: free the paths returned by cg_control()
MIME-Version: 1.0

On Sun, Oct 11, 2026 at 06:33:38PM -0400, Sasha Levin <sashal@kernel.org> w=
rote:
> cg_control() returns a path allocated with malloc(). The two callers
> that pass it straight to inotify_add_watch() never free it, and pass
> NULL to it if the allocation fails.
>=20
> Keep the path in a local variable, check it, and free it when done.
>=20
> Fixes: 5313bfe425c8a ("kselftests: cgroup: add freezer controller self-te=
sts")
> Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and=
 IN_IGNORED")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/testing/selftests/cgroup/lib/cgroup_util.c | 13 ++++++++++---
>  tools/testing/selftests/cgroup/test_memcontrol.c |  9 +++++++--
>  2 files changed, 17 insertions(+), 5 deletions(-)

Thanks,
Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--lgnee3ewncxbl2us
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaszWTxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjYAgD8C3rg4DsOngu0tGcoEsvc
5NuTbUsIxMtIYR1QnuiqLKoA/2ZVZusoTfiU4S96kRaXYt4cG9+dSPS3Il16Cshr
GREF
=nNP1
-----END PGP SIGNATURE-----

--lgnee3ewncxbl2us--
