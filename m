Received: from mta0.migadu.com (out-48.mta0.migadu.com [91.218.175.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568B6351C31
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 09:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786612832; cv=none; b=cY6sZhNko95di/7oz/emGPCsfyczntQvnuLb4ZY63oV+gUyKwq4r9IHugrosjt5lyblUzhByxQ/I6L2gfMNJcP29I9LNFNrgSdO3EWx25lJh4FzgmcywuGA4iChxqfqdYqMiXjMwEmYr9VnuuBg6P2smODz6N1Zj2EqO1r72TBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786612832; c=relaxed/simple;
	bh=Lo3/ZNPFnO4hYBRp4f8wYgQkvGkM9mHLpTJup77ntrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSGEK21dKobZ/W9KtTFiCoGVt9sIk6NLUlpNnMHyyjm7BM6wCvZOTLCn/VrEM/T6hcLBhqXUiZRe8diofyiNLnMe7POogWqxG8Ry9wOzb/M/J0FIqkhAYW+RYpSbDpwdR/XZdiDbjM5LZ4HBhak5Ts7MrCXtSEZBX9Jnl6T/90o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eZYcj/Cm; arc=none smtp.client-ip=91.218.175.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eZYcj/Cm"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Lo3/ZNPFnO4hYBRp4f8wYgQkvGkM9mHLpTJup77ntrA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786612828; v=1; x=1787217628;
 b=eZYcj/Cm3Uts6sgflxEfvxNLqpQP51lG5Az5InPWkeQN8Eb2YaZ/EmZtiFOxgon4GZzdVzmd
 sobDyStRHohud38SFaVZf4nIUFx+Oto3/gCr/iW5rK4mfAEnvWD+wV+VsdMZ17V4cHM2Cuegdja
 c0gQuWCfbkD8vpIS2MtwrAXc=
X-Envelope-To: cgroups@vger.kernel.org
Received: from three-body (240e:398:91:37f0:2e7e:cdf5:29fd:7e8)
	by smtp.migadu.com with ESMTPS id 17acceac5a5fa4bb;
	Thu, 13 Aug 2026 09:20:28 +0000
X-Migadu-Flow: FLOW_OUT
Date: Thu, 13 Aug 2026 17:20:08 +0800
From: Chen Yu <chen.yu@linux.dev>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Chen, Yu C" <yu.c.chen@intel.com>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v2] sched/topology: Add a cpus_read_lock to
 rebuild_sched_domains()
Message-ID: <an2MSP557dUZvzHr@three-body>
References: <20260813073855.ji2UrtVh@linutronix.de>
 <20260813074817.t8IQTgfx@linutronix.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260813074817.t8IQTgfx@linutronix.de>

On Thu, Aug 13, 2026 at 09:48:17AM +0200, Sebastian Andrzej Siewior wrote:
> 
> + CPUSET maintainer which I missed because re-used the CCs from v1.
> 
> On 2026-08-13 09:38:56 [+0200], To linux-kernel@vger.kernel.org wrote:
> > A read from /proc/sys/kernel/sched_rt_runtime_us leads to backtrace due
> > to missing cpu_hotplug_lock with CONFIG_CPUSETS=n. The callchain is
> > sched_rt_handler() -> partition_sched_domains() -> sched_cache_set() ->
> > static_key_enable_cpuslocked(&sched_cache_present).
> > 
> > sched_cache_set() itself is also invoked from sched_init_domains() which
> > is early during the boot, holding just the sched_domains_mutex_lock().
> > Here is no warning because it happens before user space is running (and
> > hotplug operations are not possible).
> > 
> > There is also sched_cache_active_set() which acquires the hotplug lock
> > before invoking any of the _cpuslocked() functions.
> > 
> > This is only a problem with CONFIG_CPUSETS=n because in the =y case the
> > other implementation of rebuild_sched_domains acquires the CPU-hotplug
> > lock.
> > 
> > Acquire CPU hotplug lock before in rebuild_sched_domains(), before
> > partition_sched_domains() is invoked for the CONFIG_CPUSETS=n case.
> > 
> > Fixes: a7660ce1590fc ("sched/cache: Fix has_multi_llcs iff at least one partition has multiple LLCs")
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu

> > ---
> > v1…v2: https://lore.kernel.org/all/20260812095800.gl06ANul@linutronix.de/
> >   - Move the lock from partition_sched_domains() to
> >     rebuild_sched_domains() in the CONFIG_CPUSETS=n since this is the
> >     only affected case. Noticed by Yu C Chen and Tim Chen.
> > 
> >  include/linux/cpuset.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> > index 65d76a38974ba..bf3999daa080a 100644
> > --- a/include/linux/cpuset.h
> > +++ b/include/linux/cpuset.h
> > @@ -273,6 +273,7 @@ static inline void dl_rebuild_rd_accounting(void)
> >  
> >  static inline void rebuild_sched_domains(void)
> >  {
> > +	guard(cpus_read_lock)();
> >  	partition_sched_domains(1, NULL, NULL);
> >  }
> >  
> > -- 
> > 2.55.0
> > 
