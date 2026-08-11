Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AA447ECCF
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 22:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786486069; cv=none; b=pjElGJBAs+NmxqIRwR8ASwBibIuBuQYoj7UKN0HrZcxRr/Y+SYeoxCxKh/k5ZHY17SvtnRMAlxjlg4M/RC6+vQDvr0BAnoygL8ROfb/WG58LTwDRLpehePCixSVjlDMg8RRKkAKaosKQ2ay9tB6+h/uzIkqkaXdY7OYb1pcOJvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786486069; c=relaxed/simple;
	bh=/MPy+Srz4kLb0KrGUSenPokqGjfFOgdaoez1wxiGMiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VY7FtCylVTk10BRA97IlEA4DjYEGMUBZ+4t7yisjg/AoDvq3/0QHLFdbFMqFplSoQ/IWdiVRoyhdzyQJZTU07UTP20O+H8WH6PcDOXQ4e1mO8HTtchxbjCr5n56wyNmCzFzm9y7hnWBF6PM/D8mto2BJwIl3sAc+F9IwW7dgsnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fLrDxxLQ; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fLrDxxLQ"
Message-ID: <c9fe7691-d808-4363-a826-14ac8a9bd575@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786486054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h7pG7HCOaG8HHKqHFRa2IHy8vYgr6fwvJ/QGXSBnpi8=;
	b=fLrDxxLQTT/wYhrdN1U2omzqh6wWRL2CstUhQdvhLBtnmaY/wZjzMfHTT8FHsSxjJB3dVI
	YS1/dVkLn8YcQdjFaLpO+NJVnE7yQdDjSFVHD34l+plJbffX7nhcLZOFAKxp2D8EBkre9u
	lUnQrHCR6xEsnDh2YUutC6rm0Sil1sI=
Date: Tue, 11 Aug 2026 15:07:15 -0700
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] block: add BPF kfuncs to read blkcg io.stat
To: Tejun Heo <tj@kernel.org>
Cc: Ziyang Men <ziyang.meme@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Josef Bacik <josef@toxicpanda.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Mykola Lysenko <mykolal@meta.com>,
 kernel-team@meta.com, linux-block@vger.kernel.org, bpf@vger.kernel.org,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260807193732.4073299-1-ziyang.meme@gmail.com>
 <20260807193732.4073299-2-ziyang.meme@gmail.com>
 <anot9w6mg9538RWm@slm.duckdns.org>
 <anpU4oV46MDVDixj@devvm16600.scu0.facebook.com>
 <4306439e-a00f-4b10-b8a0-9be6e046873d@linux.dev>
 <antT1wtJEZ02CDx1@slm.duckdns.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <antT1wtJEZ02CDx1@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 8/11/26 9:54 AM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Aug 10, 2026 at 05:17:26PM -0700, JP Kobryn wrote:
> ...
>> The get/put kfuncs above use KF_ACQUIRE/RELEASE so the verifier can
>> reject memcg access after the put. Replacing them with a generic API
>> would call for tracking a new lifetime relationship between the css and
>> memcg (or other derived) pointer.
> 
> So, if you need css -> memcg casting, I think that can just be RCU
> protected. In fact, even for the iteration and access, RCU protection
> probably makes more sense then KF_ACQUIRE/RELEASE. It's simpler and less
> overhead especially given that most bpf progs that people care about are
> non-sleepable and already in RCU critical section anyway.
> 
It's just that if flushing is involved, the cond_resched() within
css_rstat_flush() would preclude RCU.
