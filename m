Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98663480350
	for <cgroups@vger.kernel.org>; Thu,  2 Jul 2026 12:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782993934; cv=none; b=cE3ifCMYKxextke+mIPdit9JVtXB8NEL/HfRlRsy2DOgHqHD+vHRHA7GPO9Fe9r2hQ7jgCeB9Q9C/ThBkML0h+rIG99tLBwPYJ4pgJnmHfhM32O82pkANOe/B+JrKo/oReJ//W2vrPM1ixqP9XJUX4UDCRGI+jtzlvrjJgtap6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782993934; c=relaxed/simple;
	bh=aFWRYzffvWX18rxN26TJG1HHWDq5qg2YYAFZjnrTqNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6LBS+O+siVnacqXxDBTMXfXmAqvRoDwXJLN0PHUJFavW6HunZsJ57oQjAESlbQNsilgUd8hF2K3eU+eTO2o0+412xtiGtm+6+Y0tr4e1vhsv8F4PiZqPu8iZaL37pA9Vfo/umFOlXqpih89dyTThVNL9PSjnPpj0JgP7j69Fhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TYasFFDB; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TYasFFDB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782993927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FvNRxHOXuznsB6xwsU+UX6ceiQcxEPGVQFz9XKk/Ric=;
	b=TYasFFDBDXO6HXwugU2s0DXBHXOwzs/aBD8k0uR9GoufDFKBB5AcJ7PQGiFPBcv22bmTG3
	w69/LpVWQKDGarn33xcg+dDEFdeGW0z2Ub8PcW0SzbrFpz+X7yB6xwtrT69+kWmhIK7DP6
	2ymoNmdMo0pmMvkDL8aqKsIMBf6x+YQ=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Zhou Yingfu <yingfu.zhou@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] memcg: bail out memory.max when memcg is dying
Date: Thu,  2 Jul 2026 20:02:28 +0800
Message-ID: <20260702120235.376752-3-jiayuan.chen@linux.dev>
In-Reply-To: <20260702120235.376752-1-jiayuan.chen@linux.dev>
References: <20260702120235.376752-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jiayuan Chen <jiayuan.chen@shopee.com>

memory.max has the same high-latency reclaim loop as memory.high, and
may additionally invoke the OOM killer on a cgroup that is already going
away, further delaying its removal.

Mitigate this by bailing out of the loop once memcg_is_dying().

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4519dc9eae33..938f190a98fe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4849,6 +4849,10 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		if (signal_pending(current))
 			break;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!drained) {
 			drain_all_stock(memcg);
 			drained = true;
-- 
2.43.0

