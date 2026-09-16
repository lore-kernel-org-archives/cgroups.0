Received: from mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA93D39A054
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 02:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789526195; cv=none; b=HT0ZYZwJFd6SUXpHMsxEhim+gloXBzH2liECxNsU7zh7E1oPSgXUH8zR70v6ga+xQb+CUX8MkXX72IEfhfqeKpupgejwfrzRzj+476Lvmuxc/hJ/wTkmUcARqYmhQ++kKzXorTK0ocF5ecGCnikJxtv8mRoY+MoF867yo7ona4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789526195; c=relaxed/simple;
	bh=7Dz4fms3T/cjCdtsDYuHqhdriRacQBPm6AH3anwvlj4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CWvdJFXCyfhPRN+TlkUxpmB8FB/eirXxhztkxxeewaZDPu/sEQ6nIQEP3SRvsqj0UVYmWsjfIp9gwvZM5xnuITtKVbKr9Mp0idiXOhiTd5uKxu4n9xgNHUeFQgNsUaM8zkiECqNJt+g9hwBC6HOigWv5nYVVYRB8VaBf817Nmg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ttFq3DWY; arc=none smtp.client-ip=91.218.175.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ttFq3DWY"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7Dz4fms3T/cjCdtsDYuHqhdriRacQBPm6AH3anwvlj4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789526186; v=1; x=1790130986;
 b=ttFq3DWYHJZhgvzRXlNISEXYnO9+a0TLmYENr95Sir8R3XqPdJSJAmgdHapbjlea+8ffH6HQ
 bG8OH1LIvXMk/RLyxUtd7KxUxdHXZUepRxw2IDAJC2LHDSlrO3LFXerkoKiwEpVoOiaddVCJ1u/
 oFz3PkKYN5o0RLu7RsIA41gE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 9d20baf603adb599;
	Wed, 16 Sep 2026 02:36:25 +0000
X-Mizu-Trace-ID: 9d20baf603adb599
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 09/11] mm: memcontrol: constify the swap accounting
 helpers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-9-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:36:09 +0800
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
Message-Id: <B52CEE68-38E0-44BB-A375-E733BC5BD37F@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-9-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> mem_cgroup_get_nr_swap_pages(), mem_cgroup_get_folio_swap_margin(), and
> mem_cgroup_swap_full() only read swap counters and limits. Constify
> them.
> 
> Remove externs from function declarations while at it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

