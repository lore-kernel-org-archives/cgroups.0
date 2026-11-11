Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404985;
	b=CuZDXupqY3/gxH4TDldGj1aPtkUGQs6rSk9kaPJc8b/BYwADDkk7uPdx4lpPECAgLuhK
	 G0Jq82yeGHvs6mv+QuR6UsRngSa8688HUfuj2AJGncslL+cJCIpI6LthGpJJ+8upteE1X
	 /3vG7etJFZQyprj/DWm/5ysqUwpGUj+uavdK0w7Ne1uGHBXPOayXN18v3tkXv87wPqiMA
	 uPDLKz5Ulb3vU/dwFUjCCJMImv9cGwulhfCFvvbSClVWbKEDhEo7cOVBQZSFDmm1OFVVB
	 Kn3YxemHrTmUtfA+OyJ/QPmV9Z8Tv06unvPHkGuYM0UMvlwjiUyEo4s6ovUpOrFPbwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404985;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=QrqbGrUeaMzxTtNKFPqZn9l9SynA7oL6rbPLiV4WlNk=;
	b=wmnYisR8OUMd8FOvSijZzvpoVR4RqwZs2NhxVvFAxciakgjV3G5otfVUiKq8YuoDMlAy
	 ihleEyEsek+DURzmbhZLwsenayQpnS2vx7Eu3B9bHOOB84LazjSUP7k6r2I1otWRkUO7f
	 m1axFBHHpX2mEav4OXtHjpzJit5VKQRhCAPCDXn4JJnzo+OrLmQBNYUmk99V/Okd1xJG5
	 PZK+9hWu25EGQRPGLE98PKmq9WIwdxyveNGI6duZM+Qmw4WXvL5djU5Np+KeSVyjmmYjD
	 BJiTXKUTt2f8vWEwk0TuLQs48x/SB6P9WogMLLiI46gTDSn3NwcSWOPYeV+HaeKuzmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Dxa+lxRe;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=i7GQQlT9;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CA3606A335
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 13:49:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2CA3606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Dxa+lxRe;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=i7GQQlT9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794404983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QrqbGrUeaMzxTtNKFPqZn9l9SynA7oL6rbPLiV4WlNk=;
	b=Dxa+lxReamTY9bp7EcOWVafTkGHpIkIwVWZ4Wk1F/qz2TmtgCHN4s2aeSMcSQG6qw1Yz0f
	aZ3DwhFUVXkGGeOV3MxruAq91CHHk/Iraqsz6LWJctd2/VJQRKiWatJXLBKMUCDxRn+O/F
	vevXgaHOA4MwGrM0tYF81AP8HdhYcDw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-dMbU94yzND2_TzWK5tIcKg-1; Wed, 11 Nov 2026 08:49:42 -0500
X-MC-Unique: dMbU94yzND2_TzWK5tIcKg-1
X-Mimecast-MFC-AGG-ID: dMbU94yzND2_TzWK5tIcKg_1794404981
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a35db2d6b3so24449765e9.3
        for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 05:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794404981; x=1795009781; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QrqbGrUeaMzxTtNKFPqZn9l9SynA7oL6rbPLiV4WlNk=;
        b=i7GQQlT95Sb7l8iWRKyldHDMVoU8dEQ8LiXnZ/hsSPVTmpVPPFHPcB6HPY4EJj9pXU
         Nyw0+YSthtfLeTFqEMaMCW2lXgBUEMBHGxPVxY3RyRUtE2fccvhNeF+yeloPLamC0ct+
         1tLlBJjv7LjgleRz4OsNRroLTN/NQHrdCy5Vr73XAYrVVO98+580y6l/t5Xx5YglOKkh
         8UMvx9Zwo+ctLLVC8glyZtIIlsb34h51iIjhpJvjDrF1gzLRU2XUgZ3fVtFU/hfcBgCI
         YKvSjo6cy2EUeE5zbOmSB9/OfNnw8+mkIQ/C7gLj+OQw8eK/UY6c9DH7M1WLUopEffRe
         q30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794404981; x=1795009781;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QrqbGrUeaMzxTtNKFPqZn9l9SynA7oL6rbPLiV4WlNk=;
        b=VzcGnRHeeycaHp2JU6Nlc1gotzf2JDoXAbdCZ2romvPxzrOjmOn5QZ6gyY+aCNKMUf
         y4RA+/tUskiq5EmWTfdi3QmSF9JXaDLrk5hTTAC1SFyxEUSWCigeWQglazzJeVFYWDQ3
         tTzLx9jhQnCDBdmt1+005zzloY4AKihuVdoHghjxVpteBgNs3p2//jK4Hdj0TLTpyKM0
         YHjOpy/uaHMI/ehcBcJGfMVHndPu1VrDJprnunYBNqjumYpBk+TrBEeVmO7kTRquLMsP
         RWuPBLHKNxMKziHN0fbHKGMSppmdJNnFkBAHM4jdRIaj1vlC7BpudQzzOX7ih9fw+4+w
         yoEQ==
X-Forwarded-Encrypted: i=1; AL+hErE/Pt07SRHouynzlHp6iNR6ayJ9GbA0w510TSyKl24JmWDXPeeoMz8Hbj3Tp0noQ/YJqZKC86IE@vger.kernel.org
X-Gm-Message-State: APuU4Z8cyJPa1i+qMj+uKX1dc+iTEUrdFXwc9D6ic3Uxv8xi5yH7rD3D
	zQV+LCIqBdmr+RPYQC4THvds4czX6+wCun2RzfXzGL29xmG3D8UoEnXEdAfyjQ/RgGarGPGyh3N
	Q3pX4rkD4LLwYxs8AL2gNwrb5ltIv3VHc5HgYTUls2AjuvzZIu6HPN0FYrSg=
X-Gm-Gg: AYBFou2pDkeLRJ9zeWmpwa3J/Ljgp2V0kvYZNlDfQ+icm3iOh0eDctxwJYJ39J4P+XN
	itSJWZPzlPAxOlHK5aRGAj996MyJql1803OVgPoIhgkq/uYz+UDUxamcj3DK+TvYnzVN9k+HXv7
	1AhCG8R7TEjQTEpZt9iP2B0DGZbIfeTSd4BiXItAsmpArsGIsyk7XO2usAQg1kanAJ2Kz7jsULY
	jdFpn+qm/yQHq7VSSY6vyKmhYmCJ0C89JQYKxWSUUssZdmvb8Lq51leBy/QMfVZd+0U9uDA9Bq8
	18t11tIZ704/aFMlA48iKN5xP+qKobo1ckMYme3GUNKADYUoFtwhJOkumQ5Ur1i3ukhLOWcJEDE
	d+n01wZF3v3AM4zwNjnHckmexPnNNG4jB5YUlhNuuT3Ji1+heVo5XNYn5hbG4hAzcBqg93XWtzo
	bgEtU=
X-Received: by 2002:a05:600c:6308:b0:4a7:b304:253e with SMTP id 5b1f17b1804b1-4ba09381867mr49914115e9.22.1794404981069;
        Wed, 11 Nov 2026 05:49:41 -0800 (PST)
X-Received: by 2002:a05:600c:6308:b0:4a7:b304:253e with SMTP id 5b1f17b1804b1-4ba09381867mr49913635e9.22.1794404980722;
        Wed, 11 Nov 2026 05:49:40 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba01fe2f09sm159753605e9.4.2026.11.11.05.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 05:49:40 -0800 (PST)
Date: Wed, 11 Nov 2026 14:49:37 +0100
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
Subject: Re: [PATCH v5 14/29] sched/deadline: Fix this_bw when a task is
 changed during a remote wakeup
Message-ID: <avRycWTxtUr9gug6@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-15-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261108185406.1549770-15-mathieu.desnoyers@efficios.com>

Hello,

On 08/11/26 13:53, Mathieu Desnoyers wrote:
> The this_bw of a runqueue is the bandwidth of the deadline tasks
> assigned to it, running or not. GRUB uses it to compute the inactive
> utilization of the runqueue. When a task wakes up on another CPU,
> migrate_task_rq_dl() takes its bandwidth off the old runqueue. The
> enqueue adds it to the new one.
> 
> Between these two steps, no runqueue counts the bandwidth.
> try_to_wake_up() can leave the enqueue to the wake list of the new CPU,
> and return before it runs. task_cpu() already points at the new CPU. A
> change of the task in that window gets this_bw wrong.
> 
> In this example, T is a deadline task that blocks on CPU 0. A timer
> wakes it up there, and try_to_wake_up() picks CPU 1. S, on CPU 2,
> changes the bandwidth of T from "old bw" to "new bw":
> 
>   CPU 0                               CPU 1                       CPU 2
>   T blocks
>   this_bw of CPU 0 counts T
>   <timer> try_to_wake_up(T)
>     set_task_cpu(T, 1)
>       migrate_task_rq_dl()
>         sub_rq_bw(): CPU 0 drops T
>     T on the wake list of CPU 1
>     return
>                                                                   S: sched_setattr(T)
>                                                                     task_rq_lock(T): CPU 1
>                                                                     T is not queued
>                                                                     dl_change_utilization()
>                                                                       this_bw of CPU 1:
>                                                                       - old bw + new bw
>                                       sched_ttwu_pending()
>                                         enqueue_task_dl(T)
>                                           task_contending()
>                                             add_rq_bw():
>                                             this_bw of CPU 1:
>                                             + new bw
> 
> CPU 1 then counts the new bandwidth twice, less the old one. Repeated,
> this makes this_bw drift until it underflows. If T left the class in
> that window, switched_from_dl() would take its bandwidth off CPU 1 the
> same way. A task that enters the class in that window would be counted
> twice, by switched_to_dl() and by the enqueue.
> 
> This needs a wakeup that moves the task, so a root domain of more than
> one CPU, with busy CPUs. CONFIG_SCHED_PROXY_EXEC=y makes such wakeups
> more common. In testing, a task sleeps and wakes in a busy two-CPU
> partition root, and another CPU changes its runtime. The kernel warns
> within a second in each of 8 VMs:
> 
>   WARNING: kernel/sched/deadline.c:352 at dl_rq_change_utilization+0x71/0x2e0, CPU#0: wake_race/109
>    __sub_rq_bw(): this_bw underflow
>   WARNING: kernel/sched/deadline.c:316 at task_contending+0x244/0x260, CPU#6: swapper/6/0
>    __add_running_bw(): running_bw overflow
> 
> Fix this with a new bit, dl_bw_oncpu, that tells whether a runqueue
> counts the bandwidth of the task. add_rq_bw() adds the bandwidth only if
> no runqueue counts it. sub_rq_bw() takes it off only if one does.
> dl_change_utilization() does nothing while no runqueue counts the
> bandwidth. The enqueue adds the new one.
> 
> With this patch, none of the 8 VMs warns. deadline_bw_test, added later
> in this series, tests this in params_waking and random_mix. The Sashiko
> AI review of the first posting found the double count, and a bit that
> the first version of this patch left set.
> 
> Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

