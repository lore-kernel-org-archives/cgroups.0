Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717930;
	b=fVzcHTFGqicPsgBh50Re8uMOuuVPHapbOlEiVi5QOUU2m/9/NbJxLjRv2IMdrePybFz/
	 LCU/skMWZmaDAR4d6Lk7jiYtArTRN0M/6EwJ4WoFW2d3xeSne/LIA8eKmyZNIayWivdg7
	 yVMInIl+k9Uuus39buQRugC4FUoEcLmy+Rc1WBNmITP0xRH6NHnFtm0BmOqzZNjsUIMWb
	 tWkJcA/skqPs/kvVq/45fMAVDgnwrziwSgncFUgegH6QD3kpBA6uan8ZJxkK/4omucm3O
	 SZl2vFSsinoUjrLGPNQwOlnd1kxE5UPql6o6pVzGXdCXRBuYbo+rcmivIRInv5NGD8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717930;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=nCgjyvSgpq9HtRRmA5g/wITiwT9NMwWO0tA0AqWHdOo=;
	b=BhK5l5Lzd0gWubFQBsetBvr2E4l/o9N737orquzu52OeJhJmfqXvRFNjfxIYY1Tp3dt6
	 BVFJNs43oNhWPT3lD+CCRpfFsfv8W6UXGRoY0XUhqZgBm01CmEDvf5qVJYFF4ia73mJ3Z
	 a3GtG2+dlbBRly/iSkKh5bfNs6NDSWyu6ffJbgOdHH3QycwVUZee9yLGoOzPRaNWxv7b4
	 nPVbpWxIbqATLaxV2iXod8ru+8hefLcx4bu4Z4XdKNyG+PxiV50k7nI7Ur5PBjGTzlgjU
	 E2mYVccJNbadW9pb6RMyHFY5HMAIY9oburCrUDU34fZeT5j+UUIJYWtrZOvEpKvBMUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJWgbDpU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4686070A80;
	Tue,  3 Nov 2026 14:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJWgbDpU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1377B1F0157F;
	Tue,  3 Nov 2026 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717930;
	bh=nCgjyvSgpq9HtRRmA5g/wITiwT9NMwWO0tA0AqWHdOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NJWgbDpULl5/IfF/A2iaAsdMvrqVRCq1dRCxgSslUT4SCbCQxEk+R0ZYD8o4BUD8d
	 GZdaUnBFknNdr9beo7nm/L/i78tSSC1a8wnFsu0sj/aGcr94UX30N4xKSMxMzM3Hmv
	 pb0CgMUzBef6Uu0HsSCrtZcj8HN9zZDdRika3LgaAiUlbZtyvncqColrWhRsY8JeMs
	 VxOdoIiWkmrGXSDk5u0NIFBEsMYeOOiJD8EUnsqtjsl2VPuxcajKtoO+r7KSIaIa4b
	 e5Q/JQ0CnebzbKZtsTKJKD1m2FPpPKkT4J2P9TYZ4ZY8EqcTSkoCqVT9nLGXlwk9fp
	 mg/y0vj9QVZqw==
Date: Tue, 3 Nov 2026 04:58:49 -1000
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
Subject: Re: [PATCH 6/6] cgroup/cpuset: Don't make a forking task wait for
 memory migration
Message-ID: <aun2qV-Jaupz0koB@slm.duckdns.org>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-7-matthew.ruffell@canonical.com>
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
In-Reply-To: <20261103075940.110308-7-matthew.ruffell@canonical.com>

Hello,

On Tue, Nov 03, 2026 at 08:59:40PM +1300, Matthew Ruffell wrote:
...
>  - task_work_queued is set whenever is_memory_migrate(cs) is true, which
>    on cgroup v2 is always, even when cpuset_migrate_mm() queued nothing
>    because the nodemasks were equal. The parent then flushes
>    cpuset_migrate_mm_wq for no reason of its own.
> 
>  - cpuset_migrate_mm_wq is a single ordered workqueue, so the flush waits
>    for every migration queued by anyone, not just this fork's. systemd
>    forks services with CLONE_INTO_CGROUP, and as soon as one slice carries
>    a cpuset setting every top-level slice has a cpuset of its own, so PID 1
>    blocks in flush_workqueue() on every service start for as long as some
>    unrelated cpuset.mems migration takes. On the AWS systems of
>    LP: #2165410 that is minutes, during which logind cannot create
>    sessions and SSH logins fail.

The end result looks fine to me but can you please separate the two changes
into separate patches? The two changes can't interact with each other, so
the patch as a whole looks puzzling.

Thanks.

-- 
tejun
