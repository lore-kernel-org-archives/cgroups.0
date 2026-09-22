Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF463515E6
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 08:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790064623; cv=none; b=qigAjWxLfHY8Yo9uvtwkXPnfGXh1shGnxWyRVaq3szvvXOgsnUuuyNHYKtB1MD/io7aN/GKBiHLuF9dmlJXV0/vi4/jWwmQColqxYBeDOWnHlRqr4BJyY1qDwtmuad6hoAWzhAfHQo6DI+0XcXZubtrp2h8vE27dPgbWqS1X22Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790064623; c=relaxed/simple;
	bh=NlF78RerIOTo/MnyozLSa9euZ5Hw7BjWTrePBtX97Ok=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=F68dazYXhfDGtGD/q4WNWMTWBLChuArcIVMKiMmT7ImlL4sJpiN99e8bJc2N9PfcwCdQhF0j/mLnRh6BEXvmPpQW9B+xmvtqxizaZULCRdNl7jEu2WORO3mllP1E/Dbc+lcqA2WHXX5a57tqbYYuwGZucZa5owgUorLKhZ2GNRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lpsvjEIe; arc=none smtp.client-ip=91.218.175.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lpsvjEIe"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NlF78RerIOTo/MnyozLSa9euZ5Hw7BjWTrePBtX97Ok=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790064604; v=1; x=1790669404;
 b=lpsvjEIexqKARa1Z6TX2LfmsrV+h8MVVmH2OVoxlDa3dvMz/U89bSyl7jMTUSngyLh/GGZQI
 7uDLtBL1/4tBn3w0CdvgVyUSbmSwUn42yraZrwvJq6ObbJ+BTWZgZFlLusmdumzpl2dujYuSI1N
 C/ovEGPnVIxIeCFMuDFC7Tyw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 316ad890671470eb;
	Tue, 22 Sep 2026 08:10:02 +0000
X-Mizu-Trace-ID: 316ad890671470eb
X-Migadu-Flow: FLOW_OUT
Message-ID: <acd79732-1ef3-47d5-96fc-4dd3ff3eee27@linux.dev>
Date: Tue, 22 Sep 2026 16:09:57 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, axboe@kernel.dk, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me, yukuai@fygo.io, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [RFC PATCH 1/1] block: charge passthrough requests to the
 submitter's cgroup
To: Tejun Heo <tj@kernel.org>
References: <20260921070647.1928289-1-cui.tao@linux.dev>
 <20260921070647.1928289-2-cui.tao@linux.dev>
 <arFgjkKUwYGWbV8H@slm.duckdns.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <arFgjkKUwYGWbV8H@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Tejun,

在 2026/9/22 00:51, Tejun Heo 写道:
> On Mon, Sep 21, 2026 at 03:06:47PM +0800, Tao Cui wrote:
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> Passthrough requests (SG_IO, bsg, nvme passthrough ioctls and uring
>> commands) are dispatched via blk_execute_rq{,_nowait}() without ever
>> passing through submit_bio(), so the bio mapped by blk_rq_map_user()
>> carries no blkcg association: the transferred bytes never show up in
>> cgroup io.stat, and every rq_qos policy on the queue (iocost,
>> iolatency, wbt) is bypassed, as is blk-throttle, which hooks
>> submit_bio_noacct() directly rather than going through rq_qos.
>>
>> A quick demonstration on a scsi_debug device with iocost enabled and
>> vrate pinned to its 1% floor: a direct fio writer was throttled ~10x
>> while the same cgroup issuing sg_dd writes ran at full device speed
>> with zero io.stat accounting.
>>
>> Associate the mapped bio with the submitter's blkcg at dispatch time
>> and run the regular bio accounting (blk_cgroup_bio_start()) and
>> rq_qos throttle paths with it.  DRV_IN/DRV_OUT commands are mapped to
>> READ/WRITE so io.stat classifies their bytes normally; request
>> completion already pairs with the throttle through bio_endio() ->
>> rq_qos_done_bio().
>>
>> The charge is gated by opcode (READ/WRITE/DRV_IN/DRV_OUT) and to
>> queues that already have a gendisk: commands issued during device
>> probing (SCSI INQUIRY etc.) have no gendisk yet and stay exempt,
>> following the same probe-exemption reasoning as the passthrough
>> iostats support.
> 
> Do you have an actual use case where this matters?
> 

I don't have a specific passthrough workload that triggered this in
production. I ran into it while testing blk-iocost accounting coverage.

The relevant concern here is cgroup IO isolation. The expectation of
blkcg IO control is that the IO consumed by a cgroup is reflected in its
accounting and subject to blkcg IO policies. Today that is true for IO
going through submit_bio(), but not for passthrough requests.

The concrete observation was that the same cgroup issuing equivalent
writes through two paths gets different results: normal bio IO is
accounted in io.stat and subject to blkcg IO policies, while SG_IO
writes consume device bandwidth without accounting or blkcg IO control.

So the motivation is not a particular SG_IO application, but whether
passthrough IO should be considered part of the IO usage controlled by
blkcg.

I don't know yet whether the right answer is always-on behavior or an
opt-in mechanism. The RFC was mainly to discuss whether passthrough
paths should be covered by blkcg accounting/enforcement at all.

Thanks,
Tao

> Thanks.
> 

