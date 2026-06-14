Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9864F265621
	for <cgroups@vger.kernel.org>; Sun, 14 Jun 2026 08:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781425220; cv=none; b=GTkhlzs3OhsZtGrKR2OVzygoQqAv1LSIfz9RwTQUxf4gZK3/mDF9XOteTIKV8JA5x/ZEi8IMWD1T6AvzZdwA/mktArf5gNRnb3X3LlzZyMfj0LAypcdrKVdIX5hWL6lb1wP7HwJ5dP5anX8CdJ/1Ep9HkN6RkMblL1xs/FU46ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781425220; c=relaxed/simple;
	bh=gewyEdyEhtdyYxG+SRF/EqpHzJVs6wnsL55nkCPli0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nVvqDqCv+SattjcL9QQCPSm/G48ByvAHUVXzWogio0nL/Bzh9ji2Z6HRyBhxpJqIg0/XkthjUP0W9BRJEGx36lDohTGsDDsCk1KH8k4FYeSRgDpZ1ORPcQGbuKkzFavaEmTGxJLIXBvDhHWQW60/eRBDb+DNVobJEOsdvIqpyd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 14 Jun 2026 17:20:09 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 14 Jun 2026 17:20:08 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, chengming.zhou@linux.dev,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/7] mm, swap: Virtual Swap Space (Swap Table
 Edition)
Message-ID: <ai5kOOmR1LPTWs1J@yjaykim-PowerEdge-T330>
References: <20260612193738.2183968-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612193738.2183968-1-nphamcs@gmail.com>

...
> * Integration with swap.tier by Youngjun (see [12]). For now, I'm
>   leaning towards opting out the vswap device from swap.tier entirely, and
>   treat it as a special device. Integrating it with swap.tiers will
>   benefit the cases where you want some cgroups to skip vswap for fast
>   swap devices (pmem), whereas other should go through zswap first. But
>   most other use cases, either the overhead of vswap will be acceptable
>   (or not the bottleneck), or we can just disable CONFIG_VSWAP entirely :)
> 
>   Youngjun, may I ask for your thoughts on this?

Hi Nhat,

Tier 1: VSWAP, Tier 2: ZSWAP ...

I don't see any problem applying the desired functionality with the
currently proposed mechanism and interface. With this, a user would be
assigned the default Virtual -> RAM swap tier, and the overall picture
becomes one where swap tiers are composed according to the priority
setting.

A few more thoughts came to mind.

Shakeel also proposed a per-tier max for the swap tier interface.

https://lore.kernel.org/linux-mm/aiw2p5ANjsQUCIHA@linux.dev/

However, for vswap, rather than treating it as a case for limiting the
amount via such a per-tier max, I think the current interface is the
better fit. (But, as Shakeel mentioned, if we only allow the limit
to be set to 0 or max, the usage could end up being the same. I'm still
thinking this part through.)

I have a few other thoughts as well, but I plan to raise those points in
the swap tier discussion thread instead. Please take a look at the
related thread, and let me know if you have any opinions. :)

And I'll share more if other thoughts come to mind

Thanks,
Youngjun Park
