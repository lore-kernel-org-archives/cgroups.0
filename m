Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718117;
	b=UoZAzSr69jRfuzTxmFu4gUBJJP0GbvLk0VX6UiXsIfr0Nr0YedEVuObFYp212wSYbAj1
	 4dwoVT7rDuhvXqBVNqCxLERf07pETcqBiF+UJKkbeWxp9wBU2xtq2GMFCtjloWRj17APe
	 jOcq40QYgSoV8yWBQ9R6H6sivlYRzXXQakb5F5SYK26YFe6G0nTHvqLIl3lPnl53spFwv
	 Zz5cs/T0chgNZZKhb4b6gjXaf6G5kA1IvrCj39Hhw8qO+ORn/CSYvxPDPS7NqLPySVY0G
	 JR6WzU6C5h53EtFZprBN8pFMu2DqWsH64HUC7KQmNQG+wDYQFg+md6LNDGmm5sY/BpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718117;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=x+DwvzPCizDdWmjSJvWlcQRJydG6oUcS5wV4t674KgA=;
	b=ATRct9tINwpwLEmTdCTzGKKV5qC0d/FpQeR6bLrKk7KyS3CihJpST1BIots1+YE5PlLy
	 9oEDejOehhRCAYLvIROfem2A8Gp/o+2nJNKX5OUr9pKTlxOa87pEr9xSvq6Gih3GJj8tj
	 R7rALNsyuzOqYjwkMiSC3Tu37A6jvEATbZ9L6gqK43fyS0Im2Gk9vdmb1mJYU3N3KEnYn
	 CkfJHjuypQonTc7K562v8r8jOlf2xq5TWlfzzxpzGKnQWfVM9lrBoDCYilAOAK4jtBWl4
	 kaw55T6zLl2eM29QlvtU8EMxvb3gdhxYxlvRd3aM5Dct94yXQzQWAiE89vx1o44trdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nt5AkpQ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CCC606B251;
	Tue,  3 Nov 2026 15:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nt5AkpQ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B751B1F00919;
	Tue,  3 Nov 2026 15:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718116;
	bh=x+DwvzPCizDdWmjSJvWlcQRJydG6oUcS5wV4t674KgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nt5AkpQ9xzaOQ1fTYw0l5B4HfodCv0sPfD7QFVJnV2c9oEkdAzkw+NTT59o2ggnYz
	 SZbi23+yzLh/v2Wmpx5CcIEUDB/1X8Quo+88j2eLBa7Atfjqeky9v2k319KGMODtCL
	 Ftok0laG7i6piw0fW0Q9jYqWx9uBGsBs0lSJ2yTdHUS+DhfdosZx8g1F1Hs27HmGh0
	 4IhfI1cku3+T+DlOdPXavAnvm4eVfgYQX/2QigbFcpkT9b//JO6CmCEC6mB6ePeJWt
	 9zdofkU10cLS6w5myGpOLtx8+RRydr5ein+oH2Hfsg1neaOR7DpSJV2t51KkYE/IPO
	 PMvkXzaCKV5OA==
Date: Tue, 3 Nov 2026 05:01:56 -1000
From: Tejun Heo <tj@kernel.org>
To: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
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
Subject: Re: [PATCH 0/6] mm, sched, cgroup: LRU Cache never drains when
 isolcpus are used with spinning SCHED_FIFO tasks causing page migration
 stalls
Message-ID: <aun3ZGLR2sLsvG6F@slm.duckdns.org>
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

Hello,

On Tue, Nov 03, 2026 at 08:59:34PM +1300, Matthew Ruffell wrote:
...
> isolcpus=nohz,18-95,108-178 nohz_full=18-95,108-178 rcu_nocbs=18-95,108-178 
> rcu_nocb_poll skew_tick=1 nosmt=force idle=poll numa_balancing=disable 
> transparent_hugepage=never audit=0 nmi_watchdog=0 nowatchdog mce=ignore_ce 
> tsc=reliable clocksource=tsc

We should get rid of fine grained isolation control. This is such a footgun
and ties implementation details to interface too tightly.

...
> What happens is that the spinning SCHED_FIFO processes running on isolcpus are
> constantly dirtying the LRU cache, and when we attempt NUMA migration of the
> 50GB of pages, systemd calls flush_migrate_mm_task_workfn() which creates a
> kworker that calls cpuset_migrate_mm_workfn() then do_migrate_pages() then 
> lru_cache_disable(), and then __lru_add_drain_all(). __lru_add_drain_all() then
> creates a kworker on each CPU to drain the LRU cache, and systemd and the
> initial kworker wait until this is done on all CPUs.

I suppose you have fair deadline server disabled?

Thanks.

-- 
tejun
