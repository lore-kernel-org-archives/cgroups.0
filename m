Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444383;
	b=XZYhfDl9wOXAuhJT8yw7fbLJaJUzslJXN6wXmVqqcuaRkCfhz6w/5AfUsQsgVG4zBILn
	 FH1L2vT7nk526Vb8HW5rUjmcgQoAcZ6ufdker44a2mheJ+SVW28xf3j5LIN3YV4VkbvJ1
	 2KczNUi1LQBaC3QRV8tP4pRYAE4wHuA3+MXBMhaI8sBNDzN9NZqVbYjVPj9zhQEhBvJWT
	 Uk7G+6SPgskAishNyv8hPWhQvl8o+o9qcJCTDjbSfRf+PIledx3JHqYSKTCIultynoWGd
	 aD1J1//rm8XvY+0kRiC/9gzqd8EmCKqvzEd3Bx76P6Cc4KR8rrsjz2Hosd2+P1d3Llw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444383;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=k633DNog7kHsc3DkibIR1k/YpXw7SywtAhFVDY+BYIk=;
	b=zn6WBtR3fbem5HEaknUmbSBw8xRac2aTxmxS1rJLf1PKRM3dZRHuk5LZNO6Kv4GwWW5q
	 CPC/kYxq4+ONkcXRrbmSfeVgJoWK8N8tmFrhcpgUiFKvJkOKuPvT4UT2mUlMdlKPbqBsW
	 SN3NdV7QcwrN/XxD+wm0UWK1y0K9mI6WFRTFAUjw+US2AUcXbql4L/uGp6Ce/pXMFWyGY
	 4mvu1o0qlQxp9Odtef3k8ipo/6Gc01X8J2yJd9T8gAb5tPLNRCDcw6K4nnp666AwWePVg
	 gzOr9cwf2UdNLzJkhl4yuMezcMw6NS2cgbh2LBHSFy/JwtAQH2YxuqQwfrzCcUEImng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=ZxtcbYaU;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=9m7Ugj8n;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A24606A31A;
	Mon, 23 Nov 2026 14:33:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68A24606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=ZxtcbYaU;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=9m7Ugj8n
Date: Mon, 23 Nov 2026 15:32:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795444380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k633DNog7kHsc3DkibIR1k/YpXw7SywtAhFVDY+BYIk=;
	b=ZxtcbYaUCdJCiwN819LIpdx/24DZbqjBfdQLHv34aaGA3g6B99AUapDeSMVBiZcLKI3T/3
	zvh2H+xflYd9shEF1DUmaoB4pE9tq4NHxRLw1TL+3pyq4dAwkQOodC3IJ9pcaVfam/nZ3b
	0qRLEUc4B/bPPfvHx9jaW4JMKc0izaPU7RPEumvkTfxbIK9k9jscgM/Bjex0Z9Ek5LfhFW
	454ibkUJW/nJ5A6c7mDBnQmuH7fMxghGAi5sWAAPImLLNK5rzrSGiEKP2/GZjuuX/ryNKS
	+49/kTIbVt0lPKuGZKVyLVapuH4rqCR+iXqoePOK0d9F8hnQ5Ma/c4nuOtY++Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795444380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k633DNog7kHsc3DkibIR1k/YpXw7SywtAhFVDY+BYIk=;
	b=9m7Ugj8nI5t0iqfjMRoRoinvgwt82fY/F0wRU3yw60HfzxIXFwcVx1R9IMTqDI5BsG8Ath
	nAsai9NTuok7EuCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, bpf@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Puranjay Mohan <puranjay@kernel.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH bpf-next] selftests/bpf: Disable preemption around
 css_rstat_updated()
Message-ID: <20261123143258.N1ETiMUU@linutronix.de>
References: <20261121082843.44614-1-kmehltretter@gmail.com>
 <DN26CP5BB6O7.23ALW6CZUBYSD@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DN26CP5BB6O7.23ALW6CZUBYSD@gmail.com>

On 2026-11-23 00:47:15 [+0000], Alexei Starovoitov wrote:
> On Sat, Nov 21, 2026 at 12:28 AM Karl Mehltretter <kmehltretter@gmail.com> wrote:
> > trace_cgroup_path_lock. On PREEMPT_RT this leaves preemption and
> > interrupts enabled. On non-RT it masks interrupts, satisfying the
> > assertion.
> 
> let's fix the kfunc instead
> 
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index de816a4..d72fe72 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -131,6 +131,7 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
>  	if (unlikely(cpu < 0 || cpu >= nr_cpu_ids || !cpu_possible(cpu)))
>  		return;
>  
> +	guard(preempt)();
>  	__css_rstat_updated(css, cpu);

This looks like the only call site which did not disable preemption on
its own (the other are either NMI or have get_cpu()).

>  }

Sebastian
