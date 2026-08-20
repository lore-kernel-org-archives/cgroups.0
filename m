Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A75D2E7396
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 09:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787218047; cv=none; b=SdiCWu4qcPFMPuJUAwXycG1gOlonQ5lNezn4HKGnznRO/aG0898eSi/UtI5CwYE06xPp/VTXwCWK5PjziL/kV2AhQpTrfSf26ZRYNcsKEdok/lcewadipoBIvx3c4HEqEIInrolbJg/4Y0EzrhnUsr+xB0jllqjDY93hoLMulSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787218047; c=relaxed/simple;
	bh=Scs/yfMT1Qt6xHXiv08qF9LC5VYwbtCPsFLZi99I6mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ev1a2t03NHby1nnUBq1NMAwNZYMKepDHJ6akHCyWlPpo3chZ2mx826OxlE7IY1tRZfuXeuU0Sd3jmuOEw5KYBajPwCD+VGfziZfmpWPMUtAnIBPtsKk2VuJGx3K98/U7X2oGiE6YhhgsUNZjb4r27XQL1Epjlq3wthqkCEwu/O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I1mWtRfK; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I1mWtRfK"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49558ce01afso15789455e9.1
        for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 02:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787218044; x=1787822844; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hMskdTdkeMRGiYIbEal35ckaJbDeYchkDIOfTGopKXE=;
        b=I1mWtRfK3qt6Bb1ohKe9M+B8loMX/4FzelrYufcII+va9aoImsod/r+wyRgYY0j0qQ
         NsE0p1KldUD6nyDGBDpOkhsDvLghhdiQeFzm3H14KELbJWMqTDKhguWtsjwcCWTEsk2i
         k5/BZGaYSSiCv9pEAZFsdgACaT3FppeJ7r+64JaMXSdjoWe7W9bm6PmVH/VDPzbPmXQB
         497ZCh7wVHi0qI+xKTG2TSVqgKHxFpTmkj3vH9pQIZ2FTSwqDa6QYCyhKrnZAuIU+ZrT
         NPzJqok9n20mjAGzX+KWK/f8l6P0GXNm1I80wh56GcNMxaLhxfXXq+sIvuOIZYL0x5+/
         LpaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787218044; x=1787822844;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hMskdTdkeMRGiYIbEal35ckaJbDeYchkDIOfTGopKXE=;
        b=MUt9Un2LAGD5MXDNvfv+7Vx4yGz8gbKBPqIatiH3zCj5K6DbaUUjqcKUnF2xJOVBjN
         Y0hvnRO0MjZsuyczRW/mfAf/VSdpo1BY9SO4VnDsJosVGfIjN2cnyhRglSu+N/IQDXnz
         GVUC4y/iXxLtwizCUe60YphuDpMjCrh6tJ9/Ww4BATkVJULFtDd+axSoiKpCYNdRMzUn
         M2A7SUMpcEGmskx8j2pBhc1/ZHkozCdX//z3wMAA2ffA/I7IS3X540xymugqhjM01zT5
         7lNpCwBl9KXpCgFxh9oqbDcz89n9zUE9N9hQ3O087KzKaaSyczqIYJJZE5elpunds4Sv
         CbcQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro+UhO8zDlmS97sYUUlTgHr/AiN20VlwrqMqOCKN4tk9niKipSq4l3BJ14Vg58OqM+7OeD01AmN@vger.kernel.org
X-Gm-Message-State: AOJu0YxtCHQuZXp6nnuHQoqnKMxIWbFBzlxTORnvz1muoOtu+L+VE2Oq
	yevTQMxSBP4RqP3aUU214/YiluZHKWkmjM2hIWrtt/i4pulq2JZUatpcDhxawEaNA44=
X-Gm-Gg: AR+sD10dNkX4VNX36iHyCWRtXATHHxlD2TjkbaU2ntvotdlR0kBD+WzmytPemiWsmij
	udTaOmnDHoWts9k0zFcGeg0Tg13YEbnLQEfPGnqobC0bw2gsQcPf1X8Xibwzcnu9J4C0zBQlBrk
	uMu4vxXcP8IDPiteOaiJAAKtzGa95+vwILDF2ne/F0lkWUsCYMsM6rVX+bez4TSRLMxNOpSKh55
	MN7KJ8NeYfqrc+S0ZYek18dp4AyQXzKaW5BhO2gRzC/e6QybKM6K2kHgIjdIoOZ9fF7et8jD58F
	HrMiD0sNr5y440nAuuume1ggpZZI5bOTGy5bohuKSB7JQSFgAIYOPOFSY/qBfCy27dRzY2J6Ni5
	K9PWwNexYriXcglFMxbW3pKhhMU6PboQgMoMFZwdQy9kbVMemwmZmk3ZD0Yl/uoN7pfns2Ip+/E
	Wz1CmJaE2Pv6c4CaUhMmnfVB0/YCO+6qalPLKwwfaRdZUDw8zddoBIsSLU7CYRL8M=
X-Received: by 2002:a05:600c:c167:b0:495:4d00:2fda with SMTP id 5b1f17b1804b1-499aa143546mr214370055e9.2.1787218044328;
        Thu, 20 Aug 2026 02:27:24 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499a9e805a4sm144983515e9.4.2026.08.20.02.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 02:27:23 -0700 (PDT)
Date: Thu, 20 Aug 2026 11:27:20 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg
 parameter
Message-ID: <aobIWjGwusjSzvBn@localhost.localdomain>
References: <20260820070944.31451-1-hongfu.li@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5mgqyivtgswggrj3"
Content-Disposition: inline
In-Reply-To: <20260820070944.31451-1-hongfu.li@linux.dev>


--5mgqyivtgswggrj3
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg
 parameter
MIME-Version: 1.0

On Thu, Aug 20, 2026 at 03:09:44PM +0800, Hongfu Li <hongfu.li@linux.dev> w=
rote:
> From: Hongfu Li <lihongfu@kylinos.cn>
>=20
> cg_run_in_subcgroups() discards its arg and always passes NULL to cg_run(=
),
> turning the (void *)100 from test_kmem_dead_cgroups() into NULL so no
> allocation occurs.
>=20
> This makes test_kmem_dead_cgroups() falsely pass without exercising the
> "dying cgroup with charged slab" scenario it intends to test.
>=20
> Pass the arg through to cg_run() to fix this.
>=20
> Fixes: 933dc80ec262 ("kselftests: cgroup: add kernel memory accounting te=
sts")
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  tools/testing/selftests/cgroup/test_kmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Good catch,

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--5mgqyivtgswggrj3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaobIcxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjWhwEAka0wkR1ajkCSVyjaiXDA
XIVViX0NbgRoaisxbd3m6XYA/0av7r0/ssp0z/21d6p1a6x5TWOMouSsQwmWbet+
y5YG
=RIxv
-----END PGP SIGNATURE-----

--5mgqyivtgswggrj3--
