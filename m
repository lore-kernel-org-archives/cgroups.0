Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0067936AB57
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 12:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787575036; cv=none; b=rkIU1wKUgSS1UbnvQzEx4lVtjT0H2NRjDJlFNyjnrkvQ6dJvxoiwOpra9jk4BgrK6zcJ4byW7NqPr+tI1TW/1kRW4YV2sw3Y3cavrXxk8qn3kZD2JLfvLzedyPDQ3cNXv5RGqA0cAgYbbCPxuoSEK2YLAzfVi8P2W3NP53XSeOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787575036; c=relaxed/simple;
	bh=b360NDSCJoVo8HT1M4LG/4YMGXJ1Fxz2kG4E+dBWl/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QuLRONXQfx7lAu31VCS3erOwHTr3Iy0v8xRns9gO8JSkZqHjxyJN7sljkxo3lC3GiHXp8B6jvUk6WuXmFRrNLfBV0Pvr40wNKrT2PhU8CmSpKKa2gDl8j5eHQ2edYFBPCyReN+7QTBwC4mVEN4tJF6/nq61fRSe5ohrs0jTLJZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aY/HGNNh; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aY/HGNNh"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c20fb91ed0fso518594566b.3
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 05:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787575033; x=1788179833; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xFe7CZrh/NKPQiBuCvoXHDZxKc/OI1NirTgmnI07Xf4=;
        b=aY/HGNNhDDoQUhlu//mHisAb1rBEnGx1EjDLE0HX5CU/KIDRza+9DCnm9Aucn6Utha
         rcICODpsLNSt3plDu971QUf8cHlUkCaPSKkU2DSZpwX+zhojCLwqTybUvXO2da5A7XFv
         4LP5alfB0Q970LR5mD2+qimagw1M7O3vSBHWSFrWOEhhqGW7bw7kfURFtqVD4zUcsm8E
         R/j7Pc7b/xthnlAFaIIdu1saP3SFhZwRXDYAjP0DPeoowz3+A5g+hqcJPtIoGAGgWLLO
         2qPANwUBVpYGKZtGFikMcPV1vR7PaNb0d3vKyQSEmfCj9F66RLVq+iONZpErzVodK0Ol
         vQaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787575033; x=1788179833;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xFe7CZrh/NKPQiBuCvoXHDZxKc/OI1NirTgmnI07Xf4=;
        b=TevypxTb5VfneQEu0gvD1IPxMET8pHL3evwlMWF2CWWteDkUW45CYY/M/LjhiO3OL2
         3bia+AXrwp5DioJHzuC62p06JIQrt5yxnpDOeY9mNAS3+6PntPfKMxm+r2jucQuG+/dS
         QfdH/4IRdhvmeUgxRegxz/yKcGwkFFmUNP9vhVOzR6ghV7TNJkdDRe0NrL9pEY3tpi2c
         RK/w9z809Cgewt9ydeCqo66tILbtqtG2qCIM6SE0mfSZs3fomsYQWf4Bi+lPu4F6SrAP
         tphHIMJ6esYm5zcfY9ar1WMJmBrxNffezhTkkCusdcGhe+OXPr4CjLUvpYM8CBW8XFm+
         aBzg==
X-Forwarded-Encrypted: i=1; AHgh+Rp7Km3TAEe6wkpUT1Vr6fY150U8l6R/NQ9h8uiJcLMVIf/lqqId+GJ0Q4N1yoS80AV7y2MjDx6C@vger.kernel.org
X-Gm-Message-State: AFuF++nzLVqyoaMAZVfKWMDhKYgW3odhfp7TvOI9/axuBudifs5ono27
	deFFpTSjuEdLfzGs1IKWLlwXrkU335uMvnFeUPtXZJ3xz5Sqlk2FkP7+lzvZIif8G7s=
X-Gm-Gg: AR+sD11YhFJivCy8zd/pfqsQnAr1E+uvhJmSI0F9rfzBSBgQ3stXo0dDivUozSFFgq3
	yhm81LC1fCpCrfOAi1+rLdxhNLbgXahhsQQX/xXWNBqn2lqrXzmfNMsFNakSkPoXNW5vJTcs4Pi
	CH7EjtxEGLR69xBGj6g373A+t7wBvhbWU3ORC9RBHBjbgHK/Vo0fYSUi792QTRwjVo8HTZwyB6J
	YQJlQ0TKfjeBQYQ9u1MI6mvGgrrrECS9MDlqWElPIwEbmWL4DkC7DjaqPgdI5+yF7yJ+RaTsIit
	6Ol0auRHKyim5Y/pN6NLp5XMo/uxdjygaHSmaTu8U7IW0gE0QXgt+TmWPwQVpAia3x+F/vwMAaF
	H1PLLE0OThHqxKwNMwjgf5soSBMxz2/FyGDmOurI1rcHjt9eEW1g8DcSSQp4lW2qnyo26XiESW9
	fU3bfz1LXierz8mVbOvdyaoKNnJPM6IWw8WZCCnwtzbWFm6V/y2uFId4gqi5JW3meXcIvb5/4sF
	A==
X-Received: by 2002:a17:907:7b93:b0:c20:5213:56f1 with SMTP id a640c23a62f3a-c246a60348emr2798113866b.13.1787575033111;
        Mon, 24 Aug 2026 05:37:13 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606b5aasm1253429866b.4.2026.08.24.05.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 05:37:12 -0700 (PDT)
Date: Mon, 24 Aug 2026 14:37:11 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
Message-ID: <aow4tSYssWJRjzm-@localhost.localdomain>
References: <20260824033533.2147900-1-wfelipe@google.com>
 <20260824033533.2147900-3-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pfcylgei2cxs7jeq"
Content-Disposition: inline
In-Reply-To: <20260824033533.2147900-3-wfelipe@google.com>


--pfcylgei2cxs7jeq
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
MIME-Version: 1.0

On Mon, Aug 24, 2026 at 03:33:58AM +0000, Wilson Felipe Pereira <wfelipe@go=
ogle.com> wrote:
> In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
> checked against stored_pages * page_size / 4 to verify that the pages
> pushed to zswap belong to the test memory cgroup.
>=20
> Due to slight stat update timing differences, delta can evaluate to a sma=
ll
> negative number (e.g. -5MB out of 1GB). Because delta is declared as a
> signed int and stored_pages is an unsigned size_t, C's usual arithmetic
> conversions implicitly promote a negative delta to a large unsigned 64-bit
> integer, causing `delta < stored_pages * page_size / 4` to falsely evalua=
te
> to 0 and fail the test.
>=20
> Fix this by declaring zswapped and delta as signed longs and comparing
> against a signed threshold, ensuring negative deltas correctly evaluate
> to true.
>=20
> Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem byp=
ass test")
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/=
selftests/cgroup/test_zswap.c
> index a7ff525c1267..15cc1dfdd1f4 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -621,9 +621,11 @@ static int test_no_kmem_bypass(const char *root)
>  			break;
>  		/* If memory was pushed to zswap, verify it belongs to memcg */
>  		if (stored_pages > stored_pages_threshold) {
> -			int zswapped =3D cg_read_key_long(test_group, "memory.stat", "zswappe=
d ");
> -			int delta =3D stored_pages * page_size - zswapped;
> -			int result_ok =3D delta < stored_pages * page_size / 4;
> +			long zswapped =3D cg_read_key_long(
> +				test_group, "memory.stat", "zswapped ");
> +			long delta =3D stored_pages * page_size - zswapped;
> +			long max_delta =3D (long)(stored_pages * page_size / 4);
> +			int result_ok =3D delta < max_delta;

I'd rewrite it like below for higher type confidence (mainly, an explict
cast of stored_pages so that subtraction is signed; possibly, implicit
cast of expression assinged to max_delta):

			long delta =3D (long)stored_pages * page_size - zswapped;
			long max_delta =3D stored_pages * page_size / 4;


> =20
>  			ret =3D result_ok ? KSFT_PASS : KSFT_FAIL;
			ret =3D (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;

Thanks,
Michal

--pfcylgei2cxs7jeq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaow68xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ah3wQEAkD4CY79HnHFL3zUOh2xO
fMcsSq7vsvnmYX7s4mYh8CsBAMi2iZwoDAROyEEUXSL3lUZmgimfzFx6ViqPPxyO
Z8UD
=UNwY
-----END PGP SIGNATURE-----

--pfcylgei2cxs7jeq--
