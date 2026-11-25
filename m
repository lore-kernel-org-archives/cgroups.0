Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795569967;
	b=hYxIE61/MYFIn82/76XySY/rLRa9vO6ASCIj0bpu8vl6rTgJLGIF2hWV2bDDZ+2sqDXz
	 HRuxIxH0RHD2Wrn3Vph5VA0FfuwHiZ7pQJQJ8yd13onS8e0kmeKLRbQnrNfH8A+TR4nbx
	 v2/t1DHC744B24Ab9bVlXFb0SuKsYmIhr04blbR6/pFDl0BFzM/ohg2lmIRU5xE2vdQ8o
	 zuHFdCdpkxs9DW9Bnc6+TNl+4s4y5iwCup07KK+LI5KYsbKdx9WTajNim9AQrUhfk/Ui5
	 QWFSue4XfCO/ZIftTLm1Dr97HHaIOtwDlHj9mxLRAgjkx6Z8tMhQKLjC14IJ9/OHlGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795569967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ca3B9Vvi6+90qx4u9Sp1DXWE1+uVNN4yzp9+O5Q2YIs=;
	b=KZ1lFQYPSwqwmHmu6eOome9gHTBh/c2+YxG63zEme7RMkst1oF0v1h4iJfNn8CT0vpzQ
	 Ya9W6abOASxH5CqhsoXGyn9ZxPUVI7OKYNiiEpfOfQGDYLCHhT5vFgd+eJ0OGaAWYqNF+
	 OXU3KkY55qe/F8Xm3by2CnEUYlnkVYBXobixi9H2WQRHut5i5eim9CqvBqKycxnQl8PZc
	 ZE6PqGRx8jxSi5+qZuEs9Fm7IbA7FjMYJlLAAKcKM/fyJQRDXK9aRg4P7hxLlTtWBGjk+
	 AvfNoAXpkMeuZdZHLU5TaPOwKoK3biAuQwJRojMSuIcz+w/A6sGlEJNIX6ceh6Nx8+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQ+GX78V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620E0606A323;
	Wed, 25 Nov 2026 01:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQ+GX78V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D6B1F000C6;
	Wed, 25 Nov 2026 01:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795569967;
	bh=Ca3B9Vvi6+90qx4u9Sp1DXWE1+uVNN4yzp9+O5Q2YIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQ+GX78VKftJ6+id7UodYIJVWt0mLOwYTL+d/5FUAfPlDVbAfxmLIdg74hMbpoT9A
	 qMASA0BppbiZBYE6BmaS441yhU2m7bViO3tuhrklReMv1XIrnAaAlDJgGNBKQYY1sN
	 j3WxIaMwitlY3uyl8ziV6MaUD8lIEJLChB3uP6+mbI2Mtg8GRodlirFdOOYH5yVKlU
	 1X913VYCj42FXa4OS7y0H2qP2ZFNkiOG1ZFhzSMhFTAk8hV/VIEqU2+unCXJTZBxN6
	 wzdqDIb/f5BYWCtK6UNW5RduhBRF1ScAN3blsgfmikp7PfnMx1qSjB/LMh2Z8ppaIb
	 BPNSW7eGhWylA==
From: SJ Park <sj@kernel.org>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	Maxim Muzafarov <maxmuzaf@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	Tianyi Chen <hi@tychen.cc>,
	Kairui Song <kasong@tencent.com>,
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 01/18] mm/mglru: rename the generation offset in lru_gen_folio_seq()
Date: Tue, 24 Nov 2026 17:25:57 -0800
Message-ID: <20261125012558.98032-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124-mglru-fg-v6-1-8ffea39934a6@tencent.com>
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

On Tue, 24 Nov 2026 02:52:53 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> From: Ridong Chen <chenridong@xiaomi.com>
> 
> lru_gen_folio_seq() computes how many generations below max_seq a folio
> should be added to, but stores it in a variable named "gen". Elsewhere in
> MGLRU "gen" means an index into lrugen->folios[], i.e. seq % MAX_NR_GENS,
> so reusing the name for a relative offset is confusing.
> 
> Rename it to "age", which matches what the value means: the newest
> generation is age 1, and a larger age is an older generation.
> 
> No functional change.

Looks good to me.

> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> [kasong: dropped the comment table part, the series rewrites it]
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
