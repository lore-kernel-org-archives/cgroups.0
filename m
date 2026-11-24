Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795514377;
	b=X84vyQQ5I8lealRHAomIj+uHWXuxOPWcRcIYq3gHJt1+cTsStMBP8Kp+DHzn49mDCZQi
	 9icweDCKIei64Tl6tIT763m/4mlzvm8AZqYTxjGS1eq571JzTf0219Jq3ZpOKq7GG8ifv
	 kchglfqFggzFRL+kaCz7Eukld83yQ2FWCGpdptBckwdFy3La86zcsIaPg6M4VvWgu08lw
	 XpNsAldljnwhqSkygWKYlar6610c3NXHT7oU4JR5R6B4bjfSo83y+bUH2EP43+thzWX2c
	 mpiSX6gJe2m2KJd1w8f5xgEnZRNotvM4eOs58L9+o1yT8Kt6J8PS0FrOeT/WrcXJcqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795514377;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=FYuz/K8ZJHw8V19OxffQhxGLJQWBYYcYpwJUkZTtfL8=;
	b=M4OKCD2iOwdr9d2uy+s2By3IYPwEXqdpy4N3e1ctOzmQKmPVvnh7MIp6ZO4xKEHiIuNk
	 ieFPt1HIpFfd5ZelzVQoxFiDzyNkSYnDB5Ncxnb5s5kNy75gNOsd4Ol6q9OkFf0H+Solx
	 Hl2N12drUCZ1+wIATBo+SZhU7mqhzq9594qVTudzO6zTpPzylFdg0rD3VvsyV1PqeOpjH
	 A/Q8B0Maa1Wl0Qs/odLzdUx8u7qkkqTAL97oLByJGq7U7IeVcfnsel0AwFzB/QGpjpegB
	 SPTv76H4StcEMb95OeBPP984vPS/Ij3prPAS6Lw0x2wKbbQFnz7LyHiSDhbeiwcbSeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=b23ugdr7;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=e0n1oN0R;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5E8606A336
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 09:59:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E5E8606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=b23ugdr7;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=e0n1oN0R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795514375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FYuz/K8ZJHw8V19OxffQhxGLJQWBYYcYpwJUkZTtfL8=;
	b=b23ugdr7IJLEgos7XieA49KYy2MUNYpTd6rNUQrWHZ13scOsWsThhISd58PYGo3C7ykmVU
	oh7t8WhACKYNr1iwv/YLbPGPleTiHy7lewj80j3/F88b8cNy9jFswHvX9aMw1apyCg6c8z
	RbPK4HweIUxjxx6iyUrbPc1L1sm3Td8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-mqsCD6JqPsuJso-_RzUoPA-1; Tue, 24 Nov 2026 09:59:33 +0000
X-MC-Unique: mqsCD6JqPsuJso-_RzUoPA-1
X-Mimecast-MFC-AGG-ID: mqsCD6JqPsuJso-_RzUoPA_1795514372
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4ab855a8c21so3527437f8f.1
        for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 01:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795514372; x=1796119172; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FYuz/K8ZJHw8V19OxffQhxGLJQWBYYcYpwJUkZTtfL8=;
        b=e0n1oN0RmBVJLCI2UlG/FmdCSTssxV+exz7Odw9yPctRTzDBOLz+b2w7bqcsPMtVhY
         YZsnJlqpYryo6qXAzhI+HVuYKj2kQ6eORj7Y9ra/+xc7/TMDdxWlDbxBQGWNlPWo+pYh
         P9Yh8ZIEPzKxRF39734uIOFuoBGSrOiagZDcnGRKcPvqCx8+d6iKyBGSdkKsUn7cDzEH
         Zfq11/qZ89jFO2QeuD57BKgJ0CvhpX40ao4X/57E3cqcucRCuS5KVkPNQoYFzuwAs7nT
         OgpeiwiGocdpfMzny02EziP9mr4b4+NpyTTgWQUvN5rhKV3uyv69ttF9MXSiOudVL5A5
         KyaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795514372; x=1796119172;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FYuz/K8ZJHw8V19OxffQhxGLJQWBYYcYpwJUkZTtfL8=;
        b=y7LcWreUBFFLCU9haznr0yvXPXzL9vGJCOxa1QzEYLQaxgWrgpkEtzGqqHWgfrZKZp
         CQmF7AnpF+iRMpnDUC+wDcIazAlsjHOIIeHwwMP0TX5dAPjYZ0rVwD8SBN1TDLv79Rgz
         bhyrR/rP25ccNZsM5qtT9GE9hGkvOsMGDVLHJSygGQ19YDITKTYiIKt/Spq7uzzjNZTY
         kmjDIQM/zD+pH2yTZE6woVJtfTZdiRTofqYAdhHpbBZE4y0q+AWQO3o6w1nckLoraQjA
         jEpYf8iL3I+YaukEGhJ8u6coy9i13DvWAAtoEBMh5riOAKD6hIrBTh4PHKDEN+KNxg3f
         NYZw==
X-Forwarded-Encrypted: i=1; AL+hErGQNJWkznQ/iUsX7x1udCQiNPcn2T/gpJFiPkKRs36VSKsnhx/MFthTxm4hyEFyI49Imel+g7CX@vger.kernel.org
X-Gm-Message-State: APuU4Z8dNbZjD6lv/ggbcviInLrq9umxnXYks6FheIdG8R4yZOKP4Rkj
	b+076TjCU3a1J9Ngor+W8KRoJEhDp8E/JhnbXUWV09vt+QlhtYwGOAXyp1EhCpH6i0ARHMzRXDI
	wIyzSQzozsN4E3x7ntFMIJRp4c3kq6T8AoCKCrXtVegBcxruUSo+W97oGYh2hl7shOT1MCA==
X-Gm-Gg: AZFdTZf0iXYBHSHvF1Aq79HknRdctn1tRgMkyFugeGw5no7CtdLHh0wK2I8+X5YpjC/
	6FIAb2bx+tVC8Wuj5yU1v7VISZ6YCBzVMfBSwl6cPL0LPoncLlooHWIusbG+wHCR1yye/Duxk8p
	097OfVZ7HgpLzqTw9Bn+mNUahgFsmLifd50uL4UtqLb6DChtXG1AjYRD2nzpm4jhfKJktzBUsW5
	NgqZczzsGbeFH7pJjXOxkIfJa/D82/oWTKvPgID4s9/xV2OBUBJoIL6FGPh+fMBiyLX63IrFaTN
	CRNHTIhZX26SidLqkCeg74Ep2Dc3IE7aClzJ1Qy5VwL/zPXaE1bgtZMxlEF7ob2XVFKAlhETVNi
	u+ZRt8OG+OasW/3GSLYLjo77Tr0ULNMyc0YoEPQOJhznNf1eSHXf5Ft9vD4m/D+izcmXiAKCZ8v
	nNzls=
X-Received: by 2002:a05:6000:4013:b0:4a7:d4c9:ea03 with SMTP id ffacd0b85a97d-4abaac57bb5mr26588486f8f.6.1795514372441;
        Tue, 24 Nov 2026 01:59:32 -0800 (PST)
X-Received: by 2002:a05:6000:4013:b0:4a7:d4c9:ea03 with SMTP id ffacd0b85a97d-4abaac57bb5mr26588458f8f.6.1795514372081;
        Tue, 24 Nov 2026 01:59:32 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab5ffcad11sm26055111f8f.0.2026.11.24.01.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 01:59:31 -0800 (PST)
Date: Tue, 24 Nov 2026 10:59:28 +0100
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
Subject: Re: [PATCH v4 3/6] sched: Add sysfs files for the per-CPU
 fair_server knobs
Message-ID: <awVgALGuilf2FMsT@jlelli-thinkpadt14gen4.remote.csb>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-3-d523e4d960d3@linutronix.de>
 <awVDG-ABOvj7zGRg@jlelli-thinkpadt14gen4.remote.csb>
 <20261124080833.0I9HFgtf@linutronix.de>
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
In-Reply-To: <20261124080833.0I9HFgtf@linutronix.de>

On 24/11/26 09:08, Sebastian Andrzej Siewior wrote:
> On 2026-11-24 08:56:11 [+0100], Juri Lelli wrote:
> > Hello,
> > 
> > On 23/11/26 14:41, Sebastian Andrzej Siewior wrote:
> > > The fair_server exposes the runtime and period knobs per-CPU in the
> > > debugfs folder. The debugfs interface is not a stable ABI.
> > > Make the /sys/kernel/debug/sched/fair_server/cpu*/{period|runtime} knobs
> > > available as /sys/kernel/sched/cpuX/{fair_server_period|fair_server_runtime}.
> > > 
> > > It adds a struct kobject to the rq and exposes only those two. The
> > > per-runqueue folder is named `cpu' rather than `rq' since it might be
> > > more intuitive to the user than `rq' or `runqueue'.
> > > 
> > > The set logic is pulled from the debugfs folder but it is still shared.
> > > That debugfs logic could be removed (after providing the same for
> > > ext-server) or symlinked for a while.
> > 
> > ...
> > 
> > > +static ssize_t rq_fair_server_runtime_show(struct kobject *kobj, struct kobj_attribute *attr,
> > > +					   char *buf)
> > > +{
> > > +	struct rq *rq = kobj_to_rq(kobj);
> > > +	struct sched_dl_entity *dl_se;
> > > +
> > > +	dl_se = &rq->fair_server;
> > > +
> > > +	return sysfs_emit(buf, "%llu\n", dl_se->dl_runtime);
> > > +}
> > 
> > Since these files are new and meant to replace debugfs, how about using
> > ns everywhere (you partly commented about it in the cover letter), as
> > sched_attr and the dl_server parameters already do, with the unit in the
> > name? I.e. fair_server_{runtime,period}_ns here and
> > dl_{runtime,period}_ns in 2/6, with only the procfs compatibility path
> > converting from us. Right now /sys/kernel/sched/ has dl_*_us in us next
> > to cpuX/fair_server_* in ns without a suffix.
> 
> I can do both in ns (or us depending what is easier/ more useful). Let
> me update that then.

Mind that it would be nice to hear from others in this thread before I
make you do changes that others might not agree with. :)

