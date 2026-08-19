Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C696F437448;
	Wed, 19 Aug 2026 09:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787131148; cv=none; b=rY23IUeYG3D4hdPhuP101EQRFLGqNVO4sx3bFKyjYnGr5zJT0kbVE1NW8//IVGn4P5RySKD3McVlpafTwoJREQ9FIBgsEkNhszc4Id7+LXP+GqoDyoTG/BpkS/zDmzZOxLFCQ+vskN8W5w5JpwPh2sHLTW5cZRoSl2TVWr3YLAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787131148; c=relaxed/simple;
	bh=iiPy2e8hJGY5e2XDsk2naZ8ySfGm2RtaOuIEJ6nlqrg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KruI5iuUR9W655bvt5rWULvXwB8YhAyrqIWUeQ5h+LWoFKdq/pXHZrbU2sjU8ClZhuYVvpGOVgI1NTcsuEMst+qqeIMgIA26SyWSh2+bIvM7ANnOBF39hl92DdnaFSFcLKJHUZomLYaPNJ4c0OCytawUE0EZKzLonihvqQWP50U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wZljpv/f; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wZljpv/f"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787131135; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UUkUEVNocOa8i2pwhU3EAXuYAIwF7UnAwk/Wn4nSKBQ=;
	b=wZljpv/fTzReYGIFfan7cw/kncZiSh5j3/979vJngITOFvKkUsTVSAQLe24b851tOCj4QG739ZEddIfsCScKUN8ghrWkAnMG+CnlzGc0bD1NoKmQYAL/oZmbWNiuq+h93idr4OmXZI8D8A4phQiUsjK83Z+vS4kOUtyH8suTAE8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X9GGcxy_1787131132;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9GGcxy_1787131132 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Aug 2026 17:18:53 +0800
Message-ID: <52215f41-9297-4197-982c-bec01b485bb7@linux.alibaba.com>
Date: Wed, 19 Aug 2026 17:18:51 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm/mglru: move max_seq read into walk_update_folio
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-4-8dbbdac0d28c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-4-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
> each read lrugen->max_seq to compute the target generation used by
> walk_update_folio(), then pass it as a parameter. Move the read into
> walk_update_folio() itself so the callers no longer need to compute
> or pass the value.
> 
> The max_seq read now happens once per folio update rather than once
> per walk range, so folios always get promoted to the current youngest
> generation.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> ---

LGTM. One nit below.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/vmscan.c | 29 ++++++++++++-----------------
>   1 file changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 080132997d87..a819be6b7ae9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3517,13 +3517,15 @@ static bool suitable_to_scan(int total, int young)
>   }
>   
>   static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
> -		struct folio *folio, int new_gen, bool dirty)
> +			      struct lruvec *lruvec, struct folio *folio, bool dirty)

IIRC, MM maintainers prefer 2 tabs, which is why I changed this earlier:)
