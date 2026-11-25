Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795601396;
	b=qUIQo0ccY5maXolJy+D1IdKU5yCiqfSk2rSrrYnt9nHnbq43pJO1xlm+bKTte82Kuuac
	 7fZgqHd3ksbgdbqqh9FL4rU+EWVJb5fJwWkh7ow7XU+ZadgIKgvRxRPYXU2luNYJqDkM5
	 IbjY3DafXx90jha99JFJpnr8InRnd2cyIps58dj9mWDeerswX6gmtj5HBg6cHihXFvl6Q
	 Nr3kzta08i2BT9hzqT8PED4gSrXF4aBkInsT/xqdNZWNiDuKmfd7BwjKzpSCakJGmXD8V
	 IWXvE/MMvksPafxSVhR41rajde3tKhw1Y7wTorlVN1pCtU8ZT7xUnT5kpXFUG3PdpWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795601396;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=fRTq+AvY8ISbuT9KG/JFr78txoqaHjxW4VA3cGzv+3c=;
	b=XHEqPDxQgHcsvPfLgeQ5cprSNr5PQPBKVMkDC69Iqn55ZBfnkP13hpNKwICbKEg3PCV4
	 kvXzOEcfhDrwIdd+i9UuA0k80BC1EyTC9Sck21dAynGyg/RZ9r0d27F8w9X6TTR9cEQcP
	 9+trJbtOItDvBvWHrPZBUayyidKd4puyY9RXodSyu9q+t1Ars5/4ZKMKQ7GAx48QKzuQ6
	 P9HCnzqb0rzkBNKlY8K0t4/2FaDxkNvoHsyhCO+RnwnmujDmZBfLBv/OKZFvskmNQHiFI
	 v13IR6HBL+95/x9auF5kujNe6/+2mrvUKbyDIPoKK3HDa0lsYFutsFND6hdbNhVS7lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hrqSbBaF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76450606A31E;
	Wed, 25 Nov 2026 10:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hrqSbBaF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6DC1F000C6;
	Wed, 25 Nov 2026 10:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795601395;
	bh=fRTq+AvY8ISbuT9KG/JFr78txoqaHjxW4VA3cGzv+3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hrqSbBaFPjP8G9n1TEpjd1nBDvi0kQZJPz2xrVHr15XyRl9owNVJwfef7a1Yj3Vtq
	 hMbwF70XbF4FHg0XftOd5SE0U8cri7N7kzR6ueyonVnqIPAYlJTqfsAr5SOmCtsi/b
	 LWsyq5YR+auu4GxdhholkFMxCQvDSCFOsafIs3vOQBdXmfO3jS7OzpT+eTicBotJvX
	 SLDtmESfq2cKhB2yHNwAEaUDqqsMgpw5es9IrjvQ2f8US4vF3f+DKAI6TgtUgOdgu/
	 wIirgCJP4tzsSKbnG4ctC58tWlsYPSCCv6ccjzIZ6JymdiuF9weLIVkzEI4AknvGBm
	 BVYqPJf4XXMMQ==
Message-ID: <fc51ad85-16f7-41fb-8eb3-2b8ee595e711@kernel.org>
Date: Wed, 25 Nov 2026 11:09:37 +0100
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 15/18] mm/huge_memory: mark folio as accessed more
 accurately on split
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>, Ridong Chen <ridong.chen@linux.dev>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The behavior of updating the folio's access info isn't consistent for
> huge mapping splitting or ordinary unmapping. The page table's young
> flag has to be translated into folio's access info.
> 
> Right now it only checks and sets the folio's referenced flag, which isn't
> enough since folio flag updates on access have their own rules. Ordinary
> unmapping (zapping) calls folio_mark_accessed(), and it also checks
> if the VMA has recency to avoid false updates.
> 
> So first just use the right helper here to be more consistent. Keep
> accounting the young PTE as a cache access, sticking to the current
> behavior.
> 
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 75e8641bf9ff..fa9f6d21e786 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3122,8 +3122,8 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
>  
>  	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
>  		folio_mark_dirty(folio);
> -	if (!folio_test_referenced(folio) && pud_young(old_pud))
> -		folio_set_referenced(folio);
> +	if (pud_young(old_pud) && vma_has_recency(vma))
> +		folio_mark_accessed(folio);

Can we just have a helper that abstracts that? We pass in vma, folio and young
state and it takes care of things?

-- 
Cheers,

David
