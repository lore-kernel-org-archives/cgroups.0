Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5F13F7875
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 01:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784597246; cv=none; b=H5BQOWWJWICsWK8MIBdKZzfhxcinpoT7BOoITT5WyWO96RxJRJy3MF29Y1jObPc5BTZOdC4ZIsnSRzWfbI2YuDqCujBZqYdahu3Ph+go9SPxnT4bVJn95aN4wfIao+YTtE1E6gM0VuSCQ8jUHfejHZXb3V5l6hTThZ+rShrRrWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784597246; c=relaxed/simple;
	bh=sCrZgc39KHy8TyGx5WNHCPk11mBF6wS4RYug+nc6V+I=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cB5hZVCNDOSSqzWQYuu5Et/v7dkLVy/oYdhPlnqmO5o53drwqaMB2XD79I9BvILugac1XHUASq0Mjmfb3TmyPW1hL51UUJtMkZa2xpNjFQKLoa0WhgOBLvWo26N70kqfPeCRNf59+0fgATnrElKQZcfEiAP9l9c5rtBpJSrp/2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cQs2kF9u; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cQs2kF9u"
Message-ID: <f59cb798-05a6-437e-a245-046f1a088b72@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784597232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+lM8qOQE4WaqWeo2B6X7yANWnM1xqtKd8ZVywKa9FQ=;
	b=cQs2kF9uNO7J2uQamii1cRozjTdYo8VB6/82kj2uEeKOwxvljRcXcu99Z8kp8yMZtuLyUr
	tiKKpjxZKObbl5ZsFayK+BtFsx0kcbeAIIPoNqZhWz9GJYhAJxmv5Dnj3BcoyeolC+vxCA
	SoVFf/CCXh1lHTzQ5oF1rcrhpxq4p9Q=
Date: Tue, 21 Jul 2026 09:26:51 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH] cgroup/cpu: document cpu.stat nice_usec and
 core_sched.force_idle_usec
To: Joshua Hahn <joshua.hahnjy@gmail.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
References: <20260720152741.1226695-1-joshua.hahnjy@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260720152741.1226695-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/20 23:27, Joshua Hahn 写道:
>> On Mon, Jul 20, 2026 at 08:02:26AM -0700, Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
>>> I have to ask, which tree is this based on? I can't seem to find a single
>>> tree that contains the "(including those in descendant cgroups)" section
>>> anywhere. 
>>
>> It is most likely linux-next which contains a nearby modification from
>> [1] (or it was based on that regardless).
> 
> Hello Michal,
> 
> Thank you, I must have missed linux-next in my searching... that makes
> a lot of sense! With that, Tao, please feel free to add my review tag:
> 
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
Thanks Michal for the pointer, and Joshua for the tag.
Based on linux-next (next-20260717).

Thanks，
Tao
> Thanks, have a great day!
> Joshua
> 
>> HTH,
>> Michal
>>
>> [1] https://lore.kernel.org/lkml/20260629060636.200118-1-sunshaojie@kylinos.cn/

