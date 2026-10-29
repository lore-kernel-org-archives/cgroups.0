Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254155;
	b=ac7tkkTgabLnZl2D60z5hnTy5vpKsGLmzR3aHl7P+mOOrojUgk9ch7s1oYr/utIH+qJP
	 kl3iuvm5CYEBXxHuu2PT5PTArSVVaZ/XM2OK+pZ3aYiPtK4p2ekY8xtFIpyvG4UENP5q8
	 7Ke2600p3WVuZYcxCqUEdeh0bmnEax8OQxT43wnyz/GJNIK4+nBt8r+pvrTyQ4606Cebs
	 jDbCVryY/DyNCFuzxS9BIGq9qCZuzzbvkECyG/1AXF9LU0F92jp+viKDkBB44vDIY8FbT
	 16ds+o795/YsgdMRLiH6ALi/RGlemZBvjrwzD30FovGYaZZcAV5InEvgnrYNwAnxAFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254155;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=WifFjtHgZkJ4eUGZzP2SLgCkpK+TLdKe5MTWOWYju04=;
	b=eOZJgJXIO6hpG9hTK9zn+8Ulb1YYdiWCDyxGyCop3gf1ph51V/tvRSVQQRf10tn8fevp
	 12hL3uNTPSr/la/OPvhwx6PHXyhKoM6JeOw/mwv7YjZXuTTs/fbfT1pSIIPlW9Uaw4NPq
	 mo94DhDHzPQ16dRzF+HbJQf/4ygNYfNIQbbUnghHXd8knfTnJAjtzZP24VODdu7mfBYs5
	 uyUFpBekuhm9I4B9dgXDDaxhRIBUw7QWwFDrRtb9pfUKut6DFd1zScaS0Rm16VnxJGP+x
	 cYN4dRhhEM+/noeGK0OseQWXNHkQ467zAM8gXv+7YlIs+dS0XwNqLM+5tjUhnrcZwGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Ei5dsryP;
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D2D606A31A;
	Thu, 29 Oct 2026 06:09:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07D2D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Ei5dsryP
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793254149; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WifFjtHgZkJ4eUGZzP2SLgCkpK+TLdKe5MTWOWYju04=;
	b=Ei5dsryPDbSXJE3ao7LiehUItmwhBnOGDzax7VUcJAh/I4ecobYxJgKTg5jSSgBBaeGWvswYaCcb4Wlf+rkC0F59rTEBbwoPAf+jFy4hGGTydXLDxcA8mQdsq+bno1lY03UjVlQtjl7k25Mik5RCtpO1GVAN7geGlx5PprGAR0M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XDiZZYp_1793254146;
Received: from 30.74.144.149(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDiZZYp_1793254146 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Oct 2026 14:09:07 +0800
Message-ID: <62b92624-9d64-49a4-a67a-ad54ca6d9be1@linux.alibaba.com>
Date: Thu, 29 Oct 2026 14:09:06 +0800
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
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old
 generation
To: "T.J. Mercier" <tjmercier@google.com>, roman.gushchin@linux.dev,
 muchun.song@linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261028010611.3929937-3-tjmercier@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/28/26 9:06 AM, T.J. Mercier wrote:
> lru_gen_offline_memcg() moves an offlining memcg to the head of the old
> generation of the memcg LRU (MEMCG_LRU_OLD), so that global reclaim
> visits it first and evicts the folios it left behind.
> 
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios"), those folios are reparented to the
> parent before lru_gen_offline_memcg() runs, and nothing can be added
> back to the offlined memcg's lruvec afterwards. Putting an empty
> offlined memcg at the head of the old generation no longer serves any
> purpose and only delays reclaim from the memcgs that still have memory
> due to additional shrink_many() iteration.
> 
> Remove lru_gen_offline_memcg(), so that an offlined memcg is rotated
> like any other memcg below the reclaimable size threshold until
> lru_gen_release_memcg() takes it off the memcg LRU. MEMCG_LRU_OLD has no
> other user, so remove the op and update the memcg LRU comment as well.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---

Thanks for the cleanups. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
