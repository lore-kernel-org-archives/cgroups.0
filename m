Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D533936C9D0;
	Tue, 12 May 2026 18:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778610310; cv=none; b=OPHUP/0rJ4mU8hZ7b9hBMkZuakkAV/Zc/0UlGYqUwBd029lz9ahnDoQuhWJ7Djmpvu9fdqlMqDT3VI29UrqMtd9ziJgTza0Lk2mYg5dtEzhEg8A/QSUKmCKUizSISewn6w24MS1u1TCaq4E4GpVnbi9zF0mlAaPoM7TflmAv9Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778610310; c=relaxed/simple;
	bh=wWFplwI8P2hR6V1buCzgG+m8ARlADkfCV0zPnRB0cqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GuapYwg3e8AvTS65jfz+iCIKDJAiARGoSUgPcD1b6Dl7p/3KoKKJwM6eLjJid9kdbINiOmd2OYO8328xkkaqPwqUU6Fszadtcfqx7+tiKHBJRwFfP5SY+J5cYR5nuzVznIHnA6Fo5D2zWYjTxSi3yYQagtwd9Icixk8VNjUkGY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Rg2TBN2T; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rg2TBN2T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iTtNV5Ij0ZGs+MxSCL8DE835b24AdzqfLKn3z0XFiqM=; b=Rg2TBN2Tgmw6UhYaGPLNSJ9A5/
	ofkZ4FwFUUF5YBoiDSUZCvSkqTVG8QPodYvuWvGt3jZhyqc8BBRP8nUcmPt6zAUlMwa6U/UDYARoJ
	cNZKURIedo2UVXFIY/iZcT/coBTtml1Gd+ApxvcxBojnKQ2/yPMjEqD9ycSEoaYpoiDMu/81G5V0T
	YD15I59HOTzAbM+YdbPLAQ+3QXYz0kSfO8auU6c/Zw71xngYui4BKitt1wCrBoDS2W4czuPrg/THp
	007QD+YRFfBMLkVjb5hEmVpbTlG0STIkXNI246B1A76MNsdxD72huF9X2cZI6xUdwcQp9mba6GZEr
	7TirtqZA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMrmb-0000000AAb0-0NoG;
	Tue, 12 May 2026 18:24:41 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BD04F3013A0; Tue, 12 May 2026 20:24:39 +0200 (CEST)
Date: Tue, 12 May 2026 20:24:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, longman@redhat.com, chenridong@huaweicloud.com,
	juri.lelli@redhat.com, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, jstultz@google.com,
	kprateek.nayak@amd.com, qyousef@layalina.io
Subject: Re: [PATCH v2 00/10] sched: Flatten the pick
Message-ID: <20260512182439.GA2855641@noisy.programming.kicks-ass.net>
References: <20260511113104.563854162@infradead.org>
 <CAKfTPtA2aBtuBffVV02VgsRRi5mRK0G5ununzuvJ7h7buygNxg@mail.gmail.com>
 <20260512092040.GN3102624@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512092040.GN3102624@noisy.programming.kicks-ass.net>

On Tue, May 12, 2026 at 11:20:40AM +0200, Peter Zijlstra wrote:
> On Tue, May 12, 2026 at 10:42:33AM +0200, Vincent Guittot wrote:
> 
> > 
> > I haven't reviewed the patches yet but I ran some tests with it while
> > testing sched latency related changes for short slice wakeup
> > preemption. I have some large hackbench regressions with this series
> > on HMP system with and without EAS. those figures are unexpected
> > because the benchs run on root cfs
> > 
> > One example with hackbench 8 groups thread pipe
> > tip/sched/core  tip/sched/core          +this patchset          +this patchset
> > slice 2.8ms     16ms                    2.8ms                   16ms
> > dragonboard rb5 with EAS
> > 0,748(+/-4,6%)  0,621(+/-3.6%) +17%     1,915(+/-7.9%) -156%
> > 0,689(+/- 9.1%) +8%
> > 
> > radxa orion6 HMP without EAS
> > 0,588(+/-5.8%)  0,677(+/-5.9%) -15%     1,505(+/-10%) -156%
> > 1,071(+/-5.9%) -82%
> > 
> > Increasing the slice partly removes regressions but tis is surprising
> > because the bench runs at root cfs and I thought that results will not
> > change in such a case
> > 
> > I will review the patchset and try to get what is going wrong
> 
> Yeah, that is unexpected. Let me go have another look too.

So I can reproduce even without the last patch applied. I suspect it is
in the cgroup mode patches somewhere. My first suspect is that concur
mode thing doing bad things to track the 'global' nr_running thing.


