Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.194
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664346;
	b=4r6lmJNqNJeOC1LVaitaCa+0mFOYC/EGV7HCxIhFmtIwJtXVwVWe8js2dsiglx59hQJ3
	 4BTzEk/vKUhoOyfuSTZP8oVEWUjjrEYwJJW3koqDuPYicWvj3HSXFSVv9wLMg1+bYKUAT
	 GW3qecQLAs/ETgbcSxGN+emYl/Fml4jwdAP9QaF4ZtOcBDlur+ufhOIB/nFuXHNYIJRCN
	 LV3zzlxYXb1WqVwSXzqfJPtCjXMlTzaTnlYgq75uIYc8pSxcV4ymWhGRpPAJWxsNgar6E
	 xQ8SRjS1Uk2ODkCFtBlQrXpRC71RY0WAl78no+1vr7gFlcsgRx8ZzDfW7iT3qlWCZhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664346;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WZXhqqMJtGtQSFqs9mp5EiyQrG4t9fKkEiiJJfk1V94=;
	b=PYdJXE9YQdHqspl8q30Yx9F5Gob64rHY1KNBEruzh0Hs8qM9Fha2w9e+XIWFSl2xByZt
	 mW16Db33PbRuT60CBMEl4Z469NFX42pMgZSNQq4jvs5rNqB2Fx8LTWIAxB5zb0Q3e4uqx
	 Vxo07JxvSpyUQ2hO84MXJHJI4bn+kRxUz6q+kuWKJgOhwh/lRTJMhmfQz9uF7Gq4M40RF
	 4NGuuKlVIMs26i0TeQXISzElyN+BAonbOfFQgWuzYm0IzoHyGMVyTGDGSpqmbw3NJexL3
	 XoZhXcbBsn/eaTcSGdTmdztRESK9suIYKxbc34IcmtI2NEvDWQZBRudiGo1vFZzCL6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LSdyAs8J;
	arc=none smtp.remote-ip=95.215.58.194
Received: from mta1.migadu.com (out-194.mta1.migadu.com [95.215.58.194])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96236606A326
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 03:39:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96236606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LSdyAs8J
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3UV2O3vp01qJF08PlpVk7+NJu2+NXqvyVZ3Kr2qDcy8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795664342; v=1; x=1796269142;
 b=LSdyAs8J7bC0cwji/tGdQecq8Tb/rUDxBvCZ8eA2i2W2wcoPx32DxmBSqPsZUXpyVC/jASZp
 W5Q5gHCmigHcxUkWUsIUEaW4tZX8X/02c4qBdNrJInCsJGoAobC5G7g7oXcnSlYNUKq0omgJe+s
 93KKvNA1mcwtd7Dgk23bKn94=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5700fc680564a234;
	Thu, 26 Nov 2026 03:39:02 +0000
X-Mizu-Trace-ID: 5700fc680564a234
X-Migadu-Flow: FLOW_OUT
Message-ID: <8685acd8-4546-4414-9b92-217048766321@linux.dev>
Date: Thu, 26 Nov 2026 11:38:48 +0800
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
Subject: Re: [PATCH v6 03/18] mm/memcontrol: avoid potential counter leak when
 reparenting local stats
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
 <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/24/2026 2:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> lruvec_page_state_local() clamps negative values to zero on SMP.  That
> is right for readers reporting page counts, but can be wrong for
> reparenting once MGLRU updates the counters without the lruvec lock.
> 
> Reparenting runs after the forced stats flush, so a negative is a real
> balance that has to move to the parent, not be discarded. We will
> introduce lockless MGLRU promotion which may cause following problem:
> 
>   1. A refs CAS on a folio on the child's lruvec moves it from
>      inactive to active, and its active/inactive counter update follows
>      as a separate step.
> 
>   2. A concurrent isolation of the folio reads the folio as active,
>      debits the child's NR_ACTIVE_* by delta before CSS_DYING is visible
>      to it.
> 
>   3. The child is killed, and the two __update_lru_size() calls from
>      step 1 land on the parent: NR_INACTIVE_* -delta, then NR_ACTIVE_*
>      +delta.
> 
> The child is left with NR_ACTIVE_* -delta while the parent holds the
> matching +delta, and reparenting the child's raw value is what cancels
> the parent's credit.  However, if the child happens to hold few enough
> folios for that counter to be negative, lruvec_page_state_local() clamps
> the child's negative to zero, which drops the debit instead, so the
> parent keeps NR_ACTIVE_* overcounted by delta, and its active + inactive
> total overcounted as well, permanently: the child's local counters are
> gone once reparenting is done.
> 
> So use a raw signed helper and reparent with that.  Ordinary readers
> still keep the clamp.
> 
> Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com/
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/memcontrol.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 091401cecf39..3f551e2e3206 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -562,11 +562,10 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
>   	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
>   }
>   
> -unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
> +static long __lruvec_page_state_local(const struct lruvec *lruvec,
>   				      enum node_stat_item idx)
>   {
>   	const struct mem_cgroup_per_node *pn;
> -	long x;
>   	int i;
>   
>   	if (mem_cgroup_disabled())
> @@ -577,7 +576,14 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>   		return 0;
>   
>   	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
> -	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
> +	return READ_ONCE(pn->lruvec_stats->state_local[i]);
> +}
> +
> +unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
> +				      enum node_stat_item idx)
> +{
> +	long x = __lruvec_page_state_local(lruvec, idx);
> +
>   #ifdef CONFIG_SMP
>   	if (x < 0)
>   		x = 0;
> @@ -595,7 +601,8 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>   
>   	for_each_node(nid) {
>   		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> -		unsigned long value = lruvec_page_state_local(lruvec, idx);
> +		/* Reparent the raw value: the clamp drops the child's debit. */
> +		long value = __lruvec_page_state_local(lruvec, idx);
>   
>   		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
>   		__mod_memcg_lruvec_state(parent, nid, idx, value);
> 

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong

