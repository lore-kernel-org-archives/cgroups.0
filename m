Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794932911;
	b=wOui9NrRj85EfFkMHpK8SiXj95Q65lJHuv+1abn8z013lYBPmvu2m0lqM6Go2EzFTG65
	 h/b839SRQ175lh/XjqS0bFLBUkaJ3JVAD63VUITSkEEeeRhxYyTqWcSgxVgQ27SsR0Lxs
	 W2gaF1NrGuGmWVTVREd9iOucd5H10xBkhZ5OODD8ngTDhEfJjQ4Q/bUpXOEjuwyzhp3jz
	 qgkh7qin8hKNdtVG6hM1suMXGmFJd6IUurAUBKqFM85IKBZhBldLeOmZNceymQdDTgd8Z
	 Bmhk112ihi/686X14s0tzVs51+9iQcniM9h3cEPklz15UxwAg2egaUnuBkXIEeMRfzg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932911;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=kYRKqypZGpF5DQTuLNtjlb+FmX8c92duuQBB1ElK0Kk=;
	b=F6umP/+u5R4nTliRaKpdDJMxiwonhRZIid9QAvwNezLe9hzajzOTw3NMV/68wEtzBoCD
	 Yhb3lM3dBQbPKKfamG7pIN7Tx8H0JFfO7bHpHTAi9BZhq0dTHk5yDvHgZPOZR7k2Knvvf
	 xbaShjyTvF2rSCdUQkwYiKgdR6RC3Txg1/OiTGdiHKbyNoK/HZGVabEvnoMZ5i+SWdso8
	 AcTpjPWtT7x/JK53x2/9HgptF537TmBgkxtW2aTEbLWB+9g6jdWcB1olhRFQz0k9vJmSm
	 A5U4JW4w+0LoBovRhg+M+jEsqxGIjA67AKuqt+MDMEL8xemIJ6PZYJ5nLpkiwql/w4w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h3npYhXM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51E9606A32A
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 16:28:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B51E9606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h3npYhXM
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c4322d310e7so872579966b.0
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 08:28:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794932909; cv=none;
        d=google.com; s=arc-20260327;
        b=rS/Urznq9VNs074Vfn31Z7rvKzfmg75zjIEmTPhHUfJks4CjJaIo+pt3bioKiQ9+CE
         MuIahZVnuXjDSCOMzzJKgyHGMn41EDRz0oX8znl7N6Q0nwMgPX4nhej/f4qLv1RTAUaz
         yc8DJ2hTKDAA1VOUhe+/vAoQ6zqtAOBMqYyizygUAUpZ+Tnv7vurHxHkJlD98KphMYsw
         LE2huMPRhixoo7NVc2cA765JwK6b5zDH3Glu5ehhIOc+fy5yqVt6S1XeIt0d34tpvXyz
         AN2rm7zcTr0WmdQPByZhEZm/CCC+ZBSPr3x2INIDB0PGj9ErfdrYPfp6MfFhdr2P7GyP
         C76A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kYRKqypZGpF5DQTuLNtjlb+FmX8c92duuQBB1ElK0Kk=;
        fh=0cQLyGXumz9jCJe7c+JJvde3mkElVl0knBolujlhpos=;
        b=of1YrZGv09UD6v9uu7ijE6i9YaQlubQllEavsGxgnTYs/5Im6L4sQX0qsP6ZMAIZLZ
         B5p0WaqjpNXd7gn3C+bysvC3BJG2neL2ayhcMuInTRlSeFCHblFYG0xPG6xGpdfZ9jo/
         AIujFSMzX4W62MIQO9kmdTVIGyXxkIM9f24C5ukCx8G6DuyYEF25a2dtgVuxCD5QdjZR
         E4WToZkRX124sAk8tO/SOoFlYfPc4uyJgBjy+T/kTCdPp58g3OM9+WxiiXjv5YZmCsy9
         OqXejLOAE0vZ0XTKiMmwdCe7AdGj8yAxY9tE6fdEbAHMcL3DkVFvhf6xyxid7REgFSz2
         VCLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794932909; x=1795537709; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kYRKqypZGpF5DQTuLNtjlb+FmX8c92duuQBB1ElK0Kk=;
        b=h3npYhXM1j+icboEIJG520dZBPkG8hQl2TKs9oS90lCYq7jkkbTF6ySYHA5FbjqjdC
         v1Odz5EFTfDnzm6SRes07/DRxkjWjdLZbc4XAA9aT63WxzaKm5QPDy3aMaV9/EkkICX3
         GU5EX2lB6AeMItqMAk/0fi8RYDq1ipL5URNhiguVQBpL0OgoHtHEFsFl3dVrX0BTXWHW
         ueK6QU+xLa7IJ1FwlaDVp24Dv8NMJB3FDXUuysF61Phv83J+CzzCxUO6kS5hB4fAp4m1
         h8oN4YQc1w6SF8zs5kf24giLe/VyftcFPrAQSjvh2hXdhvQjhSceTWu0xyOHFw+nYa8H
         9oqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794932909; x=1795537709;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kYRKqypZGpF5DQTuLNtjlb+FmX8c92duuQBB1ElK0Kk=;
        b=1MmjYLJX1t0JNYDTmVfwguqu8gJ6gYpIaFi/SR+V/c1sKO31JFrZlI52kya6u4DktN
         gs/3c0fj4+qZm1nlrB9M8nwtn96g/7XqlCDbt6OaSVCGi249mKrz80MO6bcf3Y4uwmzG
         SNgoe6u9jyeR2WSBQoBz0irvrH7G8lQz0dww1lPNabh204ohd102gX3c2uPkgiymHWG7
         DQSQ8EIzfAv0aC76fjKQlmLLa1wP+w2cNWc1R/KeEo1HAEi3feIlFphLzkyqwxfdZ8R/
         NToFKnu0gDiuqt8EYqk3tPeYqj+0fihR7VOQobwy8BqFnVqgywUsR9qOjxOp3z/cPJtO
         eIVA==
X-Forwarded-Encrypted: i=1; AL+hErEoD/7DC7OLpCU62ueoBWYJygt0sPS07jYtz8EWLmZ/AIIMTrYB62uUxaY8FdXmqSpSp+CKMNBh@vger.kernel.org
X-Gm-Message-State: APuU4Z/TQlOuqtgMHDHxNME5ciX+vl0SBSznZkzFj7T3hBG9UARYxqua
	r2nyLf3hLtivbyjqR6vbe7pRQBb2MxL/ATCRMy6I8ix/cIBtfak079I8/LU4ZlKErJuK8MurBGg
	qqjJKPFL+OJsYn5/sFMaB/3TqzZwb/TY=
X-Gm-Gg: AYBFou18FycQP/JzGFlyKT2f4kIE/J0yNPHKtzdbJZIElcK7u7XIalAfbLtWXOYismC
	qpUmM9DY9vSfNsLkRY9/G06Hi9bQnfg40aqiaMbhAYg3fDLkqElCurdLjsdboz1gKSrH1boVmF4
	zCrgD0EFGH8Qh+Yrc7Z+GiKkLKzNnZgOcu4CKpxPHo8Rh5E5gzvxXc9+UvLkQaKzIiL+QVm5Or0
	OcyEjNrbaIySeh3wlZKo7VXSPkM+3zVNwEnTd63x3FJOvP6Wgx0vxKLWrdkDGuiN16CCBjUuwZx
	2THEvy5lWb6D5MpI/yE1zNm1rIloU/v6ctuP4sEVCi4U0Y+2e/pOxHSrRsuVwQLwfItA6Fn7uuG
	kbZts6LqBpg3j2K4dawOoDVOrZV9AUg2YzI+ouGltM7LiGHTeaXxRtBBl3Ih9YPaq/lRndg==
X-Received: by 2002:a17:907:3d05:b0:c41:8e21:4d5a with SMTP id
 a640c23a62f3a-c5096110e80mr1270381766b.5.1794932908726; Tue, 17 Nov 2026
 08:28:28 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116110122.309748-1-nakixii@gmail.com>
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 18 Nov 2026 00:27:51 +0800
X-Gm-Features: AclHuK8jFoB078UJjX-4oMtgMSTNWJhLa3LQu5nrN5DX53PjZ0PRScBUeflPjVU
Message-ID: <CAMgjq7B=F7grQqhUP1wGPG5uYHL44QNS023Lg4Zw0ycQEr_C0A@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
To: nakixii <nakixii@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi nakixii,

Thanks for sharing this, I do like new ideas on memory compression /
eviction :-D. However, this approach is wrong in many ways.

Posting a mega-sized chunk of LLM generated unreviewable code is not
helpful for anyone. And it's based on a rather old kernel, considering the
parts you are trying to work on have changed significantly since then.
It also lacks a convincing realistic workload, e.g. almost nothing is
measured under sustained memory pressure.

I think you can start by describing the problem and goal clearly instead.

> This is a proof of concept, posted to ask whether the approach is worth
> pursuing. It is not meant for merging. The series is based on Linux
> 6.12.23, not on mm-unstable, and has not been ported to the swap-table
> and zpool changes that have landed since. If there is interest, the
> next version will be rebased onto mm-unstable.

But anyway I took a look at the series (also with help of LLM :P),
IIUC, the main goal is to cut down the intermediate layers for better
swap performance.

Then basing on 6.12 is a bad start, those updates you ignored already
achieved that, or are focusing on and getting close: Zpool layer is
removed; Swap table & cluster allocator removed the Xarray layer and
multiple synchronization layers and reduced contention and overhead;
we are also flattening the zsmalloc handlers, and many more are being
done step by step. You can check recent git log and upstream mails for
the updates on these parts.

So in mainline, the win you measured is no longer there.

I asked an AI agent to try this out yesterday and it reported this today
(256M anon, all paged out, 20k random single page faults, page-cluster=0,
best of 3, canary filtered, same compressor on both sides):

                        pageout us/page   p50        p99
  6.12.23 memcomp lz4         1.11        0.96 us     1.63 us
  6.12.23 zram lz4            1.31        1.13 us     7.75 us
  7.4-rc1  zram lz4           1.13        1.04 us     2.42 us

  6.12.23 memcomp zstd        4.15        2.42 us     3.21 us
  7.4-rc1  zram zstd          4.92        2.63 us     4.08 us
  7.4-rc1  zswap zstd         4.89        2.58 us     4.04 us

Against a 6.12 baseline your point reproduces (7.75 -> 1.63 us). But for
mainline the p50 / avg are close to identical, and the p99 is only 26-33%
better instead of the 2x you measured; considering the ongoing
optimizations I'm pretty sure mainline will bypass that without bloating
up the LOC, or while reducing it.

And I think there is a major misunderstanding here: you didn't bypass
swap, you just re-invented it. And there is no "direct memorey
compression", everything goes through a page fault, unless you have
some fancy hardware support like CRAM.

So TLDR: the 46K LOC for an ambiguous performance gain is really not a
good idea, it is basically a poorman's reimplementation of swap with many
essential parts stripped to be fast (broken OOM handling, no cgroup
control, many statistics and counters missing), and still not really
fast. So don't reinvent wheels.

One thing to keep though: patch 1 (UFFDIO_MOVE exclusivity) seem
valid? And it has a Fixes tag, so please double check and send
it on its own and maybe we can review it :-)

Anyway, still thanks for sharing this - a good reminder that everyone is
chasing every nanosecond of swap performance :).

Thanks.
