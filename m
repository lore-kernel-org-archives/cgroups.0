Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875FC3126DF;
	Wed,  9 Sep 2026 01:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788917856; cv=none; b=NvH3u5Cy8hJKET97oznd8U1ZnjmtCnSSKJ8brulrL/BxsgzBfccjkFrZyOWkivoi/MOczomJpiQJtBb5Y0ptA7DqQzC+YbHif0mtmJNNapy35CdSWSgHRNRJAGCa+fAvZWwGwQSb2qPaAk2qxkw1OQ8g3hcuCZKb5np32yws3no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788917856; c=relaxed/simple;
	bh=1QqV2kcOuJD+VH+4fxWTChxpZO4+0Tfu+1ICn6hR7jg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=GLJtm4TqOJa+Fzc3WYTF4HpVHBPybAf6W22LbpS0Z6P87Iu6Sq+lIVcFWX33Q6dfIJr+2IRlMQUbxVv/NgnoztSSWLw19oVSM8X30Vt9ZSJK1MahvFUxUtPG0qEpWGbH7xZfsIDQeGL4g19zPIo7FPFATrEmNvaDcLz2JzWqA5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n5kLNgGa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n5kLNgGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1021F00A3A;
	Wed,  9 Sep 2026 01:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788917855;
	bh=wCl8v/e1Ribr5OQ7F4L+L+/USm7rKZv5e/AFPktfvKU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=n5kLNgGajilivzKNxr6qpSIgTRetxyb3x1+BtrqXUEygI/I48nTe9K8FN47vE6BPq
	 l8cyhTCo38RYUFtxqC0HV7fQZFi9cdyBW1Bi79JzbR5/zRai0NsGs9IfChmrGG928h
	 fo/AjnTJ+Bm2lpDcwwzrX3dydmVtfdPEu6j9I9bY=
Date: Tue, 8 Sep 2026 18:37:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu
 <zhuhui@kylinos.cn>
Subject: Re: [PATCH v4 0/4] mm: workingset: fix the shadow node budget under
 MGLRU
Message-Id: <20260908183733.ea115c9f8e6f88220d1b9b5b@linux-foundation.org>
In-Reply-To: <cover.1788837625.git.zhuhui@kylinos.cn>
References: <cover.1788837625.git.zhuhui@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  8 Sep 2026 11:41:10 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") broke the workingset shadow node budget under
> MGLRU: lruvec_lru_size() reads mz->lru_zone_size, which MGLRU never
> maintains, so count_shadow_nodes() sees the evictable LRU lists as
> empty and the shadow shrinker reclaims eviction tokens almost as fast
> as they are created, losing thrashing protection.
> 
> ...
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
>                  so it stresses exactly the fast path patch 1 changes.
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

Am I misinterpreting this?  This difference is probably within
inter-run variability?

