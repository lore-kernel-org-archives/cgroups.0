Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BDC2F7F01;
	Thu, 27 Aug 2026 07:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787816053; cv=none; b=uscsvGcpBDeJEekjRix5N+SoGwECSElnt5HSuxp54BtDBwE9k3LfJ30/7nn49vOg1Ds8gl5DryERz73KezCJWhnA9S/2jhUdmui0aor0P5nRFL4TFfFOeYsQr2UF5MAzanwe2hr52CR1zvDl0s/VtcGmsYP3ov9I3+THj055usE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787816053; c=relaxed/simple;
	bh=8drfNVrDp2nQo61aX/ZOU95S40WClBnOjTh3U+prARI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iin5RyzBQmrqs9LRAuvIpRWRUrzQHdPodfZ5Iqj/0n3xkL7Au+vnzqAlMzJB9gMvjF1lHXfyqgERYWRWTZPv347qsyyuW5lG784JO65bdCoFbc7uI2TqTSmhNgWexFBlGobBqu21NYOJdYPOMnfmmSapybVDl+dI/XC9G/dyUWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EulLblZo; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EulLblZo"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787816040; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0D4/pZY+ymvH1WHGZfWDEIPydoo5F42QzbhSUiRWkQE=;
	b=EulLblZo0jAHikegzBOQR+R7qnuVgufV255MfynYDLlDDe2cMjrxbk5oZdLLbrabv663mz9RQAJs17mPGfFzJ9Wff2XTqcVVC7duvlC8HFOLXSlkoMBRstRv/hrwmIN5kDLC027LzDAWpiQDEj9PPoqEG2I4+Ryel6+OT7Z3XAM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X9j1CkR_1787816037;
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9j1CkR_1787816037 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 15:33:58 +0800
Message-ID: <c8406629-0bb0-4f79-a015-70e39037b8e1@linux.alibaba.com>
Date: Thu, 27 Aug 2026 15:33:57 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm/migrate: copy all referenced state via
 folio_migrate_lru_refs
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/26/26 1:53 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> folio_migrate_flags() copies PG_referenced separately from the MGLRU
> refs counter, which folio_migrate_refs() transfers. Yet under MGLRU,
> PG_referenced and the refs counter bits together describe the
> referenced status of a folio.
> 
> Consolidate the two: rename folio_migrate_refs() to
> folio_migrate_lru_refs() and let it copy the complete referenced
> status, i.e., the MGLRU refs count including PG_referenced, or just
> PG_referenced for the active/inactive LRU. Drop the open-coded
> PG_referenced copy so the referenced status is transferred in one
> place. No behavior change is intended: under the active/inactive LRU
> the extra bits are unused, so operating on them is a noop.
> 
> Transfer the reference state first, before the destination folio is
> marked uptodate, so a concurrent lockless reader cannot have its
> reference update overwritten by the copy.
> 
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
