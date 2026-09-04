Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A139D39EF1C;
	Fri,  4 Sep 2026 09:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512754; cv=none; b=Vc/xFMx9ld/0s2C5SJiYgJtUsT2F4egDeobJ0F6EEOJUn0Dg1fB1h9nMonfxiGdqZRzCivFqTRe6nTs5PgV0qs/K4XQdkm0U8l4J15X5kqk5WWFNIXkNo64WLDkW+sgbccEeUevwLPXsP+aOEC6rsk6UjNDdOzW0GpxvtPRS+RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512754; c=relaxed/simple;
	bh=ipcHRxzW/g7VAbOv/YCHkXwa+Zj3T9xePkroGbszt7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jeug0RlJQGt5voMJbSj15iFN3A+wqerAS9FwjSCAmgqJ78ssLNWRsDFDmIzDn6Br4vaxU6uEqbWCFiPRsN5fVnFAL1roozkaHDsaA1e8D7hXtvyrvlv0MptWzJCzP8MYPYVkM0bXv5lVNdpC/gZvOP473+M8KkaRtNvSgxtp2NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lcczhL0i; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lcczhL0i"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788512742; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HvVcR1L5HLtDSGjj5QAvynuTIH/BiFENIznYFocO2Uw=;
	b=lcczhL0i1+cS3e7USBlJfyNcU6OkC6qKih29D+N0aY1oqkIfuAKlGhxK2m41aBPRzX8v0s1ZFQ4nom/Yq/oXpRZq/l3iZIWP/wA7zTyizXIcEX+77cFY8PM+bzZHzmNXOUo+snDgWcFiIkFq/rd3TV0kLfGS3fd/0RSYo5BwM3w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0XAIQHTh_1788512738;
Received: from 30.178.82.219(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAIQHTh_1788512738 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 17:05:40 +0800
Message-ID: <d40413c0-d826-4797-b768-644f38f4e5b6@linux.alibaba.com>
Date: Fri, 4 Sep 2026 17:05:36 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: memcg: settle memory.high debt after THP faults
 with non-blocking gfp
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Xunlei Pang <xlpang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Chris Down <chris@chrisdown.name>, Chuanhua Han <hanchuanhua@oppo.com>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
 <20260904035407.4098627-2-qinyuntan@linux.alibaba.com>
 <de28b6a7-7f51-4344-8139-1ec412604062@linux.alibaba.com>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <de28b6a7-7f51-4344-8139-1ec412604062@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Baolin,

On 9/4/26 2:50 PM, Baolin Wang wrote:
> 
> 
> On 9/4/26 11:54 AM, Qinyun Tan wrote:
> 
> This doesn't convince me. If the user sets defrag=defer, it means large folio allocations should not block, so using gfpflags_allow_blocking() to decide whether to call mem_cgroup_handle_over_high() is reasonable.
> 
> If you call mem_cgroup_handle_over_high() directly in the allocation functions, it would definitely increase allocation latency. This is not what we expect when setting defrag=defer.
> 
> On the other hand, I wonder if briefly exceeding memory.high is really a problem in the real products. If this is only to fix the test_memcg_high_sync selftest below, which is full of magic numbers, I don't think it makes much sense.
> 
I agree defrag expresses that the THP *allocation* should not block,
and the patch keeps the allocation path untouched.

That said, let me share a small comparison I ran, which shows what
this means for memory.high in practice.  Same kernel, one mlock(40M)
in a cgroup with memory.high=30M (no memory.max set), measuring
end-to-end mlock() time:

              no memory.high    memory.high=30M
  THP on      0.00s              2.03s
  THP off     0.01s             33.73s

With 4K pages the populate is throttled on every charge batch and
the cost scales with the overshoot -- memory.high working as
documented.  With THP, all 40M is populated unthrottled and the
entire enforcement collapses into one penalty sleep on return to
userspace, clamped at MEMCG_MAX_HIGH_DELAY_JIFFIES (2s) -- a flat
fee independent of the overshoot (a 200M mlock pays the same 2s).

So the same workload under the same memory.high gets a completely
different level of enforcement depending on the folio order of the
allocation.  That looks more like a design question than anything
else, and I'm not sure the current behavior is what we expect --
would like to hear your thoughts.

Thanks again for taking the time to review, much appreciated!

Thanks,
Qinyun Tan
