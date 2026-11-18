Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795035832;
	b=P57Hq0/+xtq40YCqH5F9OWZfQS737NyTgFLsRnuRtysoC32ZT9qjHPh/Mcxv7h28Crd2
	 gX/5iLn2pH36FkkgLizWwaeyAhNVGTHPDW4kdmnkBdFctBE5EiT2M9lXCQTmYW/EnjlzJ
	 E7DBQnVB2oi5QS+pzjTWPgGSzxEN0F+lKr2lGi4lDAkA4xWHiKVMchYCS0pu5H1sqfVVL
	 9D60IHs6BvWQ+vqUakboU1nFN18cwdqNOFAgDC3P1Flk31cRuG1cbJtMajGnMiYfMdHC6
	 j0LyOYbcXB1lCuo4EcOnSGDUv5pLk95FkFRKgM6BNf2LByDJYEhK3qnP7PUP+jSgKrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035832;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=41vfnI0ZoD897IEdGdgzDciDJt9MzpCIhSsZSG2H/IA=;
	b=tD6CNxuguczh5c10ESogSaMthOl6EU+BHmlIkFK6Pz/3pEIriUZnHH31oxkqiap1YlZq
	 d+jWWQWbCk8N2k6o72oWrLc1yRrBGk/0P5t8mpeEOX1LbxxhqAZ3gB1l8IWy1+cDlZ3ZK
	 hN/5X6WJ6Vvb9fIjeM4vJUNvc9DpzoKDKIyXct/99/Mo64YBHPwRBs6kGf2XQMUmbqm1i
	 5Recxp5SMRgs0+iTd9z/9L0eMeRRiS7+1JKuj/uc7OLBf9wB+Fjs1CbP4p+RWYXoRpRrM
	 0MKf4eSxNFdpTU4eWBpa7Wc3N2gNp3IgVIkNo/kwjripDru0y+7r+EoxKTE7m2JfeXw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="FNV/h4F3";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F0460A2619;
	Wed, 18 Nov 2026 21:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FNV/h4F3
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035831;
	b=Y+oTfttcPpcmZPqcaQ+Uh/B40XsOrN9wqp2t51s0EPoIJS11TzUHjNlwmeQO+Iz3tbTy
	 6RAA38J5MKvsm31BC0nC1RkDVsORErDJCYlRIsmHBZ/+td511TpBMvbMOAtX+NwdLot0G
	 sF4UVmLx4L3GyioAMoD85bNjZf6SZGh1xVzq3CjzR5b6g4z0xX/jMVCDCk6gyGZVTGD59
	 WAcvKoKGDvZ/emE73wHMZj/hSgMdsF7MWe/yEOv23RfxrJg46Xiij7Tu1XvPDwU5nqwew
	 082Kg1vZTCLM6VqFRKGUQy9M3rIA7BYonChF4zfPouLQJTHZULP/m5kXlwKXuII+jMg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035831;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=41vfnI0ZoD897IEdGdgzDciDJt9MzpCIhSsZSG2H/IA=;
	b=swMVbQAwP+KsEUz5d/r5r7kQapafdGXXbE0TkFDnKCci4cb+HyZXbVHNuUxbh6/HPS1u
	 mNHvwVP4giFqS/uQHDQHqhNd35Q8w7+azhJ4ZZ34TOaznvfz/pgyf7Gp9N/eZAK1uSXnn
	 y8Xwx6DpBQjEK+sHW/NErZetysMhcUiXC92ZYsoaB1QXBDWo6Wq8YC2XbpE2lxDks7vTC
	 C1MaW+zC7tN5FWm9fQpU5EzuTTScWHhyI8JmiC+p2I8jczZNoHwsS2Rduy/srLoYusp9S
	 BmVuS9Wxiy+xNA+rdBUttPyiDaKukH8XkDBkTHcpTs6uw9YXP+Ne7MZVzEfmX05mMRA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A54FF1F000CB;
	Wed, 18 Nov 2026 21:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035831;
	bh=41vfnI0ZoD897IEdGdgzDciDJt9MzpCIhSsZSG2H/IA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=FNV/h4F3Z8UzmG4/YD0ypGY2S7UDaw+Sh9r5YKdXjCwy42yB6c3QPJ4eUNjtVpBdQ
	 1FLETznddO+HUKlplYrCqhW9HbptqeAETF5wtZmY4Vohyklxy6HHk8gnP7aNL/tR+P
	 YTDMH1yNo7hY92i0LIzIJvsoyvBu7vdPPrq/dtwCZuN/uOQpaaSyvTvxPF0HDiLe+c
	 IN9gWrPuPBX5+M0h5w9NXsfzonlkSuBFk4Jwi+zf3Gx1pX1mmnOEtlwwhK0InL7yVp
	 1O80EaC+//Gej9ZjOGnCaa89b1AwmEThZOczqqwwJIUUO05TsHVba7G0OT4ghufJP4
	 rDEnmxK8TLZHw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 998694AF98;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:37 +0800
Subject: [PATCH v5 05/17] mm/mglru: skip the flags cmpxchg when nothing
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
Message-Id: <20261119-mglru-fg-v5-5-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
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
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035819; l=3975;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=rKjtT9cTVQE3kB+eFzFZdlThrfxXKVi5B+1GEDGHtjw=;
 b=eXy1GT3doCWx4eA2MrHyusXF+V13z0BHWbZolJceGwJbmMtsa+zI9QRCGuCTBY1Rom264jpeW
 FKGD+ZvzktJA6h8Yvwm38iMU9RTQym7XK1PfXQXh4ylDSTy6KSdhsZ9
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

[kasong: folio_update_gen() is replaced by folio_inc_lru_refs_walk()
later in the series, which keeps the same early exit.]
Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
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
index 8d14831cdf83..0f24b6ebc1eb 100644
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


