Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793862889;
	b=xZ6+MAeTWZ1PZk9eUQxhZB5M1yNb5OM1xzI0+5J8YIybR0WQzgkpQYugBPKhNq6H2mdb
	 gKyGbg+bNZ8W2sjkHE90zqka8ZjysOFsE3HQqrt169oJhY06teB9M4xu6Z8FFL/zIYbvV
	 wjDt3h0rKt/TCVnMLT7E3gLEaMJjDmLF/5w3VjSCKf32VjdKvmB8eGhLB2eldD/2QAR2A
	 ZPjXzoERTDO6BCyZlXYxNwY9LM58WPCkguA5luvQaKV2RXFIvQqzscOorf0KjaqUslT/8
	 MdypqBs88bgGich+SViWeZZ1xoS3eHj3Xz+2TpYlDGTeRKrUqm3fge5JJI3W8c5ie2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793862889;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=cZkitsX+DewrI5AYsqUlHktt4nU0q8Qh/L8/eegqT0M=;
	b=tcrfz2vgy4HVQgB7S+tz4oqDyInzuimPvD/1fSOHMIv9xsmPasGTe0oICPeEFQlXh8F3
	 pdKIz8Ctkvr/6GTUqNf0QdX1MK8ehJg525z7PKh3dZmQFQcrCwCzZdLHd4U5dOjIXUH8c
	 KUH83CQ75A4cEMmpuxq5zpqiWVR5o53zW7zphR/n0f+btQSkAenPxSPDdbCCLRPHpYGnA
	 h6pxgDoU9Xvh4snAyf+rHXnB6UFjXfKrvBUQz/CF+ONO6lEMlHibJwPKth7nRmlDpHzZn
	 nDgsBZLRJ0U7tqqU4Hb2ZV/XjsjUV9nGsomc7D7HEhKgdSymvq/PymCl/I1z751LrRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VAAtYU2R;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=XumuW6oi;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BAC606A329
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 07:14:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62BAC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VAAtYU2R;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=XumuW6oi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793862887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cZkitsX+DewrI5AYsqUlHktt4nU0q8Qh/L8/eegqT0M=;
	b=VAAtYU2RgYH6pQzcks5y24LAZUYSV56hDWarr8l094ODjAnp8V1cuOURn6ywczROCOympa
	WveQ1JOJ8guwZ7ZDZMWMN0FKJCg4DOZ5Os5d85+LeIDPq9/IND3IAx3owZjauqdLiyj1m1
	bGpdYFf8bCLQ10xsqShdxjoYOqmGyMw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-Knz4HvhDOe-QFIpjuhpIpg-1; Thu, 05 Nov 2026 02:14:46 -0500
X-MC-Unique: Knz4HvhDOe-QFIpjuhpIpg-1
X-Mimecast-MFC-AGG-ID: Knz4HvhDOe-QFIpjuhpIpg_1793862885
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so10311335e9.2
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 23:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793862885; x=1794467685; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cZkitsX+DewrI5AYsqUlHktt4nU0q8Qh/L8/eegqT0M=;
        b=XumuW6oiQTXigEVxC3UHVAwrKCYL1EEn7E32m48Ko4QP2cFWCAPjnLrKEFWy1rwBuB
         ilv43E/3WOJglVkTMZ8l9v9liW8tY3OlgCmZ29DVHm03/IHV1oIW8hkl1b8HvgOpvWXh
         KFaHEgQS+si5j4Uy596RWbLGsBamCmT8NpgDPcpow6JCsAqObeoeni1PM6AaOvJ/xc+D
         kTVcKRqvjzgn0dK1GmLzCBxvkbB6/35y7Cd0SmiSHSVaIIv72nnu/acXSa8NrpciVV2E
         6Rr/CtKL5wxX06v/SeZxJ+Wsmb79j55O3RF9Lm6iJ56+6kDGPokO95FXaR2OvXPGglU9
         OBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793862885; x=1794467685;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cZkitsX+DewrI5AYsqUlHktt4nU0q8Qh/L8/eegqT0M=;
        b=f/mH4qVxJwuUwbIY8JRzjiCDQZE21kZdo7T3mG2o0T2SNVax/kT8n50Kxyv7bLT8nM
         o0lqYMiUaewEGWoJfGIx6mPpDQFGGHuBUi85WR0CMb9YhyVV/V3t6Hctf7HZRSrAMPZs
         hOUaMfxrk1x52nS0Fnx7Q/hatDoVg5/X/ILvb6kfBk+iA0bA98t8PD5A9C0sto4DQlN4
         PD4T1OQ1v2y7AwY6uHrAGvtTkG08XgHFBk80pmGjLUKfyNTQs6wT9UKrMWiTmooFRYms
         pz+xlyZvoo/S86tNz98Koot8Z2seD6QSEy9E5ekhmoon8vD/gU/YmlaOMaNL8pCgVacK
         ACWA==
X-Forwarded-Encrypted: i=1; AKwUvBxwUotEOCLLbwaA5Sx+QxJoDiDQO6aF6I0kRgGn3MiWeAVYBNBZFzStwWbi8W5cWgR5TXL59Afo@vger.kernel.org
X-Gm-Message-State: APuU4Z+pK6fiElme+Y15F8iQDD3fwsDb8Asj7o4Hy6beWLmy5DoP7J+L
	KwpRubGcjlki/crangIFf1Vt3/PmRtYRMKDH9cH1PhW5LW0ukl998z8f0DJtGGCdL3bmIpX9hSw
	kLkKwfW+dURdm4NHmZrLeZIS+FlsMNC22HzIVX2PA+b06KZcubOwMryv8GQ0=
X-Gm-Gg: AYBFou0HXcIZevedtP3B2xFc27WZdOL5NuAP5JQdEjyjCZumUHDvR5EH2Lcg3m3Wxi4
	SMsNlG5yByzzV802kPEHMJ3WcNRrRi1JXpePlLAYFE595zqhB02DZ5t6a8PMP52mj21Drd+gOQY
	dCz9f65+AtgShvCAJmZQ4IFoGCEkj5DMrwY7cryFLhuHg8fQs0oaTnBfaqKiaaWtIcAXHzEvDHz
	S7XArVIKNo1bB8TQ79fBPX8mTPSW+oXwv15exIzBK19lEBXk14PqmnHIlXwZ2/pLpenwj2zna3m
	BkzKm5jmNNiW6rT8sjQ6l83zjgg/TlJhvrT2ce6W1RjcqX2PEzt8vzJNVqcs+hgiIK1n0Uua6m9
	k8qPgHR0fWgR4lf+MbdCr/47ywTRfe/fpfFybmWKmG55KLjUvoAPoqwdEipidb9Y2n3QBO/Jxwm
	053w==
X-Received: by 2002:a05:600c:a012:b0:4a3:59c9:a747 with SMTP id 5b1f17b1804b1-4ac1793fb0fmr400160555e9.17.1793862884856;
        Wed, 04 Nov 2026 23:14:44 -0800 (PST)
X-Received: by 2002:a05:600c:a012:b0:4a3:59c9:a747 with SMTP id 5b1f17b1804b1-4ac1793fb0fmr400159945e9.17.1793862884464;
        Wed, 04 Nov 2026 23:14:44 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b572bba207sm39679165e9.10.2026.11.04.23.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 23:14:43 -0800 (PST)
Date: Thu, 5 Nov 2026 08:14:41 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	linux-kernel@vger.kernel.org,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2 01/21] sched: Reject SCHED_FLAG_KEEP_PARAMS before
 reserving deadline bandwidth
Message-ID: <auws4cpKvQnmNM4f@jlelli-thinkpadt14gen4.remote.csb>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
 <20261104211207.1392343-2-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261104211207.1392343-2-mathieu.desnoyers@efficios.com>

Hello,

On 04/11/26 16:11, Mathieu Desnoyers wrote:
> __sched_setscheduler() returns -EINVAL for a SCHED_FLAG_KEEP_PARAMS
> request that would change scheduling class, after sched_dl_overflow()
> has reserved the bandwidth of the request, and nothing gives it back.
> Switching a SCHED_OTHER task to SCHED_DEADLINE that way fails and leaks
> the runtime that sched_setattr() filled in from the task's slice, up to
> 100ms with a custom one, into the root domain's total_bw. Repeated, it
> makes the root domain refuse every deadline task, and refuse to offline
> its last CPU.
> 
> Reserve the bandwidth after that check, last of the checks. A refused
> request also leaves sched_reset_on_fork as it was again.
> 
> Fixes: 8a70415351ba ("sched: Reject SCHED_FLAG_KEEP_PARAMS when it would change scheduling class")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

Makes sense to me.

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

