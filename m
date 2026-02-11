Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1AB1FE451
	for <cgroups@vger.kernel.org>; Wed, 11 Feb 2026 00:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770770306; cv=none; b=ExD0BgjMOiqc+0MO/B1eLUClflcIe44Fa6UlfKxD5jmRrkGp3VDO7GfDexHrawwKvzv8hUF0Vp6n7eYpPM4AK3dLJoyMqY7yl1y9CeEmIkax6n0NFZKRQR7z40LjivV7md4P0GOI+4lTMj6CPr9Kfb1w0EDv4BVjcI0GIykULbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770770306; c=relaxed/simple;
	bh=4K1bsS9FsrnaV4lN25Pd6F9YjUSRT5r+WMaVyQGDrh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1SVJ+YhWdPCZA2JPt8CumLY+OFW809gUgHmyTS/mNgmnyT2BItrKlss4Fi4BEPUV6wp9p9u0iyIRImvco1cUQsFcz4mvGE5WaRDYZIhEFDLE3E65SCPj2h1z9fZsspPRLes7ilozxbYoh1/fUdksmTUFEIl+PPsAN/guD5wLS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nGjpWQG2; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nGjpWQG2"
Date: Tue, 10 Feb 2026 16:38:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770770293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FbwdsItdNCVn/rOvfiUbXy89AP6MsD7J95YTJtH5IKY=;
	b=nGjpWQG2/c7L7wdCTrpV+AhW2KBz3M5rW7e7GCv58fHxE6WzUsIwwHKk5JLqeXsX5+05qN
	qoXZPTC9S2q3xvSGv8Bu+GVQFwoe8amFtgpZN4LDKfkYllOahsE7ivJOZ96n/wSlA5U+M1
	9wn+kGto9IbAxLcmGeUN3kZ2zd/EH/g=
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
Subject: Re: [PATCH v4 29/31] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <aYvO2IaYnyWYDHTX@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <3ca234c643ecb484f17aa88187e0bce8949bdb6b.1770279888.git.zhengqi.arch@bytedance.com>
 <aYabQii_-9EVdgub@linux.dev>
 <0673b72c-8d7c-4bfb-a8b2-da5ae5bb5f00@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0673b72c-8d7c-4bfb-a8b2-da5ae5bb5f00@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 10, 2026 at 02:47:51PM +0800, Qi Zheng wrote:
> 
> 
> > 
> > Add the usage of these start and end functions in mod_memcg_state() and
> > mod_memcg_lruvec_state() in this patch.
> 
> Using these two function will change the behavior of mod_memcg_state()
> and mod_memcg_lruvec_state(), but LRU folios has not yet been
> reparented.
> 
> To ensure the patch itself is error-free, I chose to place the usage of
> these two function in patch #30.

Makes sense.

I think we are good with respect to this patch series (next version), it
will miss 7.0 but I think that is fine, 7.1 is not too far.

Thanks for pushing this through.
