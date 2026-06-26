Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B363090C1;
	Fri, 26 Jun 2026 10:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782469922; cv=none; b=JNIs8agef+W77qdhWEXA9H3waUW5nwXNL8SoSUM0cHumSUARSCnQxNNowTzyZyKt8zQ9MYcqmVjEk2nJaCJulZvMjkY8i64nHUDwLqBmdnjU2RZEMrsgjJ6SnaAEI/LLqggpdVndDS/9MZssQWMq1eAxYuQMv1QFK7OkqQWvuVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782469922; c=relaxed/simple;
	bh=78UDbSBUqDeosNCejyB63LfZWOuVcr0Dk+iqOC18HzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJ1gVmePSK6v9WFgfCgf2ZXJEhmFwxk+vBMHDcU3Rc8jRqR+uy38CGdWrZb2IcUBMZa/OkeDLKnVW6NRGz9b0IJVHcmtD5AkTQnAzcAesP1zelOhC3Op8xVu4Wt9r8WE2KwEALrF3Pt1C/0M//x8CssINU07HPttT58dINURe9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 7D70E3EB9A;
	Fri, 26 Jun 2026 10:31:50 +0000 (UTC)
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
Subject: [PATCH v2 7/9] mm: percpu: per-node kmem accounting for obj_exts metadata
Date: Fri, 26 Jun 2026 12:20:56 +0200
Message-ID: <20260626102358.1603618-8-alex@ghiti.fr>
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
X-GND-Cause: dmFkZTGdhs9xuqAzUROmmsJvsJjXlJZ0qeTIQWv1SwQGarWmGYIa0sFgvk5TpQ9jfrltusvZoPk8YdWn3PZEEalLBjdfHMe7NqNuZrhxSoChbVpy5Nep8byl3DHWVqDvp22mXFzlNO8942ydLlAkQ+L6aO+eIgnDvtvprJXn6Gk9sJGXK+ptPbEvnkFg0hCg1QwOx0jFi2oA3CD11zGmtPZ3Qj90hnJeuAwCdkM5UQT74WjOHTYJqjH6/g55DRp4gxglIvoWlT1Dy8heeGbvllTWUsmkWwtaP9Gq6rx1FN35MPiV+ZgrCHBylug5kSysqz4Bd4NnZNgsc26P0Z686fWBs04NMKCEmzctbyNgqaXJTfn5uNKc5IUDzosj4HWtZOxrYbWPFxqqaUUG+qSrWfvEKK0IK/jKDmnEy4ZvLPuFTlSk3AdCYTzQiA4x1P58y82IIQ8vKqKXJ2dpcvzkZLCHlE6UZeICAAVBU5cSm+DnwqXLFC/OCrRgR1Sj98vGzRwgV1MX5T3cxz7vmZNcz1KQJSj71DDb+cy496Vw5swT8RTUaqI7LRWiPt5VeIG1QEJTn15eremc6g6lm6C65WZNG0NqtE5mt7+AZ+oETUsY+Ks9f5wZq8mBW/e/qwEG7QBmzXcfWd0Aw4n9segjMmWa1qiWG3mahatef6M8nKMJwCoZUg
X-GND-State: clean

Account the percpu obj_exts metadata to the correct NUMA node. The
obj_exts array is vmalloc'd and its pages may reside on different nodes,
so walk the vmalloc pages via vmalloc_to_page() + page_to_nid() and add
each page's slice to the same per-node byte accumulation as the per-cpu
payload. The post-alloc and free hooks then charge / uncharge the
combined accumulation per node, so the metadata rides the same batched
account_kmem() and the same precharged page pool as the payload.

Folding the metadata into the shared node_bytes[] accumulation means each
node is rounded up to whole pages only once, across payload and metadata
combined.

Note that there is no need to bump the number of pages to precharge here
since we already use pcpu_obj_full_size() and the same reasoning as the
previous commit applies here: we waste strictly less than N pages.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/percpu.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index e9d2d3716b99..9224344d4b8e 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1672,6 +1672,23 @@ static void pcpu_memcg_accumulate_pages(struct pcpu_chunk *chunk, int off,
 	}
 }
 
+static void pcpu_memcg_accumulate_obj_exts(struct pcpu_chunk *chunk, int off,
+				      size_t size, unsigned int *node_bytes)
+{
+	size_t ext_bytes = size / PCPU_MIN_ALLOC_SIZE * sizeof(struct pcpuobj_ext);
+	unsigned long ext_start = (unsigned long)&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT];
+	unsigned long ext_end = ext_start + ext_bytes;
+	unsigned long addr;
+
+	for (addr = ext_start; addr < ext_end; addr = ALIGN(addr + 1, PAGE_SIZE)) {
+		struct page *page = vmalloc_to_page((void *)addr);
+		size_t page_sz = min_t(size_t, ext_end - addr,
+				       PAGE_SIZE - offset_in_page(addr));
+
+		node_bytes[page_to_nid(page)] += page_sz;
+	}
+}
+
 static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 				       struct pcpu_chunk *chunk, int off,
 				       size_t size)
@@ -1689,6 +1706,7 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
 		pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
+		pcpu_memcg_accumulate_obj_exts(chunk, off, size, node_bytes);
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
@@ -1731,6 +1749,7 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 	chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = NULL;
 
 	pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
+	pcpu_memcg_accumulate_obj_exts(chunk, off, size, node_bytes);
 
 	rcu_read_lock();
 	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-- 
2.54.0

