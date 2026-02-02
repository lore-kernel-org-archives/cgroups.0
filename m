Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E64035E53C;
	Mon,  2 Feb 2026 13:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770037539; cv=none; b=jT6W1ifUOGqJXcH7MwbD+lhClZR2saAL85Bquqaay+eZSLt1cktl9AL8O9kbQzYE8OFwaTzX78lF8lFGOElDbd2Omw8Iv5LtpsCHKpYluCmxJiRdDaXwldlJxibj9i4LlITK8wbjERFAKsiTJ37f9U9KXDfE5XdfBdwI2CsHLoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770037539; c=relaxed/simple;
	bh=F8crWnNiW1I5eGPcpKlPggbez0s5Ewo7AQLN4ei6+kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GijowU/UqTsYXoS0fIMrKtl6q+CbGj8s9wbyBbbr6UftcVfJQJwzOpoxOYeQxUR6RzEjX5eZfuFPtkgav5NWZ1fyd9TBA1XQzPW2aUXKgIpIuGjgc/95pCPyqvCYEB0nnwVRgpkNmwz2waYisvjhEAdRctVC269z9GUxMNzMguI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pF3ZFb+y; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pF3ZFb+y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WjzS76ZEx91D+z7A9/8sYiyzf4PTQPs3YN9XfWKCgtc=; b=pF3ZFb+yciTFja/40tXjEOuvgo
	yrElhcy7bKt/xk0cEvyTjkRke0yv5oIN5Ml7PRqiOmjxGKbkydNnuuZM7Os8SeJ6+d+2nFVPT6wpa
	SfQ53pF/16SfXLZz7KLbcKN9OKr17D3x8HDLP2Cq0fnz0g3hspkWDvqlXedI2UNRrSa942SK+/HLs
	RATTy5+7bp5yclCUCIKklffARUoMxjFG0sFUPof5fSGTz2fHE7AIjoIvoVt1VfLmAeS0yHXOZ8gjf
	MFN7vtryUH/v1T/HWsxW9q+ribGGxVggE3aVjE1OnfpPdADE7d/ey0hTWe+cryQbNlzw72yi51l0v
	6RqZmtdA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmtcN-0000000GWAx-23vt;
	Mon, 02 Feb 2026 13:05:27 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id DCC80300208; Mon, 02 Feb 2026 14:05:26 +0100 (CET)
Date: Mon, 2 Feb 2026 14:05:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <longman@redhat.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH/for-next v2 1/2] cgroup/cpuset: Defer
 housekeeping_update() call from CPU hotplug to workqueue
Message-ID: <20260202130526.GE1395266@noisy.programming.kicks-ass.net>
References: <20260130154254.1422113-1-longman@redhat.com>
 <20260130154254.1422113-2-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130154254.1422113-2-longman@redhat.com>

On Fri, Jan 30, 2026 at 10:42:53AM -0500, Waiman Long wrote:

> +/* Both cpuset_mutex and cpus_read_locked acquired */
> +static bool cpuset_locked;
> +
>  /*
>   * A flag to force sched domain rebuild at the end of an operation.
>   * It can be set in
> @@ -285,10 +288,12 @@ void cpuset_full_lock(void)
>  {
>  	cpus_read_lock();
>  	mutex_lock(&cpuset_mutex);
> +	cpuset_locked = true;
>  }
>  
>  void cpuset_full_unlock(void)
>  {
> +	cpuset_locked = false;
>  	mutex_unlock(&cpuset_mutex);
>  	cpus_read_unlock();
>  }

> @@ -1293,14 +1308,30 @@ static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
>   */
>  static void update_isolation_cpumasks(void)
>  {
> -	int ret;
> +	static DECLARE_WORK(isolcpus_work, isolcpus_workfn);
>  
>  	if (!isolated_cpus_updating)
>  		return;
>  
> -	ret = housekeeping_update(isolated_cpus);
> -	WARN_ON_ONCE(ret < 0);
> +	/*
> +	 * This function can be reached either directly from regular cpuset
> +	 * control file write (cpuset_locked) or via hotplug (cpus_write_lock
> +	 * && cpuset_mutex held). In the later case, we defer the
> +	 * housekeeping_update() call to the system_unbound_wq to avoid the
> +	 * possibility of deadlock. This also means that there will be a short
> +	 * period of time where HK_TYPE_DOMAIN housekeeping cpumask will lag
> +	 * behind isolated_cpus.
> +	 */
> +	if (!cpuset_locked) {

I agree with Chen that this is bloody terrible.

At the very least this should have:

	lockdep_assert_held(&cpuset_mutex);

But ideally you'd do patches against this and tip/locking/core that add
proper __guarded_by() annotations to this.

> +		/*
> +		 * We rely on WORK_STRUCT_PENDING_BIT to not requeue a work
> +		 * item that is still pending.
> +		 */
> +		queue_work(system_unbound_wq, &isolcpus_work);
> +		return;
> +	}
>  
> +	WARN_ON_ONCE(housekeeping_update(isolated_cpus) < 0);
>  	isolated_cpus_updating = false;
>  }
