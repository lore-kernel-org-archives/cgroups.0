Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08B33DB325
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 20:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785185359; cv=none; b=XacaTSSHGUBJhRdAcz6tseCSUW8v+rvTV1PSBdp1yAlm6mI2rz2vvhs5ynqPdOfFl/OoCG9ikzMjKsvoDTO5Cy7HdaFUA09BP9OYYWpT+E8xc5N3/aUlT2FnV7/fNsmxuQLtzFxahOeNrFz+R4VcIWvCyAUCWG1BVhNNgMsM0I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785185359; c=relaxed/simple;
	bh=wQXEPIFUBWXynVGrnaYEE4WP4cs09MsZYHtKqFIJKWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NrwVhBkjsf3sprZBUMQI1bg0eFjAPwvveatPvZ3YaA/OJ1yXf1WsV7VBT76BzCumNgQ/1jtx54KRcCfdhOywb3EdcC2pQrcTQtcDYPmrGkzCNxtpp7Q4IzUUNA1Zg5IWiEPNQbgdTL53xZAiI1ORYCcs7dfJ+N1kdRCoj62TCyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oFDB5P8n; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oFDB5P8n"
Date: Mon, 27 Jul 2026 13:48:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785185344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFvaZkohkm528INkbN+EO7pcO2PxXj1dIjGSZDzFMIg=;
	b=oFDB5P8n2pxOC9LeWJdqJfFQi0V+c/ConSiq6qsRnZqmzeEf4tmIRQU6+h264HoTbcAESP
	JH6T+IX8GwIpDwVJGCjZWMThhb13j4eD5V5MvQBTIXkee1+lh62bvAeV6NYlHP2ij1hc5g
	TfJmYfDldJRhnmE7pa1n2zDLdm9QByM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Nhat Pham <nphamcs@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <ame7Q-0eVRrtt34j@linux.dev>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amd6N4DVzZkl90cs@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 08:38:37AM -0700, Shakeel Butt wrote:
> On Mon, Jul 27, 2026 at 04:36:23PM +0200, Michal Hocko wrote:
> > On Wed 22-07-26 17:19:07, Shakeel Butt wrote:

[...]

> > 
> > TBH I am not entirely happy about this approach. It effectivelly reverts
> > a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
> > It just makes it lockless. Assumption that a dying task will do so
> > quickly and with bounded resources has turned wrong on several
> > occasions.
> 
> That's why I kept it as RFC :)
> 
> > 
> > On the other hand I do undestand the contention issues and I can imagine
> > that the existing solution doesn't really work well for huge thread
> > groups that all end up lining up on the oom_lock just to learn there is
> > nothing really killable anymore because they are the oom victim...
> > 
> > Would it be just safer to bail out only for oom victim threads. This
> > would narrow down potential runaways for oom victims which should be
> > more limited than any killed/exiting task. It would also give the oom
> > killer/reaper chance to work. WDYT?
> 
> I will give the following patch a try with the reproducer I have. I am still
> improving the reproducer as I am still not able to recreate multi hour slowdown
> yet. I will report back once I have some results. 
> 

I have some results with the reproducer I (AI) wrote.

Setup: 20k threads, each with its robust_list head on its own page in a
large anon region pushed into a zswap pool (writeback off, so it's
unreclaimable and pins the memcg at the limit). On the OOM-group-kill
every thread faults that page in futex_cleanup() -> do_swap_page() ->
swapin charge -> memcg OOM. A separate thread holds mmap_lock for write
in a loop so the oom_reaper can't reap the pool -- matching the host,
where the reaper was blocked and the memcg never fell below the limit.

I tested on next-20260726 as baseline and then tested your suggestion over it.
For baseline ~48k no-victim OOM invocations serialized on oom_lock; ~40s to
drain the 20k threads in a VM (hours on the host, where each invocation
was a dump_header over netconsole). With the patch the dying tasks stop
entering out_of_memory and the storm is gone.

With the following suggestion, the threads of dying tasks stop entering
out_of_memory but the exit time doubled as each thread has to decompress the
page from zswap.

	if (tsk_is_oom_victim(current))
		goto force;

I also tested by replacing goto force with goto nomem and the exit time halved
i.e. ~20 seconds. Looking deeper it seems like each thread is still going
through the reclaim loops.

Just for testing purpose I moved this check along with goto nomem just before
the reclaim fuction i.e. try_to_free_mem_cgroup_pages() and the exit time falls
below 1 second. I think what we need is to detect early that the cgroup is
unreclaimable and the threads of exiting/reaped process should just return with
enomem.
