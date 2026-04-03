Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCC91DED40
	for <cgroups@vger.kernel.org>; Fri,  3 Apr 2026 21:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775252388; cv=none; b=MggzxS1XKr2xth7E2n+YoPiEZnrDM3IsFxaNreyeYUoJqQg/biueNgzQ6q5QdaA/4uTfPa6QYx/qusSz7dadbPnwzX5MzFKZ7sKInhiIK3TFzyG8WEwuxHZQDSeRvE1sqnmcK2dD7+mBeMzEiodUa7QoUo0aprTCNPOFLqGy3F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775252388; c=relaxed/simple;
	bh=eod//Il4sakxUKHmcS0KX/3ISwwB1c+faalQbMk3JFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FGwQVk+8JwzPcc8MbkMMBbhNp9yod5MhIUWtOTcwKCNGsufA8yMYRAF2bG5n/LC36yaD6RoVYw6LNz6ZRfW4W5cSHr+Oze9zTyuId9dRvSb4ynjlC7rapQvNq0Pn4v5kC5ERfPjpfSl8WKcwW7ahVa9bQ1Daf9MtJLYV/9bdTuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pqeiB+oX; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pqeiB+oX"
Date: Fri, 3 Apr 2026 14:39:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775252384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vaxPn9D0nufvu6pcRhM4O7HHngFJ1hdy48gOkdHVhzs=;
	b=pqeiB+oXjYhHGbE55N1vYYuQ00Lrja4y9Vwmba6ltaiEplJdL/jYRk08LkbiQ3uqyTPGAS
	8zgHcZB1/3aHdJxPoLgRSV7Z11PNctNltyP+EGIti9osDDeslK8Lp44BZFyEAB4mdE2ENH
	AH8URr42/ehRwbrcLw0HU0He4lfL7VE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v6 29/33] mm: memcontrol: refactor mod_memcg_state() and
 mod_memcg_lruvec_state()
Message-ID: <adAzfpWnPOF1Af9p@linux.dev>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <7f8bd3aacec2270b9453428fc8585cca9f10751e.1772711148.git.zhengqi.arch@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f8bd3aacec2270b9453428fc8585cca9f10751e.1772711148.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 05, 2026 at 07:52:47PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
> non-hierarchical stats.
> 
> Co-developed-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
