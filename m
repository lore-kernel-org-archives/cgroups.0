Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460016;
	b=R2th9LCwxF7KvQFNS4rI1cp/lSaogxGtf3RtsewPe8vZhtDBdodXGqyjgm1DoN/Fd+iF
	 cYW4goEp6CIuoGtZbTpfo89xabFab22rAJ8gOsDeP7sOGgGnDYwdcHyie6fve7CrcuOgf
	 juVCZ4eI6D9KR/9dwg9a75WBvnQ0a1b+I5GOFhLf5h7MAwCYBZqk8sZtqDVElKRGhYvwX
	 gzmkh2cCVmHIinbPqYeJ3NOHFxNhluIt4v/IlXETejD8WfPsEtrRHUtBxg9WjmVIYOk4+
	 jilbeiP/w1p0TIpRojDxiwsrLwqrnwcrNfsBMD0vgJvcjKVNtEJxaiT3l7Xm8lXppAg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460016;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=FZRD7oqKaa21oADy1rxMl/sYyXjHVIlmH9ps+OCcBhU=;
	b=AsjCrOjvMSVaFWd4Lkd4PiKIToV2DDW+D3nAvrl0WldYioZdas0RWpM3JzMKa9ZqROc1
	 8uLRPNuCFXwDv5uSDuNje36+ssdgBGei03r16l/ENaep1TVzyZeILufimFbfoKOm9nckK
	 IoB4nPRKLRpM+3NpKkchductMmVAAHFEONxnlSqiaMY5H6y8z8RSJq7n16FbHuzEETaEs
	 8elW9C8Rn9MJYzoj7loHv3qdpXN8iSiivjNGQZuRxG6TGhS45r0PIA/gdTGZPA53qr3es
	 qEWzljuL1e23OEFULlZ+7EccSojsSIz1esvLoZ8qT2Fx25C7KHJE1xXX/Z90W60bNZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dcxTUMZ9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9AC606A330;
	Mon, 23 Nov 2026 18:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dcxTUMZ9
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460015;
	b=qLhgM1UyNv38rQT8tlr1razCioZFE0aVgcn6iK3H2UPkkeEkqS3tfsm1stZq/9DSaX8u
	 V0SX2T1/SkjHWu/Mr3ULj30mHJIcxrKFXS0a6s0D6Wvu/2cKbE+vd/Mubp3RzPkoPJi8c
	 eHIjmPANIlrnfsxpRAkhwLkR0HiM7+Wc0eI6LNm61vEFTD3WkgTLwCN9V5iXBfSa/fdxY
	 Eqnkab8ju3/Utka/b/Rzxq6l63hIGI/Qv3+XPnIEAEcOxbfRjletYetWzI+VQL4mtU1uY
	 U/bsh8PoXWxKQMPXaxahNdqrTVBX4XTucX5MgbXto6o5ckL+JqKLTrzlCIdGiTAOnaQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460015;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=FZRD7oqKaa21oADy1rxMl/sYyXjHVIlmH9ps+OCcBhU=;
	b=yWb3XjNmEUfRNm+FvePk7x1dpfKAqBcFOMKQGoMwa4w+4C2tRZFQhDlQ1NnxY7/H2OHC
	 NiNJeQZQns2dl+j+yU5dGefup7+jLT9vV0HSCtBfFZDxBuExcs7quxVxlzS0ussaHfkQq
	 CSzPxtXPgq9g6H/Bht7wesvjNsXUdPeo6xBNDQM+EGW9ad0+ofKLkgZEJ1/PgsKjJ0JLn
	 Bs+iEVPkvMmX8F/p75NIZpnxedTcQFOMfG0D0KXrqXHH/gkmx0b281PqBNttS/yFNq725
	 JKDj7A/nMZ9SVnOeSvDQilPQ9aZ//9PdSCZ9DUbs6TJmxpGGzR8boDQ9ZU7ymkVVs+g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B7E891F000C4;
	Mon, 23 Nov 2026 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460015;
	bh=FZRD7oqKaa21oADy1rxMl/sYyXjHVIlmH9ps+OCcBhU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dcxTUMZ9iXBIWh3bIxmENjyUCRtPLlXPNyapEWUV/O7o6jZZc/PfVVJm5fNuPB5Fp
	 qxJA6tWREoe6Nmr/1qiSrbwSBHyz+q95AlJIEdz4guNq9rlxe8411zLsofwmJlFdJs
	 aHICoTHA5nMDP8yVRKJDUOOlOA/jjLCQ7laJTobKEQMHDxXfbsVR29fUAgyGEnyLSZ
	 Hm3+YZGAnUUNqoO6vHdjJ2oHZKnku8/mWbF61G2YVWi4Zw2mXQ0K7Jvk1I9HW4x0Xs
	 wmg2s2G9bhNWKNdoVET+V5c30EmDlslwaRS5qtXEIvn/hrGjRJu77KJazBd54I8w6i
	 KGmi102Hh6WTw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BD7AA4C641;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:52:58 +0800
Subject: [PATCH v6 06/18] mm/mglru: skip the flags cmpxchg when nothing
 changes
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-mglru-fg-v6-6-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=3997;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=//cwp1yvGPvx4hSAYTY0g5G2U3Dt6Ds7AHeyEL5Sfsk=;
 b=OR6OERTRzsjoPZgx5Bj8eld8+L1XVLhawLjPJ1B4sc7XEOe3NGkoxMtMmdek+EcOY+3113Uru
 m7OZMjFvbZsDbVamj3o5bX6sRQ2sYnivCMZ+kVKANGsxQx3MTuu1gKP
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Ridong Chen <chenridong@xiaomi.com>

folio_update_gen() and folio_set_lru_refs() always end with a
try_cmpxchg() on folio->flags, even when the new value equals the old
one. The locked instruction still takes the struct page cacheline in
exclusive state.

That is common in practice: a folio mapped by many processes is visited
once per mm during a page table walk, and after the first visit it is
already in the youngest generation with refs cleared and PG_workingset
set. isolate_folio() and the eviction paths also call
folio_set_lru_refs(folio, 0) on folios whose refs are already zero.

Break out of the loop when the flags would not change. The update is
complete at the point of that read: the flags already hold the target
value, and a concurrent change to them is ordered after it. When the
cmpxchg would have succeeded, the value written is the same, so no new
state becomes reachable.

What the patch drops is the retry. A retry re-reads the flags and
recomputes new_flags from the newer value, so it overwrites a concurrent
update with what this CPU wanted. For folio_update_gen(), a walker that
read an older max_seq can lose the cmpxchg against a promotion done by
another CPU, and then write its older generation back on the retry.
folio_set_lru_refs() can likewise clear a refs increment that raced with
it. Breaking out keeps the newer state.

No caller relies on the full barrier that the locked instruction
implied on the skipped path: the eviction and isolation callers run
under the LRU lock, and the others (page table walks,
folio_mark_accessed(), lru_gen_clear_refs()) only care about the
resulting flags value, which is already in place. Note that
lru_gen_inc_refs() already returns without any atomic when refs is at
LRU_REFS_MAX and the folio is in the workingset.

Tested on an i7-13700HX with turbo disabled and the performance
governor. N processes map the same 2GiB tmpfs file (huge=never) and
read every page, then one aging pass is triggered on their memcg
through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
over 2 boots of each kernel:

  processes    base   patched
          1    32.9      31.7   -3.5%
          8   195.1     160.2  -17.9%
         32   755.8     592.2  -21.7%
         64  1597.2    1260.6  -21.1%

With one process, every visit changes the generation, so there is
nothing to skip. Before the patch, perf annotate attributes 53-58% of
the walk_update_folio() samples to the lock cmpxchg in the inlined
folio_update_gen() in this test.

Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
[kasong: adapted and rebased for the series]
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 2 ++
 mm/vmscan.c               | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 46beded51c7d..2571b3f01226 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -233,6 +233,8 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
 	do {
 		new_flags = old_flags;
 		lru_set_refs_flags(&new_flags, refs);
+		if (new_flags == old_flags)
+			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 202e0f874b23..15df5618a3cf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3274,6 +3274,8 @@ static int folio_update_gen(struct folio *folio, int new_gen, int *type,
 		lru_set_gen_flags(&new_flags, new_gen);
 		lru_set_refs_flags(&new_flags, 0);
 		new_flags |= BIT(PG_workingset);
+		if (new_flags == old_flags)
+			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	*type = folio_flags_is_file_lru(&old_flags);

-- 
2.56.1


