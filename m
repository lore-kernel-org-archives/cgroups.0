Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795000850;
	b=EmbIs19yAFF+e0CVSF4Jyjxo9qjpVuxEm/Ahp/IpSJ5QYqA1N1OsoDX9wFMa00QVz5h0
	 G8qNCaqmJVW1pOCHlDNt0N+eVOYQ/mYPlDKB2GLFLaxZcSZIRfMNKXbRgBh3oh1Uv0mKe
	 x0PPVoHvErstHmgBaWHHPAN51QCVCZDFtFhKB/aXs2iaT1BEbbx4gnAkTUb6AJAiC7xyA
	 ARDXVcfGlQmhpUTTxwW9I+NObmnIcbZ4rRBXd2osXGbPXmRh3wJeHEebnBaV16938sFlD
	 6Ddp4kjrZ0fJzM+0zKlWwA/Ul0kayea3qZaHt6OIL298mNuI/6zI4CHZwWu/JdME8sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795000850;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UYZeLko8ARh+TMZJ/jcaVMaBZpqH4WAJB7a5zPUzakg=;
	b=uaVstX8jYUD3+x4k3NLezbds/6w8sPQaJ4RuHX57fvpQ64A6XbFFVtwVkotTgsN6h43e
	 tnAjoTHZhm8yv190IWSq2mjbP2xKG+QpmuKopuchX5bsrCCvbHZGwZCWIpW/KiMDK17Uy
	 pb8ZRC1sheVtDBcwGxRdLkt925YHvQDQrKcewA0SO2as0h5MixAKKr017Jqp6hob79xTv
	 sikTTYZ/HMLHfuKlZVGaoG9u6oWmjqUbBNOyh2Mkm7iDzo2YZ81eVwajFKTdECLqmbbj9
	 Nqga856CYzJBxPaVX+FlksQTfa5LsQQ1u/hf2UsNC0D29V1zxpspztGMCc3N52dGVXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iORFFgFd;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=GpL06LLH;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AEE606A325
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 11:20:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51AEE606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iORFFgFd;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=GpL06LLH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795000848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UYZeLko8ARh+TMZJ/jcaVMaBZpqH4WAJB7a5zPUzakg=;
	b=iORFFgFd322gO9ZgYGy1IvDR74Gf36yEqNGJxd4+VfnSq0mZFQdnH9+yCpx8U86A6I9LPH
	JpHIUxeOoDT7gA1XSbyb7LQOPjXqz0u8A7H94AuXpi5sYcdLE1YWMFt8IGbXONS1johxXg
	eE2ofvemC7h+RRHZ5H5HchRrYgU04No=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-SW1f5PLlNg6A0BSh3R8GjA-1; Wed, 18 Nov 2026 06:20:47 -0500
X-MC-Unique: SW1f5PLlNg6A0BSh3R8GjA-1
X-Mimecast-MFC-AGG-ID: SW1f5PLlNg6A0BSh3R8GjA_1795000846
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4ad3d35e899so6974935e9.1
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 03:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795000846; x=1795605646; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UYZeLko8ARh+TMZJ/jcaVMaBZpqH4WAJB7a5zPUzakg=;
        b=GpL06LLH6he6KY83Kswtjf5NHWlqseEgBMeWpf2WQ9het2uamRVdPeeUrDLQVbR8Ox
         Ihmv8Dm7c5v5zBi5IjZccJR6pEt6C5XIvcsNl13QVzxOELXQqg4jacsBtZYJBI82gSnF
         umpvBG6Js4CqPHi0EOoMyzjVGBEfZ6XkWovAbifhSzhGHTl+17Wv8+v/tHqY/zsZJ2kx
         VZsk2YPsYg+VEb1uqA+vP6I1CbgFYe+ZLa4GUU/o/FO+WGBBllgGRvxjlbmuq2UnWK6f
         klwuHSjRZY9jP/SIH2Q7ejD96q1Kv/pVsiZoDEhIrEVyaPJKv5jXtojriGafP4FU/TSI
         BMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795000846; x=1795605646;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UYZeLko8ARh+TMZJ/jcaVMaBZpqH4WAJB7a5zPUzakg=;
        b=C7pfoJ0s3OKA23Ah2c4OhN6Nwp+Qh3+LBUKoaEuNAxwRSzH3INJ0zNDl/4P/zT5Wtt
         kd8me0heEIoguj5ka0CXlPij8+uxCXnviv0xB/46P79mb/ZO6yrjS5u0VwVBY1lStlAr
         v7CFWe/mATlmmw1Gq1d8JctlWbly24Q5suaykCjPKLcLnzFDeTQzC41c0588zaL9VvPv
         AxYbvwfU/L9Fw1XxFFzgeGSxgLuHSTiyxprcJ8SCYry9HmAEHeBT3rLNk1Wn6qm6UjD5
         Art7MJBWVEKIQBKmSzvvMkpA9Lonis/pUQ8vb5y8zN0vDytCiT9AO2JBv5oFXGD444u8
         Ampw==
X-Forwarded-Encrypted: i=1; AL+hErGbbYhno8Zs+II27cY6roQi9s7HagndxT3PLwYptmkPgG7+ravNuhN3ZuotQj3m+l66BHQ1PYb9@vger.kernel.org
X-Gm-Message-State: APuU4Z+jZzriMAqGkgCFC5BNqK3oZ+u/MSicpgGaMDLt2pAR6a0w1fe0
	D6pK8MM8Nreley0TKNZ1A0eLYGg3D4BLfriSReDYIZR1YF/DwMV0X4e3L/IF4XuAYQpiAVJK7CF
	pJWhv6crqPgh/8iVwNqOU/mCYw349fzLsBsVHNGfXIG6hs3yEXXrXIsQ0L/M=
X-Gm-Gg: AYBFou0Attb2H/OuBP24Vzolh8I4dv5u5fsg+7+R66SPN3n8AiQd5pvVt9q92b7kO5T
	6Cw45zagCsph3OD2dwUOt+t0oeZMGuBgMT8/F7LWC8Pi5C5nB0zHAL0qruoLmh9FgZThUjDdZj2
	LrHyexZrjMJQ9gWmoQFcATsbEYv/okulnarF/LWpow01cX8sszmVk8sOU9dG+BTDZUYsHJ5MeRp
	hOmHOUhMqgqsF1h26fOH75nMjUvJtYf9Ky7t6qZgwMCB65BBTAbaPrJ6cOfL8Pxu+k2DMMwhj5g
	FguwBMijHWxXiZczPeAqCTd3lV/b4Sezz9L6HbKqR5jvrzS95Y5tuu+UDKobnTDj2Zhl4iM4o+G
	E3jdQJucjdcLyDRGOkfKc9soW5t/76CRsV7RODD5skdMFrh8aPtfDoCX4JvD0S5h5Ky3Pu9j93r
	1QvBM=
X-Received: by 2002:a05:600c:8b02:b0:4bb:6752:8400 with SMTP id 5b1f17b1804b1-4bb7da1b48dmr39551965e9.17.1795000845958;
        Wed, 18 Nov 2026 03:20:45 -0800 (PST)
X-Received: by 2002:a05:600c:8b02:b0:4bb:6752:8400 with SMTP id 5b1f17b1804b1-4bb7da1b48dmr39551335e9.17.1795000845561;
        Wed, 18 Nov 2026 03:20:45 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78418853sm195748985e9.8.2026.11.18.03.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:20:44 -0800 (PST)
Date: Wed, 18 Nov 2026 12:20:41 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
	boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org, longman@redhat.com,
	ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, shuah@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, parri.andrea@gmail.com,
	m.szyprowski@samsung.com, kayracizmeci@gmail.com,
	weihengqiuu@gmail.com, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v7 04/40] sched/deadline: Do not divide by zero active
 CPUs of a root domain
Message-ID: <av2KCeKAnXAi6saN@jlelli-thinkpadt14gen4.remote.csb>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
 <31f723a7dab4d58045cc60fac0fea09ea1841c7b.1794922146.git.mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31f723a7dab4d58045cc60fac0fea09ea1841c7b.1794922146.git.mathieu.desnoyers@efficios.com>

Hello,

On 17/11/26 09:10, Mathieu Desnoyers wrote:
> __dl_sub() and __dl_add() divide by their cpus argument. Most callers
> pass dl_bw_cpus(), the number of active CPUs of a root domain. That
> number can be 0, and the division then traps.
> 
> Commit daec57983670 ("sched/deadline: Reclaim bandwidth not used by dl
> tasks") added extra_bw, the bandwidth that deadline tasks can reclaim
> on a runqueue. A change of a root domain's total_bw is spread over the
> extra_bw of its active CPUs.
> 
> During hotplug, a CPU sits in the default root domain, which can then
> have no active CPU. This lasts from the rebuild in
> sched_cpu_deactivate() to the offline, and from the online to
> sched_cpu_activate(). A debugfs write to the runtime or period of its
> fair or ext server divides there. A write of the current value passes
> admission in the window. In 8-CPU VMs of v7.4-rc2, a loop of such writes
> oopses at the first offline and online:
> 
>   Oops: divide error: 0000 [#1] SMP NOPTI
>   RIP: 0010:dl_server_apply_params+0x335/0x380
>   Call Trace:
>    sched_server_write_common.isra.0+0x1c0/0x260
>    full_proxy_write+0x58/0x90
>    vfs_write+0xcb/0x550
> 
> By reading, two other paths would divide by zero:
> - inactive_task_timer(), for a task that left SCHED_DEADLINE or died,
>   if its CPU went offline.
> - sched_setattr(SCHED_DEADLINE) on a task asleep on an offline CPU,
>   with admission control off.
> 
> Fix this by changing total_bw alone when the root domain has no active
> CPU.
> 
> With this patch, the reproducer survives 20 rounds with no warning.
> 
> Fixes: daec57983670 ("sched/deadline: Reclaim bandwidth not used by dl tasks")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: stable@vger.kernel.org
> ---

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

