Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8882E379C50
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 04:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790741542; cv=none; b=TsT7kCi8kJP10oEFeSAI+w/dz3YMOcNg8Q3WobFwT4LsnshXB1QcaHehfQsknWq+UhKobnKyaQ4I1CDEPzGdvxgOWQbfvhUMHAtvYioJD/2vocnlyshQBz80eLbGJ+QhwC1pxjGWH6PPA7OL82sOWLc8xop5Q9cGdUrZ0uEbAEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790741542; c=relaxed/simple;
	bh=5ZodmMk5mazCcATEXU3st4ZtMCZZcl1LFNQi48kL3+c=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HO7wAHMYUrSA6U5K63Nt12BeElQc5amr2j4mpGfkwAsr2GC7t0zYBIS+1tv40dYt5oY18P9xF2LKXuUqM6P/JMZTVKVhaaT2SSdfgCThThe6MSHHSC3lDYQsAORzpXVGiL88IuhR32YuHky0TX6MT1u4doAwYwDuCQiCYJrYNCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HiODBe9H; arc=none smtp.client-ip=95.215.58.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HiODBe9H"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5ZodmMk5mazCcATEXU3st4ZtMCZZcl1LFNQi48kL3+c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790741537; v=1; x=1791346337;
 b=HiODBe9HJYSiStjIaj0hKbWEyCJHh2u7tZa3Sy5HEHm61R7IQSiGrQ3mSNfRPDkakKiNXhUy
 JC/6NYE9rgobU5kOYroEBvdFT+ardKefMXCg5ge7Qi/MGKQGBVg6D34YjixFFVXkQKWkF9Tn3sT
 EdRAj5dmvG3ibtbLXaTKc6/8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8e53c0bfa2c49de2;
	Wed, 30 Sep 2026 04:12:17 +0000
X-Mizu-Trace-ID: 8e53c0bfa2c49de2
X-Migadu-Flow: FLOW_OUT
Message-ID: <693c4abd-e074-463d-a859-ac8033982c81@linux.dev>
Date: Wed, 30 Sep 2026 12:09:39 +0800
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
Subject: Re: [RFC PATCH v7 0/4] blk-iocost: BPF struct_ops cost model
To: Tejun Heo <tj@kernel.org>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
 <6f80eca83c87b60398110c3a6d735aec@kernel.org>
 <4f1571a1-7e56-4264-aa7f-8dce32931ddb@linux.dev>
 <44f02289433805946d1e3272f626a925@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <44f02289433805946d1e3272f626a925@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Tejun.

在 2026/9/30 00:27, Tejun Heo 写道:
> Hello, Tao.
> 
> On Tue, 29 Sep 2026 21:39:00 +0800, Tao Cui wrote:
>> To make sure I understood correctly: attaching switches the active
>> model to the attached BPF model, while model=linear and model=bpf
>> only switch between the attached model and the builtin model without
>> affecting the attachment itself.  The attachment survives enable=0,
>> and only .unreg removes it.  Please shout if I still got that wrong.
> 
> Yes, except that removing the device also removes the attachment, as
> ioc_rqos_exit() ejects the model.
> 

Thanks for confirming.  I had left out the device removal case in
the summary.  v8 keeps the attachment independent from controller state
and model selection; only .unreg and device removal (where
ioc_rqos_exit() ejects the model) remove the attachment.

Thanks.
Tao> Thanks.
> 
> --
> tejun

