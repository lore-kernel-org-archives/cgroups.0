Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.235
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795436657;
	b=fGOy/Sj9HQ3OFy2aLwIHni6YPg0jCgzDDzTg2AqWX8vkm5h8+VOFXK3q+wwPs0GJ5CzB
	 cfSAKg1ljDswCao3n6bGJmMNcFbbyeQbpoZk1fzV6C2Sk3SEnzXs//cTKEN+JqQ+vie8+
	 AMP3mul7K0zi0fCWjzmGmLe5HmsFvnmNZTs1j2CW20GH+37bnHSo74AGi1It1X/WOZi8+
	 u6WUaP8aOpChPP61/ksT5K25LMNh4wWRsHK/bc0BmyHvKYkfE+etpnO42RZANtFPedEsG
	 lv8z4MinxsLIiB5YMMAMFc3l4fiOt0MKSD4KLYKXMZ7+qy3wJg9QDFBXgSuW38WdiLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795436657;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=C2y8a/aJsfWDdsgIUvnM1WLiUvisiUU/U1gufkqx14Q=;
	b=kG2jnFUmpXPCn2LhOLB5KSvuzgWOjJhSh7iZ9au/uJ1Hd8Xym9HNYWxnnF5Ooq5cIESb
	 38jn4cjg+P+Ott/RNQaRHVI49DPN50pAzIWh5XG/iTOM0LrtKig9+BsJiuWEUap9huhED
	 vvIbDbPxrA4H7PHoVCHMfMAxlcQQSY10sKL528b9C/6gbZHobdZ+bVUXILCaR38PFPlHN
	 f3j1Tkr4Jyr0VYw3zulicdp1hQMmY6r5Vhqcwf/vyf3irdbhcyvWZBfMiNOUNU4T1CObo
	 XIZ5v3Ku3Go/uyLZXV/6aJyw2KQwsc4pG43G5NA+t+tbOVc/HzZzCgF+bAiBbQJxevA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iBLogXYw;
	arc=none smtp.remote-ip=91.218.175.235
Received: from mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3443606A327
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 12:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3443606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iBLogXYw
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ckKSZhwUn7LT+lpCjWursw7EjXIKhQt9XVV2CuTg7pQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795436654; v=1; x=1796041454;
 b=iBLogXYweSyIf7ypQdnNycaGhQkgtwLwNEhirezZkoJD2DDj8FBIWjc4SCMhjXQqf/iMhgWT
 kCgkOtMBsLdRO8AiXqmuZffu4GjR/QZiehGNXgTlkybdY3H6LqI4OeqpB8X7rAAgWmkBExs0AUu
 56zBGNpGcBEC9RdhtCwWsupw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9061a3063b574a26;
	Mon, 23 Nov 2026 12:24:13 +0000
X-Mizu-Trace-ID: 9061a3063b574a26
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v5 2/4] mm: list_lru: keep per-memcg lists with nokmem for
 NONSLAB-backed lrus
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261123105334.2524066-3-qinyuntan@linux.alibaba.com>
Date: Mon, 23 Nov 2026 20:23:54 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 akpm@linux-foundation.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 mhocko@kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 mkoutny@suse.com,
 David Hildenbrand <david@kernel.org>,
 ziy@nvidia.com,
 baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev,
 david@fromorbit.com,
 Qi Zheng <qi.zheng@linux.dev>,
 yosry@kernel.org,
 nphamcs@gmail.com,
 chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com,
 Kairui Song <ryncsn@gmail.com>,
 gourry@gourry.net,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4AA82151-066C-48E4-BFD2-99F03F043BC9@linux.dev>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
 <20261123105334.2524066-3-qinyuntan@linux.alibaba.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)



> On Nov 23, 2026, at 18:53, Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
> With cgroup.memory=nokmem, __list_lru_init() collapses every list_lru
> into per-node lists.  That is fine for slab objects, which are not
> charged per memcg without kmem accounting.  But a lru backed by a
> SHRINKER_NONSLAB shrinker, e.g. the THP deferred split queue or the
> zswap entries, holds user memory, which is charged regardless of
> nokmem.  Collapsing such an lru loses the per-memcg view of its
> objects.  Reclaim can no longer target just the cgroup under pressure.
> 
> Keep such lrus memcg aware under nokmem when their backing shrinker is
> registered SHRINKER_NONSLAB.
> 
> This leaves the savings of nokmem intact: slab-backed lrus (e.g. the
> superblock dentry/inode lrus) still fall back to the per-node lists,
> and the per-memcg lists are allocated only when a memcg actually holds
> such objects.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>


