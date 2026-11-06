Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793969739;
	b=wDaatOHmBv6GX1tuTn+YXoctxrD66V9VgIEGaS0fO6ljx3nLji5nnuLO0+mpa7fQ+p3I
	 RnnweR07VDWJMz6nBjnj3/JurEofIN36/5bM0TNcKODnGYsVXtKy6Br2TiHM/z+5d84hQ
	 q31Vs2GuZDhm0c6yaQthw78Fr6T+oUkES6/DnLm4+PfUyYbbTehzI15Ux1tmcDgWvw9Yy
	 wpwtNOwViYyaiTe8yZVTwlSxwMQoYLWJuUTpfNOSKeeo1JOf0JkuIzDc5UzSjPjfZQhhB
	 iq34Yxls3ejWVSzGaqC9qar4Fuvc+xPvLTxus3wC6d2vZq8d81PkLv1+ftAvW5B9dEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793969739;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=uE91UOgBj8jv8YUB9c2MmH469EmfSYIyBsp9JTygT5Q=;
	b=W6A4UPnWXx81nyMe1tqaQ49xtwaomgTW4BsXBKnsqfI8Ni7t4QzjV2h+4h4NHLw2gA8O
	 7k32dcVweluZVUKOxU6W+HFJF4EXkJZlEjhueNN0bF241fUJV/UpfPr0HnV5Pauz0gZc/
	 43i3Ek01xgCIV0Q+RfTvILH/FXpL0XJefvRPeZkFH7vnZJUHlx1EXBT1C5zJrdx9JWRtz
	 cyVs6i5DIO2uRZKaNBptJ9Wp2NyaVZ0tcChIeNuU3FH0B24xf2+JZkDnw+wantQvU+M72
	 svGyt8bI/g4KsG8MI9vUtzZ0gYBoCcEI/szNpgY0oVHd0GAWER2wY8rLVZ8FhtFJtIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JTIMIdh3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DAC606A326;
	Fri,  6 Nov 2026 12:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JTIMIdh3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5022B1F0089F;
	Fri,  6 Nov 2026 12:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793969739;
	bh=uE91UOgBj8jv8YUB9c2MmH469EmfSYIyBsp9JTygT5Q=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=JTIMIdh3tteQGxSJWb2Jw4jcDdDBuKzj/qZIdJPLH3TuFteIT/alysb+Fk9XVZQF8
	 RIeeemVXIfjCUYROU3/F4jed2Ruk/wfKUDaeqSGR+B45iylPF/kgZK+7C9s4mlUB0A
	 kKLAN/c2zuSZ9/8LuJHPdUcFCqWKcYM25bAfLi/jmh0Vva5UTBxJ8CiTl0I4jgS6yv
	 b0oyre/UBnzGPBnWgijVXCO1NgDefIAEClRvG5xJTz9dwlvrz7suIaB9Lx5UweK+L2
	 V1uQdCK+RmQ99RAFgt6e62QqsEx16X2WQ1dUdXRCwTMPjy5tdGWXCQvZhkMc98Z1lW
	 TDx0h0LnH6jaw==
Message-ID: <36a854e2-712a-4d27-92ab-6719dd37e7a0@kernel.org>
Date: Fri, 6 Nov 2026 13:55:21 +0100
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
Subject: Re: Virtual Swap Sync
To: Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>,
 YoungJun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, =?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?=
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rik van Riel <riel@surriel.com>,
 Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry@kernel.org>
References: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/26 22:06, Nhat Pham wrote:
> Hi folks,
> 

Hi,

> Sorry for the delay in scheduling. I also figured it was not a good
> time with all the merge activity + the big list of issues that needs
> urgent attention :)

yeah ... thanks for taking care of this.

> 
> Since no one responded to the last email, I took the liberty to do
> some timezone math and create the meeting myself :) How does this
> sound?

I'll try to be there, no promises lol


-- 
Cheers,

David
