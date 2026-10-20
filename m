Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.26
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792531287;
	b=lQLMXQ0gXhu2uO5WjigSsu3Sd1M1+ITbzLJb1GyKsh3NRsgEvDVXiXK3ynXIRtWHiWCj
	 /7jf2SM8oTIOerX+sQ/8aLm1T600kpgV4LDXda4hPt7e+T2L9QonGh3MAr9bfqlJGbDsz
	 CPIfYV/4yx2DjnTm9/3usv5jsMcUPz2di04SmseAVVC2n9b0RvZdyVbLnJU+/sppvDpZy
	 R4mrQ/1Otb4dY1KMwTjITD37ITIJyOdSONTDimR0kVwC4tpwrADONs3m4syODb1W0tvgo
	 K6WRM6gXMCMi/pp75t2B8k0/3z1S+LX50ty8rUBdvkkol5Tx1I34k2YhvgpuAMRbfKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792531287;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=kfPFN6p3dzzyhZDI8mEIySVXtBWL1/DWlxavyXB3fN4=;
	b=U979/U+pNZ4SI8qspfqo0doIHz5JmqLJkpQ4zYf3COTPCcoFsKa2sWC0+KuF0r0H7x2E
	 3Qh1YDJh0z/0RXbvRq3hq5Z/bPAxKbLEd+HZyFtJnytMvjsRPEqZgNMswZ+ozQ7Awx0Ke
	 10BXgdO2O/lcZYgfG2l3o3qSrXy9u8YpPCLMh328IxqAOn5IJonYAqRdHCDsgtHd2cxiT
	 kdYqN04VI4OxPWdQV8KepDT1FmZuf7nTg6yIKv6h5BMcH6IXYCFEfnl4sbGW1EdbeOKVi
	 5g4pSAvyrhYQgpY5mlSpq/PIze+ojWDP1Oz4Ulh9JquYbDil1WQujlnCH8kPcFEOLXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=evLX7g7p;
	arc=none smtp.remote-ip=91.218.175.26
Received: from mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F015F606A31D
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 21:21:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F015F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=evLX7g7p
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XQAWskVKn7U7xT+2zsWfc+G6Pi9IJ2IbzAXQD5zOloc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792531283; v=1; x=1793136083;
 b=evLX7g7pVPpCVP6R/sCEfJSjsP25ftzprt/nwJJYw5GG+vYMZ9ce6hIm6VDHJ5yaGkh2iuyZ
 68JdfilehvAXJsdFoMf3PKq9ip5bW7+Cqdx4AukYcpWz13NTekhMxEC06CNpCXiAB3zkXBMF7AZ
 Sbu3kX0k+JVYsupwIzvUqJ7Q=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bdf38585b1173da1;
	Tue, 20 Oct 2026 21:21:23 +0000
X-Mizu-Trace-ID: bdf38585b1173da1
X-Migadu-Flow: FLOW_OUT
Date: Tue, 20 Oct 2026 14:21:22 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: publish null pointer before dropping css
 reference
Message-ID: <atfMngq7nyZpt4u-@linux.dev>
References: <20261020190336.3754557-1-joshua.hahnjy@gmail.com>
 <20261020193531.181318-1-joshua.hahnjy@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261020193531.181318-1-joshua.hahnjy@gmail.com>

On Tue, Oct 20, 2026 at 12:35:31PM -0700, Joshua Hahn wrote:
> On Tue, 20 Oct 2026 12:03:38 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 

[...]

> > 
> > So for drain_local_memcg_stock I agree, since FLUSHING_CACHED_CHARGE
> > is set, so you can't have it concurrent with drain_all_stock since it
> > will skip that stock. But refill_stock also calls drain_stock when
> > it evicts the slot but the flag isn't set, so is_memcg_drain_needed
> > can read it at the same time.
> > 
> > What do you think I should do? I think reordering makes the intent more
> > obvious and maybe it's just me but I did find it a bit misleading at
> > first that we were dropping the reference and then publishing. 
> 
> Oh and just for clarification, my page_counter_stock series actually
> gets rid of this codepath and switches the order when moving it anyways.

Yes but this patch has fixes and might get backported, so we need to be use it
is fixing an issue which is real.

Let's try to reason how the race can happen between is_memcg_drain_needed and
drain_stock:

CPU 1						CPU 2

drain_stock
  WRITE_ONCE(stock->nr_pages[i], 0);		is_memcg_drain_needed
  css_put(&old->css);
  /* assume full grace period */
  						  rcu_read_lock()
  						  memcg = READ_ONCE(stock->cached[i]);
  						  if(READ_ONCE(stock->nr_pages[i])
  							mem_cgroup_is_descendant(memcg);

  WRITE_ONCE(stock->cached[i], NULL);


Do you think there is possible race condition in above? I couldn't see.

However I ran this through AI and it has convinced me that on PREEMPT_RT, this
is indeed racy access.

AI reasoning:
-------------

How it breaks on PREEMPT_RT

On RT, local_trylock() takes a per-CPU spinlock_t (an rtmutex). That is
rcu_read_lock() plus migrate_disable(), but the task can still be preempted
inside it.

1. CPU A, refill_stock(X): there is no free slot, so it calls drain_stock(i) on
   old. It sets nr_pages[i] = 0, then css_put(old) drops the last reference and
   queues the release work on CPU A.
2. The refill task is preempted (by a tick or a threaded IRQ) before it clears
   cached[i]. CPU A's kworker runs css_release_work_fn(), which calls call_rcu(),
   and grace period G starts. G will wait for the refill task, because that task is
   inside an RCU reader.
3. CPU B, drain_all_stock() → is_memcg_drain_needed(): B has already passed a
   quiescent state for G. It enters rcu_read_lock() and loads cached[i] == old. G
   does not wait for this reader, because it started after G did.
4. B is preempted right after that load (RT readers can be preempted).
5. A resumes. It clears cached[i], puts X in slot i with a non-zero nr_pages[i],
   and unlocks. G ends, and old is freed.
6. B resumes. It reads X's non-zero count and calls
   mem_cgroup_is_descendant(old, root). That reads old->css.cgroup from freed
   memory.

