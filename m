Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE83A606A324;
	Tue,  3 Nov 2026 01:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R3cSXNEU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B781F000C1;
	Tue,  3 Nov 2026 01:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793669399;
	bh=JL0qvT8ZjJjiuievn8oHTO+mTi5spxR1dpR3Ut9PSkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3cSXNEUgnb3K9YOWjnMQqFH+EiogBKNMMLkot4qCORp6kHRUaaVhX1jCsg7RTM0d
	 F9nMpF9n9e76JMZcvCUeVOLI1GJJYz20/HE6P+rlUcTLBX9dz163Lz2Cr4WWcTBFJx
	 SSc32ghlzCrYzhzdgN2qRpBfo0/MkVgKbE732CGSlcPVMc9HMy9RQqMNWD0PtwQ9tA
	 +iz9py1Vw+1YdOefU9z+3YfR/JzCkfrw1PYU/yQLxxUSSO2E9lqbEkjVphHn3/lHcO
	 Tn89iFq3+Isg31Pvh4tCnu2qmOz7o0YHdBHoINyTS9bCr4Z0PJak+1q/8AdYOZWwom
	 Rs1wUnMZKdvEQ==
From: SJ Park <sj@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH v1 3/3] mm/damon/core: use node counters instead of flushing the root memcg
Date: Mon,  2 Nov 2026 17:29:51 -0800
Message-ID: <20261103012952.93674-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102225030.2743129-4-joannelkoong@gmail.com>
References: 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Joanne,


On Mon,  2 Nov 2026 14:50:30 -0800 Joanne Koong <joannelkoong@gmail.com> wrote:

> damos_get_node_memcg_used_bp() flushes the memcg stats before reading
> the LRU sizes of the goal's memcg on the goal's node. For the root
> memcg, that flushes every cgroup in the system. The flush is not
> ratelimited, which means it happens every time the goal is evaluated.

Just thinking loudly.  damos_get_node_memcg_used_bp() is called only once per
DAMOS quota reset interval.  It is usually recommended to set the interval to 1
second.  So a sort of rate limiting is applied in common use cases.  That said,
some users might using quite short interval.  And it is obviously better to
avoid unnecessary flushes.

> 
> For the root memcg, the node counters hold the same LRU sizes as the
> memcg rstat stats, and they are always up to date. Use
> lruvec_lru_page_state(), which reads the node counters for the root
> memcg, and skip the flush for the root memcg.

Again, loud thought.  For root memcg, users might use
DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP instead, which calls
damos_get_node_mem_bp().  That said, some users might use
DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP for root memcg (maybe it makes user space
tool writing easier?).

So, looks all good to me, thank you for this patch.

> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Assuming the discussion on patch 2 concludes to have lruvec_lru_page_state(),

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
