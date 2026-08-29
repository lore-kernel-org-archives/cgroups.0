Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B813232B113
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 03:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787974504; cv=none; b=hKf3tDPhXvseugk/QYMRQDXPF5p4qAhaut/jgFTL2+wkn0vg6pVXm4CLquKxZuDdzOS2NbpT9y/m6KGUDxkyGmQLIkERQZlNcrikpmF/OkPLlRp+BqXs88QCXn2I8ePI5X6u6kuVOANJr6BgvSNabUVDgV2hyvxTYVVkbyj6LNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787974504; c=relaxed/simple;
	bh=8yAywSgOCSK1fCox2+toPCjcPuWCAJR0UBUdjbUi4aw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BRZTiRRwAX0Q++BCu+YY1SClGba/9xTz8oYCu71/teZC29CwawGT4ZlGbpA4S00FdCxCCT0wQHB/SJe2Efbl6gLuCtYgi71V1/i7N9CFtlxYfOCcjHGA2/zL7XxEKjr4Qmatp0YXzxkYyn2PhrRIjU0R2YrGtMPn+bLRMSsc3+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cfm8s5qU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cfm8s5qU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D26F1F00ACA
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 03:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787974503;
	bh=8yAywSgOCSK1fCox2+toPCjcPuWCAJR0UBUdjbUi4aw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Cfm8s5qU2msB9/1h7moyZ6tSFsusG89fmAeWBlt9HtHBBkc5igneHUtZh/Ka5ksAa
	 deohhCbeHtgQ4joCZCm7rxke1psvcS6Y332qfpx92RsGr4evnULtiG77Lita4FVNxd
	 PJFhzvLLSwPiO9QMtyQhCFacFCW2D5X2ZfYCdTtxHVWxMU7n/F0RdqDwcI7HS4eTrF
	 fhy+rcUUrQfZI790pRboMXz5yCs2aBxU80FiX4JevPD+pKwFnkKrg34cd9VCUWQmDK
	 kKTk0L4h3xeB/MJxzrnaR5xaEUsq5ZO3Z8in59mIrASxRfPD0MJnZ8THdIvALSz6em
	 gckm1CwjVkLIw==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8ee43b3e5abso11019446d6.3
        for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 20:35:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx8Ehh5efInFbgXJe8MU6/8P9eXIY+vqkOKsL0XmeY5cfBn1SSGfJ9AZ7w1wsEjhjVzFWHu75TP@vger.kernel.org
X-Gm-Message-State: AFuF++nABYHERIm16uT9BK37hpyjLT1axCzyjCffXlWmqkdJPSscHn7T
	jIIkGALC1MvV9kJd2kQKFzL8h/lGpCzst26Zjybqysnb/tl8T0N5hjkWFlmcsme7pNvqSj7Z7PG
	FLNA3LsIYbEtnm4h30Ov4oRb1idnWn8M=
X-Received: by 2002:ad4:5c4c:0:b0:90c:d136:f686 with SMTP id
 6a1803df08f44-90ce0c5e041mr152357926d6.8.1787974502361; Fri, 28 Aug 2026
 20:35:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-1-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-1-d9f1c75549c8@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 29 Aug 2026 11:34:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xqEpAxO4wuxFruYaRphSeD=Zmz5nUZCMoJYEbyprP+6g@mail.gmail.com>
X-Gm-Features: AcwNN1WEqRQ3mtVBCtrOuN4gMOImSKKb5i3DYRumzgHPVKAv8X125ymB3I-vnAo
Message-ID: <CAGsJ_4xqEpAxO4wuxFruYaRphSeD=Zmz5nUZCMoJYEbyprP+6g@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 26, 2026 at 1:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> introduced a sanity check to catch memcg counter underflow, which was
> more of a workaround for another bug: lru_zone_size is unsigned, so
> underflow wraps it around and returns an enormously large number, then
> the memcg shrinker loops almost forever as the calculated number of
> folios to shrink is huge. That commit also checked if a zero value
> matches the empty LRU list, so we have to hold the LRU lock, and
> handle the positive and negative deltas separately.
>
> But later commit b4536f0c829c ("mm, memcg: fix the active list aging
> for lowmem requests when memcg is enabled") already removed the LRU
> emptiness check, so handling the deltas separately is no longer
> needed. And if we just turn it into an atomic long, underflow isn't a
> big issue either, and can be checked at the reader side, which is
> called much less frequently than the updater.
>
> So let's turn the counter into an atomic long and check at the reader
> side instead, which has a smaller overhead. The underflow correction
> is removed: a massive leak of the LRU size counter would indicate
> that something else has gone very wrong, and one should fix that
> leaking site instead. Besides, the updater-side sanity check is
> unlikely to catch the leaking site anyway: if a folio was removed
> without updating the counter while other folios remain on the LRU,
> the WARN only triggers much later, from a likely innocent callsite.
>
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>
