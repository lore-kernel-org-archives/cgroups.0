Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2A13AAF50;
	Wed,  7 Oct 2026 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791393333; cv=none; b=Is7QaYrgJqMcTBhxSjmRklhzDAZ8A3rUe6rgN0mgi86YtFgQYXNznWjJvl08oFlpMF5W5RnAuTZAKGILB1K+3jUyXdj8udLOd4qbAMaLxOkZL8rxRa8SOF47x8vv86/AlkD0Qt2hu9xD2GnRp872LRO9P94D8Q8+gW/pWGO9uwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791393333; c=relaxed/simple;
	bh=l7ksrUuuCrFADahNiGgjjX0cjZTD0/LzwDWvKyN3YR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ke2QGcJajGAL+qewQV+vOksuhde0puJmzULxQ15vMDt6A9Q5a6op6NykRR4daH3LHpePhpOe38I1bCeUQ2K2OHkz7v4jfiwq8criG4rmeQDI5FHLm9lIBqyBiZqitQAaS/y8wyjL2TEW19yV3sBIAWKImCODSGodg3RwpmcnRAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BqcVsecx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BqcVsecx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EB31F000FF;
	Wed,  7 Oct 2026 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791393332;
	bh=IKPv1AXkbOVrLzSJbysUwydgPgY8ZEOPRGlNsK+wMds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BqcVsecxmXNy4fg5mqGk7N0ypwHtyajS81nsbXd5i2Wu2JIBduH8S6XXVmRPLmT3g
	 HKoSujXLfVVRD73FwlUyDSd4AOVs1oJDfsy3KwTF1RdwfXDRYgxe1P0uLaXkRlJ3jE
	 lzsYtMv8NcvuHKlhWPA/VZFDRk5O4/3MfNIfxYhfUSD+9c3plZRiyFJCkjExVJYfsr
	 IpcQPdJRGzG0qB3tzsOqSxtGfjOa/QC9cwlOkWIZvd046tDwLJDuGuQg25VISH2BPO
	 g33ELEp6mj95IliGKNd/jRqTK5yLbX8wtTIqd2/p8jAe0hjq/rZ0pfdOEMZpRX8rlR
	 YMjMUcStMfhQg==
Date: Wed, 7 Oct 2026 19:15:29 +0200
From: Harry Yoo <harry@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Stevens <stevensd@google.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] locking, mm: Add atomic allocator trylocks on
 RT
Message-ID: <asZ8jmWNoGk5tYce@thinkpad>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005070625.8871-1-kmehltretter@gmail.com>

On Mon, Oct 05, 2026 at 09:06:22AM +0200, Karl Mehltretter wrote:
> On PREEMPT_RT, a BPF task-storage program attached to sched_waking
> can deadlock when kmalloc_nolock() obtains an rtmutex-backed allocator
> spinlock while try_to_wake_up() holds p->pi_lock. Releasing the allocator
> lock can enter priority-inheritance or wakeup code and re-enter scheduler
> locking.
> 
> The first RFC [1] rejected every non-preemptible caller. That prevents the
> deadlock, but it also rejects BPF arena allocation and faults under the
> arena's ordinary raw lock.
> 
> This RFC instead adds an atomic owner state for bounded PREEMPT_RT spinlock
> trylocks. Atomic acquisition succeeds only from the completely free state.

Please don't skip discussion stage and jump into submitting a very
intrusive change across locking and mm, assisted by LLM? :/

I don't think attempts to tackle this problem will make progress without
discussing and getting buy-in from (PREEMPT_RT) locking folks.

> A regular waiter sets HAS_WAITERS before waiting, which prevents a later
> atomic owner from barging. Atomic release preserves HAS_WAITERS and does
> not enter priority inheritance or wake a task. Preemption and local
> interrupts remain disabled for the atomic-owner section.

-- 
Cheers,
Harry / Hyeonggon
