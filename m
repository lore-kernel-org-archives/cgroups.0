Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D494086A
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 01:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786412852; cv=none; b=EwQ+22Yi2iFsuSXpwuyrZoVJPJ8CsDpr26C43S2Mvv/hVGhg8pCmwblCX1duVhK2wFADNRyh6kfJRyRN1rE5UA1TMgDr3CdaHHvev7c5jKYkGO3R9rc89T+Tzw2up/xIOWGo63Jccuqb6iaipfWrLC/GVtBR8Ij47EI20LQkqCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786412852; c=relaxed/simple;
	bh=daaWrdhudeSnOoR2NLOeMjevNGOtsy0g7fUpq28Qfkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UgnsZQ3kDWpI0uoMOQc7dXjAHWxtVp1ACfsRctHYnKseyE/T2q5THGA+g6bEOv7LuXtA8LTV2UXqgh2itYiC2NDmO22Zh8S4Qg8YnTfHBfA2Q281lV4mMrtsut58A5vrtX/CbQ/vS/76Qz8rG0S4VtDHhS1LcR3NZ/FjPrFV8GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fni5WM2z; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fni5WM2z"
Message-ID: <39efdcc9-3dea-4669-bb82-04568fe2c58d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786412848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXSP3rMmLOlY5oMvjw5F843dB49FoaX+dyKSJWS/MBA=;
	b=fni5WM2zXzlCkn/LRqi7o4f3BY91YWHhHUStmRfuCHNIhly1vQnlVkgIlL6WWuSqEYxXvp
	RMecZgI+XxCyjF5/foVr/aPN2g4K6IiTg0SlHBl7i9D2WAUiA2SkjCvVKtpj2Qj/zpEzcm
	DPr+ezJIC+HKxyhn7KLuFyo8U2HFoAY=
Date: Tue, 11 Aug 2026 09:47:09 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260810074247.52747-1-guopeng.zhang@linux.dev>
 <20260810114749.368140ad5be4fa10085bbee0@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20260810114749.368140ad5be4fa10085bbee0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/8/11 02:47, Andrew Morton 写道:
> On Mon, 10 Aug 2026 15:42:47 +0800 Guopeng Zhang <guopeng.zhang@linux.dev> wrote:
> 
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
> 
> Thanks.  Nice changelog.
> 
>> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
> 
> I'll add cc:stable to this.
> 
> AI review thinks that memcg->tcpmem.track_failcnt should receive the
> same treatment:
> 
> 	https://sashiko.dev/#/patchset/20260810074247.52747-1-guopeng.zhang@linux.dev

Yeah, tcpmem has the same issue.

I'll add

    memcg->tcpmem.track_failcnt = !memcg_on_dfl;

and update the changelog accordingly in v2.

Thanks,
Guopeng

