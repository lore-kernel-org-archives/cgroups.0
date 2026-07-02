Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91FD7262E
	for <cgroups@vger.kernel.org>; Thu,  2 Jul 2026 02:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782959896; cv=none; b=rm/+s1vh88e9MvODNPzgrO+Ar2MxxZm8U36iFzZTi5Nie4o6wbmi9E4xMF+Dx3ndbb3dFyTzpo68wTqyMbsC5kWAfkGurZNfa0g5SKDAGcev1ceogTWbggGofcOVmqKsgiOWOvNHbA22c5tdxztYGIbHzF+Tt46dUHk0PUXjSVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782959896; c=relaxed/simple;
	bh=Z18+xYizXA+PLNCdQ0fdP/BIqavPvQmYPBLXC5MYz7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBLDA1qVIQY0R5Vo4vToWoSmk20THkXVM13QhzADuM98AVs0WDfhH4gP7kNKXhO0dQWr+RtWzg7ljVDL1YmX5RF9x5Kk+fT67Hcsgn5/pekZjVn5T9O2qudDC3/KpSkohY5EFr9TfWpq31RzeuS28G4d1ui+aX8Ys6tUjNdetc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
	by 156.147.23.52 with ESMTP; 2 Jul 2026 11:08:11 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.154)
	by 156.147.1.126 with ESMTP; 2 Jul 2026 11:08:11 +0900
X-Original-SENDERIP: 10.177.112.154
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 2 Jul 2026 11:08:11 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: shakeel.butt@linux.dev, Youngjun Park <her0gyugyu@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	baohua@kernel.org, yosry@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v9 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <akXICzVZ3pWy58J7@yjaykim-PowerEdge-T330>
References: <20260620181635.299364-1-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260620181635.299364-1-youngjun.park@lge.com>

Hi Shakeel,

Gentle ping on this review when you have a chance.
I submitted the patch using the memcg interface approach you suggested.

Thanks,
Youngjun 
