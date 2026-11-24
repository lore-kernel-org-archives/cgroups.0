Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.247
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795496601;
	b=XP6bPtQUxfg3V8eAwrN0Bvr94cbMjUAuH3kZGZeVmq7/G2wCYnbGW7Ik7LjlN4uK8dZW
	 npq0DWdiz/2EWZUupi0u/IAGHrfcX8XZBjGMPpadVL2r1wXHjKVOoUO0L4tFLLOIuCzuD
	 FSsVMCOl8240GH4+2oT2oqDRZySaMlPeW6NrLzi6vQT1Vo8pq6STT7rE6SY3W4U0vFGZ9
	 KwJyihuCKvxybBGdO1staPmViWYGVpaQXiAaiLcdQ3d1L/1A32/FwamvGH5iB6PS44WtQ
	 H8n0FwZkvWU4iGkuWx+eDfJwp+fj2LaXe8mn6vKeQwkoTHMKyPjX1lT4LqK3o+USvgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795496601;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=S2gozbY24olxUageBz+NlIzZXi6x5SrXPb32SM57AJM=;
	b=QFOdvXW8vrslnylI/hrEUyiOWQWovTpDb52o2bJXHrOZQBTd37xfTURqXvAgfz5qdZSi
	 QBlt3qRZlqxAGMdd261zw6nRnF12AlmY4j9RtszL9/QrZGZmpeEmEhN3FYs5+W5lWO8op
	 y2hraVbUAglqWruL0hKNjJIAT9UkaNJT9MvoBG4dnkrnPRqx0LGB+cjKXV12DFpDU9ZQt
	 ZqrNsR2lq6/GboKcOTuxLOaFT77+j5XwdSk38w2vgcLt916QutuFYV6p8vK1eR3bJ6Xtj
	 6dAuMy5zQRgohO+AwEZdrrNA6OW9cvJFc0Uvc+o/sTEhOMxO+9VRJ6195jyU4eEklTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EHi93Q8K;
	arc=none smtp.remote-ip=91.218.175.247
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEF3606A326
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 05:03:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBEF3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EHi93Q8K
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pZwquf+TOycXJqm5EEWgkMHD8Suyd/T8rx/DR0eESz0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795496599; v=1; x=1796101399;
 b=EHi93Q8KppmvlCPPbQHFZbV1arZr9h53O/lUisfvlbqeOPCXVBOJKhrG+sTLx1kMjNa18Wn/
 F3gqamW6qJPqCWEWVpIeZZYtBmY7SMYJdyhNJkAX5jY+ogb5QhmAUTBS4T7RAzaMJmAbzbhwFHN
 1GzW5XZwOULYV1sSkP1YbrO8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9439c991d20d68e6;
	Tue, 24 Nov 2026 05:03:18 +0000
X-Mizu-Trace-ID: 9439c991d20d68e6
X-Migadu-Flow: FLOW_OUT
Message-ID: <c665ace5-dfd5-4fb7-abcc-7454f732fb36@linux.dev>
Date: Tue, 24 Nov 2026 13:03:04 +0800
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
Subject: Re: [PATCH bpf-next v2] cgroup/rstat: disable preemption in
 css_rstat_updated()
To: Karl Mehltretter <kmehltretter@gmail.com>, bpf@vger.kernel.org,
 Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Shuah Khan <shuah@kernel.org>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Puranjay Mohan <puranjay@kernel.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20261124031642.40616-1-kmehltretter@gmail.com>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20261124031642.40616-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/24/26 11:16 AM, Karl Mehltretter wrote:
> BPF programs can call css_rstat_updated() with preemption enabled.
> The kfunc calls __css_rstat_updated(), which requires preemption to
> be disabled while it queues an rstat update. A cgroup iterator can
> hit the lockdep assertion on both RT and non-RT kernels. The
> cgroup_hierarchical_stats selftest can also hit it on PREEMPT_RT:
> spin_lock_irqsave() on trace_cgroup_path_lock leaves preemption and
> interrupts enabled there.
> 
> Disable preemption in the BPF wrapper after validating the CPU and
> before calling __css_rstat_updated().
> 
> Fixes: 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi safe")
> Reported-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> Closes: https://lore.kernel.org/r/20251119111402.153727-1-jiayuan.chen@linux.dev/
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> Assisted by an LLM.
> 
> v2 places the preemption guard in the kfunc as Alexei requested:
> https://lore.kernel.org/r/DN26CP5BB6O7.23ALW6CZUBYSD@gmail.com/
> Since 8817005efbdf split out the BPF-only wrapper, v2 does not add
> preemption operations to the in-kernel callers discussed when Jiayuan
> proposed the earlier kernel-side version in November 2025:
> https://lore.kernel.org/r/20251121040655.89584-1-jiayuan.chen@linux.dev/
> v1: https://lore.kernel.org/r/20261121082843.44614-1-kmehltretter@gmail.com/
> 

I suggest you target cgroup-tree instread of bpf-tree if you need revise, because
you only modified pure cgroup file.

Since your v2 does the same operation as my previous v1 which was denied
by cgroup maintainer, I also suggest you wait their replies (
As time goes by, situation can change).

I still insist on kernel-side modification just like this patch because we should
prevent 'wrong' bpf code from triggering WARNING.


> Tested in x86-64 KVM guests with lockdep on bpf-next 9867c61abbd4
> (base and v2) and 2bf3351c5f89 (v2). Both tests passed on all 24 boots.
> 
>   Boots with an rstat warning               base     v2   rebased v2
>   PREEMPT_RT, cgroup_hierarchical_stats      2/2    0/2          0/2
>   PREEMPT_RT, iter/cgroup                    2/2    0/2          0/2
>   PREEMPT (!RT), cgroup_hierarchical_stats   0/2    0/2          0/2
>   PREEMPT (!RT), iter/cgroup                 2/2    0/2          0/2
> 
>  kernel/cgroup/rstat.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index de816a43db9f..d72fe721cea0 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -131,6 +131,7 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
>  	if (unlikely(cpu < 0 || cpu >= nr_cpu_ids || !cpu_possible(cpu)))
>  		return;
>  
> +	guard(preempt)();
>  	__css_rstat_updated(css, cpu);
>  }
>  
> 
> base-commit: 2bf3351c5f894697e8443eeef5333d4c4ce90cab

