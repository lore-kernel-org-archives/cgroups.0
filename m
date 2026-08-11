Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896052C86D
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 01:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786412927; cv=none; b=pRRIuv2xWiHrllhMtVQLZQbTwds6NJKGLsYWYz3EoR75WZO/xJiZNxQ7mwERSkPKJfdLdj724qNUoAIwex5e5xdIzjpeAxWZ++5PoZTE9BTEEo5BYUFRywx391zlkamgfr7C4SWqu9Vc+EqpC5QiZg9lDd/scuSJIFhHZNbbzbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786412927; c=relaxed/simple;
	bh=5DgxQBvWr5FiWLjEsBfhkhHArp5Esz6GYToFJ3d0XS4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oHHD8GRHTzm8Ch2/61l21WKMpgZw0jJcpg1DhrOZfNolE3jrDAsIFm6xqYGrt3YQmk1xXEO+IaO55IpXRrIEoSZUDzvAkC/oqKfxWsbIkMRhZCYx20mD9kLuU9gn4gn6H451GJ0Cq6HEM/hedhmODFIQnSLpjJnnkRgrKi7YrUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dICgdgX8; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dICgdgX8"
Message-ID: <fbffc1dd-a606-4307-aad1-2172e010de88@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786412923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZkR9Jrw3xAmJagDyGOXNwoyN0RpcRJIgBllJw9AEJU4=;
	b=dICgdgX8gaKSk4Qf7qPJHjC3t91MFlzNSnOpWSNHNtWABVNfQ/J1xiBig+1w7K8I5jfg9C
	CQZsDqtAymdDCAcdB4/TW/DT6lnyiSF6Otg1y8PRQK4TKmNJHSgUufoh0+QOLoRLyI0oi0
	axGFMuu3l9UfhnlCk1Pog9Vy0dgXx7A=
Date: Tue, 11 Aug 2026 09:48:38 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: shakeel.butt@linux.dev, akpm@linux-foundation.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260810074247.52747-1-guopeng.zhang@linux.dev>
 <anoh5K01Qcn2t1Xh@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <anoh5K01Qcn2t1Xh@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/8/11 03:09, Johannes Weiner 写道:
> On Mon, Aug 10, 2026 at 03:42:47PM +0800, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
>> cgroups") made failcnt accounting conditional on track_failcnt. It
>> enabled the flag for memcg->memory, but not for memcg->memsw.
>>
>> Consequently, memory.memsw.failcnt remains zero when the memory+swap
>> limit is hit. Enable failcnt accounting for the v1 memsw counter.
>>
>> Reproducer:
>>
>>     CG=/sys/fs/cgroup/memory/memsw-test
>>     LIMIT=33554432
>>     mkdir "$CG"
>>     echo "$LIMIT" > "$CG/memory.limit_in_bytes"
>>     echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"
>>
>> Start a child process in the cgroup and make it allocate and touch 96 MiB
>> of memory, causing a memcg OOM.
>>
>>     cat "$CG/memory.memsw.failcnt"
>>
>> Without the patch, memory.memsw.failcnt is 0. With the patch,
>> memory.memsw.failcnt is greater than 0.
>>
>> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Sashiko raises a valid point. kmem.tcp.limit_in_bytes is deprecated
> and will warn if set, but the functionality is still there for the
> time being. No need to leave it broken until it's removed.
> 
> Could you add
> 
> 		memcg->tcpmem.track_failcnt = !memcg_on_dfl;
> 
> as well?

Thanks for the review and Ack.

Agreed. I'll add

    memcg->tcpmem.track_failcnt = !memcg_on_dfl;

and update the changelog accordingly in v2.

Thanks,
Guopeng

> 
>> ---
>>  mm/memcontrol.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 6939a4fbb991..4ffe5b3733d9 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4235,6 +4235,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>>  #ifdef CONFIG_MEMCG_V1
>>  		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
>>  		memcg->memory.track_failcnt = !memcg_on_dfl;
>> +		memcg->memsw.track_failcnt = !memcg_on_dfl;
>>  		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
>>  		page_counter_init(&memcg->kmem, &parent->kmem, false);
>>  		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);

