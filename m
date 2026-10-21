Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792546536;
	b=WbNm2Jck1wq7vR0xjJjER26chh782YfkN+doE0WWfO2O0FTtG0TF1hta6DOlvPoB8z73
	 jFpjZhWWJfdezqVRvC17H+DDnu6FgBNxzayNgDQeCa9UQTF15h/rbKuKxOvjJFrj0C5M9
	 ehkqRG9XuSE9LNUNj/oi+35d5P9QJsEi2de7GseYTI0yneVLBqT57FfglZSp7y9ke4Gn+
	 0m2JdhUYItly0LgQyues2bKDdgrZPxbik6/rU4VL16ptx7Bw5fdfmzHMl//MkzxcaZj2o
	 F89bAvdlgEvTk6ZH4BoPoz/ovj6gWv59pb6fYklMEpMc2c1Cqi+/omT7JC6bIJVywrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792546536;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2DrsebUbLp13fzrXzEa+wLSyr3pCfG+dstsywGVgOW8=;
	b=wES1izS/j0DKx7mpiAVmhUU3m8XOugC5c76aQarTA2CEnOloPIQsUf80DaSgL9UaXMRa
	 9MoBhKAImnrVc3Vo8UmZRZfqCrTC7t5Mic/kKKIcPOyHvoFwiG4VW9kBZY0o8CoNCGO49
	 kWS67hIilpHFGTZ/JupJL0q0/ByxYgfTGD3e/8g9QvGk0MMgW/72XhGGoW6XWSvaX8zh5
	 suAVRkrPm6+0wN5JalpCMzJU/DUTm3GMVDo4c8wMRyAfXlngpS8vqiWPk5clCeW0fppRz
	 xgqVBRw+zpWBfYzzWzi9ixGSQ3z3S366OEjbZwL+qS3xrGHbplDa80aD+X0m7TvWOdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uJEUkpII;
	arc=none smtp.remote-ip=95.215.58.123
Received: from mta1.migadu.com (out-123.mta1.migadu.com [95.215.58.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B031606A31B
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 01:35:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B031606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uJEUkpII
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=U4cwMEsU5qtx0w9jQC7lKQe8YciLG2ZHaqb1h0PZGWo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792546533; v=1; x=1793151333;
 b=uJEUkpII0xASAFqy+OyFz21nWdXbOvPvi06zXr7G/p7WjwYCqAgEbjhmxN5aDi6MqQfNzXEV
 1HRn1mT8xnhJBgSdHeJ20VjONagAJncpXCIKbWHS5ia8nNFOT6TQveSqergfFbO2unjJNmed1o9
 lWGx6b1iBzmzWg69aybEyxD0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6f2b2204164ec746;
	Wed, 21 Oct 2026 01:35:19 +0000
X-Mizu-Trace-ID: 6f2b2204164ec746
X-Migadu-Flow: FLOW_OUT
Date: Tue, 20 Oct 2026 18:35:16 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/memcontrol: publish null pointer before dropping
 css reference
Message-ID: <atgWux9N9a47BHE7@linux.dev>
References: <20261021010051.1529261-1-joshua.hahnjy@gmail.com>
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
In-Reply-To: <20261021010051.1529261-1-joshua.hahnjy@gmail.com>

On Tue, Oct 20, 2026 at 06:00:50PM -0700, Joshua Hahn wrote:
> struct memcg_stock_pcp hold references to cgroups that it tracks to make
> sure that the memcg never gets freed with unaccounted charges still
> living in the stock. When the cached stock goes to 0 for a memcg, its
> reference is dropped and the cached memcg pointer is set to NULL.
> 
> If that was the last reference, the css_put would free the associated
> cgroup before publishing the NULL pointer, which can be racy on 
> PREEMPT_RT. To summarize Shakeel Butt's analysis in [2],
> 
> CPU 1					CPU 2
> local_trylock() takes a per-CPU
> spinlock, which is an rcu read
> lock along with migrate_disable
> 
> drain_stock
> css_put drops the last reference
> release work is queued
> 
> kworker runs css_release_work_fn()
> call_rcu() starts grace period G
> which waits for the refill task.
> 
> <preempt>
> 					drain_all_stock
> 					is_memcg_drain_needed()
> 					enters rcu_read_lock(), but
> 					 grace period G does not wait
> 					since it started after G did
> 
> 					<prempt>
> 
> stock->cached[i] is cleared and
> unlocks. Grace period G ends,
> old is freed
> 
> 					mem_cgroup_is_descendant() reads
> 					old->css.cgroup which has just
> 					been freed.
> 
> To close this gap on PREEMPT_RT, switch the order of the referene drop
> and the publishing so that we publish the NULL pointer before dropping
> the reference. Note that this can only happen from drain_stock who can
> hold the last reference, but not on consume_stock since another
> reference will always be held. But fix this in both sites to maintain
> consistency. 
> 
> This is based on a report from Sashiko, who found this pre-existing
> issue in my page_counter_stock series [1].
> 
> [1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com
> [2] https://lore.kernel.org/all/atfMngq7nyZpt4u-@linux.dev/
> 
> Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
