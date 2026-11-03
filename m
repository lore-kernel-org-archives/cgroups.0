Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715025;
	b=ia+FnL2LI3nzuVAhvDAnal+hCh3Wxji6tPIM/Pins7C+YJT5QBVnfomaQO2mKZ7ZKdQi
	 iEShNxFEKPk4yQKIYncyW7mNgvsSfehkn4SZ6GHbGtlLUKVjydgNgXMJQbrerVL49j1EB
	 z1lmHBN+Jf9tEnmAZnuxKza5Kf+pSbrV57nwyM9UfB1zYzQ1AewQqg4w68P3Ae5zV6JyP
	 TCGikOoxxIkzh/X2VJGuNhwZ62eg9ImHU5vbPyLj2RImYmBQeYCsloe63B5qE8cUH5FVF
	 iGVzVOK8GY6PN9to/HPpHxmM7eJduLNkVmi5okJf6u2HKy8MV8svMkobINiXLornvKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715025;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=9hcT28SYX76z1COvWorzxu+1gkA4oj6GNwI2cd7zGC4=;
	b=ve6nwXNB/yTTk1tKsUllEugm2ATxOxhYFj3TyYg2DK4BN8w6XoWxh2XCla82iQRQxXnY
	 n3yVuF4TjF18WkwnUq4rRJgBxpIz3VQK6GRsf5OROzajO4RV54HAV4D8xRKDr5aeMT7wW
	 xUuUSCtIJZq4j+vjwNrF/SvMir1vpQN732KZSOi4CaGKqekQ0WKWlr6UDf565c1whnmkJ
	 8vtX2T20nrjVPfRyWnCeigX4KFWN70zmpPf2f7fPLwhOF48r6fSppRrtVg/FFgj6iLNaL
	 Qwppbx/l9VyFkXQzGg7paBGsqfZLbGTSJXwWl/roTRujjHrZfyaWqmqJd79QMlJo8ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A8gG2FyS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F88A606A32C;
	Tue,  3 Nov 2026 14:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A8gG2FyS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C32D1F000C1;
	Tue,  3 Nov 2026 14:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793715025;
	bh=9hcT28SYX76z1COvWorzxu+1gkA4oj6GNwI2cd7zGC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A8gG2FySIrvGccJDt9QVUN41xO71+6Rpf7aiyxt8Vsopa/Ys8hBvt1hDZeBlS/PGw
	 MOt8BcnF/W4r1s15z+9Q6nzud+DWuRPuIHnctKYism3LQZOnWs3vU+zGKDYcGAak9v
	 i1JqUhBvQ5kbpMtFLU6xUwyGov9lzqLdMvTVOsorWieMgO07vFjRnAf8TphXqmT54a
	 fGU5gWTkE4FlbUGGSThdSpyyACGOdEcur0TIARvk+d+UVbVw5+sbat1Ht0raY6TNIJ
	 eZtyJEUng8T8aAiarrufke9huCyGceFpE9bK2kxHfRy5JVsGTTX+UrBQ3G6s7LkukY
	 Bnv6IKVnB5Lwg==
Date: Tue, 3 Nov 2026 15:10:22 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Matthew Ruffell <matthew.ruffell@canonical.com>,
	Leonardo Bras <leobras.c@gmail.com>
Cc: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH 4/6] sched/isolation: Drain per-CPU LRU batches when CPUs
 become isolated
Message-ID: <aunrTtH00__Xi7PW@localhost.localdomain>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-5-matthew.ruffell@canonical.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261103075940.110308-5-matthew.ruffell@canonical.com>

Le Tue, Nov 03, 2026 at 08:59:38PM +1300, Matthew Ruffell a écrit :
> From: Caron Wills <caron.wills@pulsar.com>
> 
> Isolated CPUs no longer batch folios in their per-CPU LRU caches, so
> that __lru_add_drain_all() never has to queue work on them. Boot time
> isolation (isolcpus=, nohz_full=) takes effect before any folio is
> batched, but a cpuset isolated partition can be created at runtime and
> the affected CPUs may still hold folios in their batches from before.
> Those would linger until the CPU happens to drain locally, and the next
> lru_add_drain_all() would fall back to queueing work on the now isolated
> CPU, which is exactly what must be avoided.
> 
> Drain all batches once from housekeeping_update(), right after the
> HK_TYPE_DOMAIN mask has been updated and next to the vmstat and memcg
> workqueue flushes that exist for the same reason, so that newly isolated
> CPUs start out with empty batches.
> 
> Link: https://bugs.launchpad.net/bugs/2165410
> Signed-off-by: Caron Wills <caron.wills@pulsar.com>
> Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>

There was this patchset:
https://lore.kernel.org/lkml/20260519012754.240804-1-leobras.c@gmail.com/

Leonardo, do you plan a v5?

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
