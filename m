Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795162886;
	b=QJdPl08i3oF/ydFjfLkJ87QD/8XrqjiwZ5PVIrCkqJN4TCwgzM3UGm5WlvLoK+LaXD5V
	 Ufs1cPjqaqAa3+Hs7UyQCNLyGgDhgCw1bVrkhZ3Bl2KgRbFj/sD6+VOjk2jyzY3ZspGfb
	 brlxkBrnRl+Y02ok+NNvuVfaqBRstK07jTrdcW+3F/dIH2Dlq0zvKgETUXRsuM8fdITio
	 4QBLdpXXAV1VJTjer0lyd/ELRMTsDyWIOLl5h2N/7MmMHRTnoF+sOAP9XEyZYEp8BLfCu
	 KQ3imwnZzRUp+IYNlBw/YFMfwl02so6nRFH0h5Is8u6R7I7HU9oVzL4VI47l+MAHyNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162886;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=uOP5aWJGRtaVMkdWmgxTwssrKgIM3MZe/XfpLaSpJSg=;
	b=uTxPxxTE4i3poKbP6/MmTT6u3GC5/SPEhb25GlE1VNJgrN/4Edw/xrFdmKkavdU1hPSe
	 5SbW89FbhaSvLWoxzA8RhrD5l2z/BLxjdf2dSpMDO2i4aXALqqGUN2+uMiYEsUBADi8HX
	 RYAEg1y5dgNkgjEXKTAZJkgZ4oQP3Nc6ezI+OHcF8qe1AKBc25GhZybC2fDjRm881YYYz
	 p07LAkeDo2Drf0wfJCaCC/Qkucg+7VBLOwnfqDe/GO1o4oAILWNu2daQxt8WVCfrU1SCy
	 kSnzFppr8owWdbGUSK1Sdnzh5DlJ2E0bNloHYQgfff21TFyJmyDgV2WZJVX2hkJ6oQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hpMvuF7a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DBE60A2601
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 08:21:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38DBE60A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hpMvuF7a
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b596afb4c5so678436a12.1
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 00:21:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162883; cv=none;
        d=google.com; s=arc-20260327;
        b=dXc8Rn6u44g/qMBYjDXzUhZjtOdwd6AEucBAzWqX88Tcbxf92HUOu2+PUyVD95Yjg5
         miLmsOAeUJe70StwYT32cU0QROe1Phk6nPqS8lMR7FeTmioPZvgioQF80211GXQu9aNw
         pigNQMu8p4ID5/OQ3jUi+XG280EA79i/lpZ2+G30O47KJJ9WEvN6gozghI8qN/J2YM6d
         R5BFfc25m65U9qt9x8WyDWxROUo4TLk4eJWJ6KCopWk54X6H9uWCfIa3m0YbeJTO6uLj
         mvW6JTcaL+SKr7A3h5N+fbqMrpv9LCrqmg4DPQxOOzXo01v6I/vHtUlglhpZRMzrqqkX
         2nBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uOP5aWJGRtaVMkdWmgxTwssrKgIM3MZe/XfpLaSpJSg=;
        fh=MCPMom3M1sv5CDPnXBt63zkIptFAeYxLvZGMTDhH1U4=;
        b=Q3wOgVQMyKb7dXs990JOChtBzuUBTm8tC2MYGGzAv6Xn/ya73qdjx2oBQ20R++kDLo
         FqCnsbv78rhyqbF0A2nBmi3mzwax6oMljhx/kBfUNS7kqOr58xS/1q/fTBUcZUvHHGGK
         a7o2KdG7KmBYMVuwB0CG8czCVzPfwyjWK6x0HisN+2F8/COkYGSaFdGCHGpyN8/OT5aF
         p8KLP2G4CYukD26OLbKdP5K9WPhyhi43Xq9yHT16sQHKGBFPNQrAV2VZ702XFfNlZP0K
         KsRR6JNZi/zp6bS0wV+tMvKdMgwtNJWqnyfKN/O9AdGUFldU6pqi6pWS5dKwztvFqMNG
         2PmQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162883; x=1795767683; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uOP5aWJGRtaVMkdWmgxTwssrKgIM3MZe/XfpLaSpJSg=;
        b=hpMvuF7atQx5u/yCb3O+48tdu/pjRN681S7BaZGK1eaMeX0QKtN8tQ24Hkl4rjLYu3
         pkqLXW9ef+K8YJouQyaDlo7kmbPW/svFd47P4jhMu/XS7xAa/ngYdlnmC9wcRy5rBB7p
         Y3MjEzlDTDKOtOZ0p5S2UTl/SrNoZsPjK/sx5cSpSarua64saf9skOc9zh4cIyyHAkkl
         xkIBI8oHLQxNJDPb0SaHhHNnEpx8EhNqtdlSHVzD8lClpoENGPdJH7by3WfOwqjjycs6
         Ulk4wE2dD2QKXo7Q6P0gGEopVb5fRz/nbkVW88Z42MjOVO8sf0pR3tYtonISKnVcl7We
         7ldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162883; x=1795767683;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uOP5aWJGRtaVMkdWmgxTwssrKgIM3MZe/XfpLaSpJSg=;
        b=s4HyMXPogs4kJeOSIxOa1WBZ+2C9ATNTB8m7zFqPep6PsU+igNaNHa3U31tsCP8cm6
         AzyYDO/PyRl8q5W6asHx2nd8mIaKIk0nV4mXv31oevxV4hGgQR7+Nuy91h0Og7EsmuvX
         HbGTXgOHu3eVdXsK+6E9TIABGUywULAqj7+Bt4zBefg797a4mPuIHy3ChAolYaBsztxE
         VTVrGFKtqbN6y/DLdJX1j/Za51s0QYiB2Hz7mFAR8KZOuflszahGGH7MZnnLKWZW4gyP
         mEC4A6zJZigBl4+9WfBZ32d9cML1X+Y5+9FEb0jBBjAkUhUsNSriGC4bm8B88TPeC8t9
         KZQg==
X-Forwarded-Encrypted: i=1; AL+hErEazDaGBHRvtd1GDMG9t/aF9FSYjQcoM84xH2yOsc6vKUAjLdC99wuALVZwrEWR9+Bk6Ztv110A@vger.kernel.org
X-Gm-Message-State: APuU4Z9x+7nwbmNlT/Va6T/rghEIpRtcwS8KFSaPRhhvO9wnuIvCgZx1
	Oh18O4v/LbvYwAfYEPRqRyZydFXiGDvM5XWFFoKalIph7Q+uZTrhantY26Ly1JACYkdQ94Z7MH7
	ZE7qVpwTpJrKVy/F1OH9qiMPV70DiNUs=
X-Gm-Gg: AZFdTZdDoCZ/nuBXR6cW9R4G1aRI1vDilFbMWPW3QhR9gvG+zlBmjIiZgDLQ25vXuQW
	3ynxV34pC4vc+UmqRA5VZ4749fCPZY4TA0yFSL6z19i44LStUYywR8UswYCvfVYAA0kvjbzgETC
	5j3gB0+itCqz0itFdss+fs5WT/uZ38kI/RL9yTNQ93nFNIyBpP/ckpRZ6jEEABw1z+GseGl8XCl
	eCgLUPneH2386Feb6hV6qBOok+Srym+tipZcWNiNb1k0LNMl9QlCV3Myc16+j/U6NC4q6G1i4rh
	+0BaM7XJrLAVNWwK+t3pnF7S/xmjJaHgXQbl3ZBiaSe59vMBdX9Quh5LX2rwyYGryC3YWCC0sFO
	Xcz2yx4FHgTyzmDkLHfaaBOS0k+k18WEKXDl6gjh59xDaJVWO/aMWOP3WHXt1qvE=
X-Received: by 2002:a05:6402:46d1:b0:6b6:efc4:9ebf with SMTP id
 4fb4d7f45d1cf-6ba37ac75b5mr1331883a12.0.1795162882855; Fri, 20 Nov 2026
 00:21:22 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-10-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-10-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:21:10 +0800
X-Gm-Features: Aa3M54pHysxbWD9vjPcsTe4RDZA-59shgtAMQxrcEcwNDlcrEAHTKKIWInyzYBE
Message-ID: <CAN_Opa-Nn_ps+x6gWkERRDWBXxt3Gqnwvfw_4rURaCdPiyTc2w@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] mm/mglru, smaps: convert to LRU refs based
 operations for MGLRU
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> PG_referenced is only the lowest bit of the folio LRU refs count
> (LRU_REFS_FLAGS) now, and MGLRU never kept it stable: promotion used to
> clear it, and now it toggles as the count grows. But with the LRU
> referenced count as a stable API now, we can use two helpers to provide
> in-kernel users a stable and sane reading of the referenced status of
> an LRU managed folio.
>
> Add folio_check_lru_refs() and folio_clear_lru_refs(), which use the refs
> count when MGLRU is enabled and PG_referenced otherwise, and switch the
> smaps paths over to them. The lru_gen_enabled() test stays inside the
> helpers, so its static key is not splattered over the few call sites.
>
> Convert smaps as the first user of them. MGLRU now reports every folio
> with a nonzero count, so the reading no longer flickers and clearing no
> longer results in an ambiguous status.
>
> The classical LRU case is unchanged.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  fs/proc/task_mmu.c        |  6 +++---
>  include/linux/mm_inline.h | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 3 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 22361607020d..f76a37d052b1 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -889,7 +889,7 @@ static void smaps_account(struct mem_size_stats *mss,=
 struct page *page,
>
>         mss->resident +=3D size;
>         /* Accumulate the size in pages that have been accessed. */
> -       if (young || folio_test_young(folio) || folio_test_referenced(fol=
io))
> +       if (young || folio_test_young(folio) || folio_check_lru_refs(foli=
o))
>                 mss->referenced +=3D size;
>
>         /*
> @@ -1686,7 +1686,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigne=
d long addr,
>                 /* Clear accessed and referenced bits. */
>                 pmdp_test_and_clear_young(vma, addr, pmd);
>                 folio_test_clear_young(folio);
> -               folio_clear_referenced(folio);
> +               folio_clear_lru_refs(folio);
>  out:
>                 spin_unlock(ptl);
>                 return 0;
> @@ -1715,7 +1715,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigne=
d long addr,
>                 /* Clear accessed and referenced bits. */
>                 ptep_test_and_clear_young(vma, addr, pte);
>                 folio_test_clear_young(folio);
> -               folio_clear_referenced(folio);
> +               folio_clear_lru_refs(folio);
>         }
>         pte_unmap_unlock(pte - 1, ptl);
>         cond_resched();
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 3323a3c7336b..14aab2b1ed08 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -508,6 +508,37 @@ static __always_inline void folio_inc_lru_refs_fast(=
struct folio *folio)
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>  }
>
> +/**
> + * folio_check_lru_refs - Test if an LRU managed folio has been referenc=
ed.
> + * @folio: The folio to test.
> + *
> + * Returns true if the MGLRU refs count is nonzero, or PG_referenced is =
set,
> + * which is also correct for the non-MGLRU case. Kept as a separate help=
er,
> + * to avoid splattering the lru_gen_enabled() static key.
> + */
> +static inline bool folio_check_lru_refs(const struct folio *folio)
> +{
> +       if (lru_gen_enabled())
> +               return folio_lru_refs(folio) > 0;
> +       return folio_test_referenced(folio);
> +}
> +
> +/**
> + * folio_clear_lru_refs - Clear the referenced state of an LRU managed f=
olio.
> + * @folio: The folio to clear.
> + *
> + * Reset the MGLRU refs count to zero, or clear PG_referenced, leaving
> + * PG_workingset alone for the non-MGLRU case. Kept as a separate helper
> + * just like folio_check_lru_refs().
> + */
> +static inline void folio_clear_lru_refs(struct folio *folio)
> +{
> +       if (lru_gen_enabled())
> +               folio_set_lru_refs(folio, 0);
> +       else
> +               folio_clear_referenced(folio);
> +}
> +
>  static __always_inline
>  void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
>  {
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu
