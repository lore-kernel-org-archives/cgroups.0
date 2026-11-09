Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794233543;
	b=KiTpavVhkv85I0lRzr3naB+18nPKocRTkeb1WJVdoN4fsKMVgAUozhSMGhLu04VZymNG
	 Xw3td7Yv9ZRd6JzFS0Ocay+VYTSBPh56Vp1a53rOk8gpMQSgmaDny2mXwHN9tpK8soG+/
	 gTbz+IIKL5jpN4AskP/IeKLV1rQATz3pmOJrMNUt4z6zYFpYUCeFP2vvldYCBO6xAqpnZ
	 i9JioMcZiJlodOGd6lvCgLYrmOCvrFdguhYHM2EBdXWAJuM5La079pYsI7FCr8Noa6cKq
	 d6YbvJAbcOq3kFLJwXEe6Tno3VB3cjFj02Hy43pAoXU5Q0oRYElnpLHY3A+H2lQS5uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794233543;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=O2aI15BvczZ+7OEGQ6YiBMp3R5vW+5w4ZDD7M1MqN48=;
	b=t9eF4t0/1o/Jo18d4vNw9eJyHjX5vQFWkvFn0523kNAxo44EcnWlolVnthuftSSG7I/9
	 PhDl9lBzmiVXJHBdWXo5WN1LqenmfYKfnls3xpQP4wanJghdv4Vu6TrngaWMjGW5u8lvK
	 CbAHBCoAJES3XRgvZYupBewY7eDBhnK8WuhBAWqMgLWk8nJH7DYGgJclYO80yflWIR6M1
	 wdgcgOkUKjSz37JxXfAzT68HvTdsMo08L6lBO1KmckJAq8TMK1tQQodh0yRG7oy7FewZy
	 dUmUBOllu1V7dHTWUV8jz1NhSHxVyNHkQJ5FEkJMEluxL2RODHbE0DJFa8J11YOCZSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yXVd9FmK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="IKVJ+W/M";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yXVd9FmK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="IKVJ+W/M";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73ED606A32A;
	Mon,  9 Nov 2026 14:12:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D73ED606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yXVd9FmK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IKVJ+W/M;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yXVd9FmK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IKVJ+W/M
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1049B22030;
	Mon,  9 Nov 2026 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794233541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O2aI15BvczZ+7OEGQ6YiBMp3R5vW+5w4ZDD7M1MqN48=;
	b=yXVd9FmKe7Ob1knMgsssG3E8dnqPFa0gh0va6UsPFrZNmfpwf1CGYY+ZQYXkADBkD6slxB
	71n5bXMvrrwP4ZchHaoQfbg40Eeu+HVyE3/eNsiDOZSJ6ZOYWf8QOyxxM/7gowQf95PzJ/
	BAp2h3EXcZ7YjBAnFxrWWFX5wvcwr9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794233541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O2aI15BvczZ+7OEGQ6YiBMp3R5vW+5w4ZDD7M1MqN48=;
	b=IKVJ+W/MQJeGL8bBUobOAWe/cGORmXeK3Btk4btV+VroK8l0OkQR0+TNMZjS3RTsQVA/5I
	Wp8jupL4693KM3Ag==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794233541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O2aI15BvczZ+7OEGQ6YiBMp3R5vW+5w4ZDD7M1MqN48=;
	b=yXVd9FmKe7Ob1knMgsssG3E8dnqPFa0gh0va6UsPFrZNmfpwf1CGYY+ZQYXkADBkD6slxB
	71n5bXMvrrwP4ZchHaoQfbg40Eeu+HVyE3/eNsiDOZSJ6ZOYWf8QOyxxM/7gowQf95PzJ/
	BAp2h3EXcZ7YjBAnFxrWWFX5wvcwr9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794233541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O2aI15BvczZ+7OEGQ6YiBMp3R5vW+5w4ZDD7M1MqN48=;
	b=IKVJ+W/MQJeGL8bBUobOAWe/cGORmXeK3Btk4btV+VroK8l0OkQR0+TNMZjS3RTsQVA/5I
	Wp8jupL4693KM3Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9D0E13319;
	Mon,  9 Nov 2026 14:12:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id otPMLMTU8WofWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Nov 2026 14:12:20 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 689BE221F7; Mon, 09 Nov 2026 15:12:16 +0100 (CET)
Date: Mon, 9 Nov 2026 15:12:16 +0100
From: Jan Kara <jack@suse.cz>
To: Breno Leitao <leitao@debian.org>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
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
Message-ID: <xehz3f62chf5ivwbh7f5chapypp5md5vasdtsnxfwzsebontf3@roqs5cwjk2va>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
 <ysxh2sfvjikoh6cw2qmk2i6p7xripwnqxkx43jj7unxop5tkiw@gws5wezjt34g>
 <au3w4xiaYbEYLTru@gmail.com>
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
In-Reply-To: <au3w4xiaYbEYLTru@gmail.com>
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO

On Fri 06-11-26 07:47:22, Breno Leitao wrote:
> On Fri, Nov 06, 2026 at 03:37:45PM +0100, Jan Kara wrote:
> > On Fri 06-11-26 04:26:34, Breno Leitao wrote:
> > > The slow writeback report is printed on every wakeup of the waiter past
> > > hung_task_timeout_secs, and the waiter is woken more often than that.
> > > 
> > > Each flusher working for it wakes it once it has not run for half the
> > > timeout. All waiters on a bdi share bdi->wb_waitq, so a wakeup meant for
> > > one of them reaches all of them.
> > > 
> > > A sync of files dirtied from two cgroups, on a throttled null_blk device
> > > with the timeout set to 5 seconds, gets a report every half timeout,
> > > each printed twice, 18 reports for a 29 second wait:
> > > 
> > >   [   10.327992] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
> > >   [   10.328000]       bdi 252:0, work items left: 2
> > >   [   10.328003] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
> > >   [   10.328004]       bdi 252:0, work items left: 2
> > >   [   12.888187] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
> > >   [   12.888195]       bdi 252:0, work items left: 2
> > >   [   12.888197] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
> > >   [   12.888198]       bdi 252:0, work items left: 2
> > >   ...
> > > 
> > > Remember when the waiter last reported, and report again only once
> > > another timeout has passed. The wakeups do not change, so the hung task
> > > detector still sees the waiter making progress. The same test now
> > > prints 5 reports:
> > > 
> > >   [    7.661129] INFO: The task sync:277 has been waiting for writeback completion for more than 5 seconds.
> > >   [    7.661136]       bdi 252:0, work items left: 2
> > >   [   13.241102] INFO: The task sync:277 has been waiting for writeback completion for more than 11 seconds.
> > >   [   13.241109]       bdi 252:0, work items left: 2
> > >   ...
> > >   [   31.801068] The task sync:277 waited 29 seconds for writeback completion on bdi 252:0
> > > 
> > > Signed-off-by: Breno Leitao <leitao@debian.org>
> > 
> > Now I'm waiting for someone to complain it gets written out too
> > infrequently :). 
> 
> Once per timeout is also how often the hung task detector checks by
> default, and patch 3 logs the total once the wait ends, so maybe that is
> exactly what people need? Not sure.

I was mostly making jokes here. I agree reporting once per hung-task
timeout makes more sense.

> > Is this change substantially different from
> > writeback_sb_inodes() waking up done->waitq less frequently?
> 
> You mean the ->progress_stamp field? That is not used for reporting
> purposes, right? Should it be?

So my thinking was: If we change the wake up condition in
writeback_sb_inodes() to use HZ * timeout as a limit instead of HZ *
timeout / 2, then we should get one report per timeout, shouldn't we?

> It could drop the duplicates: a wakeup with work left runs the
> wait_event() condition twice (since 84654c7f4730, it is checked right
> after schedule() and again after prepare_to_wait_event()), and the
> second check would find ->progress_stamp just refreshed by the first.
> 
> But the waiter refreshes ->progress_stamp on every wakeup, so it cannot
> space the reports further apart than the wakeups, and those have to
> come more often than the hung task timeout.

Why do we want to wake up more often than hung task timeout? We evaluate
the condition after each inode so the error shouldn't be that big?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
