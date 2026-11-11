Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794413960;
	b=SX034NmBxjemyAesHRk6gs/WBix6iOqpErqBixxNmmSPXs0SPvSxAvgMK87IH/sQNblE
	 L0AAiRB5iTy1ltBpecSO+WxPrFWCwcwNbIEyzF78rS1oItya4kqUJXWYNqt8KnFGI0/Ig
	 VuSnYAuVidh/mNT8ltefo4/RKaAmiLExHIQ93bcKLtI22Akl6Zj231KRaXlJE62lI3a+i
	 et1IB/D/o9v8bx+DIhD+BgJDjUX7MFbyRKs0JRMpHjcNdW5tIqYYHehzyzXO+vxBWqf4R
	 Uxe2OHSNWB60sOxniWvk9ISfxooj0TIDiHy0Eo11tl4DWCigMN3YZm14Vg19O6cf6oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794413960;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=3Tr7kJyMgrxILW6bmy4HJBMvh/+CUoCrlh1UXHmeUfg=;
	b=2q01niUkEDmujMK0DQJJsThu9t7ddswwi6UENQsX77CIazon2j9+ppR4qJhIqqS0suab
	 nA9rBVRhUjqsT4GJecPl5eJ+WRzWY54JX5UGYdKASEE9IAZ2bUWgXQmi2O84EfY3QF4Q4
	 O9rqISjv1Dy38LCQUspsQ6FRAxppKvnt82s6In1Mw8udq8iT6Gf66KAv99uw/YtrqT8fW
	 9mlYSDUjTkxCmnyKFid8rWw7mfrzLmWfQY5UAWAHi4JNoMvIXsPIjCoim64Pnajhz5DBK
	 IQEzcZ/jb6rSD1HvwQkNkA8mjdPRetayijPrTHtGvLMzPjddwO0mUoHaHIsiBjhlrqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=JCvYPm5I;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40175606A32D;
	Wed, 11 Nov 2026 16:19:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40175606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=JCvYPm5I
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3Tr7kJyMgrxILW6bmy4HJBMvh/+CUoCrlh1UXHmeUfg=; b=JCvYPm5Is+991YuywRlzjEMNp1
	S7xApyjWkrIWpO1oeaL8ktGurfYFlNjlkCO5QDII88oChRyKxzldRJdHvNh12Qc9AqcRnnTbfHGgi
	m24D8VAzk2xKVIS6fw5o+v0JyHDFmq1xcpGCCBrxJb/8xYuWZMHFFVQYsq7++pn3jgfUQgXXxRzch
	9z4ADnYmpKTG72LwmxGF3ubyCFpL4b2Bw6SoxxtCFFZqjGjzvQLkdiEurQL6UszAOmvSbqcHjpFEp
	ZQ6NLGlEPWFuQUKKypZ/upo4qvHU052VKpB4y13ADLWF5cwZm2yeau3pKtixdT09vC++p/dFkG29U
	Ia7lrXtA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRB2X-00000009KMT-3SmB;
	Wed, 11 Nov 2026 16:19:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3D91130031E; Wed, 11 Nov 2026 17:19:12 +0100 (CET)
Date: Wed, 11 Nov 2026 17:19:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Juri Lelli <juri.lelli@redhat.com>, mingo@redhat.com,
	vincent.guittot@linaro.org, linux-kernel@vger.kernel.org,
	tglx@kernel.org, will@kernel.org, boqun@kernel.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it, mathieu.poirier@linaro.org,
	longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
	bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
	m.szyprowski@samsung.com, kayracizmeci@gmail.com,
	weihengqiuu@gmail.com, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v5 13/29] sched/deadline: Keep departing bandwidth across
 a root domain rebuild
Message-ID: <20261111161912.GP1779021@noisy.programming.kicks-ass.net>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-14-mathieu.desnoyers@efficios.com>
 <avRmoK08LoIeySBL@jlelli-thinkpadt14gen4.remote.csb>
 <c3e7054a-486c-4e5a-a646-eee42e815ce4@efficios.com>
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
In-Reply-To: <c3e7054a-486c-4e5a-a646-eee42e815ce4@efficios.com>

On Wed, Nov 11, 2026 at 10:35:17AM -0500, Mathieu Desnoyers wrote:

> Measured in a 64-vCPU guest with sleeping deadline tasks:
> 
>   tasks    today: rebuild, longest irqs-off    single list, all irqs-off
>   1000     0.75ms, under 0.1ms                 0.12ms (0.19ms worst)
>   10000    7.4ms, under 0.1ms (0.3ms once)     0.9ms (1.2ms worst)
> 
> The rebuild itself is 8 times shorter. That comes from updating the
> extra_bw of the CPUs once per root domain, not once per task. But the
> longest section with interrupts disabled grows with the number of
> deadline tasks. I do not think that is a step forward for a real-time
> class.

This is domain rebuild? Do we really care about performance there?
