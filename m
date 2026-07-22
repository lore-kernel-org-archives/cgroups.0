Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C484457BE
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 18:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745800; cv=none; b=JvhWs8/Ggf/v+S8cp8UrSA9X5tR5GlpTGMjYnjKHhYvOkgW7g2HUqCwsjZaSe43uiz9PGWsKU/+Zbv3fslqOzf1I4bcKUC1swxVkuqhU37UG6oToKIqfq76DEtJpqina3yOLHxtut9pei35zSYAvpfDeqswQxjV2dkQPbkoDxP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745800; c=relaxed/simple;
	bh=I7OAPFVw1qwfP4L15Bcyym54Fr9eyVz6y1aErBbwV1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N2m26BDewr0MykoOSSM6fPv3hlye/KWcv9TLhGjiNpcOuNfhGQ61mayebh+I5EAOtivDGNXm42LXvvezEkhawE8t0LQYagwDwUrlneGVdkyIxJZOAzQFW0b9beC7IAV1CKGRlsRG+TUGlqzHlka2F7Do+njO+1Y2uSwa0xCtRpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BsgpXMd+; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BsgpXMd+"
Message-ID: <f83b6c93-b32e-434a-94b7-68628a2e8527@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784745786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jU7TNupb0pdhQBzs77sfqtrZ1+d4xoAeYWx+j3QiA1A=;
	b=BsgpXMd+bM/LhQJ2Rz7ftetxHEMGudfLcMl4EwXOOefgsqqUA+QfxR2ssFJp4BuLLOtnV8
	wr0DW6Ha7NOne5YliUKnWr4ctzX7Wb4TOO9wzA1gl/rTqa474oUAM576CKQ0vhO6rpIyJr
	lWH6SLT6mICi3YJyQVJ+jlD9UymTRoA=
Date: Wed, 22 Jul 2026 11:42:58 -0700
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/4] selftests/cgroup: add memcg_stat_cross_cpu
 correctness test for flush
To: Ziyang Men <ziyang.meme@gmail.com>, Shuah Khan <shuah@kernel.org>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jiri Kosina <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 David Vernet <void@manifault.com>, Eduard Zingerman <eddyz87@gmail.com>
Cc: Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Mykola Lysenko
 <mykolal@meta.com>, Nathan Chancellor <nathan@kernel.org>,
 linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
 linux-input@vger.kernel.org, sched-ext@lists.linux.dev, linux-mm@kvack.org,
 kernel-team@meta.com, bpf@vger.kernel.org, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
 <20260721174833.1232771-3-ziyang.meme@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <20260721174833.1232771-3-ziyang.meme@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 7/21/26 10:48 AM, Ziyang Men wrote:
> Add a test_progs selftest that verifies the memory-cgroup BPF kfuncs
> return values that agree with what userspace reads from cgroupfs, across
> a whole cgroup subtree that has been charged on many CPUs.
>
> It complements the existing cgroup_iter_memcg test.  cgroup_iter_memcg
> calls the memcg kfuncs on a single cgroup (BPF_CGROUP_ITER_SELF_ONLY) and
> only asserts each value is greater than zero, so it never checks that a
> value is actually correct.  This test compares the kfunc values against
> what userspace reads from memory.stat, and checks every node in the
> cgroup tree.
>
Can you extend the existing test instead of adding a new one?
