Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44969198A17
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 01:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786669390; cv=pass; b=UgIvk30e1KjgNHcLXemdpA2059/6Q2utJQXy6+4ml3U0YQ+FwkkRC+UHiA0WIGM8p8JRh0T9nu6y9is2TIZYRCdYelFpXT5hbqudZgLNXuNS5jD4EZOYjPcy9FCRlRnPSahmeHK0URHeN+Azz64jS3cqhSdZRG6C+kMJ3KoYkdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786669390; c=relaxed/simple;
	bh=Hh8/sxZJsiFQsSNx/FrNwcbh0HywcYbRQSc2GZhuiDs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HNosM+5H7r8Fwtl0kQp+EvvEk/5LMfrJjjJD7ZbbRTKiCw4CSAgLHSZdzf0TsDpuyCdrhtEcsV+KKNiY1ZFmy+g4TXE35lAyuh1gLr7/s2qd8j8ZogY+MsTscSI+ZuTWrI/ZUGNDrvS9mkQZxZpJV6mYUcQ1ENMOoXi75RaO+W0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l39l5yhR; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l39l5yhR"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4996c452e95so520035e9.0
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 18:03:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786669387; cv=none;
        d=google.com; s=arc-20260327;
        b=fgMraHq/Z67NqNhCwTq++4+wtCBXJbnZyAiliMEEeX9XFlAWFhJreRgkmVu9jXjb6X
         pmkid0pDuZx2+AeShCPufKl/xGTNlcidS7eLakseuoTXxfs81Wcmgif0xA6+TEJJX0Xe
         tjQEau6HFV+OzZUWEp40Mxov+1P6zbYlQAHJdf5v9NHQUjvdzsbY3v9HrfK1JAaBENr8
         qP+6Yu+oCAuyBXKVjtIgZ8VjwfUO1PkDENTO0RK8BQmlOcQtaNpB+n+m573x8epVb/rj
         1InDD6/CHN6C2Khh7ouQMjUg7QrEt39w/ZTcyb0/oQ6OfO558m8fQx2XmMtSbjMh5KV+
         izEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eKtuG6jGikRVQqJP0ZyZYZl79OB5GjG68NlKzeTaNwU=;
        fh=pcVY6/eg5Tv3619f/s5JkxpqZsJC/iTLM/oiCk+E65M=;
        b=lRDkOk/o732VqveRlyTfkHhwWxthdAxc3IgBdD8KFFTjfUoJ4Y0DeiC7WwT2czPM21
         gIZuRACe//wfivuQX3fCXA34RxDQmAcjIl1l4tFec/KJA0rrUUbtcfHMwkO0oiPeWIJ5
         lGMC68QRDdYLVW/b4GT7+tHr/xhfJh6mdsq8bHHf/qSgv/Tsuc+bgYIR6NppEI00TkKo
         xhM6abNN8K53zotF7ge87i/ZUbMmOjkIA1DIYQVnbqSHSWhSnDGtOXD5y7mOHugpJ3Sn
         pAeMFUsXXPtskTNY4nnbq2k+PVhPMZeJy9adxirrRUkWjY0brPR276XZZ8Yq58dgQg9J
         E1dw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786669387; x=1787274187; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eKtuG6jGikRVQqJP0ZyZYZl79OB5GjG68NlKzeTaNwU=;
        b=l39l5yhR0UfZ8rfEFSzPEH1tWklxHAQWtOynFp6mMlDfNy0wZo2e3k+ZsCphXXg0hS
         vAfMjKhZAG1Zr3W0DBOkH9DdchpNTJ/teDKedMdMaBEjp0Vz6hTLvoMwnAvD0JVcOWWn
         KZHaaQYN88vf1b7YtV99ULQkSLlE1MiBjOT2n9mdxScm7bFOovg7uiagKDHC5jY5qZ2i
         Gf29p/zkpCSWCOHuyG0tSVLQ89hyPDpCN6EzICCCVAcf6VsZut6jkqSwPm3v6eR2vjWl
         j8OJKXvl5dSwQB/oQaRCyPrqv5AMzJwgIB/Nl4j0IBIIXVN0XZD6MHh4GGeFz6SsGfCE
         Vp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786669387; x=1787274187;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eKtuG6jGikRVQqJP0ZyZYZl79OB5GjG68NlKzeTaNwU=;
        b=Gz/EsfDla18aa7BLW2mB86ZfW2+Al3Ms2zD/u0RYjqOybDii46mmOg0XEVU9wTHLH1
         hZM2RBNsBFZ4bIIu4bCA/t+v65WvQ0EQcFbAoYPvbZ7AOv6Z3C5mEhhVi0glgftIunYM
         rNHy9pSwX4De4+2OIAGLYvFWhBOAfNOhsoT2FyY9OEZQBJEVGUjYKVeVp1tBtgkO4Z7E
         sKdonmpUOldxPqQiu0dX8Lgpwq0h/1lFKJwgej5U5MN5JyZbg4oWSXUJp9+/cQ4qWxwT
         eN0thv9D8gWOa0IzEeEp4hrqrnXnyiW8t5cnFz6W7j7RRoIpCA2c7hr2nrq4nGKYoUXh
         Gqag==
X-Forwarded-Encrypted: i=1; AHgh+Rq/nOXT284QZu20zHX6oSR0vkEK2966ImLORYADqf0+/Fxqbd3ic6G5A40cYwRRGm30MEwQo1Ng@vger.kernel.org
X-Gm-Message-State: AOJu0YxMtKqFGd50bKCk56E5QIgnAHJvLTyJvxF024KWlvTCfg1PfjTT
	M5hGTc40vOJsM3OzU7cN/3FpVhuuOdxXZ6/NDOT6o7v97u9dTGdq5nj8JnJ5Pt+HvsjfWeFyQ+A
	oB2s6f41lQAap0pMqx3fchEXdQylYz24=
X-Gm-Gg: AR+sD11DPI56drU1lLHeFGXtc2GExg9JVqNfNhUgkU10rjnwqXStY2b5IgCBPclrUiy
	65FSUl4xzFTPUTtwd7qzbqFrPtq70fxZkzdFAodaBa7h5DOGIehctDzogDaxfztVPsLeCXrJYo4
	cFkJFkIKyeDeICc6KIetXDmPDCiH6+nCe48kM9pxnDA1gFb3kXmI2txhH0QUZfxu4bFEeOeMFTH
	juA9wC402Jqt+hDUhfdpaNsCeQNAyh2qbEBCMsHtY0a/oXMIr2SZuo93OxF0nPTHWFhJ9LX6sAY
	+n9lacW5UwypKj+DJYjkTibLumo2g6wY4H1ibPq8sO4sv2UIJro9VaLWB0O9TDa5Zggr7lil7d4
	nge0P5cezEA8yIy6Ldf0zpOnmOnlqLQA=
X-Received: by 2002:a05:600c:6206:b0:495:4126:1e55 with SMTP id
 5b1f17b1804b1-499879543c7mr12992215e9.2.1786669387186; Thu, 13 Aug 2026
 18:03:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260813075025.1406585-1-xueyuan.chen21@gmail.com> <20260813134401.a1fb632936fa3b91e454c82d@linux-foundation.org>
In-Reply-To: <20260813134401.a1fb632936fa3b91e454c82d@linux-foundation.org>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Fri, 14 Aug 2026 09:02:55 +0800
X-Gm-Features: AUfX_mylOzV5S1BtiT-kri0MP_i865uLQASBKaj342mBheeet48cW-Q-PIEvuho
Message-ID: <CA+qSx6xnAKa+Wa214tbBqXx2onA9QyUANUuzEcceEyvvsoHmng@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] mm: avoid large folio splits when swap is unavailable
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org, 
	ryncsn@gmail.com, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, ljs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 4:44=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 13 Aug 2026 15:50:21 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com=
> wrote:
>
> > This is v6 of Barry's original RFC patch, "mm: Avoiding split large
> > folios if swap has no space":
>
> Thanks.  It looks like a nice patchset and it comes well-reviewed.
>
> However it's super late in the cycle so I'd prefer to defer this until
> after 7.3-rc1.
>
> The changelogs aren't very clear on the overall benefit to our users
> (please address this), but I'm thinking "minor".  If I'm wrong then
> lets consider -stable backports and suitable Fixes: targets.
>

I'll improve the changelogs and run some tests to quantify
the impact.  If it turns out more than minor, I'll add a
Fixes: tag.

Thanks.
