Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.29
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464678;
	b=bGsDC+py7WOFlhSPCqUL84tLIo7NF7YY9PjGP8dmAJAdQBdanb8hHQ6zssT6PERLU5mh
	 0qIUbQJsxpE3btH+h3pURsQjcCxbcxlR4itkq/PCVui+LDpG0/b4CleRn985GzTNpOjiE
	 XZ2jH8BaycjPs6GN6jN9odiTl8HXyxwhUr+YaLLhn+UczGNOFBaZD9Fj3WZ4JUUwuo1dG
	 nWCOvEZ5vWThzQLYsPGH86mi+28HIV2XqUs9L4YGKI++OyIZJ2ReGzr1JLeDGpe/Mn4Cg
	 RBENODQi4hO+o1LP8DOghsFyJE2Hev3kRGy67rDSNiJIfIYOR441/TSzhxawuW3eTgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464678;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:From:To:Cc:References:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=9hHNuq8VUc33E92tTq5jQ+KBZqXa+5yqvOaNMaHxjXk=;
	b=HVfavFKPrFsxfmLnL0gT3p9+WG8rCLfbJ0cqf9o6W/xVm6BpZY6j6fHdlxef6v8O5gFy
	 Ml39EK9lKNa6IUD9M2Br77GZvVuLB8Ax066+yuwHvW8YDb2RFtomY4NyTZUCsIGGcl583
	 hd3TP9pmPZ0r7ac61lqJk9m90rrzrNaA68jrWiRhfuvY+Nvaq+iNzrdxp9+/CRniHHhTR
	 6gtPAxaENn9spTe5EIouwPBwSG9tyzK84dX0qTPnh6xGc32o3c8pr8xkuA66Iq4f9GE1E
	 0UK/v1O04pV1u7U0d7UaC2fc9YW64+giEhxQqkV5BBzyRxknkA/1zc7JTL7HPBVzSKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Opp1I/1e";
	arc=none smtp.remote-ip=95.215.58.29
Received: from mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830EB606A31B
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 02:51:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 830EB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Opp1I/1e
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0LhUCCHbEICJb3ocD63LGJtcQVmKNGI1w3XPmkE83mg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792464673; v=1; x=1793069473;
 b=Opp1I/1evXffFl25B7tpnPy9Gm6fePTJZ0Tix1L9fiXdnBLs3V2Wteh+Q/NMn7TgLBLlsRix
 KMsEJFqx8nSIXInlpJB8PRA780msCNl3vuARlmF8jnKyMicB//W/oYDVT13lpRL8tVoD2E+bj5g
 oSaXjLns3Lxmp6YYGmovSSms=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bfee1020aa42ebdf;
	Tue, 20 Oct 2026 02:51:13 +0000
X-Mizu-Trace-ID: bfee1020aa42ebdf
X-Migadu-Flow: FLOW_OUT
Message-ID: <56d84287-3de3-4a57-a92f-ca63d6dcda96@linux.dev>
Date: Tue, 20 Oct 2026 10:51:05 +0800
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
Subject: Re: [PATCH 0/2] cgroup/cpuset: Fix partition updates using stale CPU
 masks
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261010075947.333549-1-guopeng.zhang@linux.dev>
Content-Language: en-US
In-Reply-To: <20261010075947.333549-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,Longman

Could you take a look at this patch series when you have a chance?

Thanks,
Guopeng

在 2026/10/10 15:59, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> These patches fix two cases where partition updates read stale configured
> CPU masks:
> 
> 1. Shrinking cpuset.cpus of a remote partition can leave a removed CPU
>    unavailable to the top cpuset.
> 2. Updating cpuset.cpus.exclusive can leave an invalid local partition
>    unable to recover after the mask becomes valid.
> 
> Move each configured mask update before partition_cpus_change().
> 
> Guopeng Zhang (2):
>   cgroup/cpuset: Fix cpuset.cpus update in a remote partition
>   cgroup/cpuset: Fix invalid local partition recovery
> 
>  kernel/cgroup/cpuset.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 

