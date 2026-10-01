Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36257434989
	for <cgroups@vger.kernel.org>; Thu,  1 Oct 2026 04:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790829743; cv=none; b=kxI9M2AgT3tdCKmyVL4tqbpxcugyYSmyPfNS6jgJN1jkZuH20jZNeEODqUvA1JwWZ+i5ql2NNq7/aI7PtoaJXJ5BFhnkPVM1nPnX+rSppqbukSikL3sjObvv/kzoBMgS8/e5HdRSUJnZBIX929qzCHBykLbHBL60y9O9ykyOu2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790829743; c=relaxed/simple;
	bh=vZ2a1RS1CoeagLQdph6wHtoMViLnpsPlbekfBXE+tuE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OaMVOCoAEsspz8dy6YJ5VjpKCnLbaAgVSBL0f2OMPNXzW/l0XVb3RPZHYVMyc0Btn61wucRCWXeeERexwAwaR6dPqlqR7Ya2RpNGckLahYQv2/+9i+HTczOz5Qy+jazj3HoL5tALVRFx3PxG/iDzRgFl4mhK7xdZc7Z25ktRty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UqXfvQin; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UqXfvQin"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a00713639cso30353985e9.1
        for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 21:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790829739; x=1791434539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p2Gp1DxjHQ0qTISrrSjvk99H2tt8CfuvB/h7scE7CDY=;
        b=UqXfvQinxt+NHrhgqikrVcvkpAftlLeI45IG08yG5MN843l66qXD4S4RO7BaWSbNZw
         iYbPUZPwU5vFjGYM+WJc0cF3mK4lud76GLWQJqEs+A8oKLMvOsI3A+KdcbsMzl+5NDnJ
         9rEqJwfanwwxJ63tiGZ6akqHzL18DqS/1FOt7jZV/9SRhQMTTYCj1eNWkwrLgAZhm7dl
         qKehcURJ3AQSEzNVMQRy7C5O3uKBoxlX/gwc577j/2Kn7c/KkSXbr88LpiQlbBZMTj5u
         VraxuyooadZn5OoRDDxz7h2Nz5pOtJZFg+PPJO8BvEwvWJSX52BTP2yEssK2UrKr01SK
         7vXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790829739; x=1791434539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p2Gp1DxjHQ0qTISrrSjvk99H2tt8CfuvB/h7scE7CDY=;
        b=EADVrQjQowUdKu5wJWKdw9EqnLePaumedHRF9VA5CZM9hYSP/bvwukjK+FI9QOyNSg
         kt2TWHQFxFh1X3ZEyHQKF4/eE6PzTsKVH3KplRcOB2oxWPpPVnPP2n1C8was/HbqveQd
         sr1i7BSWSXmdW3xoWcCjtm55lZ1sVgPr8EnKopnN6dq2ucyaNOADW7NFoCJSVQzON8V2
         iR46SrxHR2lShZwMF9NWvJWLFhzom2J9oG3zsj4Rak6qIFpJnIdJE6wTQ4hQe4k4Jf/B
         IbA9x75k0n7sAYuOHuXITlDbJypsR+Cgz73VAPQovpQMXDu9Jt3JQdalU3trbch5wteh
         QptQ==
X-Forwarded-Encrypted: i=1; AKwUvBzBBtWZSH/usEX5qPe3zVEBeQt26lef115Pf5Z/Mdk9d+pBoDwL3IcleXNo544oOhJcC42G2fAv@vger.kernel.org
X-Gm-Message-State: AFuF++nuDcpA2tXQWL9YH0c/D4LdALh8W8pR0xPE0DUkTohrX0kC6wTI
	qkj5rBCzWJLPqPl65YehzwRfgGiu0THC8SLPwRCIvm89CYOXBZWYBSpv
X-Gm-Gg: AYBFou202eROdp9oqzcuJkRzljkEOLY9Xq8gd7AENyTEAjMVWrVWtGFWDR4W5dGtA6u
	IX5UZDrq3fcDqnsXLAlotWonVyFDv/ea7hlztw/QkUWslR8s0TUem8hjN/9LVblkqZg0WYKjy14
	hTEHY2cLklmzwhLMpSmU3GPB0cQ/LC/uqbyfrgLBowuVMOnrRTOTZagZj8uE6zGzSWBewTNqMuc
	/t/xDBitQyspty1v4/GRZspb3xzJzUea2ac6FmcHQtg1KRnZGVGL+gIHHIoHjXB6rEuWQJ3CC8V
	BdHHzRSNVbr8Q3J2SA89zyYHp2Jrzikdf3GzNISQslUGQZEOtJ87GS1u1a9EKcuNhV/nPwRC8NP
	SM8OdRViS9cMuSS8IK5J0aTU2Yg8QlSGHrIt/5Ooecfc86mL4jkQO5lBwMyginpLlyamOuxdRbB
	GLywKqRGeRX0x51KXhRMJ37sC7ZZ2W8KjRwLtr68Lb40OmsJaKuzN39e6EBDio1G7kbLpq/rV/N
	km69DSdBScLUWoNyhQokc7ghQBY6yz9vFf9OXVAlVV6/3tSX2SHyyVoDyNEGBWg/fwRkKkP48OZ
	XHBv/92zf/EZdrvyZgFnOX0UH/TjzPjcb1dMGye29Ap+11qfxKQF
X-Received: by 2002:a05:600c:8b38:b0:49f:ce72:e930 with SMTP id 5b1f17b1804b1-4a01b13d7d9mr54875995e9.34.1790829738870;
        Wed, 30 Sep 2026 21:42:18 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-095-117-056-101.95.117.pool.telefonica.de. [95.117.56.101])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f6c5059sm32619515e9.0.2026.09.30.21.42.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 21:42:17 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH 1/2] mm/slub: preserve no-lock freeing after memcg charge failure
Date: Thu,  1 Oct 2026 06:40:55 +0200
Message-Id: <20261001044056.75079-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261001044056.75079-1-kmehltretter@gmail.com>
References: <20261001044056.75079-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kmalloc_nolock() can obtain an object before its memcg
post-allocation charge fails.  For a single object,
memcg_slab_post_alloc_hook() rolls the allocation back through
memcg_alloc_abort_single().  That enters the regular SLUB free path,
which can take a sleeping list_lock on PREEMPT_RT even though the caller
selected a no-lock allocation.

Use kfree_nolock() when the allocation flags disallow spinning.  This
keeps the SLUB object rollback on the no-lock free path.  The failed
allocation continues to return NULL.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 mm/slub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 54ec125033571..a1f08338102e2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2519,7 +2519,10 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
 		return true;
 
 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, *p);
+		if (alloc_flags_allow_spinning(ac->alloc_flags))
+			memcg_alloc_abort_single(s, *p);
+		else
+			kfree_nolock(*p);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);
-- 
2.53.0
