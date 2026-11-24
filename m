Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541094;
	b=dC1L3kBW6pouxkOjXc09a/x0A0WKYC9xnuesv4HZ8omg/42L3fZeggFpNvXuEStMbnmU
	 G6hGSgP1lp1u1a5Qw4M/x64debbpzKVjuyHVlHbCfmQaEj0u9us9l4uZ88defFCavlljh
	 9W8N9kxepBa18CD5x8G3qcvQbNN01S6ZKpgFEt9Hs7AYl/hdEgQc4EKCXhrClakM3NTQQ
	 hk3vaEO0sm2bdg6b653WRE89Y1G+9ANPqIHt4/X12LeZPkZ+iBZ75iIul1VAdZrX6hsHS
	 cfndUt2Umfe1dvopBbYkTG0yDCRdT8SOgB4kHi82zIf/LqML1IwNPp/jUXLDtn0MOiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541094;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=ozTidCXqTzSwi9dcCKWD5fJGGI9rCJsLQ/Ov08gLSsk=;
	b=pXpWBCSSXHSpgrpnh8GUm7gmdbEUAEUcMMTcwuza2lkv4cabZYD03k0FQEIiThWmUFz9
	 Txl5qDylWNPJOCqH54SUjwzO7iWWhGmGpuvh4gMbTg7mOvEnQPHsiXPBI+MVHHiPBdmm8
	 EebnP0bF8iYNF2MDHtXYZ8C7Ea3Dtso6MMldKYCp2FuL3ZjjpeNVpShTyj8YqeA/ExBYl
	 zwhgWvtD+OzQ1BQBcNcXOAytUvSEl7SWLKDPF/IViQ/1omD9cS4gDa6NJEJwMulI7oE2U
	 WhhoyEiLL4NBJANcTLKZB3XCn3RjpwSrU5i7h8j2MYwalg5nQnNRzhyyV1IujpJOLTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UEsvIshR;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06234606A332
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 17:24:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06234606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UEsvIshR
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2f0a0d1a1e5so11644245ad.0
        for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 09:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795541093; x=1796145893; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ozTidCXqTzSwi9dcCKWD5fJGGI9rCJsLQ/Ov08gLSsk=;
        b=UEsvIshRIY9txsH2W7YuViBjWyb6RCmLJ1dlolrxjjdbyMWW9RSfAuE9mVkyY4ufZF
         8FqH0V9X71v8mD8MmM0dodRkQVkzFJayU5PbfS5SUlKcQbQNIhmha312AWigEQacHXvz
         tlnJ+cXXRtr3CeJHvWoUEP1wLuvCJhLY3xGgX5UGoXy34aaRiRbh2mM2C6hREOrMuzd+
         0HL60opQThWLEOzStOspPHJ508wq8IPVtyTge/TpJczhosNhj0+uO5zfRoaDcTTXL78F
         qGmrthQRxbkjyyqlkMbgk/kUdP/CkQc8Fsl1Uby5M2xrJzqUzzuCunvvAzUvLaQSbJbY
         SVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541093; x=1796145893;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ozTidCXqTzSwi9dcCKWD5fJGGI9rCJsLQ/Ov08gLSsk=;
        b=lGBwfO0XexUNhMvYvzVDrP7BZ6kktuBKNEimkSl/IXmzMNTCKv30QqIcdq2E9TQtZp
         avBLu636fGxuanuXBeTRnA5SoM2m2KslC1qB3Dp2FkTseJsljqKshGSQBBOfBsbm95ld
         VpMfmCBPYJoes2t9GYpxN2GbjdIhEdC9EcvjMP6V0DnVgm/dFNgHHrATcx/cr6e7VsWV
         IGVC3/E009ZiZKzCDkx/6TM5fN0GN+xjcqPKtwso5ueVc5oUNxi7lPGRs0qZAwbScD6E
         4D+bEaD0LCxLERj5CL0OocYv9Ij/JbfGY4lBXi5RxcbNRrulXUvLJxLxVO/+b+7wURiU
         dEBw==
X-Forwarded-Encrypted: i=1; AL+hErF9uSqcmHllEOO1X681djXSFJFYZ9TZRvMU63GnyIrx9idz4ppSBX8FEQkB3Y+vveyy2zdZoutI@vger.kernel.org
X-Gm-Message-State: APuU4Z8V8K3SDwYD0Nt8fViuxx1Yh+m4YmSHDRdU/YGY8g3bd2nNq7Ol
	P0eBW9VbfyTIx2FznAcXpuK/g8iE1hSLjIr/t6+6AjPs1rykw3xzgf+C
X-Gm-Gg: AZFdTZfEq+u2x7Yu67YbZdmfHOde/7VwF6l867pssPo9rkOjjvdf0WCW+JUnRkLlTdY
	Cv+qbeC66pWeAm5g7Sx2bxKS5P4iqhk233GCPWWp7lm/BTibjjmaJgN/QC7ETj1e0YIX9QVL8EU
	a+ckuSWddm1Q1AbFMO0OnkS4x7GfShQ73uUuyJ5yiTTQxPQoVmRMcmYv00lhTw7c0I+DVV9PMgy
	vD1KZoBIWNqUfHOW5Lup1KrHdQDFrlpp5UKBs2u2wqeFXCHFxXIWwVzsjujW/63aBHsbqfGFp5D
	UtXoHWB3ZtfZNSame3MgrKJN+dy2SgvmrXhCMgg9cMsg5nPtojkNbMPyL+D1gHo0g8mbRXwBU5I
	XNYeFH2EmgRR/UUllq3J4nEObU+s7tqis7HC+ASTYNghUfCEhTg4qODBU6mhoaFfAePxWSPhx8g
	9AzKVbXu4zWdIMNXYYR+St5U/+JrYFncTKlKOLcWtC0r7wmQtgZW5C1AGI+6Itf6F0RVdachWD5
	LvfdLohSzIZsVvSNr+JFITap5ym+WJRP6k8qv3riZpTnvn4eOrtD+q6eyzenQHCtUDFKxEm6MnI
	+rMNQ8B1x7BKwwqMT4HEuOp2O/hxKQ/e/OHkbezd1LyPlvATB7wh0PMZeHiHj71s0XUhHkc=
X-Received: by 2002:a17:902:f647:b0:2ef:e130:1505 with SMTP id d9443c01a7336-2f03f17d196mr143597245ad.10.1795541093208;
        Tue, 24 Nov 2026 09:24:53 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f102fc4sm72406805ad.43.2026.11.24.09.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 09:24:52 -0800 (PST)
Date: Wed, 25 Nov 2026 01:24:38 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 15/18] mm/huge_memory: mark folio as accessed more
 accurately on split
Message-ID: <awXABa3dYhEN0YEt@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
 <DN2V8E26C4EL.2TU52TEVLUFA@nvidia.com>
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
In-Reply-To: <DN2V8E26C4EL.2TU52TEVLUFA@nvidia.com>

On Mon, Nov 23, 2026 at 03:17:05PM +0800, Zi Yan wrote:
> On Mon Nov 23, 2026 at 1:53 PM EST, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > The behavior of updating the folio's access info isn't consistent for
> > huge mapping splitting or ordinary unmapping. The page table's young
> > flag has to be translated into folio's access info.
> >
> > Right now it only checks and sets the folio's referenced flag, which isn't
> > enough since folio flag updates on access have their own rules. Ordinary
> > unmapping (zapping) calls folio_mark_accessed(), and it also checks
> > if the VMA has recency to avoid false updates.
> 
> Can you elaborate on why vma_has_recency() should be used? "false updates"
> might be too vague.

Thanks for the careful review!

Right, maybe I shouldn't say these are "false updates" indeed. But it
makes sense to do so, will reword that paragraph.

The young PTE becomes folio hotness via the LRU refs to help improve
LRU accuracy: telling the LRU that the folio is accessed, so it should
be protected as it is more likely to be reused soon.

But vma_has_recency() is the app's hint that these accesses are not a
recency signal: MADV_RANDOM expects "page references in random order",
POSIX_FADV_NOREUSE sets FMODE_NOREUSE, and MADV_SEQUENTIAL expects
pages which "may be freed soon after they are accessed", which is the
opposite of what the refs mean. In all these cases, marking the folio
referenced from a PTE access hurts instead of helping.

zap_pte_range() and folio_referenced_one() already ignore the accessed
bit for such VMAs. The split path is the last place translating a young
PTE into folio hotness without it. So while converting to the more
useful folio_mark_accessed(), also add the missing recency check to
avoid wrong promotion.
