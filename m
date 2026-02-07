Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA523277011
	for <cgroups@vger.kernel.org>; Sat,  7 Feb 2026 01:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770427722; cv=none; b=NA6HevaUgJLg6B5E03ojvggZEkB9t7ODLXO3xMdD22ofT/B3P+I6l2zDnlOzRnLS583tN+V6kHmrPgqXcMmXHnigqsfsc9et0FB3ElXjPV9zUXwaQSWSFvEe+jieufpfTPvtdGXKgZHHj4Y2o74kwAjca3HngXAbALTuxH+mYGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770427722; c=relaxed/simple;
	bh=+ffM72bpvKODee5kEkQBZOPCaBjXjE1xmt5Ucj+SFag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4FlCWcN94Of0ZRe7wYcwU1kEb0r/H12eir677DD24ku43b/YAZ0Vqf6OSc7q6veJ96/xRmf5WZqA7J211nb6V2tcesl85RmEEPWGJ61/n1P/JEiJpLTz2uK2z6Fky3ftQB1gZRRApU2y8hi3naQX6ktbmG/blLuOLoybLnjxJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n4EoziCy; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n4EoziCy"
Date: Fri, 6 Feb 2026 17:28:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770427716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2KiVjlTLbuL/enTYJjSv25CIgwiMxffKNXItGReEOzA=;
	b=n4EoziCyzN/t2U4wGbUHcReaoO7DAa3lBUTeTN0xmGggQkj4GpFIifcNxOQZIPMpyqy62h
	Y8AJXjO4Im4zHX/X2ysMVeg9L6eLyZ/0bmocJOb/s16Srn72gZPh9TsRv/nm2uRGrP8Lrb
	2Fm41jY3+QZScxISbwECnTyZg2/k4n8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 25/31] mm: vmscan: prepare for reparenting traditional
 LRU folios
Message-ID: <aYaVIzw6cVUO72A5@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <26efe2997261631c951d326bef6a20fe0796c43c.1770279888.git.zhengqi.arch@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26efe2997261631c951d326bef6a20fe0796c43c.1770279888.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 05, 2026 at 05:01:44PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> To resolve the dying memcg issue, we need to reparent LRU folios of child
> memcg to its parent memcg. For traditional LRU list, each lruvec of every
> memcg comprises four LRU lists. Due to the symmetry of the LRU lists, it
> is feasible to transfer the LRU lists from a memcg to its parent memcg
> during the reparenting process.
> 
> This commit implements the specific function, which will be used during
> the reparenting process.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
