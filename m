Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1E419F13F
	for <cgroups@vger.kernel.org>; Sat,  7 Feb 2026 22:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770503214; cv=none; b=ROv13YQvTzpaqT9c4ih2MYBHg/FWxJNPfPWyUiY+L1gFpkeUOKgkjDBqJCWt/nhf+Zut/mKLcgsc4wYxHqKqcJfd/iLuHHS66o9UBx7UhfNxwpdKI9BOapB+soWR1ZJ0gJ6v+8aA4wnMWHVk9Hx5Z8ex820CBj3vqvahjXp6xX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770503214; c=relaxed/simple;
	bh=q8LcLAECZm9KH8T/OVJJc4BkLb7nWZQ+8rpiE9PZ71Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCx1QstGVksgXY6IqTJGtjpyI+kNV7W5v3uvNirywZXZEgeTFvkW301gkFZL5NkQHzW15qPErhM0o1a6ZFNrKAs2tdbuGlTTz0DmpchLPPLbgdE3lv0ymSIZI2mqby4qEbzMqYsuonFZ3CSYfqueKpySNfqCc1m1hGCdMd5iCow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M0BAedYd; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M0BAedYd"
Date: Sat, 7 Feb 2026 14:26:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770503212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uatIfXnMXwohncvpb4GuJ6tvrwIsq7Gi4yhdTvLaFmc=;
	b=M0BAedYdtDfGL4RevBAr7WRnh6IHPEJoJg8oen8Ycw//6EKX2dlwevhCAGbmJu/qFSVxHS
	/OyV6waSTQjew2u0iGNfNO8O8zZwvvbnTXiqrSvpU+UYiLD7s85gvAkSurw2o0eLKEsBzJ
	wju6l5bxKCCtM7+gzN3JiZA69WqnBpw=
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
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 31/31] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru
 maintenance helpers
Message-ID: <aYe8DifzgL8C9uaI@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <cf1678070fb6bab6ede8fe48f835fe913a0bb728.1770279888.git.zhengqi.arch@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf1678070fb6bab6ede8fe48f835fe913a0bb728.1770279888.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 05, 2026 at 05:01:50PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> We must ensure the folio is deleted from or added to the correct lruvec
> list. So, add VM_WARN_ON_ONCE_FOLIO() to catch invalid users. The
> VM_BUG_ON_PAGE() in move_pages_to_lru() can be removed as
> add_page_to_lru_list() will perform the necessary check.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
