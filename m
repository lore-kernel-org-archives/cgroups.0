Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690D6480350
	for <cgroups@vger.kernel.org>; Thu,  2 Jul 2026 12:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782993939; cv=none; b=KTlyUCQ0JdcF7EssI9Y3/5WqKN5E45irO3PQzvm6PNUE2t6XqlvpjOmJDPtXZMdd0/Ru6acbLlmm2gEhpxoYQSDNKu1x871c2Y9F5fZJIi8PYKHUxJiJZgeAG2s17vAMQvUP8i10HxXlPF5L0Q/oRLb5ygLf5Swf19T7FYFXNQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782993939; c=relaxed/simple;
	bh=osAkqdldu0cEtl7b+69rPbUopVqWousL2SHeNgC/ypo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFWB/Hn+tZkG4OFHj1Kr0U/L3bnR9O5vIKsEmayY7h5nzd9YpfVHNd+hB/9KW38mn2fWkndbUPFSA8xf1aIxuKT0ps2Yjlg5rq63SpYaCSC2XS5kzVgOnvW8j/KUWJajg9srp+wEc6Q/Uo9II5ivbocErl0UaVd8cyouvsJ4Rgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KkGVTP0g; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KkGVTP0g"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782993934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qV/6Q/zfvU+sGrRgh8IWLF6r3UQhaR3MZc7VaNSCn6c=;
	b=KkGVTP0gI8cfFdAg1a9okozjmFpJrnwgFn0GqlbJKS2fHkzPFT+tSei6g6K1BEmpaB2NBF
	IiX941PxBS9SvWwPRCRKTcaf/BLPiw2TYCg9/kHaxHYGLQHnEQnzIvVyxSlr2/AyVXUdhe
	CT3GxhecyyzOx4dCrqZ9vxxPAnMruq4=
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
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] memcg: bail out proactive reclaim when memcg is dying
Date: Thu,  2 Jul 2026 20:02:29 +0800
Message-ID: <20260702120235.376752-4-jiayuan.chen@linux.dev>
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

Proactive reclaim via memory.reclaim can run for a long time - swap I/O
or thrashing again dominating the latency - and delays cgroup removal in
the same way.

Mitigate this by stopping the reclaim once memcg_is_dying().

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/vmscan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 754c5f5d716a..6ae61be2fab8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7912,6 +7912,10 @@ int user_proactive_reclaim(char *buf,
 		if (signal_pending(current))
 			return -EINTR;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg && memcg_is_dying(memcg))
+			return -EAGAIN;
+
 		/*
 		 * This is the final attempt, drain percpu lru caches in the
 		 * hope of introducing more evictable pages.
-- 
2.43.0

