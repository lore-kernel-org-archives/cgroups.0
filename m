Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795012351;
	b=cZQxfHfIyPH4YPPRSfAqorJ4+8ILphVJj0332HJAdyFDW89mTwBj3ainrIsmTau5Mai2
	 ATvHRxmuW8mB35JzWfn0YC9CfdEmuhvAntRZK9lTPNHgD71JvSaIR/JusC7kyIoz1aIOv
	 N54SdAfwn6lEY1Vb1oa/v8+7nPIanb+FxNXx+TxJex2hjOeJV1IYzCO1ju7TpH13Jm12z
	 C/FyuawQnlh+t+I/POuCDNxZCSZdaS550SDprQEGhk67Z4WVRMg2DBlSdt53j8C047XY/
	 FAF8uqh9K5DRMjS+ArXIpRRZ8plyXYQ4FiK+Tw1wBnJe19HV2gLLNykX1yP3qPmcHGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795012351;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IYa7d2S4FNA7B3qml35ZrjkyJZWT7YLdzwOJhQFTPJw=;
	b=TZR5xSGMGR6a4XfMDGyexT4Y526m372ZsThdq0r+n9yjlAU17Y9Zb66ahA7hJ+nr5tQ4
	 SDq4+Eq1CI90DH0viKI6kZvJ2ZYu+i5A+LD5TN/TJN/N/l36Jgp5oUu3f3g25SBnvS5PP
	 gVU5V+ThJHCBwLrzGnRZq1c2L+MqLEj5YsGdGR+a060tCCCIh0BwkW1BcK1HmWtuZkqLC
	 2CP3iMQ1GneGE9qtJ/HOLyUqPeQnq+kJdF9GmjLeQWUv31fMpfxNrJsWQT2vlmvY7A4j9
	 0ieYtfXZWIVkTP/1KlsIsOAOJteka/ICkYbdErHAE2zfWrshYsabgrPugsWyUt/8R8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VaD+Xsu3;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=jhchfRR+;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B44A606A32F
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 14:32:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B44A606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VaD+Xsu3;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=jhchfRR+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795012350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IYa7d2S4FNA7B3qml35ZrjkyJZWT7YLdzwOJhQFTPJw=;
	b=VaD+Xsu34vU64AKsQ/3FGGJHuzhiLtHQnsCNzlppRoorGh002QJMjXaBegLUGUzUg342Rn
	7KbJ1wjiA/xJYjp9bHq0MqJVJE03JkHdQSHgXQGR1E71KypjsuAwJpoxDG3ik86HAreqp+
	tfbGFOYrFM8UrxhgmYKz9aDlCmcul8M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-mkeRXTrSPOKCqV_fBdd9oA-1; Wed, 18 Nov 2026 14:32:28 +0000
X-MC-Unique: mkeRXTrSPOKCqV_fBdd9oA-1
X-Mimecast-MFC-AGG-ID: mkeRXTrSPOKCqV_fBdd9oA_1795012347
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4bb68a5e792so4932525e9.0
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 06:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795012347; x=1795617147; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IYa7d2S4FNA7B3qml35ZrjkyJZWT7YLdzwOJhQFTPJw=;
        b=jhchfRR+9STjT4RdQylP7KrJi5iKHkLKKg+LqCVbi+6LvYc/vlbXKwv+BbYq9IyMB5
         5IuuHmdsLkM2rw2y6UhKtLVj1wJeVgZIliUYnnFwyBooZl3lPlPjle9k6c9PjiB350TR
         ZdRR0OcSgvgiZaML0rzx4h8rU2XLsXvGAbf5Cm8NLa5+SdGfDzvkgg3NiYc/r8MBs1bt
         Y3knU0pXRvWk37uIGmeS3wbA/XMgLSH1UBvdcZsRGN5EhvpLsA4ZZEQcoZXnNl4n2zQQ
         /rWcyjyE018M2KmjNVvvymzL+Nls+cOtEIEDk09i8PkO6LBq6ANB/M00NGOAjbvSleoI
         iXJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795012347; x=1795617147;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IYa7d2S4FNA7B3qml35ZrjkyJZWT7YLdzwOJhQFTPJw=;
        b=p7w3A1notg16v3AB5AXbsBzRJLz6MuOqd2TaF73yURBEdotNEGcGI1XqBYrG0HWn5B
         I+px38G9PWNA9toyWNFW49Hf6WorjWeB3MNvPqRh8J1LHOgesxUyU7omM83XmUUn9u7Z
         JZIB/qdhc6yPyvxg4jd+2Zjp+cWWQbJ4scTpwUgadUHDfwkPQmj2gd9XjUcObxG5++JN
         VJlyIcIEN1WkprkMUaiCUgvcnMMPce0BpLPlw1i9S3VNkVRiOAkiZp00qCS+I22Mu+sv
         i/PWNSY9rby6QQnOoEro/tq+NNcApI4dkPnMt8XGr5rKybJYeDiuzMpa5JB/h6SQL1+3
         Lhxw==
X-Forwarded-Encrypted: i=1; AL+hErF8g8K3Rqoihf8K5KuQHLF95j5G8+HbR4XQlhW4pM3BuvaqJTGfnnZg35cfq3mtdztMa16vaNE4@vger.kernel.org
X-Gm-Message-State: APuU4Z+snua0bTMaXFZGlk2hpHWFzZcbju8E48FG4xakrsScKlvdwfcO
	1sDLevi/A2NCCLlPmT/5h8bvSo+W2zkO8AfDXl7U1kpUheGeFNzLF0Mlc6qUszMa01GoAVlffE8
	HPynlljcdMWSKAgGCCEtbOmYu45tTJaH5vn7Tubnnosa1NEzWInvShUmua+g=
X-Gm-Gg: AYBFou2GADEuRkJwwUQSs3rk2ZADtgb16K/79AT1TgrnMfIo6ewrF74BwYG3PTwAxQF
	r+Uy/tvk/31q11R0CiWlrLssnpZpggFc6xrUCosWaphMOEeGUsvWe/ZdqzD5rKl3ZTIyMMOh/Px
	auZ0bjEEirynqfrzARwsBZrMfetYPX922yk02PLR6ZlpTgukvdSC/axRrrMOu9isyuHuhVbTGBX
	wxr4Ml7jk4qr3EfAt7Qok7VYrjJG6CJ1hD7hU4UpNoYYpL2cAfy9o51sk7sx1F5PnQ9z5pDoTx6
	ecLkHbSd+5SbWhkbW+PVr9hKb00qNCxjZiRV2qWHwnu+EcP8ZPnPeaa/YCNMp9LScS5glHqQ3vF
	pxc7WL1qAntCa0McyscQS9vYZ22q91aziN5SMm/QdWR2vRRj/y1BPwWiPVzWKlslYVeiWxRMN+i
	SbIiM=
X-Received: by 2002:a05:600c:6290:b0:4bb:6a78:7c42 with SMTP id 5b1f17b1804b1-4bb7d6cd48cmr55544705e9.1.1795012346805;
        Wed, 18 Nov 2026 06:32:26 -0800 (PST)
X-Received: by 2002:a05:600c:6290:b0:4bb:6a78:7c42 with SMTP id 5b1f17b1804b1-4bb7d6cd48cmr55544025e9.1.1795012346150;
        Wed, 18 Nov 2026 06:32:26 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d2aad96sm58360485e9.6.2026.11.18.06.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 06:32:25 -0800 (PST)
Date: Wed, 18 Nov 2026 15:32:23 +0100
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
Subject: Re: [PATCH v7 08/40] sched/deadline: Do not replenish a boost from
 cleared parameters
Message-ID: <av2295tJMdwRp3wK@jlelli-thinkpadt14gen4.remote.csb>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
 <cefacab5f1c0e7617f17e050af4ef5f6db01700a.1794922146.git.mathieu.desnoyers@efficios.com>
 <av2k8JlLvUcBBOhn@jlelli-thinkpadt14gen4.remote.csb>
 <ddd215ff-d6de-4dea-b12a-80948a9b5ea6@efficios.com>
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
In-Reply-To: <ddd215ff-d6de-4dea-b12a-80948a9b5ea6@efficios.com>

On 18/11/26 08:44, Mathieu Desnoyers wrote:
> On 18/11/26 14:15, Juri Lelli wrote:
> > The above paragraph is a bit hard to decipher. :)
> >
> > Maybe something like the below?
> 
> Yes, thanks. The next version takes your text as is.
> 
> > Also for other changelogs, I am not sure this kind of info adds much, as
> > I fear it will be hard to track down in history anyway.
> 
> Agreed. The next version drops the sentences that name the review that
> found a bug, in all the changelogs. The credits to people stay.

Hummm, now that you say it, crediting Sashiko for findings might be
worthwhile (for usefulness statistics etc), though.

