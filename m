Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A296A1FCFFC;
	Thu, 11 Jun 2026 13:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781185963; cv=none; b=IAw5A3ljT3RqprMIGyIdvmFEDtEfm50ngFdbadf06cP+Cq8Fv825/ZYWvTZj3Y2qVd0BoA+VjaNEs62zyADmZbVt9nhCmgjxt3nlLcVC5kah3rJu3QXXAgK3CzZPCqavU9hwZj2Inh4BxlI+KZk5ctKLuzucSCnfX2oCIm+z/as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781185963; c=relaxed/simple;
	bh=ClUeRIlwxtKCGlKO/QfS7Pui8jOoNo0Exev2CdMiWy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1O7Pp50xnrTvVkIMLedTm1GqSaWM553tL8JRpNY9q1SKC0/tINPV/g44HtYf/WnvXiKHSNeoN3+r/ZwtumPPcE6RU1nTHZCTEYovo+Pql18+ciOQHN0FD40fri21cfJqL9rsOFs6ox1f61kTd66jOl2aw+Dyai53k1U1F6cTqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qI7xfvfo; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qI7xfvfo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=593ksplQiT5Bh1hNgP+899YJ2glOv9xxnrZFl5JotAY=; b=qI7xfvfoUJvBsLw1RUkb9i7yv5
	+8WXWB0rUl/m3xIwwU4OqbOF+Go+BmUwhA1mQqS10VpOGFigHtcpr8mxGTjXmeF52b9Eneneyn2U8
	RR9i1/mPeKlb0OIvjG0+e4+nQVP8LR8WOvgwbUrwULkEeTXyaVw0rg8vFUX2Awnwr33KWuQDNiCvw
	emnQNc5o0V4mDK8JkRQubl1TopkE297kdJc0TY9NgxWx41Ti3q4imdK59PMmZY67p4C68KZu4yTj5
	2OlwRu0EzOXnzhYeISHZdaBsceLhs5PkxRn1rWkKus9QoB6Ul9gPfV6/20UMRMejgjm/B6STHsib9
	Y8AiQpZQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXfkk-00000005HBP-2cc0;
	Thu, 11 Jun 2026 13:47:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C58CC3002F0; Thu, 11 Jun 2026 15:47:24 +0200 (CEST)
Date: Thu, 11 Jun 2026 15:47:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <longman@redhat.com>
Cc: mingo@kernel.org, chenridong@huaweicloud.com, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, jstultz@google.com,
	kprateek.nayak@amd.com, qyousef@layalina.io
Subject: Re: [PATCH v3 3/7] sched/fair: Add cgroup_mode: max
Message-ID: <20260611134724.GK48970@noisy.programming.kicks-ass.net>
References: <20260605105513.354837583@infradead.org>
 <20260605124051.589618504@infradead.org>
 <d4ca5fe7-fd76-47c8-949a-a69916bfcbd4@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4ca5fe7-fd76-47c8-949a-a69916bfcbd4@redhat.com>

On Wed, Jun 10, 2026 at 11:09:59AM -0400, Waiman Long wrote:

> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -4116,6 +4116,21 @@ bool cpuset_cpus_allowed_fallback(struct
> >   	return changed;
> >   }
> > +int cpuset_num_cpus(struct cgroup *cgrp)
> > +{
> > +	int nr = num_online_cpus();
> > +	struct cpuset *cs;
> > +
> > +	if (is_in_v2_mode()) {
> > +		guard(rcu)();
> > +		cs = css_cs(cgroup_e_css(cgrp, &cpuset_cgrp_subsys));
> > +		if (cs)
> > +			nr = cpumask_weight(cs->effective_cpus);
> > +	}
> > +
> > +	return nr;
> > +}
> 
> I just have a question about cgroup v1 support. I am assuming that cgroup v1
> without the cpuset_v2_mode mount option is not supported. 

Correct.

> To fully support
> cgroup v1, you may have to use guarantee_active_cpus() to return the actual
> set of CPUs that the task can run on.

Except this is group based, we'd need an iteration of all tasks in the
group and compute a union of guarantee_active_cpus(). Which all seems
far too expensive and not worth the effort.

> Also there is a caveat about the arm64 specific
> task_cpu_possible_mask() for certain arm64 CPUs. That is for 32-bit
> binary running on 64-bit core which are allowed only on a selected
> subset of cores within the CPU.
> 
> This is probably not what you want to focus on right now, but it will be
> good to have a comment to list items that are not fully supported here.

Will add a comment!
