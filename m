Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C855749A3D1
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 15:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818017; cv=none; b=szDaXISgCPrwp6S5I12QQmsE79kbdJKDHSXpU8AFq3h7o4IN0oBrM2BfVbHNy9/Hq6djgkmXKstiF9RSHM4oYKEzZDVjz5XjZ/XcFqepJ5LGf7eYDvtxLvu+qhjsUD95LYWFQDx6GXjUuRUtimb11WkDPTFJlNhffo0hzKIkeH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818017; c=relaxed/simple;
	bh=umGqnCHZ555YbWy+AD6Im0/YlCEfdWkGC5Y0UR1kwVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGQurIonuzQkfhByg5d1mOH9bv/BnWKGaZ951eN6ihfyFUl0IxAV1Mjq6bscnRtdSH1qCSqyew37m77eyBNPo2ByOZBnPFalqqoAOoFbOnTBPyIeFeCvELKris8zP2dyOHmfAOAVyTMZmQtU94kNen8xchYJpxQYiunCRoA/6qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GiIsn1Lr; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GiIsn1Lr"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-486e70f2457so879891f8f.2
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 08:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791818014; x=1792422814; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0r5ZIRxJicrpwO18Ig2AHoe77ANyyN2+mXpKTZzO6Rs=;
        b=GiIsn1Lrp0cPDPfjeIYIyoWI8hYnEYJu1tkaNax7crpy4wRox2QAo3iM3f3odwD4lc
         YgMIbZKozdQc4e+JLl72zk1oGcSMnOWYbhWf5tUbJQ3Xptic2M45LM/btRJIZFJQ5dDW
         78sAcnsi3H4dLkY3nAHDOFfs6Yf/4AH3E0vyN/nwkG8FT//uA5j7HR7ErtnqYtWxk/KH
         PrDvrak7mh7NUUy9RDuE+PK9YEJ7mVSWYWJv9HLyrYYQgSRNw5ycZJ1CjVUpisr+KlxR
         pu7Van4C/MnW20ZDwBzYe/p7l1GU8dhLbOEG9HyeFd26AM/DCGCnwN/IukUbeVbEBQbr
         98eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791818014; x=1792422814;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0r5ZIRxJicrpwO18Ig2AHoe77ANyyN2+mXpKTZzO6Rs=;
        b=qMwSs59hotm0QiBegBMeM3bBcTwvSFsXinxyF8lqGBJOZS114jY5DCpG4jWZToCLxG
         2dK1FD7JOaua6lH05nP+ayAo8BDbxFnwKnQXyOfgvWV0jy6Mg5Ur5nWfiOPnA3i827Tr
         dcCXjGrOHoYn+2ch8uwgYFJ4U1Nd0mRerlIY6CDRzwKnosRGRymFKYnuVQJcSNQ8Gxw6
         Ui27wk9utUueeAgFKSN7pzC8cULWCJXI1yL8ckVRFFSctYLlcPBW5hvSO78UYhGzREdg
         WCFwlLn4IuYOLHJHrajF3ASMe5/jreQxbi0+N+kuONr4X/U2htlxPik7CalxFHllGwd5
         Iymw==
X-Forwarded-Encrypted: i=1; AKwUvBy8JiZb7mSBrC2WS9n6YkqrjkjMAcP0/5E1T4nfcpXAU76tBLm7xUnYV9k0J3lC6wVZ0ZGDQ8u8@vger.kernel.org
X-Gm-Message-State: AFq9FYLctfmwVpxsLRh8hK3rc20qIsP3NgrB619wFO3f/+/FjzmwQ9Xl
	WihmmdSD6amlfTHXJdx4TeHgIMboXhITjPtC91fCTlv8vPAmmVC/IFkznNGrhEtO1W0=
X-Gm-Gg: AYBFou2UiZhITBtclezys5DoTMHMjgOmIOqet+uNINtSo7OwbnWyjI4uh8BS1YkuJjw
	fCH267m2iUNkkNCEI7azH0CGs/lt30ze2ZF/7ANDUW08JuZJ0Fn6FV7KqPHTOnn3X6qNK8k79iu
	/htQO4F40yn0HxTyEyrm7XU/t7HYTKiiLkxVZcqZ6onnvtII74gYclvZXNYQYoSlDsyygZi21dI
	3PMggGAaqaEE3xXWTMuGRPxyPyEcoK1rXYX0D2LmhSDCzcFt0O0CBD6JlOjlxmH1ObTd2bitbe9
	MylwdpmcL937yUqXMBi974QhRxmWOJWe3KApnArWqQnwngaiWq+WSZXyH8YRY+wuGAQ2ScERu9C
	kRJhzVUEbfWbnfmS3hh/0fZCjbLaSz/Pk7topSgdnE0nn/0HZcd9vwxLqJTtRKflaq9adw3wb64
	UiMaMWAFV+8cAi4FPPnKjycQ1CCW7QR46HBeeYucg9djkAGrR2OfsQ3YWiuOSP8e+jj749dlqLM
	g==
X-Received: by 2002:a05:600c:3d96:b0:4a1:746e:5898 with SMTP id 5b1f17b1804b1-4a18e4835e7mr165297275e9.13.1791818013897;
        Mon, 12 Oct 2026 08:13:33 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a19f318c31sm78961655e9.3.2026.10.12.08.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 08:13:31 -0700 (PDT)
Date: Mon, 12 Oct 2026 17:13:29 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Sebastian Chlad <sebastianchlad@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shuah Khan <shuah@kernel.org>, Sebastian Chlad <sebastian.chlad@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] selftests: cgroup: Report failed checks in
 test_memcontrol
Message-ID: <20261012-blend-diner-c6361d00b9f1@there>
References: <20260926055152.1684-1-sebastian.chlad@suse.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="u5gbdmp2bzg3luyu"
Content-Disposition: inline
In-Reply-To: <20260926055152.1684-1-sebastian.chlad@suse.com>


--u5gbdmp2bzg3luyu
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 0/2] selftests: cgroup: Report failed checks in
 test_memcontrol
MIME-Version: 1.0

Hi Sebastian.

On Sat, Sep 26, 2026 at 07:51:46AM +0200, Sebastian Chlad <sebastianchlad@g=
mail.com> wrote:
> test_memcontrol fails intermittently, but most of its checks fail
> silently, so a "not ok" line gives no indication of how far off the
> measured value was. This series makes those failures print the observed
> and expected values. It does not change any threshold or pass/fail
> behaviour.
>=20
> Patch 1 converts the terminal tolerance checks to values_close_report(),
> as was done for test_cpu in commit 4cdde87d723a ("selftests: cgroup: Use
> values_close_report in test_cpu"). values_close() is kept where it is a
> loop or retry condition, where a mismatch is expected.
>=20
> Patch 2 reports the "memory.current < 50M" check in
> alloc_pagecache_50M_check(). Because test_memcg_high() calls the same
> helper expecting it to fail, it gets a quiet variant. An alternative
> would be to pass the flag through the currently unused void *arg of
> the cg_run() callback; I am happy to switch to that if preferred.
>=20
> With patch 1 applied, we observe at times failures like these:
>=20
>   not ok 3 test_memcg_min
>   [FAIL] actual=3D18722816 expected=3D30408704 | diff=3D11685888 | limit=
=3D7369725 | tolerance=3D15% | actual_error=3D23.78%
>=20
>   not ok 4 test_memcg_low
>   [FAIL] actual=3D20852736 expected=3D30408704 | diff=3D9555968 | limit=
=3D7689210 | tolerance=3D15% | actual_error=3D18.64%
>=20
>   not ok 4 test_memcg_low
>   [FAIL] actual=3D14364672 expected=3D22020096 | diff=3D7655424 | limit=
=3D7276940 | tolerance=3D20% | actual_error=3D21.04%
>=20
> These are the child memory.current checks in test_memcg_protection()
> (expected ~29M and ~21M). Their tolerances were already raised in commit
> d2def68ae06a ("selftests: memcg: increase error tolerance of child
> memory.current check in test_memcg_protection()"), and the values above
> still fall outside them. In the first case the child is about 38% below
> the expected 29M. This series only makes such failures visible; whether
> the expectations or the tolerances should change is left for a separate
> discussion.
>=20
> Changes in v2:
> - Patch 1: pass the measured value first in the alloc_anon_50M_check()
>   values_close_report() call, so that a failure prints actual and
>   expected the right way round (reported by Sashiko AI review).
>=20
> v1: https://lore.kernel.org/all/20260926034923.31718-1-sebastian.chlad@su=
se.com/
>=20
> Sebastian Chlad (2):
>   selftests: cgroup: Use values_close_report in test_memcontrol
>   selftests: cgroup: Report memory.current shortfall in
>     alloc_pagecache_50M_check
>=20
>  .../selftests/cgroup/test_memcontrol.c        | 50 +++++++++++++------
>  1 file changed, 36 insertions(+), 14 deletions(-)

AFAIU, the test is catching two types of errors:
a) running under global pressure (preparations already fail),
b) mismatches in expected values of protection tests (after
   preparation).

I like the reporting of the latter -- with (only) that all consequent
silent failures would imply^H strongly hint the error of type a), no?
:-)

Thanks,
Michal

--u5gbdmp2bzg3luyu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCasz5FRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhGygEA+E0rmCsu6Ho27N1p5NB3
Lk11r2ujJozxMdTi3dbS1r0BAK1DXnSYhASHxLY7xCWsydP9u68Z2lTjRkyysntj
W8gI
=dP/j
-----END PGP SIGNATURE-----

--u5gbdmp2bzg3luyu--
