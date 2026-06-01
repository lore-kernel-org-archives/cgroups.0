Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49B839B962
	for <cgroups@vger.kernel.org>; Mon,  1 Jun 2026 10:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780310425; cv=none; b=bOq+oKTlDdMngSLH2hgGnxeYhEYN0eQRYjVqwc4uIuHAGz7Sgpqd8qepwt8YHUNwSVSUspGUkHUg9IOTEUrzaGmiTsPnlUX8x8VeitZ2O1LCpVsYDrojqIpYYmeXOiU5FTdAV73oLEVEJHVSaBoja4oR+ALRUWFKUOJKf5PXEmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780310425; c=relaxed/simple;
	bh=wAxApDjkjOGBXeuElPBQx/dPHycKhTGW+Gv/8QhEnbw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=un7dFNiwcc0Vv6PAiMlnc0QAtNRmM4C2k4zIWLILhBQfW44YB53l66pYp3Mdhb85k3XrJYM0E47oG9DtYL+G2TLj181pNRxUWHF0iRv998rHpOjChHFuJiCrnS7Fu2GE7aly06BpjuRseVTCheYivsurcqXvjCFk/b51p6tg1aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FjACQjOW; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FjACQjOW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780310409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+kxihP4QbZH/SbV81BhxMKE8qdk0EBh4QHfFzGdZZ1g=;
	b=FjACQjOW1MOQtoUqCCNCGVBX+brPhDYVowfPvlbVuB2B7NGhsRgGhCegZQHJTQHw8+9xR4
	RSmQ4zKh26ma4ohTxjq+VqQQlcmn+ejFhVGkVvqdkz77SAZgJsdbfmBAJT/cwR8371K8MS
	iugrU/Lsa7XIbrkFN17aqtQjZ4L9hIU=
From: Lance Yang <lance.yang@linux.dev>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	qi.zheng@linux.dev,
	yosry.ahmed@linux.dev,
	ziy@nvidia.com,
	liam@infradead.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	ryncsn@gmail.com,
	zaslonko@linux.ibm.com,
	gor@linux.ibm.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	npache@redhat.com,
	ryan.roberts@arm.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Date: Mon,  1 Jun 2026 18:39:47 +0800
Message-Id: <20260601103947.63923-1-lance.yang@linux.dev>
In-Reply-To: <20260527204757.2544958-10-hannes@cmpxchg.org>
References: <20260527204757.2544958-10-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Wed, May 27, 2026 at 04:45:16PM -0400, Johannes Weiner wrote:
[...]
>diff --git a/mm/memory.c b/mm/memory.c
>index 135f5c0f57bd..f22e61d8c8de 100644
>--- a/mm/memory.c
>+++ b/mm/memory.c
>@@ -5222,6 +5222,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
> 			folio_put(folio);
> 			goto next;
> 		}
>+		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>+			folio_put(folio);

Missing a MTHP_STAT_ANON_FAULT_FALLBACK bump here?

Since we jump straight to fallback and end up at order-0 :)

>+			goto fallback;
>+		}
> 		folio_throttle_swaprate(folio, gfp);
> 		/*
> 		 * When a folio is not zeroed during allocation
[...]

Cheers, Lance
