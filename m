Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793862954;
	b=vbU9i8JahbuIm1d/v0uP4erG+sFspLGRsoqy+GM47/M+osrW5fZrXdmdLF8ylKbV5BdK
	 5ODWTsCvFiCM/lPUUFL1qWzktEkhd8KCrW90xmj1GFYdot1ndzVV3EzVl39vNLaSx819W
	 eJAi5q/P8AnD53Hb/Szt9+ezO1oTKuHWEziai4oDp/+bBbfpsayJpRXJfUzyBq/7bC4kW
	 7o+M8FqZXJB9PFPzHhahBmUUA23FuZ1vHBR2R9Gj2flwi/7tkhGfzMsKQKxMGBNOkxrSo
	 iKXDN/HuobHpd7sPQ4qnLc7XQvlcnJVb6BJynfcAt7saRK3wpgMtnzX7iUU6dCdZF2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793862954;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OhNvDsZJpE4KS30+qaZ5e8X21eLLhO3Q56fZ1Ek8d2I=;
	b=3VA1NVf2YcIOfC3HmyQZMuMubhVZ0N6XXeXUuzIiTbclBdTaA/dtMU9TUHWTsPz5s8xO
	 9+UTy08KAz8FYB+pzmbd4wIzjrIBdkUXzy8yxcCaaMdGWXMeFHM0iwOWm1GTq97IQ+P8v
	 ZiNyD0zqS989L1If7N06S5DGCmIVTwuN9LNrjuz+6aUkp9U7egozQL8Sn5LtwGh5qKyTW
	 QPn50usqn7XzyBUB4PtYwMaN0e19xHJif0Q/DeIU6rahhMxTn/bfxh/v4LENrYQD4DIp+
	 3qs6CdJwY+03aWfIJH2eXqOoft6i89XUUK7KCn4Lfn0I5PllKMqAHhakgrwFxXXXg+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UpCupRSt;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=UC6dPSWO;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA8A606A328
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 07:15:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CA8A606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UpCupRSt;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=UC6dPSWO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793862952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OhNvDsZJpE4KS30+qaZ5e8X21eLLhO3Q56fZ1Ek8d2I=;
	b=UpCupRStGTKdg7B7YlB41BNskmU1W/sNMsDCUS2glDMpU3+XjxxGt8C031tAkmswQZaKbI
	m+waC29h34dcg2+DdVUcPms7xie7OY4yL9GY3II7wfqfoY43Xw9uHoUHocIs2NVXhZTT4Q
	9DWW0vUH777z0EJw5C1cLeH8X4ZlzyE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-58E4d0qBP1u4bq6Rfriz7w-1; Thu, 05 Nov 2026 02:15:51 -0500
X-MC-Unique: 58E4d0qBP1u4bq6Rfriz7w-1
X-Mimecast-MFC-AGG-ID: 58E4d0qBP1u4bq6Rfriz7w_1793862950
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4b0a307487aso8627375e9.1
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 23:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793862950; x=1794467750; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OhNvDsZJpE4KS30+qaZ5e8X21eLLhO3Q56fZ1Ek8d2I=;
        b=UC6dPSWOvEiKo+YH17r3sJM+YGz+JwKvul+7LxPXUtwj6RL+6qFbI6JugCqMlwcyIS
         Ysz20AhBz904sHWlq8h5BrXnZnsCEuii2vQxyBozXHqHJpe8yAzyuW8QMBmoHYn8KEw5
         5oqJiAMb1qYcWEo3xoktCD08dgQ90usype0flBeLFooyXgUSFzg/ECgJfMgnHl+4+Sc8
         JSDfmVai8SdggbryHet7nQRwU4RWgeDgYkAdZhAZWz7EMKofHNM1nLReci5DfLuzZgyD
         33E297uS6YQXtwVqkF3dE9u6mfSfxJU87cOwZSdf4n2+3p4+cjXj+1z208w+HtRXz2HY
         hKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793862950; x=1794467750;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OhNvDsZJpE4KS30+qaZ5e8X21eLLhO3Q56fZ1Ek8d2I=;
        b=CKuYFf2HmwoGGrQ+CnXJqOL9snw658UYhVZ4X/PiiwbT2mGC2GCCkYcU4g33QOeH1n
         v+rnm8pDXLklqJNsyb3YN3ygsojVEI/j/6uii56KQCKPTknvYSluazFWjhowZDE2+Hsh
         dB4SKC/79hPuKXXTPmjJRc5c+s3TgubDJTCIuLi7gAd4m0p+6dt8zpR1/xMnIZ6xVG4p
         MB4AbrsB98s6ELhwEo7JF0eHKBU2pUkJTngdBMAmnkLhRm8zxboiO8z59w63ghG3TLbR
         n6GN+yxwDBm18HXN1NVFZdnp7+w/8j170Ylnv1Sco5hNB+tQ5R31HA/g8vdlR3AAcrUK
         d46Q==
X-Forwarded-Encrypted: i=1; AKwUvBxA15gnWOkv2jvJkYP35DvFm3OBSHqxdIPbScn6HxRBH5HFyRxS5EGYO4MIwMGi7g6Ak26MYNrL@vger.kernel.org
X-Gm-Message-State: APuU4Z+63sYHfuJhaId/ueof0b8Oj/3+qh4CB43pbsHjEABmNoDvQIFv
	LuU8JYqUnt0cQ/2x1/0Kbd3SdvuRdICVoaf5na/ZTJRRIx9JVsUA7v59lNvR1O5RjLsQMrX4YGW
	jArS3bDR96ESYpFcxALETathjG9S0Oa39us26CDA0DNxCfZyv9FRfw95KDkU=
X-Gm-Gg: AYBFou2qPbb4T7dc/XrwYX28km1NKePreZvcDE4OpKd53LsnrZ8doS68bmXrTNDMZNz
	5HXYHO1OJjpf6trpeFzFUgPWysHzFQlDs/hmiAgFP5y4kCVex8anziS7PbT+ULjp4MF4VSfAZmv
	8ZTlNyUchsMLTN13pBBLvPkrye51asDcUpzqLEpUyJ2Vca1EtsXv1p2RFE3Q9DOcFcyheRO3h0d
	vST9Mokz+4KqTOtmfXOzHNAfcoIYrPUngqyJPeH6s7O67/B61n0RAX0jUn0NgVejGRdBXuLOJCc
	d9fSoNl9B4zqG9bhtCvQQzUiY8QnSv7NIAb6hu2Q1wN3E/q3ktBMkJQqqKDTHJvKltXY6Z350qn
	hy3gUDY2BvGevzWtoFkUpawBV8QKy0qKBrF/bPZqVrch4ChWg+4DXnJ5zhxgVhJUim8eTEF4n/y
	9I8g==
X-Received: by 2002:a05:600c:1f8d:b0:4a2:c9b:9b98 with SMTP id 5b1f17b1804b1-4ac177539f6mr393038955e9.17.1793862949756;
        Wed, 04 Nov 2026 23:15:49 -0800 (PST)
X-Received: by 2002:a05:600c:1f8d:b0:4a2:c9b:9b98 with SMTP id 5b1f17b1804b1-4ac177539f6mr393038455e9.17.1793862949360;
        Wed, 04 Nov 2026 23:15:49 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56f5e65c8sm42015295e9.12.2026.11.04.23.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 23:15:48 -0800 (PST)
Date: Thu, 5 Nov 2026 08:15:46 +0100
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
Subject: Re: [PATCH v2 02/21] sched: Refuse SCHED_FLAG_KEEP_PARAMS that would
 change the policy
Message-ID: <auwtIqa4H4Fqjq6V@jlelli-thinkpadt14gen4.remote.csb>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
 <20261104211207.1392343-3-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261104211207.1392343-3-mathieu.desnoyers@efficios.com>

Hello,

On 04/11/26 16:11, Mathieu Desnoyers wrote:
> SCHED_FLAG_KEEP_PARAMS keeps the parameters of a task: it skips
> __setscheduler_params(), which is what sets p->policy. A request that
> asks for another policy is then carried out by half, and succeeds:
> SCHED_OTHER to SCHED_BATCH with SCHED_FLAG_KEEP_PARAMS returns 0 and
> leaves the task where it was.
> 
> For SCHED_DEADLINE it costs bandwidth. A task that priority inheritance
> boosted into the deadline class is of that class already, so
> prev_class == next_class and the class check of
> commit 8a70415351ba ("sched: Reject SCHED_FLAG_KEEP_PARAMS when it would
> change scheduling class") lets the request through: sched_dl_overflow()
> admits it and adds
> its bandwidth, which the skipped __setscheduler_params() never gives to
> the task. It keeps SCHED_NORMAL and a dl_bw of 0, so nothing releases
> that bandwidth, and total_bw of the root domain holds it for good.
> 
> Refuse a policy change as well, where the class change was refused
> alone.
> 
> A SCHED_OTHER owner of a PTHREAD_PRIO_INHERIT mutex with a slice of
> 40ms, boosted by a deadline waiter blocked on it, leaves 0.4 of a CPU
> behind at every such call: total_bw 419424 -> 838854 and there to stay,
> in 8-CPU VMs of v7.4-rc1 with the four deadline fixes of sched/urgent,
> and of this series up to here. With this change the call is refused and
> total_bw is as it was. The selftest added later in this series has the
> case, params_keep_boosted.
> 
> Found by the Sashiko AI review of the first posting of this series.
> 
> Fixes: a509a7cd7974 ("sched/uclamp: Extend sched_setattr() to support utilization clamping")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

Makes sense to me.

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

