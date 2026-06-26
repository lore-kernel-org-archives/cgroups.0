Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EE83EFFB2;
	Fri, 26 Jun 2026 10:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782469668; cv=none; b=VaZUXSgPKcP/dC7tWdNc1rQvJWvxW8fb9GHGyseTw65Z23ik6wQBGVMwaf6UzGSLrhqNI/DayxV4OKJ/ffLE8vT0IHV/q1yeGUi/6M2mEwelx47SRj2YCGF/VWWwc0Y09W8II3ubBVJJto+4BWvrx/SBxrF+9hf6zRvu/q8FMqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782469668; c=relaxed/simple;
	bh=d5uFmXyI98y9nRyOPM0/269ojXox2TE5rCPhyMeyHgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8HpeUnHf5NlHEnzGPXhhazYHdtmeac7HxPIv5pSPTo59/MaY5gCVjCsa8F1qz2WbzoxDCPZFj+B7QCS9pe2Z0dXNpcO/NQnFpKahY9T7mM8fCB8/+4vMLwLp8eFZRaM0hJYn9n5azykoemF/xcD++rzNXsERfndpYhUmAVhcDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 803FE3EB90;
	Fri, 26 Jun 2026 10:27:26 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 3/9] mm: percpu: fix obj_exts metadata charge size
Date: Fri, 26 Jun 2026 12:20:52 +0200
Message-ID: <20260626102358.1603618-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102358.1603618-1-alex@ghiti.fr>
References: <20260626102358.1603618-1-alex@ghiti.fr>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTGnYIDq9A11TftEatbke2wSLsM4U/RRnbCHpAUAIQBwHbVmowa+ke86M8Z6PPn5o7UKBvUMbr2gZWgcRiFc7ixLzqgLUvmoF1f6yq0GAxvM7ym0xa3n5f10aBqF/6aF0YuddnSkH5x50aCnRuJBlmRRybtyRnTHEtDjNABLsbF8/J37ko6Bm3zG+eW4NfAtWrkoIM0OVuVjH1i1R2t7kHuPQJtjQvB5ayDwVI8gcfE8wIDI8ctauyWpfQVDC9X4EX6LKQuBwn+BvrBeBO0dxg0WQvW3qtFakFlV8vs7Ehg02InoNEqwXY73y16xKIg4BKzVJqVRXZF2evXpKGHtjYSRICkDEkROcNVTsGp7+HvytOVWOvqCzJZvFqA9U0asoStphjFxrwjYHTun2FbrP2cY5CUFueIVGpmgGhZ4L+6TjIkJnmqViwrnMGDlAaLFCoLhoilHKmwbT9UclHSoartkKorY0R6ZvVd0TBVsbmy4Eu7EyEQeQd5BQDRpwJKKK2kecd0KDg1QZ9kzEiB2Rbnc5+Nu67xS7KN6EaDvdYpRj9ghoDeQBodD83HNzmpyh1O2Uz56gpM+Ngn5oGOk9F4GhWXeFH2ND/B/ChRfsdIrkV/6jsF0+Y4FG3t6PG7uxYaJYWTANQSlIGADiNiALI5UcEKUddASLwFeS02KeJDvIg
X-GND-State: clean

pcpu_obj_full_size() uses sizeof(struct obj_cgroup *) to charge the size
of the percpu obj_exts metadata. But obj_exts is actually a vector of
struct pcpuobj_ext, whose size, when CONFIG_MEM_ALLOC_PROFILING is
enabled, is 16B and not 8B like sizeof(struct obj_cgroup *) currently
returns.

Fix that by using sizeof(struct pcpuobj_ext) instead.

Fixes: 8f30d2660a38 ("mm: percpu: introduce pcpuobj_ext")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/percpu-internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 8cbe039bf847..d1c0a508710e 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -156,7 +156,7 @@ static inline size_t pcpu_obj_full_size(size_t size)
 
 #ifdef CONFIG_MEMCG
 	if (!mem_cgroup_kmem_disabled())
-		extra_size += size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+		extra_size += size / PCPU_MIN_ALLOC_SIZE * sizeof(struct pcpuobj_ext);
 #endif
 
 	return size * num_possible_cpus() + extra_size;
-- 
2.54.0

