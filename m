Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E6F2EA731;
	Mon,  2 Feb 2026 20:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770065298; cv=none; b=Uly8uLNEG0ooiR/dMrE4irSrEUf4beFTHdDQ1jT4H5UaZyrBRXHOtuRny0zjtcZ+KALMOmFZI2NGPsgWeghfASiY5J6CkFGWqo1jZOIchQixfdg9s6sGFHNH46GKSpmXyBisGTRiFKhgjgARl97mD06nQvyrzZewDv+hqIyZ5HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770065298; c=relaxed/simple;
	bh=FcILvlT/I9R5y6ytmnV/QqDzufRt/2TbUBNE3Fob4FU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soYkYiMc4PyppjCUr5uxjcLDWNFgTTt6SmvD0SwfG0dGacLQXxnYilAAURv1D8i7ljqDP1IQOdNdcew9+YdGY0B5rNrWP028qi5w/EXO1D55gC8VrWqjCbvrWgAajHqBWnEsHquAIcSPEtR5re4rdGHikn0vP0+mDWtax07aB1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b5xO/Agg; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b5xO/Agg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T1jq08TNdoCYYlZhkL7hgE4KpY/81wnO/NYZMkq8nno=; b=b5xO/AggIz4cnWcFe/H43k0C8/
	kYR4OrnYMbdIYFG5CGl/wOwRhDYWYgWoUz0/0una2PAhwGuozVJFH+4sjMQdEysY0q0DLIiyLZWhE
	Q53/xembNg/zeBExRngb2RYEoyJy5tStLLaPHpaHAbxYPi++aYgiur9c3t4x60EDOAWA/G9wIQ402
	ClIt0waJSeSAcvA6oVslZScFAlyzVCUyT0NnjhizenhuzXVR8Omql5hxNyqCItz2K2/8Tw3ZOdWhB
	mLyhoo1SilzhGLZt0jB6HlvCWRzJNx0Bv+5eMsSzAZ1wmSRT0355CQLdz62DseOfeeiUtnH3Kpmyn
	5ZaeLQtQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vn0q7-0000000H2xD-2CxZ;
	Mon, 02 Feb 2026 20:48:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8E6FF3008E2; Mon, 02 Feb 2026 21:48:06 +0100 (CET)
Date: Mon, 2 Feb 2026 21:48:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <llong@redhat.com>
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
Subject: Re: [PATCH/for-next v3 2/3] cgroup/cpuset: Defer
 housekeeping_update() calls from CPU hotplug to workqueue
Message-ID: <20260202204806.GL1395266@noisy.programming.kicks-ass.net>
References: <20260202201144.1669260-1-longman@redhat.com>
 <20260202201144.1669260-3-longman@redhat.com>
 <20260202201844.GJ1395266@noisy.programming.kicks-ass.net>
 <a503d890-0c83-4741-b622-88798016787c@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a503d890-0c83-4741-b622-88798016787c@redhat.com>

On Mon, Feb 02, 2026 at 03:32:03PM -0500, Waiman Long wrote:
> On 2/2/26 3:18 PM, Peter Zijlstra wrote:
> > On Mon, Feb 02, 2026 at 03:11:43PM -0500, Waiman Long wrote:
> > 
> > > @@ -1310,14 +1321,34 @@ static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
> > >    */
> > >   static void update_isolation_cpumasks(void)
> > >   {
> > > -	int ret;
> > > +	static DECLARE_WORK(isolcpus_work, isolcpus_workfn);
> > >   	if (!isolated_cpus_updating)
> > >   		return;
> > > -	ret = housekeeping_update(isolated_cpus);
> > > -	WARN_ON_ONCE(ret < 0);
> > > +	/*
> > > +	 * This function can be reached either directly from regular cpuset
> > > +	 * control file write or via CPU hotplug. In the latter case, it is
> > > +	 * the per-cpu kthread that calls cpuset_handle_hotplug() on behalf
> > > +	 * of the task that initiates CPU shutdown or bringup.
> > > +	 *
> > > +	 * To have better flexibility and prevent the possibility of deadlock
> > > +	 * when calling from CPU hotplug, we defer the housekeeping_update()
> > > +	 * call to after the current cpuset critical section has finished.
> > > +	 * This is done via workqueue.
> > > +	 */
> > > +	if (current->flags & PF_KTHREAD) {
> > 		/* Serializes the static isolcpus_workfn. */
> > 		lockdep_assert_held(&cpuset_mutex);
> 
> Do we require synchronization between the the queue_work() call and the
> execution of the work function? I thought it is not needed, but I may be
> wrong.

Well, something needs to ensure there aren't two threads trying to use
this one work thing at the same time, no?
