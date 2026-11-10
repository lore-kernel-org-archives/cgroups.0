Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794332525;
	b=Ux2i8wkGk5w85rTk8TDd+MHt5B/RiNjV6rjRZDoRFRDc4ibKv/kjIAikrnUWdbc1Mifw
	 WkOAdiI70qPQE4WT0UE125/S5E7u64qjW0ruA+or/Kqqjb/cKUHAehXC7idPEwayUuBfF
	 +JZtrJ+ojbzvAq9tr5MhWN/YD9y07S1ckNfn7TGxUYNhSKtehu4t//4D1v64fqapLdXd+
	 7bmIISRy/eaPEr/3JcbdEFPoEMGabsjmyR5ZV8hWSixauVlGE5YtBdr/A4yRSxLa5Tdcb
	 SdC0q6KSm6iZ5rWcTGwJ2pEnYc3RSs39CguhZLUM7C0tcvSG0ClDCYPYYmrttVREW+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794332525;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=z6qhmSVVpuzuoGiVpBIjsGohvtx1OvBYwJqje5IRlEA=;
	b=VGkRl0117BikZJ5WHBXrbXn+tDrS8r/ltLT/EjDTJJ3X/snS2Fyw/nVB0M7XbN6ywlkd
	 9IzzHhmmQwpm2OVEHmcd1wso70bHXyHpYMYpU/Ws4FH5BfAsGuW6TG58eau5ctFxj22Hk
	 Rgcq0GuCwIPe97bG4IGbt/lDRzajuM4+74yaRc2+9gOxYL02LOcNQzttJJhVJrs+e8bUZ
	 iR3IkqCRNaQjkqzpdedwQXRFRHGb8BgAT3osCFp8oS0f6U1F7qJrbpiiQShaVgIkYvcr9
	 S7wGtrjHc9prZVJ0zwy612aeBKJ4IXgQCP5xZg0d32YZ3p3/QwGnTRlJnxcJQrYrhnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ADIqkJTK;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB30606A321;
	Tue, 10 Nov 2026 17:42:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FB30606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ADIqkJTK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=z6qhmSVVpuzuoGiVpBIjsGohvtx1OvBYwJqje5IRlEA=; b=ADIqkJTKAtvjpq7/dfR8LPX80y
	Y2NsltStTJhp6BWwpgTUgzZoFXfsBbbdDmz4OZdYaJDKRzwoMSiKN+0SOWGSG5OZ9kp1QUR4ElkI2
	CV3qiRAUsDcpxZPMu4chxZx34LCGOAkS0MplFPiezBoufqNbAIWv5ar9P2ZenFNtC7QxPxCQbSbJY
	KSrYOYwAT0Um8DaltWGQwNiUXjcNJjBWU9feEb+0wJa11RCgnMluWtGr/Y9TM/kzUZEx/eQghRwFO
	ptOMrW4R4by+8PTgXEQAnyqjBrN/w9U12K74ve6up5WByn+zSB7UmXySJ8KhIUK48VVipisvuRB/x
	NjlJvGyw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xQpr7-00000004ht1-39q4;
	Tue, 10 Nov 2026 17:42:01 +0000
Message-ID: <1927ace7-86f4-463e-bdda-b3a5bc300eb2@infradead.org>
Date: Tue, 10 Nov 2026 09:42:00 -0800
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
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, rcu@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: John Ogness <john.ogness@linutronix.de>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
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
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20261110-sched_dl-v2-1-cc9399f7aeb1@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/10/26 9:34 AM, Sebastian Andrzej Siewior wrote:
> diff --git a/Documentation/scheduler/sched-rt-group.rst b/Documentation/scheduler/sched-rt-group.rst
> index ab464335d3204..788df93cb3a04 100644
> --- a/Documentation/scheduler/sched-rt-group.rst
> +++ b/Documentation/scheduler/sched-rt-group.rst
> @@ -18,6 +18,11 @@ Real-Time group scheduling
>  0. WARNING
>  ==========
>  
> + This document applies to RT group scheduling provided by CONFIG_RT_GROUP_SCHED.
> + If you don't use, schedule real-time tasks and experience throttling issues

-ENOPARSE.  Is that:
    If you don't use or schedule real-time tasks and experience throttling issues,



> + please look into Documentation/scheduler/sched-deadline.rst and there for the

                                                                for the

> + fair_server.

-- 
~Randy

