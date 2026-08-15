Received: from mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD84213254
	for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 00:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786755057; cv=none; b=gdTJZDAqzKPHX8asqWsIKCowJoQuXrngu/mrKtAdak0GrPcP+DdAC+lajVh3nGcIZ3IGzC0pOyrnIthuPaT1iXixT8cSR9HoAbsoDphvuRQbAM4hM7K/XEp/G7pvfGUB7AZsjkHyzOyOL3JrrVwNHLcaQRJLLLj4xfQ+d+wxybY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786755057; c=relaxed/simple;
	bh=76/lMek3I/Lm2DW5pZ43j1lOWGN+BgwgiOZBOJZUj0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCxxOQDEMUJs/qo/F0Lj26ON41I6Tr/L9NArn7BLD+StRsZuislNWi0P/BfmSNTUkxODcKBHFJt8A8e/KTdfCDM8GkSz/IZzoTK3x7gBzwDTnPlPJhMdM6fbFVBFgNMqXhE631A3gyJcqodfuAjHePZ6tHwRoCMzLFkyK74Kt1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T/5uVyRr; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T/5uVyRr"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=76/lMek3I/Lm2DW5pZ43j1lOWGN+BgwgiOZBOJZUj0E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786755053; v=1; x=1787359853;
 b=T/5uVyRrVviafwxqmWzk85xw6vUb5zOTXbqkBjjcXbzT4jxvV+GrgoyvY6KGQvrfjt1R+1wn
 ej834zA5R8CMgdVIh/C9hjZPvty+/+CHW0osf1h4blGBv6ww3zfceSkb/4PMZZEYAKSfwjssbsz
 FRNuP2oBPHlKJngZccb0d5/M=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:70::)
	by smtp.migadu.com with ESMTPS id 95cad438e84247e2;
	Sat, 15 Aug 2026 00:50:53 +0000
X-Migadu-Flow: FLOW_OUT
Date: Fri, 14 Aug 2026 17:50:48 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/9] memcg: make the v1 soft limit knob inert
Message-ID: <an-3qupr53VNNOUa@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-2-shakeel.butt@linux.dev>
 <an1-4Rgwlsfd9Hjt@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an1-4Rgwlsfd9Hjt@tiehlicka>

On Thu, Aug 13, 2026 at 10:22:57AM +0200, Michal Hocko wrote:
> On Tue 11-08-26 13:31:55, Shakeel Butt wrote:
> > The v1 soft limit has been deprecated since v6.12 and nobody has
> > reported depending on it. Start the removal by decoupling the interface
> > from the implementation: keep memory.soft_limit_in_bytes, but ignore
> > writes to it and always report the maximum value on read similar to
> > what memory.kmem.limit_in_bytes already does.
> > 
> > Writes are still parsed, so malformed input keeps returning -EINVAL.
> > The knob now also behaves the same everywhere: it used to return
> > -EOPNOTSUPP on PREEMPT_RT, where soft limit reclaim has always been
> > disabled.
> 
> Is there any specific reason to not return EOPNOTSUPP for everybody now?

I followed the memory.kmem.limit_in_bytes example. If you have strong opinion, I
am ok with EOPNOTSUPP as well.

> 
> > This also fixes the syzbot report linked below. Soft limit reclaim is
> > the only caller that runs shrink_lruvec() from kswapd against a
> > specific memcg, so it is the only way to reach lru_gen_shrink_lruvec()
> > and in turn set_mm_walk(), which warns when called from kswapd.
> > 
> > Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Anyway
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks for reviewing the series.
