Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795601240;
	b=2z2aim/q8LeC3nY89s3wnDBvCVtQuw0cfpKt0LLoQLYQ6uOYzGbWO+gAp7voW9x9Y2yp
	 VO3e1I9A6VPCU54z3jQKOqQNS5OE4dxZrgD/4TJOBBsqbgFHVIoxDl/cGTmQZHpoEx6dO
	 EZL6fDIwibRuzVGqdJUsG8kB9RZU0oh7DFLvKmSi4MNuaXZVhul+STM3fK7WlaQSkdUud
	 AaIhaNLg9bIrqiDEJfNw+WD80r3zjXDKDyvaT9Ew0sIBWiRJC+zc7LUxOLnY167oMPeQ3
	 3uaT94zTMV0EAz0MCRh7YjZ0FiM+Vv1oNwToRsg8Z/w+Yv7ckc8WSWPzoC7tEFS2Uyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795601240;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=mWx4O9IoqBZXrSxXrPMmLZ9d1NpcNUKfMxyf4VNB2/k=;
	b=t722ebao2Mr8uG4oSwm3QFU+QSo6blAURVWPKAuO5DrXGAZqd5DT4AP4UxV/UfrwFBp7
	 HqG8w9FQxjSc+mnwwMOelVpfQV98gaZmQwIbemhL23JgvH5HUhR5u9BcbV1dYndBonA0n
	 v2b3IIaAUCZvWp1+4dYw7zomJ541OBNzVl+XgSjFOZBpdWRHx9CwL69jsUzmv0niLMMCW
	 k1hMFkt99UQfVgINEQUjZv6Hlq1r0LQmG17Z4aQ5AA5FKWvXlGs44srjd0F6CRzoOxUdO
	 y7bvPMFR2t8gQ8bGS4AsC2tKIaT5xNtT6yOw9Vs0q4212ss8PkFe6XSD4fezOBJ60gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x9ro8Hlu;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265EE606A327
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 10:07:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 265EE606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x9ro8Hlu
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b439e37813so2742767a91.3
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 02:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795601239; x=1796206039; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mWx4O9IoqBZXrSxXrPMmLZ9d1NpcNUKfMxyf4VNB2/k=;
        b=x9ro8HlujGirtS4n7Kiceqz39P8rBYt2AApwczCy7S59DTac/QhGjF+yenBMEx13/X
         eCCu9ktzaE5ddktgrNbv1KF/0CYetKUTScAiHGiPmje59mF3+4ZbpopnrqxbXGQQOHmI
         hGKFBEShUq7cDUrceli4dKiwHMrkkMsNMGcqKMcaLfTMc36FHn2QzNeuHz+yMKMc2zjL
         /yJXtN8BUXeZ/pEiZ4fW4BVILlII4TwcC9QOrToMQ2vON1LNk8jAoozYn10R/FJRv7xe
         gn6NORYmRatB9Cu1fh3VPmcluhTeADopud+xI5Vz3C5jsIhRX7rY/Nj6r67jQyzWxM01
         h2Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795601239; x=1796206039;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mWx4O9IoqBZXrSxXrPMmLZ9d1NpcNUKfMxyf4VNB2/k=;
        b=mo5HKwhrKCE6DwSImZvP9aIc4JMhskEcuUItRRTU4efIMKamuFM94SqXDmMEuoXchx
         PW74J2KrZQr1jX/PEm0HNKF+Z9qjWHvcWrkZeomHpz7XhKrGO3C2UCqbPQe9UhU2lUTF
         dGXwPpgl/Z9xiTlyTrrTnfUppicTXc/Vht02jrmvOLbFq0ASTGEuGqfLRhZPhBIHuJjH
         hw2Ers5oMFhtvNobLYz2lAUiPmE4dgzhNLP63gTSZRlgaI7r86hk4d8bSrndQR0uXInY
         CczAbKyFgkHlace9RfUu6F+VPOO+v+gm0M6UHRoTf+0+n/kmGDr+A7aqFUizDAZc+6go
         rWCA==
X-Forwarded-Encrypted: i=1; AL+hErGulqP0GE/q+9yxIw8JJafro2TFDvbNNtqLXkimSLYc2BDSH2d566pXkAaXKxAMdy43u3FZZ3YQ@vger.kernel.org
X-Gm-Message-State: APuU4Z+oyg6+tLSUW3/o8S2sVyrb0ZhjlImnktBuXEA3oGb7d4fxygGQ
	2WukEYrv6rgFmj+QWuKrQDOgToSJ62OJx4XPFFZrNw5cgtuhLER5FKz3
X-Gm-Gg: AZFdTZc7dkU4WwALVeFon7PlS2S8BmVJ6q8je3cxWT6ZoFjCEwXYU4TkH6oVqsoPGml
	N6ATlok16FyRBxvtH1TLJW+nXCNsLrtHHAQcQbrbcRThJsKZc4ZTlbHzBiCXr6QSxo0HFunAZdp
	62Amdw+cE51IswvDwny5pkRPIYUXpRqCeBXyOxB3gO4yyY8sgM9aK4Uza3oBtMhuixqGE0zaXCM
	iNRFGNk+dwQCcZsyl4n2RYNfHD8yxALtmkY5osqg8ifGIhl5ZsmeQo8vEoUyWV/oi8IqS40SgmM
	sFT508NR2MFEdBX7AcANa2kV/mKY84Fy6+A9y69emtJuZFiYX9olo38M3QwxqYsuVapZuqFwFSf
	xctSuWY1rKY5JHl7HYjbKDBM+feXt0Y0P90ZhfEOc8+UZ09P4w0cA/acMulWz7wKc7ja2PbIbVm
	Aad5tQpg3oayFRNykhVVkvo5yye6dGYqogn6bHA0nk1DDQsI1NUVkVE1Ro3ua2lgOnR0dvys24p
	gGGhat/Eztb6CZ8CpE/Zjd72CHnVXbpzwZqARtuNhY6gv7+GTdIGezJIbmubmV41RZ1E79hso7V
	e68aTH+FAQz8iQZ5t2XOZgw9rZqVyg8mYXlRKOyoosVw
X-Received: by 2002:a17:90b:2ecb:b0:3b0:e2a9:3466 with SMTP id 98e67ed59e1d1-3b41c98a1d1mr14557905a91.16.1795601239179;
        Wed, 25 Nov 2026 02:07:19 -0800 (PST)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0b2c4sm26804572a91.4.2026.11.25.02.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:07:18 -0800 (PST)
Date: Wed, 25 Nov 2026 18:07:00 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 06/18] mm/mglru: skip the flags cmpxchg when nothing
 changes
Message-ID: <627ebddc-87b8-468b-b0c3-0503494f357d@gmail.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-6-8ffea39934a6@tencent.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-mglru-fg-v6-6-8ffea39934a6@tencent.com>

On Tue, Nov 24, 2026 at 02:52:58AM +0800, Kairui Song via B4 Relay wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
>
> folio_update_gen() and folio_set_lru_refs() always end with a
> try_cmpxchg() on folio->flags, even when the new value equals the old
> one. The locked instruction still takes the struct page cacheline in
> exclusive state.
>
> That is common in practice: a folio mapped by many processes is visited
> once per mm during a page table walk, and after the first visit it is
> already in the youngest generation with refs cleared and PG_workingset
> set. isolate_folio() and the eviction paths also call
> folio_set_lru_refs(folio, 0) on folios whose refs are already zero.
>
> Break out of the loop when the flags would not change. The update is
> complete at the point of that read: the flags already hold the target
> value, and a concurrent change to them is ordered after it. When the
> cmpxchg would have succeeded, the value written is the same, so no new
> state becomes reachable.
>
> What the patch drops is the retry. A retry re-reads the flags and
> recomputes new_flags from the newer value, so it overwrites a concurrent
> update with what this CPU wanted. For folio_update_gen(), a walker that
> read an older max_seq can lose the cmpxchg against a promotion done by
> another CPU, and then write its older generation back on the retry.
> folio_set_lru_refs() can likewise clear a refs increment that raced with
> it. Breaking out keeps the newer state.
>
> No caller relies on the full barrier that the locked instruction
> implied on the skipped path: the eviction and isolation callers run
> under the LRU lock, and the others (page table walks,
> folio_mark_accessed(), lru_gen_clear_refs()) only care about the
> resulting flags value, which is already in place. Note that
> lru_gen_inc_refs() already returns without any atomic when refs is at
> LRU_REFS_MAX and the folio is in the workingset.
>
> Tested on an i7-13700HX with turbo disabled and the performance
> governor. N processes map the same 2GiB tmpfs file (huge=never) and
> read every page, then one aging pass is triggered on their memcg
> through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
> Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
> over 2 boots of each kernel:
>
>   processes    base   patched
>           1    32.9      31.7   -3.5%
>           8   195.1     160.2  -17.9%
>          32   755.8     592.2  -21.7%
>          64  1597.2    1260.6  -21.1%
>
> With one process, every visit changes the generation, so there is
> nothing to skip. Before the patch, perf annotate attributes 53-58% of
> the walk_update_folio() samples to the lock cmpxchg in the inlined
> folio_update_gen() in this test.
>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> [kasong: adapted and rebased for the series]
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 2 ++
>  mm/vmscan.c               | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 46beded51c7d..2571b3f01226 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -233,6 +233,8 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
>  	do {
>  		new_flags = old_flags;
>  		lru_set_refs_flags(&new_flags, refs);
> +		if (new_flags == old_flags)
> +			break;
>  	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>  }
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 202e0f874b23..15df5618a3cf 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3274,6 +3274,8 @@ static int folio_update_gen(struct folio *folio, int new_gen, int *type,
>  		lru_set_gen_flags(&new_flags, new_gen);
>  		lru_set_refs_flags(&new_flags, 0);
>  		new_flags |= BIT(PG_workingset);
> +		if (new_flags == old_flags)
> +			break;
>  	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>
>  	*type = folio_flags_is_file_lru(&old_flags);
>
> --
> 2.56.1
>
>
>

I have done similar tests before, simply skipping the identical old/new
flags, and was able to get very good results.

Makes sense to me.

Reviewed-by: Vernon Yang <vernon2gm@gmail.com>

--
Cheers,
Vernon
