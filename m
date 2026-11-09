Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242687;
	b=EEpJgnkYQBNHWe9nvc8jIj7HMs2PEHSj8/1LySj4J/20jeve5USOT/8dt0EVyxIttqyp
	 coNoTRPOGSt/grEamCmgL1MvzbvaOc55BUdreZam9ULqh/mycfCfmIIpMxn8TG251nj0M
	 LRcLRkzOCRe9E7x7Nu6BKVy5kp8NTmbnR/EIjG4+cttxXKkGMqSm/UZPwzwxpvT3//J6t
	 fyKcy2gnbZe1YbETI/UpVIuV/nnP4SEOBMCLurX/2qSYowzZmBq4ryDsRsWjfjoRkGBch
	 QJygsrSLUuTUMao6kikhvJhZpeaOjO2m/OBxZuT7X7ysFwSxdg4vo26RVt4F1bQEqiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242687;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=7vmLERfGD76whB6hILQUqqQo9S4q4ZlcNJ1AUlRZ+Ms=;
	b=dHtAhHsL3xGCGqLKWUHIW8fmiwJPTw0zJAcUt8AgEDFzjXsyyx3q29U0hgMx7zznPWvs
	 HUV7ZCWBaUV8UBnB1AYhR7gN6IBJHW+FWIs9TaNIFJXxClCZE0M8kbhMEjCqAxuUgDenc
	 6KnNuU9S1G/b4RYK8HDwLCLsqd8+oEYU+0DMbojdGDke0kVwPDnwNjZThe5x3w0TA3av8
	 UPetu3fzzIzDu0GaVUBQevIVzd6c4NuRK9vfDYGr2hZyznax+y4RLpEHemOa9yEKLfHsN
	 cpgNTiI9X61N5BqKAxENGkW4zES9aTUs9giIUkCB2WJWpNkzGVAAQWBDkn9KD/hlJuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Bf5BsZQm;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541D060A2636;
	Mon,  9 Nov 2026 16:44:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 541D060A2636
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Bf5BsZQm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7vmLERfGD76whB6hILQUqqQo9S4q4ZlcNJ1AUlRZ+Ms=; b=Bf5BsZQmw7kqkyNLaJy36LCu6O
	DuhqQq7rkrdUnaBAunpnrOgxBv0C9mefE+kILiW6fL//AERC4l6xRx6Ba6r8SXrSjRRekPdlIFNZ2
	SDsQsGKykzUAWSke3vbYsnUlX5d1s9cqi7kAYXbzDvQ4E4E87HA1wicoTm/AbIlgncEXt8r5GOhko
	hTfkMTLUCBJJwdBTiv1gLH1xWheXezX+xSXJ4Ub6kneYYRaxmZWrIyRZgWBakyuBaEZtBhA6HdwFV
	wBiuwgR2QKGQyrEfeeLR4phfZwK4JAXGDAAB/64pZacvnNmiB6IfGcpXKz8ukSibwZ0aMl8rWEnj2
	YQ1YssTg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQSTo-00BlId-2m;
	Mon, 09 Nov 2026 16:44:25 +0000
Date: Mon, 9 Nov 2026 08:44:17 -0800
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
Message-ID: <avH2FWw6-N8s03Zb@gmail.com>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
 <ysxh2sfvjikoh6cw2qmk2i6p7xripwnqxkx43jj7unxop5tkiw@gws5wezjt34g>
 <au3w4xiaYbEYLTru@gmail.com>
 <xehz3f62chf5ivwbh7f5chapypp5md5vasdtsnxfwzsebontf3@roqs5cwjk2va>
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
In-Reply-To: <xehz3f62chf5ivwbh7f5chapypp5md5vasdtsnxfwzsebontf3@roqs5cwjk2va>
X-Debian-User: leitao

Hello Jan,

On Mon, Nov 09, 2026 at 03:12:16PM +0100, Jan Kara wrote:
> > Once per timeout is also how often the hung task detector checks by
> > default, and patch 3 logs the total once the wait ends, so maybe that is
> > exactly what people need? Not sure.
> 
> I was mostly making jokes here. I agree reporting once per hung-task
> timeout makes more sense.

you got me here. ;-P

> > > Is this change substantially different from
> > > writeback_sb_inodes() waking up done->waitq less frequently?
> > 
> > You mean the ->progress_stamp field? That is not used for reporting
> > purposes, right? Should it be?
> 
> So my thinking was: If we change the wake up condition in
> writeback_sb_inodes() to use HZ * timeout as a limit instead of HZ *
> timeout / 2, then we should get one report per timeout, shouldn't we?

I think so. Let me hack it up and respin.

> > It could drop the duplicates: a wakeup with work left runs the
> > wait_event() condition twice (since 84654c7f4730, it is checked right
> > after schedule() and again after prepare_to_wait_event()), and the
> > second check would find ->progress_stamp just refreshed by the first.
> > 
> > But the waiter refreshes ->progress_stamp on every wakeup, so it cannot
> > space the reports further apart than the wakeups, and those have to
> > come more often than the hung task timeout.
> 
> Why do we want to wake up more often than hung task timeout? We evaluate
> the condition after each inode so the error shouldn't be that big?

Yeah, I don't think we want to wake up more often than the hung task
timeout. That should be enough here, honestly.

Thanks for the review,
--breno
