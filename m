Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E562B44F545
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 08:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789546915; cv=none; b=hmzZRpzT0RyQ/8LNlLIljaP/MtxcT+t2anVJ0/tT7vivUNLEG5WPN3bvuxqnZd1CUDHQDk4sl12nM7pC51C1k/Cq3MlVwtoggWtGFX3qcJPyeUwDFZtU94/7wuwGBd0FVuIBJTMoGAxU4lqZo6GULkG85hPp3v+jnuA//1hkZ3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789546915; c=relaxed/simple;
	bh=4QEPSFxwOL/UNwt7iBdY4dY2kx7+/Hzz8r4iula/V3k=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tkEIsoz5lkUZsn0kMYKu7NAT+SJoh2/m3i2UjPQzqu4dqxt3K3IoBIrL1by+u3lVyHqWIICPsah7NeVLnopzwOE4J9m08+xQGC+FGldQ9VRECKdjUUo+XM3WO4v9CMtMB+RLFhlepDn8QxmDG2QwhGxIIwrNiQYgfdZWRtBJjg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bwBBKKh3; arc=none smtp.client-ip=91.218.175.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bwBBKKh3"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4QEPSFxwOL/UNwt7iBdY4dY2kx7+/Hzz8r4iula/V3k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789546894; v=1; x=1790151694;
 b=bwBBKKh3ulVmlTiRnvDIssj406RkbdUEPiWgO3kWpi7/h5u8gER54j04AFHkt1syGy161qXC
 Vk9SlrVo2px1uN+4JntQL04OmbXZnOlp0M296HP59fM2rkjkzkRqhp8/BUZFdE+2gItu2tujU/O
 OvFVxD5FsVS0P1fRZYpkju74=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a6cdd9e4629a66e4;
	Wed, 16 Sep 2026 08:21:23 +0000
X-Mizu-Trace-ID: a6cdd9e4629a66e4
X-Migadu-Flow: FLOW_OUT
Message-ID: <bcea321a-1442-407d-acbf-1e9d5dcb060f@linux.dev>
Date: Wed, 16 Sep 2026 16:21:20 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH 1/4] blk-iocost: charge flushes as pageless random writes
To: Christoph Hellwig <hch@infradead.org>
References: <20260908022135.1429281-1-cui.tao@linux.dev>
 <20260908022135.1429281-2-cui.tao@linux.dev> <aqJDCtbWqXlPu0X9@infradead.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <aqJDCtbWqXlPu0X9@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi, Christoph 

在 2026/9/10 13:41, Christoph Hellwig 写道:
> On Tue, Sep 08, 2026 at 10:21:32AM +0800, Tao Cui wrote:
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> Standalone flushes issued by blkdev_issue_flush() are represented as
>> dataless REQ_OP_WRITE | REQ_PREFLUSH bios, which
>> calc_vtime_cost_builtin() prices at zero.  The flush component of
>> flush-heavy workloads such as database commits, journal flushes, and
>> metadata sync is thus neither charged nor throttled: a cgroup at 1% weight
>> can issue ~510k flushes per 12s, monopolizing the device while iocost
>> reports zero usage.
>>
>> Price them as pageless random writes (LCOEF_WRANDIO), which provides
>> an approximation of the device time consumed by a flush.  For
>> profiles where WRANDIO clamps to zero (ssd_dfl / ssd_fast), use a
>> one-page floor (LCOEF_WPAGE).  After this patch, the same 1%-weight
>> cgroup is limited to 24 flushes per 12s; on ext4, write+fsync
>> workloads are correctly accounted through the journal layer (~2.2us
>> per flush on the ssd_fast profile).
> 
> Flushes are actually a really interesting case.  For devics with
> a non-volatile write cache they are no-ops, but submit_bio should
> ensure we never see them here.  

Confirmed.  submit_bio_noacct() strips REQ_PREFLUSH and completes
dataless flush bios early when !bdev_write_cache(), so they never
reach ioc_rqos_throttle().  The charge only applies where the device
actually has to drain a cache.

> But devices with a volatile write
> cache they are significantly more expensive than any kind of write.
> If we touch this we should probably figure out a way to model that.
> Note that this includes standalone flushes and PREFLUSH ones,
> so this patch might be a good start, but still is missing a very
> important part.

Right.  The PREFLUSH component of data-bearing writes is the same
class of bug as the standalone flush (uncharged device time), so I'll
fold that into v2 as a bugfix: any REQ_PREFLUSH bio gets a flush
surcharge on top of its data cost, with the same write-coefficient
fallback.

For the pricing itself I'm preparing a follow-up RFC with a dedicated
flushiops= entry in io.cost.model, translated to VTIME_PER_SEC /
flushiops like the other iops coefficients, and falling back to the
write coefficients when unset.  On virtio-blk, flushiops=10 throttles
a flush storm to one flush per 100ms, which is exactly the intended
budget.  Parameter naming and whether the builtin profiles and
autocalibration should learn it are better discussed on that thread.


