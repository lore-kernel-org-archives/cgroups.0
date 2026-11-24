Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.141
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795478692;
	b=2rV0ba2sNWvq5d/Pr9UB69GsRT7McpKSd0SpmKaQyRmN0TJMchDVLZ18qVfhr+nTjW9s
	 JUU86HeJbR0kBmHh+JHa4jfiZAHkF9222JhRmyYNs4/4GfkvBOV+ObFW0z8rAJeUnG/TL
	 RHv5Xb/E0Gc9KdNJog+tE1skGcTgPsd6TbumlUqBY5ChCoiS4T9gsNVlld3vkam6cbHVd
	 0tdbAz9X7+wG8cKJ1tYdD1S2KdcYdzLyetuuO2XkiG/sNEh+RNMuOIw2MqKkM09Et6VSA
	 SGBupHRK1323LZeurubPCiK70pRjBlyRl/1cLDhsqNFFMu7b3lNTvJp4WSOnXmfH7Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795478692;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Vj6rX/08YHl+BRfiOlA4IKO7KmtpRoLD3xe6xszFx3w=;
	b=afhmuBRAd01MI/Yyor24Ftj2Cz6SZvGkHoUtBLtNTfUZ2WdZZuQiSLXYn0H96vLNgTaS
	 SubEN983+ujqH+VU5nfgKFZJaXC6Xi9vAXYQz1E4gqfFeaUGms7N+wD03+iXYcUd3g1y6
	 frkwKoteijPLJx3sbfpsBzjzDqrqAKbmFnvNh9ISN+p4bYj1JLirbAQ0SbsKATUDmss+p
	 RKzSCCv5Qx0EKirDYiRPLCFi0RV17FTeILeiFd6hyrWQQsHtHun1RsSESXNaQDc0gVoRh
	 ecEgbxFm5veZlvdvzhe/5Jx+kMMWr+pN4UC06qtUuT1n92XEoKbfBkRZfFbgiomtZBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=L1AGF+Op;
	arc=none smtp.remote-ip=91.218.175.141
Received: from mta0.migadu.com (out-141.mta0.migadu.com [91.218.175.141])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA945606A338
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 00:04:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA945606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=L1AGF+Op
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=m3O6JogaMnAWcW2J6tqEKYwa71B3rZOaHK/s4y8qPEg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795478688; v=1; x=1796083488;
 b=L1AGF+OpgYxYHFwN2ndyQIJnk7W/HiPb7d3D4ikfrBzyNJmILt7Hqw6AIhCODTSDjUbckT3H
 8KQd20FS0K2U6ZmbJ+pbr4Xd3bBC57Nbqm1MLIOgijHJBY8AR0NZQ0JKqAQNQ856ow/Po4MY6xg
 ac064SLCWN3qDLXhVFL8kuls=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 511bb6528f3e081a;
	Tue, 24 Nov 2026 00:04:48 +0000
X-Mizu-Trace-ID: 511bb6528f3e081a
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] memcg: free the private ID of a memcg that never comes online
Date: Mon, 23 Nov 2026 16:04:39 -0800
Message-ID: <20261124000439.967403-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
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

mem_cgroup_alloc() reserves the private ID of a memcg when its css is
allocated. The ID is erased when the last reference to it is put, and
that reference is first taken in mem_cgroup_css_online(). The failure
paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
themselves.

But css_create() can also fail after css_alloc() and before
online_css(): in percpu_ref_init(), cgroup_idr_alloc() or
css_rstat_init(). The memcg is then freed through mem_cgroup_css_free()
without ever coming online, and nothing erases its ID. The reserved
entry stays in mem_cgroup_private_ids for good, and each such failure
takes one of the 65,535 IDs away. With failslab failing radix tree node
allocations during mkdir, 1,500 mkdirs leaked 6 IDs this way.

Erase the ID in mem_cgroup_css_free() if the memcg never came online,
which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
only set when an fully onlined memcg is released.

Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
Cc: stable@vger.kernel.org
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/cgroup.h | 5 +++++
 mm/memcontrol.c        | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2afb4cb2bb4f..123c713dcc91 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -449,6 +449,11 @@ static inline bool css_is_online(struct cgroup_subsys_state *css)
 	return css->flags & CSS_ONLINE;
 }
 
+static inline bool css_is_released(struct cgroup_subsys_state *css)
+{
+	return css->flags & CSS_RELEASED;
+}
+
 static inline bool css_is_self(struct cgroup_subsys_state *css)
 {
 	if (css == &css->cgroup->self) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..e7dfc96fd1b9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4545,6 +4545,13 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	irq_work_sync(&memcg->high_irq_work);
 	cancel_work_sync(&memcg->high_work);
 	free_shrinker_info(memcg);
+
+	/*
+	 * The css_create() error path bypasses normal CSS release, leaving
+	 * CSS_RELEASED clear. Drop any private ID that is still reserved.
+	 */
+	if (!css_is_released(css))
+		mem_cgroup_private_id_remove(memcg);
 	mem_cgroup_free(memcg);
 }
 
-- 
2.53.1-Meta

