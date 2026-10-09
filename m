Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE304A3D4A
	for <cgroups@vger.kernel.org>; Fri,  9 Oct 2026 10:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540281; cv=none; b=EFHCL27yj/FGCZTuU0e9N6YJ7UvwtW9QkIfTAezqjS5DHUxIZULgTna+4jVfvcauB07l0BITfBJrul7KEdK8LFMzNu7uuTpbRKZiHRGuApmQ7A1tbmsBNtgOvJAR1273/54Qr7nHgD43a9QDsfdp1+zj2jmcnY/5NHnvxMPBDW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540281; c=relaxed/simple;
	bh=5yLkz2OZBQ4ipEjXEN7/lCEXtkQpCiwl45030Q1M6lA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K21634kKaJZyZiQOoGd25UMC6Xq+7XIrsNnp87y0YfmfGi/W+3/Lr1kMgHWIkVYMnxJeBBTEEiyMVvBwGWlZiGks15f5OqJmuSw6HmLlFcvCiRPaEkLi0j/7+pxkHkRQQcNA+oij9MRO+/bGG/XIjyECs31IbWv6kCIiuem1ZDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mv0bXuY/; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mv0bXuY/"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so5338367f8f.1
        for <cgroups@vger.kernel.org>; Fri, 09 Oct 2026 03:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791540276; x=1792145076; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WCfrYFQWaB6ljrpcA5mB+GvPCr6ztXX1INv06kJj6BA=;
        b=Mv0bXuY/dbslJrVlIeMtcxPdMhLIu3/yZLmI50/So5GHoEeQlXlcQKfT0SUHwVk5Kx
         R+6aWsPXaKh/7fFnAtl0/YG7zxU8j2j3kckVubW399a9rtWIpvskoUxAs+X9xngQygCx
         a87s25iG26dO4mAjyHuF+kQ5cJQzgxTIO5J10VcL44URFMev9rQ5ejJNZmdKtmIVQS79
         ueEOTvGWtd0OeaYefX23YBmg4pzUxHliPw8wAeyYfjXk9OmTmGyJvy41qBBG1HPkACTt
         q1rc+IgaRF5GB88OVPs2YFDDbyW2l/GfwVAgW5E6rPwMieA0a+R+g2K8thOHn0su1y/G
         YWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791540276; x=1792145076;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WCfrYFQWaB6ljrpcA5mB+GvPCr6ztXX1INv06kJj6BA=;
        b=j7bF7Ce7vtV+BnOfulDl3FHw6m7TnYcQfQBEagFly8AaZqrOoKYob30a42BDnmlX+X
         OfUoyk492Ay33fayxQKGO4W5IWH4WtOC1wHkONPSI0phevs1icBfqACb9aiw8OQtU68u
         hEgOj31OqaKQCC790NZjL8vmdAucHv5JSy5HGOiTBsMgPnujP+w76AVNnz2XZYXFwvuF
         /HpXMQi4nZTX2/pKRtRLq48wnHUINpScC2B2c0xTOaPDq+CnIh8rr2QEIPaYVhtQ7HA9
         XKVfM7x6UjoAQIpdX8yq45syclOmohJ4upqvhcZN0Y3Uk2zNAUMuIM/eDggmxg78hiaZ
         Tvdw==
X-Forwarded-Encrypted: i=1; AKwUvByjDLc3acS5mvd40Uam9vKCBwFKo5nXOXTC8PkCiOrfz+xeF1nINvfkTMzqT7DXpUhjVub4Kp0l@vger.kernel.org
X-Gm-Message-State: AFuF++nPWbcP/We8jWTJCizuoDeExiyyNlM4IYI6GpZZYAhSbnD8K2G9
	eTKBkZkt7V/9wuzVzS5+EPxRHyfKZKHTzLd6hGodQuh50nIJ6ZsTCZJ7
X-Gm-Gg: AYBFou2V3+X+LWU1NJJCo1uyZcIKskMlbkMBjogsx49C8Ut2hoKyeWf/FydUNBWj+bM
	n+tVRIyKksDg8D/ufWi1CRw5+kVR0kLvwTeAejsKKUqYudsIhSbpv2FpcRIuGXPm2lUvT1US4Sh
	c3h4KZAKKxkoywQmMmN8X1mC3yIQ8ma/eJK7eBnv5dvR5rKwrp9KOWB/dNn2HzGuYV+BAsWwybm
	ziTB2VBMw/0P7aDuFB66PObu0k/MNv3aASgw6V9N3Uxl/nnRIsIPy3puhux1FUC0/eJvQP4wIDg
	m+gy9643DIzO580kw5G+BiU0NKTQNpZc5T9EHvupYLFraBYqoQONN0OW8vwb44B+oL/P9IlDOHl
	r2FmiV+ql1WfWFEYYCXdp/7wq/ail/weTsSqfEftA3QSATJ/n4usbPXJZf1r53Fyk0kgc6JIlNB
	TRKqSD1fstzbfDKIuKENtP1PeUnCPrjCt3s2/6DYEu/kDN6zJEpU0J7UmnmPOmWTVm6a7htdFSe
	aoaMmrSDERcwcFqRTYOe8pxIWgSrcYPswi8vsTKH1wawb3LDsQnOchIPhwiGT6DeFRFfkIFi8/P
	PAW5b/XbqyzP2muY1bv2ZoMPZ6x5RlGEaslWJm/mGt8Xf+IXLHFTRKD993weF5W/Ze6z8euiVbG
	IJh0ePODIS800uyk=
X-Received: by 2002:a05:600c:3f16:b0:4a0:2150:55fb with SMTP id 5b1f17b1804b1-4a18e44395bmr24842945e9.4.1791540276044;
        Fri, 09 Oct 2026 03:04:36 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a128-aa01-297a-7094-853e-a20c.310.pool.telefonica.de. [2a02:3100:a128:aa01:297a:7094:853e:a20c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf2caf4sm53382635e9.10.2026.10.09.03.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 03:04:35 -0700 (PDT)
Date: Fri, 9 Oct 2026 12:04:33 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Harry Yoo <harry@kernel.org>
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
Message-ID: <asi6Kj3TcCd6HAM5@gmail.com>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
 <asZ8jmWNoGk5tYce@thinkpad>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asZ8jmWNoGk5tYce@thinkpad>

On Wed, Oct 07, 2026 at 07:15:29PM +0100, Harry Yoo wrote:
> > This RFC instead adds an atomic owner state for bounded PREEMPT_RT spinlock
> > trylocks. Atomic acquisition succeeds only from the completely free state.
> 
> Please don't skip discussion stage and jump into submitting a very
> intrusive change across locking and mm, assisted by LLM? :/
> 
> I don't think attempts to tackle this problem will make progress without
> discussing and getting buy-in from (PREEMPT_RT) locking folks.
> 

Sorry, I should have followed up on the additional v1 replies before
posting this v2.

On the alternatives in [1], Alexei [2] preferred detecting
scheduler-lock contexts and returning NULL. He confirmed that NULL
returns are allowed, rejected restoring the local-storage allocator, and
raised the RT unlock/wakeup objection.

I initially tried that detection, tracking pi_lock, rtmutex wait_lock
and rq locks. With RT, lockdep and slab_debug enabled, task-storage
allocation under an independently held hrtimer base lock reported this
cycle:

  hrtimer_bases.lock -> rtmutex wait_lock -> pi_lock -> rq->__lock
    -> hrtimer_bases.lock

I don't know whether my changes introduced or exposed the dependency.
The timer lock was not covered by that guard. This was a lockdep warning
and the workload completed.

I then tried atomic ownership in v2 to avoid that unlock path, at
the cost of IRQ-disabled spinning without PI boosting of the owner.

One possible interpretation of "raw_local_trylock_t" would be preserving
the non-RT local_trylock semantics on RT for short per-CPU cache
operations, with allocation failing when it needs an rtmutex-backed
fallback.

Would that be worth exploring? Sebastian suggested
consolidating the existing local-lock variants first. What should that
cover?

For arena user faults, backing-page allocation failure returns
VM_FAULT_SIGSEGV on the RFC base. next-20261007 preallocates outside the
raw lock. Failed fallback allocation returns VM_FAULT_SIGBUS. If
restricting that fallback increases fault failures, is that acceptable?

Thanks,
Karl

[1] https://lore.kernel.org/r/arIY0wMQjCCsqidI@gmail.com
[2] https://lore.kernel.org/r/DLO3RV3IQUOV.21BNLF4QS9T4W@gmail.com
