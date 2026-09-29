Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CDF4FE2D4
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 13:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790687670; cv=pass; b=N8G+vVLJ5IovOE1R98cduFgCQbgSZ6iee2PdlhKzpmt9+o3SvRBcT4XSe+OGCzvvSUqq4APKkTnm5Zlrll/DY7q2OAOs4NU4EmBoo999S94IJRSkoRGUsgYxZCxCIWB4B8nyO4IN8IYo1cKsE5z4aJ3Qw8A2qd52mbvkseIhSx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790687670; c=relaxed/simple;
	bh=mc9ZngTcAoluBbUuX2lmbdpcrwmnX9oPwgK3aLjWg04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qk8pLfE8o8pa6rHnXtCu7DNICaH0IAPcLithjpd3lE5yCc6tp6BcNAtmAjCIkxNeXLZxIjMMPKauzW0jWaB7Q4rUkdxkdk6CXHJy/VZPeAZQEgyhUgUR+P3MCAgajYLBghYjkHnolqyQY/Xh2jBBK13qGoci7CdbnNW64rlgHrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iCg4rfp1; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iCg4rfp1"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffa15f67fso17932825e9.2
        for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 06:14:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790687667; cv=none;
        d=google.com; s=arc-20260327;
        b=j15JU/RXDvVNKRiJej5laX/lbLT8foCfDJMqJdHF0jd2KBhNjvcE8oFnakjaVlC61S
         ZDSx3nv78r9pI4ano/jYaV9PZNjHMuuIVe2Nqt4XrBmRuAxHQxBnf+uKyP1Tl+vGyedR
         kZTbNfAqR/NWDpAgWQxHH2i98/9UowGGjSfs7Z4LrsiAyjLrW7XmF5mUVa+PPVwYsXx0
         0vW+VrMJghyKIRJrxNLjqtfPH9fzKUhUzd6jJVTtZ2YVbCBum/z2MAp3zfZ6EvIMR3gR
         7ngZHd36c8bT9c02TqdWJPRB1yJLz8tVX7d9hEhrBpDjGiibfxoqhNn6FBdjKawZWqXu
         gFBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SYRpRMxccbtbpG1laeX3wfTBykfDUuE+jqqX7h3vEZ0=;
        fh=BMSENzMRJG0EIFmBpFsAcx7a76FZkbi07WoLa8w6Hw0=;
        b=jz5QZHAAKTO+gJg+q+6/StrbTB+Zgu78SQH6xK7Q7MTnx15BSc5aihOWvjGN0+Hhr8
         mbBGGxirwyu7eR5DMmum0MT22vGbbdTknrR0mTq4Z9IE0AhCyuoVp9EPISQfjXuFe0Fp
         FKpItBh6sMIJ45GjNRkhhLDDbwoCRNBfa6fdtFPx4I/qsd7BlVVY4wLVbwtG/reGCXHB
         sh90L7mwAr+ZXVyTjNW4fUjyoVhNco0hxqTRw7NUSp06vcXgxWjQv1kWQeHN9et6zub/
         v5GF7Tj7EHwNAE3Zb9nD0+A5GOrZNg682gKEfEKPmKAOuRshDY6zfgGPzfyh2M6KjlTV
         2ang==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790687667; x=1791292467; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SYRpRMxccbtbpG1laeX3wfTBykfDUuE+jqqX7h3vEZ0=;
        b=iCg4rfp14eSuBBOibIB2qwEDqX7qD8s2MEzh1y2AaasArYmYpvIeJXGhXNRMYFmkb2
         zuMGGQb4SGdrYm7nI4bg4/0ILMs/+6qhTny2PiYw+Gie0KPZWt9QtXLLRtlf5Hk0uA41
         T/Y1M4g7dLbSk5wVWRqxrTGC0hia7y2DBuFGbdzRrWWIeHFvXfR6XgP+/rojWvSpuI8+
         cVnTEMvUbJp8zYOUiVrMbC0cB8jMw7X+Q3bquNiYLmUIefX43lG9i/VsyuTCFPgU8Uw/
         kgqO4u+ZkZSsXWN6n8w3pw1Wo2ejmrwPDpkVTTZL8A0IyhYaFho+gZaDWO30x69a5ux0
         PFhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790687667; x=1791292467;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SYRpRMxccbtbpG1laeX3wfTBykfDUuE+jqqX7h3vEZ0=;
        b=iksbOPu2ko63qAabbXfBtuL6kTUmbotFnWpYnf104pEz0+LJzI32MCp50IS5KUBzKh
         wLPxVhHrUsRzsAk7NXt0wcM6//K+9TJUzVQQF9/q8Vr0tbDf2wnSSU0h32qRPAsGEGFx
         IEJ8fn5aNgp4keAEBMGY0ABda6CbfS6DDzMAk9+p6ytZqnPaV2EDcqHo92f5yB4lP1hf
         qXVi/8PY2Gafxn7OTClnPz2a6xdAQDUJs68u0fF4VyrMRavPybpjMgoKTI/3Iir3lUAN
         iY2iHVA128llIC3bCB5ngHJq8E44hYUwOaA+Msrtv7wlufk2WI5qDdjhHuS8KKlhKEsf
         sidA==
X-Forwarded-Encrypted: i=1; AKwUvBzOPnRQenKbDkAnb4Aizxar43wC9XIAzgHUmUuNYsjzMOC41r/m7Nld9TRWkoAwtyohM0+cVfj0@vger.kernel.org
X-Gm-Message-State: AFuF++nWe3Xm7Ht8fpGIeCMRGsEfHwL1BuiiomVy9Wc9v2tXE1uSif++
	W+pfesXZdUeYaAmkkjFJ8xQ26eR55Gwok3aXh3kD2G/CgBzQBPt5oePAb0SjSTIQ4RrFHjq9EjX
	U0XdZVJ2F7EqdvJ5/Ws+GIBHp5ueilu4=
X-Gm-Gg: AYBFou0uK/hSNL9Oqw2WFeI0th8eyXp/yXhUeWjw31lg5GoodFzWyf8YdtT1YsldRkN
	riatDsaOpHpR0Z3xm2Bdy0oXZde7ndZNh0XxyB8R4ADMoG4PZn3vgrxAIXj5+Wzw50kH4y5mqOh
	P3G+4+FFZVD5ypjNHUMNTP83OkcVYrgtOrNxoMvGSBLwlwQaAB/kQA6pZyvIEI/a5bJ5VuTCegm
	wbHBoKJYft0f+o5BaoX8/zr6DogKG/H5fvWISLsjnUR/pavFwxgrypfHv750ZuZh80Dl8vu7sRb
	yEmk5SkCSi4JKjqwuX3JkWTRXv76EWD0y2GZRWnSgBeQpPHahBN+fmcmZBDL+qw+4jYHC+2QYfS
	Xe+7S2WJ62N37dVz1zN7H7nA6a8s=
X-Received: by 2002:a05:600c:310b:b0:49c:ee20:e787 with SMTP id
 5b1f17b1804b1-49fe66c8959mr264819315e9.1.1790687666921; Tue, 29 Sep 2026
 06:14:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928081900.4187482-1-alex@ghiti.fr>
In-Reply-To: <20260928081900.4187482-1-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 29 Sep 2026 14:14:13 +0100
X-Gm-Features: AclHuK-gHF1dvlctEtmdSR2RHiaD0wcMX6yQUH1GuqMtNTGrIvszFdFCGGkiTPs
Message-ID: <CAKEwX=MzVBTF46m6qBedUtpSgZFksRNonG6Gkw0kEMaCF17SBA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] mm/zswap: make shrinker writeback work with iocost
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 9:19=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> We want to enable the zswap shrinker on our fleet, which runs iocost,
> but with it on, a large production workload is slower than with it
> off. Two reasons:
>
> 1. zswap writeback is REQ_SWAP, so the IO controllers issue it as root
>    and charge it to the cgroup afterwards, as debt. The workload pays it
>    back: its swapin and page cache reads wait, and iocost eventually
>    stalls its allocations, which in turn stalls the application.
>    Patches 1-3 let zswap writeback be throttled instead, by marking it
>    REQ_BACKGROUND.
>
> 2. A throttled write sleeps in its submitter, which for the shrinker is
>    whoever entered reclaim, often an application thread in a page fault.
>    Patch 4 moves that writeback to a per-lruvec kworker.

Yeah that tracks with an older experiment of mine, where I add some
manual throttling to zswap shrinker to reduce latency :) So I think
this problem is real - thanks for root-causing this, Alex!

I'm a bit nervous about adding multiple kworker threads though, hmmm.
Per-lruvec sounds like a lot of threads... Do we have to scale this by
lruvec? Why not per-cpu, or just a global thread? Is there any data to
support this autoscaling?

And do we have any concerns with work (CPU) accounting, from a cgroup
perspective...?
