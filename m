Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793810114;
	b=jyjq0UqHoPLsbYKdXhUdvnp6or+gHD2TTDITJtT01eFwtm+Daf6d6eFdEFymQtJXHi7n
	 1AsZav4Oe6ALi5lrc6NQv50YCqkZsi99IemjFRgWI1jcc8Z1BlJhxvj2nlfv4jOiGISzI
	 Fz0A9A/ya0tFfGzd4HUPt5k6ygmcKDq+GKlS6efPungouCS/efzhGv3JHYwUaOPV7R4MZ
	 GerICYFicpcCMx8KUbn/Y5poiTM0bg5+yM4o+/wDc5EZ+5qkIf4Gx1UiCuQ81q170K+UZ
	 p4Api6jo5rDpD0dT5q4jA7uA9KYFvp+JTCW6uwCZKObPGuLfX8OZoh+kbWQSia63wYg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810114;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=r1Dhv/Jl1KwjwSgeC5h/yWHauZP92LHd9bdUwOqpNVM=;
	b=Ff9JqWCZ9+2moLg59VL/UbSPHWC4aA1VS653qZRqbEsPvf0CzCLRk8UNb/L4zecB+B37
	 wZHGDfWtAfLP2iKtfME2fss6Q/541iXrVEggmkBu2dqzT+N2RgeYOAC5Poh1GROPlUvwh
	 BHWhuxSkj+TSUVwdVpV7wO+PbWuMnow9H+Ix0v+OLwNv0oVQJRviP8FzUPt0Za0MIzFJJ
	 7EidUbHw+VHEjJ8QizMjBKoFPMidzuqIv/NT/iccBXELRJuCT/lGxJaWEy+b2tt0O+gyf
	 A05VC1sc4ZlxphlRdr0x4W6XT938iM305KYGQ1GLRNza6qIXjTHZ9j+Gta8wFLDJTSg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="k/Ap2ipi";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97318606A31B
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 16:35:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97318606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k/Ap2ipi
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4afe2d546f9so10932375e9.3
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 08:35:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793810112; cv=none;
        d=google.com; s=arc-20260327;
        b=Fq1zQHg2aPjUiBQIti1331WzPihQjEfRLKfRPfoGjrEH8qvvZh6azjke2PBd5vzief
         50i1/IXqirTwZN55s7lYRKQIfHCvAU8EEb5H29iyV7I02zbg2gWkDHta9Z8mYdpm4sdL
         hvRw6ek6cUms0CVQ6Vfxzr509tz2bTw9annnskzo66anPDeKJLA084Gf2KF4jPhcQltN
         Xh0v53mDax8tao+eRs5iRyzYDJCx1fbltrXzzdkQvXprfcZ++qmp/jteGCXxudtPk5k8
         JCs2gX+ARnnLXAMEDx+LbD9BT6/KMmBoNoFWVkYtrdtSAGUuAE2I3za3KzrKYBZ5dYm9
         7+oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r1Dhv/Jl1KwjwSgeC5h/yWHauZP92LHd9bdUwOqpNVM=;
        fh=+Vz5o5XtOKhJns4n7yDNIPFkorU3y2ggGspr2ZXRCyI=;
        b=oWtl7ainUmuznSCTyqVDXsgZSQ4Q6xLbytv1WFJmGNzQK6rYXrXxovGzZW+sFTjy/Y
         SyxqTY5myONoRRNi5Ujs5+MAtMA+kIP/XxOrs6AOTZqSDWVdopVQS5zmVB+GImHTwnwX
         2RJdx6jdKI3ak41ovIV40Wm6iHtLdUIvdUtow+VFdt0zEQkNWDf1HpF+zBWGONLW1v7Q
         MHGdHm385RFnDkFV02J15q4cW3dY8g/IAeCaJXWA6L+x8USYB/QGNBeqCofNgsAipawG
         Xjqxb+h+aLoYiDBqu4JCEiUglMLEEzYLNXAovwTgshugQUF6hEdrd7CQTK9JJYQqbc6V
         k1ag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793810112; x=1794414912; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r1Dhv/Jl1KwjwSgeC5h/yWHauZP92LHd9bdUwOqpNVM=;
        b=k/Ap2ipio1jUCr7hxSrGcd8xb0Gq8lTypwNjw1lqjro0NRz18F8YlDsM7HiNnCrFEi
         /vm6jltU94UiorOMls9tUOhiUmC4AOyQfjobjB6JZxrLT1KXhNJJcpT+qX+61OC+1IKN
         YAqzR3UE7fxjTamB8udMYWWXXeLdPyEeqkXh49Q+FEMhJKIYZBmZOkJbU8vDdg2QWP5I
         csSN0oDtIczRxv7wm16bMx6N1/xbT81ZIvFLsaJOO+xoahN/0wl0B6TUIie1cR/TXVsc
         FHsluw456OtPMGxM39SdrU8hon8fOyA3tC4Na01Tp6YGM/spTgpi2gRXAZ2JlBC47rEZ
         k3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793810112; x=1794414912;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r1Dhv/Jl1KwjwSgeC5h/yWHauZP92LHd9bdUwOqpNVM=;
        b=2CdqtPj8yAmtnWmjVG4swIxmlfhrypVCge3a8bd4r/64OJ47lDgoFbosfoRUxFAbHH
         sEtGc/zp2lJFN7KBSHqUmFtbUJDLj1y1UVJeOYTuA5XiVe/HS7N0lLfz2N1bm7LgdwQL
         5CWeeDUgHKKAwPxFbuIzcAkTxYzJUMddHqxOQUlWTW96a7pQZUHdIonbzB/ivJmuAljY
         fg+gg9QOLvz+i9kobSTYxVNaey2lrxYTaR4oFu0SvhPVGFVe8X5lyS7K+wRK/vHIbbTq
         AM0jMWVzCdody4UnOeSqqMA5ecJeDj9r82lQ6N8TAwfTS7rtP56rN+kcnl1hrT66AEbU
         eUTw==
X-Forwarded-Encrypted: i=1; AKwUvByEQvW00znE5azMAFm7q/FrBbGGgTQrr6f+JUpCM1iHx2GIIC5VjrAfjYLyzKR0/keXiFzwV2MQ@vger.kernel.org
X-Gm-Message-State: APuU4Z9nv1slKEAjvi6XAyI/66qAB/F0qf1M/Hju13QbP81DkIlx94hq
	1PP2s/E5qu209YBcI2tE33LI2hIsmgoZdjptzhih5/cqHoo0aXAPhr7Q+lZbDk/t9LX7ziNjrf8
	j9wzUzCld7BCgC5vOhYw/z11VKpNh6+0=
X-Gm-Gg: AYBFou3rxRTqLg0kaVdRFq7lLiZfYYZguljdhBaFzgQfmL7ScOQaxbQ5fbI1DJHQytd
	RoRJ72Xzkw1i48xJ+k5qve2f4+8ouxUMzO9OAmQSUhJJYzCzbJ9jWWdcu+zkU2gAZ5AI8HJhX7x
	wcZiTHE/lYwnp8lSK5mzjil5DoeTr+ZMyeDXby/tyBiN6wYP3p/Y9xQdRduAywzQNUn/E4BNQi8
	PBwfNvphkVNnuNrXCnWHKFm+A8gBFgIB9pr1E7/Dtmk6sEgISYFfB6Vi2DP0+t+L9vfytbVPV9e
	sCfnaKZVZRgpCaHO7EVp1pgs6St6L3c/2kZs0MSBhXa9OpTThTBFpZjLsrrUrP8BnO3kKnRw0xZ
	w7xpIxQO3qtjJfTRXLJTwxEpZf6agPEkVipFBd4tiudEzJT4xu1D3O1S6CGjy1mV8Q2Msn01mg5
	ud1R+AEgjHlKyXhskILilMy75HAUBPC3ePjoU34ND+MJkj4RXmQkGESRkfEWpwC1sZyGSIab75Y
	w==
X-Received: by 2002:a05:600c:4715:b0:4a6:eca1:7d5c with SMTP id
 5b1f17b1804b1-4ac182dca82mr384625265e9.32.1793810111530; Wed, 04 Nov 2026
 08:35:11 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104095315.2326-1-zhangchujun@cmss.chinamobile.com>
In-Reply-To: <20261104095315.2326-1-zhangchujun@cmss.chinamobile.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 4 Nov 2026 09:35:00 -0700
X-Gm-Features: AclHuK9XCOvhLBDiROBbZxHR84Wbx48lhNSlCdNeopT450arvK86EzOe3nZed14
Message-ID: <CAKEwX=MyLZ12jtwWOYWvf+KK5dyOOG=RWJb9Q8-DEFy4-twNgg@mail.gmail.com>
Subject: Re: [PATCH] selftests/cgroup: test_zswap: check malloc() return value
To: zhangchujun <zhangchujun@cmss.chinamobile.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 2:53=E2=80=AFAM zhangchujun
<zhangchujun@cmss.chinamobile.com> wrote:
>
> test_no_invasive_cgroup_shrink() uses zw_allocation immediately
> after malloc() without checking for allocation failure.
>
> Check for NULL before accessing the buffer and use the existing
> cleanup path to report test failure, matching the handling of
> wb_allocation later in the function.
>
> Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>
