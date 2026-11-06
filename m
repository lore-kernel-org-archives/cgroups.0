Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962209;
	b=yyOju/V9d0LlfmPKe21EPyRHin1IIQtjrp4VVKFVVypuDupEgHik+KbrQwtIVEFSjpIj
	 o8A12Tks3TZoXL7bAltdbcDEUylcERWKD2R1a8XomoyrlT6UZh/1vcH8CyPcEjWDvvNVd
	 ZIBJ4VI9LNbymtbMBZJMtMYXTu9DM4jcP8JPAbLkdE5B01/gcuzmUl6gLxDaEF9mIkJbl
	 CVvUSDy5j5G9orz5zfqleTySj+ZPMLbD3waWHSZq0KRkaKs8f/gfmGC3kEY/wagGhYRtf
	 4pidWhqHtY0Bqs70PJM7Tt61wclzgzBI8vhk44YLkqr6pchhh+uWtYBN9cK4/7HHcMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962209;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=xYW39RZi6BQZ7wB7I4RRp3gBwQGPXTwbaw7HbZN2BsI=;
	b=oOsiNTwS7I9lbRKxrgoonRf0EcgG12BbRuTewFnlOBdW5h+W70vj8STH7OETEp7JhS6j
	 anKSeE46C01ArcUQX0FMJZdQAKeftqQWHnsCfK6BZhQPr2kw7v0NhmZ8Hdp9OD9dpiiiG
	 zzJ3E9IWn1I4xOu/ZhfEPgaZHrhYb/cop2eqh0wddos8x9xTEfuyA9GCp6rHgZoLV9/yh
	 ILpqi7kVvX+WqM2FZgkX8hZER1jKMk3zvvWTQ6a6mnpfM0c2slIP+pdR8iCj7/KxUBuoX
	 /jpd9qSRnc9PT2GvuHQnKkkP/lrkMoCII7buX2swz1HU/6N/YNiX8fuWw3fobg0kjMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=poBvO1j7;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB582606EEAC;
	Fri,  6 Nov 2026 10:50:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB582606EEAC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=poBvO1j7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xYW39RZi6BQZ7wB7I4RRp3gBwQGPXTwbaw7HbZN2BsI=; b=poBvO1j7MwZvUIGsLTn3iJCmx/
	CSuYqhq//CeM0atUd9aOwTyvnO52sxlX/0pRX7c2Ot1CP3q4viXf3nFpCGIBHXD93M654Z0GncDYY
	0s/1FckqirvBZN5ryvJADB/GI+hUbi2XTPmU3wwN8X5ZPmYswmFE/ZducjrM0jNSxIMj6rssVzP9m
	naSTva9/+9GWSpeTjIKwW9H2Kh5a3K+BKEQiwKWouEQlv379jB/f0yiHjPSVkzyaDpaWxCloZkqLM
	bonIjdGN2fblCQ1oVoKGBsT8yFdWAO0Gqy+F/n5vYu55b3XvzakgJpRQJXhk5siDP9j1z63fgygBZ
	pNqHHb5A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xPHWF-000000039C3-3mMH;
	Fri, 06 Nov 2026 10:50:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7DB0E300882; Fri, 06 Nov 2026 11:50:03 +0100 (CET)
Date: Fri, 6 Nov 2026 11:50:03 +0100
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
Message-ID: <20261106105003.GU1813469@noisy.programming.kicks-ass.net>
References: <20261105164724.yxONBd03@linutronix.de>
 <auy6nyTUuHBlgrV_@slm.duckdns.org>
 <20261105193010.tXUDDu2w@linutronix.de>
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
In-Reply-To: <20261105193010.tXUDDu2w@linutronix.de>

On Thu, Nov 05, 2026 at 08:30:10PM +0100, Sebastian Andrzej Siewior wrote:
> On 2026-11-05 07:19:27 [-1000], Tejun Heo wrote:
> > Hello, Sebastian.
> Hi Tejun,
> 
> > 
> > I'm not against it but wonder whether it'd be useful to do it more gradually
> > so that people can pipe up if they depend on it. ie. Mark it deprecated and
> > put it behind EXPORT for a bit and then BROKEN before actual removal.
> 
> I would be surprised if this is actually used especially since it is
> cg-v1 and v2 is the default/ used by everyone (?). 

So I would love to actually delete this. But IIRC there were actually
people who used it.

But yes, we need to replace this with that other thing.
