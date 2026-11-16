Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794824483;
	b=tKOUd9clHg/Jn/wJDhjhPiIPoRAPpkW8OZ7CX6/nK4ymk2sSMQa5Mg354J7ynPJR00oI
	 osjaBCqCnt9uV8oWTKi/ht6l86qjW/y3sz0pyskyBggwoBWMkrbdlweL/TeBBkuptZCoe
	 xLMU8KmvmMfjOPFhTZo8J1rwlFcvUsLthCTwDPfs3+/d5DAX75MTuTsIMkGOUBMaA2iL0
	 XOxeNFoq3sFXDEyigLwOKSNnrtYHxTt/57E8msT6LakNUymbruGt3NdEcW7VQzR8ZlIaN
	 8IEUzXWEL7LZS83xux7B1kngSNPqrk211XgGiy9yGHo8KweOFii2N3wWamCN8neEf0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794824483;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TtB6NVTta0tvsTqH3AzztjW+y0F8Qfmd7U44QxV+Lc4=;
	b=3HgeZR8tSq0hMeUCUsCBsj5fTPSqk5VH/V7aU8fYzU0L9aibV8P29eolpOCAf3T5CViA
	 LkYAQ4xoA/8W3XvnxIBV9Eg8/bKv3SR4ib+uW6hxwYiKbdXitFP/O2t3CTlY7bAHrqL2D
	 x3Rv8cEBvOp0tFzakxQ70yZEHpSFPfdZQruK6APfJrStvkJq6i1KrJ0LQLa53kMnbVp+t
	 f9xjayw/RBgwO4dAthK+gxfMYFcLkQe867k1zxYu/cSdhpplH7Vnm0QEIgrabmA6cMZnm
	 ZBZdVOJo+iIw5qH0xFZDKByMyLMWctItRg4RJcRkKZG5CyBxIMPHaBzqDnt5zK18Jmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZY6mCzKY;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qccX7har;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7112606A32A
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 10:21:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7112606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZY6mCzKY;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qccX7har
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794824481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TtB6NVTta0tvsTqH3AzztjW+y0F8Qfmd7U44QxV+Lc4=;
	b=ZY6mCzKYslCYVCgoiHSIHDP2myLAx44R4RcbutjRjjKpdhoxsbYjQyMas6Rc1LYlxsML6b
	J4fH+hbHYEOS1gF7M8+S4UlrQD14Fx6Hn3cz4/LAnvHSQiiOMLX0tZKKee6iUWVwzCupAa
	/z6xAqHMwhMO+mM0ETrE3rGz/JkyvDg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-z6E4n0JGPX6bHYZ5p3BPpg-1; Mon, 16 Nov 2026 05:21:20 -0500
X-MC-Unique: z6E4n0JGPX6bHYZ5p3BPpg-1
X-Mimecast-MFC-AGG-ID: z6E4n0JGPX6bHYZ5p3BPpg_1794824479
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-49166c8a60dso2299536f8f.0
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 02:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794824479; x=1795429279; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TtB6NVTta0tvsTqH3AzztjW+y0F8Qfmd7U44QxV+Lc4=;
        b=qccX7harUwf8eiayr+DfzPEQNO8jtBu0G+uJB5TxwXa2l30hixqgX8IQihn/zG3p8r
         HinAWqG7/9eDvncHZIxEd9PMMgvtJgrOL4NpfP8hQO64ilyrx2Q7KErbo5E0+ixYqpoC
         woZDv40aalCfcg9ed56J1SMUDiua7kEyFjc5w0LN7AXS1hV7JYix3yWmMRoIM219PUVK
         g00YxpfaEWiNOFAIX1NK6TlH31PG4Y3p42EujrYRyfFgf+MId6UJP974D5XgG2AUuCtq
         c47WKJNQ0HeL1trBXI/OavSD7hnR09k+Mel8LAeHyqxrlXOZgdfcednP7c3xzBs0RvKq
         9A6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794824479; x=1795429279;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TtB6NVTta0tvsTqH3AzztjW+y0F8Qfmd7U44QxV+Lc4=;
        b=LTK646RKiST19wEbWW5T7h7EzhoBLAOMFg9qkDpcMR0shKuEARQr6odyXfbtWLDEGk
         ECFzoRWd77ys+XnQ5caIgQ5KvAWzzdrQvTO5rku7xuTrZcGz2Somq0JAoTrQIHh6jGr6
         XHYA+QSXJafdmjhiw0eAZcjW2Yh9/x1nj6Le5W3da2urJPtjD+oYfoE04+W6210r9nlg
         8G8L0qJI94tLyQgZC6UUirYTA9S5muchA8Vsa0yiVHxyq5OA8UHcl48NRmiktAzzpr9C
         XRufZ7qXvNDF+r0y+AbyOMZTIXyNm3+TtXj57h3sOo0X/JaXmOpzj4aSs9qfUEcAaRrk
         JQ4Q==
X-Forwarded-Encrypted: i=1; AL+hErFdeOg3CFrLiVdp3YuKAUQwj/h92GuDqLiTsq3XWc64P8uVkrPS/hK20ijWBq4uTjQUZx7Q2mc7@vger.kernel.org
X-Gm-Message-State: APuU4Z+vte/Vb1MnxhvB4Fz5K2ff1gic8l6S5hk+SJOzgjzdRhh+zI04
	ve9+JfLYYOjsVC+s/6HyIMM80wpK3T8ZtuovDWjKmyhIOWdFnImXHD/9n7Q1bEvrbRYjPep4QCw
	VG2QcscPQKqerB4DK9oSI2WGLeUAojbZMfSBuGy2EIdgkesIvCeG72dbdLEc=
X-Gm-Gg: AZFdTZfjs+cid3HXO8SFZ0pZNQOPAvjL0uXJXmJIl4UVpYfbF4Lb86uS6FjRT2p/BOp
	n7jN7Qwd1g8BtRMVN0FRVhOdfGWTZplpfiKQgnI1MwiPQKFvhJOp+Spu5ULyYeJl3Dd+TwM108N
	XfYQ2sc85gHpYYHcaSOkJQARVw2qo3MfEtKfbaWsBhYllMnX0X4PK+meaZThVMjNbZvRiFkKGFr
	GiceVCH5zd0yT7OvbtqIPbNKhW53qzffIw7f5RSeOnFM5x9YPvbRPHGWCbshCfpeOu5rlMh6Kba
	03ij9cT/b2s/DTem8rVObTA+nRbTuovLjcIRSQIbygZcVXDcWMWRTgFXqyfembL2kK8vFz98Cs+
	Fm26k0DN1aBxOyYlDSnZXyXZ/pXJHXYfs8BSjqG+WjpZHhSM6Whpn9HQzYlg5X5riSL+axUAtFr
	1X96o=
X-Received: by 2002:a05:6000:3108:b0:48d:f9dd:e3de with SMTP id ffacd0b85a97d-49c7353c415mr20874714f8f.45.1794824478817;
        Mon, 16 Nov 2026 02:21:18 -0800 (PST)
X-Received: by 2002:a05:6000:3108:b0:48d:f9dd:e3de with SMTP id ffacd0b85a97d-49c7353c415mr20874640f8f.45.1794824478326;
        Mon, 16 Nov 2026 02:21:18 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60116323sm20991495f8f.32.2026.11.16.02.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 02:21:16 -0800 (PST)
Date: Mon, 16 Nov 2026 11:21:12 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
	vincent.guittot@linaro.org, linux-kernel@vger.kernel.org,
	tglx@kernel.org, will@kernel.org, boqun@kernel.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it, mathieu.poirier@linaro.org,
	longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
	bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
	m.szyprowski@samsung.com, kayracizmeci@gmail.com,
	weihengqiuu@gmail.com, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v5 13/29] sched/deadline: Keep departing bandwidth across
 a root domain rebuild
Message-ID: <avrZGPNdCwZMd3B4@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-14-mathieu.desnoyers@efficios.com>
 <avRmoK08LoIeySBL@jlelli-thinkpadt14gen4.remote.csb>
 <c3e7054a-486c-4e5a-a646-eee42e815ce4@efficios.com>
 <20261111161912.GP1779021@noisy.programming.kicks-ass.net>
 <83b2244c-f68a-4af3-9c8f-0fabb4eacbb4@efficios.com>
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
In-Reply-To: <83b2244c-f68a-4af3-9c8f-0fabb4eacbb4@efficios.com>

On 11/11/26 14:19, Mathieu Desnoyers wrote:
> On 2026-11-11 11:19, Peter Zijlstra wrote:
> > On Wed, Nov 11, 2026 at 10:35:17AM -0500, Mathieu Desnoyers wrote:
> > 
> > > Measured in a 64-vCPU guest with sleeping deadline tasks:
> > > 
> > >    tasks    today: rebuild, longest irqs-off    single list, all irqs-off
> > >    1000     0.75ms, under 0.1ms                 0.12ms (0.19ms worst)
> > >    10000    7.4ms, under 0.1ms (0.3ms once)     0.9ms (1.2ms worst)
> > > 
> > > The rebuild itself is 8 times shorter. That comes from updating the
> > > extra_bw of the CPUs once per root domain, not once per task. But the
> > > longest section with interrupts disabled grows with the number of
> > > deadline tasks. I do not think that is a step forward for a real-time
> > > class.
> > 
> > This is domain rebuild? Do we really care about performance there?
> 
> My worry is not performance, but rather the contribution of this
> "iteration on all tasks" on the irqoff latency of the system, which
> is relevant for RT.

My take, of course let's have Peter keep me honest here. :)

> What I don't know:
> 
> 1) is 10k deadline tasks something that we should consider as realistic
>    for sched deadline, or it's way beyond practical scale ?

It doesn't seem a very realistic scale to me. Yes, I've used this kind
of numbers in the (far!) past when running experiments with DEADLINE,
but I can't think of a real workload reaching these numbers.

> 2) is a irqoff latency of 1.2ms (rather than 0.3ms) something which is
>    relevant in terms of irq off latency on a preempt rt kernel, or is it
>    in the noise ?

Very relevant I'd say, but 0.3ms, unfortunately, very relevant already.

> 3) are those domain rebuild expected to happen with a live RT workload,
>    or are those operations expected to never happen on a RT system under
>    real-time constraints ?

In small systems, single workload with few housekeeping CPUs, I would
expect the setup to happen only once before the workload is started. So
no worries here. But we seem to have people interested in consolidating
multiple workloads on big machine by, say, using containers. So, in this
case there are several exclusive root domains each running its own RT
workload. It would be undesirable (to say the least :) that a
reconfiguration of one (or a subset) of such domains could potentially
introduce latencies on all the others.

All that said, I now wonder a couple of things (which can be addressed
separately as an RFC if also Peter agrees we don't need to tackle this
right away):

- The 8x from updating extra_bw once per root domain instead of once per
  task does not look like it needs the big lock? Maybe it's a nice
  improvement we could have on the current scheme as well?

- The deeper issue the scenario above exposes is scope, not lock
  granularity. I wonder if a rebuild really needs to re-count root
  domains whose span and membership did not change. Maybe some kind of
  re-walk of only the domains that actually moved CPUs would shrink the
  scope making reconfiguring one partition a non-event for the others?
  Again, we can think about/tackle this separately if it makes sense.

Thanks!
Juri

