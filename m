Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB0A337699
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789146166; cv=pass; b=ip4NDOkLdT87ohMuVTjCciaGENi3PnZqQdP+D1fz3MPvsiAXzWK0jMItH0Z49BXM3JFT9e9uXISWD+eN/WUu/Y7wV6CsC0QfhECygxGzeI6Sckjljvh7S9xrfOnTKSKJZLspklImiOJvSaxqjIU1tuZH9iLH9Xff3MtX4RDa9kk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789146166; c=relaxed/simple;
	bh=lEBjerB2ZaHUd2HRyZIeMAAHDOVNiGkEpACiPSF32K0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rfR8tWvHj+TPpbIOZMK51I68nIrmV9nvbP9xNhk+9U76o4hRcp555+NOzksF/Ns8fNHVpb/IygingV1TCm2Wf1jOs3PMF92mFf4+MdTrT22gO5A07Z1Zkee/4C2Lbam6Nz1AKjSN1vMcl0Q6BJa7kc47S766AVEVLsRgw9AigRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PSSKsIBU; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PSSKsIBU"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c169ae1cb26so302288566b.1
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 10:02:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789146163; cv=none;
        d=google.com; s=arc-20260327;
        b=ei322EZy9Lh7lpJ1hXIiGWuRWv8eRh7MSJPmyMgxzjIx+ieW4lM7UbqiV1mrlwrWV/
         zDhJCfQAUab/t9nep6Je5N3jZDJzfvfJgHTt9FHWZkSUgTVaFhemxukw8+WF09rpmCka
         eg56Is4Yv0wThvHXDT3Y7t8XRWhn572zm7Np2KTD92r6rn+yGzATbnSLlxpdakUSMp7Q
         tfbiTE7iLCU4e2rkC4BwPvQr4Dj3i16q4AejebDqBLUXGdX6qaaLIq2PYHHejg1K2gr9
         4cwAgOP0FLUoTnpmyjXsFDoHbnpoiT01F8J1UpBOxFztNLfx2i7dQPaJE5LiRREihKdT
         II1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OECv2yjkS4C1/vp1OMprOqRH2B2H12xO1mA6lcxkPXk=;
        fh=drUBtAHGXCkLD2kstUKeuqv7uZ7njp6DibDZw1BN4y4=;
        b=cNC/GDcHmCD9UQJZpLaP3nlfVvUL4rZfY+6E1S4ztIwlzYwoJRu53nCnL3veSf0pRN
         ZHXiG3qww7iGUZpBhynTpQc/Nx9BcuCiQuZWwuTQvOZBWVn9jMO6Ak/wkVE/dzBxft4d
         TDrGLwHeZtNTAb7OfHv4EJij1fyzz4mRUh3IIIkH8Q5ECtUXufkiGswM4FMVGvOOx/QZ
         EWzo3IoEja/jV/JOYsaJuHOcMKm+Kj+lj27zVVWeXMVNjRazDt9g4gAG7SJXWsRxqgsz
         rr3YhcIWJXZm2ekHT5A40JKtFfOzyo6DunPNl0XU4OUy1J9KM+DkFeA9BJh4eLZcfTVY
         fzXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789146163; x=1789750963; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OECv2yjkS4C1/vp1OMprOqRH2B2H12xO1mA6lcxkPXk=;
        b=PSSKsIBUcy9qWXPPdPjS2shTYOrHYxI+7JjwPD1iAbq/y7A4hf/IbpooPhQCxq4Xxr
         KItZ/y9NkYpFBGFT9RDYDHbX1t/sxF2VM83Pgg9H6B2j2I2/zvhB6hNoPcz2VUiZBVeX
         ruaMrYiw6aO4RYc3fu9s6fMXBvsQme/5euDfysceXZUmwWyk2Simg/p2pJn/2gXP8yup
         LiJRxpvGc3ThoQ/vIeglePYQEtrIiVfmF+xNJY4rBgW+AgaQPO/uVt8u9bwgh/iNZqTD
         tbEKiUqbqXMHnfAjQO+KONv56GNa4Mw3gxyrdwZs9NMLh19tYZRMn+FM/XX/6P6SG7Kr
         OlqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789146163; x=1789750963;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OECv2yjkS4C1/vp1OMprOqRH2B2H12xO1mA6lcxkPXk=;
        b=Adgx4wcQ0jnHIZL5P53ZtEEJGdDbZTQdSZAWvmCkmpe2G1ABfAcs5zg9ovdamQCP8/
         16yZQL6XMfi82UdhfSFgnJ5u9xAPBAEA/iFUmCCLeDhOOcbhr5104jJDZeegpKNnfX+G
         VDbFG5ZaBUsDXIjARa6wNNZJzgGZa62UGt7NC/r0Lisy86nzKA2Uszkp14S9hsWN5OIl
         QoYPjHIseArntviLyVrWzPjx2IR8RQEsU5UjkbhhoGkvgPeAWBxVrU3Tp4rahFZr9exU
         i1+NDtbvO8ceuvCXc8QOyc+Of7yZGwMDBi0hrbn7bfN7ar7c6gK8fP6ch9uLKZbjJPp+
         EDpA==
X-Forwarded-Encrypted: i=1; AKwUvBwUQCz/omZTLR6J8qtxbaaGH94dKuVGMxrJy4h0l2T2b5BVIuVOajETWH9rLbxdjcDUXZVJCQLp@vger.kernel.org
X-Gm-Message-State: AFuF++n3PTT6syJBsRkWgIkuPKUKk5gkLUgLe0luKSHFpX/Vju3vClm8
	+/AZs6TtcP7nnTWy6Ubs93VkuC+AL3lOUSEyosHQ5RaN9FOGHfFqgcFQfzBWfFoju2RDIpWGtpq
	x5AufVQo/VSGTxn1eNrtp/8YSXsFbGpE=
X-Gm-Gg: AYBFou33bYDGOGwdEvA5Uw2D3g/HhqlmkndyHItR2zxEQWvs1ZHP65DVqX436G6LnFs
	a0gOGRyXKiJLqxGNNM8CI4ft0Osb6j7Tr5Esg6wA1ypo5H7jKSlj4MqemnDB7/8iSiwoGMLi6V3
	mOaAMPdWSTOYHJcJxcbTDtmnvxMOBOs9atyCq+6lDf4OBlBlSzth7VaEmHduvZaExGnYd0oJSu9
	vZjFlpwUwjEWCUBkLb3jKEyjwEvxtCyfYhbgngva51PLK52oTZLQcKwb5UaWnBaWWDxlcEHvV8G
	2Qy/5GgcansHiO5N1wquoF3pxrnUqwD884NL9oEBtTuT3aQt7ZvFzatTNpUFKqpUoYlTr6MxHTo
	Zh3BeElH+I8Zv
X-Received: by 2002:a17:907:6ea3:b0:c26:1cfd:4244 with SMTP id
 a640c23a62f3a-c2945df0046mr549681566b.11.1789146162827; Fri, 11 Sep 2026
 10:02:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com> <20260911-mglru-fg-v2-2-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-2-f26e5cb26da7@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 12 Sep 2026 01:02:06 +0800
X-Gm-Features: AcwNN1WZxmLzBpJpg1QE0SBA47yQSwx0Rtahq0z7WbiXeya29doeRNeqKHQTWO4
Message-ID: <CAMgjq7AAxBGFN05ZQQsqhWhKi8XNyxCfCbH8-G1sZfqDKEYvCQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 02/15] mm/mglru: make generation page counters atomic
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sashiko reviewed this, I think it's just false positives, see "===" below.

commit 5d43c1cf23cfcb5744723aabee21da2f8bffb50a
Author: Kairui Song <kasong@tencent.com>

mm/mglru: make generation page counters atomic

This commit converts the MGLRU generation page counters to atomic_long_t.
This enables lockless updates to the counters without holding the LRU lock
while ensuring final consistency.

> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 597f013c8e046..f52f02e8e5be1 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
[ ... ]

This is a pre-existing issue, but looking at lru_gen_add_folio() in
include/linux/mm_inline.h, it updates the folio's MGLRU generation but
fails to clear its tier bits:

include/linux/mm_inline.h:lru_gen_add_folio() {
    ...
    set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
    ...
}

Does this leave stale tier bits intact? The MM Reclaim documentation states
that all paths modifying LRU_GEN_MASK must also clear LRU_REFS_FLAGS,
otherwise stale tier bits inflate access counts and distort MGLRU eviction
decisions. Could we add a fix for this to the series?

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index aaceed4759eeb..32890e628240f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
[ ... ]
> @@ -4720,7 +4717,7 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
>
>   for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
>   int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
> - long nr_pages = child_lrugen->nr_pages[gen][type][zone];
> + long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
>   int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
>   int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
>
> @@ -4728,9 +4725,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
>   list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
>        &parent_lrugen->folios[gen][type][zone]);
>
> - WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
> - WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
> -   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
> + atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
> + atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);

Is there a TOCTOU race in __lru_gen_reparent_memcg() overwriting concurrent
lockless updates to nr_pages?

This patch explicitly converts nr_pages to atomic_long_t to allow lockless
updates without the LRU lock. However, the code reads the counter at the top
of the loop:

    long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);

and then later clears it using atomic_long_set() as shown above. If a
concurrent lockless update happens between the read and the zeroing, wouldn't
the update be permanently lost?

Could this cause permanent divergence between actual LRU list sizes and
recorded nr_pages, corrupting eviction statistics and causing over/under
reclaim logic errors? Should this safely clear the counter against concurrent
writers by using atomic_long_xchg() instead?

===

The first lru_gen_add_folio part is false positive, we want to retain
the refs info, not clean it, at least in this series. For existing
cases, maybe it's actually not a good idea to always clear the refs
info as well. But anyway it's not a bug introduced here.

The second reparent issue, __lru_gen_reparent_memcg only occurs for
dead lruvec, and all users only do this for alive ones. Maybe I can
add some VM_WARN_ON_ONCE and a Context: kdoc here in next version,
it's not a bug but good to be cleaner indeed.
