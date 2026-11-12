Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469824;
	b=uNHf6jvoQ6S/gEL5m99aAMwSMJr1cLJt2PjKN/QJ5jo9qglbSCorho/dOH0h768llSx6
	 xFzwJywKCf24BWJZGP7n/tE/W4Yfm9H9ZQtN9o9Uo2QJbZ+f0Q0Bs785SKDBnmBte76c1
	 Jt2zTPJygB3G7P6da1FxbjSklhYZI9PayP89J5O0pL3o9VHPWD/V1TZUpWlT1KXVeX86d
	 I0SykLCAupnzDYPMyRpeSKtne3kUiRJjdA4czJqMy0OfvNrCCcu2Zh5DVIFZXVhVLp55N
	 q+fhZb5dS2++6al24i6OrIaS6VE+fh7RAOFDv0uOfSTIpJrgnmC+MCNfQTb/OBZbMAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469824;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=eAEaXknwutXsE98av80d8xzVhjo04EdbVXbDbQO9bFo=;
	b=CBeG6NA8H/ev94CCM8MvIYPLq/9nHs5Z3B+UBZDEYSGcUnbZhyaKmBSTxBY8z7pOOy7z
	 UdcBMptwNy23RaP5IJZi5aSGOsJSo6Y2SoDeiGbVt3jqIbityGmRn42E5iSy/wUJqZdcI
	 ow/WqdDnlakVi18xUjxtujSMLVsZUDCXb87WuUiR/k/XFhsjXvQHJoif4gPRFweS/udLX
	 95LNh4Od3f9LCRTKb8A4RSMhtFe0M1KABaQxRJI+pIuxp5x0gErxzZonSC86P5CaIQWEh
	 /HMCbcaJxQnW7/yTN80B6xNDo6aTttURMtQJmoBmPEuAH+Z05X1Z5H4m80o/hk3XH8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bO7VKf20;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qDwrBmcq;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13B7606A330
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 07:50:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F13B7606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bO7VKf20;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qDwrBmcq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794469822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eAEaXknwutXsE98av80d8xzVhjo04EdbVXbDbQO9bFo=;
	b=bO7VKf206GndRdvNIcdsMumUbF0HP3xbPQkOTtL9to5a8h6p89zXJuhvc4EO+mP6CGR9fw
	a8qj4vRNRW5L5M4jbq6RG9+RfU8g5VKYgJjaJOR2EWmEsaM/eVsG+LWDY9P0LvLbzHPH/7
	QvWW2+SQ5XrRdKRmyVafpPejKKft0Ao=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-u4o0jUNRPrqHFcT4MDB-nA-1; Thu, 12 Nov 2026 02:50:20 -0500
X-MC-Unique: u4o0jUNRPrqHFcT4MDB-nA-1
X-Mimecast-MFC-AGG-ID: u4o0jUNRPrqHFcT4MDB-nA_1794469819
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a359c7f47bso34000015e9.2
        for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 23:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794469819; x=1795074619; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eAEaXknwutXsE98av80d8xzVhjo04EdbVXbDbQO9bFo=;
        b=qDwrBmcqbdfv6sjXk1rqxfTgCtqUKuKT1+J9Hh/rhnouIzDHTT66xrCcbFw09I5gzH
         shdWuZZgpiY7326zbMZC217ZWyMWsiJlHJUuwt6QWR9XgsdW032CaJPDjngjN1lHNWNu
         pdDlSf22mdcd9DHpYvFdT3oWmDnGz0PxNtRtVnWqIicChUtPmY1lzcN+QWv2sBRAUyCr
         n+7mdMjMeq5ADnfe/XQBPNgfgjwjdTWWikxeP7FFO1nmpQijKjghDM6B78PoLBDKSop5
         DHjNxtHQtaLc9kYWDgH/EBIy6TA6zxY1msISa4pPKoJt906w9hOvsl0CSD3o/9/jFse+
         MgqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794469819; x=1795074619;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eAEaXknwutXsE98av80d8xzVhjo04EdbVXbDbQO9bFo=;
        b=d/ULhS5HHMQy6Y4+rWGlMnbYryXG2pGedSOnyFxbWrGaiTm8De0LATU4LbGvXQOoqv
         zUPhLDNeAsZpGXJn9TonGcpgJiILQ3S1mDN7MXNBFUwMNnij7JqpzShDjTcyK51Z72kQ
         gTIRD1qxNkO43tTWfRcCKLcLCSR2Usv9fYJupyxR1BKCMuQ68wKZgWfYWsJ1GdVITlKH
         xnCy7ZPpGT6y84cgfBLNh/XTee6acIaTPK11WGK3FqE+bKlxghZnkwvNFPwGPRaY+Euo
         fkmoszTW2pNS6k0nY+sPOg2azGPCoWUvxKJGR2qRHCdwB5konml4XF6aLRDZDV4/sZSC
         Xn1g==
X-Forwarded-Encrypted: i=1; AL+hErFFz652ITMjaO4ahi8AFwldYwEsCOTWqmYDZle/KvW8HmHTp7jG2skUeW+Evk52sUNWtckgeuBd@vger.kernel.org
X-Gm-Message-State: APuU4Z+iihDT7THlrlm/ZZA4jMXe/vUtC1bxj0qG3/YApHvJwRRr+khZ
	uQMxRwVt67KychNC9FRIE8saYpyurietLTGkAJnznUEYQpUFN8lKF0uDTg37cEfd29irVmTgora
	j91CDybnDQ7gCQ3kBh9WBMQaS67NJeIwrorRRshoKFnZ7yF/YMLrhfW17c+U=
X-Gm-Gg: AYBFou2eqGoQ5do/j+J5oEbUu7rsbTm779PzLKWkUR8Mdcn/WZeLIBmQ7Uix46YrVPv
	qDtYcTCBMMBHAvp1eIgmZYDsRtxALlGjoYBsaqXhToWVCCwwfLQ98fZeIm87OLCk0RYRGqv5jAq
	S9feZpUNb+MCFy62mMSrx+Np9wb/wF87pFDL2EjeJl1E0ZCFyePAqr/doDeEJH4T/b4lVTN7eaX
	TGkc2WE6FkgI5xKoD+uF6oCGhnfdi9ps+n8qEplRbfvHrw/Ra9WfdwOm/cQPKTk5O1qCOTjeCuh
	nwEAq/Fo28dUwkGxNbqtDb8UL0gbDEyF45S347sukkHut/0G92nv+wjmv2ir6NaUMj4idSbOmR4
	CdXPHdfagyOb1SGlGkh2Bzh7VYKMEit0gmfZlmZNfoPjwIzVkBaR9eu8dUvdWs7B6xhB9OH2d9d
	bnZA8=
X-Received: by 2002:a05:600c:1986:b0:4a1:f7f4:7cf1 with SMTP id 5b1f17b1804b1-4ba09376d2dmr82685365e9.11.1794469819070;
        Wed, 11 Nov 2026 23:50:19 -0800 (PST)
X-Received: by 2002:a05:600c:1986:b0:4a1:f7f4:7cf1 with SMTP id 5b1f17b1804b1-4ba09376d2dmr82684805e9.11.1794469818478;
        Wed, 11 Nov 2026 23:50:18 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e28c882sm52359655e9.6.2026.11.11.23.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 23:50:17 -0800 (PST)
Date: Thu, 12 Nov 2026 08:50:15 +0100
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
Subject: Re: [PATCH v5 19/29] cgroup/cpuset: Wait for an attach before
 rebuilding the sched domains
Message-ID: <avVvt8wlKqW4LqTa@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-20-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261108185406.1549770-20-mathieu.desnoyers@efficios.com>

Hello,

On 08/11/26 13:53, Mathieu Desnoyers wrote:
> cpuset_can_attach() reserves the bandwidth of the deadline tasks it
> moves in the destination root domain. cpuset_attach() moves their
> bandwidth later, on the strength of that reservation.
> 
> Commit 75f7a25ec6bb ("cgroup/cpuset: Prevent race between task attach
> and cpuset state change") lets cpuset_attach() rely on what
> cpuset_can_attach() set up. The writes of cpus, mems and cpus.partition
> wait for an attach in progress, in wait_attach_done_lock(). CPU hotplug
> cannot run in between either: it takes cpus_write_lock, and the attach
> holds cpus_read_lock throughout.
> 
> But a rebuild of the sched domains does not wait. A write of
> sched_rt_runtime_us and the energy model rebuild them through
> rebuild_sched_domains(). The cgroup v1 writes of sched_load_balance and
> sched_relax_domain_level, and hk_sd_workfn(), use cpuset_full_lock().
> 
> In this example, a rebuild drops the reservation. T is a deadline task
> asleep in root domain R. Thread A moves T to a partition root P, which
> has a root domain of its own. Thread B writes sched_rt_runtime_us:
> 
>   A                                      B
> 
>   cpuset_can_attach()
>     takes cpuset_mutex
>     cpuset_reserve_dl_bw()
>       P's total_bw += T's bandwidth
>     drops cpuset_mutex
>                                          rebuild_sched_domains()
>                                            takes cpuset_mutex
>                                            dl_rebuild_rd_accounting()
>                                              clears R's and P's total_bw
>                                              counts T in R (not moved yet)
>                                            drops cpuset_mutex
>   cpuset_attach()
>     takes cpuset_mutex
>     cpuset_attach_task(T)
>       set_cpus_allowed_dl(T)
>         R's total_bw -= T's bandwidth
>         records a CPU of P
> 
> P now lacks the bandwidth of T, and admits deadline tasks beyond its
> capacity. When T leaves P, P's total_bw underflows. In testing, the
> race left a destination admitting 3 tasks of 10% too many, or P
> admitting no task at all.
> 
> Fix this by waiting for an attach in progress in
> rebuild_sched_domains_cpuslocked() and in cpuset_full_lock(). The
> latter then takes its locks in the order of the writes of cpus and
> cpus.partition. A rebuild from CPU hotplug finds no attach in progress.
> The online, offline and kill of a cpuset never wait: they hold
> cgroup_mutex, which the attach holds throughout.
> 
> The move_vs_rebuild case of deadline_bw_test, added later in this
> series, tests this race. Without this patch, it fails in 5 of 8 VMs with
> 8 CPUs. With it, the case passes in 8 of 8. The next patch needs this
> wait too: without it, it would give back a reservation that a rebuild
> dropped already.
> 
> Found by the Sashiko AI reviews of v2 (the race) and v3 (the cgroup v1
> writes) of this series.
> 
> Fixes: 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach() fails")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

This looks good to me.

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

BTW, this and other patches are actually cgroup/cpuset domain, so we
will need to ping Tejun, Waiman and others at some point (if they are
not looking at this already :).

Thanks,
Juri

