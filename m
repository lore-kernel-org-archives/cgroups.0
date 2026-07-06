Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731B53C553F
	for <cgroups@vger.kernel.org>; Mon,  6 Jul 2026 19:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783367334; cv=none; b=fJt6wtWm0LAlBgDP4F76+DK0ymloW+fBnBr183gP/JnaLxIIC1wfldA3C6oIZz5e713N4WpQegGrhot6D/mF0O+Mu7jRUNQUC+AGvuSEEfK3ETjdjUn41JyoAVUxTczOKedcisjl9zow5W3SyCBmD0/JSAne6lTql7Q84BcgBf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783367334; c=relaxed/simple;
	bh=CWX2RW1HumNtm6M/k384P/sHqBUZGLI5pEYS4rkWAmY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iEIBoUuSgKq1swsYsVtw3GgM+44XdPX3j6RCoWuNRbvzve8hEibusq2hI2zJFiugAU5XY3iam38S/kWIm6OFVqNGmVXjzEttSz9wFPE/7tXr0iZgBmp8jUxZFlf5mWFYpmAPcoDui/ShTe9w3RSsu3JP+GgMXxod6kq7QwMk+EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oa9MCfRU; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oa9MCfRU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783367330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWX2RW1HumNtm6M/k384P/sHqBUZGLI5pEYS4rkWAmY=;
	b=oa9MCfRUXRzMF16hkwzuVONS1rjnVLN/iWs9OAnpICtFE8D78D5wzHxUApszLYevIl1drt
	38/rgPBMyLDJQN17BSXlpCgMRczydK+oB5BFryPa/4BLyiPwoGUbqyhioZbEldO81VkcNN
	3HZg9UFwu8QCAH8p2dzM/zN8DKi0RZk=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org,  jiayuan.chen@shopee.com,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Muchun Song <muchun.song@linux.dev>,  Andrew
 Morton <akpm@linux-foundation.org>,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm: memcg: reset oom_group in css_reset
In-Reply-To: <20260703063826.306878-2-jiayuan.chen@linux.dev> (Jiayuan Chen's
	message of "Fri, 3 Jul 2026 14:38:24 +0800")
References: <20260703063826.306878-1-jiayuan.chen@linux.dev>
	<20260703063826.306878-2-jiayuan.chen@linux.dev>
Date: Mon, 06 Jul 2026 12:48:42 -0700
Message-ID: <877bn7nbl1.fsf@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT

Jiayuan Chen <jiayuan.chen@linux.dev> writes:

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

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
