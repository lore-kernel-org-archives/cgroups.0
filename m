Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698373;
	b=2OO3lodJZuBuH8pmdoLGFY73L6nEbMv4M+lbbB7tbt/ToB5acrlSxcdG7lci95m65jSQ
	 nd1nO+mGCE6zsTavZVWmapI7CR4HwMA8SngpEwTHONZCGvCAfaBp0o0sCBS0lfr41drep
	 KAJogj7Wpv57/gByLJI+3PxNtX0eJiAqj0bROWXigj4byml2/9xKGCfFQ8LvvndpcJMq6
	 IjB3UGZkcj8ys6HOQwJJMLgRFu4YU4iMFYD8o/HOrZI5xmuwBfkhrjf+A1gRP2mauO3Vo
	 iJbKpeN9vAD4wKXqHBdgZv82UM2rXEn7WytVYoTbuBMg9op3c3ocYJZlYDL0ymXLEqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698373;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=8N0vEDOHENh5TCI6g+MQ642/w77B6Opk/aAqQYUAijY=;
	b=Swiciinvxe0ugwufc6y4rm8myIXm7/LttMAJECRsdKL+V1LYYeu5Lf0SnVYYUPEEa6tf
	 T5YhXyWqYXZF4NXCoDUBnh8FiG+m3JVfc0+zAebsI7kJEPRoY2UqaudBoA+0TtJgBW++o
	 RoPqKRyprRYRICYp3qXU2FR/SYsncNfzuwKUbVXVnnQF4u8XKZ1GBULtKzF1ntwPXDXA9
	 H9XrlftMVxLguNcCvy6N93Fj8sotLw/sHQ1YfrpquV0hV+L3GezCR202eYwARI9Fcz/Qu
	 Ajh73IONTAhAGu51BT49xqhROJfp5vrXVZMoVYzFv8hdU2KMx+TG5IT2T+P19bnVI4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ANS3TwtW;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A944606A326
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 09:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A944606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ANS3TwtW
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48df54150dfso1920800f8f.0
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 01:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793698371; x=1794303171; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8N0vEDOHENh5TCI6g+MQ642/w77B6Opk/aAqQYUAijY=;
        b=ANS3TwtWPuK/jnEQAQK/8kNfGrYi6sQEas8E6CyIerU8CF/jYBxQ1B4OEFsLBAuuF0
         cuPUzS9iAbmufFbUxsvHhKlH1W81AcejvqmpzRXZKi3e9XLsLkEENgPdGPL4WmmJ1BOf
         3nakCg102OmBCtuRjJk/cmZQXyPe+KAI+uI8qaR0m6H3F98ZlmT2coTfZETQbAHahjWC
         N+yPvubfz0LPqumQ3sn5UEOHhvqocX+SWy5ky70liSEmr59larXu1vneyA6PbZ7ON1Er
         3gEw3hjwoTFQvqOlw6+c73DivXgX0gx/g6F0LQFDpN9aWtvH0Mmae8rQExSq+H8QPjva
         I+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793698371; x=1794303171;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8N0vEDOHENh5TCI6g+MQ642/w77B6Opk/aAqQYUAijY=;
        b=VWJVvXSlQ6CnCb18XbX4tsm8M/+GQANaNQakPIOdhmSKjcx1PL1SJchcZjtBzZD5wo
         HKnauquQ4TNoNLGPgOBA9QILp6GIy4idy2C8g2XHejNb5+M9PF7RnrOqoobrisTwi4Js
         qi+GviqIUKvLEq+VIoZuux+l100bIr54KExgJM56O20O3KK/y1Ec0b9VeUd+1TH9xqIf
         s29hwN+NPSKOC6aw63VKQIiVrEVlBIQFVNqf6CT8cqSLTb5k2py+M/ov6bBpTw27MsM2
         8qLDo7SvONvFTaVkMfh3DIMbfJ3qywD7EXI4ZRHENpoUYI7mtUQpDC+Pq4wqrT8X+EiJ
         hkcQ==
X-Forwarded-Encrypted: i=1; AKwUvBzlnr3qiQjqePsmZXGIDD1MkRYO9iLjt8EBpMfLwdTWcRsj6lvbDZ/2txzSBsvP2Ka45DElSMHm@vger.kernel.org
X-Gm-Message-State: APuU4Z+bTfibMRZCm3md8b83qJFlhAhZ0PE+D7h313bI1ypbCiWEyGci
	5BCwBG+yEboo1P4PgKWNfRaWEj2+El4F/y/j20LW3ai4KgHjSC+uapoJVzmnTjacWq0=
X-Gm-Gg: AYBFou18naZUaHXsYVyuUsihDATPmCSQeWRoKP3E5CdULkUrgZfpfbKRvHlD8ZlPNKv
	LXFLS4fh44ewZghPo2gwJRFm23xAlxDftiuxqWV6vV2aGbcTXYuPVvR1hL/1YUjddIw5SxT4z12
	iAU4KNzLW1REaWzISuFl735OwlH5q6aBV9zeHZ99eDsMSv4U1lBRyHjPu9OecdjEYc3Uii0SLME
	THR9FuIxNUQOs3Djmc4Z1xG0RUCvMjXKWLjXnVHw6uY5K9WOx843mBxZvwlKy1J2nDS5KMyBiYX
	X4Gvnxir5Mulh00ubnoIcEXKkXCioonanR4XJar33W83eaej0BtyQ7Db3ulm0Fl57ATO2xTqNg8
	uON76zCmzbGq4afUCJruB3T71yDnSsUGV03Br9ksciLIQc3a6TtwWGrZCgN6fjr6ZR56g9Tqo5u
	NXkCNk10NN6hPllsfjL4k3Rn/rOnoaxFDdEX0Olikp+OykzzKXGIGGATPS4RMONDmz9ZXIMWcGo
	IJzSGVZMqTkKK8H9ckvsaJrDtrCjgCKUxLz8WCwriIz5w7TsK35Mo4YfkHrjtsT2xmlg4Q0E17U
	i7iB4FXsamTi6z7A9Of6gSvn8WXghlyhH1lB1cs=
X-Received: by 2002:a05:6000:2088:b0:48d:f6d2:9c88 with SMTP id ffacd0b85a97d-48e6e4f8daamr29004855f8f.47.1793698370857;
        Tue, 03 Nov 2026 01:32:50 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e86a06078sm7960579f8f.54.2026.11.03.01.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:32:50 -0800 (PST)
Date: Tue, 3 Nov 2026 10:32:49 +0100
From: Michal Hocko <mhocko@suse.com>
To: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH 0/6] mm, sched, cgroup: LRU Cache never drains when
 isolcpus are used with spinning SCHED_FIFO tasks causing page migration
 stalls
Message-ID: <aumqQX7tKHLKRQ2k@tiehlicka>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
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
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>

On Tue 03-11-26 20:59:34, Matthew Ruffell wrote:
> What happens is that the spinning SCHED_FIFO processes running on isolcpus are
> constantly dirtying the LRU cache, and when we attempt NUMA migration of the
> 50GB of pages, systemd calls flush_migrate_mm_task_workfn() which creates a
> kworker that calls cpuset_migrate_mm_workfn() then do_migrate_pages() then 
> lru_cache_disable(), and then __lru_add_drain_all(). __lru_add_drain_all() then
> creates a kworker on each CPU to drain the LRU cache, and systemd and the
> initial kworker wait until this is done on all CPUs.
> 
> Since the isolcpus are running SCHED_FIFO tasks, they never get preempted,
> and kworkers never get a chance to run until they get an opportunity to by
> returning from a syscall, and it takes a very long time before all 192 CPUs
> actually drain their LRU cache before the page migration can continue.

The idea is that they are running on isolated cpus should they shouldn't
be preempted by unrelated work. But at the same time those
isolated/cached pages shouldn't be blocking the rest of the system. IIRC
there was a proposal to flush all pages cached on pcp on return to the
userspace. What has happened with that work? I do not think this has
been merged. This should deal with the underlying problem without
introducing lock contention that might be a result dopped caching.
-- 
Michal Hocko
SUSE Labs
