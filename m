Received: from mta0.migadu.com (out-244.mta0.migadu.com [91.218.175.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5684D3546DE
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 02:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789525739; cv=none; b=uOIMaTfJXozF3Is8Y/bTZJ+SjnIWADKjW/UULtA4IgRJ/PaWvxFZqRP+uUo0cNlTgjgKXTAxXMZt7EFgz/2LqE7BnlpaR8lq2OfCAmd21/KMAJK4FFe6BawhBQmXm3UGImcD1wCbhI7k5PGVA3PFwC/p25YCQ9pslCEO3HYTuCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789525739; c=relaxed/simple;
	bh=tTKmz98Lo5PgYCpRdlP0wUncPsKYuinX9OL0Z34CMXs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=EJuxpw/RSn09Gthq1QZ63+r5kXK3XnrQ8YtxFn/AyFS87KDV+zvu24e+LuSsUYx1a1sTYXDDkKdf+LnIER7Z5uAUk1VT0Nps8UJfbZM1ac+euMXBzeSUmlx31NTZ5mPsRb4pDzHNdmGXVMw+glBnWhzh0D2VJH18PiiESwQTjek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bguxoym4; arc=none smtp.client-ip=91.218.175.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bguxoym4"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tTKmz98Lo5PgYCpRdlP0wUncPsKYuinX9OL0Z34CMXs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789525732; v=1; x=1790130532;
 b=bguxoym48gTuKTsek+zfr7nVSvfkOfFpTCP0Li4h0ISSG7k/NNlmEIy4QO9OPFIeNWOhVIft
 B7WqHMvU75M+4mhfGJMq7PsrXsVliQxbPDAMLhU1m/27/ELXpb3rzj68O5aSh9uLzRICr2CHHkO
 tvOibVlRC5RmPtC1KUN+TyC0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 519e8ea2ff9347be;
	Wed, 16 Sep 2026 02:28:52 +0000
X-Mizu-Trace-ID: 519e8ea2ff9347be
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 02/11] mm: memcontrol: constify obj_cgroup_memcg() and
 friends
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-2-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:28:30 +0800
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
Message-Id: <1FC4ABF6-E713-4034-9431-9B97C584B90F@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-2-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> obj_cgroup_memcg() and get_mem_cgroup_from_objcg() only read from the
> objcg. Constify them.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.

