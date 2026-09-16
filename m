Received: from mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DE53655CC
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 02:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789526155; cv=none; b=nPo8kWZgGfXUw1vdTJpy8G7ojZqMGsIi69TvXvN8pOBfkHt7n6qZATMrUEWiPmJV7pAyrKUfHfZK/iQhv0R+4KHnqotguLxi1e4szf1bBmD3QvK5VyytE2qdiAy/+cPSLfcmLCDwNnjiKuW7Xfkv+vhLpkIN1JqWRMmraP1I6o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789526155; c=relaxed/simple;
	bh=TvWzW1LVwKvEvLrmGXalaJM+zsGwELVQfJ+2EaBSRlg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OExFJrj30KGq2v06wlOiiK24LrVKfA+AUTn2iM0u4f9gXsYfURiBeHAk9qZM+qCCNawlApw7McR4XknIspqT6AQPGaB3JvskYmnfNcxryAkUa8p4wqgR2PcSxGJRxweM0QxZN9F4mG8zfhs3PAmK/Hrfe3OSnw5fJNrfevPsh0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KTPyn9x4; arc=none smtp.client-ip=91.218.175.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KTPyn9x4"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TvWzW1LVwKvEvLrmGXalaJM+zsGwELVQfJ+2EaBSRlg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789526146; v=1; x=1790130946;
 b=KTPyn9x4PqhGz0UGzuaeiGFeeaWT0YM3OsRPCLSrXrIjZwAWcV/3kbgZn8g0xvAoR9EgJLmt
 EVD89zcG8Pu2iL1ftSs1ceoq+5UaG/pyiuKwiknns3FRqnhu3t9ST3vCBMhcscG+e8r5pKkDKFu
 aqCzQ0AZKmF6Rch4ktgAJqrs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id e4a3c3e71545321b;
	Wed, 16 Sep 2026 02:35:46 +0000
X-Mizu-Trace-ID: e4a3c3e71545321b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 08/11] mm: memcontrol: constify the memcg and lruvec
 stat readers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-8-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:35:24 +0800
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
Message-Id: <41FB90C4-30C2-44BB-9719-43CB9F70CF05@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-8-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> The memcg_page_state(), memcg_events(), and lruvec_page_state()
> families only read counters. Constify them.
> 
> Use container_of_const() in the lruvec_page_state() family while at it,
> so the const isn't silently cast away.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

