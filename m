Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793668402;
	b=Pvk+84rU9PQ3l/Wmag7pdnj7pY1pcKHYqR3L1OEBbqpgRoOft36U+o0hveLUYXTrHJrs
	 8NSEQCRC9wyHUJyqspQsq7VosyeoLiGt9qIT3DVALqAAynRhTBBUeYXBtTa7vG4HOeEgc
	 2PlMD74+6qcaIpf1ziijSsm8CdWEeq8+OHFQGMAt7JSLqQ4L0eHklZF+D9nyR3gDeP2ac
	 Hbxmg6GMB6TyZ2lu9N0x2yu3qJmoYYykhy9jhpYbaG0tcQwsDsUgSmRUn16STGeu/kFI/
	 TLapfe2Q0I4fui3gaHr2w0/xqZCVWeze6lauX7Id+1KNNm4iYzSIBW/CQMEAnaoOl2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793668402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=YO+Mas6+Ogs0nMHl3MFFrvvs+CIGukFs8BZM4Sq24hg=;
	b=hPIh/6ckd68HOgljTyk6zVaRDsB1cvw48k6PvtwMJDjqQsmZOq1d/0iP+57kwCJ2QQ3x
	 M1wM5KNHNAEyyuStxncnE/GhbklKb/vqWU9ky0XI542OFnsU17Fk21WLbPsisA5ld8mym
	 uE8EfUD+3+r0yrQJuwq2txoecmIDxDLMLfBy4m9ZEM+jd6bjYwxPDhVg4K6153shmTtle
	 cGw60YEewWwTkvvzfNRARDB1Sb9bt5k0ExZVN+3aO0kxDCf2vdo0BMIaXS1KQSCFh9LG7
	 i9WLLk0sfybF2lUDIIZJpQbVIognZgEU8vqf3BTCJJ2OHA63u1X3ERH3qGYs7IVpSxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="H+44i/oX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA21606A326;
	Tue,  3 Nov 2026 01:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H+44i/oX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04EA1F000C1;
	Tue,  3 Nov 2026 01:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793668402;
	bh=YO+Mas6+Ogs0nMHl3MFFrvvs+CIGukFs8BZM4Sq24hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+44i/oXiSUl+h5xIKQcSgVXzdS+QyrtKaeH+fOgkX9FPTaVPGpAOAz9ICuqQx3op
	 1QoPrg+LRRJFuI1SCp3wvqfBPX6ZSLM7e6GT9Itga/V5cPlAJ66/jbGezZfjkLsrOa
	 MBqZxcA3oDUqceXgbNRfpZVv42juqnrE5+wOfSUm2f4SSNWU1bXxXRgy9HbZRt91Rg
	 YOqz3S+20VfmydxdTtmpbC+R/MD6zQQt5HBygqly5FpxqpDEg/g0AFYfWaWMr3j1Yl
	 kQBBOusp+ck8LWzKZ++nXO6sxtgwDn7M56JqKDb9F5qyuLkIfdBii1NrlY3XWCS7B7
	 60vhOaN1advRQ==
From: SJ Park <sj@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH v1 1/3] mm: zswap: fix shrinker count for the root memcg
Date: Mon,  2 Nov 2026 17:13:14 -0800
Message-ID: <20261103011314.93358-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102225030.2743129-2-joannelkoong@gmail.com>
References: 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon,  2 Nov 2026 14:50:28 -0800 Joanne Koong <joannelkoong@gmail.com> wrote:

> zswap_shrinker_count() scales the number of freeable entries on a
> memcg's zswap LRU by the memcg's compression ratio. That compression
> ratio is computed from the memcg's MEMCG_ZSWAP_B and MEMCG_ZSWAPPED
> stats.
> 
> However, for the root memcg, the zswap entries owned by the root memcg
> itself are never accounted for in the stats (obj_cgroup_charge_zswap()
> skips the root objcg, and before the root memcg had an objcg, its
> entries weren't charged at all). The stats only reflect the entries
> owned by the root memcg's descendants. When the root memcg's descendants
> have no zswap entries (eg when the whole workload runs in the root
> cgroup), the shrinker reports nothing to reclaim for the root memcg, and
> its zswap entries are never written back by the shrinker. When its
> descendants do have entries, the root memcg's entries are scaled by the
> descendants' compression ratio instead of a ratio that includes them.
> 
> Fix this by using the zswap pool-wide counters for the root memcg
> instead. The zswap pool-wide counters cover every zswap entry, including
> those owned by the root memcg.
> 
> This also gets rid of having to flush the root memcg's stats, which
> flushes every cgroup in the system.
> 
> In a VM running a reclaim-heavy workload in the root cgroup with the
> zswap shrinker enabled, the shrinker wrote back no pages before this
> change (zswpwb stayed at 0) and 1016 pages with it.

Nice catch, makes sense to me.

> 
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
