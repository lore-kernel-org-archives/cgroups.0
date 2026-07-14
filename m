Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4E53F8899
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 09:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784021542; cv=none; b=EORRilYCjQ3wb+YiUC1ygB4v2lvQngisEu/iv7CcFzC5WP0ivwrxdNt8g1/V40F1dH+5159uDvA3NuWFieTHS7w1T9vt/G59e5l6jHVl0qzWdMA1GwrHm1JyTg+5MQnGSX8s4G4pBK/uzwR7cN68UsMNKlA4CH3nZ4HaO4FzATk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784021542; c=relaxed/simple;
	bh=loB3HG8brTXzmdSKSsUK401/V7kF9OMrAV2ZVZNmfIk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DN3fNvr2e2eG8r5ZOqANCrCfz8qQjXjOlI/uZ0dXciGPfanW7R5wzMFR9vYERdMRzS/Ge4U6SgeHYIrZkDvg36gmL7fN+1glXGTMPtUNmqYGXyCZaj7YbxDU2mZLlzafJvPLnjVBKEl9l1Vs4Kl2u9EVKvYXBvo0xjakEOBEiN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CwzbUHAp; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CwzbUHAp"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-474170b59dfso2219525f8f.3
        for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 02:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784021539; x=1784626339; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WzKR252Snnew5WaAvQzSvTHfEGNrnKkZ6pkR9ltqCAo=;
        b=CwzbUHAp0nWlTHkFa+h0qE+RUS7GQe639KewU3gLAFfQD/wBRavxlakTZs2oWlw4e7
         OhFqKlsR23PYvXtjoUo34/RYYcSEZvH6FUfQWzOR5uHO4LX3DFXcIH/DZTS8oDJ5BaNh
         XvibGCVavGT9YxVHWIai8QygMc4C5+Fe3n6Nv9jfCRjI/maDD7nWdXtbpI/gk79wwBjH
         tFJGiQ2PSY+E+GnjnTqzzPO2xf61oNxa68Ycy/flM7j4Q0euiw/v76i1/biVwNCmYLSG
         TgEW1diK2i5iBioiIJv0D/cDBxSvbjwM0FS9D7BaPBoujTEmZ2djU9Dk7cJX0y2XxYdX
         FhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784021539; x=1784626339;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WzKR252Snnew5WaAvQzSvTHfEGNrnKkZ6pkR9ltqCAo=;
        b=QYl//gJAncXzKe3SFeiG+FTV0pVOP8DKEjNPdLQ43JkTO7iA3D3LromXAAG+V+NaSo
         nwNdaN7nlEVfFaY2Lk1qSZL5Kmy3z0DBFL6QiWDhyJhAf4rD+MFFTGVuslE48Jv6pxOk
         53jgZ4YahWflP+TyIgi0P/CDrvoRMA3iQTj8UhgKrxrkjqmJ0L9xDTG3dd9xGSR7XDku
         lEgBVprf0h2342peIRSnjRpRyC40sUEY3mhupFPLamkEpzGFfmorh9djQqpKGEDPr4XR
         q1X7lzbbVLlas0kPHWu1j0q42bEJjOpnJgHC5Y/sZ6SN9zH/nWi3FtuSALg258+YOncW
         8kzg==
X-Forwarded-Encrypted: i=1; AHgh+Rr/6xJGy3AMFXz5ndcX7MhKvUnZxB7Ue1YZjhRP4WvzqxkToAX25hMS8ih+C+3WZtZddh+PeVOx@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp4SAq5fh/8tuJMSiJg2ENW5hGOiD/xf4xEQ5yvV3oUEVWkO66
	G9DH55k0DmQSr2ARQU9e9ntWqZYa+rqIaNJKjY8+a0HHvj2urc/tvGYBuZHNcVnaBKxxeDXqarI
	McMxKpTkJRZDzCg==
X-Received: from wmo8.prod.google.com ([2002:a05:600c:2308:b0:493:bc2d:fea8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8119:b0:493:b6e4:fb2b with SMTP id 5b1f17b1804b1-493f882cc20mr115137745e9.25.1784021538718;
 Tue, 14 Jul 2026 02:32:18 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:32:02 +0000
In-Reply-To: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260714-spin-trylock-followup-v2-4-3c20ed032b14@google.com>
Subject: [PATCH v2 4/4] mm/page_alloc: remove a VM_BUG_ON()
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

VM_BUG_ON() is out of favour and on the way to removal, since I recently
touched this code I am removing this invocation. If this precondition is
violated, the system will soon crash anyway.

Suggested-by: Zi Yan <ziy@nvidia.com>
Link: https://lore.kernel.org/all/7F866265-3F2E-4765-B9D4-9AB898A9C4AC@nvidia.com/
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d53f858e518f7..0db1a7281fc33 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5438,7 +5438,6 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp_mask);
 
 	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);

-- 
2.54.0

