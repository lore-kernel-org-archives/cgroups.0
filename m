Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABD0473C88;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788253097; cv=none; b=ISm/gAamQeQTOCSxgwLvRXQgIs76sLAzOSNGJsqVe9WkuhmfVefiOA/LBcSq/lD/o0UrRjW0lfm3LyvXyfkoMBsEdm7AMJJcrA01wGeQmmT+nwCnNGHyU7osCASXSv8D345obivIrLP2Jg4M0W+yDsFXRExhimky45AmljtDxtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788253097; c=relaxed/simple;
	bh=KlUxJ5Oj10Jo6f53V6E/JY8gDtVIZbewdVdCgVfLshY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WQjxY6FQEuN5YPCB5u3287IONQpb7T24oARyb27AN7/ltG/fJqGlAS1uLlWHIik6CXv4em5cvg7h25+PT4jP9I57/QYjY7xsPGgEaZCbD9wH2npQ0RLAgKvByxGuq48jbd5PjN1vrH/K9/NK6Nkqud8oD0mIbEJHhM0zK4Q81eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+wPWbMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+wPWbMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA886C2BCFA;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253096;
	bh=KlUxJ5Oj10Jo6f53V6E/JY8gDtVIZbewdVdCgVfLshY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Q+wPWbMJCk+meNviZObyUyWu0S1q5aygcJ0vIBA5TP5zHaOm4TplJAiH4BpPFySeO
	 jXDscHzc0zAOG/HMcwRWXD9XpaWU93ZFF0tfmWiw0bJ01q7Uceqo3IIq7xd/WZuxB9
	 2swdeXcjeKwomMGwC/lknTFwPgKJfI7c7T+t4n/aNYeh79wtPAmtVgF0ldq5pYhaXl
	 zghGJbbDc7WYzAwYaqBJsvT/po3TeYmWpCJJ6/qmBVrboEDpdyYxkxcnC9pRBO6LIb
	 VMVqTb+uDMcXtZ4aPdts5DLvfNV9kFrqi2EdAlj0GaZe/2w3bF9Vh9tn8+amJ8MHri
	 2tz4YIm78FBEA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B06C61DD3;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 01 Sep 2026 16:58:00 +0800
Subject: [PATCH RFC v2 1/6] mm/memcg: add a helper to kill the memcgid on
 offlining
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-1-8edd7f7a7251@tencent.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=1251;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=3jIkwaCFjFq8QjiGq9DEwjO0Gl2r32Hxoi06xqqEo54=;
 b=fFy5sTfWuAG/5jEHRJE44WgGDDn7U5jjh+8LxOBk/3EumTxFbZ9fB/Db50YLW6h5pywsH36vd
 pgSY2DJLajRDGHE5DuQDgcZ12R0BvZh2CcatUZ1nsRPAiD576IfDQcW
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

From: Bingfang Guo <bingfangguo@tencent.com>

The online state holds one reference on the memcg private id; it is
released when the memcg goes offline. Put that release behind a small
helper, mem_cgroup_private_id_kill(), so css_offline() reads clearly
and the id refcount helpers stay symmetric: get_online() / kill() /
put().

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 256b68ffca70e..31cec9dde55f0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4048,6 +4048,11 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
 	}
 }
 
+static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
+{
+	mem_cgroup_private_id_put(memcg, 1);
+}
+
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
 {
 	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
@@ -4385,7 +4390,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	drain_all_stock(memcg);
 
-	mem_cgroup_private_id_put(memcg, 1);
+	mem_cgroup_private_id_kill(memcg);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)

-- 
2.43.7


