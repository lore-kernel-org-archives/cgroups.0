Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E742D739C
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790950978; cv=none; b=n6ycTJwTDV6203EZqMNOatSIQzIw8EJca/GBttbecnPSPJDu2dsL0BTx5tatYwCDJPswZjs9u93gi1l7DIfDefWH7wmA+cOtPlWASfIq3M51SPVf0xJKVtFgEEk221b98fp/m0iFfF/T1OZ2vi1Mugoy3t7hsoW2FixPeMjdn/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790950978; c=relaxed/simple;
	bh=sGzMVUeqDqf7GQKw4l0gxrrknKTOL6B3iQo4am1C8Vc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f9sq8z3eVeiv+q4lTEUVafwuxEbZ3DEYgIL0PY44E8yul4lC1+6NdfipxiCe/OsvVqW7K2oh8ceqjORPVYkZ8Kk13Qn7VRw/trnROqw6U5FQMxsiVeJxQXm7/tcEFY1cWtj3ZyLwwoZD8wIuclQHTD8Q/SCCpKd0kBNDqLoIjIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kiHibtzr; arc=none smtp.client-ip=95.215.58.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kiHibtzr"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=sGzMVUeqDqf7GQKw4l0gxrrknKTOL6B3iQo4am1C8Vc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790950975; v=1; x=1791555775;
 b=kiHibtzr2uyEYuN5Ez98r15l9rFOhWokB6XAvVp6Btwgr8QanWuddCBJoa+ISaPJFMpnnwCE
 blkM17j3AqeeaJGGgtOCOGGS1KZhYORGqYTDA0OnUItAfrNPKAxEzFD698JXUCyF4LBlIzhRCPd
 ATyOWZYPdw7raSpG+U3dPoRo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3e28bf05cc86db57;
	Fri, 02 Oct 2026 14:22:54 +0000
X-Mizu-Trace-ID: 3e28bf05cc86db57
X-Migadu-Flow: FLOW_OUT
Message-ID: <d0446b98-6b5a-4a4b-bc36-a1d14b0764a9@linux.dev>
Date: Fri, 2 Oct 2026 22:22:51 +0800
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
Subject: Re: [RFC PATCH v8 3/4] blk-iocost: add iocost_ioc_tick tracepoint for
 per-period device summary
To: Tejun Heo <tj@kernel.org>
References: <20260930075154.189958-1-cui.tao@linux.dev>
 <20260930075154.189958-4-cui.tao@linux.dev>
 <7335927f4aeb61a7b92066aa58d45446@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <7335927f4aeb61a7b92066aa58d45446@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Tejun.

在 2026/10/1 08:20, Tejun Heo 写道:
> Hello, Tao.
> 
> The following is a Claude-generated review.
> 
> On Wed, 30 Sep 2026 15:51:53 +0800, Tao Cui wrote:
>> Add iocost_ioc_tick, emitted once per period from the tail of
>> ioc_timer_fn() with the overall controller state: period_us, vrate,
>> busy_level, active iocg count, usage percentage and running state.
>> It fires every period the controller is running, including steady
>> states, plus one final tick before the controller goes idle, which
>> makes dormancy (e.g. a device saturated entirely by uncharged IO)
>> directly visible.
> ...
>> +		__entry->running = ioc->running;
> 
> The timer only runs while ioc->running is IOC_RUNNING and the switch to
> IOC_IDLE happens after the trace call, so this field always reads running
> except when racing ioc_rqos_exit(). The final tick before going idle
> reads active=0 running=1, and dormancy is only visible through the ticks
> stopping, not through the field. Can you either drop the field or report
> list_empty(&ioc->active_iocgs), and adjust the description? The event is
> also emitted before the vrate adjustment and the period transition, not
> from the tail of the function.
> 

Done. The field now reports whether the active_iocgs list is empty,
rather than ioc->running, so the final tick directly reflects the
transition to dormancy. The description is updated accordingly: the
event is emitted before the vrate adjustment and the period
transition, not from the tail of ioc_timer_fn().

Thanks.
Tao

> Thanks.
> 
> --
> tejun

