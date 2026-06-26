Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3CF1A9FA4;
	Fri, 26 Jun 2026 10:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782469991; cv=none; b=Tl7mokml9qLh0NII6c4HY2tsCJHBZl5ex1I5WO5MLsN1JCnzpOfQJgDMaeMN2OvsDaccE3JurgNRwdcAhRS0jwMGZFe6RE7Sts6NPWGf584SDtgFMf4ju9qbiatdO+4P2OhGGTjH0qYkKSBRB5eNNSyT2qDQ9u+enKFD75s51+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782469991; c=relaxed/simple;
	bh=qN9Xt7aL3Es3fX04ON6ryHDR764FxOc0BY1s8Ae6l0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DieVetUST8pw8c/1T+a2YkQcmoCs7DQ0Ee/Ldg3EWnQoM1Iss5hqLNiF9NG07HTNi1LpT3ZsOWBwm3Bi68eQz2hkADGj6J/wqJ13mx98NCKE78a0sus5OSN/S4KuPOUvliJmtDM3F1P0WN9kqau2vaayd+DxZ6/Cnlm0k8FgHQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id CF0FA3EB86;
	Fri, 26 Jun 2026 10:32:55 +0000 (UTC)
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
Subject: [PATCH v2 8/9] mm: percpu: skip the per-cpu node walk on single-node systems
Date: Fri, 26 Jun 2026 12:20:57 +0200
Message-ID: <20260626102358.1603618-9-alex@ghiti.fr>
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
X-GND-Cause: dmFkZTGdhs9xuqAzUROmmsJvsJjXlJZ0qeTIQWv1SwQGarWmGYIa0sFgvk5TpQ9jfrltusvZoPk8YdWn3PZEEalLBjdfHMe7NqNuZrhxSoChbVpy5Nep8byl3DHWVqDvp22mXFzlNO8942ydLlAkQ+L6aO+eIgnDvtvprJXn6Gk9sJGXK+ptPbEvnkFg0hCg1QwOx0jFi2oA3CD11zGmtPZ3Qj90hnJeuAwCdkM5UQT74WjOHTYJqjH6/g55DRp4gxglIvoWlT1Dy8heeGbvllTWUsmkWwtaP9Gq6rx1FN35MPiV+ZgrCHBylug5kSysqz4Bd4NnZNgsc26P0Z686fWBs04NGZ2L6BOqlCYjKvy0RPl7Thgt+4EKQYopbxzDs7aRSVnv8Om2E7KFTJqyW49SFwExedbRztVQ3o3Mx42iJb/e5jWK2J2HP0hZ8f6iwzaeOrYp24wuOmClFvrWLD0Vl4qKtHrID2ph3in0idGpyU1i+AnVA9ZmliVPBjveNKHVapt32F7vtuOo5Gr8AZ+yUGd3ELG9ZiGkMLsESU6QpYSR4Z+V/fA2nWJNczIPh54RZtlsCY6gKvvfZI+HtGQP2Mil6Dk60YBYJdUlCDWI2Ymw0Ya/Rwr3g0qWeGny0xO8mX/7X33UudNXMYp14pkhpFjJdky320ibKb7wdMNa3KUXNA
X-GND-State: clean
X-GND-Score: -100

pcpu_memcg_{post_alloc,free}_hook() determine each backing page's NUMA
node by walking the chunk with vmalloc_to_page() once per possible CPU
(plus the obj_exts vmalloc pages). On a single-node system that walk is
pure overhead: with only one online node, page_to_nid() can only return
that node, so the whole allocation footprint necessarily lives there.

Add a fast path in pcpu_memcg_accumulate(): when nr_online_nodes == 1,
attribute pcpu_obj_full_size() (payload + obj_exts metadata) to
first_online_node and return, skipping the O(num_possible_cpus)
vmalloc_to_page() walk entirely. The result is identical to walking the
pages, since every page is on that node.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/percpu.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 9224344d4b8e..9a735d01b23a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1689,6 +1689,18 @@ static void pcpu_memcg_accumulate_obj_exts(struct pcpu_chunk *chunk, int off,
 	}
 }
 
+static void pcpu_memcg_accumulate(struct pcpu_chunk *chunk, int off, size_t size,
+			     unsigned int *node_bytes)
+{
+	if (nr_online_nodes == 1) {
+		node_bytes[first_online_node] = pcpu_obj_full_size(size);
+		return;
+	}
+
+	pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
+	pcpu_memcg_accumulate_obj_exts(chunk, off, size, node_bytes);
+}
+
 static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 				       struct pcpu_chunk *chunk, int off,
 				       size_t size)
@@ -1705,8 +1717,7 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		obj_cgroup_get(objcg);
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
-		pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
-		pcpu_memcg_accumulate_obj_exts(chunk, off, size, node_bytes);
+		pcpu_memcg_accumulate(chunk, off, size, node_bytes);
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
@@ -1748,8 +1759,7 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 		return;
 	chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = NULL;
 
-	pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
-	pcpu_memcg_accumulate_obj_exts(chunk, off, size, node_bytes);
+	pcpu_memcg_accumulate(chunk, off, size, node_bytes);
 
 	rcu_read_lock();
 	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-- 
2.54.0

