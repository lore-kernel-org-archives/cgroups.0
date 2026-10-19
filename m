Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE32401A2E
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 09:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792403064; cv=none; b=KvF3noLoA8aDizrEt3SP22lFFTN0vebkFCZ8zL9/igMJg30hhZ+9Z9fRZtOImCCgAQhwyJox5PImxdPJFpOJrGP94wizZeCRKCSQKKRik9YBMpXmbQPREMHEoaEn+XMYEMXsucYFlcdTPPWnffbtrUOxOi9cMwCoNuKm4McVYqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792403064; c=relaxed/simple;
	bh=e0QRKXqseSbnwv/jNw0BZs0Ci0ks6UPUvoTzc0mkA6U=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YC245YGm2tOpibmBdqmzS86FBUhC/o7bLM3wndLidLdtagBTz3MXRyBFgCVJkYfvSQQAR/p3nTitgiXstu4iqKkh8f4Q8qp8p1sKzt39uC2J6gDoXH+GltAcEHja6+Zy38apD9okH1bjMRsr29m51LDtf6GOKJTre/pxdDsjGbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BMaBccpM; arc=none smtp.client-ip=91.218.175.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BMaBccpM"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=e0QRKXqseSbnwv/jNw0BZs0Ci0ks6UPUvoTzc0mkA6U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792403060; v=1; x=1793007860;
 b=BMaBccpMv3NMSDT1Bd0lgqkLZ9Hcw/VNr3PvN7xr/D9ixiZf51Ma/Yu9HoJmC/dNLPaqTC0n
 hQDkxRFL1nMlfQuW0pXCk2oH2Mw7jP5U1GRu1G6aKNVcn9wtPl2clD1vIu6ESSEw8BkSg7ndplj
 fSgChnF961fWYeln4MxeG+Ec=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 51b1cea30dcf2afa;
	Mon, 19 Oct 2026 09:44:20 +0000
X-Mizu-Trace-ID: 51b1cea30dcf2afa
X-Migadu-Flow: FLOW_OUT
Message-ID: <8f67b745-d63f-4d3f-9672-7bad7ce0e436@linux.dev>
Date: Mon, 19 Oct 2026 17:44:10 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>,
 ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v10 3/4] blk-iocost: add iocost_ioc_tick tracepoint
 for per-period device summary
To: Tejun Heo <tj@kernel.org>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
 <20261003124045.1289305-4-cui.tao@linux.dev>
 <b76b821edba101b68f085f03e8613d7c@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <b76b821edba101b68f085f03e8613d7c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Tejun,

在 2026/10/17 01:49, Tejun Heo 写道:
> Hello, Tao.
> 
> On Sat, 03 Oct 2026 20:40:44 +0800, Tao Cui wrote:
>> + * Periodic per-device summary, emitted once per period from the tail of
>> + * ioc_timer_fn().  Unlike the state-change events above, this fires every
> 
> The event is emitted before the vrate adjustment and the period
> transition, not from the tail.
> 
Updated both the commit message and the comment to say that the event
is emitted before the vrate adjustment and the period transition.

>> +		/* whether the controller still has active iocgs */
>> +		__field(int, running)
> 
> nr_active counts every entry on ioc->active_iocgs, and ioc->lock is held
> from the count to the emit point, so running always equals active != 0.
> Maybe drop the field?
> 
Dropped, along with the printk column and the corresponding commit
message paragraph. With the lock held across the count and the
tracepoint emission, it always equals active != 0, so it carries no
additional information.

Thanks,
Tao

> Thanks.
> 

