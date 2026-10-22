Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.205
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792703875;
	b=Zn+fse1hsSWkh7eraPg5Ay9aD87wHC2l9cRoUTYf7FfPsD9U6I90sJ+ntMtSgTY1uVcH
	 sduHdsH+2kd07sfayptRLr+fQEUU4sxHU72/89USmKOIG2IR22J65GBQGZXchQjOwIWFF
	 dvF23Mw7D3s5KoeX2NCo0HCIFWdi+oeJhRyeHcL8dpyvnvAlhddno8bpMO3SVEJdFSGTY
	 kRLHKe3mAcAeQsGVgAqMj1lzcFVk3U4zqBCqe2oCaBV41CWQYwg8O9QHEgDvRZMu7pZPY
	 D/wH+gqMARCyNe0N5FE5QwilmytOfZBRjQb9n489du/rKcTiybnd5Gk7ghujywjhiIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792703875;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=tCGGzZyU61kJ6IDawbKZzEOK2Mn7ancoajfi8twfHqg=;
	b=XE99L85xwsh7jWowprlaVwVzc31z6AMlbr6MkqBcC1ZIYpPWApR5mUmPKFcWObUvki5+
	 HjpPCk94TVzZZnmmfM/Wfns/6vYvh3qVFrO4c4F180b+QT6+iTNCZr6E8fCThadCF0+G1
	 Yx0cJAE1byEH5wBd63pD1kVqDZXma2shBtui2ZRZhGVaHOA2wvoVv161zWjFW+rBmrM1K
	 mma1bnY1sEH4mGZ4t2qWk6URWXfK0cae91Cpa4ewtjD1TB5WEAgXESKHQlGj0JiVdLPCI
	 U6AUPFsZ2V5mLKXF6yUyCU/oJ3krPPwPYI5hiiluZONL+6LFXkavyVO55aMosnzW4Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wrrawjN4;
	arc=none smtp.remote-ip=95.215.58.205
Received: from mta1.migadu.com (out-205.mta1.migadu.com [95.215.58.205])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5A3606A31B
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 21:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC5A3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wrrawjN4
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=h0J8OgpZrOv3Sfgzgz7uTRPJyJ8BCDfUJCwW+8yZSG0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792703871; v=1; x=1793308671;
 b=wrrawjN44aodaSGm07ZrQDkU52fkNTAPfuDARmJ2fz01DGuv7GMM5RSk4RTU3iqqf8v72P6K
 Jmc0uFnIuEtP0VIvCZHnGZo5WvwQFD//A4klg5kClMuOOvTw+rG9yP8mDbtSHyW/eZVHTQZLpGD
 SR6CSObUb4aQXTQX+7FSK8gg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 76616d6bd444bd51;
	Thu, 22 Oct 2026 21:17:51 +0000
X-Mizu-Trace-ID: 76616d6bd444bd51
X-Migadu-Flow: FLOW_OUT
Date: Thu, 22 Oct 2026 14:17:45 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, yosry@kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1] mm: move LRU size stat updates out of lru_lock in
 folio batches
Message-ID: <atp7tN-UfEAu3wdk@linux.dev>
References: <20261022200313.2354350-1-joannelkoong@gmail.com>
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
In-Reply-To: <20261022200313.2354350-1-joannelkoong@gmail.com>

On Thu, Oct 22, 2026 at 01:03:13PM -0700, Joanne Koong wrote:
> folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
> once per batch, but they update the node and memcg lruvec stats for
> every folio in the batch while holding the lock. Only the LRU lists and
> the memcg lru_zone_size need lru_lock. Updating the stats while holding
> the lru_lock is unnecessary, and they make up a large part of the
> critical section, as seen in [1]. 

Can you please add a tldr from [1] here? Too much text in that link.

> With many threads faulting and freeing
> memory in a single memcg, about half of all cycles are spent waiting for
> lru_lock, and the hold time of the lru_lock directly limits throughput.

Do you have perf profile showing this? Mainly I want to know where in stats
update we are spending the CPU most.

I wonder if we can find a lower bound here by removing the stats update
altogether in this code path (just for experimentation) and measure the
throughput we get.

> 
> Accumulate the stat changes per LRU list while holding the lock instead,
> and only apply them after dropping the lock (while still inside
> the RCU read section that keeps the lruvec's memcg alive). This moves
> the stat updates out of the lru_lock critical section and turns the
> per-folio updates into at most one update per LRU list per batch.
> 
> The batch is attached to the lruvec while lru_lock is held so that the
> LRU add/del helpers don't need to pass it down. To keep struct lruvec
> from growing, cost_lock is moved into the hole after lru_lock, which
> leaves room for the batch pointer in the same cacheline as lru_lock.
> 
> The stats can now lag behind the LRU lists by one batch, which is well
> within the per-cpu batching they already have.
> 
> On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
> CPUs repeatedly faulting in and freeing memory in a single memcg,
> average pages per second over 7 freshly created memcgs per run, 2 boots
> each:
> 
>                      before    after
>   shmem, 20 threads  4.74M     5.47M   (+15%)
>   shmem, 80 threads  7.94M    10.33M   (+30%)
>   anon,  20 threads  3.04M     3.35M   (+10%)
>   anon,  80 threads  3.23M     3.41M   (+5%)
> 
> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
> An alternative that avoids adding the lru_size_batch pointer to the lruvec
> struct is to pass the batch down explicitly, but the plumbing for this is a
> bit ugly (and doesn't cover mglru paths). The code looks like [2]. Happy to go
> with this if that is preferred.

Do you expect there might be opportunity to batch the stats other than LRU stats
you batched in this patch? If there is then I think we should at least explore
if a more general stat batching can be done.

This code looks good though.
