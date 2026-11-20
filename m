Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795187224;
	b=iKyz7MU+5YDcIbNpOxWzugsSSR7l3E52UTPC5zuX7O8XNuUrDhHKPHNEWtyBgPpzGXgL
	 wEo1X7+Kt7fLecFH92FxOC0+Vkwwq5ZvKQ+WrooA4iVJedHMN0a8JxNjTAiKury64bHfv
	 D995aEuZFxrXuZlarDHj+xNkKdkk+wCdJ/twpr3NP53SdD2mvuMV+cKuWZJRRK3kk9bL/
	 5EEbeTEGhsTUELqRXrNgg7g9JD/G5Dt7oecKDCBjT9eJHJVFN0jzVlfdBv57H7HWbdF4Q
	 NpimEp2z1XPVSwGq4+XLlY3sQ79eFR3ZGxNa1JP4TG3CspQ6H8/Qrjofa2rqxQZ75bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795187224;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=O0TPK5M5hrUDnQg4DmTQaVPUwM9tdKMHp47PNrEqGW0=;
	b=trDnnxz+rDtJTG3s+ZFkg4B5x3ldS9dLSyT7fFekCYPszgCxizSt3c6vpC9ml64xFt2P
	 7at9MKHCTz4GmxN3qJ/xOGW6y23hLRdbFDeMVwwnG2Sh90jY8iqq0TcA4IyAjE/Wcdebc
	 dSJ8/oOqcuk+/dXynbnX/vjNcIs7TsE3ciwmwS7AUBI8B1KHVfKDfwoxhCM2N+k1FVSIq
	 X740sumqaqd2ZXf3z78KrMAlSMCOmN9fUeHU+hiTMEvAKkDMZVf7ZRbin3Na7eLBM+U69
	 dmhPVVaJlHzZKTWBOV8iEAdfVCwHw83M1OvMddedXdNEW0+hPSQmaLA33qd4u8uxKJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FKTEVT6M;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=atf+HUNm;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBC860A2600
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 15:07:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DBC860A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FKTEVT6M;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=atf+HUNm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795187223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O0TPK5M5hrUDnQg4DmTQaVPUwM9tdKMHp47PNrEqGW0=;
	b=FKTEVT6MFJl495kupXoN9cmZMHA+Jfd6q6Jfq4FLspKXwwweay9KcJJ8H0+2w5L3enVlpl
	jfEP73alJfSCCnvDAPBwSaDDQ7OD40OAzWdsQPrpAL7XGBxok5s/By1Er9sRxurGAbmbLc
	A3zqr2xJW8ggTjGc44teWNu4cssWtX0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-UGE6TY9yNDO6fet-ljDV0A-1; Fri, 20 Nov 2026 15:07:00 +0000
X-MC-Unique: UGE6TY9yNDO6fet-ljDV0A-1
X-Mimecast-MFC-AGG-ID: UGE6TY9yNDO6fet-ljDV0A_1795187219
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49febef74e3so15147785e9.0
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 07:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795187219; x=1795792019; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=O0TPK5M5hrUDnQg4DmTQaVPUwM9tdKMHp47PNrEqGW0=;
        b=atf+HUNmIBtmeaxP3vFbVrI+iI6bplrGsWSan3oKdQlkKy8nQDteKVtqhoIvR3ythv
         GC2ncmOWH1UTgRqbpoLNnevwHkuwhWc24xcTkm6OylKD9fZffeGFyQL0QVV6fZcylUrh
         RMvcH/2r23T2FAJNE4MlUsxDvRmsd2pkO9yMD7OEpJpJu0fhCMCTNOrKxHTo7j4ymghA
         YotOoY3WuVXq81fH9b9lJXDTqkli1YuM1ZCxNjZMyZziQjLow6cedw+l6Fi3/3G/Ay4t
         jtCD1cdBzsPzp1t2IE18g9h8yUBzShi1YJgw0xIb8mBJ0kMQsgZamfMVJz7VpzmafFHe
         DvGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795187219; x=1795792019;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=O0TPK5M5hrUDnQg4DmTQaVPUwM9tdKMHp47PNrEqGW0=;
        b=ZYxY9dpouhshY6U2F4/eJw63yGxahv7G4EbTdb0K4N/ZwvOkTo19Kjc6dhUeviz7ah
         2iiJCiW/i5G/vcQyVqytzZKe95dHQnZ79B4MZhUwHxe9Eb/dAR7AdAyZCjmq2vneBD9X
         0eXClQfK+gkdjYfhH/ZLzdACbAK0KJL2oVqSsgoIfA5IJIcKNehQfP5TV2J1hfxOBDTz
         rNKorulkIfuLYIxNT40hYeutdgN5qKCzfuwxNgFZPmI3HPmqYymis7bCKXEJNHiwHBhn
         UgKRJlO+xmfiNqSJFxQMWT0kbjFkpmocMimi1OrCD12Ooa9wgLHbNdDmPG/mXQ0vGNM0
         AUgA==
X-Forwarded-Encrypted: i=1; AL+hErEKLMcrC7CUwSBoGfk1hhjiqlTzAJ0v1g0HGlG64kQI/xfDhjZyGETlj+NqbpKJDecIHOf2jUvD@vger.kernel.org
X-Gm-Message-State: APuU4Z9C3ta/Ru1lU4t/L63rZ+qPNCfK6E80mkuQD/oD75/UMINPInTR
	7SbaB8wo8k9PkDuUnN5jsDz8QM+axRb2tI0f8dFbVC9cH6rCxlSiQ+MpCLq7XKBO0g+QS/mNaFt
	5BfiG1f+JwrO6UrTY/CmZ/5lh2qICTK3wHx11Z54NHWqtGP0VqJ67oN1B0ck=
X-Gm-Gg: AYBFou1bjLHFoKHJihX++wU4I7kgkVyLfV0pBToAF7RFMsxNicDf1vCkFnix9p+egzG
	40Qov+cR0QdSXHAE+DW6Mne+lW6Kj+zFn9SwL5/u5C9xt13ObdLYmwsSTi09XXseMGPaFms8jeT
	YWrNARcEnqreS6x8NTz2Dz54zuYT1IaNc+ljtrZ3OGd6d9Hj0lpcz57U0ElmPtGZl6Z263TFpOy
	W3zHwOriraYZfwVNJ6D5+1X9fRtQ/35WQfotwOE07xAJbsUdEgBETMUNxVyYpC6u/xJ27ciODTF
	9QVzohLwRf61RMGkSrlk+g8wSwKHTh+Ax9bQMtSyGNubWp5Y/W6WcNZvmUEjgv022b/IoVnNTb4
	PK+ozHTjPijp4s5+dbbQ83yHtSn3XtHolL6GbUKoVcUVUVEVddg7O9KRTXSgLzTOVcuulHbN4ho
	iBl9s=
X-Received: by 2002:a05:600c:4585:b0:4a1:c6f5:2450 with SMTP id 5b1f17b1804b1-4bb8881b8e4mr73498195e9.17.1795187219427;
        Fri, 20 Nov 2026 07:06:59 -0800 (PST)
X-Received: by 2002:a05:600c:4585:b0:4a1:c6f5:2450 with SMTP id 5b1f17b1804b1-4bb8881b8e4mr73497495e9.17.1795187219045;
        Fri, 20 Nov 2026 07:06:59 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8849247asm92714315e9.7.2026.11.20.07.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:06:58 -0800 (PST)
Date: Fri, 20 Nov 2026 16:06:55 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: kernel test robot <yi1.lai@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	aubrey.li@linux.intel.com, yu.c.chen@intel.com, ltp@lists.linux.it,
	cgroups@vger.kernel.org, rcu@vger.kernel.org,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH v3 6/8] sched: Limit sysctl sched_rt_{period|runtime}_us
 to RT_GROUP_SCHED
Message-ID: <awBiDzEvUch_5ZJn@jlelli-thinkpadt14gen4.remote.csb>
References: <20261113-sched_dl-v3-6-a76ffa1cdeee@linutronix.de>
 <202611192004.cca8bf73-lkp@intel.com>
 <20261119142348.MkPQ2Fby@linutronix.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261119142348.MkPQ2Fby@linutronix.de>

Hello,

On 19/11/26 15:23, Sebastian Andrzej Siewior wrote:
> On 2026-11-19 22:11:10 [+0800], kernel test robot wrote:
> >  [1;31mBroken: [0m
> >     • proc_sched_rt01
> > 
> >  [1;31mFailures: [0m
> >     • proc_sched_rt01
> > 
> > Session stopped
> > LTP test details
> > ----------------
> > starvation: starvation.c:115: TCONF: Skip test due to slow kernel configuration
> > proc_sched_rt01: proc_sched_rt01.c:45: TFAIL: echo 0 > /proc/sys/kernel/sched_rt_period_us expected EINVAL: EBADF (9)
> > proc_sched_rt01: proc_sched_rt01.c:47: TFAIL: echo -1 > /proc/sys/kernel/sched_rt_period_us expected EINVAL: EBADF (9)
> > proc_sched_rt01: proc_sched_rt01.c:53: TFAIL: echo -2 > /proc/sys/kernel/sched_rt_runtime_us expected EINVAL: EBADF (9)
> > proc_sched_rt01: proc_sched_rt01.c:62: TBROK: Failed to open FILE '/proc/sys/kernel/sched_rt_period_us' for reading: ENOENT (2)
> 
> The test writes to those fies and now complains because the files don't
> exist. My intention was to remove those files because writing to them
> serves no purpose and people don't know this and _assume_ they disable
> RT throttling.

I agree on the RT throttling part. Before this series, writing to them
does serve a purpose, though. 5/8 moves that functionality to sysfs,
which leaves the files without a purpose, and 6/8 then removes them. So
existing users don't lose a useless knob; they lose the working one,
which has moved somewhere else. LTP is not the only one that will
notice, I'm afraid.

This is what I meant with "yes and no" in the RFC thread: we need an
interface for admission control, and I wasn't sure how much breakage
moving it would cause. Now we have a first data point. :)

You suggested yourself back then to keep the files and make them apply
to DL only. I think that's something like:

 - keep sched_rt_{period,runtime}_us for !RT_GROUP_SCHED, backed by the
   same code as the new dl_{period,runtime}_us (sched_dl_try_boundary()),
   keeping the current validation semantics (the LTP test checks the
   EINVAL cases, and 0 is a valid runtime today)
 - pr_warn_once() on write saying they only control DEADLINE admission
   control and that RT throttling is handled by the fair_server,
   pointing to where its knobs are
 - fix the documentation as you are doing already

That way nobody gets surprised anymore, which was your point, and we
don't break anyone? We can still discuss deprecating the procfs names
later, once the new interface has been around for a while maybe?

Thanks,
Juri

