Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBB63AAF4F;
	Fri, 18 Sep 2026 08:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721654; cv=none; b=Ox49SGcBssb+FX7H/LeKBiHVG/shKPOL05r5oaEz2utxTiuYxbXzoRLNPl62BPO16l55YkQ8NZuTOoc2OzpBeEZW0DYuuKj/2GKNaOlALKLgxz8sNlTKnSw9rIvKKsSg/5GjrWMqptAuQv+UfTCqW+nvG9ouUcQDN51n2ae3Eag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721654; c=relaxed/simple;
	bh=l2GgfsX40UJpQL1CyGaHv1TFodoR33Opdo7qAWZ0KZQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RzTBwbfAhLXxBiJ/xtSLgGRRPvOwTaHgqoQNvTy0gksQDpa27RppDslgZ0IvxqlbTW67w08KqfpRwAnCtP/C8SdlJfZXQv5LJm/b1Hvy88pFSmW0RdFnJ/mbs9Rb2x7tUMajhWe3wGjfTCH+CTQVnh+EWMwkPPHWd7g6r7Lbfsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oVCQU6QN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oVCQU6QN"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E42ABC4AF49;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789721653;
	bh=l2GgfsX40UJpQL1CyGaHv1TFodoR33Opdo7qAWZ0KZQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=oVCQU6QNMu8SBg+S5/FFO8AIAhCIF2gNftQd0+NAn/X8ZLRZgqA193P4Qic9v4VR1
	 hWQkoSUXIBanm6p+9b1zTeuj1nW4/6VkDFhhCANnBkpMTZ+aCVMWaarOLzRcBzi4jV
	 mJC2s6v82imYa/MlA9UZznRqUd17kvd97KOpqSXxRZF3Nbi9y7yd1+LRNUKK7Z4/NW
	 8se2Cu0WxuksMUsD+0e+qYbRHJ0jXqUSwUosKMZZRyZgJhqjhOzkrx+FzMYEq9XhNk
	 De3+y79MHQQhgrzS2bvxgVAK1p3HIXyBvzQ8aDjqkI6qE3gq80HOYnmSmiu62G7llF
	 ikptf831WvWVQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D159CC982D2;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
From: Jingxiang Zeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 16:53:46 +0800
Subject: [PATCH 6/6] mm: memcontrol: clamp mem_cgroup_get_max() to the
 combined limit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-descriptive-name-v1-6-dfcfdd91b456@tencent.com>
References: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
In-Reply-To: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Jingxiang Zeng <jingxiangzeng.cas@gmail.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org, 
 Jingxiang Zeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789721651; l=1734;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=zhtOFhKxtUFb8xp+y1sRK9RNl80hp/9T+5xQLqfkz8g=;
 b=EL4RDYrjbrEVE0Vr7y+4cIOSQgOIfXScAu7h3KFs+GeoFED9JQADdqJOi0z5dI/RGqwmZiadl
 oD5iJCJEyvMDmM2LC4+vXp+Pk0BjC/J109Snq3XrqY5aSU7jeIHLraO
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: Jingxiang Zeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com

From: Jingxiang Zeng <linuszeng@tencent.com>

mem_cgroup_get_max() reports the memory ceiling of a cgroup.  Its
default-hierarchy branch derives that ceiling from memory.max plus
memory.swap.max, which overstates the reachable total once a combined
memory+swap limit is configured: with memory.max at 32M,
memory.memsw.max at 48M and 2G of swap online it reports about 2080M.

For memcg OOM, constrained_alloc() stores that value in oc->totalpages,
and oom_badness() scales the task's oom_score_adj by
totalpages / OOM_SCORE_ADJ_MAX, so an overstated ceiling weighs
oom_score_adj far more than intended inside such a cgroup: in the
example above about forty times, enough that a task with a negative
adjustment stops being selectable at all while a positive one is picked
long before its rss would justify it.

Clamp the result to memory.memsw.max, which is what the v1 branch
already derives its ceiling from.  The limit defaults to "max", so this
changes nothing until a combined limit is configured.

Signed-off-by: Jingxiang Zeng <linuszeng@tencent.com>
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9e8a176e7afb..e229de0d35e0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1919,6 +1919,12 @@ unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 		if (mem_cgroup_swappiness(memcg))
 			max += min(READ_ONCE(memcg->swap.max),
 				   (unsigned long)total_swap_pages);
+		/*
+		 * A combined memory+swap limit caps the sum of the two, so it
+		 * is the real ceiling once it is configured.  It defaults to
+		 * "max", which leaves the value above unchanged.
+		 */
+		max = min(max, READ_ONCE(memcg->memsw.max));
 	}
 	return max;
 }

-- 
2.43.7


