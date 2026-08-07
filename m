Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B707143F4C2;
	Fri,  7 Aug 2026 20:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134163; cv=none; b=ThJe6655WjOZIbdUaFWqlbP+v+prdKZRWhM40pXg1CXMkJxMy84vx/DX024x7gKeiwBZoDs79cJ/J8PFadWNuKaRVDgRzfgx7Vo2lPTRFU0FK0qgqSybccf82TvYPTOWSiu5lgVHHteoi9en/9E1t7fUJIW9PJJAGfrvGCI32Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134163; c=relaxed/simple;
	bh=ntvlIlPU/1Vs5sCNazI4dO+KwCTJ2e7GItKoeIHk7qM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=EkKqF6sbwzuELGktMMXi23e9YfL6ChjomUByRl+d98tRffPHuvVNfwGw/zQDi977NM9mtFmwTzJO5jqiqaXdzuUl5AFgBzTcp/gttRdpZRplkFfq7C4JlXM/woW9DaMzUg/YVvMeeB28ObpyqlZWUseJWaKy1cHaYDZIHwiTtZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oRqyv2OV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oRqyv2OV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF51D1F000E9;
	Fri,  7 Aug 2026 20:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786134162;
	bh=EfSM4/6djJ0RX2cidCyfBl3q1rP9l58dQUE9oj8yHrE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oRqyv2OV7k8cVASjY6aEdGukkuydgr+mmBv7o65Twwb0+O85VmspSOYLKuxd5w13p
	 kLBXFCVDgSMCqOuRxMKBw4DJbrVfx+xaOnoX/QxhJ2mTF8Wick9wU/vDmq+uJljgpz
	 4/OtruoH2ElTHW4enwYmMshaxRmCeVRdFig22RHg=
Date: Fri, 7 Aug 2026 13:22:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cui.tao@linux.dev, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 0/2] mm, memcg: fix memory.peak reset clobbering
 other fds' watermark
Message-Id: <20260807132241.147c758d2904e00daf28ba4e@linux-foundation.org>
In-Reply-To: <20260807090000.1532495-1-ridong.chen@linux.dev>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  7 Aug 2026 16:59:58 +0800 Ridong <ridong.chen@linux.dev> wrote:

> Two fixes for the per-fd memory.peak / memory.swap.peak handlers added in
> c6f53ed8f213. Each open fd reads back max(its own value, the shared
> local_watermark), and both bugs live in that scheme.

Thanks.

We're missing the preferred description of the worst-case
userspace-visible effects of the bug.  It appears they're quite minor
so I'll assume this series is a post-7.2 thing.

Sashiko might have found a similar race on the writer side:
	https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev
