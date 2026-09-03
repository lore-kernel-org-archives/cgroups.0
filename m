Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEACE420490
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458045; cv=none; b=aWHEq3K9ban1WeQSjz+ZaS/7CiKsredTUlgyPzA1hdlrnWygRqYX2j08rH2QhZm519M6zr1qYSzY4EEBpB3fj+HSk4VYCdZn5A0ejE+LrZXBzvXOCXVLRPQnsJlP+/RH9i9PAiDaDvlIs9P0YAm3EyNiAdcIK9eS9GEzGA6Mknk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458045; c=relaxed/simple;
	bh=/eZlZaJfS4LJcg0pLq7HbNjDhmQoWNJgwHrvMq66Eng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmq7CPZ+0I9P1B5gPUG80sQxv1xha61OAX0pFL7PwHlyAtHYM4L4NvX4zhZtl4fuNmneQbqAqG9AEnaFdY7Mx7DScKNCpgj68hArbJvzQ4jVVBhgyTlm9InfwzlIbi0Hw5cIUj6GVcgEKFPaMJuQpEq/1nd4XpTtfRUgUgMUHec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FvDTBfMB; arc=none smtp.client-ip=95.215.58.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FvDTBfMB"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/eZlZaJfS4LJcg0pLq7HbNjDhmQoWNJgwHrvMq66Eng=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788458041; v=1; x=1789062841;
 b=FvDTBfMBAPR3E5rQJesArpC1+6I2a5k3R7ke2YHpHtwqOmcgYmz3+S8/Q21YFOfvCWW2A+v7
 ij7lyzDx3AdOpXp+YqG0U2vaLjoWfuyhK9sbVPK4BBYjc79TiQG9YCesktDEbF++WvoxJQVDy+Y
 dq+PUHsXlUJBdv2FxE3y99H4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 280e3003281bdd8f;
	Thu, 03 Sep 2026 17:54:01 +0000
X-Mizu-Trace-ID: 280e3003281bdd8f
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:53:56 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2 0/3] mm: workingset: fix the shadow node budget under
 MGLRU
Message-ID: <apmz3SGJ-kH0ppAn@linux.dev>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1788169145.git.zhuhui@kylinos.cn>

On Mon, Aug 31, 2026 at 05:46:08PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") broke the workingset shadow node budget under
> MGLRU: lruvec_lru_size() reads mz->lru_zone_size, which MGLRU never
> maintains, so count_shadow_nodes() sees the evictable LRU lists as
> empty and the shadow shrinker reclaims eviction tokens almost as fast
> as they are created, losing thrashing protection.
> 
> Patch 1 switches count_shadow_nodes() back to lruvec_page_state_local(),
> which both classic LRU and MGLRU maintain.
> 
> Patch 2 addresses the reparenting race that motivated 7404bd37cfbe:
> patch 1 makes cgroup v2 read state_local as well, so extend the
> dying-memcg stat redirection (previously cgroup v1 only) to all
> hierarchies.
> 
> Patch 3 recovers the performance.  Patch 2 added an unconditional
> rcu_read_lock() to the stat update fast path; patch 3 moves the dying
> check out of the RCU read-side critical section so the lock is only
> taken on the rare dying path.
> 
> Performance testing
> ===================
> 
> The test script and the raw results are available at [1].
> 
> Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
> configuration, medians reported.  Workloads:
> 
>   w1-anon-churn: single-threaded anon fault/charge loop in a memcg
>                  (MADV_DONTNEED + re-fault, no reclaim).  Every touch
>                  is a real fault with charge and memcg stat updates,
>                  so it stresses exactly the fast path patch 2 changes.
>   w2-file-churn: file read loop under memory.high pressure
>                  (reclaim-bound, noisier).
>   w3-reparent:   reparent accounting sanity check.
> 
> w1-anon-churn (pages/s):
> 
>                  classic LRU          MGLRU
> base             4393028              4377122
> patches 1-2      4385996   (-0.2%)    4352887   (-0.6%)
> patches 1-3      4381832   (-0.3%)    4377053   (+0.0%)
> 
> w2-file-churn (MB/s):
> 
>                  classic LRU          MGLRU
> base             8277                 8226
> patches 1-2      8226      (-0.6%)    8123      (-1.3%)
> patches 1-3      8157      (-1.4%)    8294      (+0.8%)
> 
> w3-reparent passed on all kernels.
> 
> Patch 2 alone shows a small overhead, most visible under MGLRU (-0.6%
> on w1); patch 3 brings w1 back to the base level in both LRU
> configurations.  The remaining differences are within run-to-run
> noise.
> 
> [1] https://gist.github.com/teawater/32f373ec41d185d840455eb167321a5a

Thanks for running the benchmarks as well. I think we just need to order the
first patch after the second and add CC:stable to the second. We can ask Andrew
but it might be simpler for Andrew to just resend with the correct ordering.

