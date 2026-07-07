Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90CA2D8767
	for <cgroups@vger.kernel.org>; Tue,  7 Jul 2026 02:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783391093; cv=none; b=knQAay6hZRzeZpU0cHMUlwdRFItGr9nI0LlGcY4OD/iy+7Pw2W/W/P01eVJZ++/1EneKuhtDuqOM86THJ0HYRlNNEi+kMUgzktM+YovFHszXoI5vpPCmwOh66gfOZzgWxdq8CxKhQzPg8VMDrXLCzZZOb6mJrxXwg1t16cn2CQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783391093; c=relaxed/simple;
	bh=b6y459NR1xRqnzSQLvc602fqcBXFvpK9Z3gxOCYggZM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=sUrQMqXUdNZYF4JwwrC3u2m9fyPjwWbYJvdLAnFxIj4DGBg5K4pY7jSbvEl5jOouvxyebKYLo0pRvpaopyGmbdrPJqkYXVvAW68IqWmqI76f8JIknnf5+oGF8dn3PrMdwTaiKdNrLpiICGi0IY+nmDxORLtv7UHNgUjHohIHvIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GgOyj+PS; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GgOyj+PS"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783391089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QC3O2UucywZXQimgMV3VSL+pHVajRHBfYvR5TjfVN9o=;
	b=GgOyj+PSOUlCJ70vsX+GszKAOkfW3wnDOjrIyGCu3XZaXzgX3LmM3B4J/n+apK/kPZTCn3
	9cKCDtlwtEhDbZEXfPxq5DaLSm6fyfuMLVJzhg6rvTwUggY7voO1opb/4soMvNQjoHeZl+
	0ZDmSTWLfvKdnXGfcG3nL6DdAqLeUJM=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 2/2] mm: memcg: reset oom_group in css_reset
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260703063826.306878-2-jiayuan.chen@linux.dev>
Date: Tue, 7 Jul 2026 10:24:32 +0800
Cc: linux-mm@kvack.org,
 jiayuan.chen@shopee.com,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <7EAAB709-9AB1-43A9-AE43-8E0191BA1B2C@linux.dev>
References: <20260703063826.306878-1-jiayuan.chen@linux.dev>
 <20260703063826.306878-2-jiayuan.chen@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT



> On Jul 3, 2026, at 14:38, Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> 
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> memory.oom.group defaults to disabled, but css_reset did not clear
> memcg->oom_group when a disabled memory css is kept alive by another
> controller dependency.
> 
> Reset it with the other memory controller policies so a hidden memcg
> cannot keep applying stale group OOM kill policy.
> 
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.

