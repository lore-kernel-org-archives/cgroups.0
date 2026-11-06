Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963540;
	b=yF0k0X1P5xQed00hITMJIEv5UqBNe0FPe9lPagfNB3mn7TDhTb9Pzb648vi/vx+9z1qA
	 lJdAOnbG7RDk4n+xhfN30tX3XB7Jq1jejaFXdi+goSShwV9iWbOQq1Qt0xmtJ/mxotje0
	 nwBu3I3ZKCpSZPTTUoVJ4+uiWgGbRF+DrioPPwY4k79JH4Dc0VMAvE2v85JgyISk56/WP
	 4LTQ6/JswxLk7YiRVLk7w58H0xJKC2AxR1t356nTRxLgLFC9f3XDbtISDUxRUE2qe19qO
	 Wz69Pku8AkHctjD0KHqfSjxqcAbfQ432hfs523rDbTUFM5/lOMZNDFkBPn1ZbzQfZDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963540;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=7DVhJx7Rbv9VPK3/O6fqaFnxiPFsrlzR18pmIMEOZnU=;
	b=3zW8hnCI/z5OtfzphxEvVzFpTDtO6QPN7S9kv767/KF3Egclbzq90JOx7Rr8kVwDACax
	 k0NSM7vLcb9QtVGpqA0QxA87xxAeHj/wQZyHzNS1ftjtg45dfcjAFtLd/UCEKIjpL0Ulw
	 ArjqdLO6vt/dp5aBT7+9Qmq8dYDecI2Mx5jAEHuLq9y8++lpRghRW1pbMN9zAV4VdRCPw
	 AJRPzGxi9elb5vZBiSOb56HL7lRTjdPJckHHAktzKGiZTXWyg5hqJUcvX2Y3u8pRybH9C
	 y8M046o8mBOf4+9Xr7nnUniCPcUYitZ5wnvERBUrEFhQQ85hprN+hdUXCRY7ANd/wkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=KqKAeKgU;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB088606A326;
	Fri,  6 Nov 2026 11:12:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB088606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=KqKAeKgU
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7DVhJx7Rbv9VPK3/O6fqaFnxiPFsrlzR18pmIMEOZnU=; b=KqKAeKgU8i/rkNAoYmHsxcFc7B
	+L+FKXAOwQ6aJaBIUha+98o9ifs93VozSXBfSZPUU23NKamZCrmw9goDrJAlejDFli81tQ5ebp1Me
	7t81hca6I/IwPMGUzX5QQxO4z/ziU6ffPnKyB4QCOlUOh4N+tXfjnDUYhgUL0ZhxXlvo/FHye4INu
	6RvRN8HiOyRT3ZstBjkQrnMWdO3S3hJykjTCad3+s8mUEZOJPXDBWF79xUVTIA/6N8kSWSW/cXaE6
	qD4P3b/CqOy9iVVFsnZY9Sq9lQzCNJe03rcVngffFl9ToCRxgcTqYQYwrAyHrw7BESAVIXzaijARG
	bP/Mk7LQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xPHri-00000003I6l-0pEk;
	Fri, 06 Nov 2026 11:12:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 57E47300882; Fri, 06 Nov 2026 12:12:13 +0100 (CET)
Date: Fri, 6 Nov 2026 12:12:13 +0100
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
Message-ID: <20261106111213.GG1779021@noisy.programming.kicks-ass.net>
References: <20261105164724.yxONBd03@linutronix.de>
 <auy6nyTUuHBlgrV_@slm.duckdns.org>
 <20261105193010.tXUDDu2w@linutronix.de>
 <20261106105003.GU1813469@noisy.programming.kicks-ass.net>
 <20261106110435.5MWA_4Hw@linutronix.de>
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
In-Reply-To: <20261106110435.5MWA_4Hw@linutronix.de>

On Fri, Nov 06, 2026 at 12:04:35PM +0100, Sebastian Andrzej Siewior wrote:
> On 2026-11-06 11:50:03 [+0100], Peter Zijlstra wrote:
> > On Thu, Nov 05, 2026 at 08:30:10PM +0100, Sebastian Andrzej Siewior wrote:
> > > On 2026-11-05 07:19:27 [-1000], Tejun Heo wrote:
> > > > Hello, Sebastian.
> > > Hi Tejun,
> > > 
> > > > 
> > > > I'm not against it but wonder whether it'd be useful to do it more gradually
> > > > so that people can pipe up if they depend on it. ie. Mark it deprecated and
> > > > put it behind EXPORT for a bit and then BROKEN before actual removal.
> > > 
> > > I would be surprised if this is actually used especially since it is
> > > cg-v1 and v2 is the default/ used by everyone (?). 
> > 
> > So I would love to actually delete this. But IIRC there were actually
> > people who used it.
> 
> That would mean that it is working which does surprise me.

For some definition of 'work' :/
