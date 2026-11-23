Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795465346;
	b=tKX+JVysR6Pr7cUVyak+ZO38uo5oirngFU1l+XTY7iHO03uLg4vmaELxowXIRm7X3xNt
	 7dbQ9hOOk62jy2yfOcJfYkt9FVLXeWgw23YkNBKPpTjlj+4qb8OiCOtjph6HBWog1wGjR
	 Of9ihCLsYs8yurhUHhO1xU3+ZdsLSmM+iT3MJ0dUZ+tmmtbsMWV4sMBtVBHlwj1Iot8Nt
	 rM1jzhQ385PLWCJikBH5QuJp/LYbWCtX/2erq5b7lBJgWZx8tKSS7gQpCXKC70hLF833A
	 swsUy8mRw5tatQUn90O0KpM+Mj2P75+SRyO4gRbsVkTOsAqhb8JYjrsNf/7g5YS9lqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465346;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=25UVLybwoRnEcpbdXV2pFcFQ0Vqv+61x2so2s19OgUM=;
	b=jaD2Boq/m0vTissas0mSgLSUOuJY8lUmnI3t14SMnwZJHbQeH0/bWRTS8yxvTgUu2PwQ
	 24jGpSk2qwxnXFbUT72BdvpT/CtKIu6f6vjA3nopx5zYebiRVAb/Xg8W8LrfxLJxeN5jH
	 vZu/S6U6uUN1Pdln9Oi+YzI5xCzRM3T6mB64xN/o2U9XTE17zPJJmvxa1SBWAb0TsOv13
	 BRL84MTnkiorTpefRLJ1n63aJ/mSpU5eUdjsIBD4TcdUZLzm03FqXXRh60wc/XfKg5Hpb
	 Th1hcah9aA/yT7m3hOCo98DUIFU41m/n2Z6Yp0RmeA5WjB7JgnNQaqFoQgKaabfk9PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DwAC8cHH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CCB606A31E;
	Mon, 23 Nov 2026 20:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DwAC8cHH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04ACC1F000EB;
	Mon, 23 Nov 2026 20:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795465346;
	bh=25UVLybwoRnEcpbdXV2pFcFQ0Vqv+61x2so2s19OgUM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DwAC8cHHY+5qU8NdK2ZbrsvhxFqopogKwAxsWk8kEnCCVT6Hmbtw0V6XziVvGOJFl
	 UqXnmynokZ9RofSYPre5yp5SaL+eP7gD+iVzbExurknf8l0NwCrdN3RTO1xJ6LK71f
	 8PNPmpHS6+1C0lJh+4nQoWqAlcS3s5LQourJH+QE=
Date: Mon, 23 Nov 2026 12:22:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Muchun Song
 <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Ying Huang
 <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He
 <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Nhat Pham
 <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan
 <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins
 <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes
 <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, Vernon Yang
 <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, Tal Zussman
 <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, Xiang Liu
 <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, Zhao
 Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>,
 Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>,
 Hui Zhu <hui.zhu@linux.dev>, Maxim Muzafarov <maxmuzaf@gmail.com>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen
 <hi@tychen.cc>, Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 00/18] mm/mglru: frequency guided promotion
 (MGLRU-FG) and flag cleanup
Message-Id: <20261123122223.ea225d3b6424c274679b41de@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 24 Nov 2026 02:52:52 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> This series implements MGLRU-FG following the idea proposed at LSF/MM/BPF
> this year [1], based on current mm-new. Depending on the workload, it
> improves the performance or reduces IO by roughly 10% to over 50%,
> fixes multiple long-standing issues with MGLRU metrics, and drops one
> page flag.

Great, I'll add this to mm-new and shall move it into mm-unstable
(hence linux-next) promptly.

I tested v4 quite hard last week and I view the risk of breaking
linux-next to be low.

> The series has been tested on multiple platforms (desktop, large server,
> Android phone, x86_64 and arm64 VM boxes) covering many typical benchmarks,
> databases and real applications, so far everything looks nice, with good
> test reports from other individual testers too.
> 
> Different workloads may get a flat, minor or dramatic improvement, the
> gain here is mostly from real improvement of LRU's ability to distinguish
> the hotter workingset.

Well, the hunt is on to find something which got slower.  No luck so far!

> - Minor optimization for clearing refs:
>  https://lore.kernel.org/all/CAMgjq7Dd=Y+GekSD9WO5oGdoa+S1eG3T-U=VsCexopvb723zFA@mail.gmail.com/

Right.  That was the only question mark I could find and it sounds like
you erased that one.

