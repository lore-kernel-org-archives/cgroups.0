Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AC13C584E
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 03:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790048014; cv=none; b=LKibe97PS7O3Do1iuk1crM7gQTzVbLVquDs6lHd78ewAy/qHgOr+b/KNl1IwH1tR5ZJ36L4qG0E8klSPv8efAuhPUiLdK2TARQn1fL/yiwOlgWQSxaVe/59hJbl/Y+45/Xn+I9wsAAHH+fFkWcT5etbbE1rZzu0x3QD9dMDry98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790048014; c=relaxed/simple;
	bh=jsmJwRa/fQr2fXpiMozTq7dippLPIT6++tb7uYe4CZE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GVgECtVaKZkold8D+XN/qiE1CLYouwvcj/AGqCRDHiRLeI5m5fxEWl+Fjlcbc5ZpSLViZLX+LjpBSRheoymc8GYt07Viu8Fn/DHvWSuHyR7eSnEGBBu68tr4UCXphkwR65H+1RFcfhKsfY1bQgqpVJXYMd7SPB0SotY+P7c0rS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jsTQo/Sc; arc=none smtp.client-ip=95.215.58.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jsTQo/Sc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jsmJwRa/fQr2fXpiMozTq7dippLPIT6++tb7uYe4CZE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790048006; v=1; x=1790652806;
 b=jsTQo/ScQ+WxjmiN0fEw425xrIZ9q+LdipdIkErEP13bFoHEmPcmdWhbQuKpWRj+HA3Mgb+8
 akbh0mbuMziAGJlI1peZGULX5haSvMltMMkkUDvdXfdMMSYENqjM1SsCmMVg36e0g5kvirSqZMd
 1ErqW3cZeOF+C1Dbp8bNOTmo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id c0aae00e32e5a8cf;
	Tue, 22 Sep 2026 03:33:26 +0000
X-Mizu-Trace-ID: c0aae00e32e5a8cf
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] mm/hugetlb: account migration target folio in
 per-node NR_HUGETLB vmstat
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn>
Date: Tue, 22 Sep 2026 11:33:08 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>,
 Chris Down <chris@chrisdown.name>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3534C571-DD8F-4FEF-8206-3CA4D783322D@linux.dev>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
 <20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 21, 2026, at 17:12, Hongfu Li <hongfu.li@linux.dev> wrote:
> 
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
> when a huge page is handed to a user via hugetlb_alloc_folio() and
> decremented when it is returned to the pool via free_huge_folio().
> 
> A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
> hugetlb_alloc_folio(), so it is never accounted, while its free always
> is. For a migration target this means the target node gets no matching
> increment for the decrement on the old node, so the global nr_hugetlb in
> /proc/vmstat drops by nr_pages for each migration. The same asymmetry
> affects the failed migration path, which frees the target again right
> away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
> same helper.
> 
> alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
> folios, has the same asymmetry: the folio is handed to a user without
> being accounted, while its free is accounted through free_huge_folio().
> 
> Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
> and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
> decrement in free_huge_folio(): a successful migration hands the folio
> to a user, a failed one frees it again.
> 
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

