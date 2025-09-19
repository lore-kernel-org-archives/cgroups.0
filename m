Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6BD25BEF1
	for <cgroups@vger.kernel.org>; Fri, 19 Sep 2025 21:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758317459; cv=none; b=NvzacIJ+gVeY5mB/8qjKTFd2bu92iRQ9l7Yk0VH3LCEJTjQrIXOOsLQwWJbcGE2M05XoNUk61oI14e36BNEzB5C/xxT0GO28b9A4d1vfv/FLbcLHtjc0PSU73FFzkTYCwILG4/3HGsx2Nbgo79uAirqkOcAA5XHYp8hOR3it4qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758317459; c=relaxed/simple;
	bh=3dXD2EOiARgrAuGNOZExnJaqd+/7J94+WWnFY5LBOf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=byj/gY3Eh0EMhERZbRL61wBHwztZFZhtuhJ95/ZvOBxiPOCrP6wvqlnGM3hCTWB/lpPAHKfwi0WHf2ulxDPhaft/pAvnOL50+9JOrpwHSsod2IZ3GQthjhQtvkJuG0Hd+tIeA3OAqL1LVAEIkgGrpBNHa0MLfI16ouJ7zgq8fZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JaUd4+A7; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JaUd4+A7"
Date: Fri, 19 Sep 2025 14:30:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758317455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nePlvBxaX+05CB+7UEJ5zSphde1td/eCwPVeg6HHBdk=;
	b=JaUd4+A7i1eAbmEufsJ8+rltM7gxxF/Didf5CeXL6bRhg7LuWe1HFJjaSRQXnfhavpHCBx
	whhbAzGBSW8dpzIRgPSdSc8iKHulo6kQOW8YpfRiLkauIBSrQNL5McNsJt6ttzCjxI40dx
	h05Sr6BSAlLK5AbiMGXGTie6mKujuHs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH 1/4] mm: thp: replace folio_memcg() with
 folio_memcg_charged()
Message-ID: <yi5eghzjegjvu7tq5b3os6cxt6lcgfpu2xv7m3yiywppq2xcl6@lneq7zbtm6kl>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
 <35038de39456f827c88766b90a1cec93cf151ef2.1758253018.git.zhengqi.arch@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35038de39456f827c88766b90a1cec93cf151ef2.1758253018.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 19, 2025 at 11:46:32AM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> folio_memcg_charged() is intended for use when the user is unconcerned
> about the returned memcg pointer. It is more efficient than folio_memcg().
> Therefore, replace folio_memcg() with folio_memcg_charged().
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

