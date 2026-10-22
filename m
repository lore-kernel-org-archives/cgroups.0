Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792688619;
	b=YBiXebFznJ7nit59K9ZaHJXQd6mZjpDi4AvwGiEWKyfACXG33DIopHe5NgmtSZVMkZ0z
	 eXLWMb9/U3SicDzK3OenAb68RUPuWrwUK81K+M1jMMz33EWTnN12MUbBfeBtW7ShiRMY+
	 DxM6KO3rS9RKVijZa3qV1+LQMip7geyUFCfm6OWdLHqQ/PX1bL1j1CKGyJLuhZFb8ljBM
	 pCeXEZFG87JhpzKl9i2OA0qZIIs1cKuX5OVCcd3+z2o7UsklL9j51LTQwmwtYIlSRRlhG
	 VtP8r3tAw6OqpDya1im78zvuZJD0qvwIA/VdRXosg1B9TO47b66USSTq+ALbA71Apog==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688619;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=42ZKTYCAvrM3nzOwxlsBgd+YAojo0q+aV1smVjaq8KU=;
	b=rMFsHn2wwltqQ+aJ0JXwvazgWxlWpDHxhmry+oRXE8Hb8RGh97eToi7nQc5zhT7YTIdy
	 BEeJcdIZS1efTYNf4Vd7rEa/Hb9ZQZeNnuGd9uJHgKkhrgrsuXPKWiswTKIoanxLtARTf
	 YSF1ygKBD0/dUNJbTLjGDf63yZIKRugy8gekl7MUpqcYzlF4fQWs1OOFOwCtfXbjIK9/C
	 ULHMw3OSysnjwpVKehG6IrgLHpp4LJqzx7Q92Mnb8iMDrQ9Cktb37uG9pYvp5jJKZfYpN
	 mvdV3g6sU7aI6D0fJi9oDmX2IsvmADWmgJXxG5kJvtd3Mn9mYRX5u045utQyQmVZSpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qYzOs5h0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7B2606A320
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 17:03:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F7B2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qYzOs5h0
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1e266fca2so234325e9.3
        for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 10:03:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792688618; cv=none;
        d=google.com; s=arc-20260327;
        b=ODtgfshhZ8qevWELJQSLIPDDpLeNevq6ZjAXBqqvt0jrYhFoD3lxjA2Yg2jvvrfgzM
         Kxohzu+nifgI2XgXUwwpjxAtsr1CKgMAmEOQAo1T7Y/JPjqBZgmU0GQOwFc3+B9PoLht
         O6acpYsoZM+JntzgVmu8pniSqxauyJrSJnyUHxhegwJJquY1p70cPJQfjgh2zg9I3cKb
         GrbekpmynbOQSXV382kJdMINKQR1l3ooG+VBNvr5W9rJ3An8On50pk0W7kA2KfqQgZ+s
         DIGu4ZVb4MjXF5Hln4PI2OeCVUyyG0fzrkoAV7szP5QZJQacu9joacRXvCvI93F5w6j3
         GRGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=42ZKTYCAvrM3nzOwxlsBgd+YAojo0q+aV1smVjaq8KU=;
        fh=C2XlLNuqcfWz6Ict/Sudr1bwGU6jpuM8ameRk2sLc5k=;
        b=dbeNCgImR6XPglZA/85Mhc7D1zBVpZeCrsGMG+zBIkmZnLNyEFAlICEFN6jSQYFKu9
         iBYX+taz+H6aZtCH3lmTOnVjSRWzLOJjF0lBmTzWJBtMTAQ7tkbz0h00LBVsY0hUNQbM
         K1S68pIXcqcC5+u4Xqqa1/rGZL3QbZE8GpuevyOPXkcFRAU7Jd1UFbk3Et8EJt0VtUzp
         Wim5uUbJvXsN6MiSk2EH6S3c5Sutpm6IAbNr0L2gr8aOOwk5cQet6ugxOrZzHBtHvkPu
         3UejwPzJFtIfBYZLamvCY/0jbOJvVqBJBMksO952gw0HhWmqylsA9Zyn+VrlvfKb5LT/
         /F+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792688618; x=1793293418; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=42ZKTYCAvrM3nzOwxlsBgd+YAojo0q+aV1smVjaq8KU=;
        b=qYzOs5h0bXZxIVavXr7HNRq0g1WgfRJgI/Gu5cQj0HIe7P7IOhfhcVnfRT9rCJveiF
         3NUcgZ8bNqcQ845QepKODWAP7GCT9bLmdzP+yXz/j+ayzYi859f7ROfAymVEPsXSWtV6
         ZZwsxdvJ8x2ldFc+pPUEFrY0/T24yOfHteitf77XMw+P3HDFEkWO12HOJ1EQCk1sDI7B
         t7vbsd6Z926+FDsGoRMyeMyKq6BXCefbCq8itO9VXWI7MKR+s/1X3jFDowXg1NQu/nps
         09ZXtkSqo/v4tlNuMTlMIAMSzzLqgAAd72Glk4sq5zHXst38KYv8jJ3t0Dp7w9rhnejf
         xN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792688618; x=1793293418;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=42ZKTYCAvrM3nzOwxlsBgd+YAojo0q+aV1smVjaq8KU=;
        b=jxk3GZv/RxqaiDROXAhR+TZxFWZr8JsTzq7HewB+NCF6ZvObTq40IZyjoSiUkOpRef
         BVNCTs6GV91NvKrZYzgLruhOEO/LyzxqahI8oB0xrrHxoZ8/DQzZF31LVT5gaPPc+cds
         dkk4DArY6ldisKjiir55ZrDwLQXXLUc64rT8oWv144dJyxaoM0Hduhp6d8yxsT3YV6N5
         6/JHC5Dw37thnwRzgspKEXGReaNCN91IyC6ElUFY2BPkuBdQkxC1AUiYn9NLgB7vQry/
         HXoh3wJsQypSkt5vKM9mvia1GbuGNBrM1VDzQ8gNLBjX6VTnXuZYj7e2EifTuDbWWM+s
         pgtA==
X-Forwarded-Encrypted: i=1; AKwUvByF1Qz5uXXGeSVy1BKmyFJjt9Eilh30G6XcgzhnwzpWGlXC6m40GIQmCa86PIaSY5H5kf8aOcFL@vger.kernel.org
X-Gm-Message-State: AFq9FYLBroh4u3pAiZuUnU2UvcceggokH73l3Q6L9fYUFtxCReZ0INE/
	jBICrrBFPOZmX8noh86RLRpNuCiqrqD1EJzZh6Zuj371v9TADTafpNZdk1goYtwz4QfiLp1IXt8
	b048G3jfRe8/9sMHvLSpacycIJZcRcu0=
X-Gm-Gg: AYBFou1F5o0xe6DuaqeCpjTjst89Rcx9Uh+aQKxJIiLaWn/Oy2F+6teB02xJGjBM+DW
	Nj9BbZAuYCr7dfW1uOuUcwrT2/NmKe/KlQXlwM7PXYhPcAuaDUgkYe/VSRTJUHMFpIWy8dLcun9
	qWTtoihnNLbXUBvU8+oN653nJCXLQ9sabvsKU2obAOlQ4FqntSbfBbLlgQ69L12wN5IZqrZJOET
	vk0QQ6R4NX7wYhsng3tG3kOj41tNtxQqBZ8YCI1DJZba1tJBpPSlElozsmvp6eXmco7L6srjoRO
	Yu9MUFqTP7NDl8QU8tasH1nTAPdiAMDBQi0KiQvlsWZ6U6OchesTlaaY8apkFxuAowRXDKgkgb5
	ZiZ2S1mxdnNwo0nIZKbOfI6Lxa4Cas958nku9PULhvfq1SDkuXKdAsD3fjK+PXSo2MbQ7G8rV9L
	ni4X0fhg/Bk38d/c5rglPlk2hcb22Rg6K2e4t9+alGgIiML0vy9tai
X-Received: by 2002:a05:600c:3e15:b0:4a1:e11f:b2d5 with SMTP id
 5b1f17b1804b1-4a1fd8a85bfmr107503165e9.2.1792688617341; Thu, 22 Oct 2026
 10:03:37 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021060323.553433-1-nphamcs@gmail.com> <179263657717.2549665.11401372071846447074.b4-reply@b4>
In-Reply-To: <179263657717.2549665.11401372071846447074.b4-reply@b4>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 22 Oct 2026 10:03:25 -0700
X-Gm-Features: AclHuK-KHka98G0XQ9c1yETjfsOpMIxaCbqOu01mqGiSr3S8GqcFL1s8QG2fmng
Message-ID: <CAKEwX=Po0J7KsR93YnP4SyXkpqZqjrg7HxyT=17gVD-fNtRHdA@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] Virtual Swap Space (Swap Table Edition)
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, riel@surriel.com, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, 
	kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 7:36=E2=80=AFPM Gregory Price (Meta) <gourry@gourry=
.net> wrote:
>
> On 2026-10-20 23:03 -0700, Nhat Pham wrote:
> > B. Semi-synthetic Workloads (memhog, usemem, kernel build)
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > All values are mean +/- standard deviation across rounds.
> >
> > Test system: x86_64, 52 cores, 64 GB swapfile for all 3 benchmarks.
> > Swap backend: zswap (zstd) with the traditional active/inactive LRU. We
> > focus on zswap here because it is the motivating use case for vswap.
> >
>
> I get that the motivation is zswap, but it would be nice to have
> disk-swap performance numbers here as well right in the cover.
>
> If only because...

I probably should test it regardless, but likely there will be no
difference in performance numbers. Right now for straight disk
swapping we incur 0 overhead, because I just bypass the virtualization
layer :) There just isn't any feature for me to entertain vswap+disk
swap quite yet (it might come soon-ish though).

Vswap's physical swapfile backend is only used for cgroups that
support zswap (for zswap writeback and fallback if vswap fails to
allocate or zswap rejects the page etc.).

For the older version, I put vswap in front of all swap backends. Disk
swap sees no regression, but Kairui found some regression with fast
in-memory swapfile (pmem). I reproduced it with zram, and I think I
closed that gap in my own testing, but Kairui did not test the fixed
version AFAICT, and I also don't have his full suite, only the ones he
quoted.

(Btw, Kairui, could you publish your full suite, or at least the full
set of testing parameters? I would like to hammer the thing myself to
expose bugs etc.).

>
> > For each benchmark, we test 3 kernels:
> > * Baseline: mm-unstable, no vswap patches.
> > * VSS off: vswap series applied, vswap=3Doff, to verify that there is n=
o
> >   regression to existing swap paths when we disable vswap.
> > * VSS on: vswap series applied, vswap=3Don.
> >
>
> If the numbers you presented carry through, I'm left wondering why this
> is a boot option and not a build option.  I rather dislike the boot
> option compromise in general - but other reasoning aside, if there's no
> performance impact, then I don't see why it shouldn't be the default.

That's a good point yeah. Lemme think about it. I added the boot param
before I decided to bypass vswap for physical swapfile by default...

>
> ~Gregory
>
> --
> Gregory Price (Meta) <gourry@gourry.net>
