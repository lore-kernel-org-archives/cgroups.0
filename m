Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8373F1CAA78
	for <cgroups@vger.kernel.org>; Thu, 22 Jan 2026 09:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769073235; cv=none; b=OwzxxYtqYQZ/dZIsXPQpcqfpiISGeRrKWGdA0uR5NEmqOlgsfeTxu8zT2rSSkl2lSvHgvnj11iHRw+VYYSTAIGo005YmHN7u4JTLky2009HJHmrodvwndpwuxRHHDreXGubeAvwaBOR1kZtsJ0ngJSU9e7wRlgMcU9zvv+VCdF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769073235; c=relaxed/simple;
	bh=iXB51nXihyIEUz1BgTSCwZE3hfpdNPmopWpitB/381E=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ktWuNhOdqPC5L3HwSStX5rnplUPBTmjMk2OxiFWgBrMz796Gkx5zv9y5JpkVuXc64acH61AIGLfYKg9kDdUSfwnINP53cFN/K3LyKkCw1ZMB5xVMM5NGmG/sV098qeK7uHz6Qi8Mmqx6TCkuZLcVH9AL8NzIQf0ys8GsKeA5I6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xFnYZbAa; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xFnYZbAa"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769073229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+KyNQBKKJPUaK/wW8N+ZLRmAcLZADaNx1sFkt8g5Ew=;
	b=xFnYZbAabOqzFSmJtBX/KGte0MPJ5qXzrgJxhvtBQSprrumcS0OcbzIkfk5mNYhGH7a5zU
	wS8YDcRucnPQ37plWU6Ku98H9FVwtkKZT/JD5f+SYgIvWQwvx5quPq6JRYqsz3KriL1J9F
	fos3lLKM/qCUJM1sSKNxjuNqOaEju6Y=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v3 27/30] mm: memcontrol: refactor memcg_reparent_objcgs()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <843e9537bf6b99cc7f19744a6f53b92338c96bfe.1768389889.git.zhengqi.arch@bytedance.com>
Date: Thu, 22 Jan 2026 17:13:03 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@kernel.org,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com,
 axelrasmussen@google.com,
 yuanchu@google.com,
 weixugc@google.com,
 chenridong@huaweicloud.com,
 mkoutny@suse.com,
 akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com,
 lance.yang@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <8F366ACF-6CE0-4751-A0F1-70C20DEAF190@linux.dev>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <843e9537bf6b99cc7f19744a6f53b92338c96bfe.1768389889.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT



> On Jan 14, 2026, at 19:32, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
> LRU folios here.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>


