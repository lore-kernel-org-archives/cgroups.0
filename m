Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9244B30EF94;
	Sun, 26 Jul 2026 03:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785037373; cv=none; b=TMNfWsJKrdmsctCDgulpaUGDnbzTJFq9nno8w08pZotzV+vLBPATltej1DgVcHU3C+KGXxHqGCLsOJb38uKZxA9uwHAxOIumDPbTZB/P4bJKl5Eh3NPAtRtRGq3o05GLkxa/DmXJRUy1h3xL1j36icanR4KNOV1/xlNagMuQ0V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785037373; c=relaxed/simple;
	bh=IHVRDEnJ5xUsanLEqSKleAIxnUWY0qSSyXOyNQ1tJuE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=azVlw4NwMTBVaViSV1jbWLFHtm68ZLo9tInk3UalxcsOOCJYMng1sHFo8ane48ViWq0fr2G/oaoXR8mfF2aN/qE5gMn+iM5ZjRXpMg/jgbskUeG1G9/1zCy+i+oHdjKn5FFheJbsYwHerlkCB63SPi8q/HDXDrYcJ4fp1bF+l4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sj6+aXhx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sj6+aXhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71621F000E9;
	Sun, 26 Jul 2026 03:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785037372;
	bh=3qyGbIXb519uDjoX4TpMXmvDySS+tkP5wly055S7W94=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sj6+aXhxl37uZ5dhwMi0bnZSS4GxR4ATQ1YcldCJnihgPGbcuIsyon0dtoNQDe7Tz
	 aL/CRp1Oo94ZoaKtHHih/7Jy4yRbay8z+cmBwmD516AoJ3DmcqqtYtDXcxOt2WQDPq
	 /VkKXCzkpjwmsI6ZizLF5QTWSPtnwO6kuzPBBEKI=
Date: Sat, 25 Jul 2026 20:42:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is
 superseded
Message-Id: <20260725204251.f96eddc5fbc8e965546cc292@linux-foundation.org>
In-Reply-To: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Jul 2026 10:18:05 +0800 Guopeng Zhang <guopeng.zhang@linux.dev> wrote:

> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> kernfs serializes file operations only per open file, so separate open
> files can update the same memory.high or memory.max file concurrently.
> Both handlers store the new limit before synchronous reclaim, but
> continue to use the writer's local target in the reclaim loop. If another
> writer raises or removes the limit, the first writer can continue
> reclaiming toward a stale target.
> 
> For memory.max, this can leave the writer looping indefinitely once
> reclaim retries are exhausted. The OOM path sees sufficient margin under
> the current limit and returns true without killing, while the writer
> still compares usage against its stale target and records another OOM
> event.
> 
> Check the current limit at the start of each reclaim iteration and stop
> if it no longer matches the writer's target.

Thanks.

> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")

Dec 2019

> Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")

Mar 2016

Having two Fixes: targets is confusing.  The Fixes: identifies which
kernel versions should be patched, so how is anyone to figure out
whether their 2018 kernel actually needs the patch?

I assume one of the two hunks is for 2019 and the other is for 2016, so
two separate patches each with a single Fixes: would be more useful.

That being said, both versions are so ancient that it probably doesn't
matter.  In fact the bug seems so obscure that I'm not planning on
adding cc:stable to this anyway.  Maintainers, please advise.

> Reproducer:
> 
> Populate a cgroup with anonymous memory and disable swapping. Lower
> memory.max from one open file, then restore it to "max" through another
> open file after the new limit becomes visible.
> 
> Without the patch, the first writer remains blocked and repeatedly
> increments the OOM event counter. With the patch, it returns normally.

This is nice info - I'll promote it into the permanent changelog.


I'll queue the patch for 7.3-rc1 and shall await maintainer input,
please.

