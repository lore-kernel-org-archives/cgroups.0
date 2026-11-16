Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794838440;
	b=lMP6XcFaVLIwkgAQxHLm46H/DfTeN12Xj+T1gc/B2fbQ15y3LrhP5bo/7amsEayoS//u
	 V7cP1kEawwO+hKgjZqNE/ugTA32s28kYr9Lq/jPkBqMgpXYH1JpxFUV9NE2J6Cdn0sd0+
	 vpOCtOJnyfywmj3GhYZiw90n+yyx8zbHEShwcIzMZt2srirX5qBzmZ/Qp9Cbi/x40Fq4k
	 /bWM2Vodpi623A5KHqVC+3eTpkvreRQ7hKoVkKlo3QEavQR8ryjQ7NmlJHSRU6qzXyuTX
	 gA/E1ytMffUkLzfrDw3UuEV3LuLI3A949Ge90aA1Fsdm+YljIaROPPIlBRTYhORisPA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794838440;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=mE4PFLCBDD7N+5kMo0525pvsFFzxkaRFBGntpezo6s0=;
	b=a2EFH+t02jImMLk3sp+dQWJasQTD0ugIjCup1McnAmdCT6OmGRUevYMF2FuamJfYEHwE
	 cbYWufNckcbtC+JTPPskkXlEMk5Djejq1CwhAwz7F8O6FLpzFaFU/HJlvxYTY+5MaCJ7p
	 r1iUIfIlyvCN2Vf7v8Z2jcYxGTwfd0i8PJEHGKVmfu2MI9pzia58/nugFMW2bIdytxL6w
	 B6Mkhr3VfkJzmxa/3B7Q5QTJsTDpf5b4ZKm3dfjpEr8iNdCFnj5A5tfTqzjaCCDUnPVXc
	 Y1A23E5xf9IPMY0faU+QU8MKhQ9Xc+4a18vwECV58/+X139PwOIzNx38EaAYoDTkDJQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NNbLYEE7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75E2606A329
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 14:13:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C75E2606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NNbLYEE7
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-491aaed7565so1638396f8f.2
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 06:13:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794838438; cv=none;
        d=google.com; s=arc-20260327;
        b=Xnr6GeuEYsBv5v2UZYWGYfxtoHblPqkfckL1VAiGN4dlLlBbYCaC9Co9JeJ3JP4b/G
         FYwxVPak0YU4Ksu5h7/pnK92qWR9GpLdFGv7GlwmUIOQYN6Tz8pvHpkcmf7RpKiU0BH1
         MHOGnGhdyP0SdyBWRgjsJKXy2u7kEsA+BJeCxRwYHolXu1QMSDPl2bWKg6gLWXuqG0ez
         nk0vjifTlm2IwenNbm5v1+w9C2Vqu8PFwyrMO2U6R2cbIvIta87CQC6iCSPSbx4UAtSY
         NeAAcfGNyeeF9uW234T7gdIBtJjH8I+Aq/qksuHUCAX0EoLV9TzgK9dV02X9WA0l2xBF
         Dk2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mE4PFLCBDD7N+5kMo0525pvsFFzxkaRFBGntpezo6s0=;
        fh=fWmWfa6MJo6q/mvkJCyTU/3pNVzCRDVriem5DjggHgM=;
        b=FU+zkXDzJuSC0Rud8KoyrkrKRFk/aluDA+T9kWTvGIwUb9rNdcY3NpCm08bS02sHAR
         FLaQuGzaVH4nBL/Vgmm+OwG5OCahojFT7oA8hKxrDYFOqjzUZbmXw6aHEsQv9Hr2nfDZ
         bwXsJfPSGl7f7XAtwCiYT3pl8pkKJYwvVbj1TpOo3Zh921nk3En5W7dOlMdmf/o+frlN
         xD/GFgKOfMqsJV2/yCxZnN9xx3gnIuKpyhMLVpagvcGE+BQyIw6Edka4aciTw6pWqlQs
         Mk/ETWjz4hw75445Fb2BjNFcJJrCiSSjmEuxRuW1wgp+jkjh8L03N7gL2nPJV4WGO194
         n5yw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794838438; x=1795443238; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mE4PFLCBDD7N+5kMo0525pvsFFzxkaRFBGntpezo6s0=;
        b=NNbLYEE7oDLii472gysZjYrI4ucISl9mt96P2z/OGqu/ZsjrYEr3uHaHVzcWUzTo0A
         14D7T4RowjUPGjFvGQ7alC4pgUtLTkMqIs3x8bhCHzouXVTdYjWp+lXePnr08spveTYO
         JtKuDMpxbF3Q13fLACjnvLTxZS/gqxteZtAaViITZFrq67ZMUG0ZrIeq+z8gS0NnL3du
         GXuMgo8XKyFkQvOaB1GgAmfPB9N6X3a+pcmZsZStl+7q8wuD8PFaFKao1MoC2NuLyWcV
         EnulOQYHtZhbPhaWBV3WVbccHCKL4yShukgIgYxPV41D204POa7FzhWg3RgnqK+rYsST
         VscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794838438; x=1795443238;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mE4PFLCBDD7N+5kMo0525pvsFFzxkaRFBGntpezo6s0=;
        b=qTfT5vQkCIdj0g2rhurTUdo5R56upi7wzzTyilPcje388KfvwE8b3iX4vDpIumdOjC
         SCwkNro0Ov5ibFavcc8pXuZuqr1wD3XdlcYB0IbSWlHMd/MpVw25krpQ17CUt4tn2G3+
         GZG8f8BVIT+rZMzOLtmkNy84u9/ZvsKeSgPHHXBSWh3WBonn1jrBTc8PyDePQ8w2FtNw
         mvSK+3yn1aH42TVizaUWaV72vBAK0Lywsy43b6iObTusQrj/WFDNmhIXa7FVqtkLQvBq
         JvrDOilZgQK9FwfszGM0UEc1F4+XWEV0kjrcF+EIdPGLNusYc7Tu+q6dTyYGz4Bs/mtQ
         cs3A==
X-Forwarded-Encrypted: i=1; AL+hErGzDlfvwPnaRldOe8XQ5GSWTLgCOYe6EEGNvlq82GbpRBBcJJmCtNe84lfCHUloCemLysouoyai@vger.kernel.org
X-Gm-Message-State: APuU4Z+QPcB7tbuqbSRTb3YSLkvG17eM+NbZCq+JyBq0NgEHMk5LOx4q
	w6VIS/PmWGBGOsbTgDedO5Q2EWc2uqhYMikJ28cVM2RDYDzeui0NbihzV5EI0WkerEQqA0AI9cF
	5ex3Ea3EjR2w9raRAHgJCU4MCn4xx9Hw=
X-Gm-Gg: AZFdTZe8pwh2wdgP1ljG53uSnXL3xapMuCF+NvHGel/uX8iRCtir7Jzh460sDvbVJs7
	Wpmi4dV/r/UUwIBZh0eXYLHGR7G41Woh66dE4Ivl5Lhoptu0Xc3iuuvqbFkoOkGx/WLu+JOy93h
	ZmvUs2w0083nRIUA+jK6ONLlhJr23kyaCQzfC0cq6x/a3mu1rKbHWokcK7eFQW3EM8GRl98CVpZ
	FB/4iKhthYV5AHxgbNRCmG8sUgi76GjBkXx0TDwFzN+2KkH5hoGxma5R+8QJMTl3qybmmFUnc5H
	+t3Ehb4u8/ElhsFn/r38QGY70fkh5WSf3O4kXcrajRjb3D2ixqpFNx0ok1hU+VSpgbHfUaUSUJq
	Ad+TN4ZHcQirRnqSkvPRHqE4VeFtk68kSf5cqFy+CWRA73YyfEaGTjQn5XTnesz23SkC7g9Iq0b
	T1ltEC8wzRcETX0o/zhYjoFH1OWTX4xUvsbzLLgLBkxGL25SI4jiYvqnU=
X-Received: by 2002:a05:6000:29d6:b0:48e:d7c:4bc8 with SMTP id
 ffacd0b85a97d-49dad032b01mr11487696f8f.7.1794838437977; Mon, 16 Nov 2026
 06:13:57 -0800 (PST)
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
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 16 Nov 2026 06:13:46 -0800
X-Gm-Features: Aa3M54omNEMN1jWto9qZ-fJE2BPU-EGOtdYeDpXDgUWMj8prRt7WmPFciW1q0iM
Message-ID: <CAKEwX=M64ZmMLBRiAQ6FiiP8f=jkA4m=HM8rgQo-cir2SENPnw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
To: nakixii <nakixii@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Yosry Ahmed <yosry@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 3:03=E2=80=AFAM nakixii <nakixii@gmail.com> wrote:
>
> This is a proof of concept, posted to ask whether the approach is worth
> pursuing. It is not meant for merging. The series is based on Linux
> 6.12.23, not on mm-unstable, and has not been ported to the swap-table
> and zpool changes that have landed since. If there is interest, the
> next version will be rebased onto mm-unstable.
>
> memcomp stores reclaimed anonymous and shmem pages in compressed form
> in memory, using the kernel's compressors and zsmalloc unchanged.
> Reclaim replaces the PTE, or the shmem page-cache entry, with a
> swap-like token that names a 16-byte slot. A fault on the token
> decompresses the page and maps it again. No block device is needed. If
> swap is configured, cold entries can be written back to it. The sysfs
> interface is under /sys/kernel/mm/memcomp.
>
> The implementation uses 16-byte slots, a separate owner domain for zero
> pages, per-key storage and bounded metadata aging. Memory-cgroup
> accounting, cold-page writeback, asynchronous compression, precise
> residency reporting and mincore support are separate patches.
>
> Refaults follow stock workingset accounting. The first reader claims
> and clears the shadow under the slot lock. Feedback runs after
> charging, outside the PTL and slot locks, before the page is read and
> installed. Consumed feedback is not restored if the read or the
> installation fails. An mTHP uses the shadow of its first base page and
> clears the shadows of all its pages. Swapoff returns payloads to the
> pool without building user pages.
>

What's the motivation of this line of work?
