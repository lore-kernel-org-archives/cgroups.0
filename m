Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795518273;
	b=rfjKDkdHr9luObM0aZ0WFUcDNYTlTo6NCw07VNdCUs1mM1HzazO/P2i962LVpi9Kx18M
	 NeBmFd2gy+HpgaitZHWuS+xbB3FWbTv43qfDTNxZCcsaIZoW5+7m9QOrcJhen/Ssj2Pcm
	 BN3DYDaKl7eKLhARokcAeZC7qUdI4XJJcInw90N8s+U5LPOIrWNXibbUeXvh2UB2H1eoX
	 fX1F4E1xkqMIhYQn7e1/IWL069YzXedU/e7+KPFy15zRaoOByq0RcFcW1lPz9nR9mFbvQ
	 928HXZ5WOzJFT5TxiVYtCpe9rKUYMy6nTyIAdfqfdD/Y2+0+Lr2zzXb+siEJycLSwzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795518273;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TTlOMlop88MYRf1Y2eOatTSKCEHNu2LBs6PIdGIA3ts=;
	b=r6G5f+7PQtyglRwJgkOL40/emooTiVVYzvvJFCgmTaV/ojqaGBM6bVgZcsY4tx/QlkzN
	 7e/1v8Ju45zAKM42nTacn6kYda8kFBI3shkHvpOn9FQ//Q4xy5lbhJS9XscuCB+htD0Zx
	 bfeUrGwq4lU2CKrf7imyygU6/rzD0GTUmBb+IX+Iu4/4Mr9YYOKXXwFPP+14vYEeU3jfl
	 JHL3UR53LurnYg5Vccr67HZhYQpwhQKBmqu6/qjGsckZ9byLhMHNpSPibLXMmgfMqu8ul
	 zlxbseY3dm+e/vh09cN2qeLKSvYg42IT4tEhEHkHIoG2+nWnugB3hapDbXZ+MAkQBOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Gx0jwKic;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=cI8cddPG;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CFA606A322
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 11:04:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47CFA606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Gx0jwKic;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=cI8cddPG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795518272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TTlOMlop88MYRf1Y2eOatTSKCEHNu2LBs6PIdGIA3ts=;
	b=Gx0jwKicO6PYN0KjC0d1hd5uBlP1rWdYMXJMVgWllSqFONNKSmOaPMhq4XAJ8o/lVwllkb
	K3iiKZ+DB1KLOpGclifctS0oNLhHl4Rg0FACq9N7FMNFyI1W0QSgwFLdP0pD64d/jYHsB8
	CYitJQprsGT+V5d9qDPt//h4zwf2AnE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-kS_jPORRONOBlJuJhyq8-A-1; Tue, 24 Nov 2026 11:04:30 +0000
X-MC-Unique: kS_jPORRONOBlJuJhyq8-A-1
X-Mimecast-MFC-AGG-ID: kS_jPORRONOBlJuJhyq8-A_1795518269
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4a7c864000eso2527443f8f.0
        for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 03:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795518269; x=1796123069; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TTlOMlop88MYRf1Y2eOatTSKCEHNu2LBs6PIdGIA3ts=;
        b=cI8cddPGERKUW1Hg1Xcj05XFux6gB6hsbwlfhHILhMVjH9xrBGWddA61SymLnf3vvk
         C0tuSKGgbr2dUZIk9Wdpm3CGFt0IFCzHLVS7tkSm8XJz094j24tIY0OEM8H16oIibybs
         L6S6/HrZ7T+MuXhJ4d1Enx5nvErwS5A+8ZqQVnHiIz0urEhlteHDoVWhk52WZq4mHYdV
         GTiRFrZmM13sdHQTtcXes5r11rSIVhpxzxG9bY9jXmNft1UFUV2A6zR6lcQaOW1thk1t
         LLtRL0UMZ/LMPh7F9fE4E3Ou7b8MdKOT/vQ38s4yYnTSNJ8QUmZHPkzC56kf1ber0Vqn
         EP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795518269; x=1796123069;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TTlOMlop88MYRf1Y2eOatTSKCEHNu2LBs6PIdGIA3ts=;
        b=OrCm/JwJn0C2WSOeXKlMFR9OEUQ5PxwsPsL5hKyRgYdENNz+pWWqBMg38ktW3vS0/5
         NGY1xPzI74I9h3eO8YkCsmaHs0JGkN58oNxuWyhlD/sUsnj1nDLnpqOMZcShRHh4IQnt
         QTzdxhe8H7BNua4uyNGJE2oRBYX5jjWl5n8p85al0xdVfMaIu3dubr11buZRr9TUGp1/
         4CmKkgymM8pfxDaXrzU1TG+yJ5YTgf0FLFaOLJHCYRm1M6t47hFS299VwGral4gnF8ZK
         48LLHeMkvvmrBT5VfKmb83yAsEmWpdyJRFS765qZf/74deZDxN155i0QKh7wrcKysUJN
         2/YA==
X-Forwarded-Encrypted: i=1; AL+hErGMxspuyRKCgKqjxrlEFVNyS12XEe54SLa7LnXgnnTezgmC6mGb1TcaCfqh5gmPBbVWqtrvf5pb@vger.kernel.org
X-Gm-Message-State: APuU4Z/88HhbZfBF0QbBwo6sp4ozp7tKgHBGBbMPUulZmCGkn6Zq71/T
	rILbzt3YkHnkeDfEoxDFiDApSjsKVZHaBTBOmlxMrkyjYPwsHsqjIyuNU3f9CZGA0FK2fS8qw/A
	n+xoH3pi3uAvnak70kyDG2fhPgJyDnWy3KPZ78uHO5Ywm0fvtR0lE/Mj5fhg=
X-Gm-Gg: AZFdTZdHyQ6VDN9A+78Q+OlfrG+oDTmqvyanqnBprH8SCG8E3ZOAo6fsgIKaxtSd4Rc
	f3bUvFtcj1peXdk9q0khO6Q7o3ZsK10b/u0g73qFjzf42RwbyI/r2Tg6LWHxJZmtyc9I2zsZwCf
	xN3ITK/m75oSePanG3LjftEwinH0ZtVvN2+SY0ih/2h6bkoiixCkaoPCqnWskJB9ANQEHeZwkIv
	NinaEQFmsZcecZqMkWHXkHyZuzi9giwHKaTiczK8/y+84vQLJbhusnT5fB8UFbS4vmxet0rKin/
	jGpug7Ahw94+kOlq7ULku4vddlTFDZ641FHVtS+FN755ZOnJmuWPVEtO2JilC4zROCxEVFbuDPg
	aVRXeftH0+bi1Ro+UQIL/vXvbrEp5HV+7jwZoKGsHvfpV5PDIUkhRM+lTkWtjztdHbmrtFMjjx3
	NDuZI=
X-Received: by 2002:a05:6000:184d:b0:48c:7386:af18 with SMTP id ffacd0b85a97d-4abacfea55cmr29663624f8f.8.1795518268980;
        Tue, 24 Nov 2026 03:04:28 -0800 (PST)
X-Received: by 2002:a05:6000:184d:b0:48c:7386:af18 with SMTP id ffacd0b85a97d-4abacfea55cmr29663561f8f.8.1795518268563;
        Tue, 24 Nov 2026 03:04:28 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b34e9c3ffesm10976795f8f.19.2026.11.24.03.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 03:04:27 -0800 (PST)
Date: Tue, 24 Nov 2026 12:04:24 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rcu@vger.kernel.org, linux-doc@vger.kernel.org,
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
	"Paul E. McKenney" <paulmck@kernel.org>,
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
	Qais Yousef <qyousef@layalina.io>,
	John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v4 2/6] sched: Move DL's admission control to sysfs
Message-ID: <awVvOGe-RwmLCqDv@jlelli-thinkpadt14gen4.remote.csb>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-2-d523e4d960d3@linutronix.de>
 <awU9KmFsbiyvbcOr@jlelli-thinkpadt14gen4.remote.csb>
 <20261124075332.nZysJRfS@linutronix.de>
 <awVfotZsGc8S_aB0@jlelli-thinkpadt14gen4.remote.csb>
 <20261124103507.4u5Sz_bU@linutronix.de>
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
In-Reply-To: <20261124103507.4u5Sz_bU@linutronix.de>

On 24/11/26 11:35, Sebastian Andrzej Siewior wrote:
> On 2026-11-24 10:57:54 [+0100], Juri Lelli wrote:

...

> > > I assumed you use the proc interface because you don't know better. The
> > > warning makes you aware that the throttling knobs and DL knobs moved to
> > > sysfs. The DL bits are mirror to the sysfs interface in case you ignore
> > > the warning and keep using proc.
> > > If you move to using sysfs then everything is fine. From here, going
> > > back to proc looks odd.
> > 
> > Odd indeed, but I wondered if it might happen that a sysadmin configures
> > things properly using the new interface and some time later, say, an old
> > application that hasn't switched yet to the new interface resets/tweaks
> > using the old interface?
> 
> Therefore I wanted to remove the old interface. The legitime users would
> want to change the default DL attributes. I am more afraid of those that
> intend to disable RT throttling and are failing to do so.

Agreed, that's the group to worry about, but they never touch sysfs, so
an error after sysfs was used wouldn't reach them; the warning and the
docs do.

> We could also make the proc interface return -EINVAL on read/ write once
> the sysfs was used. What about it?

Hummm, I'm not convinced. Whether old tools work would then depend on whether
somebody wrote to sysfs since boot, which isn't visible anywhere: LTP's
proc_sched_rt01 would fail again, just only sometimes?

Earlier you actually offered:

> I could look into making the sysfs values appear in proc, too.

This might be simpler. For !RT_GROUP_SCHED, procfs could become a view
of the sysfs_dl_* state, with no second copy. sysctl_sched_rt_* would
only be needed for RT_GROUP_SCHED (which is marked BROKEN anyway, and
what we end up with depends on the HCBS discussion).

