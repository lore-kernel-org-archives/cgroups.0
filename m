Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794467034;
	b=cZeXWEw2OPkeD4M4+2sDOrQFVUTK823ki7kD6pP9rZqk/UaVyT+X7ImU4NQtoyJY1XQp
	 DnU54cp4w0j0znowsy+j9XPITi1rx44xYUpkOF3VDhFablL4eSwsFyLLzMEr0T9crCWVp
	 VjV4KpW9ZKQhg0vQQgF3Lm6BaYqhyVgegaaMLV41xIlayVAdxyjdcQ/JFY9QNemLLFlo8
	 gqRdxdKcenfQHDxu71QzRZcFuEPMb8cGWsr/2mrM5GDFRGaBTWt4TvpyTnAjoAPGmfgOG
	 vrFud1Xb6L0SWTMdjyBFwx8v52+mjIiuH9YRyt1d+aUzxGmsjT+EJ/qI/q9JenDBH2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794467034;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=MzKSTO8LvpR1kk43PP3scsPYLloAVo4g9q+JhIcdw+g=;
	b=H07gpdTAxK7k9JRyMT0w/td2jXI8OhiKTMZizT/LViPgmKF4B7byt0Mqyfy9eb4CYEL3
	 V3cnVnWzVOmmqjW/WYXBIDnVUnnoyAF8jxtDbVGj+uRtUVhGkNoe25vzAHrYk0cRBYDkR
	 oEfm17+uCgIf2SYontaE+g9iItWuv/E7JsInfvHMoyymfTtNYbPtV0ExW2YlotyfYPFTu
	 I8P24tHGU6XRPai+JZKHLwgFrx7OjDPhel8XZv47fV0Ygx3fs1O+Z5aR5aikF5fVrOkq2
	 UabVg7g9J/9kMQ3l/6pQFj7kJQFbNdwTrxe7R1mKkSMVBB4SnncRAsfiytgVoiW7UKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UU4sr+KE;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qV7AOgop;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07038606A31C
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 07:03:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07038606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UU4sr+KE;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qV7AOgop
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794467032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MzKSTO8LvpR1kk43PP3scsPYLloAVo4g9q+JhIcdw+g=;
	b=UU4sr+KEXLWG/VMn1tojphdaL3NHxohGi1XR7H6d1DZnX2DZ/Dmoe4EXaCaFOPROeVmBuD
	2Bfbh3HCYBFXXQFQrUCiXcYUeVnOSG812IacDyGUJsnzLOreHMjOSegjGGe6KiHolligtl
	OeRD6FxIHNmw1C/SrndI+EtsqjnDOk8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-Bz_4qpZfNEKDyP4sYz_8uw-1; Thu, 12 Nov 2026 02:03:50 -0500
X-MC-Unique: Bz_4qpZfNEKDyP4sYz_8uw-1
X-Mimecast-MFC-AGG-ID: Bz_4qpZfNEKDyP4sYz_8uw_1794467029
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48fbcf023dcso2346299f8f.2
        for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 23:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794467029; x=1795071829; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MzKSTO8LvpR1kk43PP3scsPYLloAVo4g9q+JhIcdw+g=;
        b=qV7AOgop0W01vPhiKpcbR1iniUM5nKXxDo0iqseOsfEa7Vdop3uUtjikrlcz9SfGhX
         swRduSSzYFGPA6SA1t0n/QbHVPGxqpAkLR364JdwWI2FHto12oirN84ozqFqFMq20r1F
         WUyGD/gKFIKiGOgs8EB7mvjygEmIB6oYqrdDeV6MTrTONcrBiyutaMcXH9UZPOTY+izo
         bdNJUrD04e5vd9Ifm+3QURW2XY1Q0PG5n3UAVMkxJDF3iaDVeuxNhWZcsf/3oDmoYqfu
         VTbWQJzjrzM8tI5fxMlDn45A68wJutyg/8IB6/YQC8CI8F4D7IsPPkKg4DmE7om/b3Tw
         eJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794467029; x=1795071829;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MzKSTO8LvpR1kk43PP3scsPYLloAVo4g9q+JhIcdw+g=;
        b=gLEnzefowG+GeaIH5yn/z01gU7qag/qxWq55TPv7GWFRrm4LfNOf66c79pUsik/hVy
         Zi7G1mDzNVYYNioK/ebSMpsMtZWOBq2Z8qd4fQxI82h968hANXPwsLn3ViOlMpC03On0
         GYc//gZB2lM2EJ3oRzAF+IIlUfyMQ6nQ7KUXolf2+xODPacwvRlLT16ID0r9W+oJ84qu
         t5RejFCkE0qwZTjljRHs2EuUDsNMeVM+EtvDhWFseuzkreNzdfGeO/RuGLzOAP108CDF
         Z1IupyaQCd4eNd1RR87f+P+/BRwOVQIBiwGvMylP4Jhfo1p9ws+dURFzsSieSXI4aQWr
         tYBQ==
X-Forwarded-Encrypted: i=1; AL+hErFgmNUGdXBqBtjiUXaSnPM7P1TkvaQ0+kYgWhfdw255XyutpgFVOmK++3asyhuQS+exOnlnBSgs@vger.kernel.org
X-Gm-Message-State: APuU4Z9IIsJJ/+AJX4q9No6ak6rRj02H6fUuVK2FlzZhbDxvevezfa7a
	SX5JbiTOBbgZMuJwJRJGefPF+1p9ouJUzK5iECddGXoi9mhBz04BDEvCTql8kVabqSZd9dRFGuC
	vddB5sgydcsUB7YQEiI/XLMW+5gsHGCd3UtpvuFKX25VCIQj6x+limR1gl0I=
X-Gm-Gg: AYBFou2HIMZunoecDGSj3uBD8d3oay4wa4khOWCAgVN/9UpySHWscrrQwLny9nZ/4gd
	A7zAeeJBkuaLUlSQ6PtK2Zx7KAiy/BFgfVAD4OZLV53b5Tj5JPC18/lmW0Jq03HJtr4Ii46Ck7D
	uneeGoW17wzSrjKoA02z4N/qXBdDjyISwaID5pS1o0sJ6zfmnwhvnlpfhmA5pWDUdiyoHg6a+aT
	9QBrwxGrTs0pxDzahW3pT9/NLiIr81Id6sV8xksu7LoR6cYSRGWYpi4GwS2yfMfE7WvcNrthePf
	n432KBAGsZc82pkSPqrkXm5EPE/ys9sZCvsPuEEagEMUKcb2aBRF/Bg821jS7tGRo2m26GCQq8K
	7m5TV6BVGrPsDSWJ64C4s/1l2+B8eAxFqBMcgY+AW0ncOewl/1kd+7UFLPYsTprMY98+HXm0uZN
	/EmpA=
X-Received: by 2002:a05:600c:46c5:b0:4a1:825a:56fd with SMTP id 5b1f17b1804b1-4ba093ab88emr83497705e9.32.1794467029441;
        Wed, 11 Nov 2026 23:03:49 -0800 (PST)
X-Received: by 2002:a05:600c:46c5:b0:4a1:825a:56fd with SMTP id 5b1f17b1804b1-4ba093ab88emr83497045e9.32.1794467028991;
        Wed, 11 Nov 2026 23:03:48 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498369a495csm14952955f8f.55.2026.11.11.23.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 23:03:48 -0800 (PST)
Date: Thu, 12 Nov 2026 08:03:45 +0100
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
Subject: Re: [PATCH v5 18/29] sched/deadline: Move a task's bandwidth only
 where room was made
Message-ID: <avVk0UU8IRGoo77v@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-19-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261108185406.1549770-19-mathieu.desnoyers@efficios.com>

Hello,

On 08/11/26 13:53, Mathieu Desnoyers wrote:
> Commit 7f51412a415d ("sched/deadline: Fix bandwidth check/update when
> migrating tasks between exclusive cpusets") moves a deadline task's
> bandwidth in two halves. cpuset_can_attach() reserves it in the
> destination root domain. set_cpus_allowed_dl() then frees it in the
> source, when the task's affinity changes. Its comment relies on the
> first half: "We already made space for us in the destination domain".
> 
> But set_cpus_allowed_dl() runs on every change of affinity. It frees
> the bandwidth whenever the new mask leaves the task's root domain, with
> or without a reservation. sched_setaffinity() gets there too, if the
> task's cpuset spans two root domains. With admission control on,
> __sched_setaffinity() refuses such a mask. With sched_rt_runtime_us
> at -1, nothing refuses it. The bandwidth then moves with no room made,
> and no root domain counts it any more. The destination would underflow
> when the task leaves.
> 
> Fix this by flagging the affinity changes that come with a reservation,
> as SCA_DL_BW_RESERVED. cpuset_attach_task() sets it, through the new
> set_cpus_allowed_bw_reserved(). set_cpus_allowed_dl() moves the
> bandwidth only with the flag. Without it, the bandwidth stays where it
> is counted, until the next rebuild of the accounting counts it anew.
> 
> The attach still flags a task that became a deadline task after
> cpuset_can_attach(), with nothing reserved for it. "cgroup/cpuset: Give
> back the bandwidth an attach did not move" fixes that.
> 
> Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

...

> @@ -2957,6 +2957,8 @@ extern struct task_struct *pick_task_idle(struct rq *rq, struct rq_flags *rf);
>  #define SCA_MIGRATE_DISABLE	0x02
>  #define SCA_MIGRATE_ENABLE	0x04
>  #define SCA_USER		0x08
> +/* The caller made room for the deadline bandwidth in the new root domain. */
> +#define SCA_DL_BW_RESERVED	0x20

Why not 0x10?

Also, nit, the comment looks off compared to the other flags w/o
comments. But maybe they just need to gain comments (I keep forgetting
what SCA stands for - Set CPUs Allowed, maybe? :).

Thanks,
Juri

