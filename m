Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.63
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793407669;
	b=i1CZquHYhfpZBCmW1+DEWoCXOWLYfBtuTV8go84Rhro+ZkugU+Z3LZd4hSHsoEJdKD2p
	 5kgxOozmAvOHG3u8MZT3L95L+3JkpoduNuyqNxM6JaSlP6jmXJjeVyAm9s9tsEvcjw7j1
	 eKWKfylOw7Pj7IB42fIp2UAgdtgIyR1nppxiHpVoeeuXSO595Zv2cgE1gdHBu84vIxzRJ
	 btq1KG08kv0+1NIeoKb3+h1Fj7JkMzVUhmCq6Nho24XGHcPlFvX7vrQz2f+6Obaw72pBE
	 YWS5CXPAXhf9XuF8P1ruRIiFerGbU0Yo0/zC0sE9VWXdv3TRQDhhT9hL+99n2G+Hvsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793407669;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=6fhD2qwAKEE8buFW7sdA+FNaQmZ6JEgXK/EobNzcOWg=;
	b=BQt476U8LWEslDYH7uh8FWRQsfMqd59dOkYSIaMfq7bnOuBkD155UjEW8R6nxfmRtApw
	 S29OyhUkdZFDtILzRmWBfzIs+Yvu99MrprrwIRMLThOp3CVGZ36MqNaXxkH3nMv0fx5V1
	 PVG4fej0vkuqnot2ut4zQOwuR2HfKWhfuKH6Ohca/nYJQ5bb+DfT9lgzt+QfjtCrYMBrH
	 GaPe6Qg6MK+UMiDC7yjEkUAaO8suwMzCRQAEpI9Y7HfXzVI+6eJMc6bZ4DlSyYsOOrYXc
	 VQAQdOXkVXyhDErUnBv3f9rVmz28qUigZeaw5/U19m7vwke/5rfJ6SbnaL8uLs7yvHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="KJ2P6A/7";
	arc=none smtp.remote-ip=95.215.58.63
Received: from mta1.migadu.com (out-63.mta1.migadu.com [95.215.58.63])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6BF606A31F
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 00:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E6BF606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KJ2P6A/7
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kevExdvvHDN/m+BeEtkCzD1iYaSMM0hTbZZ7U+mTrjc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793407666; v=1; x=1794012466;
 b=KJ2P6A/7SyWAEKeg/sUN955X1AFHrN4ldIplQ8ZR+pkcpvFMmfOse4BQcy8rsBauzU9l0oVy
 HHEXfu4WxwfQ1p9dfG5Yc2k4aRN+Iri9cGb26AnVZDdupSdtyzKzXjdG4vC9E1c0E2DY7jnRrx3
 SCex0gAHMSObJvuw2P+V8zZ4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 5b6af64fea02a9fd;
	Sat, 31 Oct 2026 00:47:46 +0000
X-Mizu-Trace-ID: 5b6af64fea02a9fd
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 3/5] memcg: use high_work for kernel threads
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030205418.341214-4-shakeel.butt@linux.dev>
Date: Sat, 31 Oct 2026 08:47:30 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tejun Heo <tj@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>
Content-Transfer-Encoding: 7bit
Message-Id: <D333E657-EFA5-49CE-B7EE-3B89F758BB1E@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-4-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 31, 2026, at 04:54, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> Kernel threads never return to userspace, so deferred memory.high
> reclaim does not run. Reclaim and throttling during a charge can also
> delay work they do for other tasks.
> 
> Treat kernel threads like interrupts. Queue high_work for the first
> cgroup over memory.high and skip reclaim and throttling in the charging
> thread.
> 
> User workers created by create_io_thread() and vhost_task_create() keep
> their current behavior. Vhost kernel threads use the new path, even when
> they borrow the owner's mm.
> 
> The worker requests a fixed batch of pages each time. A fast allocator
> can keep usage well above memory.high. Kernel threads also skip
> memory.swap.high throttling and its high-event reporting. The memory.max
> and memory.swap.max checks stay the same.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

THanks.

