Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980068;
	b=f47WvQmBMlK+iy3YxF5DqM/wWSe4ONWsapNtascoSN6VovbAB4gBkDlVZ0QIsdZqZ85w
	 39jCKhp1676OG3l8MlbYXkwgjB7j1R6V7Coqffr0kggsrW+/3MTMaAwQw5fueKTt6QWtA
	 NNErQ27swEi5WSp90PRWF2UtXhuv5s0UXpDYa+Rb78NCFcQKK8yEsU9nj74Uh7Yv4tUEh
	 zKmQFn1Zx+aoyQMj7vGCXgkpXwDs2CbsfKtuM6pGP4dvWdAQ8OHW0QAT15hmgaGz57QPA
	 GcSC0mEMCKjXZmiJCLtoLOEOhhro3dBduVkik4ijSw+O48VDBuP+WZhDh+t3mjJNzhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980068;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=UmKUyztNyCKEX6kdM2pzglbfBGyZ6nijYc/+g6Roixw=;
	b=lBYuOmv5uT+BWSfVMshZU5J2Id6Tf4oLqO2VB0wL+KKhWX18g3Lazv4HrZrPrhAvc4Vl
	 KDu4qp2tw28O7POgSUfAgpneRetuG7qB5bFYd8i8ygfFzl6kcvTwHQNz6L84lEd7YWvR/
	 gNGvY1pC9INh2uwkLhAApzGDyPE7d9wnPoYFeJqEX8Hlw9l5C6SoUGkG0ZcyAfICZ8RN5
	 BUfx2nnBspp+CQvs6HfiHmEOUbXa03/F2ByzO9GnwGWTzFBD+kI5oDrTeTvbmzOxzzTDn
	 +dx++7Jfg6BYJqqRf+o0HA/6yAXuyEWlUt4YcZQJGjHcjba6inQeGHJlgWRlkHTNgPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=hxJ0aWWr;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7380B606A326;
	Fri,  6 Nov 2026 15:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7380B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=hxJ0aWWr
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UmKUyztNyCKEX6kdM2pzglbfBGyZ6nijYc/+g6Roixw=; b=hxJ0aWWrhA/N+kPnh9QdadK03I
	lphqVrug6uscPzlWL2jyy4zJB2rNqXeOEXOLuwmTGBKV3e6eyRkSxZroS7b5nL61OzJDkf2UkX+ln
	0BmB02lmybqsifwdOsPKfRKNklN7Giqov+pGQZVxC5OCfay9a3Wn3EhTRIaImRfCjzT4xtmKEtpzx
	svMGJfZBLYPoYIHp/j8+GM0EpjPZlGl/zWct1qAtM3b9sush4NCM+c1ChfiEjgkhJoDryu9M53/lU
	bWMwwwkvUcLuN3iGCOJ9nqxg6EvJeYKwB+fKWCDpK2kjJFauLIg9FqPkOwViu3y64uaSgBQBi1bJG
	RqdWC0iw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPMA3-009OAp-2L;
	Fri, 06 Nov 2026 15:47:27 +0000
Date: Fri, 6 Nov 2026 07:47:22 -0800
From: Breno Leitao <leitao@debian.org>
To: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Julian Sun <sunjunchao@bytedance.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 4/4] writeback: report a slow writeback wait once per
 timeout
Message-ID: <au3w4xiaYbEYLTru@gmail.com>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
 <ysxh2sfvjikoh6cw2qmk2i6p7xripwnqxkx43jj7unxop5tkiw@gws5wezjt34g>
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
In-Reply-To: <ysxh2sfvjikoh6cw2qmk2i6p7xripwnqxkx43jj7unxop5tkiw@gws5wezjt34g>
X-Debian-User: leitao

On Fri, Nov 06, 2026 at 03:37:45PM +0100, Jan Kara wrote:
> On Fri 06-11-26 04:26:34, Breno Leitao wrote:
> > The slow writeback report is printed on every wakeup of the waiter past
> > hung_task_timeout_secs, and the waiter is woken more often than that.
> > 
> > Each flusher working for it wakes it once it has not run for half the
> > timeout. All waiters on a bdi share bdi->wb_waitq, so a wakeup meant for
> > one of them reaches all of them.
> > 
> > A sync of files dirtied from two cgroups, on a throttled null_blk device
> > with the timeout set to 5 seconds, gets a report every half timeout,
> > each printed twice, 18 reports for a 29 second wait:
> > 
> >   [   10.327992] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
> >   [   10.328000]       bdi 252:0, work items left: 2
> >   [   10.328003] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
> >   [   10.328004]       bdi 252:0, work items left: 2
> >   [   12.888187] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
> >   [   12.888195]       bdi 252:0, work items left: 2
> >   [   12.888197] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
> >   [   12.888198]       bdi 252:0, work items left: 2
> >   ...
> > 
> > Remember when the waiter last reported, and report again only once
> > another timeout has passed. The wakeups do not change, so the hung task
> > detector still sees the waiter making progress. The same test now
> > prints 5 reports:
> > 
> >   [    7.661129] INFO: The task sync:277 has been waiting for writeback completion for more than 5 seconds.
> >   [    7.661136]       bdi 252:0, work items left: 2
> >   [   13.241102] INFO: The task sync:277 has been waiting for writeback completion for more than 11 seconds.
> >   [   13.241109]       bdi 252:0, work items left: 2
> >   ...
> >   [   31.801068] The task sync:277 waited 29 seconds for writeback completion on bdi 252:0
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Now I'm waiting for someone to complain it gets written out too
> infrequently :). 

Once per timeout is also how often the hung task detector checks by
default, and patch 3 logs the total once the wait ends, so maybe that is
exactly what people need? Not sure.

> Is this change substantially different from
> writeback_sb_inodes() waking up done->waitq less frequently?

You mean the ->progress_stamp field? That is not used for reporting
purposes, right? Should it be?

It could drop the duplicates: a wakeup with work left runs the
wait_event() condition twice (since 84654c7f4730, it is checked right
after schedule() and again after prepare_to_wait_event()), and the
second check would find ->progress_stamp just refreshed by the first.

But the waiter refreshes ->progress_stamp on every wakeup, so it cannot
space the reports further apart than the wakeups, and those have to
come more often than the hung task timeout.

So it is a choice between a report every half timeout with no new
field, or once per timeout with report_stamp. Which one do you prefer?

Thanks for the review,
--breno
