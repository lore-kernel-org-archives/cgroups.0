Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794416058;
	b=1owXf8rF0nC8yhJbkQaEKywaY1dRCxmYESvRZoLSQ8jXP8KOUs5Yg+INmSPZ6/dFkW9O
	 ujN9Jqydq5VaZwwsY9pBKrBRes3TWeRt+Z6dfdVT6NJjiDnVcKzgk7UryNwOnUwVDlQwz
	 KADk13WaoEqjRnW94L9TjmzTjY0MbGKJJQZDMXDJwMOZ5IFjV6koJ1MqUreAVn6/tnEET
	 qy1yPBLqKwMdgW9z1yzXYOUiGz5tLwwLOoChRXLbxE/gphzoZ9xxE8Xb9OLanQEgT6wdk
	 XWT8V3H9hYClX3YhIAx5yOcezrXlSmG0mGs4lmuWHc9s20RfvFT9/NRF/tL+uDk0T7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794416058;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=AWueVVaXQOOVon9iyN4ebU/QYOn26L/TxhgwBah2R00=;
	b=q9tzLLm+AwkAAKkhbf8ijavnzrqlaq3CUVX+OT3OYknDnGZ1CiWrNzPab1Bvlmm1wro4
	 iVi6GgBUxFPlwPbzRUKVPLkSkCu0yGyg0JhvhOrARvpNJTVnMfvb+LnejboxOTQ5FPA2L
	 linZUwTVvpy2quI92xX659EH+N/dUJJFiB7XVc1tRQLH2shptvCmnVoAJ99+Q2OIfJqPt
	 bUs01NavCPO4EjjJY0K+YDAQaCEQ1NRQX/EJ5LM9oz9MJ26OrtIUSdPEQ2y8TF4n+Pxcc
	 J1KEFNkZkKpNWBMebpLB1EsYTRtwa1Gh5cjwlZP5NaWX//kIziaxgM1f0itm5EptJfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=qu0mGoUS;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A63606A321;
	Wed, 11 Nov 2026 16:54:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2A63606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=qu0mGoUS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=AWueVVaXQOOVon9iyN4ebU/QYOn26L/TxhgwBah2R00=; b=qu0mGoUSRhzHrpda5PyD0v86SA
	6+IoEZMyWsWwp90AqS6pw/xoqmoYO0UCpT80k6wtjponve3oRVnNd9AxvLn6ARRwF1s57ZTT+R7zl
	Y3L/K3vqj5zWRPVLH9VzZTBdVXP2XFU607wVokPdDcQpX/zGFCaL5JQcK42o7qdenEBl/BsyOWrnd
	XdA2zbLs0GSjVkGA+vEiaOXEd+AiYZR/I0qjNj9TU9qNdn7hu8bXMO2KKQeJnKD+LhTtbYUkYwFKB
	CCT0uYDOk9qjEtCw+q9/ZNLmSUCx5MWcfVpa0gbebMtF8ldRnfdm4XrlOIPIaFM8qiPCGAQ6FqoD0
	Ht6tPksQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRBaQ-00000007FmA-3zdj;
	Wed, 11 Nov 2026 16:54:14 +0000
Message-ID: <60e687ca-733d-471c-b8ad-bee092efd04b@infradead.org>
Date: Wed, 11 Nov 2026 08:54:13 -0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] sched: Mark RT_GROUP_SCHED broken
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 rcu@vger.kernel.org, linux-doc@vger.kernel.org,
 John Ogness <john.ogness@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 luca abeni <luca.abeni@santannapisa.it>,
 Yuri Andriaccio <yurand2000@gmail.com>,
 Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Davidlohr Bueso <dave@stgolabs.net>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Qais Yousef <qyousef@layalina.io>
References: <20261110-sched_dl-v2-0-cc9399f7aeb1@linutronix.de>
 <20261110-sched_dl-v2-1-cc9399f7aeb1@linutronix.de>
 <1927ace7-86f4-463e-bdda-b3a5bc300eb2@infradead.org>
 <20261111133728.6RfqZWwx@linutronix.de>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20261111133728.6RfqZWwx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/11/26 5:37 AM, Sebastian Andrzej Siewior wrote:
> On 2026-11-10 09:42:00 [-0800], Randy Dunlap wrote:
>>> --- a/Documentation/scheduler/sched-rt-group.rst
>>> +++ b/Documentation/scheduler/sched-rt-group.rst
>>> @@ -18,6 +18,11 @@ Real-Time group scheduling
>>>  0. WARNING
>>>  ==========
>>>  
>>> + This document applies to RT group scheduling provided by CONFIG_RT_GROUP_SCHED.
>>> + If you don't use, schedule real-time tasks and experience throttling issues
>>
>> -ENOPARSE.  Is that:
>>     If you don't use or schedule real-time tasks and experience throttling issues,
>>
>>
>>
>>> + please look into Documentation/scheduler/sched-deadline.rst and there for the
>>
>>                                                                 for the
>>
>>> + fair_server.
> 
> Thank you. I have now:
> 
>   If you don't use RT-group scheduling, schedule real-time tasks and experience
>   throttling issues please look into Documentation/scheduler/sched-deadline.rst
>   for the fair_server.

LGTM. Thanks.

-- 
~Randy

