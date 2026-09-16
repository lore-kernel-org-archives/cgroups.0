Received: from mta0.migadu.com (out-219.mta0.migadu.com [91.218.175.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB82313E0D
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 02:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789525692; cv=none; b=fvVurjEeLrQg2oRkevRAWA6ZTq3dW+G0f8fQE91EeD0EabhfElNk4S5S5CblJuUN4f9MHhIqe7om8R404gn3Uar4U0F7d2i98vwl92oYn3GbjCb2YRhXX9kMEDwPPLRwaFD2ISqiFPlI+JXvLYmGSnzLjyCQ92pnkU6XF2iQnTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789525692; c=relaxed/simple;
	bh=ZyxvwXCuu3wDubtodIGxIsLb9DGpsFtLwTaxFFn+nac=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=O2t0W81B8/MkIKRdcTo+SS/pq8PlavwT2uQxqDULLrwZPwjmUH5uBOerjP88ZsdgB3iNuGycsgavkqtMMFf25XCdBtD2Gf4HrXjtoyf3FhbV+xibiAZwzcvPi3MnwXIcsCwHd9kyQ+z1oKG0T8xdvJ4xDlsQdvtkIzqhM3uyphY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=icxZfwJW; arc=none smtp.client-ip=91.218.175.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="icxZfwJW"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZyxvwXCuu3wDubtodIGxIsLb9DGpsFtLwTaxFFn+nac=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789525684; v=1; x=1790130484;
 b=icxZfwJWf9IQMeeSSW2HGckpLv/cicx7r/t1n3GOKWT4uTHFT+Tzb0PjFo1E4waqCykBmRue
 C7eDTylMdvEocKy+BNqjgV1NKoBD5QWzCUtMghpQDMa116QaawXSRGqYNO05I9sK6+t7b9G/5yj
 yISOx8NczZymSfEYFS6PWUfo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 00efc25bd57ee33c;
	Wed, 16 Sep 2026 02:28:03 +0000
X-Mizu-Trace-ID: 00efc25bd57ee33c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 01/11] mm: memcontrol: take a const folio in
 folio_memcg() and friends
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-1-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:27:41 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <FE95C2D9-510C-4588-84AC-4AFCAA2D3921@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-1-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> The folio_memcg() family only reads from the folio, and everything it
> calls already takes a const folio. Constify it, along with the page
> wrappers built on top of it and get_obj_cgroup_from_folio(), which only
> reads the folio's objcg.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.

