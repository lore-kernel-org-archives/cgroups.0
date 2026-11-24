Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506979;
	b=0f7VZ4+940GhZX40Bx3iMQt7afE78b706SCYrRGZ04AEuPqtacC/eWfzcA9uufihTteR
	 PsLQGFYjbOYRlfq5hR/vDPWUClSS2opNX/lYT0ewlw4zN8sMbpZJ53v3ki95WaFi9KUX6
	 x8qdK5cz3RzE1W+qOZv+87ds/QucEDc6EPRaZ6GR3wB/aLtUZ4oEo0rYTcnAEQbKFqMES
	 i/40SCaRp4+wG2Ot40hsFDl6JUcswi8Lgxbui7ALNhU8BbQiHDCcQUOiFkZakwlIRo2MM
	 u2lDz2iVZm03KHVjKau7S9uk7d3Kn23FU+rlYVSb2bZytQDq+wl47X7V8/T2LPYJNSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506979;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=NoYyv4wajWc0F6aGxtmlY+0UYbCgY2jiNDwc0W/rZK8=;
	b=rP8bOMNOy1nkr5OqUtXZLBFuuynrjWXd9COQqjlQi4k8UbMNx+oB3ITVazhEZHty7YiZ
	 0kylIXilLiUpJVRv7+16fsgavJ8vaLUtlv/P+sF78rayTwUBOFqeQoYqiUVvteik8B0u6
	 J3ssagY4LbxamzCEC/RWL++H45jBWpkoO9OJi5EyUl8i/4c2hb44kbNem32P6HcF9YRxM
	 kFpJqTGnJS4nb+xQBJedgNc5vh5MSFyOa+Xm+Wqlwha6/CGHQXX8EIFeu+ajWy9JD1O2D
	 BjTCFj3aK3acanm3bQ5dQTCr0YGj6TDoY4ss7Nla1F8whvDsOlMyp+eerc3MuFwWuLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y0Jdg16j;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=U0UeFabM;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39CD606A326
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 07:56:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F39CD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y0Jdg16j;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=U0UeFabM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795506978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NoYyv4wajWc0F6aGxtmlY+0UYbCgY2jiNDwc0W/rZK8=;
	b=Y0Jdg16jJkxsJ01Ybn6vnG0AvnkFHRNLGgNFt8lvJycpyX7rr1z1bVD7oypPeWkk7o64Mx
	pPtumeyxHcOwnzP3qwc8liuIYPD8+4cFBOmUuktGD92hpTkD1R8NW4bUUV8IOT9Vjr07vt
	ce6nYeYRDV0g5ubk6U2j58vk6hv6xc0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-Qjo4HxEbMverUXf6MtTEvQ-1; Tue, 24 Nov 2026 07:56:15 +0000
X-MC-Unique: Qjo4HxEbMverUXf6MtTEvQ-1
X-Mimecast-MFC-AGG-ID: Qjo4HxEbMverUXf6MtTEvQ_1795506975
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a4654add56so28670175e9.2
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 23:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795506975; x=1796111775; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NoYyv4wajWc0F6aGxtmlY+0UYbCgY2jiNDwc0W/rZK8=;
        b=U0UeFabMFf/ISUizAhh59HUlDp0z4hAk+BCdZZDw0RExDHxcCQfox5bhpve1ghnCTi
         cPXjrlVsFre70PX9D+3E7Xcn1cRNP0OoMtGZB92jzfCBv7uVJE34uOkgF3eXKfiDCd/W
         E7jVYMWFaR2O/PZMSdsmJwwIAa9NPe4MnnTccbDIDm5mq/pc3dkGLiSA1+sNa9G2nNf9
         RFy6vrgASvUAYCp6f4RXyrEAJ29S5QgXjHCWs30hZvbuKpe27qKD/ka249BE1dkZ1l/m
         RPuFiEzHME0ypT+0bIlb+R7NqYYYITL7TVrqcxMujUWptvNFN5HZZwl0V7ZPB0ONpDe+
         KgWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795506975; x=1796111775;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NoYyv4wajWc0F6aGxtmlY+0UYbCgY2jiNDwc0W/rZK8=;
        b=uFzicrNvdtEr15qyvbzOtKBfADPDkex+mYMz+xT3ed+LLgzfw5W8AWI6A8jvzgDs45
         hVBxs9pOGFBsGTxhtcq2uEFpOcEBbVUgnl/fq2OwGBV/fZRcnQnj86j3M65NrYn6RNcs
         TKtsc1pQU4WRFGdQyNtrTqKxPzeXCiyIrcISLXWEPHKrbP/gnSivQBfBTF8kVMB5O41C
         dlhGkU08riMWzwICpj9xpfBLtCaI0V8AC/uCogW+0kCu+0Aiy57Su+g+A1fDINr5ou0B
         4w280XM/MB7Ny76OSmAXy5sW4ha2eFLh6UtNJlQJWKQmgE8jtP9f4O6JmYQtnOvsW8g0
         ugPA==
X-Forwarded-Encrypted: i=1; AL+hErFPT6atCFXmSlqovqQAFFIKcN7CvWW3tPewe0nzTDdxtP7pFI7Efe6uFT9HXilVvnqd1pzG6VcR@vger.kernel.org
X-Gm-Message-State: APuU4Z/Thzy0FpnNFuNn+RjIwhMedUQstzZb02Axf3Gh7s9qk89F5zg3
	5Bcne6XAmzGanDO3acBb3anbhs4FrTVYfmIoccTMbx14XnTFnjS7wZzpMZu3qvdoQbSEPj4jDT2
	cAiexLNzm5u/nrvYmPGRz3ZDfhZPIyogSuD6VT/2c+v1tELTTNN/ZR+Ue44s=
X-Gm-Gg: AZFdTZcKwIbkI+TvwWKlJlGTVxI2phayYbJdg3eE8oCxJuEAd+alYYlgYguJ0S9BPHd
	/Pz5Ma240UtQ6jbRfQtobwruKmp5uZRmE1mohbvXMv6XC4fgA/P57+Hv46Tx6iIGhZ0oNSJyi+H
	A+Wb8WV1BG9oiqbGsgP346GRkj47JeOD7v5wSoAfy00g1+LoKhE1HzFaOevPAiewnxxpHLD7TKj
	XIEjTK+mlE4JNyPwZrMyIu6IvpOPJ7e+lxNtJr1iIqyy+zQcVoDpaow0Zkt+OmJeiRsBenms162
	ecxr6NXsrO90s//Wm52/eBTlKcIlg4qgwZGo8ce3JQP3NY1gyqVcST11S2CVrd8umwFyPHFxbh+
	wDIykQEusGutTDlLKf3jsKjMYE/N81qUS++mXNiGO62poc1Jfy+Sm5oLX5oJ28sgN4npNFq+0I4
	u/cbw=
X-Received: by 2002:a05:600c:1549:b0:4bb:6f45:2a77 with SMTP id 5b1f17b1804b1-4bb8880abf7mr268984095e9.11.1795506974704;
        Mon, 23 Nov 2026 23:56:14 -0800 (PST)
X-Received: by 2002:a05:600c:1549:b0:4bb:6f45:2a77 with SMTP id 5b1f17b1804b1-4bb8880abf7mr268983605e9.11.1795506974353;
        Mon, 23 Nov 2026 23:56:14 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6c340df4sm30623656f8f.55.2026.11.23.23.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 23:56:13 -0800 (PST)
Date: Tue, 24 Nov 2026 08:56:11 +0100
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
Message-ID: <awVDG-ABOvj7zGRg@jlelli-thinkpadt14gen4.remote.csb>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-3-d523e4d960d3@linutronix.de>
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
In-Reply-To: <20261123-sched_dl-v4-3-d523e4d960d3@linutronix.de>

Hello,

On 23/11/26 14:41, Sebastian Andrzej Siewior wrote:
> The fair_server exposes the runtime and period knobs per-CPU in the
> debugfs folder. The debugfs interface is not a stable ABI.
> Make the /sys/kernel/debug/sched/fair_server/cpu*/{period|runtime} knobs
> available as /sys/kernel/sched/cpuX/{fair_server_period|fair_server_runtime}.
> 
> It adds a struct kobject to the rq and exposes only those two. The
> per-runqueue folder is named `cpu' rather than `rq' since it might be
> more intuitive to the user than `rq' or `runqueue'.
> 
> The set logic is pulled from the debugfs folder but it is still shared.
> That debugfs logic could be removed (after providing the same for
> ext-server) or symlinked for a while.

...

> +static ssize_t rq_fair_server_runtime_show(struct kobject *kobj, struct kobj_attribute *attr,
> +					   char *buf)
> +{
> +	struct rq *rq = kobj_to_rq(kobj);
> +	struct sched_dl_entity *dl_se;
> +
> +	dl_se = &rq->fair_server;
> +
> +	return sysfs_emit(buf, "%llu\n", dl_se->dl_runtime);
> +}

Since these files are new and meant to replace debugfs, how about using
ns everywhere (you partly commented about it in the cover letter), as
sched_attr and the dl_server parameters already do, with the unit in the
name? I.e. fair_server_{runtime,period}_ns here and
dl_{runtime,period}_ns in 2/6, with only the procfs compatibility path
converting from us. Right now /sys/kernel/sched/ has dl_*_us in us next
to cpuX/fair_server_* in ns without a suffix.

Related, do we need to add Documentation/ABI/testing/sysfs-kernel-sched
entries for these and for the 2/6 files (units, defaults, limits,
what 0 / -1 mean, -EBUSY on admission failure)?

Thanks,
Juri

