Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795505460;
	b=GearPPvGNvqGPRe4z7sTzWz+lDKI24tLao8oV9OMwmo2U/InvRgMnOYHMXRXY7rGrL4H
	 hw+R/oiIBxS0EfAepeTjImrvE3Yn3zDSiG5+A65jZ18NIHU8Wo9ydsbyyxqkEnhNh0SSv
	 Cn4okptwGFNaVDuLTtnqWP59wcQZ5MhI+L9Toya0eNiCx1SwEEdAussaEI4oJIrlgCbxI
	 Gv8AqzcfhLdR7n/F3SfwvYw1dk+Cuat8TrMlEhdZqp2ZrFG+ORN54ObVAPmsExkEih5xn
	 Il1G57XrL6LTrPvWk/BKHZG3riP0mGhzqDesRjQAR+MFWLYBRXOCoTfOZUc0/kuPSwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795505460;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ICKsbXWih1ldCpzpgsQ/uVr8XB4yjrWqfudWCRA9yjQ=;
	b=FJMTpQbUGaCq5A2emQdtzBy8OIVWJsBMOiZ2AYb3LgM7+3WCcHIDzo+/AAHeqmwpe7zn
	 YkJWhLuM/FJwPThbn+RHmQhTiOma27nsXEDpkizu9rfjwzYyvEBRcTSlbPDhh6XEKtEPt
	 bkWd6vhwgwTjn5YY2CGZGvwB8IEvesf0iToqHtgdQ09jjtXcV4+YmED58H+3H7PM7AepD
	 If9cJ9DykNnfmCdocSR4D8XAzk6cc8t1tgfYcxpkYl5vS8Ioquu+QBnQXaNPNgG6N97rg
	 ttWazWmB5fZMlBPQOt+5M1vYO7Vpxl8oNWGXNB8nNUurUECJG6EEgoBxfzeqoUTOlTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RvldNy0B;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=fl4STBlE;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C49606A31E
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 07:30:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9C49606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RvldNy0B;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=fl4STBlE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795505459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ICKsbXWih1ldCpzpgsQ/uVr8XB4yjrWqfudWCRA9yjQ=;
	b=RvldNy0BzdkrPDPpPCYiG9gVXd0zz/pwO1axucLR36hCmlav01aDJkn4FhMm0lLrVk2SWu
	D8yaSgkMITy2qRIUOpqkHvh9Y2yUjhKC4r0ll9t73HEbD2AaIPK2Hp/qHVsM+XPwh+dPJZ
	jC/FvFL50bORVHbVO07hXVl3BTTjFOs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-4rQSooxpMiafzvDNSUfFbw-1; Tue, 24 Nov 2026 07:30:56 +0000
X-MC-Unique: 4rQSooxpMiafzvDNSUfFbw-1
X-Mimecast-MFC-AGG-ID: 4rQSooxpMiafzvDNSUfFbw_1795505455
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4ba078f26f4so29373575e9.2
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 23:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795505455; x=1796110255; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ICKsbXWih1ldCpzpgsQ/uVr8XB4yjrWqfudWCRA9yjQ=;
        b=fl4STBlE9F1zbALKvAgq9KByunB0yybbrYxsmospRkTMqV1a417MCXou9JDE2M9xEd
         bl/aBFHlfsuvG0pYnM6Xzz7qDWt4z0as4zGyq+sC6BUN5xNac79BmxBvaRqOpW1910ja
         rdXBmH0ELa3SHD8SJZS2QrRU8ZZJVbUTboFBEDWaW0gdvZLUG1N3mrs2ChdXrchmPO6x
         C3yTWAsgmxIIANk1+K6MCK8b/Rnl/LjGyYl27kVyGP3AW780DdCATtGAsSeaturDjF0P
         +jBn1SJQHZpjuGCxRcc0Ccmv1eLN/6+ULnb5xxF1JlTzP06kPfaEFvuiwMNAjRui/bhG
         UFzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795505455; x=1796110255;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ICKsbXWih1ldCpzpgsQ/uVr8XB4yjrWqfudWCRA9yjQ=;
        b=tRiELvM8g7OAzCty6W8nL7Tdihq5yssddKZymq7+cRmquCU1fyy0sdJDcdT5UDXlDP
         rznvb7WO1x1hTOlAgAy7V8yjDnBZPnoeJDp5qprsLBmUCcnMnZgtRHVEbnzNLEBDUjO2
         2+9BvHGZgbaibOXQTWi9FJagGBA8ZCyzicHByZuacdArT5hQf6blfVSZufJY3t7dsbeo
         xFtPAx7AyIwYgM1uYAOpkTvqwEc0hY5aeFgE6g3C8L2U65RavEuLfZxVZL0HyGKY1jsv
         m1qM2QJaZKSkPtQTrgm85VAcNuaoJDNvrXimAfZQsFJ4faW72dUGUqdQYr2AWpCfIaF2
         LD7g==
X-Forwarded-Encrypted: i=1; AL+hErG1tiCd7EYXQnABRGjtSLcxivq8OGjQtKmzuPd2LbdwQ2wrEwYBidPqBInGP3pSRReDADW65gGw@vger.kernel.org
X-Gm-Message-State: APuU4Z+oGW6y2bngjzFqgeDj3kX1+bbq4XSSbpF0myQVKpszxU46KngD
	qtltYiZUnUX88sYWmhJ0DRzJOzg4HfWBnP1dkpoacjiWrP0eR6X6THqZTnC6uO08W55/neFs7fo
	OXowApiYCd2Q0CL/HP4jiKFZLYzLgkna9+2rKkSRQROQWITx0mGe6I5nbhbA=
X-Gm-Gg: AZFdTZeCoKB8Y2wXm8OUOHKzGZbzObV9nVlU4M7JRkIyW4H2JXdGGLGE7To4ugFIBAU
	Wcnz/tsWAEO1eugCRZtCX1HLi/MeaoEZgi5JJlvND4MS1sjh6vI0vzM2DWBQpst7W9RXWOi+IqH
	9Noq7Hvz5rzlnmbTMibhy/nl0B0ZEuvAkif1bCBeOOxDcis552zM9F5x1nJPFtlgGUIntZO34ti
	aohtWGzYnKrD1DJloO/U6dmOmfiZxaTvzp3QHjzOOxmEb7JLKgBaJK+IJVFxLtGkTEq21cc7rmX
	uBd1DkpvCFv8b3JH3L7OLg6hoxrfBmXLQMYYL7AiKF85om+y13R89F16FAejRLAWM1cHRU2Heoe
	lrUkrpVFx76ZdzpG/hvut5cm2UW93JgT8VXiFzAeO3G3zJ3puKBVGz1p+aCD/EO7qgSMUczUYB9
	/jpas=
X-Received: by 2002:a05:600c:1911:b0:4ba:38a9:85e3 with SMTP id 5b1f17b1804b1-4bb8880eecbmr308303775e9.12.1795505454977;
        Mon, 23 Nov 2026 23:30:54 -0800 (PST)
X-Received: by 2002:a05:600c:1911:b0:4ba:38a9:85e3 with SMTP id 5b1f17b1804b1-4bb8880eecbmr308303335e9.12.1795505454675;
        Mon, 23 Nov 2026 23:30:54 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884865b1sm407760395e9.5.2026.11.23.23.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 23:30:54 -0800 (PST)
Date: Tue, 24 Nov 2026 08:30:50 +0100
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
Message-ID: <awU9KmFsbiyvbcOr@jlelli-thinkpadt14gen4.remote.csb>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-2-d523e4d960d3@linutronix.de>
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
In-Reply-To: <20261123-sched_dl-v4-2-d523e4d960d3@linutronix.de>

Hello,

On 23/11/26 14:41, Sebastian Andrzej Siewior wrote:

...

> @@ -2882,26 +2881,18 @@ static int sched_rt_handler(const struct ctl_table *table, int write, void *buff
>  		if (ret)
>  			goto undo;
>  
> -		ret = sched_dl_global_validate();
> +		ret = sched_dl_try_boundary(sysctl_sched_rt_runtime,
> +					    sysctl_sched_rt_period);
>  		if (ret)
>  			goto undo;
> -
> -		sched_dl_do_global();

Nothing updates sysctl_sched_rt_{period,runtime} when the sysfs files
are written, but this always passes both, so a procfs write of one knob
resets the other to its stale sysctl value? E.g. write 2000000 to
dl_period_us, then -1 to sched_rt_runtime_us: admission control is
disabled as expected, but sysctl_sched_rt_period is still 1000000 and
the period is back to 1s.

Thanks,
Juri
