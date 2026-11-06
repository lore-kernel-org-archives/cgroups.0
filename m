Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.32.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793955486;
	b=cGk35mx9hIQVkq3mNMn+qOCsLDUbIC+Rrrwj9O5MMGOxFRRgbE4lbYqRwI36LUs9xwC/
	 rr+5vKypPFUD9cwy0ZvvzeHrzPok2QGVDZH0OH08KSpKPbNOua9XqBnl0MICaX9MPCnQQ
	 wDH4jnaXH3IkQX+HWe5LbcTg2OOpQu1AO4XazLjcFz5VW9NosxfejG5X1IuAldIJwemtI
	 yYVI0aoyjTUbrf4zW8ypJD/gk8wCmrNvDzTnhL0C7OjFaxRSc0p9ZmTb+1rIDLby3YRA8
	 1vxXBrcrVyMC21UfoZU6XLfFfhnfBfcBSL3Pfo5P4tG65dUbPrqSmmue6sfi8Rktfaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793955486;
	h=DMARC-Filter:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:X-HM-Spam-Status:
	 DKIM-Signature;
	bh=Y9b1zETzpGuZPT2LRJGQZGXEXsJRKPedVyL9/8wejHA=;
	b=N3rjWgvwB4muq/XVSZq08wpgqkdotEKiI6WTNGM60+UD4BIEl4zs87MGini0Tt2jCtu+
	 qeU25or7mry3zUFQE6mpoehnoO5ZnoHYtyg/yY9NsUAG5PzZURnj9aLnxma29NaJ3goRK
	 AC57p8kzb8iUUx2ZZeZaQYlZRBOFL5eW7ikCZmw1PoZ30+DqSL7LHKVTc23aLCr2uSqTC
	 7FBWTgi4xPdKKu/sRlFbOlEfBrmip1eZq/BdYbZ1kb+wT6tv9O8KWoHCKn/z4O+nKDjOa
	 Mc25CxfuZByWjPz3DRrb0pZQhOE/91aIwEAoKmumhK82Ll0QdreiAPe4GOxODN7QJtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=deepseek.com;
	spf=pass smtp.mailfrom=deepseek.com;
	dkim=pass header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b="fN9dhDJ/";
	arc=none smtp.remote-ip=220.197.32.106
Received: from mail-m32106.qiye.163.com (mail-m32106.qiye.163.com [220.197.32.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15FF606A332;
	Fri,  6 Nov 2026 08:58:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A15FF606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deepseek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=fN9dhDJ/
Received: from [198.18.0.1] (unknown [183.128.151.132])
	by smtp.qiye.163.com (Hmail) with ESMTP id 53c046e8e;
	Fri, 6 Nov 2026 16:57:53 +0800 (GMT+08:00)
Message-ID: <b58024d2-5e71-49c3-9aeb-15fceb0671e9@deepseek.com>
Date: Fri, 6 Nov 2026 16:57:52 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: fix memcg_data reads during a THP split
To: daejun7.park@samsung.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
From: Tao Yi <escape@deepseek.com>
In-Reply-To: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1b01426ce09dakunmfa798b8f1334d6
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDQkpLVkkdSkMaHx9KHhhKGFYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKQ0hVSklDVUpOSlVKSElZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJNS0pVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=fN9dhDJ/rsrUdQSQUvrX+sSjXePEn1KkXVgiNuICZPS+82bSnjrldyaoZI0FJRNOt6/8hd7NrIv123U6e97kg/VqpL9wZ18392PV3gqWQ1Fy6zc8xMXi7I+otQA6tfacH8Dj/k4VeHfIA85uf+5UwRc0oR1MGxqj2N1QT+HEWk4=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=Y9b1zETzpGuZPT2LRJGQZGXEXsJRKPedVyL9/8wejHA=;
	h=date:mime-version:subject:message-id:from;

Hi Daejun,

Sorry, I missed your email on the RFC thread. Thanks for following up
and for taking care of the fix.

在 2026/11/4 17:59, Daejun Park via B4 Relay 写道:
> Tao Yi reported an oops in page_cgroup_ino() while reading
> /proc/kpagecgroup and traced it to the THP split in an RFC [1]. The
> RFC skips frozen folios in the reader. Patch 1 moves the memcg_data
> copy in the split instead. Patch 2 orders the same loads in
> page_owner and needs patch 1.
>
> Charged large kmalloc pages are frozen, so the RFC would report them
> as uncharged. My review of the RFC [2] got no reply. Tested on x86_64
> with KASAN, see patch 1.
>
> [1] https://lore.kernel.org/all/20260907124001.1544655-1-escape@deepseek.com/
> [2] https://lore.kernel.org/all/20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d@epcms2p7/
>
> ---
> Daejun Park (2):
>        mm/huge_memory: set memcg_data before a split page leaves the folio
>        mm/page_owner: also check PageTail before reading memcg_data
>
>   mm/huge_memory.c | 17 +++++++++++++----
>   mm/memcontrol.c  |  9 ++++++++-
>   mm/page_owner.c  |  7 +++++++
>   3 files changed, 28 insertions(+), 5 deletions(-)
> ---
> base-commit: a13b500946e5dc467976838572b8ddd2fd777ca7
> change-id: 20261028-kpagecgroup-split-8a749c6ee27e
>
> Best regards,
