Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046965;
	b=EkP5Wkg6CCoO/jAJvfKfeBAAheIfHglzt5IKOD/aPe8n8BH0XmB1vhGZVnYEKXvxnduD
	 11sTuRNQdWmxpx9jzYDrtRkTJg0KyGEApLXHulGTQ/ZcMgf824/zwqdzNKntknG0qCuO7
	 PMsrfRu/6T41ZyRDXu8vY+xM8e+5LeAkrzj835BzPPgXyyUWdqb8kKnERWvMhriKE425w
	 V+YY5DvShQeP6D3nSJEXhaiorpj2fnV4TR0FbX0rpCSaRwbNGNK1q/83uQSRy7ns6tuyu
	 yzYA1EkjC2wLVwXIajCPi0isD9j/IUZ7RGUa67y6uRD/4zjogF9cy8y865xJeVLGiKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046965;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=VqcrwoCztAKpY/Tq1T0uZhbHihAEPIjWKmk0N4arOGA=;
	b=ff6HiEV+AUZ6hlvO2xUgM/Z/XW0CwWzf9yGeRjTmX7O/Z6pF3LD9/EgGc5uN7uTjA0Jh
	 gaMA8XD9gZgLwUOyVlRMC2MnWARXsOuDIA5KJ9r9Yoe9PHgj6mEN1o9GjAw5oP1rlxwaG
	 zO4wnmoUaRqt2UKIbk46gBS0zll/qxukc4nbK2959zIRCBvOovCp9WKlnpOFWmQCK1aUY
	 BaD1V68xTy74EADvVOmGuI3+whIwtHfJJmL/vJ/v4aHwl2pceuUODGNqO/SN93ddCwSTc
	 B58gttGErSW4pEbRN9Av6I0Rbb0vdgyx0iDeYG+X0lyndWStLt/01fCkb2I0LZV5fWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmpxchg.org;
	spf=pass smtp.mailfrom=cmpxchg.org;
	dkim=pass header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=eX1Yz2qu;
	arc=none smtp.remote-ip=209.85.128.173
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B636606A337
	for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 00:09:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B636606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=eX1Yz2qu
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b503e2a87bso12373887b3.3
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 16:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1795046963; x=1795651763; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VqcrwoCztAKpY/Tq1T0uZhbHihAEPIjWKmk0N4arOGA=;
        b=eX1Yz2quNliQ9kJGqzWY4M2+BbJJhvB5AlbNRuzhWx1cfsr4l8ERV2dTky2i86zlO8
         Vcj3LRN2JKWvjl2MON9EYzNxkCDoSghxWA5QzS8EOS829DFUFKLCMCpzsv6cdlH4S6ro
         yXKKxEKXb0NfhYaezx63+N/tqQhO93ZFydTLOgksWlNuFUk2uXAvR7R+1fx8QKzFFuTa
         kPI+zcz4ipoCWonZsSpYmaD2Np4eWZwzu0POnEbAyw6f3MrJOhVFR7wvVxnJVv6vibyY
         Ja3VMVaO3EOw4Z1UrijNqGIWMk1pcpigm3TCYty9mW86DEsk0hMG4g34IddRPuuiSIE1
         R3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795046963; x=1795651763;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VqcrwoCztAKpY/Tq1T0uZhbHihAEPIjWKmk0N4arOGA=;
        b=wn6iHePOATWEHfMGBlK1//ECCEx9TI3QLVEjQu/bL+1a6+D2/3kheH/cnv4yLtemP9
         Y4lzQgffpMM0YDDsoCFHVyrl/BhShbV8aA/nTqDpy8X9TzzoitmP1jGFdpwcIjoMnEsp
         QtkceSVGIGKpp8Z/Mo0+bD01SvWttWaEgudIOuGWPIQsedlP0Fsy734JbSvQ6D7z3NjY
         QqJlOAM2RTqUSPLchnUncKC9bNzisxUV8WSpV/QlJlLsyFp7KajFZ62X+uHDXPVuOt3F
         5/1+i0FBpa6fAwFOnP3j1/uqlTnrKNCecWoz/WFOOaYtFeH/VDkBrMacXzeCiasGBC58
         ThQg==
X-Forwarded-Encrypted: i=1; AL+hErEGk2V2D+V2090S+C+is8epMnQ9OXIT6HsRQ7u9oQ589z6dGVgw+NxaknOawKFeHI5VdgrLIdkc@vger.kernel.org
X-Gm-Message-State: APuU4Z+nWD24gJxUjOCeNxqR0l/VRoMgTQeEGx800ndssZwEvJqWZVMP
	s2cN1Uvagvl6qbxzYsfV4PxJlagL6IvZJ2vvcmADX6ulhlMUiXFJJJ6bz4k4msJw5V8=
X-Gm-Gg: AZFdTZdEtKgZ2akVXyWIdL2UE8QONR159Hxr8H68gFk+eHhWteDx0jBr2SGbP9fiTPj
	NDTxgrdyK8QObX7Y5g9i0QGoc9OFtHiSXhXgQtOXfy3AOXu12Tj2gqGrt4OehH0ZWNu+wKMNbpt
	xjYE/b6YBOvViP9WuM3fGJbmZLblwahCNRNNbuRcvH2pF5Ji3gW5Wh11LUI6E0grrFCi499ZUQQ
	3wgxeDZpbzMTEt7PllaPp8+tfppTdWkey8ZZ5xl9J04RYqf2uF4PYiUmD56fxcWocHO8Kxed/HO
	O45Pe4wz1Kos6/LdlpMTmnppHzOnz9qIiHf9cJzAxT9pOJhQ3tL1YTGFMwP3ieirPhT5hD0Cpu1
	1Wkt9T7Fy7Xb2R2mMHF5Ew0j15P5tZoC918DeE7fIV3Fc1RYCKDO/Ep0vOrVpgHmDQ12xvBjH4F
	OAF0TS5rZ6PDw3k8/YW2Oz2UIfukwbN7pwuGUdtp0XPqgLXknrXiJvcL4JKSL6h/jMhOzZoiPEe
	ft7A9lqB6oiXsaUNLsYTU9+Mey+veZE+ppZU/Lz1uquvvrZPEy2eMExk2RaiWXsTAzzWi2EvGVQ
	dfQJ/oHpqyza39SDqGGeh8MF8zLgELzwzDJqylNBMl3cjj9Upg==
X-Received: by 2002:a05:690c:6d83:b0:8b0:df71:44cf with SMTP id 00721157ae682-8b4fed0a8f5mr20096457b3.15.1795046962815;
        Wed, 18 Nov 2026 16:09:22 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4fe03091esm26030767b3.12.2026.11.18.16.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 16:09:21 -0800 (PST)
Date: Wed, 18 Nov 2026 19:09:20 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jaewon Kim <jaewon31.kim@samsung.com>,
	Jaeseon Sim <jason.sim@samsung.com>,
	Youngchan Kim <ycshark.kim@samsung.com>,
	Dmitry Skiba <dskiba@google.com>
Subject: Re: [PATCH] mm: workingset: compare shadow nodes node-wide without
 kmem accounting
Message-ID: <av4-MCNVImLfcmMO@cmpxchg.org>
References: <20261106235904.1092712-1-tjmercier@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106235904.1092712-1-tjmercier@google.com>

On Fri, Nov 06, 2026 at 03:59:04PM -0800, T.J. Mercier wrote:
> count_shadow_nodes() limits the number of xarray nodes holding shadow
> entries to 1/8th of the pages that could be using them. For a memcg, it
> counts the LRU and slab pages local to that memcg.
> 
> With kmem accounting disabled (cgroup.memory=nokmem), shadow nodes are
> not charged to any memcg and __list_lru_init() makes the shadow_nodes
> list_lru non-memcg-aware, so all shadow nodes of a NUMA node are on a
> single list. shrinker_alloc() falls back to a non-memcg-aware shadow
> node shrinker, which shrink_slab() only invokes for the root memcg.
> count_shadow_nodes() therefore compares every shadow node on the NUMA
> node against the pages local to the root memcg.
> 
> When most tasks run in child memcgs, the root memcg only holds a small
> fraction of all pages, so the shadow node limit derived from the root
> memcg page count is far below the number of shadow nodes on the NUMA
> node. Since the shrinker has seeks == 0, every root shrink_slab() call
> trims about half of the "excess" shadow nodes. Most refault information
> is thrown away, so refaults of recently evicted file folios are not
> detected. Refaulted folios lose PG_workingset and the workingset_refault
> and workingset_restore stats drop.
> 
> In testing on devices with kmem accounting disabled, moving tasks from
> the root memcg into per-application memcgs dropped workingset_nodes from
> ~37,000 to ~900 and raised workingset_nodereclaim 4.6x while
> pgsteal_file rose by ~12%.
> 
> When kmem accounting is disabled, compare the shadow nodes against the
> whole NUMA node, as is done without memcg. Behavior with kmem
> accounting enabled is unchanged.
> 
> Cc: Jaewon Kim <jaewon31.kim@samsung.com>
> Tested-by: Jaeseon Sim <jason.sim@samsung.com> # Galaxy A18 LTE
> Tested-by: Youngchan Kim <ycshark.kim@samsung.com> # Galaxy S27
> Tested-by: Dmitry Skiba <dskiba@google.com> # Pixel 10
> Signed-off-by: T.J. Mercier <tjmercier@google.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Looks good to me. Yeah I don't think nokmem is used by too many
different environments!
