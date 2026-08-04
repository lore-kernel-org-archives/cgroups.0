Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB80939EF2B
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 02:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785809502; cv=none; b=IitESg3bnKfJ9gntU0QheK36rIRL0ll/uBVkhDb6AxbYaV+8TBzBxI9U7F3mMg98l0Qd99azPPLtVUfwGlhSCQepjoUPWcl8FLwi0V4eGjgL/3cbRLVRoiPK3zuzs+i0ykQ0iKdpXGI90u5qUZoa/9xjaE4tQm8RhCM1PGcEwVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785809502; c=relaxed/simple;
	bh=zfEclrsYG5vOGszMKMLbEZ81QNfoN8o4EjK1qOVqQUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOfwxV5aDDbLk84shvscajamlWpO9OTOwLImrsoeSTaGnYdeWDpBWaU6qbcIpE6JqVAExIQJvS+TKClEzzxoikSM3lIQMUydOk0uEjww+WH3b1w/AXkYNIFU7L+WU+wsnCt9L4kYdOR0EEo3WpDR6230dK4x6jlRsqCg4kYt+Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dw/ncJrC; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dw/ncJrC"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso4939258a91.2
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 19:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785809496; x=1786414296; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8SYycNF3WUCSlS4WaCTVXd7p9H/S1LXP/nnaP+2x+nY=;
        b=dw/ncJrCjhWsODPpFpqPYysAgILgTJRtYgV3qVaKAjnRiNNxqw+HJcpk295/y6dcsz
         k7ELveudJHGprit/Vqxgqjdzl1r/9UppKclJLn/PRkoRTpKNd4zaA5LLiSxY9cqkoOvy
         Burt7+FG4/EfgZ3rdZQYZHXilVPm/0ay+nP++wwg6d6qQOr3LTzq/MMq0TzZB1aEFi9u
         wJ/fiv9AFqrasc22HAxvig/ZzfZPqjU4Gm4e8sxSuh9iXGRPyZyY6Lhsy9uZ+WbxpSM6
         XjjABkQAzxHwTRrS+oo2ffGdiZRl1kjlewe03AajFnF/NIXE2OLHjV6DvIjFaAKabq25
         ojMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785809496; x=1786414296;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8SYycNF3WUCSlS4WaCTVXd7p9H/S1LXP/nnaP+2x+nY=;
        b=QB/5mAYfyB67pNAIstjp5Bnel0L8IL0B86CTSlI4oi7ysCgbuempsRZuUEePXMFY9N
         D7VPYMDpYdS6fI7Nsb+nOGe7m62ZXYJp69Z/m4WVFW/KAzBVx4wSxTpwlnlPOOYViaE3
         G1506VLAGBiuxDqNl9PYSGZzC+OCIhhyDn6Zgnn/0gEhLXLaGGqbmld9/b8Vc9qwRW/M
         /S5cP7B5KBtApzlcK2id4V1+s3BfZhM4b6XSx8AGuwKW5avnhY73QBq6GJ75L6+rdMOC
         CoZ4bMmBW3yjKBzyEe2+Wbo7RUXqCSj7y4jz8y+exrSGZOUb/vaPYaB0LkFFLneFjQCh
         LAsQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro/AEB7XOnwM3pDvS77NRme3sxI6IEY/OTSoe6QB0jZZ5Pjjd5UqUl9NxJwuTVNfHUIbyTpIMcC@vger.kernel.org
X-Gm-Message-State: AOJu0YzHwks72ZLOG+KRssJhu57VpRkZfjrfJdF/7sJjsOI1vCaXAMt2
	VoDx9ENsce+ibLbglziLq6WveRMN92wAY1ArEMKNnMEFrrF7+nX+YKyDPnpk5GSYw/I=
X-Gm-Gg: AR+sD113FHhq0MnCHqzH3yYWxRTEM58lE4mxBITeliSfBBeVz03dCj4BVffbXH82ADl
	WLuv8GJiirLHy+8frAKj5bAP3Y/4dfLl6vjwgv3dSMhIarJ80TA15bO82MQTimbxbmtoxwBTrEl
	MpIMx6ySYEF8yJIdbYJKd5CXzEOw3QW1UkpQLDfzCSgNQEyY6WNpwPBODYsFIcFeSJNE1EOmO5/
	B69Ewjl4mUQRK2XYTKK6SO6ep7Z6wKqGPqIfkci6ixbyaWcn0LQKgMqtYGat4WWUlYEngPlZ5dX
	3zvkfpS9AK0IDx2BM5YoNQGvGkfO4W2W5lU38oim9KfXjMPY8NyK9OooBwjX5u/NFEmNndHJKPa
	8oCRLZb2qSC9KGg4RCXiBUP66M073F8g/vsAxOReDsqDwfsqszEUjYt4BwrfoJFNnoN/RR7s5sB
	lGDYtvJo0L1H1HGRcKt8/DUTyMf8AlET0pQc+JWZMtWkkCmvBUk9yL/yg9008ak2LRr6j7ryAZn
	2IIc6j6flOeLiUF3rs7OQXeWS7kB8vaUPA=
X-Received: by 2002:a17:90b:4b02:b0:38e:bbf1:de34 with SMTP id 98e67ed59e1d1-38fbc3e7e39mr11745590a91.7.1785809495777;
        Mon, 03 Aug 2026 19:11:35 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38febff7eedsm515509a91.5.2026.08.03.19.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 19:11:35 -0700 (PDT)
Date: Tue, 4 Aug 2026 10:11:21 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SeongJae Park <sj@kernel.org>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 12/15] mm/smap: report workingset folios as referenced
Message-ID: <anFJMBI5Q24BEdkn@KASONG-MC4>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-12-4d8dad39dad6@tencent.com>
 <anE-nSqyXcG1g5zQ@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anE-nSqyXcG1g5zQ@cmpxchg.org>

On Mon, Aug 03, 2026 at 09:21:33PM +0800, Johannes Weiner wrote:
> On Tue, Aug 04, 2026 at 03:47:08AM +0800, Kairui Song via B4 Relay wrote:
> > @@ -944,6 +944,22 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
> >  	}
> >  }
> >  
> > +static bool smap_check_folio_referenced(struct folio *folio)
> > +{
> > +	if (lru_gen_enabled())
> > +		return folio_is_referenced(folio);
> > +	else
> > +		return folio_is_referenced_by_bit(folio);
> > +}
> > +
> > +static void smap_clear_folio_referenced(struct folio *folio)
> > +{
> > +	if (lru_gen_enabled())
> > +		folio_set_lru_refs(folio, 0);
> > +	else
> > +		folio_clear_referenced_by_bit(folio);
> > +}
> 
> I don't really understand this and the preceding 2 patches.
> 
> What is the benefit of a "shared" ref/workingset state implementation
> when you then still have separate APIs for querying & modifying?
> 
> Switching some these callers from folio_test_workingset() to
> folio_is_workingset()? But both functions continue to exist?
> 
> Why not make versions of folio_test_workingset(),
> folio_test_referenced(), folio_clear_referenced() etc. that do the
> arbitration (bit ops on classic, refs ops on mglru) and leave callers
> that are only interested in boolean states, like here, alone?
> 
> folio_test_anon(), folio_test_lazyfree(), folio_test_swapcache() -
> there are many examples where they don't just test a raw bit but
> assess more complex, composed state.
> 

Sound good, I just copied the folio_is/mark_workingset helper from
my previous combined RFC, where I tried to drop PG_workingset hence
used a standalone helper to convert the users one by one for easier
audit and tracking.

I think I can just replace the default helpers and have zero effect
for CLRU. There are actually a few more helpers not used but introduced
here, will drop these in V2. Thanks for the review!
