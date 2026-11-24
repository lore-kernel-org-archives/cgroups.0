Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795515097;
	b=AUjnlQziwmMG22gMQnddW9OVrGsLOkMUkYxV1JSD4FpVKkxVCifv3t1J+cw88hDa41YG
	 A39tdJcSbgG4t3gf8wdd6epJC8PXWB1PwIG+gNfUVdoSsuLzXDHVPT+1S6KR38pPM99ar
	 Ik6SbuUfkgpkw/a7eRSuigIa5ufVsgnadyJweig+XUwRNI603TBiW3KNczhiDUTbzf7ZH
	 n0ZVDUXWdKhrnjn+SnX+fbnQDogm8GTJxf1WruHhTkID+ssSEy/mYTt76QItxD2eGYF6r
	 zfqx8yYnIfP2mo81KAkAm1lH3FcbJiL1hGa64qMEBgstCIdpcCXSGCvHDYxnQlFyanQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795515097;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XAjHpOoHzD/5/0Qvp1Ofl3iGJdTZMSnNgw4bsE73GGg=;
	b=RKv6IN7/FvgTHXgJacY8QhAp/xUE8h+zaCmuwY9TuXER5hc/kusI8yh1XWAm+vgjeowe
	 6QcIByIfLi7790xzRzBu6FNNHsMzoZwkVQGFE42yhSSk7WkMhH7gfF1TyU47vRbDrpUvK
	 q9sy99E7xx1weKFmwIRBlYXBUxMXB400zbTG513oNUlHjjbsPefNFBycKdATLS9fsPE11
	 UMmS22WI7qUMT9K/vVjMCVx61U5rfuxtxyPF4VLmNdDUlTfCVSQMU8YVL3oVTh1m/tUBj
	 SMAqW6vsRzXYMzMXiPyIpTrOPqRrA04PHTHscYRc+tiyb1cAIO2oTHCxgybnGgNnogQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Z0iJ+rco;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=molHwP+0;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9539606A322
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 10:11:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9539606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Z0iJ+rco;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=molHwP+0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795515096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XAjHpOoHzD/5/0Qvp1Ofl3iGJdTZMSnNgw4bsE73GGg=;
	b=Z0iJ+rco98BjqT3s08NOsRwqQXnAbSjnD1vYA1IifTLvmI78K+ymU14N2/mR6dDjckNY4h
	SL2eJyrSdePnKOtvXB/ph5B79REPIKK60YNSbP4wPFu7ap6rKHTLFVta+ol1/44svtP5OJ
	43n6JJv2h7UtRdceAZm4CE4nbzZm990=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-9FvRw5cxP1y216ekuWm0eQ-1; Tue, 24 Nov 2026 10:11:34 +0000
X-MC-Unique: 9FvRw5cxP1y216ekuWm0eQ-1
X-Mimecast-MFC-AGG-ID: 9FvRw5cxP1y216ekuWm0eQ_1795515093
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4bb6bac1e84so27803135e9.0
        for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 02:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795515093; x=1796119893; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XAjHpOoHzD/5/0Qvp1Ofl3iGJdTZMSnNgw4bsE73GGg=;
        b=molHwP+04wNXKuv3ni7ToonnSoQ0DFV0bDuwx81qYQpbgtY8bACebiuyOLf2x2JIvs
         pDapUo8PI3U6WD5ynAANNbP1V/b9uQ78x8CwH3tuicXj/BhaIv891R5h6MhxbS+d6si5
         fshQISD8/jomRimOIVvEmK9XqY+2bqVejKGuMGwub179ziijZ92uC0bdFXuhw8wHTeIc
         dBJTw313q2l8i//Cz1W6LJ7nACvNv1dzZr4lGHmoXuMibxg7pz0PUcTib9+CdOlkdJnB
         neQpKooG2Nk4fFMDmtQ24kJCps4n8Ph2S/F1IZrliXu4o7a9FqYgSwYZBS4CJq3fnL/6
         DOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795515093; x=1796119893;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XAjHpOoHzD/5/0Qvp1Ofl3iGJdTZMSnNgw4bsE73GGg=;
        b=vCcni1ISMvBnCdlUCYj5oJJFyO5xzUfT326I3s7kIz9vn+9LnG/tREy7KYHLTs2oyE
         7KE1jtdWSualvCimDgaSuocs2GW53vLOv4wLAkrpLq+eBVfjBDN4GIY/lC//gefucynR
         gnblIrsldoR0j86nXnsya/rACpPSHZnGDAbYVEv69qvaf6B1B09MjMCwJN4oHeEm6iY9
         M9Xb89NvCqLADXOrBSXY09SCz7H1C/RScMAYlORZp+fIiVUJ7VCISpJWOes3WRTJHbuY
         0TLm0tyukpn0P90J56IqfVsJXan5x6xibEy85+3xqIyDYRMl9luIXn600O/AJeYY9BrC
         waJQ==
X-Forwarded-Encrypted: i=1; AL+hErHGosAksfRv+gUevp/oa4t7Z+NuVznybZXTyYrltAOQ7OgArrQkx1iEKfopNHBW3PwhWrf74RgV@vger.kernel.org
X-Gm-Message-State: APuU4Z+bW3jrLtQb1t5Ywtaa0IT2phIMSs+mF/nk1llwmjXnuYES02eV
	mAHWPEEEL9yKAdv8MUx33s+vDWwVpDt+7l62zxC66QeulfNapFYGZg3hgmiv2wPmOYoIMJYF7kx
	quiU6uX2cqiDR3slrvFzn8scVteGRSB913lshvhRXwIaGxxIKzRUHEOtPHHo=
X-Gm-Gg: AZFdTZcDMOToDe5/Rrh+Zzp9pmOANEvVf1+QsavjaFYaNvxn5eoJ/W1rEKrC9mc1f46
	x7q6K4NGfjxbcTvkq2ajH/Ik9t1lrJ4MQo5pwEEMHNpDaPoHRkgKd8JZkPuHJEEPbSQ25GSGmEr
	hDP4TB8IBuiYvQybeLqx1TZOUZKQ6dpX3XbySZY4v78VDG6VsKCV66vPhBDraXnVeFr68fAcZZg
	HstXLUPw8xCpqpjQZbY2yP8W6gWWtB4kBMeZOXepSiwbPV/DNhSKdKCoAWAv3r/8cJAtYYSR/TS
	IsWl2fejcNSS6DAO7HWVWqQV2MJO+WCrbO5MHCQhPTZzKC6LK+xx1ADYR2sLWmp/sSHjvoxSHcs
	tpfQk4YQ4PSgzWOzNdmwBcCli9LgsvFHeduYi1XmdEU4nOzc4VxybKQWawjSuGkQn7yQ0LqCO2W
	0OGOI=
X-Received: by 2002:a05:600c:1d86:b0:4a1:fa27:df7c with SMTP id 5b1f17b1804b1-4bb88922972mr294991715e9.34.1795515092661;
        Tue, 24 Nov 2026 02:11:32 -0800 (PST)
X-Received: by 2002:a05:600c:1d86:b0:4a1:fa27:df7c with SMTP id 5b1f17b1804b1-4bb88922972mr294991115e9.34.1795515092291;
        Tue, 24 Nov 2026 02:11:32 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6c61e53asm28093795f8f.59.2026.11.24.02.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 02:11:31 -0800 (PST)
Date: Tue, 24 Nov 2026 11:11:29 +0100
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
Subject: Re: [PATCH v4 4/6] sched: Limit sysctl sched_rt_{period|runtime}_us
 to RT_GROUP_SCHED
Message-ID: <awVi0VQJCBNYc8u9@jlelli-thinkpadt14gen4.remote.csb>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-4-d523e4d960d3@linutronix.de>
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
In-Reply-To: <20261123-sched_dl-v4-4-d523e4d960d3@linutronix.de>

Hello,

On 23/11/26 14:41, Sebastian Andrzej Siewior wrote:
> The admission control for SCHED_DL has been moved to sysfs and RT
> throttling has been moved (long ago) to the fair_server and its debugfs
> interface.
> 
> This file remains to have an impact only on RT_GROUP_SCHED. Keeping it
> for ABI/ compatibility reasons makes no sense because its original
> purpose (RT throttling) is no longer served. Anyone changing this file
> and hoping to change the throttling behaviour will be surprised.
> 
> Limit sysctl sched_rt_{period|runtime}_us to RT_GROUP_SCHED so everyone
> using this outdated file is aware.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---

It looks like subject and changelog still describe the previous version,
as we are not removing the interface anymore?

>  kernel/sched/rt.c    | 8 ++++++++
>  kernel/sched/sched.h | 5 +++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index bd37dbf2bebbe..258b187459bb9 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -2877,6 +2877,14 @@ static int sched_rt_handler(const struct ctl_table *table, int write, void *buff
>  	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
>  
>  	if (!ret && write) {
> +		if (!IS_ENABLED(CONFIG_RT_GROUP_SCHED)) {
> +			const char *msg =
> +			"Please note that DL admission control (via sched_rt_period_us, sched_rt_runtime_us) moved to sysfs.\n"
> +			"This update will be mirrored. Controls for RT throttling moved to the fair_server.\n"
> +			"This will not be mirrored. The fair_server settings are under /sys/kernel/sched/cpuX/.\n";

I am not sure a user who hasn't followed this thread will understand
what "mirrored" means in this context. What about something like (names
depending on the unit discussion):

 sched_rt_{period,runtime}_us only control SCHED_DEADLINE admission control,
 now also available in /sys/kernel/sched/dl_{period,runtime}_us.
 RT throttling is done by the fair server, see /sys/kernel/sched/cpuX/fair_server_{period,runtime}.

Thanks,
Juri

