Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795750395;
	b=JDhrk9+garSbo2l36IqDFHAR2aJBHHSuWf+wWgXjrva6AfxtA7ggDs7X8WxVDtt60Juj
	 6ZxCrStFIrfWWv2T5OIbHWBI7TS2z90x6lhOkQlz0Ti8F4qKDPBBmjYkbWhA0VNidG2th
	 b8Jm4rCyOXTeUjqM6I+GBf0hiLCaWRe51Bo3Krvxdc2OU01fA973kLB+Nwlz2NdpZolVN
	 d6r9lLIFatxg0PHPxrX1zRTGuxPe2DIvdFYggGLYseqKwugDydXe1cCCKim6oH24u00ak
	 JNhnia1MTBcYmd6HWAKeRSJ8S/JDulgX/ufrdzyiKg9wMZl2stIdzeQjcqfkAWYYq/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795750395;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=IvS6PwiM0MwyaI9Q71Y3huXKWpS6mVFDFJuvxq1GyR4=;
	b=p11O8Dhaj8KGk1kv4ua3KXfO1kG2C7/yS7nxmFqBrDbuQmggUsEbZo4Apn5pblj+SJ/z
	 jRNCQCf3M0uXB6Cy+VbdJd0gsqXRHA24ir3uYhEiLvPMjtEIpDT++K9J40FqnrsqKEXMc
	 rOWXhv4aCoCBd231SWePpAqQqgIt6jiR+6eVgG3Sui/zfoej7VSXZWD7hVSvtBxrj6dGK
	 Ve2N9ssqKj/TfS7reGhIRCq0byWMW7gTm6YQGANBrUCvjv5lxGp3ef3xxrvuwFNPcNxku
	 ar+LvOnRIMGHuTRhvS4DUFg0H4tSrDAmakYooXxSSitWLgZVIgADFYDbDkkIEsZOJzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iuPaFvMW;
	arc=none smtp.remote-ip=91.218.175.13
Received: from mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD69606A324
	for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 03:33:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CD69606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iuPaFvMW
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=QgYTOSCJMTPUU6uzHqdiUg0E/5P+/jUuCCDzWFkkxHg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795750392; v=1; x=1796355192;
 b=iuPaFvMWMhrqtS/gCWCdJ/vMi7BLET2lqnp6VSOo013JgeQcAQFK2eGcdauV7SeSWBGWfWFS
 +fNyXhU7CGSDhzWr4NhXvM6byFQ0uBBDIN9E9/Y0adxcevY6/kR+d16x6T1PUdhpuTCOM2U+Mmq
 iMt79omfLORrmQsQ0ZAiWK1M=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 83cf2f4b8b8eda50;
	Fri, 27 Nov 2026 03:33:11 +0000
X-Mizu-Trace-ID: 83cf2f4b8b8eda50
X-Migadu-Flow: FLOW_OUT
Message-ID: <60e890bf-d5c4-44db-9f90-ae7970b5de32@linux.dev>
Date: Fri, 27 Nov 2026 11:32:57 +0800
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
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
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
 <8ec3f3e2-5d3a-4bed-a571-88f7ba473b00@linux.dev>
 <CAMgjq7Ayu9H85wurRAUdmXEPWYi9BdLJW13BhK+LMYoBX_7fuw@mail.gmail.com>
 <CAMgjq7DwCNbke2G25Bxfj3bi5aRp3_qkGeYmCTGVGv+Y5XzKTw@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAMgjq7DwCNbke2G25Bxfj3bi5aRp3_qkGeYmCTGVGv+Y5XzKTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/27/2026 10:20 AM, Kairui Song wrote:
> On Fri, Nov 27, 2026 at 10:01 AM Kairui Song <ryncsn@gmail.com> wrote:
>>
>> On Fri, Nov 27, 2026 at 9:48 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>
>>> On 11/25/2026 8:36 PM, Kairui Song wrote:
>>>>> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
>>>>>> From: Kairui Song<kasong@tencent.com>
>>>>>>
>>>>>> Pure code shuffle, no behavior change.
>>>>>>
>>>>>> Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
>>>>>> Without MGLRU the extra bits are never set, so they are inert. Move the
>>>>>> lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
>>>>>> unifying the API for checking folio referenced and workingset status.
>>>>>>
>>>>>> folio_migrate_lru_refs() now migrates the complete refs count,
>>>>>> including PG_workingset (bit 1 of the encoding), bitwise identical to
>>>>>> the direct copy dropped from folio_migrate_flags().
>>>>>>
>>>>>> lru_set_refs_flags() skips the nonexistent mask bits when
>>>>>> LRU_REFS_WIDTH collapses to 0, preserving the two independent flags for
>>>>>> !CONFIG_LRU_GEN builds.
>>>>>>
>>>>>> Tested-by: Zhao Zhenzhuo<zhaozhengzhuo@uniontech.com>
>>>>>> Reviewed-by: Kunwu Chan<kunwu.chan@gmail.com>
>>>>>> Tested-by: Andrew Morton<akpm@linux-foundation.org>
>>>>>> Signed-off-by: Kairui Song<kasong@tencent.com>
>>>>>> ---
>>>>>>    include/linux/mm_inline.h | 55 ++++++++++++++++++++++++-----------------------
>>>>> I'm starting to feel like all of these mglru/reclaim thingies should go into a
>>>>> dedicated helper.
>>>> Hi David
>>>>
>>>> I saw your comment on other patches too, about the header mm_inline.h,
>>>> about ~690 / 860 lines of code in it is for MGLRU / CLRU only. The
>>>> rest ~200 are for VMA / TLB / MMU.
>>>>
>>>>> Can you do that as a prio cleanup in this series, so we don't have to mess with
>>>>> mm_inline.h in later patches anymore?
>>>> Perhaps we can instead move the non LRU helpers in it?
>>>> These helpers:
>>>>
>>>>     - anon_vma_name_get
>>>>     - anon_vma_name_put
>>>>     - anon_vma_name_reuse
>>>>     - dup_anon_vma_name
>>>>     - free_anon_vma_name
>>>>     - anon_vma_name_eq
>>>>     - pfnmap_track_ctx_release
>>>>     - init_tlb_flush_pending
>>>>     - inc_tlb_flush_pending
>>>>     - dec_tlb_flush_pending
>>>>     - mm_tlb_flush_pending
>>>>     - mm_tlb_flush_nested
>>>>     - copy_pte_marker
>>>>     - num_pages_contiguous
>>>>
>>>> All other helper in mm_inline.h are for LRU. So we rename mm_inline.h
>>>> to mm_lru.h?
>>>
>>> Moving the VMA/TLB helpers out looks good to me as a first step.
>>>
>>> For the LRU part, there is already mm/vmscan.h, added by "mm/vmscan:
>>> move struct scan_control to a dedicated header" in mm-new. Most LRU
>>> helpers are only used inside mm/, e.g. lruvec_add_folio(),
>>> lruvec_add_folio_tail(), lru_gen_add_folio() and the refs encoding
>>> helpers, so they could move there instead of staying in a public
>>> header. Barry also suggested moving lruvec_add_folio() and friends
>>> to mm/vmscan.h in another thread.
>>>
>>> A few are used outside mm/ and need to stay public:
>>> folio_lru_list() in include/trace/events/pagemap.h, and
>>> folio_test_workingset() in fs/btrfs and fs/erofs after patch 16. So
>>> maybe keep a small public header for those, and move the rest to
>>> mm/vmscan.h, or to a separate mm/mglru.h if it gets too large, as
>>> David mentioned.
>>>
>>> I can help with the mm/vmscan.h part if that works for you.
>>
>> Good idea! Maybe you can send a series to do that which I'll rebase on
>> top of. Feel free to take the first renaming patch too since they
>> should all be zero-feature-change :-D
>>
>> But please help keep some helpers in a public helper so when we are
>> able to get rid of folio_*_referenced and folio_*_workingset, there
>> wron't be some strange header inclusion issues. FS users quite often
>> need to call them, especially the folio refs related ones.
>>
>> (Considering MGLRU even used to try to completely ignore anon reclaim
>> at swappiness 200 about a year ago, maybe that isn't too much of a
>> problem, but it's still a problem).
> 
> Sorry my mistake, I meant file reclaim, got it wrong in the opposite way :P

Thinking about it more, the header move is not urgent, while this
series has been iterated for a long time and fixes real problems, e.g.
the swappiness 200 regression you mentioned. Making it depend on a
code shuffle would only delay it.

So if David doesn't object, I would suggest landing MGLRU-FG first,
and doing the mm_inline.h split as a follow-up on top of it. That also
avoids rebasing this large series onto a moving header. I am happy to
work on the follow-up then, keeping the folio refs helpers in a public
header for the fs users as you said.

David, would that work for you?

-- 
Best regards
Ridong

