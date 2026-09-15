Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47B838F248;
	Tue, 15 Sep 2026 02:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789439613; cv=none; b=LiE1G21wgosqbHvfP50mrJStrUn0ir96mql8R3lgNzKpuRdRNDnupzAiU2e/txNTxg/XGRPQAzQipxpG2AEYWBxalRj1kUFy8hzF4usGl7vuJjWzhit/g++TW2+FEiVysuEZ7LH6PTj4GW/tAL7oaPZmih5tIfek+YDrFhXGuxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789439613; c=relaxed/simple;
	bh=1PKsPxfydHEXgauA8PzNG0629hOylKv5vC+7wf1sydc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GSATrhgnWHyLx4cpkYQ0DFjW/FBbtRzEfJlsiAhXIqG0qHbM1E2dpVWjtdfiOh3x2YzCLAeRiaBJBW7s1jZ00d0o9i1dZ55rzV+b4Q2bloe1p8tFhQocPsPdx+dykbveJJO4KtoM0mrroxmn9KsNan/BiexmY7SIihNBgp2j0wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=themaw.net; spf=pass smtp.mailfrom=themaw.net; dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b=jz4fOWxv; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rYdtuKyk; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=themaw.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=themaw.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="jz4fOWxv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rYdtuKyk"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id E7ED1EC05C1;
	Mon, 14 Sep 2026 22:33:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 14 Sep 2026 22:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789439609;
	 x=1789526009; bh=1PKsPxfydHEXgauA8PzNG0629hOylKv5vC+7wf1sydc=; b=
	jz4fOWxvqpqHpHUCpaXErZXqKWZXkRwDdFPSrZJsW+GZVB1gXWNOwlSOlBwued2J
	bD7MTJfNqAuez0zNDdPXUPOBaztimhDMttBGJU3W1/LRw3gTOG3WILi+ZEBE3dla
	qzrqqQjgOcEePAeU0WrFJLMBVKOWx+5OFSzCP44WA0mR2c7KJTq1KimlUTwWOaFo
	4pQ3FokBLnoHus2Wg0dY+8sGBuKgfLbNCoH0Ai2ZcEJefGhbaEbCVfL61XOim3r/
	5WJHVt7UIV01UpTbuD4j+SpzjkYL4vKgOZzywIX/6rRlLOnKiMHYaWxK9/FBjmZP
	HuIyic9H9sgRjWXzT3KxNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789439609; x=
	1789526009; bh=1PKsPxfydHEXgauA8PzNG0629hOylKv5vC+7wf1sydc=; b=r
	YdtuKykZHqo4n9Y2BdebzD//DIfG+IyHfwrM6Fo8sQAK8Teugl+a/uzJW+6obQV6
	qSrUuMAmtrmhcO8XyuwmPeghGCuiB4cZinnT8c5fQTFS+N0WJFdqZOhf7nkN7baO
	UImZHceNGGxcKiz31YWHYE8fTiSA4QWWavEs3+c24kNNT7koE0nO72wlMXWQWQLr
	qhgu5FHI994ketRL9D6ik3jdgzoLYw3sOU6GsvTJVuvvd0IMxOvCeA95xNxD8ZYP
	3Ejit5QJXtAq2iR3P17JSCxPNnk9A/3mzSek8YCaeZuIFsbffrE4mqdsEjj0VpJM
	E53MyulKt/+GJlHbJzr4g==
X-ME-Sender: <xms:ea6oaoqpuQLN6cjzIUCnR_2at-bvCJRv4OvSLMwz-GSUUEN6ZY_gRg>
    <xme:ea6oavHhOAD0lMK62Q1FVIHcivlpZVOYhDj9xcnwxy9tCTcYxtEVkDcpk5ciQY9Uf
    uwdOD8XjmsrD1nybET70grSVGeNJRTAgmnTOKMcFrRTLL_7zQ>
X-ME-Received: <xmr:ea6oat61aURBJNQQq6B-LWOfrcd5uQ4-LJozHmGp8D_3-zTXTrSXAoJW8AJFurYpW5sxBNF9qNfZplRINyLBixS_-j1gQjRPrTJJxefmkkWlQi_9oLEvxIg>
X-ME-Proxy-Cause: dmFkZTEMc3mhCo0AfY0ceXzitodwcFHZTu8xfjlZlGigJeHbz+Egqlsb4SHQ6LAHi/IX6a
    XL9n0wCnXfOnILNU+NDW210vGYWsqnhxZD/tehXsuWPRoqQ+OOu0FGm4XLKftVJ+8gUWW4
    DiIEjUFmd7kgENbaGqIQseNFaGvAnpqK0A2x0eBdQ1clcws8QLWRfu8QLQdA6zJ05XKr6S
    tBJtHiTCzioUQAn+QmSxX5Hy2CI/wWA1+74xccbJU4p2l2cwVX7fLp2mJPbJrgaR6p0EwJ
    JK608D67cFfUrtL2ODDa35218JRwGSoDr6+boq6i/x7PZwuBiVW+JMM205/suz77Jl0cCg
    IGkJSRPhbhw+iZ0zylCayt28bsgxQNgPOcjOr7o8CsYAyt/DpKgYr0b7RNaWU4PznRydPz
    wiL45gVpfdDtbHPNB4ZaMcTIQzHu5DMORbPVbFx7Upzw+vA2l3XEvo0L/0wNu/wgeXV5Xp
    BOyRZQu8Z3AIyXj9jBZGF2sOGG8XGLDi321AkSmIjdzmod9ljwxl4Nu2g2ooB8I7Odk4h/
    F7+6c6dYU6l4qOvFdk1W0+58/kYX8rP8I9chipNHVjWqIzLIxZ2t0A4a4aDqQhlcbVE/Sj
    lZIjYYvPU8OI6ddd1YPD+mPcHqHWCrWSel37Q1XsC3aqE7b2AbcFFmyZXFOg
X-ME-Proxy: <xmx:ea6oanfK277olv1BM83EdpuLZBl7hYw4W_R4wUQwt7U_sqOnmHBUKg>
    <xmx:ea6oao5X1gZKfAB9mX2gV1gaWUnao-y1XuEGCMhoOc4D5Avu_EXU-g>
    <xmx:ea6oas_cSYc7ZT7JaOeqU9lQNiDNuI3GreDiEbF-wLRlQXWLdkTG-g>
    <xmx:ea6oaiHWxmMrKGc4VHT3U2f_uv_wPFZjJuObacaniBu1fO3FyvxVtA>
    <xmx:ea6oaqCHyptHrbv1p3tSk0y31IfIeHnQF_Xf3Vof9y37wvX7c4ESl6Rq>
Feedback-ID: i31e841b0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Sep 2026 22:33:26 -0400 (EDT)
Message-ID: <3f5cfc95-8b09-424e-93c6-ec958daa1137@themaw.net>
Date: Tue, 15 Sep 2026 10:33:22 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] kernfs: Remove kernfs_rwsem from dentry revalidation
To: Sandeep Dhavale <dhavale@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo
 <tj@kernel.org>, Christian Brauner <christian@brauner.io>,
 Meta kernel team <kernel-team@meta.com>, driver-core@lists.linux.dev,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260821050507.2161607-1-shakeel.butt@linux.dev>
 <20260821050507.2161607-5-shakeel.butt@linux.dev>
 <CAB=BE-QMyzKT-o=gbhdp3g8JSqQgRiTFzxTX9vEBmCttABrmdw@mail.gmail.com>
 <aqRWuffGKczUhegT@linux.dev>
 <CAB=BE-SjW76gWr0kZcPnEjXOwt90vCV0TJeFuYEGV1Kt4Y1HWw@mail.gmail.com>
 <aqTB1AVmFVs08T19@linux.dev>
 <CAB=BE-S-fOqvjj5s=M588tdUDDgDMAxOF7SE6Sm-9vara3=snw@mail.gmail.com>
Content-Language: en-AU
From: Ian Kent <raven@themaw.net>
Autocrypt: addr=raven@themaw.net;
 keydata= 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
In-Reply-To: <CAB=BE-S-fOqvjj5s=M588tdUDDgDMAxOF7SE6Sm-9vara3=snw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/26 11:28, Sandeep Dhavale wrote:
> Hi Shakeel,
>> I don't see how reclaim can set dentry->d_inode = NULL for a dentry with
>> elevated dentry->d_lockref.count because kernfs_dop_revalidate gets the dentry
>> whose dentry->d_lockref.count is elevated. Reclaim specifically skips such
>> dentries.
> Thank you for your input! That may explain why I am unable to reproduce led by
> memory stress narrative. Let me attempt to reproduce this first and I
> will provide an update.

It looks possible the dentry isn't negative, instead it might be possible

it's a use after free of the inode. There are functions that are called

directly by file systems that use kernfs.


I always thought that was the reason for the lock, not so much a need to

synchronise with the VFS (eg. in ref-walk mode it's likely the inode read

lock is held).


I wonder if there's a concurrent remove going on when this happens?


You could enable debug logging and see if you can see any node removal log

messages. The logging isn't very chatty so it might be difficult to get

further context from it but it could provide a lead to follow up on.


Ian

