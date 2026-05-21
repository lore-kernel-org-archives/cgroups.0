Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C4D3806AA;
	Thu, 21 May 2026 13:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369733; cv=none; b=nV2WovZ8nknzOdHJIoX04ccOl94O/je/B8f6i0M4i97bmjJaJQbN+G3maG9xsYB4rgoyt01Bda7WNXIemX8jUoPF4WRK7ujQhajfizg5W+68yakaOEVnCcH3c9TqqzS3qsoqIK/gcyKGfHUzhXmQXDpA2GotWELGOQeTM3nlYzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369733; c=relaxed/simple;
	bh=zK5oJobL1oqp8B7ybYblCM6WGqvgk4ox1m8JsQc/azM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tT7oIguIOvX4tz9frfCCAP7dpFJBFl5DST1pJ09pPQxbYG1AM6ERxNE7wh95jprxYmubsSY+Jy1Z4/5+t27bKA/sddnrHt7jZycO6CIpZfp1uXC9DFpGvW9MqwyX8wwkC35L8WQrCLTD2JVIzkrc4qxPxWgE1j2ErpReF+58G+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c8u+z3ko; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c8u+z3ko"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zf5octw05mJJPujr2PEO1B3R63m8gCWNNBtU/nGGy5Y=; b=c8u+z3koV2ICGJnyel6VouEcxZ
	iNe/t/lnYearDV5gEwrwiQdcxDUpfOuE3pRDBecbX8dZ6e4vFHCt8uBKromJAdEVALFwBvgrhzvPh
	f9sh3lCgLbCDriz5CgsBLXJnGWjNx4BXcRO3GiD1YmkOd8dW1dL9aL2btssnxnyoCClWg9o37gi6Q
	bFnXPPzfuY5TM9DW+N4GcYuLYrjiCdFWgkxWnkbU3ggF3CY7JFWpYhxqh+8/Vsxm96sUllhCjbME4
	HIQDfg3MJSBGyjGiOYZ1oK7IJsU3N524ybfa66i8XLvX/NBV1Z1jVa4RmBZLhpUVjP59HBVANWsoa
	nmyaZVFw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQ3LN-00000008WR8-146F;
	Thu, 21 May 2026 13:21:45 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id AE8AE300446; Thu, 21 May 2026 15:21:44 +0200 (CEST)
Date: Thu, 21 May 2026 15:21:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, longman@redhat.com, chenridong@huaweicloud.com,
	juri.lelli@redhat.com, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, jstultz@google.com,
	kprateek.nayak@amd.com, qyousef@layalina.io
Subject: Re: [PATCH v2 10/10] sched/eevdf: Move to a single runqueue
Message-ID: <20260521132144.GQ3102924@noisy.programming.kicks-ass.net>
References: <20260511113104.563854162@infradead.org>
 <20260511120628.206700041@infradead.org>
 <CAKfTPtCc=pBKe9eRbA5B0zhaXJKVjN4N74AT0BFyRK39cS4c5Q@mail.gmail.com>
 <ag3iC-jH6HPoWKGo@vingu-cube>
 <20260521103117.GC3102624@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521103117.GC3102624@noisy.programming.kicks-ass.net>

On Thu, May 21, 2026 at 12:31:17PM +0200, Peter Zijlstra wrote:
> On Wed, May 20, 2026 at 06:32:11PM +0200, Vincent Guittot wrote:
> 
> > I finally fount the root cause of regression: the update of entity lag happened
> > after the task has been dequeued which screwed update_entity_lag():
> > 
> > update_entity_lag must be called after updating curr and cfs_rd and before 
> > clearing on_rq
> > 
> > With the fix below I'm back to original hackbench figures and maybe even a bit better.
> > I haven't checked shceduling latency yet

I see a very slight hackbench regression on the high end, but meh. The
latency-slice test seems to have slightly improved max values, but this
isn't the most stable of things.
