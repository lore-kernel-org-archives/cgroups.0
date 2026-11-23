Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795436576;
	b=rPTafAHGUKUhyGJgtwL8AF3mJh4gTfUyNWVGx0cT0EpgdIMlxkt4Ck6KYSwyVRqiHJ2H
	 KEjQWn8EMhrLvzk5vPZLbMv1lUM1lgZ6U8NJjwqyR/+UEPh2iQcdHkmMR3qPTrVCdxP6H
	 8DZvzLnk0wZ7qQzVuwn3YYf76dvNk5HDz7QrOeeHkAuWelLhCOwiq5GKkyMqdiZQ5VD/P
	 WxU6CgW4jYDrtCF6UvQv4FhQ3sxpkiosuzLM/GVrwcd217eGJuKgr83HrzgmLmGFkpXLG
	 WCwOf5mf74Xrw3NOEcVZr3A3QfmFEGhh25oMRJMJCMkWHwv3OQCDvQqbpFC/3IZ+uyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795436576;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=GUmWSh6uTeixFFkyYnWFbJ+QiEm7Y6IWZTbXXFJX8T4=;
	b=O59FyMCx3LpNaoqfNMSyPApP8i2zCPYEufNF1dCe2b3Gnhx0E1k0ptVDaE/noil/J/fW
	 DQUA6oUMKwYq7RSNVVR8dDe1WVGP+6+Ftard3NFjnXi+wF9j8YdWajQeQdJcPRTkzd/2O
	 hJk74g91RdZiSJHFma12biGv5Y5z0VynzY5gCFTo4Px8kPcJzFghHI3Va7X6PbssvDOPL
	 EzMGKwgBYetIYy3kBY7zQk6CIgQSkFqoQH2t1EQboFsLctQmaYMZkhnUngGV6SuJjQCD+
	 WaAaVpwiOfweyoBORGF3bBhZm1qWEiX46yFHGH0gMEoMqnDfBE6xWmcxSi6mzyHRgeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oal93E9h;
	arc=none smtp.remote-ip=91.218.175.198
Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596E0606A330
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 12:22:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 596E0606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oal93E9h
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HBiS2kYF8PVr+vkQZ7k/tuC2TvlwZKRHilWszpQnZcg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795436573; v=1; x=1796041373;
 b=oal93E9hrbrvToGf8btCaPuf8tsAauiJkAeAIN4xbW6hAPzHSIlO7tyEFJJJINeBwKyjUuzR
 Pj7j4x0zUY5oCYaN74tJN48MqYohM1lea8nWqb4tcWkksmqQMQ7uP3rGWN30XWtk4BrxD23iMvo
 Re/LM53lMMy229SlyvQKYDcw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7dd95ba535c2c3e9;
	Mon, 23 Nov 2026 12:22:53 +0000
X-Mizu-Trace-ID: 7dd95ba535c2c3e9
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
Subject: Re: [PATCH v5 1/4] mm: list_lru: index per-memcg lists by memory CSS
 ID
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261123105334.2524066-2-qinyuntan@linux.alibaba.com>
Date: Mon, 23 Nov 2026 20:22:36 +0800
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
Message-Id: <4520D630-10BD-4D66-9FDF-279A07F5A4C0@linux.dev>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
 <20261123105334.2524066-2-qinyuntan@linux.alibaba.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)



> On Nov 23, 2026, at 18:53, Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
> list_lru uses kmemcg_id, a copy of the private memcg ID, to index its
> per-memcg lists. kmemcg_id is only set when kmem accounting is enabled.
> Non-slab shrinkers need an index that also works with cgroup.memory=nokmem.
> 
> Use memcg->css.id for non-root lists. The ID stays allocated until the
> CSS is freed, so disabling and re-enabling the memory controller on the
> same cgroup gives the new CSS a distinct index while the old CSS is
> still referenced. Reserve index zero for the root, which uses the
> per-node list directly.
> 
> In list_lru_walk_node(), hold the RCU read lock across both lookups so
> the CSS ID cannot be reused between them. css_from_id() can see a CSS
> before its online callback succeeds, so check that the CSS is online
> before taking a reference. Drop the RCU read lock for the walk and
> keep the reference across restarts to recheck the same owner.
> 
> Remove kmemcg_id and reparent the lists before the objcgs on memcg
> offline, including when kmem accounting is disabled.
> 
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>

Nice cleanup.

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.

