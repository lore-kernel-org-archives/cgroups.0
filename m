Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795507639;
	b=yHcMvjSjxSq2JM4NcfDfVYDg21jMwSmQRVXGpY18TmAJwWU7mtdjTyOJtHeUKgPj3+CB
	 Z6vmIUIN4R9HAhze5ccJ60zetc0qOkQdKEh3PbddJbgedjB9IqgbeKmIoG0osnt3F3hyU
	 VVnI8/YzfikW88uUPjyc+UhA12BuKZxUMNe7W4pSQG34MMzBJWidOHcpsoejNLowKD3TB
	 LsH6NT+nH75H/ZGY5bjt7gNw9WyEXy81retKm8Guwt7M8oEw4ZgJgUS3TOppwuimA5QEI
	 qsxckJq1pBtWK8PwcwgkYMnmoMy+h0I0m/hcg3Cou6rN1QnqTAM3gN83p8LiZozn+Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795507639;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=67vHNWv5XydQCuOWzXnOZHfUdZ5hbczxGbSf1cnDCr4=;
	b=kZTKEGSijNv5eAVeETcWrKcakYW8OYV9XoTuWIGVeAKKWMa2orATVB2pt8kPbRpwFgDh
	 dRLrcPTLah6q0E/4LSGIwMLB0jo1odiPehUPIwu8QJUzuheNWd2ZZzgLB8DCl+4HepRr6
	 5y8Ar1LdmN+5VMPYpbLJxn6JyM+ERiaHxmB5k8DEyMlcKAE7qoIYLJR9P5L/DJGQj7RBx
	 GBP7R1fNPf+HnFK2DgAhpnF5L0NxB1w+nJ7XA6b8GimgQssm0uLD6dvgRRThghWaOKeGX
	 FJblNc6DCDdB09LbCn3p2mGSYV/Gab66ojhiH46SyNMcYLsMuwns/gLBQDctFdJy81w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="o2RDp/6v";
	arc=none smtp.remote-ip=91.218.175.24
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9A2606A322
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 08:07:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB9A2606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o2RDp/6v
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cXjzmosgBA+4GsZx1vbHqYGDv5GQy8T2isKKaaoWxSA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795507636; v=1; x=1796112436;
 b=o2RDp/6vMg9dCJBd5K2vR8eLitzzwzQsZDVVPHNmFoYF2Lfb/nrlf0VUI0ykkQ0WngAdDoRG
 8Rk+UxvIJpJJFYUl9aT2M4DYvVIifQBY/hdVB4zDZuO3jTen+ugwVpl0I5+D0m2T+swd7IbAjCI
 EHDWmnIJjgR6fYcBtwcgQzhE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e41294f2a3451cd8;
	Tue, 24 Nov 2026 08:07:16 +0000
X-Mizu-Trace-ID: e41294f2a3451cd8
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 00:07:11 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Runli <mingyu.he@shopee.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, littleswimmingwhale@gmail.com
Subject: Re: [PATCH v3] mm/bpf: Always flush memcg stats when explicitly
 requested
Message-ID: <20261124080629.GA564737@shakeel.butt@linux.dev>
References: <20261112041348.66915-1-mingyu.he@shopee.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112041348.66915-1-mingyu.he@shopee.com>

On Thu, Nov 12, 2026 at 12:13:48PM +0800, Runli wrote:
> memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
> the flush threshold. A concurrent flush can leave an ancestor below the
> threshold, so the early exit prevents it from receiving further updates.
> 
> Consider root and leaf on a 4-CPU system, with a threshold of 256.
> CPU 0 is flushing another CPU's stats after CPU 1's stats have already
> been flushed. The counts below are shared stats_updates counters:
> 
>   CPU 0 (root flush)                CPU 1 (leaf updates)
>   ------------------               --------------------
>   clear leaf->stats_updates
>                                    add 64 to leaf and root
>   clear root->stats_updates
>   finish flush
>                                    leaf = 64, root = 0
>                                    4 more batches of 64:
>                                      leaf = 320, root = 256
>                                    next update:
>                                      leaf > threshold
>                                      break; root is not updated
> 
> Root remains at the threshold, which is insufficient to trigger a flush,
> while further leaf updates keep taking the early exit. The periodic
> forced flush restores progress, but until then the root's aggregated
> statistics can fall far behind. For example, page cache grows at rate of
> 1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
> the actual usage.
> 
> Make bpf_mem_cgroup_flush_stats() force a flush without waiting for the
> periodic flusher, while preserving the memcg flush bookkeeping.
> 
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Link: https://lore.kernel.org/all/avKy9oMwDRjKjfzm@linux.dev/
> Signed-off-by: Runli <mingyu.he@shopee.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
