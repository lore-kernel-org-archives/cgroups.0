Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794231495;
	b=FecYb2qiTrlvBum6HntKyvEqgfyM8v979TSAf7EgbFVaF4Zkv+wsBfNRCf4H33X4O6nC
	 HjzIx8iUr2HrmUzUW6wWtifgdHgP4qdXBXDpIL87t1BR+OHddex5sQjB9EgRr4gj2zSKO
	 eemWX2eCOzv4kqzExC4YJQ2vz16ePsP7F0Fas/BqQcO+reVDawSPvmpiSKDkCe+EpTOUL
	 AqeAOZ6Mkp1jZfmkBjBU+Tbjf6YFDBe8KUY1i+Rk8qSKFVl5cADo4IGWIVzGJrUVZz9MN
	 T8cChnyF4uBViU1uCzSs0caFma682UczClqb39P629HVco7p3w5QhwkE366jRXaXDlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794231495;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BGYsCV+6ghrjpGJ3qQugEb8Y0kCPQvn96f3QlByPPhE=;
	b=cZWEuUaGaKmJYcmpmgThWfx/80vbYvnJfEK+z8iAxQjVMa0q7s/SU/32lawfszVfawC2
	 8Kj7QnCGdfSzuwwLbD+PA0lwRIltnFhjL+4Z7tOcm3Srvrar+u1qhsI4f6bIy3iTkQfi5
	 fLUfHvlIkAAZflOhtykkcht6VfHieyHjr1mtdUjYQVa/YtZg95Sf4o3xi3zXt/+0fBOIc
	 OGtC+ShhfNC9g7EtryzFfVhizDkwk5rHGZNm9/06f6ABl+5JyYz3jICEpEJFriXlGzDVA
	 6ay+41Pf0aLRqy/B6fz7wbhStp4L3D/BOBQriep0GhL1bpw/u0Mo8yHPQUcq9U+VlMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VUtCOFoi;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=HEIAIx1m;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6346606A333
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 13:38:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6346606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VUtCOFoi;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=HEIAIx1m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794231493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BGYsCV+6ghrjpGJ3qQugEb8Y0kCPQvn96f3QlByPPhE=;
	b=VUtCOFoin3YsnZlHv1bGq3yzV7qv02AZiKSQEwCqxciMjpsbtAYhunQCGP+3TJqorp8+7s
	XHva+KGu7ZSpUVy+QsQTGaGCv+s3xM3wiDikmYx+0gUM8sL7j5BEVbS58Ap38Ws2v8NlWY
	aPRNxjHsXiCuAMXedfUcgPN2MLoOSMU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-XzEBUNirM3-Ilo5XPuXbGw-1; Mon, 09 Nov 2026 08:38:11 -0500
X-MC-Unique: XzEBUNirM3-Ilo5XPuXbGw-1
X-Mimecast-MFC-AGG-ID: XzEBUNirM3-Ilo5XPuXbGw_1794231491
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e00f3929bso504023f8f.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 05:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794231491; x=1794836291; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BGYsCV+6ghrjpGJ3qQugEb8Y0kCPQvn96f3QlByPPhE=;
        b=HEIAIx1myBNl8RKtNU2XaCgpu79yU/cswIopgOKAAckX76fZaPPdUZz80jomxlLDwO
         TKpL5uzkNnDfJql6smhnFjeHPj5toVH6EOsjjQvyTt2TTDk6jGYXTmWBMqt5oJ+OISXZ
         bNk3+uKL9NKgignHq9zvMKt/kEK8wxGyRNU2KW7txfTsNUrLo2Scc0aQESVh0r4NWCvZ
         JV+zF0NG9GxdWyiozHCOGj0s/PT/Uj8ExGGkdMxibWPUuFofVzD18pC5GlVDGIqE1EzS
         VbALQvoq1rBNznrl6Krqrwsni8JvywssTcTmdCSNFkjO7HhJndbap36p2vQswKUuf5GZ
         bPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794231491; x=1794836291;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BGYsCV+6ghrjpGJ3qQugEb8Y0kCPQvn96f3QlByPPhE=;
        b=VhCguqdPqDvB1Db2WWRAAv6SoWURkC7mbke1VTcjli+hG2CXalV4sSTugI8anugwVb
         M/qI9kI9mzp0RP4olbUyM0u54gnsDYvqTseHUG5uov8Nuh/qJ+cZgBNaYmjGLsX7AKCL
         VORf63Z2O8IxA2tUpYtRuWH+Qic7rZfWmu5fhl3/kO5MOsZY6X0ak64gPG9z/WIY61WG
         rgUeWxpYwWt8e19QpOXZ9nPTsYIRQNCikw3Hc/0z0kJT7aFYwnMsyzLBd4gIC+Y/DGfH
         kNaUXJQjByI9FqzUmQvBeePDdnHSRdPY5A5q4lfO/PgXbb0Zt80Hv7zV7CKBU/XlsDt8
         3MGg==
X-Forwarded-Encrypted: i=1; AL+hErFXU4SY8Tp78Zagja4ZdwFFNWkKf6piRR9afJC/ZspyqewgQMNZ21W20m354aBNwTRzL6/ESyX+@vger.kernel.org
X-Gm-Message-State: APuU4Z83AsnfGDccVZxdOpdDJ72aMvo/9X8/0daZ4ZYG0v3tM2AkALrh
	NJYdGuv01GvhTQvzydbQVsq7rLfg6AkRgYeO0CHnvcyZAqJ6KKrIv4L0l1XwkM8n4V7OaUh3jhH
	3mAyPpEexS5MdRpCgYrh0eWH46e17a3tz3NPKxY9pGQ+WKk+0jYWh8mxF8vo=
X-Gm-Gg: AYBFou0KZ1Hcv6hC4yi19qAgEA13YR4lnJuAZuwCz+J1LvKNvo1BfesTd9UHToPAIYx
	LefE3cy3oWUA00r/cW8e/GZubY3rr98R+O28+AWH9gyVGVsIRUPGM7/oOpt/dJTKuhPQis0L99f
	G5SR5vK9iQMiR30ZZ/JJGK/zZNDJbHpIBq3qDq4QyR5iAUjJDPa5gThJaXp01iMG+XCAwDOfM5O
	QPLMcOycVkBcS+ynu3TA0ygZs4RFrRdXiql7DaoHrP5r1fvjxTzUK33+YtvL7tpY8tilX1VM4S7
	97ngDXaLFptTzuuhMUG2cCozTNSbmu/d8xbjqb7QjCRH6fxPmubQiz+MvrId0S/Qxp+VZhZOMB+
	tJ8/QuR9hIVvRqfawmP/dQ5MQ88oa2hCgQLXr2pYni1wqTkRviAVfpupeIQwzPQTNkCds9FpHep
	35nw==
X-Received: by 2002:a05:6000:240f:b0:48d:f160:efad with SMTP id ffacd0b85a97d-49425566d13mr15141621f8f.30.1794231490589;
        Mon, 09 Nov 2026 05:38:10 -0800 (PST)
X-Received: by 2002:a05:6000:240f:b0:48d:f160:efad with SMTP id ffacd0b85a97d-49425566d13mr15141537f8f.30.1794231490148;
        Mon, 09 Nov 2026 05:38:10 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49597652ca7sm10965139f8f.39.2026.11.09.05.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 05:38:09 -0800 (PST)
Date: Mon, 9 Nov 2026 14:38:06 +0100
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
Subject: Re: [PATCH v5 04/29] sched: Let a task boosted by a deadline waiter
 change its policy
Message-ID: <avHMvpJonTciAtx_@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-5-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261108185406.1549770-5-mathieu.desnoyers@efficios.com>

Hello,

On 08/11/26 13:53, Mathieu Desnoyers wrote:
> A SCHED_OTHER or SCHED_FIFO task that holds an rt_mutex can be boosted
> into the deadline class by a deadline waiter. Then a sched_setattr() or
> sched_setscheduler() call on it fails with EBUSY, unless it asks for
> SCHED_DEADLINE. sysrq-n would not reset it either.
> 
> The admission test runs "if setscheduling to SCHED_DEADLINE (or
> changing the parameters of a SCHED_DEADLINE task)", as its comment
> says. sched_dl_overflow() then handles three cases, by the task's
> policy: the task enters, leaves or stays in SCHED_DEADLINE. But the
> call site tests dl_task(p). That tests the priority, so a boosted task
> passes it. For such a task and another policy, sched_dl_overflow()
> matches no case and returns -1.
> 
> Fix this by testing the policy, with task_has_dl_policy(). A boosted
> task has no bandwidth of its own to admit or release.
> 
> Now sysrq-n can take a boosted task out of the class.
> normalize_rt_tasks() calls __sched_setscheduler() without pi, so the
> task gets its normal priority. Nothing then drops the boost. At the
> unlock, rt_mutex_setprio() sees no change of priority. The pi_se of the
> task would keep pointing to the waiter, which can exit. So also drop the
> boost in __setscheduler_dl_pi() when the task leaves the class, as
> rt_mutex_setprio() does.
> 
> The boosted_owner_policy case of deadline_bw_test, added later in this
> series, fails with EBUSY on v7.4-rc1. It passes with this series. The
> sysrq_boosted_owner case of deadline_switch_test tests the sysrq-n path.
> 
> Fixes: 332ac17ef5bf ("sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

