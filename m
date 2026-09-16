Received: from mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A045345EAC
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 02:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789525984; cv=none; b=PpmutU045wfA4l+GG9NYUNt3L/XNWcZEbYeyi7scEkWdyDnH1pAPLvYvYhvAxdfDIKnYxen/EP++35mPhL5KtTbF3z06bhefrOx3s3FgYgadJ/SpV8wnFe9xueY8jvgBH4EunHThhtnTG9sHbutDCOfU2hCJrDL8aConwHQSOHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789525984; c=relaxed/simple;
	bh=EL2OlE49I5JY81apAvNWZqvNiNlpta9PbuUy1mYyKIM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=pB3HhcezQ1qifinAe4iN3Ip7wmATiVixAzI5IFgHBBWDNseg28VYZ3n/J6yUp1t32JnmhY1h+ZqMTOm08XxLmXi2qdoUl56UUl7v7cz1LJEigEAqNgUE4ywsJyfovW46F1ijNJqVrCuZwrNPSHds+vD3ZiaadnoejrDYmKPAQV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vl+EYyYQ; arc=none smtp.client-ip=91.218.175.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vl+EYyYQ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EL2OlE49I5JY81apAvNWZqvNiNlpta9PbuUy1mYyKIM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789525978; v=1; x=1790130778;
 b=Vl+EYyYQbU6OEG/du4v/iP54LiQa1SuyPS2vamEpynw/r/G5sG1zzqaKuGm7YLKtgOrrUGzx
 YQt7erpMiIVhF2GWnBb0Z2LnOH6Zj96OwDmbjR/HqjiN8k3JrXxQFoGoPLgvgudTma0K93nqTQK
 QToe55+12PflF64iVD66MCak=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 227d476b07422197;
	Wed, 16 Sep 2026 02:32:58 +0000
X-Mizu-Trace-ID: 227d476b07422197
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 05/11] mm: memcontrol: constify the mem_cgroup
 accessors
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-5-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:32:36 +0800
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
Message-Id: <B130AC93-87CD-4FD9-88FC-B57798DE33BE@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-5-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> mem_cgroup_id(), parent_mem_cgroup(), mem_cgroup_is_root(),
> mem_cgroup_is_descendant(), memcg_kmem_id(), and the other memcg
> accessors only read from the memcg. Constify them, along with
> mem_cgroup_shrink_is_root()'s shrink_control.
> 
> mem_cgroup_print_oom_context()'s task stays non-const, as
> task_cgroup() takes a non-const task.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

