Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594691;
	b=QnkBVS7wyJ4YmdVehaeHjggq67OneLFR2y+Py2FyPUjEoSY6aJ6gpCUFDminhbA/GGNz
	 oGi6Kz6pXRFzgHYJc4HviFqsZ0QhsAEvbQg57owplctqeCeGV5rfpGJNRTSXrp0sGRoDY
	 w+THEk7HZ4hLgLl4ULPZkwskMdKEQeUeUVIt53p+0R2Il/OIv3UwcQGGIBnMPXZoBwQxb
	 5sJzdk1/aZqc9x+cju9TbqxDB2Enr5VcmotcNwk7Ts925QT37ldKGEH+igtNtGzap4twA
	 PCH+z2QKlRUjv0bwYWIOUycSGkhk1uW6fXPvk1ykGdsQfkm8m+3wFMFq06+zLU+0PQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594691;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=zQ4PDN/+IecVCHWBDQ0v0hwYyubU4Qhpq8q9f1QbpYY=;
	b=HT7e1e1hJsNj5WLEiJmKPO7wglCoPyIPXCE3uQX5OIjwhJmUtMhp8fvjbIeI+XgpRevL
	 qnIHN81a3+SJVlb4aJFgzoeopZv4rpVBatODIaTqJg6UZ87K7hVxuze8fLZ34+jdC5kkF
	 MZ7xV0m3HvaCbjmrNsQGM1HcoZOK2H/1NLXnjUZlgwR3EbRn6TFOce3Wv+TRrIQ6I+nbr
	 OVk1z8kBXvdKCVA82SKj1Z/i85dYpc0+wUma2QLJXPa+pFxHjaQNpgcePmyn8lhvRSoyL
	 a3tV4VJsuQRaQn4hVexQoA3PuOU6dgVlyZX8abYtUeUk2kDd/HoydvHYhxYjwS5jB9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JL3SfCjV;
	arc=none smtp.remote-ip=91.218.175.69
Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435AA606A321
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 08:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 435AA606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JL3SfCjV
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Hnn1Upm6og0+ZrW88GDMEcGJ/ZGLLay+qcflC5gxlL0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795594688; v=1; x=1796199488;
 b=JL3SfCjV4080nOi9CL2Q+K936t6S+au5atuKD6XAd3apiOOESRAHmZ0x4F4NXgGc98kRpCxq
 bwK9DlYtw/+U5IMNNX+628MFduzZMqzlSkJYE/Ma8ZgafwvwYunoQzceNShRRKkN5A4TWWH81Ab
 uERyIbgFjLMa6/H3/tiucj8o=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id eba729f2d53511cd;
	Wed, 25 Nov 2026 08:18:08 +0000
X-Mizu-Trace-ID: eba729f2d53511cd
X-Migadu-Flow: FLOW_OUT
Message-ID: <195d7fbd-5538-41ee-828a-92e5f400917c@linux.dev>
Date: Wed, 25 Nov 2026 16:17:49 +0800
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
Subject: Re: [PATCH v6 02/18] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
To: kasong@tencent.com, linux-mm@kvack.org
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
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/24/2026 2:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> the counter is eventually consistent and only serves as an estimate.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2395ca8ee305..2edb9beef6d3 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -47,12 +47,11 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
>   {
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   
> -	lockdep_assert_held(&lruvec->lru_lock);
>   	WARN_ON_ONCE(nr_pages != (int)nr_pages);
>   
>   	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
> -	__mod_zone_page_state(&pgdat->node_zones[zid],
> -				NR_ZONE_LRU_BASE + lru, nr_pages);
> +	mod_zone_page_state(&pgdat->node_zones[zid],
> +			    NR_ZONE_LRU_BASE + lru, nr_pages);
>   }
>   
>   static __always_inline void update_lru_size(struct lruvec *lruvec,
> 

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong

