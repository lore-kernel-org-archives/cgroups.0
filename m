Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B2240B363
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 12:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783945885; cv=none; b=fYv8GcN085b07BLA6E55CQ1eYYnjzarMNNQd73DTd9jJY8gKnn9oQG/snXvoiqo2o3gSgCkLMIdF0fwvA4rfLn6C6GaPrq2wsha6tyoH30FOUWDOQbW1yyKMfO1LVNJz3SApBIvb32CFrJieG6KEcM1xPCtCi21PCymrIToqj9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783945885; c=relaxed/simple;
	bh=uWIEFLURnkESme9T+L7ZlebN9+Cdd1pDM0f7TC93rOY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=UGALvsv0s7lArre6DPgSq4iKx1Jw59jX6oqq8fZDT/5WzqYq8zYKVT3DNgCG+UYV7ltrvBv1jWn+wsiGSB0kLxn4qJa3XTkEGdP4v5hZfWMuPH30gkzxWFUNcgKQMGAeqi2RE17AfPtUwA15MIdiS2l7S29404GUkP5GrVIudl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LEwTWAxR; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LEwTWAxR"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783945881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SFB23UDIkU558vFag9ouVrBUfbEP1y+rl+Xg6XT26so=;
	b=LEwTWAxRdzON92cwYpy3JHRbt9SQS+fjRMDclWI5ejveG2sc0X35nsBV+ea++I8UqIr9kV
	1bqDSd6akUhrhDXJ1uFJnHlQJIfHzmxJyS17qzvSyIfFag5hGTb09wSVQZIbogf6A6pSdT
	9NxhHMzDxrfVqs2ZbcSTyGWpWMAr4mc=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: memcg-v1: fix wrong linux-mm list address in
 deprecation warnings
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
Date: Mon, 13 Jul 2026 20:30:48 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <3B4076F2-A893-44E4-AC2E-B5451226B618@linux.dev>
References: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT



> On Jul 13, 2026, at 16:57, Guopeng Zhang <guopeng.zhang@linux.dev> wrote:
> 
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The deprecation warnings for memory.oom_control and
> memory.pressure_level use linux-mm-@kvack.org instead of the linux-mm
> mailing list address. Remove the extra hyphen.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>


