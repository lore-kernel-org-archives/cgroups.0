Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794236961;
	b=zdfTepqpilH/uXSSXMNvxbhjdYVP9nrj6De/jabFJ/yvdC30np+3IrsExPSTwissZMcq
	 WkUmThsnXK34yBwg5VUJqRN81xf6h3pgj0ZAcSfxxfDrDjy7vI9Q8Eo2Le7daWMjN6M+Z
	 T5VBGhvuDxK+DgbggQugeFglzT1PsGY+7OlpeQovVLOg+827K688ul9bduZoTjhNTO6pB
	 61YQSq/NxsAsJqnym19Heh1Dgz4/J0XfKzRNKLykDKTwJCZMfT056v1899rCERZHFf+PV
	 6bE2KVjy7TYRwgUuFI59d+NJF9XywdoRbNPRKeL+ICrHEc1M5fAxflEh3nSsTuaqFIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794236961;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ehk/Gi0k4ynJUIsecQ39iaSJWX96HxZZqDpEX10WpqA=;
	b=YukLPlC1oz+WclNb2v1K/80/p1Ka3Bk3vrpuNnUrkxG9/ggCYIMqs6ix9eLwfF5GELrq
	 294gb+EAKz4MhZTQflIYH92Funk+0xwVbor3ot1h0eQMx7369Qx6S1+Ncm7VlVhryHWoC
	 pEgFmWUbpoEX2t/uFJQzyHZToRryKwb2D4aI/tPjbPkOaUgX8PlTY36xGsJLThUUQr955
	 DHol8AsZerCdGGAC65AvWdAqL1zvmxlvkJgwP1mKaOe7RhMNufIKNvQ7x4aVhR6sAljKK
	 YAanFAm8Utqa3RHxts76J1Eduu34q8TYVpORERt7XcpouZSI4VIJXka5Gj9bB9qUknQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RHiGBPfq;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=LTIsuBLa;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F13606A334
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 15:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4F13606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RHiGBPfq;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=LTIsuBLa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794236959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ehk/Gi0k4ynJUIsecQ39iaSJWX96HxZZqDpEX10WpqA=;
	b=RHiGBPfqVCTnQ9e1eazGQbFKWX3nA2oksD9mrf1L+4kJ7PgZGVUWACaLWMWt1i3dPA6NQ4
	UcoedXlIhrDNV59lL5Z7uz1kUdC5p2nBpKbs101Q9yHA3zsckfzUOH8fgviFm+YVDEFK0i
	8eeLVrHhEiaXmVkbzUIR4R3/NnjVBLg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-dNC6vOW2Mq2clYRd-rjbyg-1; Mon, 09 Nov 2026 10:09:18 -0500
X-MC-Unique: dNC6vOW2Mq2clYRd-rjbyg-1
X-Mimecast-MFC-AGG-ID: dNC6vOW2Mq2clYRd-rjbyg_1794236957
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4ae2756fa7aso6808605e9.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 07:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794236956; x=1794841756; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ehk/Gi0k4ynJUIsecQ39iaSJWX96HxZZqDpEX10WpqA=;
        b=LTIsuBLaTJuFbm754tSh3DeL+OrbAxHo5FnRP/90ZuKvbnEDj7v8rOVgTVoP9+/9c8
         CQPD2ixbWQqhUKx/pDu4v6PA/pMkf1xzvIUn/bez4yFIkpU8JnNoULhad5PSW/2DGP1L
         FKiNt9gOjCE2HOGezsfk3wZnGVm3JdxxSurhkZNUbmdTbL57/knVw7gvuEcmp/xyfq76
         4OCeBZPwWgTINF0Vpr0y6QgI1eUSkJfPivCYwlt4AgEAmtR6vPZR4no3b5R30BzYkdI0
         nVrDG9rmcrdpPzOLAgziSE4torSay4ZfeVzjGKJAjFYJ8yCI7ABuD4Y6MsOBGO2W0Q1Q
         l13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794236956; x=1794841756;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ehk/Gi0k4ynJUIsecQ39iaSJWX96HxZZqDpEX10WpqA=;
        b=lf0bnY/dmJiLSSOr4pUFq8r/CgSsZ2DHTpZO1beZ6FFJ2H9daJ2VgYw3G3AJYgeHuf
         fYiSBH7W5rEUKWJWDb59pyqYsY0UOIJR/cUZjGC2JlUhNbWwGyAAvYGjTvlVoSno50gS
         cacFG63lbTfskLycc80ON/sXKeIMx2ohp0Qd4tCS83d6o9MxgqrA+M/bv9NH9/OXLCZM
         ZgTXrk5j8dkd0WF64Yft2F3QsFkSUvDNx3iUx0jvKCHHv0fnwxhaC1nWET5aQ67Frxjj
         X0pxcfRQ/QkYWYpe4c7iEi1i2kdIgS0EOHwplJOkulhxSaQvM4Aq72FYJSZkdGqmTCjv
         cN/A==
X-Forwarded-Encrypted: i=1; AL+hErGEnnRca4rlxn7AuDnEYuQJ0lwLjLC0m2wF5diTpXkjO14u22qSa1YCon0PuVafb841Qxsd31re@vger.kernel.org
X-Gm-Message-State: APuU4Z8b642pGK9RuU8EQoHIQGpC7z4cHUNu/NvwYBdp3T1M0CuJRwT2
	6cbJyR+8W0j3HjgCggsIu9euNxeqtnl4FtT3W+vRvtN1L8JY0MU1lV21blVAWBYhvpbFPeBu0r3
	64Blntktrfa9Pg5p9VGWQ0YcAUR8cN5spXxJcejwVfvHzo4ktZDJqPCrKyQc=
X-Gm-Gg: AYBFou1X6aeKlaPXKHwPI7HJnw9IDTujHY31WyyMKj1ngm534woKCipirWa6lMphFfz
	a1Khqza4WlY6LZctUSBH4kjoFm1OeTHbxNSzEyB3i1Cbl4QwyswtMbPY03e+++Bf0MDJgesTgV1
	OEYeBS1KuX4sdv0R4i352094UKPcm2yvIrT1q6DOyV6mOUPfHgfIRfGGcOy9KGbNtwUNdbzarFp
	s2oIaVc2JCO1wHKTsuWEm4g68gqewOjbBo1CgvDEsasSL2xLFsOrYNAIw64Lw2lPhIGRTnYokXN
	SjgYo9AGWGeE1Iq6iQqrld+Xt2ML4tjUJz9drEbNoHANi8QMKRLM+D59a4TRs2/pRwfqzTVa+WJ
	9flk4HfuYXD8opw95KEaxSXtUc0Gs/L8O71yWDknxsuFwEB5Gd6n4AUV/dD+G74U0MdFnR9uZg6
	7Jtg==
X-Received: by 2002:a05:600d:82ea:b0:4a7:7f3f:6f8e with SMTP id 5b1f17b1804b1-4b943f76d81mr96595705e9.0.1794236956082;
        Mon, 09 Nov 2026 07:09:16 -0800 (PST)
X-Received: by 2002:a05:600d:82ea:b0:4a7:7f3f:6f8e with SMTP id 5b1f17b1804b1-4b943f76d81mr96594555e9.0.1794236955393;
        Mon, 09 Nov 2026 07:09:15 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7e32ad4d1sm255269375e9.5.2026.11.09.07.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 07:09:14 -0800 (PST)
Date: Mon, 9 Nov 2026 16:09:12 +0100
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
Subject: Re: [PATCH v5 05/29] sched/deadline: Do not divide by zero active
 CPUs of a root domain
Message-ID: <avHiGH_4WBizEaBJ@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-6-mathieu.desnoyers@efficios.com>
 <avHY7oNeuvjsLT4I@jlelli-thinkpadt14gen4.remote.csb>
 <3e6677a8-b972-4081-a080-e925fe1df3b0@efficios.com>
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
In-Reply-To: <3e6677a8-b972-4081-a080-e925fe1df3b0@efficios.com>

On 09/11/26 09:57, Mathieu Desnoyers wrote:
> On 2026-11-09 09:30, Juri Lelli wrote:
> [...]
> > This 2nd hunk complements and tightens 4043f54984161 ("sched/deadline:
> > Reject debugfs dl_server writes for offline CPUs") which has Fixes:
> > d741f297bcea ("sched/fair: Fair server interface"). Do we need both
> > fixes (if that is allowed) or maybe we need to split this change in two
> > (as this second part won't apply to old kernels w/o dl-servers)?
> 
> Good point. I will split it in two in the next version:
> 
> - __dl_sub() and __dl_add() skip the division when the root domain has
>   no active CPU. Fixes: daec57983670. This alone removes the divide
>   error, on the debugfs path too.
> - The debugfs write is refused while the runqueue is offline. Fixes:
>   4043f5498416, which it completes for the hotplug windows. It only
>   applies where that commit is.

Hummm, I'm not sure we can say it fixes 4043f5498416, which was a
correct, but only incomplete, fix for d741f297bcea (which the second
hunk fixes properly).

