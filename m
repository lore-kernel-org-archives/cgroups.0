Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794902672;
	b=a8zYPifhfb9z0bjbT1/tqy/Zq39/olThKweMk+Fwgcg2Rk8DsrN9aoywxkWfYvNVbZon
	 cCQcbTdp9dOlMCsE0cLmtesRfbk5dkQwT6FZ6+CC14m7Izr47POpz1ipD+DGmqXUPLoXW
	 Ti2sVcHvl+6dnWrS5A/YZRHaIlao+NdqMtWg8N0nh6hk5ZwXZXmRb3el9d5hGJJFq3+d3
	 IxfN+M8sgUcogLWvHVhp1B9J7SvlP1yDjZ7ttDHWZ/DF1t3I1MtAza41OZ1zPuxnm2tbb
	 wnLsxWf3asbT+4hMo6Wd0cBUobucF2HB6waa2R9+A/b4hlGrJnA73QX4ucldlXx4G+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794902672;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=fr+hVevMxhFED02GURMU20tKWkOs3+xF0X0pX/yzRQU=;
	b=KKk2D3WssuAHizBO8qudhg3OxuUQMKQGZfTYLjFKq2EXPwFRTYfWI84+LvYFXdAjmfFu
	 zd96bwdYBoalgfA2peoZm+P3y1zGcsNDmDjyhTnJznCr6Z2bASiHirYAhE3ycjPWNkvaZ
	 pmBtqWzJrRCvcsZ4/fEWMLpdW9ZXRtoKKU2H+05JfjOr9B/Lo5VBblNn0pCEJB848tbA1
	 EICOriF0R5SIxr9LuIGX72LGkhsSkccfU2hsZsS2qfcClegLZo6ZBG4EB8720KpWtvgXQ
	 OjduIor9N46JRs8di+J9on/Np6fpjWMjlZfXDnaXpG0OadarL/PcGVpUctMUF9K4e+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PGpgrfaZ;
	arc=none smtp.remote-ip=95.215.58.47
Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015BC606A332
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 08:04:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 015BC606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PGpgrfaZ
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HT+AvSGQmCJPID8n4M/T08ixuiDzXLImqF0yDDDj77U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794902669; v=1; x=1795507469;
 b=PGpgrfaZ2VM58rmnP3EvmRVchWywekWALpZj3AlSMilFrWfzAxYlJTTeLmzedKAjU8RpJXIS
 UJQlAJejoj6DlNOCFWxxLXOsuDb5Nduiebnv+cQC6xkDKwRJyJGDObfUTi0wN+1J8e/QT5uy+Ky
 rOWa5BHXyHfk1U/tzUwS/h7Y=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id aab591f1a1b28741;
	Tue, 17 Nov 2026 08:04:29 +0000
X-Mizu-Trace-ID: aab591f1a1b28741
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Down <chris@chrisdown.name>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH 0/2] mm: memcg: fix memory.high allocator throttling
Date: Tue, 17 Nov 2026 16:04:19 +0800
Message-ID: <cover.1794902513.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
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

From: Hui Zhu <zhuhui@kylinos.cn>

calculate_high_delay() converts how far a cgroup is over memory.high or
memory.swap.high into a sleep penalty. Two defects corrupt that penalty,
and since the caller treats "penalty_jiffies <= HZ / 100" as "nothing to
do", a small result silently skips both the throttle and the
MAX_RECLAIM_RETRIES reclaim loop.

1/2: the u64 product is stored in an unsigned long before being shifted
right 34 bits, so on 32-bit kernels it truncates to zero and no overage
ever produces a penalty. Broken since v5.6.

2/2: the u64 product itself overflows once a cgroup is about 130x over its
limit, leaving an arbitrary result that can be zero. memory.high has no
lower bound, so a one page limit with a few MB of usage gets there. Also
affects 64-bit kernels.

Both touch calculate_high_delay(), so apply in order. Different Fixes
tags, both for stable.

Hui Zhu (2):
  mm: memcg: fix zero throttle delay on 32-bit kernels
  mm: memcg: fix memory.high throttle lost to u64 overflow

 mm/memcontrol.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

-- 
2.53.0

