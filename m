Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.206
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793674609;
	b=C6MwG0U+7foE1F0sx44fovxGLh4tVSaZFIlkrAnMCaKAVijWXuzXn5oAi66xilbxcC/D
	 bytI5SwNKYfoWax1/2UapamsJwrWV2xU7DDNcGaBvomB2qYARRsvFHdQIMQsWci77z89m
	 r+jnuoeHLodGJ4LoSHVZCDf/7AoXDcUvW7NqSqgJDmd+qjd4nNG/X+ZRS9kaggKygO/s2
	 vZSFdxqebva+L37NhwFs7H44sWDtEztd2SC5/G4EpGG3GJtJNfWbFtzy+5cHozgjX2tAS
	 sBWpLHYgY4wURuFfZ38cC4KH5s2W5ep17RzKi2zBRhLPCLvnU5mzHmjnrZ3ODtencKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793674609;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RIOkkGnIZaSPy1/KAD5FiiNG0GgLq7eCUC5R8WcHZHE=;
	b=QwpvZLwUW9z97gRoZkG8qIKp6Ws3lYwkj1mu7yUJdoCoe6yWE9nG9J7av7tGqtf5Pz50
	 vRFe0OTUetJSNxqwlCvVPJkptRn7hCEUbwqJsSpUd3ufoUKVKUFwfZaxKyKoeqYf5U1hs
	 H8t5DGtNDuhJQL72U4kfcoi/Ptucm4zoEInswdYqedhzclkl/mdjO+3Lzhc32lVxnolVC
	 QdRjjDFtesYFWIpNmq8N6tMaPGYJjXv1MdswJ4ige2I/IYePz5ZoGd08zLMphs/mP1mEd
	 39/vcVJd0OylszZCwArBfsbocKbOOO7jo0vrq1Mb7/d04GdUiXuS+WJ4MiaHn4jRjsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="cp2Z//Ry";
	arc=none smtp.remote-ip=91.218.175.206
Received: from mta0.migadu.com (out-206.mta0.migadu.com [91.218.175.206])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347A8606A324
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 02:56:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 347A8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cp2Z//Ry
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9n/hwIsY+R5F+Nl0olpxr58NPq3L66rvI7ss+scwvow=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793674606; v=1; x=1794279406;
 b=cp2Z//RyDRGkFzDFCZCmu1hbgRc4Q5bqkhpgGOy3i1hGpm1LxihWaKRiMUUz2EBrXHw5U7WV
 vEESiX2Wbe2xTpBf4rH31pN6dXsGkU23VFOtygJCr1dwNnr1RrlpoEqDq+NhfHKz/jhlOeToPCi
 qblVZMc2F24LY08wvwjI8e9A=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ddeccf7e7d3279f7;
	Tue, 03 Nov 2026 02:56:46 +0000
X-Mizu-Trace-ID: ddeccf7e7d3279f7
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v6 1/7] mm/memcontrol: drop unused vmscan tracepoint include
Date: Tue,  3 Nov 2026 10:56:04 +0800
Message-Id: <20261103025610.3738894-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103025610.3738894-1-ridong.chen@linux.dev>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
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

From: Ridong Chen <chenridong@xiaomi.com>

memcontrol.c includes <trace/events/vmscan.h> but does not use any of
the tracepoints or macros it defines: all tracepoints invoked here come
from memcg.h and writeback.h.

Drop it ahead of moving the vmscan trace header under mm/, after which
<trace/events/vmscan.h> will no longer exist.

No functional change.

Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac6c43ea8c5a..5bad742dc381 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -77,8 +77,6 @@
 #include <trace/events/memcg.h>
 #undef CREATE_TRACE_POINTS
 
-#include <trace/events/vmscan.h>
-
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
-- 
2.34.1

