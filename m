Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792510039;
	b=XjLmtvANw3gcu+VOwPXq7yYu34fswplovbhna2FOBzSxLVNM5EEBezV+UHqHsLlLYcrB
	 FD5+8qhHOPsuWdJJj9r4JoDXLAS7UZYf6J26/tQn7ueuv6a3OZAtr2dJLISVoN9391BoU
	 WmAUNulx3QH8a5vGiO2bvej0I9YzoNRLfAnE0b503OOk5x2ELoafwjXKqZ92okjJoxJju
	 hIRnRlJQi6o5OyVjMF1oNzSg6VX8si1kycEfTYfhI+uR3OEuovwCkG9kBJV0Iaj7nODLS
	 vySLj691Y/ZzHi6e0AatbuTy41Vs0l9sjIAUzwN6EfHw+J2Fd9rHuR7zwvXEv7aYbbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792510039;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=AMP8JdgNkDiR02HwTbm0bVfT+4C/h/UkSkbT7J7kPuA=;
	b=CG8BtjDbYfetRI1r/q78iXoW+jAZ+S0O+NYPmWHoo6ugMqmZvDGkKR8YE1ND1yAoAY72
	 TugA6LMnIU541z5mAw69pn8NWJ9rpAG8ktnpeWXO+fZ+SH/37aYsS+L2ZLQ883eXJDlJO
	 j5kv4Asobl86//YWPnU3AQdMO3A6k53nH8QHWwi9OPR8V0g6anHXliJlMPWGuHzJKbDbx
	 JW2ZjaDZqCaoprYufJlBVz/CDmU1uPZy1Fs0evgG6kl8DnqZ1yKyuxP9VOBJytPAyxHMW
	 a3lRoosH2LT2lbln3SLzFTP1G/vs6POOYlwaR3Uy1MIo/YVW223XLfFTRlGpc3Fbmfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=2r02bKXd;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=uu8FjPbF;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBA1606A31B;
	Tue, 20 Oct 2026 15:27:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACBA1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=2r02bKXd;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=uu8FjPbF
Date: Tue, 20 Oct 2026 17:27:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1792510030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AMP8JdgNkDiR02HwTbm0bVfT+4C/h/UkSkbT7J7kPuA=;
	b=2r02bKXdXozWpDueyORgIYxwfRMI1Ao9/3XAElBBhlV5gMYcVyo4gVjbr0dtBqDRL4GSOH
	bzKSeGq52DgH3aF/eyniApMAaO2RWJQC1aw7wah6pP5TBHjy3aejp81Umu+vBn61HIpse+
	Ohu4iaU+3c3dCDpkdXxi7Gbuf6AXW9SqpmXmngqSlqS2ugEjtBnKGqkLahp0bVoy/M3Fsu
	MEXZpEg3pbeIRdjabpeyJsIDAfK5Sx5h9ITs5tQew4HSSiQG9BnEtbL/t50fi+JPyzP14J
	42wATqH09Zuuk8gt3t7rJMcYZOwIUUKjARVS8bPd0FNm+UrIMWvVCfWGT6GRpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1792510030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AMP8JdgNkDiR02HwTbm0bVfT+4C/h/UkSkbT7J7kPuA=;
	b=uu8FjPbF7WAWVQD/GH1wBlh+67p1e0H4uQT6K/4f8AvNx0BtJsnx7f+nV4gHIb73oSnA7B
	W+6bBIuocl25n0Bg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Stevens <stevensd@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Shuah Khan <shuah@kernel.org>, Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] locking, mm: Add atomic allocator trylocks on
 RT
Message-ID: <20261020152708.3atPlnSl@linutronix.de>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
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
In-Reply-To: <20261005070625.8871-1-kmehltretter@gmail.com>

On 2026-10-05 09:06:22 [+0200], Karl Mehltretter wrote:
> On PREEMPT_RT, a BPF task-storage program attached to sched_waking
> can deadlock when kmalloc_nolock() obtains an rtmutex-backed allocator
> spinlock while try_to_wake_up() holds p->pi_lock. Releasing the allocator
> lock can enter priority-inheritance or wakeup code and re-enter scheduler
> locking.

What is it that you try to achieve and why. Why is !PREEMPT_RT not
affected? Half of the problems origin from PI-boosst.
Why has the nolock an rmutex-backed allocator.

can_spin_trylock() skips hardirq and NMI. There is a trylock on the
local_lock_t.
Why do we have this mess and couldn't we avoid having it?

I looked at the patches and there something about hardirq-atomic waiter.
Wen don't have this. I don't think we want.

Sebastian
