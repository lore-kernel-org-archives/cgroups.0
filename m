Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793809493;
	b=jOc4YQvggdSZ3HApWW2byPS2lUKZIhny9VEUVS61/0yCiydPr/JSDRQQzLzW2zDAeCp1
	 ifgZxBGUinD+0UTZyGWkYgTGcIRrglf5O0u2ULx3Bld6PYOvnRa09CVhB+mVH0/6ZqXSM
	 /8BfhGySJNjuf0coREpRJ3qj96fw6XzUnkii/DCfDxzFSAXlEW8phA93Gd5dWYVcth9mz
	 g0o/LEGonzWHXUK6GEwENMkQTipw432tzZDn/kmtrqdVu+m2OV94pXsnqVweLVzoGaw6J
	 rXbqQX3gUos/t0kvkMaFzpy5RigP40WGqC5GLmckVNZpZXo3K9Yp7ZP0zVQSwA+6Biw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793809493;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=0jAbavI8ymZD98DRzmcyyK930fQyxtvawv4WSCcoeMY=;
	b=FEXR0W3YuVQAYPC/t8wUcpC9Vkvr9QTiAozWtPAQufeO1siGP9nZCxaiFeKiAmU1yqj2
	 +uNFyi6s8rRbSCRuPxeFrCL8iaEUfSs/9XwRv/3LCBDEbmYYgPhcBC5NkTo85pHvbxNiQ
	 LNp/IGAmCqjMBfa6cdq7+ejq2pKq6dvO64wp3u4S7KVCNRiwWSqOTimkwNT0htqPxKzJg
	 JPYMNsavvhs/lfX3FA47y+OEHXk1J0eNR2pjxUHJqCjD/CnqJioLBKeWPlfJHcEmlFUOI
	 RAy38PRny50WZ7WhsYqkXqQMBir8RAXEzg+Ul/r1/SKZQ1VbsWyi7vKkoJEi7LqOWFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fmwQKII2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7765606A32C;
	Wed,  4 Nov 2026 16:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fmwQKII2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E171F000C1;
	Wed,  4 Nov 2026 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793809492;
	bh=0jAbavI8ymZD98DRzmcyyK930fQyxtvawv4WSCcoeMY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fmwQKII2OcOxpajVA5m6X2WFvwAjWfOocU2T+k3T70EY6soxn1uhskGNqKdz6OvIN
	 VmsTpfWcJ5T2hMgM8ew3aaX5VkIgFgcNknEmUwKqhluTKM15Til1zGkd8qPNGzVRU4
	 9wtox6Lb4jWK0+GXsbHnqkx9ufit513GlaHrZx6yxW/3391rhDCQhMjsB7LHFTu/N1
	 Ea/N8tDlz9xWQxJc+6fVZrdyQ8SJqe2cpNdAzkBk+sSdys3aYDfbv9/nlAp3txGad0
	 grJf84a6ksmA9E335KvNDmCzIwyY7OWS2Hh52xgdE6jCnDQ4k4IX59FYf2NMjVZj3J
	 aGcO6EHA1+JYA==
Message-ID: <37ed51ad-5160-46b5-a951-a0da2ff1824d@kernel.org>
Date: Wed, 4 Nov 2026 17:24:47 +0100
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
Subject: Re: [PATCH for-next-fixes v2 5/5] mm/slab: serialize
 deferred_work_barrier()
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Sashiko <sashiko-bot@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-5-19167cfe4779@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-5-19167cfe4779@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/26 15:47, Harry Yoo (Meta) wrote:
> irq_work_sync() uses rcuwait instead of busy waiting in two cases:
> 
>   1. The kernel is using PREEMPT_RT and the irq work does not run in a
>      hardirq context.
> 
>   2. The architecture cannot send inter-processor interrupts to make
>      busy waiting reasonably short.
> 
> However, rcuwait.h says:
>> The caller is responsible for locking around rcuwait_wait_event(),
>> and [prepare_to/finish]_rcuwait() such that writes to @task are
>> properly serialized.
> 
> Since deferred_work_barrier() calls irq_work_sync() without any locks,
> it can potentially cause a hang as writes to @task are not serialized.
> 
> Fix this by serializing deferred_work_barrier() with a dedicated mutex.
> We cannot reuse slab_mutex because e.g.) some users of
> kvfree_rcu_barrier() are outside mm/.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


> ---
>  mm/slub.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 6dfa8ca3c937..50e88edcef3a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6636,8 +6636,12 @@ void defer_kfree_rcu(struct kvfree_rcu_head *head)
>  /* Must be called before flush_rcu_sheaves_on_cache() */
>  void deferred_work_barrier(void)
>  {
> +	static DEFINE_MUTEX(barrier_mutex);
>  	int cpu;
>  
> +	/* irq_work_sync() may use rcuwait that requires serialization */
> +	guard(mutex)(&barrier_mutex);
> +
>  	for_each_possible_cpu(cpu)
>  		irq_work_sync(&per_cpu_ptr(&deferred_percpu_work, cpu)->work);
>  }
> 

