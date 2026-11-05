Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793874008;
	b=Rq7nba/ORoFpknyvD3i6GbVGnqMutC+3/6L22fa5BZzLbKv3UiirBwyD2wbagPr8rPHn
	 jWUaPVcgV2EaiB2NYnateHds1gDZmTLCRNuovoOYc0Ko2dujQ299JBs7Weg2lWodlTVtx
	 znqSST3KzNzjMXzlfZnZQp2Qp5FbSKRmrgPmAr/6DDRkjMUnAuEG8zbCIZazBTPaCloc8
	 hMOWkLySUHDr8aCCMkAz0mcvbe0T22jWyD8JRipPDIojKNeQkxh7BsZp/qZxQSriozlP6
	 0iK2FWM4Qrpdun0xGGkign+yQFXP9nMhBUKRMhNoH1I1WvnY1qD6LFAHzzhEza/1qWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793874008;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jIr+BXQHSHpw8ds71xVo6cb1zGmQevyMjrEckDJRick=;
	b=UwPwJsMUl55yRBMLqKJnt+DIUfivAZcbW4tulDY+gVI6sBBa0+sN2h/r2CwyVGSeDUm3
	 D7iPCqMZSdUg6kcWYSFLCBgQ64CG6RMLoZGV156WCyQKgwr5f4ydWhAGg/AtIKn7kxDM5
	 10uRKoTo3FXyGJyHFMekFngm0Nidw5VCzDbwmpNygMwXgv+Z/E40f2xv8xp/Oxn2zAT5E
	 cDh+595xT5/J/jYq0/+r9TYQlp1CQ67xgibDsnFDrFTy0seP+8/9baz+y4SfRG9Sxgkoj
	 BHp5COLduiFkvjCugF/lRr644XcS+t4mQGW+JdnortoidK+dvF+HnnI8c+72ENSxuvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UENpPXCl;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b="XmGn3o/S";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E79606D812
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 10:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06E79606D812
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UENpPXCl;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=XmGn3o/S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793874007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jIr+BXQHSHpw8ds71xVo6cb1zGmQevyMjrEckDJRick=;
	b=UENpPXClR7A3VKJiw6bWnIxOhbRYWxGCzumEPmFopMTb5xQqQ6dvdFMH9vZ1IfOwczFDFh
	pUIVKvW0iQfkMVGwDYFyP0IFt5matNB2LtJEU+1mPvxStpMbZaQSjLWrdasuoskjeZBoGn
	9OKpiJ2HTFuR5jYO0m6K0bQ2BFMF5Lg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-cQSyw8sRP6-E7Q3PkdELbA-1; Thu, 05 Nov 2026 05:20:05 -0500
X-MC-Unique: cQSyw8sRP6-E7Q3PkdELbA-1
X-Mimecast-MFC-AGG-ID: cQSyw8sRP6-E7Q3PkdELbA_1793874004
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48e0ef019a4so1562486f8f.3
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 02:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793874004; x=1794478804; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jIr+BXQHSHpw8ds71xVo6cb1zGmQevyMjrEckDJRick=;
        b=XmGn3o/SRsBJRZkpXs1pyJ4yDOw6yxczQjG1FFlMbs6lL8/iZaeRMfizV8RMim/rV5
         s+aRRe9P/2IAouXwNl5QYZo4vQ3/LpTFP4aGNQ5oSoi5TXNL7Yv7bwQiWG3tv7mQr+Ch
         DwC16ZjbZCSQusLXy+yjphl/zUMZigoR6smKaiT1hlRkT4YxL4Fn0C8e+Q0St0KZGgrV
         914t2FPRRr5FVNyBxkxh1zkT1axHaHO6H2Ggdtu9zgdc4SVsePPnakHUEnqsnZMRmS4a
         4ct5HntOJxV08+E8hy0xJohgCOS5ZivZhfDML46SCkioc5TLMZEJsYjwm03u3hxyAm+Q
         cGPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793874004; x=1794478804;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jIr+BXQHSHpw8ds71xVo6cb1zGmQevyMjrEckDJRick=;
        b=aQdazGK/Kluu6ReQ1rK9lznEYJLwzshqoO2K+U+lmtECdZcPKcCgZVBJWSY99UV9C+
         xaL8dooOKEtRyt/tBAMDd5cdAzvatQMMvM6MVPIFsnWHzh9Rt8qXWt60f34abUKSN9DV
         UhhB6FmcEizq6oi++NA3oG14vC0AeEJUNGu56k7ih+/dMVT0D6bSfb1EHLat/68wya0v
         R/KGaVnerhNU35RX3WP+SFByPNIP8/xNqDn2cXhgmXBh2XbBnLg47a0FUv206iDhWgk3
         DDduzxWXQ2x+YQ4h8runZTKuz9mf8nDtE53+2l/1TKOwj65XBRrZ7Wzr23vPimSX9Y/p
         zXjA==
X-Forwarded-Encrypted: i=1; AKwUvByM8vtHLl0vFHuic9YbVQs09PzytKJizPcbHNwb7YwJ2VBlFFzOwK8O0dkT5bugNQep4RU7lb8p@vger.kernel.org
X-Gm-Message-State: APuU4Z9JWe4cFzYZALdJ9mc4iHtULlcEOzdynK6l2J13Zyd4TxZYmyIR
	3EQfFYbnNfds0BuR7X7qJnp3ZipmEhsF29WTWyI2jX9I/zhpYdfqp8N/KWZTVz5xropK0L2woGi
	On6xFRAWzPUkIhWN4JEPzbCclRporuQNqdrY6q71pzb3SxvoYWzb9FVuqgTw=
X-Gm-Gg: AYBFou1gWJyihCKpK48Stg4AUwACRYy1xe1EBYvyTn89HYW96XGErdNV58N8/9TPE8t
	Ql0W1aP0Lp9orf3sMUjh2j/mx3U++K8kXXPpy3YhfP8gelGl6NvkOLpHpvV/dGVrvM1+1zcnrc0
	pH+xiJQ2HNm3oOyZPAac2TDLMLdxLuRhP0+U1BhAR94nZ/6HSpA13IncJ8ZMzuwNuXEIGdx30rk
	3WtMmh3lqqipDcLBDfbEciRcq/sAjJOrR0jbHrkDf876OYR4xGC6OPxVE6MKo7udRIYAjaCAoBF
	7QZp5N2dFZo4o3GMiDB8+/Suq9edn8bmMEvNPggFNy1GP1/K42RQ23N3FNa1W5i63b2PpxmzBFd
	vq8oOF4k0lneIlhqTaQY2nTvHFQfTP4Q3P7qANF8MYL806yHr5SrSHXNlbVXmA7DrhicAq0q9pN
	+cZg==
X-Received: by 2002:a05:6000:4027:b0:48d:fbdd:4132 with SMTP id ffacd0b85a97d-48e6e4f540bmr39671580f8f.18.1793874004483;
        Thu, 05 Nov 2026 02:20:04 -0800 (PST)
X-Received: by 2002:a05:6000:4027:b0:48d:fbdd:4132 with SMTP id ffacd0b85a97d-48e6e4f540bmr39671524f8f.18.1793874004043;
        Thu, 05 Nov 2026 02:20:04 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fea180ee1sm10646770f8f.4.2026.11.05.02.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 02:20:03 -0800 (PST)
Date: Thu, 5 Nov 2026 11:20:01 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	linux-kernel@vger.kernel.org,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2 03/21] sched/deadline: Do not admit bandwidth for
 parameters that are kept
Message-ID: <auxYUb0-GSpZjhd5@jlelli-thinkpadt14gen4.remote.csb>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
 <20261104211207.1392343-4-mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104211207.1392343-4-mathieu.desnoyers@efficios.com>

Hello,

On 04/11/26 16:11, Mathieu Desnoyers wrote:
> sys_sched_setattr() fills a SCHED_FLAG_KEEP_PARAMS request in from the
> task itself (get_params()), with no lock held, and
> __sched_setscheduler() then skips __setscheduler_params(): the task
> keeps the parameters it has, and its dl_bw with them.
> sched_dl_overflow() runs all the same.
> 
> A parameter change of the task's own that lands in between leaves the
> request stale, and dl_param_changed() takes it for a change: total_bw of
> the root domain, and this_bw and running_bw of its runqueue through
> dl_change_utilization(), then hold a bandwidth the task does not have,
> and the release at its 0-lag time, which takes the task's own dl_bw,
> leaves the difference behind.
> 
> There is nothing to admit for parameters that are kept: skip the check.
> 
> Found by reading, after the Sashiko AI review of the first posting of
> this series raised the case the previous patch refuses. Not reproduced:
> it needs a parameter change of a deadline task to land inside the window
> of a SCHED_FLAG_KEEP_PARAMS request on the same task.
> 
> Fixes: a509a7cd7974 ("sched/uclamp: Extend sched_setattr() to support utilization clamping")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

