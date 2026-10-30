Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793382747;
	b=zot4cYdKwHigZvrTrVfTjIXI9RIBd/+X3KHRnPM+gJe3NemMU1HfWnul5HMDTGbnY1Ds
	 DO1UjMkxwfE6kdAj9rOu5vO9p+eASNb0qmbZT9BpPAL2SzCdtpHLYnilCJC41zH2MFtGy
	 FHwr8xoBXwurqqFLs888l7YaUIwD+TeImEYSW7r6cLFJdpPkh24rsRuJsI1fj7au0ab6J
	 ViROZ6k8un6/dQTqxxzeSOLI4VIKDpeugdEREzSsd4Tz3JFjM5PgKLuISpdgWXdm4lJ/+
	 60KG7f71Sovytf1ynXxNqeclkUUURjhgSfOoEoBomrrddWP86Fz6A9RPbr/ML2F61ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793382747;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=/yX4qiCWgActF9QSghl2kesacMQRaDgnsGt0G47KLw4=;
	b=Mf9oj89lGdYDx9oApkzgdn2dWV4XtA+9M+yYpgD5RB6dsFi0sdoFLf1ZUemU8TGAew6c
	 70DPHTR+4LOWvfbU+mLdwP4roIE+Ln7DuXc0BatgAYUIvBmNNuV3gdDOcNVUQUpe0HtDd
	 ovRYo6oT0s8bh++wGS4crz1d57I3n0+19nFDTq2SgQc3e9Xz1A2uwLuOwirOEXQfPuN+s
	 vQkXiCAdxq16O2AQHG7Qfl0LNiYiyJbq2fW+Emuc/++n/sRc0GKe9ix2x/0EjIouwD0Ts
	 YyXyIu6uildycolNe/PpW3AnUg5JdrmATFZVp6mBRZAoQ+yXm9VIyWUHtjHBkk5HLnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVWFBB5C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE84606A31D
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 17:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVWFBB5C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864171F00A16
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 17:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793382746;
	bh=/yX4qiCWgActF9QSghl2kesacMQRaDgnsGt0G47KLw4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UVWFBB5CKi30fxDlUFaYsC8UqEi+uMGiIvRARIYLKI5BQBDBW+WV7GWzN+bEaGg67
	 mVKNGcHUfB0x68ao0+tXxn5t7NpPpemE9HPaOUrFEVgFXTML22/dGQN0/XYmvUX9rU
	 9nOuZNw2nLAR5yom4NvefAxXeRwtngrdMNTt1bxUMWlnUsYiPLKocQhGuwCErxwHTT
	 fmdXgMoS5xRZ3iInX5b+C46Y5k5cO3ZtwgH8uusLQLm8FROG9oYGtFmqWqRYri9xQh
	 IJzy66GGvJZerDbNqktWyqgLUH+QGZQVFJx+iPKjwmdjDbivpbUxa90EzPQg4nITzt
	 +uHHSoeaSj8UA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c40e02b2ebaso163447166b.1
        for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 10:52:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzcMQFtnRtblHJBIBBc9mnbRepoYAOIDhtpHcpHsISLIEKwH262vhPdHGUk1qDehGlIEd3xDey3@vger.kernel.org
X-Gm-Message-State: AFq9FYLUs7iZ51HAvMpefoZseaAkmWK9T5VhJ+gYQMcyrIUCVZo20xIR
	CBN8Yu1MMYoxBoD/zw9PPmWWotrjWN0Kr3GTVA+euRFTSiyAaz0UcvbUfbf/ESqiLk6CZWUaGZB
	/la0s6Tx6d6oPKsYicCZvpxsi1+UbWwc=
X-Received: by 2002:a17:907:843:b0:c41:5a0e:3356 with SMTP id
 a640c23a62f3a-c4ca7ab80a6mr283859166b.41.1793382745473; Fri, 30 Oct 2026
 10:52:25 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030095223.325309-1-jiayuan.chen@linux.dev> <20261030095223.325309-3-jiayuan.chen@linux.dev>
In-Reply-To: <20261030095223.325309-3-jiayuan.chen@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 30 Oct 2026 10:52:14 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMF-cj4StEz9okWGROGjBhQ1XFVW3H2nJj3b8i5Jj=zAA@mail.gmail.com>
X-Gm-Features: AclHuK-Xwo9ow1U129u1DE6bxVDM9ppicXKOIUi8wOYOyhyy4kBbPsDwtTVtbqk
Message-ID: <CAO9r8zMF-cj4StEz9okWGROGjBhQ1XFVW3H2nJj3b8i5Jj=zAA@mail.gmail.com>
Subject: Re: [PATCH mm-new v1 2/2] mm: vmscan: skip anon folios zswap would
 refuse when writeback is off
To: Jiayuan Chen <jiayuan.chen@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 2:53=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
> A memcg with memory.zswap.writeback=3D0 can only swap into zswap. Once
> zswap stops taking its pages, because the pool is at its limit or the
> memcg is at memory.zswap.max, swap_writeout() has nowhere to put a
> dirty folio and returns AOP_WRITEPAGE_ACTIVATE.
>
> shrink_folio_list() only learns that at the very end. Every folio it
> picks gets a swap slot, is unmapped, fails in swap_writeout() and goes
> back to the active list, to be aged and tried again. Each round costs
> a slot, an rmap walk, a TLB flush and a minor fault for the owner, and
> frees nothing. The folio also stays in the swap cache holding its slot.
>
> The obvious place for a zswap check is can_reclaim_anon_pages(), but
> it cannot go there. Zero-filled folios never reach zswap:
> swap_writeout() marks them in the swap table and returns before
> zswap_store() is called. They need no pool space, they are common, and
> a memcg-wide "no anon" decision would keep them in memory for as long
> as zswap is full. With zswap full they must still be reclaimable.

I really wonder if we should revisit not swapping zero-filled pages at
all, and instead mapping them to the zero page read-only (and whatever
the equivalent for shmem could be), because yes, the right place is
can_reclaim_anon_pages(). I don't remember what happened to that
proposal, Usama do you remember?
