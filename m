Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADE93B27C8
	for <cgroups@vger.kernel.org>; Wed, 17 Jun 2026 06:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781676625; cv=none; b=GhBFxSj+7VjpNioni+btRRrzRdE5WXZtz8sFhI2YYcqBB9M7ReAg+vSTuThW8CX/4bnrGmZZ4eot9S7iccEbAibxlMO+z86M4bnHgUmrqB1xXrE0249FkKF5WOvgMJ7RZGgXvDF5jPOFXD96jHTKzgXxrETtMCwEjSLzm8ZAwV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781676625; c=relaxed/simple;
	bh=tQ1F140yU92zZOzRpzYu4UDTbBRUfAVELBtgf1k0MGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oq2MdL77UeVqd8tbhyxpklFZ3EA3dIvuvxB32DXLd9ruGMQpIUKhp4IHz8CF94TQMxUDusXAxLSA3O5mxHUuh9YMGnfC1bfN+3RhF4q3JeCoRe9HV0SFUn0ujVivrxarl4452Y0tSlw2KOTIqh5TQZ7yJPGKWArSiuyLtV48ap4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 17 Jun 2026 15:10:13 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 17 Jun 2026 15:10:13 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	baohua@kernel.org, yosry@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v8 3/4] mm: memcontrol: add interface for swap tier
 selection
Message-ID: <ajI6RaSrZYXOKgV9@yjaykim-PowerEdge-T330>
References: <20260617053447.2831896-1-youngjun.park@lge.com>
 <20260617053447.2831896-4-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617053447.2831896-4-youngjun.park@lge.com>

Sahiko review

https://sashiko.dev/#/message/20260617053447.2831896-4-youngjun.park%40lge.com

I think this might be an overconcern. In normal
situations, cgroup delegation is strictly under the administrator's control.

Furthermore, if a user already has a delegated root, there are numerous
other ways they could potentially cause a DoS attack. Therefore, I believe
this doesn't need to be modified.
