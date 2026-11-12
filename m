Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794495678;
	b=y70HcVxaOCQheKXZUEi6wRxUqaL22Or0eZrO0OddKtOokIL+r8EjKnjbesWcZ75hZ0A6
	 yR5VO4Z7VhS9QSO70QA3qRuLrI3upgUnLrrJj+rOMBPl4H20gFnxBGUEDR882tenfH1dU
	 s7S6DVWUd53TJvL4ONrbPeHJnC/itnIfwVegmPls21rfo6Csa1fpdgDC//fhA5V5qUENR
	 JJWySbOZ7sgcFlDfqZ4JlRMb+B/9Jw6Ag7+MKLO1Sf2FsLHsyPhvRJqNBkSDaMTVoiDOs
	 gAAT9B1AZ15dvaFxs8C6fH/vOXWF29HXxPieP8B0PqAvTAQraBxlmK/S79tpIMJlr1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794495678;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=M/6u10agl+rdRWY13WawdsYLlQi9SJfLtYTamWTVA+8=;
	b=BtcFiNTsM2TN4ihm0a+UjLGhX8Ra+eT77OEhbsyYaICExFgW3qnPqwLzbBBWZ+tlXIx0
	 aaPVZ05/8pcX6IYb9DYfMIKV3qz5KjX4qEbq1Hhm1ir6vRjSddk0RnSAMl/F2iaFwp8Sx
	 iRj5wW8S/J+VQYi4q+f9MUhoSRuPaBUMObimL+6z5KrowrFcDgBNIvWCDlLXCzJV6A3uo
	 ze0RIUooqaTwooFc9QdKKIrZ/aTVqYJ2vqmuae0OzX3F1yhMtaS2gEzXvYlx8hj2W5K9h
	 umtpH4Vc7sFy37lNDA9HT4Q0abXV+p85RbyMNabPXL6yQsHOiUvdBEFXWeDqHAE3S+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KTCH6UYL;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=RTr+R4Yb;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4B3606A327
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 15:01:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA4B3606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KTCH6UYL;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=RTr+R4Yb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794495677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M/6u10agl+rdRWY13WawdsYLlQi9SJfLtYTamWTVA+8=;
	b=KTCH6UYL3ikuyNlL9CF8WDrfFc7GiWisbsTNpxsRRj8RrclayEO+KvpeU2IvvWfQeq49jC
	pYHvD+iQ6Ur0vMlqXmSdQ5zsvDJt3f8wF2VgTE0HAViB1/5tE7Pi9p/ZP2GZY0ej6RhEOo
	K8i2TQ8+9Qh8AD+hxnsi6NHIdo72fk4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-R0seed47MDmmpvzBmGlICA-1; Thu, 12 Nov 2026 10:01:12 -0500
X-MC-Unique: R0seed47MDmmpvzBmGlICA-1
X-Mimecast-MFC-AGG-ID: R0seed47MDmmpvzBmGlICA_1794495671
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a1fdde384cso30033055e9.3
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 07:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794495671; x=1795100471; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M/6u10agl+rdRWY13WawdsYLlQi9SJfLtYTamWTVA+8=;
        b=RTr+R4YbUtPb0bJdv9nKHbt5s927vcuRHj8Qc+OgK1pDd+OkXz/XRTdRh+Lp+nae6T
         l8lJ53T4GUVn9XOVe0bCKpyjw3CnwmmmXHp08IWNvpnkN1WmIOQnOrXGswdpYoBnfqCQ
         y9gE7rnEsVVfnKIv64XUWDMmG6izvPpfn4bFNPpiC+7qjOELvlLNSzLS3gpb9Lq/um6S
         O9f8JkDe7Wxx0Wh+ahSYpy3z8bupNQZI4JCTSBKci4+I5ulr0MP7RAQiXvnYM2O3UolY
         85zasF1WCLyu6xoC8IR+3v+DI32L7sVan4s8dZ2r1WSI33icXbBNVYFWTfbbmw6GYvmh
         pkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794495671; x=1795100471;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M/6u10agl+rdRWY13WawdsYLlQi9SJfLtYTamWTVA+8=;
        b=TgXykQeNGRLYZ0mgxl8YNs1QlU5FR92oyGHmzKZTBTofFpSJjCW2U4GT6onB3OIF5x
         8Hn+VCqltHYuwNjn2LK7M++zSlUyVLPOJgkzAJCDmMpO9/t6rFDKrEevFS1gcXRejrN3
         PQBj044C/BFElRSppkbRT+62L3/KfHNZPnN7981/83ZwFAKqcnTFZmiNu4+Aa4nIEm6r
         Yeyh1azuaiAtoHmOf0DSfA60BHvoKkax6Sxo8es05w1qEOU5VWAaae0h7GC0oPAopy7O
         zHzLuMQT5247P13qsYSt4UAjeAefdLXvA2i+RavXQ2D29AXg97Cyf3UuyjwLeVdCT7I5
         aBmQ==
X-Forwarded-Encrypted: i=1; AL+hErFs1Ccqg8MnsR6uZaVOgrqXdo8XtsMInA2sGiKT07yD0OdBhQHkEu1o8u6qKtVWG8EzNHylJAiw@vger.kernel.org
X-Gm-Message-State: APuU4Z+sQcwZ6x1hG40asQIVBXwpQeexrF99f5BGbeShS3OJHMlrMO+8
	+9x0RDAPvUV27HnOFHh37J2zTvSh1qg1hVK1a0Izso01zNBJHAPdPfU9LwhwqlCfjAKQ+vcOa22
	14/j0xkGyNDEl1hXCGjJnh9lfZYIPbnt35bt4yGWOk8mBH/Ou8YAGrykYABo=
X-Gm-Gg: AYBFou1s/KrOupiNViikYsh6XSH+EmXgZjM7CicQA3ecoAeUFadWR9bx0FzJHV3RIFZ
	LLDn8EAOzIN86Ca6huIQkTPgGcuagr105Pz6rRg5K+7u2plvBD6+dV9/UQjhsPq3oAFm6F18N1M
	OfVdxQUJ1Bgo8wmdt8uPin/2ZHhSpdDYchJIfHvjkxq6sdx4Tj755xYJn5YwwjKyMU/IBuZxNw/
	cPy2c9wKx31udSJSpFkUCpLMUqRU1qZ6vurRkDQvoSVCRMS1gaqjnk4KOBAT+cgX7Xn1G9+nTjO
	fU6zOo+gPW5PA9op/2X13WtG4SM3gRZW72xpUwyGk4zw+Pj9Cf2dZ2UNpSFc5ZPayM3VBCV2gZZ
	5jwcYDAAdGHN4RxNQWcSidKrpeRtNESiqjgTXvyPGn2EDEck9p4QN4ELfXgcGeF9jif5TvTkplN
	MFOAw=
X-Received: by 2002:a05:600c:6819:b0:4a2:167a:c946 with SMTP id 5b1f17b1804b1-4ba0935f880mr100717885e9.13.1794495670976;
        Thu, 12 Nov 2026 07:01:10 -0800 (PST)
X-Received: by 2002:a05:600c:6819:b0:4a2:167a:c946 with SMTP id 5b1f17b1804b1-4ba0935f880mr100717275e9.13.1794495670509;
        Thu, 12 Nov 2026 07:01:10 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba08ddd467sm110908625e9.0.2026.11.12.07.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 07:01:09 -0800 (PST)
Date: Thu, 12 Nov 2026 16:01:06 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rcu@vger.kernel.org, linux-doc@vger.kernel.org,
	John Ogness <john.ogness@linutronix.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Qais Yousef <qyousef@layalina.io>
Subject: Re: [PATCH v2 0/7] sched: RT throttling cleanup and a bit of
 documentation
Message-ID: <avXUstjABxdTZaxM@jlelli-thinkpadt14gen4.remote.csb>
References: <20261110-sched_dl-v2-0-cc9399f7aeb1@linutronix.de>
 <c2bf89ce-b9de-43cf-839b-395d28b2275c@paulmck-laptop>
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
In-Reply-To: <c2bf89ce-b9de-43cf-839b-395d28b2275c@paulmck-laptop>

Hello,

On 10/11/26 11:56, Paul E. McKenney wrote:
> On Tue, Nov 10, 2026 at 06:34:42PM +0100, Sebastian Andrzej Siewior wrote:
> > People used to disable the RT throttling mechanism by writing -1 to
> > /proc/sys/kernel/sched_rt_runtime_us. Since v6.12 they can still do this
> > but they don't disable RT throttling anymore. Instead this throttling
> > mechanism has been taken over by the fair_server which can be configured
> > via debugfs.
> > This is not really documented by a hint appeared a few cycles later in
> > Documentation/scheduler/sched-rt-group.rst. This can be found once you
> > know what you are looking for because this document describes the RT
> > group scheduling (CONFIG_RT_GROUP_SCHED). The fair_server is used even
> > without it.
> > The then there is global DL resource control which also shares this
> > file proc file (which is stuck if CONFIG_RT_GROUP_SCHED is enabled).
> 
> Nice, thank you!
> 
> Unfortunately but unsurprisingly, this gets the same divide-by-zero
> issue reported (belatedly) on the earlier series:
> 
> https://lore.kernel.org/all/e58e48c3-ac62-40cd-b5d3-2de87db12496@paulmck-laptop/
> 

I wonder if this fixes is

https://lore.kernel.org/lkml/20261108185406.1549770-6-mathieu.desnoyers@efficios.com/

Thanks,
Juri

