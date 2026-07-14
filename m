Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BB4443AB8
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 20:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784059251; cv=none; b=K/IFmtHkeVQ7dpOvgez7HNh6MO9I8v5w6rkPjG7bxhCNf/pLYmUDqRCEL4d4IBteWwm0uOTiXXQf8XLVW6i+caXVX6UkCt07eNAT4z+5suhXwz9dHnUIVw71AXKkFDREJt38ZEJSpZaH3Llc9xNp53fx9H0qs9FQoz8OBdzsJpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784059251; c=relaxed/simple;
	bh=lwWRquSdH9aMP7sk6dbTHX88POd5U1yfcjT/G5QhmFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CXETnd+Lv/XahnA46xSgpuqWOUl24mLu9jrqgaqw+YSps/2O7/Ut8u+1xJVEvbFVD8qxdmu8dfg+5HF+5kd8hZ0cU8FsUwbzN2ZfhLxGaSuuP1KxWoMooUmwptUqwfBrlKVSNdwM0gKGHCjeBSobusAxxw2qRVsyDY8h+HFbXe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Quc44Btb; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Quc44Btb"
Date: Tue, 14 Jul 2026 13:00:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784059231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A2CBkxlbhYJRAR57C5mndFI8SavuY0NkUB+CXiuOB5Q=;
	b=Quc44BtbaXKf68dgZXyNGf4Aaf1q5Gtl78Y/HbM3BOo5WFEfCY52DsJbRCm3Ml4EGvIDnP
	wy9yqHgiFs2biTETmQPI1yz5Zb2dVinvOw1bf4v4ujYQgbaNmWnZmH1xaJ+JvIYnG6Q8bd
	HhhBs5kMLWTFPX8D+5v3iyNo/zjD4i4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: fix wrong linux-mm list address in
 deprecation warnings
Message-ID: <alaVR6KxkQgdSADJ@linux.dev>
References: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 13, 2026 at 04:57:56PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The deprecation warnings for memory.oom_control and
> memory.pressure_level use linux-mm-@kvack.org instead of the linux-mm
> mailing list address. Remove the extra hyphen.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
