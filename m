Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585458;
	b=fxNSwxW3UgJgiCaOWi5MUaHMGW75O1OFyhBIi8fXFKBgUTq2gFIeTRH44Jbf0b/v7jMV
	 3PNQrxBIcdhkgirhK1m2RcM/a8lXS6KL0Lrqlaqh65R81E86YKBeDgXiYFCtcfL3815II
	 ldVxVPv6gwlgCeEjirXoPRVd/HATK2sO6SHEk4sFFun2jk6fW6j0lh208XSetiZ7FYAQ8
	 qmKHaUQmAlBBh5NqXleYqG9jQweML7n6ZfLY6MCBWu9flyp3tmWuTusQiU9D+eDF0Rvfw
	 nbpMqnDvfe2N270/QIEg1dCc5CW96FQJ0wQrcSZ4Ek74Wqddg6+i2Ot3N3yBoloHBIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585458;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OLPlzBmIGcwx65jSMq2uJ6Gd3E4PNgtasDmsnHDmw6c=;
	b=nQRfUAgO+2Xzmszkm9+eQsTX17m/Euuh6Qm1tFq+g5zwfFVf3gMmCImrKEOsln8Slslw
	 R4xiJWEP2mMk4fpBz+5UHcjW/96k9WvtiW6xQuFU7j31VJ2qQH9k9LMoQVfDDnaycSdAy
	 dKQGtwSJbOE6Xvl2NsxHWcbSVoG5jhJZ6GsW3B5rs091WwU9WmJTnsMoDdkbYV+IsoLr5
	 tLJQWShCrAoWZK2RvK6e2VbJDb1/JpZhlfLFXSuO/3C8g43kph7F3coG+ZV7hu/AKN+B/
	 Q3lpI78iTSMGyU3I19RrGtvspBhffHbaTN281/KZSwJGQaTKVFK4vyO6H220cXkitvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cUgkH5lQ;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=P8JhzZpU;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B62160A6F52
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 15:57:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B62160A6F52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cUgkH5lQ;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=P8JhzZpU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794585457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OLPlzBmIGcwx65jSMq2uJ6Gd3E4PNgtasDmsnHDmw6c=;
	b=cUgkH5lQd0TfeL5EclaMb97wObG4AfqU5bVDReD6iqAsh6aZZQRhtwMtAFYextD8T0on4N
	fuNzKvGuz6OnTjGqiSq2cfmYXh0CswhsH76ziTJQS3eMGcfFiCEt30XskN8ujQ7i12FUeb
	dw1/xulrX+abOvxreNTF2Vwwroj03PA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-lPx-4eSYMCmVsyuVbrc-ug-1; Fri, 13 Nov 2026 10:57:35 -0500
X-MC-Unique: lPx-4eSYMCmVsyuVbrc-ug-1
X-Mimecast-MFC-AGG-ID: lPx-4eSYMCmVsyuVbrc-ug_1794585454
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-49205554e17so624208f8f.1
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 07:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794585454; x=1795190254; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OLPlzBmIGcwx65jSMq2uJ6Gd3E4PNgtasDmsnHDmw6c=;
        b=P8JhzZpUkTOzDQ4ODmJlWq9olowdwxwlVSFdM2DvBI7aQR1Zr8KlAvqaIMvyd+HWCX
         i10udXX9k4NWB2b1UBy7Fvrt10klAqOdnCzfewpIiSgfr1CtyNIls3XtDRuBQQVJhoEx
         g1pxYycHTW5g4vcSIBLJ86WFsSGbdObQac8ruq36xUk95BQcHD3fJphvmxBbwFlYc1hM
         OzW5tw3X+60fDaSxTrhMfkfzA22jds8fZasaQLQ8hqbQVE2j2FwZOA64XXLe2TgJgDkx
         Esnb9MA7D1+gdAeIyM7fqcSr+CwZs57C21Jjd6Y2vTORU7PsZsYNcCcba0AizVXRJrkN
         PR5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585454; x=1795190254;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OLPlzBmIGcwx65jSMq2uJ6Gd3E4PNgtasDmsnHDmw6c=;
        b=B+bKDiop8CMqFnZFySiwpejXRpFEPwuqK9uPs2CS+0o5zL+pr1Eifg4XQUPa+KRhWW
         WQ1Ahu+VC8p/bk57wiLO33LTIb1iWmEUfYfBl9YfxsDY7SaH8ORl9LXHIgCk53PqSMkE
         l5hMqMhem7Huz25qSCsnCaT++EQoJ3zWE/Jg4BDlyKN721wXK960FOV74GfonBsf4f3r
         K2NRoXSgdvHEwk/2XdKvYTPzndL6iuXNRcvljsIuXswDdV1oG3IvRpMl4vAzqJxMhSLH
         nenUMqIT+85EMUG72n+2SU4QH4oGW7BvRJNXnuW2gcRso6FV/Wexn+R+vSd9NRe/63nq
         Sy1Q==
X-Forwarded-Encrypted: i=1; AL+hErENamHTpnDmQEUkMunnq63A1GHmuEapgo1eHTU8P3p05gv5mryG48nZgYPXJ5AyeBPU9GRYb2gK@vger.kernel.org
X-Gm-Message-State: APuU4Z9QzArks02KUyyfKD7hKOj+lHzAkeSIprozEW4Ae1zYcK3Fn0y/
	qolt+FH4h545WOO22cHDnqw6sglXwhsDk9UTS5m6prrjZuwN0aqZ8dy5vSeB5FMgett1Buduexc
	0p4g16XWjmD++XZWzFDPxEVGwycW36Ki5vvjD/b9MDe2q8G/ITLiIyfzMOjQ=
X-Gm-Gg: AYBFou2xEE8g505WndawWztcq0zdbRw7y7scRA1ROzVDDuXcNUAj2VLH1hDD2ttbTtB
	9f+i4geqeRUJxXrLYfIs/4qThr+QkReiYdfCf96IKgzHlarE5xURAbh01nLw+6nD0uTAoNarHLG
	jdITFgyvqPtToGlaS9b6/R04mEURSNHymSq4VMPzG741QfAyvoaq4ZqvUoJcLXbAsreUMvr8Etg
	cVl+sI2ZnrSOkZKg/KyZN2ww7DD11axGsjWap/5aOA/GWTnjZkPm3RkP1j79n5CP238xNL+9Nxv
	QNx947sxg6XelIm2uRruGdQOVyAY/nLEEdnldxkJTs9YUFcpdhwYKjGuoJO8dThis0Cj5r9WfsN
	aKSVGBbjEvdRLPORYd+Mtus3N1oCkNcJGQvdjm7j+smT1LePM2i/mmkcMJwtvk7OSOVNqxKkEym
	ibkC4=
X-Received: by 2002:a05:6000:2613:b0:48e:3085:7cf0 with SMTP id ffacd0b85a97d-49c7467b551mr5465775f8f.51.1794585454097;
        Fri, 13 Nov 2026 07:57:34 -0800 (PST)
X-Received: by 2002:a05:6000:2613:b0:48e:3085:7cf0 with SMTP id ffacd0b85a97d-49c7467b551mr5465726f8f.51.1794585453647;
        Fri, 13 Nov 2026 07:57:33 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60116323sm5776550f8f.32.2026.11.13.07.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:57:32 -0800 (PST)
Date: Fri, 13 Nov 2026 16:57:29 +0100
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
Subject: Re: [PATCH v5 20/29] cgroup/cpuset: Give back the bandwidth an
 attach did not move
Message-ID: <avczaaXEh_xUhxpa@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-21-mathieu.desnoyers@efficios.com>
 <avWEta7b9X4K6hF7@jlelli-thinkpadt14gen4.remote.csb>
 <e21aaf40-b929-444c-b707-3200e21d7301@efficios.com>
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
In-Reply-To: <e21aaf40-b929-444c-b707-3200e21d7301@efficios.com>

On 13/11/26 08:12, Mathieu Desnoyers wrote:

...

> Three new patches keep a deadline task in the root domain that counts
> its bandwidth:
> - Where a CPU is picked for the task, a CPU of that root domain is
>   tried first. This covers a CPU offline, a mask change, a wakeup and
>   a rebuild.
> - A CPU offline fails with EBUSY if it takes the last CPU the task has
>   in that root domain.
> - A write to cpuset.cpus fails with EBUSY if it leaves the task no CPU
>   in that root domain. cpuset makes a partition root that would do the
>   same invalid.

Makes sense to me.

> The bandwidth of a task then goes to another root domain only by a
> cpuset attach, which asks for room.
> 
> With admission control off, nothing is refused, and patch 23 still
> moves the bandwidth. So an administrator gets past a refusal by writing
> -1 to sched_rt_runtime_us. The two refusals are new behaviour for
> user-space. I would like your opinion on them, and on whether that knob
> is enough or a dedicated one is wanted.

I believe we already have (maybe broken in-kernel) EBUSY on trying to
hotplug last cpu with bw standing?

About a potential dedicate knob, Sebastian is proposing it as well [1],
so maybe it's time we move to that. Need to sync with him I guess. :)

Thanks,
Juri

1 - https://lore.kernel.org/lkml/20261113-sched_dl-v3-5-a76ffa1cdeee@linutronix.de/

