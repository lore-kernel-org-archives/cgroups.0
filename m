Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964300;
	b=ojLQBdKJtN2gZ/l21teVjzF3ju7PQGsMecLTyf/Enrygjormtn2uW5nNWXeH6i0pjJkQ
	 RKKUqgSbDxLG2YU+cAq77f2kyFb+Q/SXFaDmYby7EvheMgp1CW1MDczkvkzGCcFTNnD8/
	 QA3eZ0l54Umoio5XvknFdn5egGG9iDwier4347BXBedwYWfZcPpjqtGD9dfN8rxP+1iyT
	 cGi3ro18zfnLBPPPjW6FfId064TMhbfqWX3OyC1ho5wNxrUi0FmBzxA350MYWwRhRYY/M
	 E0Ub4qZY+TKuXuirhmhFfgOFM1Vd9KMdkVS+nRxehzcLSoAPRvH9qaqQxhWlI0iBiDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964300;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=cU4wv+bE55wCI8rEgVyCRlUV4WkTYokq8PzGCxDXJc4=;
	b=BH/6zPj4PR9sY/vO90mq4ftdaEa3eFiAxmZncRVDeJRw2YVG4nV3HPFS3n6TM6+0Dx81
	 qID4tk7gvLwKAFPTPHNr1P5Z/VmsXgUbyk51GQMMY077KI7B3mddYFgM0/pJfB8pVsYJY
	 80b6Xi9Ptn8o8eLRdjzJPlJPKkS4gvZycpTVn6x546KB5IaZ0WIJDSAeJ1OmwJP8zrVqS
	 72POm3kyDJnkJvRpgLF2RyUFt7AyyZP7mJGL0g3SNbd7DJBX8QFdkNmCqLYLNBM/hF7v+
	 T3NyLECq64SDT37R+I4EYRibT3byEt73nQngdKAzYosSTHwLNFJ4hnpbzS6reQxIUFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=YnJXT3Ks;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC139606A326;
	Fri,  6 Nov 2026 11:24:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC139606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=YnJXT3Ks
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cU4wv+bE55wCI8rEgVyCRlUV4WkTYokq8PzGCxDXJc4=; b=YnJXT3KsMf1sSSyuWf4+GZjgSH
	f4sZE38Vo6gLfNs0+AsatvAwiRf8+AWoxFkMWNUS0A+dyUqqpRnGw7Y7YNGBuyPqoNo2J7XTeLtUi
	mzlkZMPkWbvWZ19qSpdwbj2A2vHAWIZg7P5JQL4vXK9YiN6DFtx7wfvaB832UbIViDakduZc93pH9
	Ur+49iqhaeEGq3MiWc5mw2nw7vg6yGGl9Q7Jf3ZqY1PwBWA6RI+Ev/SOaV6nqye6m10xL8LloxSWq
	b+1pmx69ozWw5XJmI7ghIo/uOpvXy070e8b9G1iOY+eBz1+SbuSQUvoiDMTU6h/Aa/kM5xFvBXWU3
	I7JlyAIg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xPI3y-00000003NNT-3rWr;
	Fri, 06 Nov 2026 11:24:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6B8DB300882; Fri, 06 Nov 2026 12:24:54 +0100 (CET)
Date: Fri, 6 Nov 2026 12:24:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>, linux-rt-devel@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: Re: [PATCH] sched: Remove CONFIG_RT_GROUP_SCHED
Message-ID: <20261106112454.GI1779021@noisy.programming.kicks-ass.net>
References: <20261105164724.yxONBd03@linutronix.de>
 <auy6nyTUuHBlgrV_@slm.duckdns.org>
 <20261105193010.tXUDDu2w@linutronix.de>
 <20261106105003.GU1813469@noisy.programming.kicks-ass.net>
 <20261106110435.5MWA_4Hw@linutronix.de>
 <20261106111213.GG1779021@noisy.programming.kicks-ass.net>
 <20261106112158.-VI88lZb@linutronix.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106112158.-VI88lZb@linutronix.de>

On Fri, Nov 06, 2026 at 12:21:58PM +0100, Sebastian Andrzej Siewior wrote:
> On 2026-11-06 12:12:13 [+0100], Peter Zijlstra wrote:
> > On Fri, Nov 06, 2026 at 12:04:35PM +0100, Sebastian Andrzej Siewior wrote:
> > > On 2026-11-06 11:50:03 [+0100], Peter Zijlstra wrote:
> > > > On Thu, Nov 05, 2026 at 08:30:10PM +0100, Sebastian Andrzej Siewior wrote:
> > > > > On 2026-11-05 07:19:27 [-1000], Tejun Heo wrote:
> > > > > > Hello, Sebastian.
> > > > > Hi Tejun,
> > > > > 
> > > > > > 
> > > > > > I'm not against it but wonder whether it'd be useful to do it more gradually
> > > > > > so that people can pipe up if they depend on it. ie. Mark it deprecated and
> > > > > > put it behind EXPORT for a bit and then BROKEN before actual removal.
> > > > > 
> > > > > I would be surprised if this is actually used especially since it is
> > > > > cg-v1 and v2 is the default/ used by everyone (?). 
> > > > 
> > > > So I would love to actually delete this. But IIRC there were actually
> > > > people who used it.
> > > 
> > > That would mean that it is working which does surprise me.
> > 
> > For some definition of 'work' :/
> 
> despite that statement, no removal, depends on broken, anything? Just
> keep everything as-is?

We can try marking it broken; see who screams this time ;-)
