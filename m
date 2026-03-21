Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593704317D
	for <cgroups@vger.kernel.org>; Sat, 21 Mar 2026 03:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774064122; cv=none; b=rN8oLU8gUzj+EoJ7+p/FAfZEVg0idgOMYRKnH/BVSdjncH8bqmGxd2mvYf2cOJqTf8p2EylQ5FOGLQb0cGjctW5y/FKaTjpB11E86YKW+7Ftc/CKpNJJoC16VSmEmeEy9z3Kr76v4eMD+OLtpFuAV9vJY6Nf9ISuqITpDitkNjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774064122; c=relaxed/simple;
	bh=96B7pb5M0XiruGqfKkKfkAko2qpTlFcP4SKbRs28Wgo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lkIBpLwuC8s8Mr2AxqSFSiFrxuE0LRLl00qjuv+r10H+HpcdXWbvhp/uflRiKtGFg+sCdJntX2e4kp/dK4yyqm7BfjlqA5OL6d68qRQrnvK9nZM4nAdtjosUdmVINYQVKlM3eO9yiXkkYKjN+ohxDwwx91wJsPSgdQUA/YCJ+yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--bingjiao.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TiiIokb7; arc=none smtp.client-ip=74.125.82.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--bingjiao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TiiIokb7"
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12a77b008deso14507769c88.0
        for <cgroups@vger.kernel.org>; Fri, 20 Mar 2026 20:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774064118; x=1774668918; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AoMBtlhfnp9XRcs7RdoT2ynBQbMVoKkeC7D17jrPW5U=;
        b=TiiIokb7r2JG6VUOYJwsD5NumP7Y2EUqF67ZeT17OYe7mbqCUGt68knko571W5Nvya
         enP0ZCOSWJpD6zFgnSgjidc8Jac35BySQ7atl1LDNNVokOqwUCyDTnZBPTSYdIlZnJoR
         JQvVPJECEanRbvhKXTNQAAPxDzHKsH7iHob49eJcUz2ABr8d15Z3AUIY/z6HR6kO55Ov
         tOuj5r7TrIVx0YPG9zxpVT11P0dQWiUllqLBYr79eZ6VeWXZ4hleppUKJ7mG/TqW3vub
         BxwIGT8o9r1xW1e1iE/WLjK5pTq6MXp1vo2uoFjVBEeTgSxMqAC2WPEOJ/YOa3YH5Vis
         axlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774064118; x=1774668918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AoMBtlhfnp9XRcs7RdoT2ynBQbMVoKkeC7D17jrPW5U=;
        b=SCTnGnoFhZTBgYercim508fHWdG1aC08C3yLmv3fRhq+XCFZ7bnFSgbzEOa5G1Rir8
         xqBIVzrMhZ2hU7J1PX4UTQkY+MXxgBHf7oW9Jqie4mzQRLsnJCGSs0YJft1xCEYfdKxK
         gGVt1pbgqSrEEmbWNDenL4yA6/3zdPuo6h/ohTtBfaXzF5fbeJArcqsU5eMra5Ve9eXy
         VV04qd3yEu7Y1FEu01Uw2y5WeJXaGKE89LeGP+yaJWoc/pJ5aiKYWMW13xuPb0zY7Joc
         dV0wMxjsKxIUY+vlQbUttN8vUMF1x9SFdssTszexbFoJQpCpOv+LlSedx+4DBvftVnYd
         FpAA==
X-Forwarded-Encrypted: i=1; AJvYcCUNcxr7ceUnk0/KxgesYtaST5R24PIEYzflWzbdjQ7kFVybW+sltRJ5DA7d2toNjm+JK+kXZgo0@vger.kernel.org
X-Gm-Message-State: AOJu0YwFm8ZuzoIJD5/+qDxiuktcYFnXpoQEv5xcUM0tULP2ludzTw+p
	kkn/6MC43pbSfLlPUY8uhOmVWcE7uBJIxQbaEAfuajnwnZrMTArCtecoWqtm3yYTJGYOTiIUgAN
	OwnaBVUO29bHcIg==
X-Received: from dlak23.prod.google.com ([2002:a05:701b:2917:b0:128:d29c:ddaa])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2525:b0:128:cedb:33c6 with SMTP id a92af1059eb24-12a7266088amr3054155c88.16.1774064118178;
 Fri, 20 Mar 2026 20:35:18 -0700 (PDT)
Date: Sat, 21 Mar 2026 03:34:13 +0000
In-Reply-To: <20260318221957.2979346-1-bingjiao@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260318221957.2979346-1-bingjiao@google.com>
X-Mailer: git-send-email 2.53.0.959.g497ff81fa9-goog
Message-ID: <20260321033500.2558070-1-bingjiao@google.com>
Subject: [PATCH v4] mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
From: Bing Jiao <bingjiao@google.com>
To: bingjiao@google.com
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, cgroups@vger.kernel.org, chrisl@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, nphamcs@gmail.com, 
	rientjes@google.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com, zhengqi.arch@bytedance.com, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"

In try_charge_memcg(), the 'reclaim_options' variable is initialized
once at the start of the function. However, the function contains a
retry loop. If reclaim_options were modified during an iteration
(e.g., by encountering a memsw limit), the modified state would
persist into subsequent retries.

This leads to incorrect reclaim behavior. Specifically,
MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit
is reached. After reclaimation attemps, a subsequent retry may
successfully charge memcg->memsw but fail on the memcg->memory charge.
In this case, swapping should be permitted, but the carried-over state
prevents it.

This issue was identified during code reading of try_charge_memcg()
while analyzing memsw limit behavior in tiered-memory systems;
no production failures have been reported yet.

Fix by moving the initialization of 'reclaim_options' inside the
retry loop, ensuring a clean state for every reclaim attempt.

Fixes: 6539cc053869 ("mm: memcontrol: fold mem_cgroup_do_charge()")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
v4:
- Clarify in the commit message that the issue was found via
  code reading (Michal).
- Add ACKs (Michal and Johannes).

 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..303ac622d22d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2558,7 +2558,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
-	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	unsigned int reclaim_options;
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
@@ -2572,6 +2572,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;

+	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		if (page_counter_try_charge(&memcg->memory, batch, &counter))
--
2.53.0.959.g497ff81fa9-goog

