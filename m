Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A382931D7
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784113428; cv=none; b=gXF06xBIO7pkI9oJSmDv+3O5uQQ5quuZasLOCKMI6/KyZpaJ5b44GJ8tcXg9vRwogKzCcCSEPobRfEvSZ66I08M6NMxE9RVoHP8IyFhT6Cc4sXtajYCqKlTlcPZ2FuTh1XZBS1If4vjj3bmNNnh+Ufy5Mi4GpYc64h9iIwB1Ot0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784113428; c=relaxed/simple;
	bh=J6H+FoeqiU5MQFbzUvf2h1acD2Gc0AUhstmNBmOjGho=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eTD7hWN12ugQzG0qLQ5EpGel3Nki1lJ8AsEUT/VZ3w+nqQhWghOlSmner9MZ53NRCGmZQaexpJn/LKHsD78xBHxm67NZW8x5ZTXKKZyqLPw1TdVUY0hex+U37iF0j7YQfbfsFSkd7SGhOehmtMQHQQnHRUdIo/kqxHdOBlHfClM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i3lNIw2x; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i3lNIw2x"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493bc2b376fso40499805e9.3
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 04:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784113422; x=1784718222; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dz86EwLqIg9rsRKy2+oVo0cZ8RAfDlpYQ8xyeR+GWfk=;
        b=i3lNIw2xeMpxYwYzM8naVyRgQp5PAXiLHUy9V2K3GirLBocN7FuHOV6gTAti6kTAKH
         G08pbVe0UvruAdcd13goBm1+Ztg2tTfSHAw3mUc6ze++QCSKQb42yIdcWdIfOi34kOGF
         DfpiMyE3/aDfd7MoFj5VZdI9LLsD5BjQhDKUU83SuHdWW2hUFh29iCisakKMfuppuYM9
         EaPki2aK+TR0zt+PHgkYk5ku/e0wZJ5doD9fZPk9rfwbVAxL4ngGvp7+Mr5OvL6pAMtt
         qoC/bxOCSlhs9cRTS+yC6NSS6IFlqicq6nZeChJ/blBhdZXURLGZ2nKbaOTDAzCu0qP3
         9goQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784113422; x=1784718222;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dz86EwLqIg9rsRKy2+oVo0cZ8RAfDlpYQ8xyeR+GWfk=;
        b=Rv/dVvOdSqsISI5sd0dhK6aYlZV+4S+HyTELaywHqp2j9UbQs1/+xgXBTrX2npDiR7
         nOf92XZ5HTeGvH/uujc67Uu+ZBWcNvHdGhAkrspou4J4AZ1o8NuQnZIqsWZV6aUL5Blb
         WZW5Y6KWMolHtelNmq3UYV93dpwdWfjyPSjJSU938VdEgHwuXxiJKi0B6mCa0ZrvJBfI
         vlR42gFDvF+p7SoJdIR+Mc/XyAH4kfyuilYXkM2hs59kq7xdTdrBFxFm4D09pMbrSKma
         ZqqlNPsPUGX9JY3DFxgEgQR5Hj5AXQguVxkgMj9wXZxunAMYG4qBtb63pDxtXWDJ8qqC
         +h0w==
X-Forwarded-Encrypted: i=1; AHgh+RoBNyLwe7cpMtaj1iEUlvDFH2oYRskYHqRgKuDMB1gZSsxqgFK4XgwvFFZA6s0TUFLzkxibhyEI@vger.kernel.org
X-Gm-Message-State: AOJu0YwuJXsWXkzNUTQur024vSFoFKiIgZMhf8+3KnaUFij0R+ml/eTA
	Q5G7qirNbZn1R0iseVuoZ0esxLtegjlUyLgz/u+SEvpiIZa44XO4TPKI9PCmh/gWeVbc7YoCiEw
	yDzfsrOsRQAG2qw==
X-Received: from wmoh4.prod.google.com ([2002:a05:600c:3144:b0:490:b2a6:e6f5])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e0d:b0:493:b499:3ef2 with SMTP id 5b1f17b1804b1-4953c299474mr25989985e9.37.1784113421736;
 Wed, 15 Jul 2026 04:03:41 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:03:21 +0000
In-Reply-To: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260715-spin-trylock-followup-v3-4-fc4d246f705d@google.com>
Subject: [PATCH v3 4/4] mm/page_alloc: remove a couple of VM_BUG_ON()st
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

VM_BUG_ON() is out of favour and on the way to removal, since I recently
touched alloc_pages_node_noprof() I am removing that invocation, and
also removing the __folio_alloc_node_noprof() one for consistency. If
this precondition is violated, the system will soon crash anyway.

Suggested-by: Zi Yan <ziy@nvidia.com>
Link: https://lore.kernel.org/all/7F866265-3F2E-4765-B9D4-9AB898A9C4AC@nvidia.com/
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp.h | 1 -
 mm/page_alloc.c     | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 4d57e9c0bf204..872bc53f32ec8 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -255,7 +255,6 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
 static inline
 struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp);
 
 	return __folio_alloc_noprof(gfp, order, nid, NULL);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 25a83a57aab66..4c6815f84adc6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5427,7 +5427,6 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp_mask);
 
 	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);

-- 
2.54.0

