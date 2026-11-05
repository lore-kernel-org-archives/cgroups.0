Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793890857;
	b=FBSUAp3FrBAdViubtAomczZ96+p6nxdH/NphtgyLybhmEtB8kKZ4lh3hhnoUBgmicmpd
	 VMlBMj2IOBFPD4f9bFuvoz+CFY+TO/jBucfBsKweswf7ohPwZycOj23CHzRs6gCYVSkaJ
	 GY4YXYtC/7h/ZfQFe6TOyRLl9DX6Dv30u9rXffVTldui9XPlqHcAMFRufORuBdLJHyXB9
	 wXo2T0DcU5UiJ7vK965t9HxgNVUmRC6Tc9EiVpUzuDZwCHffHcyWXprqfDBt4+wNIYQFV
	 wLjtvHoQhvnVcyOxygICS37D1yuQ5IOr2puHbHlpuTgiWXq0PZpJ34FJlw5+AR4ubDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890857;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=leAQgaahqk6ie+8K1Enx+eS2rtZduvQyWhwKq33EErA=;
	b=cKyTdiNE+AAPFUUuBrw26ZsSDpNqDIVqaBH5McR4q0mLN9E7cm8G+xZ1P/UWNUSVqIJA
	 ly9+SmDtsBd0AL0U8STCsS+6BtKWO/ICCpl8HLffrCWGmpZxblCCo9lsjzxrs1LdTDITh
	 YQ2nBsiDDeoSaYT/tpCRNqEpYX2UDc7Vod/5hw0qJRwgRj8WXBtwXKroleXFwW4BjGjNO
	 /MSv+/rGSn5UiLI0jjlA+TuqPEtM81bmYH3muO66RX3s6gig6ocQAjLWxQ1pdkG2uYo8w
	 y2yLG+pajHsFqH66321kNaxR76tm8GpF0muTUXmbTCDdx6drKjqY94gI++0dgPzfVYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KbqNeg9T;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b="bkHvQS/j";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67355606D802
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 15:00:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67355606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KbqNeg9T;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=bkHvQS/j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793890856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=leAQgaahqk6ie+8K1Enx+eS2rtZduvQyWhwKq33EErA=;
	b=KbqNeg9Thp1SIYzV8iorRVtD7Cxe987mTuxpC/tI5Gir9NyTpcY8UyBpY6A91bwA8UGjKS
	OGANeyDtWkP/wwdZTUUtkJBNcW6jxm4YGYg6LE4KeAOzkW5tZ473PTvELX6Wmn056vrHml
	VvUET2VJ8SMAWHMpdFE5NAcyc3guXW0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-yWHoii3uNpufvONF95FPJw-1; Thu, 05 Nov 2026 10:00:53 -0500
X-MC-Unique: yWHoii3uNpufvONF95FPJw-1
X-Mimecast-MFC-AGG-ID: yWHoii3uNpufvONF95FPJw_1793890851
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a70b42bab0so11153825e9.1
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 07:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793890851; x=1794495651; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=leAQgaahqk6ie+8K1Enx+eS2rtZduvQyWhwKq33EErA=;
        b=bkHvQS/jmWNzi4FaAFkEKmaIvLRSj7SaRjHeBoWdFSvhe0OfjchrKSLTuhekhh+1e/
         0f3GoFOBYPLwcsTQw4Eaj5WJJofXIrbWndVQnMUi4x+fBMyh0GJ6rMLRpuSmGr1/Phl/
         0u15TgEY/F/gOLKRxFZpEfiIf1f6xrbJX9rmZ4RQsw0eMjubk7Jgm0FGvKibSYFhl7t/
         MV+u2fgPDwwJMFTXwgDiChnDArfPZn3Tl4nyaPy3RHB3Qcf+BinOHNGIGihlLLESlIl6
         prLepj9a2BcLV5utOuGHZVd32mugRcarbtSt6QYtDFuKDimJQLXY2/ZWWHjGZI0MGORC
         shNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793890851; x=1794495651;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=leAQgaahqk6ie+8K1Enx+eS2rtZduvQyWhwKq33EErA=;
        b=a1Vi23xIiW8rebH5oAwcxBUD5Hh/EjcVStZckKeNwPFZLtXep5uebl41rnUxBxGWpW
         D5n4A1VzdFcRysrG7bK/x5TDbfasbbNaCYTe0CUJwLxEKTqzxWg+End6MspP1GlHYvXe
         arujp16gBN25XgaZNfmSiSdWT9GNjEhyrnMcmKf3LuyCk9HU2a/I3d5hebipmeVX+TpY
         DlsDGaNuYizg0TS7K8jAXEm8XSqg0NlziPU6wHosVsoTolWCivXUfKrXx/7K7Me0/KJu
         nfTNpUVt6mARJVoAlHppZEiIAzS+ZGjYXTY72YhrwZg//NZFNyMYZfW/DLql9+81W+2e
         JSQQ==
X-Forwarded-Encrypted: i=1; AKwUvBxIQ9JEOIw++aquoKu7rt7G4NeFI9Uf3aivK4OW6PosD/te0Mb5z1zu18DoXGoWtBn1JdhNxKrc@vger.kernel.org
X-Gm-Message-State: APuU4Z9a6kBElrl4gF0WdOrlbVFqmlRaJdYLap4xKk7PM7jbySj+bcsl
	bHoOtxC0wX9N1jppAEaTOq2yMgl/8d65Rs5JIuuM86YFIO9VaFekJMpWIvcv0wsORjBwFnQnIAT
	HcoUjC77X0pMH0R9aKknb/wuZDg/LTqs0FZLZCdzb7XP1AB4ll52Q0ijt3SA=
X-Gm-Gg: AYBFou2hbwRkh+Nc5bCU8NiDWsNMX7E4M9aOJ5mGiLF2GJv2Cg+EZxoSkddLU06Kk9z
	lC1GP95R8rsshNyI4rAtj64+6KTcLW+wuFksBfPuXy/wHPfVbWFOa/C7qpSxhRUi7Qpn78jPs41
	PrgtiMK19u/Hg14aV16fsnbX/xBod7BLwFKZjq0XTI/uWmRsriL/YcUZP0YHa27Q/hDWEiCd1ZY
	isyuvOdXfxKcidEyNEoJAo4j8IagttgOTJRnLwr0hTzGGvOiEb6eQXwt/DA83TVGpfhyPGk+pyI
	hFut4lkkL9dGJ1EBCKhNS5MWkBHq/frSSZ0/IyuOeetcW7iGhbc6rqTyocja3nA0ytaJIJptDjp
	Ca7RScD0j3LSYNlVmqJC5xZfJldeLkzD5ZcfNacsIkwmf8/qnnL2QC3vG65U+bbKdQfiAdkxSD1
	5H0g==
X-Received: by 2002:a05:600d:82e2:b0:4a1:c27d:e1a8 with SMTP id 5b1f17b1804b1-4b55d7d7a2amr55606605e9.10.1793890850720;
        Thu, 05 Nov 2026 07:00:50 -0800 (PST)
X-Received: by 2002:a05:600d:82e2:b0:4a1:c27d:e1a8 with SMTP id 5b1f17b1804b1-4b55d7d7a2amr55605885e9.10.1793890850041;
        Thu, 05 Nov 2026 07:00:50 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b452eb99b1sm108926575e9.3.2026.11.05.07.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 07:00:48 -0800 (PST)
Date: Thu, 5 Nov 2026 16:00:46 +0100
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
Subject: Re: [PATCH v2 08/21] selftests/sched: Add a test of SCHED_DEADLINE
 policy round trips
Message-ID: <auyaHi0W_R_LLXUE@jlelli-thinkpadt14gen4.remote.csb>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
 <20261104211207.1392343-9-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261104211207.1392343-9-mathieu.desnoyers@efficios.com>

Hello,

On 04/11/26 16:11, Mathieu Desnoyers wrote:
> Add deadline_switch_test, with a case for the fix two patches back and
> one for commit 41a7968022ca ("sched/deadline: Fix total_bw leak when
> switching away from SCHED_DEADLINE while !queued"):
> 
>  - throttled_round_trip: a task with a runtime of 10ms per 2s period
>    spins, so that each replenishment throttles it again at once. Right
>    after a throttle it is switched to SCHED_OTHER, and back 200us after
>    its deadline: past its replenishment timer, and before its 0-lag
>    time, which the overrun scaled by 200 puts later. It must run again
>    within a period and a half. Three attempts;
>  - asleep_round_trip: a task of 9ms every 10ms, running 0.2ms and
>    sleeping 50ms, is switched to SCHED_OTHER and back while it sleeps
>    past its 0-lag time, enough times that a leak of its bandwidth at
>    each round trip fills the root domain: sched_setattr() then fails
>    with EBUSY. Skipped without admission control (sched_rt_runtime_us
>    at -1). A kernel that leaks is left without SCHED_DEADLINE bandwidth
>    until a reboot, so this case runs last.
> 
> In 8 VMs of 8 vCPUs each, v7.3 fails both cases, and v7.4-rc1 with the
> four deadline fixes of sched/urgent fails the first; with the two
> previous patches as well both pass; every time.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

Thanks for the selftests! Very useful.

FWIW I did propose some already in the past, but then didn't get time/
tokens for a follow up:

https://lore.kernel.org/all/20260306-upstream-deadline-kselftests-v1-0-2b23ef74c46a@redhat.com/

We can probably re-start the effort with yours and keep adding as
needed.

Do we want to have per-policy subdirs under sched?

Thanks,
Juri

