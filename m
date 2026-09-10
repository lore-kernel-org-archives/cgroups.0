Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8595242D97;
	Thu, 10 Sep 2026 22:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079661; cv=none; b=mcX+pe+X91Is1J/nVEYaxrELbaoHxKH1SenSjpoVw2rJVM5P3YfBqv0LkdV7sf7HbjDR0HvmOkSaJIl1Ibho8/TyqRyNmflNisKXMuiU9E5oBL8Zz1So4Q+lTS28vgjJ/IwUy2TXWgkdG2UXX17HDXlno2MlR17EmSZyF4b+oBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079661; c=relaxed/simple;
	bh=uwe1PdcP0QTT2ihDL8pm1zi57whTBJ0qsaaxNyHDDZg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=jUm0Q2yii+adWw1B8Nlk/uqphAsGL7gDcDpmqUMl4RD1QI1OYvNrI8Hx4WuA3dl+cHKqZZRYi5+0kKQTPi4JS1BP369QrzvtsdnPyvHCmUTldZSYVIBhjALN4nTgtCWMkEzreUGOeZksW5nNDJlnb78A74QNDtEp30sgKqO2bSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mcaqD2yT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mcaqD2yT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5921F000FF;
	Thu, 10 Sep 2026 22:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789079659;
	bh=t7GGU2eTfZOysjm89mBFxoCWklcmpL9zk6i94bDBeG8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mcaqD2yT8CwlBMGZAEzwF9g1AG13LrO0OZyUCYv5NPuDFxEfmb8eKSK57i5VPTjI5
	 E8ijKCbrJSJGtxPIsvChsitXOOLKL+tLhZ7LFMD3hddl3ngo4by88iP7BQYJdqrRkC
	 VdYyy05Ln03NV2tuYLtpwQh4J4G5EbQwx3HPVzXk=
Date: Thu, 10 Sep 2026 15:34:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Michal
 =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Usama Arif <usama.arif@linux.dev>, Dave
 Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed
 <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Xunlei Pang <xlpang@linux.alibaba.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
Message-Id: <20260910153418.e818710d3c35aa075f1156ab@linux-foundation.org>
In-Reply-To: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Sep 2026 16:07:18 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> With cgroup.memory=nokmem, the THP deferred split shrinker and the
> zswap shrinker are degraded in two ways.
> 
> First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
> shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
> limit-induced reclaim of a cgroup neither splits its partially
> unmapped THPs nor writes back its zswapped pages.  v1 of this series
> [1] restored the flag to fix that.
> 
> However, as Sashiko's review of v1 pointed out [2], the flag alone
> is not enough.  __list_lru_init() also collapses every list_lru into
> per-node lists under nokmem, so even with the flag restored, the
> objects of all cgroups share one list per node: the per-memcg
> shrinker bit is only set for whichever memcg happens to repopulate
> the empty list, so pressure in other cgroups may not even trigger
> the scan, and when it does, the scan walks everyone's objects.
> 
> Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
> list_lru"), THP had fully per-memcg deferred split queues embedded
> in struct mem_cgroup, working independently of kmem accounting.
> nokmem only opts out of kernel slab accounting; THPs and zswapped
> pages are user memory and remain charged to their cgroups, so
> per-memcg reclaim is still what these shrinkers want.
> 
> This series keeps list_lrus backed by SHRINKER_NONSLAB shrinkers
> memcg aware under nokmem:

Thanks.

It seems that Sashiko still doesn't understand that memory allocations
in __init code are considered "can't fail".

	https://sashiko.dev/#/patchset/20260910080722.3961351-1-qinyuntan@linux.alibaba.com

otoh, failures in the functiond which hugepage_init() calls might be
caused by things other than ENOMEM so I guess we shouldn't zap all that
cleanup code.

Anyway, that's unrelated to your changes.

I'll save this patchset away for later and shall await reviewer input. 
Please poke me in a week or so if there hasn't been any, Things are
crazy lately.

