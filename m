Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412183546DF;
	Mon, 24 Aug 2026 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787579626; cv=none; b=g7vvMN6TX9UzfZ4icSMKSKg9akpr+/hHQ/ohM3HmLY+YGsIOG6gXEvUJr50arA+GwV/YRULtPcE6f3DWkFx9StUQOzJZnPZpTjGhNQ1TA2I2eTM8KzQorvZAnaJ3vmNMaCpATbyquzL1xmdBYMoDLXhu7fNH+diYWcZjNG2yenM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787579626; c=relaxed/simple;
	bh=/KoJeDwtEG+sf2fH9313UzT7Q1P9W5fgjGHXj76bYm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q9ooHI4amwWm8EveMIba8px/WXOcZG7HRxXdfgO517nMHDOlSZQT5olTpnZF/MI/e8XR6qj5MESCi85KA7mxqe7xNqTBo9KEyPc95Is0WeIvu1SeU34fVS4L5xIhx+EodyfpHQqBP+c0OLsj/XVBAXFoPMUTKJLosrZNbj/BYJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SUyg3bXf; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SUyg3bXf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FUkBE2bOUgu05r1cnIoJ/eYKDhYoSVkHZ2Cq/EzHFu4=; b=SUyg3bXf1+Bepe3REU0n3GZNB3
	LNrGW3BCXwKxQcDSeU1fs5lyb6bQ01L9ZEp6Yd1k6R70IUx4ArB+VCGmVgN8ufddIoH3J7H0FekqC
	kYQ5ePo6uJoSJKZAQG9iSiHgLgFigResgVyRcIKHjO9m1g4PHFLwuOHRODsuVvaEVnrKzi4jXv2yf
	wcemsWGlhSfkK/1yqbvctLKNCOH2wFhm5gZJXAW7gT+FPfYqz9dgXFqLEXq4KntOaAXQg/onkoWn3
	1rs9owGzid1ASnDEwopYC0ish2ViFFz1vlc6y7VwYFFZ+yGsR7Ul0UV/gbZS6iFsIFyaf6y6fTk1C
	bR4omHkw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wyV76-00000005FjM-297r;
	Mon, 24 Aug 2026 13:53:24 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 647CC300244; Mon, 24 Aug 2026 15:53:23 +0200 (CEST)
Date: Mon, 24 Aug 2026 15:53:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chen Yu <chen.yu@linux.dev>
Cc: Szabina Korbai <szkorbai@linux.ibm.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>, mingo@kernel.org,
	longman@redhat.com, chenridong@huaweicloud.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, jstultz@google.com,
	qyousef@layalina.io, euan@linux.ibm.com, huschle@linux.ibm.com,
	yu.c.chen@intel.com, tim.c.chen@intel.com, philip.li@intel.com
Subject: Re: [PATCH v3 0/7] sched: Flatten the pick
Message-ID: <20260824135323.GS776954@noisy.programming.kicks-ass.net>
References: <20260605105513.354837583@infradead.org>
 <fecf5eb215b4b86bec11ca47eb6b5b17f5e0fea5.camel@linux.ibm.com>
 <d690a668-7bb2-4cd1-a229-295e556d4f28@amd.com>
 <ef9f077a6faafc747b3e144400dd3f5ad10e8e0a.camel@linux.ibm.com>
 <20260818091649.GC1247881@noisy.programming.kicks-ass.net>
 <aoxah90s0bQ4tcUW@three-body>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoxah90s0bQ4tcUW@three-body>

On Mon, Aug 24, 2026 at 10:51:51PM +0800, Chen Yu wrote:
> TL;DR,
> The decision made by wake_affine_weight() seems to be affected by the increased
> weight of the wakee under concur mode. As a result, wake_affine_weight() became less
> likely to select this_cpu. This reduced preference for this_cpu leads to a higher
> L2 miss rate on this platform, and consequently lower throughput.
> 
> Test summary:
> 
> | Config | Throughput (Mbps) | **L2 miss%** | **LLC miss%** |
> | smp + WA_WEIGHT | **470249** | **19.37%** | 60.08% |
> | smp + NO_WA_WEIGHT | 305360 | 32.67% | 60.46% |
> | concur + WA_WEIGHT | 338770 | 31.45% | 62.85% |
> | concur + NO_WA_WEIGHT | 259358 | 36.24% | 61.95% |

(I'm thinking it would've been easier to read if all those '|' were
properly aligned?)

> We can see if WA_WEIGHT is disabled in smp mode, the performance drops to concur. One
> possible reason is that task_h_load(p) returns a very small value in smp mode(just the
> issue that concur wants to fix), whereas it returns a "normal" value in concur mode.
> 
> In smp mode, the extremly small value returned by task_h_load(p) can be effectively ignored
> in the comparison in wake_affine_weight(). As a result, the condition for returning this_cpu
> becomes:
> 
> cpu_load(cpu_rq(this_cpu)) * 100 < cpu_load(cpu_rq(prev_cpu) * 108
> 
> As a result, this_cpu has a higher chance of being selected in smp mode. In concur mode,
> task_h_load(p) is on par with cpu_load(), so it cannot be simply ignored and provides a fairer
> basis for choosing between this_cpu and prev_cpu. Since netperf/netserver is a sync wakeup, it
> prefers to be co-located on the same CPU/L2 domain for better L2 cache locality.

There is something wonky with task_h_load(), it isn't behaving properly.
I've not managed to put a finger on it yet. Let me continue poking at it.
