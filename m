Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795744112;
	b=U7NLsPfONnAmhVMRDLJ8BVqID3nih65WFh8M8K5vBwdK07wKZhgOf0YgFq7/ik8qbG8M
	 g/OqJxa7m5lnLwpvZgRUaMkCp3kEVuVsJOLQ8p0bSKucmdoMOils3/+/3/aI4YbgTGRHw
	 bjfQ4R9zpK6lt+/OyYSs/mFb4xNJoSl4hQcts4MpEAmWuvO7Fgwy+xTMAvMFm2Qzn2jes
	 y8n2fV6M0RbeV8CqF4OelqG29auw/Twf5j7RN4wCcUgRoaPBf+pt849mUAs6K29rUIYsV
	 9oot4u10HwDJQAUcWMg0QYIIuRsaN/ibcPmxCYr6zQbreBG6uGBPGxAu2XWunIT0IBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795744112;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=aTJQdyhxcBsW+3THmacQX4CnuREPTh1k/3kUlckbS3I=;
	b=0AQnHKaavdeHeZuPyW/q/LwO6APB6OJutSM8kUHMJzq9rk2bwYftrnzJnqgE1mi521NF
	 y/Jpt84JeTHV4JDPi99bYATm9EZSVwmJ8F64CfFUk3Qx9fP3KpwCNO1W0hotMKsrcuxih
	 FU/LXRu8YzGrvQXy17yXwKm1Rm0uX5/cJIjRCZZqHLWrb3AbRHmUryO26VUkyZ8yYYZUa
	 YyxYzEoMR8g/+FyCvVvWPqvHNVCetTXy7Q4u8q2DjKHiXx9Lx1R1GP15qsWZmdYFOyh17
	 ex+PSY8PdfYk9V9X35zn/edqMA3xDHGkOeNwig+qgE0vmcrpz0nJDQYCC7RzvAJhY5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GQAyIF3A;
	arc=none smtp.remote-ip=95.215.58.7
Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDC8606A31C
	for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 01:48:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EDC8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GQAyIF3A
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Q9H1ZM4mU9UmY5HM2f6Dg/Q5kejbxPRjAjPA/4aeIW4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795744108; v=1; x=1796348908;
 b=GQAyIF3A+2EButRR4JjY4Bm85mad1mJTAC5S3LZHCgaYBn6qF95pIY9iOIbYAg16WrObnc//
 1njH7JPm+cZcEpzTh9ZJhUeqKtAj9cEzgaJlNiLYxECchCkjH5pS6HJYNL74uFQ4EBpJmAqJFTI
 0+vPU1w3AO7emKvOqe6Hh4Ps=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b8479f5f7f50d961;
	Fri, 27 Nov 2026 01:48:27 +0000
X-Mizu-Trace-ID: b8479f5f7f50d961
X-Migadu-Flow: FLOW_OUT
Message-ID: <8ec3f3e2-5d3a-4bed-a571-88f7ba473b00@linux.dev>
Date: Fri, 27 Nov 2026 09:48:13 +0800
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
Subject: Re: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count
 a generic API
To: Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: kasong@tencent.com, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
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
 Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh
 <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com>
 <e85a2666-9722-420b-9a60-9d4251fc3d4c@kernel.org>
 <awa30hwg6x82REoo@KASONG-MC4>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <awa30hwg6x82REoo@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/25/2026 8:36 PM, Kairui Song wrote:
>> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song<kasong@tencent.com>
>>>
>>> Pure code shuffle, no behavior change.
>>>
>>> Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
>>> Without MGLRU the extra bits are never set, so they are inert. Move the
>>> lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
>>> unifying the API for checking folio referenced and workingset status.
>>>
>>> folio_migrate_lru_refs() now migrates the complete refs count,
>>> including PG_workingset (bit 1 of the encoding), bitwise identical to
>>> the direct copy dropped from folio_migrate_flags().
>>>
>>> lru_set_refs_flags() skips the nonexistent mask bits when
>>> LRU_REFS_WIDTH collapses to 0, preserving the two independent flags for
>>> !CONFIG_LRU_GEN builds.
>>>
>>> Tested-by: Zhao Zhenzhuo<zhaozhengzhuo@uniontech.com>
>>> Reviewed-by: Kunwu Chan<kunwu.chan@gmail.com>
>>> Tested-by: Andrew Morton<akpm@linux-foundation.org>
>>> Signed-off-by: Kairui Song<kasong@tencent.com>
>>> ---
>>>   include/linux/mm_inline.h | 55 ++++++++++++++++++++++++-----------------------
>> I'm starting to feel like all of these mglru/reclaim thingies should go into a
>> dedicated helper.
> Hi David
> 
> I saw your comment on other patches too, about the header mm_inline.h,
> about ~690 / 860 lines of code in it is for MGLRU / CLRU only. The
> rest ~200 are for VMA / TLB / MMU.
> 
>> Can you do that as a prio cleanup in this series, so we don't have to mess with
>> mm_inline.h in later patches anymore?
> Perhaps we can instead move the non LRU helpers in it?
> These helpers:
> 
>    - anon_vma_name_get
>    - anon_vma_name_put
>    - anon_vma_name_reuse
>    - dup_anon_vma_name
>    - free_anon_vma_name
>    - anon_vma_name_eq
>    - pfnmap_track_ctx_release
>    - init_tlb_flush_pending
>    - inc_tlb_flush_pending
>    - dec_tlb_flush_pending
>    - mm_tlb_flush_pending
>    - mm_tlb_flush_nested
>    - copy_pte_marker
>    - num_pages_contiguous
> 
> All other helper in mm_inline.h are for LRU. So we rename mm_inline.h
> to mm_lru.h?

Moving the VMA/TLB helpers out looks good to me as a first step.

For the LRU part, there is already mm/vmscan.h, added by "mm/vmscan:
move struct scan_control to a dedicated header" in mm-new. Most LRU
helpers are only used inside mm/, e.g. lruvec_add_folio(),
lruvec_add_folio_tail(), lru_gen_add_folio() and the refs encoding
helpers, so they could move there instead of staying in a public
header. Barry also suggested moving lruvec_add_folio() and friends
to mm/vmscan.h in another thread.

A few are used outside mm/ and need to stay public:
folio_lru_list() in include/trace/events/pagemap.h, and
folio_test_workingset() in fs/btrfs and fs/erofs after patch 16. So
maybe keep a small public header for those, and move the rest to
mm/vmscan.h, or to a separate mm/mglru.h if it gets too large, as
David mentioned.

I can help with the mm/vmscan.h part if that works for you.

-- 
Best regards
Ridong

