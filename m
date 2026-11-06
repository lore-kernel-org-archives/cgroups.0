Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964123;
	b=ColI3V9a8C5X57Ie8F3sfiVNdBCE8qPPQ+xP82NwNvFzGfJZ7HjAnl6KDOE5REIMjHo/
	 WJw1HiZ1iBWDuRoUnoS+cVzcxkBK0mpvmZ2t4jWswpGsDKH5H6EUxO2c+kY8a7Jxyokcg
	 Tkd1dcYZI4UG3OF+TbA2b81Kms+o2Q3l9BdE62Ly+WuPcl26M5nX2jU4hNvsCrDBpDLau
	 mAH0wbBHcnk9U5KSa0NlXu32AQlOZXm2n4r7r3KXSYw/6Upp6euojEIelbRd7Ufo+cajR
	 9o/ez3YggNVNk6CUEjvhbPrD9uWfgC7qcgI1ptxSsO+yOnU62XycBXf5hlgFnhLwbXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964123;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=13wYao7SgdJMFoNQ783acf3BVZUk+vlJR+o0bsh4/zI=;
	b=l4HhYBerW28a5powyt9iZYZ9igbX5WTvc4DUx5a5yUGkOm9pDHUKUUjW3uLxUnY1vf8F
	 BEjCxk/emULWpnxyoONbNB9F7BFH2WKzYXbBjVYHoqhmv3LbSdh+r6zrjA/dNpR2bMXOS
	 blLFQ6LB1U24WaDbE9KWmliTDRK2Er7Xs9yFuPJQAj1ep54RJW06jWvXQQVnLLhKBffGX
	 Okd7td1eA+z3JZe4ShH6U+bIXr8o9yDQlqyE4RS6Vof5xsEfu8W1OrG+TJW2YWBJRuvv5
	 4q86HziQlNbUjUhPlpX2LyP2F6VwMC6p+ttvfNJqt6rm3LsNATL0VhvbVgIMZFdHmRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b="4tAA/rN0";
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=gpc4LAiM;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE178606D808;
	Fri,  6 Nov 2026 11:22:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE178606D808
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=4tAA/rN0;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=gpc4LAiM
Date: Fri, 6 Nov 2026 12:21:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1793964120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=13wYao7SgdJMFoNQ783acf3BVZUk+vlJR+o0bsh4/zI=;
	b=4tAA/rN02tM8q9N8U7ABvGBYdC7XxtVB5CXDihapFj6aS+jDFV2P5zRpqUa9F1JTqkXy7k
	In7WKEOL+i+H4A2gztCajpilXRc2lqU1OO0Yut5ZYJfd52x2HIFEp47wQaFxraEkmPUUms
	+9bH+WFe5UzPKQc4d7fzVJrlatdRl5yHPmmEBrj7PBAhlw2PVJ37IKIrfe/Nx4OxPWZzMl
	akdWQQyq3j6yk/UMXzuh8sM2RtDqNkEo1r51HI2d6vC1oy938S9N8RUkHYMsLiDRKNYzWg
	Rkl70qNOlP/TnRA+Vr07EjxKxJP+52hOqSoUDubOSaBPerJBYQoTyDe/uJ96tA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1793964120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=13wYao7SgdJMFoNQ783acf3BVZUk+vlJR+o0bsh4/zI=;
	b=gpc4LAiM170jpseJlsCV0GRERdEQirPpS6mahNdPKPJ2BLabYPn1vhP5OfJ4QE94PlmrJ8
	unqw+qPeN9W/RCDA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, linux-rt-devel@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: Re: [PATCH] sched: Remove CONFIG_RT_GROUP_SCHED
Message-ID: <20261106112158.-VI88lZb@linutronix.de>
References: <20261105164724.yxONBd03@linutronix.de>
 <auy6nyTUuHBlgrV_@slm.duckdns.org>
 <20261105193010.tXUDDu2w@linutronix.de>
 <20261106105003.GU1813469@noisy.programming.kicks-ass.net>
 <20261106110435.5MWA_4Hw@linutronix.de>
 <20261106111213.GG1779021@noisy.programming.kicks-ass.net>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261106111213.GG1779021@noisy.programming.kicks-ass.net>

On 2026-11-06 12:12:13 [+0100], Peter Zijlstra wrote:
> On Fri, Nov 06, 2026 at 12:04:35PM +0100, Sebastian Andrzej Siewior wrote:
> > On 2026-11-06 11:50:03 [+0100], Peter Zijlstra wrote:
> > > On Thu, Nov 05, 2026 at 08:30:10PM +0100, Sebastian Andrzej Siewior wrote:
> > > > On 2026-11-05 07:19:27 [-1000], Tejun Heo wrote:
> > > > > Hello, Sebastian.
> > > > Hi Tejun,
> > > > 
> > > > > 
> > > > > I'm not against it but wonder whether it'd be useful to do it more gradually
> > > > > so that people can pipe up if they depend on it. ie. Mark it deprecated and
> > > > > put it behind EXPORT for a bit and then BROKEN before actual removal.
> > > > 
> > > > I would be surprised if this is actually used especially since it is
> > > > cg-v1 and v2 is the default/ used by everyone (?). 
> > > 
> > > So I would love to actually delete this. But IIRC there were actually
> > > people who used it.
> > 
> > That would mean that it is working which does surprise me.
> 
> For some definition of 'work' :/

despite that statement, no removal, depends on broken, anything? Just
keep everything as-is?

Sebastian
