Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792599146;
	b=z4r86Gvo4Nq92eeNfsMKRo3gcWJdfvGGvJY7QXilWlxQ+k6LEg2/C/PVaR0LCYw0DSJV
	 zLGJ4eRCqrqIQukjVnYGmMj8X0SDZ2NS9wEcsMhAUqu3sDUo0nTYujv7OKY1pboMqvrom
	 yVsNSzhThbBYv9tHm2SsNWD5EiC6aRxK3IEGqqw1kJ6sNhakhKj6SGQ4BzHzr2qg6hMpy
	 40TiS97r5GbalwrGT7v4S/hfmGqx35+SxyzeuppLtyqxeSiasrVbPCmXQAWAsOnKbF4GS
	 sEL3cLDoUhc3MVTEEJkMESXfPbDgedQ59j7r2Fs9fTo1MNXGuEgXmCru/S08wJTDmyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792599146;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GoVehwAITRhrgajbGanUnUkbvqRYmp8dDi3iasZVBaU=;
	b=kePt4H6GGWLDECxHmWPbrVtrtKdqWVr1VYMjNa5aA2glbKGM3BAEAsIGikavSUU8Kts3
	 pLfmMkradxkPSbDbIZyuqsjS3tPs2oJ1UGEAQbY7NKCdwWJd4gX8i9E6ECFVAOmwEssRO
	 F0/26PWMqpEXpH6Pyo+k3uvR7cu8hOwbqvZzbB8LsBMe14BpYfXFuFJ148n895a8jJ1UK
	 ymgWLfwKoTdHgQlO+bEGRcFSgjlINjd7BUxuvGEDg/H7tKJ4yGwYqZcZr72oaBRVgmTRZ
	 NveQcZIh3NZ4GzhkWzAEC7M8RhVbvjnGVgZh0FJKE55J59nM4BtAwFRnKkL1NbPq6Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=91.218.175.98
Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AE9606A31E
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 16:12:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25AE9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=QBsYVKIHXnHNdGjvTGIafzE1KeV3pLi8mLpEmKZblfo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792599143; v=1; x=1793203943;
 b=dylggWgL2eO76s8PTrSlgObTWVR3Mn6SSrzgy9qF+ujgeGSRohPFBUXyOJRmpR+T8hRqajPD
 Xz5I8dTXVckEdiZE9/0gvnoKI93OodqdwrAOaCr3vj3qijiQUDaX5wo+CKsawQSEEBNzKyL40UI
 oRVvFMebZlhUlHSzkGL1Pv9M=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9724ad12acec2d11;
	Wed, 21 Oct 2026 16:12:23 +0000
X-Mizu-Trace-ID: 9724ad12acec2d11
X-Migadu-Flow: FLOW_OUT
Date: Wed, 21 Oct 2026 09:12:21 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1] memcg: fix cacheline contention between lruvec stat
 updates and LRU lists
Message-ID: <atjhiAxEyoP48e0X@linux.dev>
References: <20261020200730.250189-1-joannelkoong@gmail.com>
 <atfrhsr6bft4t7SI@linux.dev>
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
In-Reply-To: <atfrhsr6bft4t7SI@linux.dev>

On Tue, Oct 20, 2026 at 03:35:59PM -0700, Shakeel Butt wrote:
> On Tue, Oct 20, 2026 at 01:07:30PM -0700, Joanne Koong wrote:
> > Every memcg lruvec (per-node) stat update reads the memcg and
> > lruvec_stats_percpu pointers in the first 64 bytes of struct
> > mem_cgroup_per_node, and the ones that go through mod_lruvec_state()
> > (such as lruvec_stat_mod_folio()) also read lruvec->pgdat. These updates
> > are extremely frequent (eg these updates happen several times for every
> > page that's faulted in, freed, dirtied, or written back).
> > 
> > The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
> > on a different cacheline from the lruvec, but on CPUs that do spatial
> > prefetching [1] (which is most Intel CPUs / modern CPUs), cachelines are
> > fetched in 128-byte aligned pairs. Depending on where struct
> > mem_cgroup_per_node lands in its slab, that cacheline can be paired with
> > the cacheline holding the LRU list heads, and the lruvec->pgdat
> > cacheline with the one holding lru_lock.
> > 
> > When this happens, every stat update also pulls in a copy of the LRU
> > list heads and lru_lock cachelines, which are written to constantly by
> > other CPUs under the lru_lock. The stat update has to fetch them from
> > another CPU, which is unnecessary overhead since the stat update doesn't
> > use the LRU list heads or lru_lock at all. But even worse, the lru_lock
> > holder then has to invalidate those copies and wait for the
> > acknowledgements to come back before it can do its next write, which
> > makes the lru_lock critical section longer for everyone waiting on the
> > lock.
> 
> Can you please reproduce on a non-intel machine?
> 
> Second, can you try the following patch instead of your on the intel
> machine?

I see there is also removal of access of lruvec->pgdat from stats update
function. Let's break up the patch into two. One will remove lruvec->pgdat
access and the other one rearrange the fields in mem_cgroup_per_node (I prefer
rearraging than removing the lruvec stat pointer).

