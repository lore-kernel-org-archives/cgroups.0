Received: from mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459B83C7DE8
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 07:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787210603; cv=none; b=OyfxuvYoNDResvTlOt4AcxkQ4e+HQ77MLhl3JS2HzpCYhCUhCUZnf+bbWZujPMIooRA10dThiSJNwcw2LtIfepxrk0afxCXnDi2D7e1sTAd+ZNyTweUsGNYdnJeLeoGG/CZ62Apr7eKBIipngLEB6qE+BiBLaLazSERZtecAeWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787210603; c=relaxed/simple;
	bh=yDrdZvhVfSgxrwNx2Q+rR673s0csOcfqiHRPcjKz2oo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mvE8XxnbYOaqsMWIRvgricN1CANiaQbeOPj+HMKvx9R/LuuM5SZXtv8mejyN6Fb74BeXwaJoNnqvo0wD1oqiq4WRQwpshIbdBQ8QK8Jw9GngIQ9uDp1Z7zX16a3Jvixxe6oDCKAZvyt8FEm1n6YGHJRPovGdm6KoNNHdt+iVQPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qDySP+PT; arc=none smtp.client-ip=95.215.58.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qDySP+PT"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yDrdZvhVfSgxrwNx2Q+rR673s0csOcfqiHRPcjKz2oo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787210594; v=1; x=1787815394;
 b=qDySP+PT0mqoQ+6RFrI2q08BGpvje2xaEONS7afUniV7lTs034PJ9LByYYuCx4ykNY9044ID
 2ztoOL8RoD9EuNhmFQSYXRIESCUMrWS+7XAzgwXGdiKPkoILxDr2dn6V1MgbL/vbF7uhE/0XBUH
 YOCEtG2Qof3Yk9/iICXvnyp4=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [192.168.109.140] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 4b08d18a9ceac2a8;
	Thu, 20 Aug 2026 07:23:13 +0000
X-Mizu-Trace-ID: 4b08d18a9ceac2a8
X-Migadu-Flow: FLOW_OUT
Message-ID: <7c492eff-46ff-44ef-9309-4a84b6c20645@linux.dev>
Date: Thu, 20 Aug 2026 15:23:06 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] sched/fair: divide error in __calc_prop_weight() from the
 enqueue path (flat-hierarchy series)
To: Jake Steinman <j@metarealtyinc.ca>,
 K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260818231333.1441757-1-j@metarealtyinc.ca>
 <20260819132207.2149185-1-j@metarealtyinc.ca>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20260819132207.2149185-1-j@metarealtyinc.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/19 21:22, Jake Steinman 写道:
...

> 
> @Guopeng: thanks, the isolcpus=domain reproducer is interesting. I am
> not using isolcpus here and have no domain isolation configured, so my
> case is not that exact path, but if you want a second machine to test
> either of your series on I am happy to run them -- this box reproduces
> suspend/resume cycles all day and has 16 CPUs with a P/E/LP-E split,
> which may be a useful shape for hotplug edge cases.
> 

Thanks, Jake. I really appreciate the offer.

I'll keep it in mind. If I run into a case that I can't reproduce or
cover with the machines I have here, I'll reach out and may take you up
on it.

Thanks again,
Guopeng

> Thanks,
> Jake

