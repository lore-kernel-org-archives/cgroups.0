Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B764E3F482F
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 07:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784015903; cv=none; b=D4Ziu5+Ut3jhj+A2nkRRXu6NcrUth/X8o9aRGvZtdaP2+W34XNBCtAeX7WnE0uYvbIQEwjUNhCKTBj8xlMkGxTpaOaZnHK+6/eaIFW4vn09YI6SutIYpCdMn/s/tfpH4Gnqu8c0mYh+jicEfSb2Jw++7z9GlSOVIxUNLWnZpZV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784015903; c=relaxed/simple;
	bh=SBT1GRfMJYu5DqF6aGKf1w+9/SPtrvqrqYxhjSlpHhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cv8fVyOOQHY9rGZgltoU1oUvjuQeNoIHjMUHSH25Mc4nJjolkp8dlPaJE3+gm256x62T5FYmyUdrK7Vre+xXE0BhoJtDdBYb827DLImHm7fsrrDUJ0D7A2rtlhucdXSTQa0yBPQutewwDjjBQ683fNY7qcRp/V4dN3tAxynaDQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n1FTh+Jp; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n1FTh+Jp"
Message-ID: <0f52a483-27d1-480a-bb0c-99c108e676b5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784015899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OkniB9iRE9HjM/WA7MlrZBOT68W89sN6W9xYL05jo1s=;
	b=n1FTh+JpAeQQlCuAEVfL1kEPAaqwHzkFyq0bcYfdQFGZcO0WXrEo1an3hYHF+gNGckdoeW
	5qY5kmuEbYAKtGE7erW9NHPRe87+U8HJgjM72MdPXsD+Yp+HGcq2+bX7BIH3OOEFUQ3DnR
	KqsX1p+oGDyvM7JxdHHUIec785AJgP8=
Date: Tue, 14 Jul 2026 15:58:04 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 David Hildenbrand <david@kernel.org>, Barry Song <baohua@kernel.org>,
 Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-3-ridong.chen@linux.dev>
 <20260713112803.GF276793@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260713112803.GF276793@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Johannes,

> Probably warrants a stable CC for 6.16 as well since this is pretty
> user-visible breakage.

Thanks for the stable tag suggestion.
I checked the commit baseline:

git name-rev b980077899ea
b980077899ea tags/v6.17-rc1

So this should be tagged for 6.17+ rather than 6.16. I'll add:

Cc: stable@vger.kernel.org # 6.17+

-- 
Best regards
Ridong

