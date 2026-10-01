Received: from mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A353955C6
	for <cgroups@vger.kernel.org>; Thu,  1 Oct 2026 16:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790870409; cv=none; b=COA0BNYmNIFC65zCvIOXbCul1Q7SKLZm/c1IdyaWgkr7tlCjR6UZ1w9nPuoxWff7bU0BvXH5QKq0rfoxTduSV/Uv5u+TOqaQfRFFWjvIGb9F4pigW8jZTP5BUG/OaxRPHCMMTTWv1OUKQi75kjwFzLPHisRU5Vb5yzbRrMqzbyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790870409; c=relaxed/simple;
	bh=nQNXL5q4knr5P0PR//t77Jz5pY4phClaMKAM51WfU40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nIpE9n4YNiGsxboFT8on6/NpKoQfFWFxxg5ZLcMmF6awvlOEAPsm5N790lAFfxiIY4eCkD1h4r+zzldoYrbD5rt6JBgIy/BFx9XqU7R0Z8cJ3oOMuTvmRUxNo8wRxrnNg7goVweti23r/V+XHgMFpqmAhxpymrQHOTQNtty83ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rNHHQbU9; arc=none smtp.client-ip=91.218.175.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rNHHQbU9"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nQNXL5q4knr5P0PR//t77Jz5pY4phClaMKAM51WfU40=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790870405; v=1; x=1791475205;
 b=rNHHQbU91vxR2GSYZRD1G8OHlE7XnK4eYXE6kj/G7461gg/TqffcehtPKaphPynQ7RNovEEi
 CoveUSvaq9EquhgfrMD2iDMh6Tc35KUDbcREvH7wZEYXCUaW8AJMGsyqopYNdKEt1lRuoSZuEZK
 CeS6/C9UGwXkw/kW7Ywp6VLk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4267819c097ea3ea;
	Thu, 01 Oct 2026 16:00:02 +0000
X-Mizu-Trace-ID: 4267819c097ea3ea
X-Migadu-Flow: FLOW_OUT
Date: Thu, 1 Oct 2026 09:00:00 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Frederic Weisbecker <frederic@kernel.org>, Aaron Lu <ziqianlu@bytedance.com>, 
	Daniel Jordan <daniel.m.jordan@oracle.com>, Hao Lee <haolee.swjtu@gmail.com>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
Message-ID: <ar5eUZ7hibU0Bp5o@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
 <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
 <20261001121842.GJ4121620@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001121842.GJ4121620@noisy.programming.kicks-ass.net>

On Thu, Oct 01, 2026 at 02:18:42PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 01, 2026 at 12:59:09PM +0200, Peter Zijlstra wrote:
> > On Thu, Sep 24, 2026 at 10:28:10AM -1000, Tejun Heo wrote:
> > > Hello, Shakeel.
> > > 
> > > On Thu, Sep 24, 2026 at 11:47:04AM -0700, Shakeel Butt wrote:
> > > > This series lets a kernel thread say which cgroup it is working for.
> > > > That cgroup then sees the CPU time in its cpu.stat and the stalls in
> > > > its memory.pressure, and the CPU time comes out of its cpu.max quota.
> > > > The first user is the memcg reclaim that runs from high_work.
> > > 
> > > This doesn't translate to net rx, which is another major source of
> > > displaced CPU usage. Switching membership on each packet isn't going to
> > > work there. Attribution can't happen that way. We'd much rather count
> > > per-cgroup received packets and prorate the CPU consumption. If at all
> > > possible, I think it'd be better to adopt an approach which can cover
> > > both use cases.
> > 
> > Ideally RX would be split for each network queue, rather than lumped
> > into the one giant softirq that nobody owns.
> > 
> > I know PREEMPT_RT has been wanting something like that for ages. Not all
> > queues are created equal. Some might want RT priority while others
> > should definitely not.
> > 
> > Furthermore, without ingress throttling, your RX back charge could
> > completely deplete the actual cgroup time quota.
> > 
> > Anyway, if you get per queue RX processing threads, then you can move
> > them into cgroups where so desired.
> 
> Gemini is trying to tell me this exists and is called Threaded NAPI.

For the accurate cpu accounting of net rx, threaded NAPI or softirq is not
that important. I think it is steering packets of the workload/cgroup to their
dedicated queues and only newer NICs have support for hardware rx steering.

For old NICs, we will still be getting packets for different cgroups on the
same NIC queue and I think Tejun is asking for cgroup cpu accounting for this
scenario to work.

