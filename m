Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFB519AD8B;
	Tue, 17 Mar 2026 19:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773775057; cv=none; b=kcFYSCISaITOZ6rcfXb69lQ4olE0MSwfU1ylymkxfzXNg5CVO3swifGYGfpIt25KaPlzypaNPdr322gmDchc4atPKDnhwro6EhAvEW15s3DMXFSCp1za2KnH1umFT+duLOPBJ7kEGPn8+BqJoUAtjl/MAaSPYMfxJxhI+vYlWG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773775057; c=relaxed/simple;
	bh=W+368n3zmFZXeS0XIlxfHQZMscjYF0bb1lj3Rt3JIVs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=GbFnXPnFmnNiEzgRnQw/tkv/l7v7gv6opmSMBjcWVe+c4tIVaKn3gHt/IAP1m3okYmiDSDtCGfP9hOh8yqBIZr0PnXdKWtuGKS49iK8PRb458FrgnDvAipJg9sPJN6FYhLYfQvu22rbYLFsvSmq0wWw/2EuG5NVgIg/T8qQlsVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Iw8Z4lVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Iw8Z4lVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD00C4CEF7;
	Tue, 17 Mar 2026 19:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773775057;
	bh=W+368n3zmFZXeS0XIlxfHQZMscjYF0bb1lj3Rt3JIVs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Iw8Z4lVGvpXYmOoizM4V5P1V32PyCVMQTnvl26cVXiRi6dtxJJ1g0tmIH9JcrXS8h
	 NfHGAkv96sULc+DE8OA+1bvXBc9em3BR73SRfmzq6nTN7LI8/5PVHhI2mAGE0sC7k5
	 RDUCUrZaMzokURlDmCZIYxiThV5Xbk43KYwfcb6w=
Date: Tue, 17 Mar 2026 12:17:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Brendan Jackman
 <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Subject: Re: [PATCH] mm: add memory.compact_unevictable_allowed cgroup
 attribute
Message-Id: <20260317121736.f73a828de2a989d1a07efea1@linux-foundation.org>
In-Reply-To: <20260317100058.2316997-1-d-tatianin@yandex-team.ru>
References: <20260317100058.2316997-1-d-tatianin@yandex-team.ru>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Mar 2026 13:00:58 +0300 Daniil Tatianin <d-tatianin@yandex-team.ru> wrote:

> The current global sysctl compact_unevictable_allowed is too coarse.
> In environments with mixed workloads, we may want to protect specific
> important cgroups from compaction to ensure their stability and
> responsiveness, while allowing compaction for others.
> 
> This patch introduces a per-memcg compact_unevictable_allowed attribute.
> This allows granular control over whether unevictable pages in a specific
> cgroup can be compacted. The global sysctl still takes precedence if set
> to disallow compaction, but this new setting allows opting out specific
> cgroups.
> 
> This also adds a new ISOLATE_UNEVICTABLE_CHECK_MEMCG flag to
> isolate_migratepages_block to preserve the old behavior for the
> ISOLATE_UNEVICTABLE flag unconditionally used by
> isolage_migratepages_range.

AI review asked questions:
	https://sashiko.dev/#/patchset/20260317100058.2316997-1-d-tatianin@yandex-team.ru
