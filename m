Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476286;
	b=IPsxDZcD2YCPJMy7RQwChcjADQOz1Xilwqaac1i8mUNfJavWCuGAjoJxMBfgmQhwzxXZ
	 iQx8HLoRbwyCc5mHnjN2VYinhnMp+7Dy3FZ2JWsIOi7W38ULkFstGu8iuO9eX7rVMXc9H
	 Z83y067PgWcKNn5qnZKM8JUUyfg02lPhzdAN7UhnpzlulyrQMmfH3nVDF97uYwgHkHKZ4
	 7oo/A2m0e8nKpQlHEUKJW1ji/7VEiE2cXgbf+043v3mva4kYwPSPE5shAH2ciNDrTBMPC
	 Nd0rcUjQSzhJ6hwMnnikkQGVrJFwjmJVcjdrd11woU7JH9nCfCjMouCr0UQcfQ4sOKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476286;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2Q2wLBAvQA7zhI3hvi4k1wNI9CYCQNcNSH4dFF1LSMs=;
	b=hTDms0PtM08egNJkio5xjqWvCMp7YRtgZRSW6x9lv3DNJOjaAZ843DVR/KUCNkZhc2Q2
	 XgGUu8cy7MocYuYeDKsEU14rWF29c5IUEG9AC53eEDUeq79ZFbfqGFjUuPm7Yx3NabcA9
	 M4D4xHRV6vM3hPwm4E1JFcyDrSEl1SQVaKTZSuDgI7w8Uf145IfTxqihaNFwxP8CMxAnR
	 N3dmbr7h21tJLryFzWwE3E0Zap6qbn7ZrVcAF3Y/HHnY4N8g6MdpAdPwrUPeFcv1fvPvV
	 x6hlSVqpN7X3RwNTqxNiCPhKcoVLjaFkoKyw0I03LEdTZ4hFX7fl6ULl48OHy3Znm8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MUz+cl08;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BBSmUs+g;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4F6606A32A
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 09:38:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F4F6606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MUz+cl08;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BBSmUs+g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794476284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Q2wLBAvQA7zhI3hvi4k1wNI9CYCQNcNSH4dFF1LSMs=;
	b=MUz+cl08ak+OfTibrMm7X6gZQ0AW5YqWpKn5A0JOj3zqrn0Hl3dDc/ewJTok31/vOeIh8N
	v2bwYL/MXLD5OX+hLfacoIcrmZW6U1obqh8qZRVz/B1XD2a/06dYzyMV0TmZ0Zc9ORmTQU
	GXNNdb00bfIxE5XJACUHeazlfu4d5ug=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-nJTZYSbmMEyZgfNxNQ0yOg-1; Thu, 12 Nov 2026 04:38:02 -0500
X-MC-Unique: nJTZYSbmMEyZgfNxNQ0yOg-1
X-Mimecast-MFC-AGG-ID: nJTZYSbmMEyZgfNxNQ0yOg_1794476282
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a20fd059ddso29728345e9.0
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 01:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794476281; x=1795081081; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2Q2wLBAvQA7zhI3hvi4k1wNI9CYCQNcNSH4dFF1LSMs=;
        b=BBSmUs+gQM2O89srxVufMBVcWy9YYrey4WVZRAoYSAu9kYgPlwBEtLHPZnJpC+OQoz
         3oudl8gdExAQQCPU7MSvc5QyYaQGqiF/EeGvlaWu7SfkbtUogXG3ke+iZ7s37gZr55ZC
         ayWWkvHgkZS8NHsQGrX4V2pKMH/7iEAx7+/tmKV9L89yWO+Ndq17+R6ma10h1IZj89iB
         GSbdo8aFKJygrbrCnQqvX7ZbFzH4EDpKrspAK2+MN7CH135pswjunxJoC+YnDL2isd29
         rzPt6Mks5ht+01fHo0y+wjViWs8F3Yn3wtYONSYRJJmfRftVpG6X6RCkdzmNuA8VrZ9b
         ulZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794476281; x=1795081081;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Q2wLBAvQA7zhI3hvi4k1wNI9CYCQNcNSH4dFF1LSMs=;
        b=UGXTpWJvBDRQ7NTXip5oEGNCvF3k86whHfZdYlOJ5VbTfwsEEV4DZeQGbce9U0ka7w
         LIE3Svq/5ztt8vCR9qEi9JznKLkowT4Cgcy3I6xOYBDOSN2ieZfgv036HPNryv7eSw2p
         A3K6TfeFObbbnamTRyvse4rCee+vrHtPyLYd2s8EYS5F8z0ZMAb2fJYbYorGvWrAW7wH
         pHHCQQjFIk2GFIS7w8msxVI2ai+B1Oqo8GGkmmvOPqPJA6AhyYc5YoFIe/ZtrFNzwOEP
         aMqpibXIgpr7A6imad6ors4uEvAdle8kYLJpdXoWTE5SvdNUV9XVwRIwbPEc+qFLxeHE
         Tn+w==
X-Forwarded-Encrypted: i=1; AL+hErHKag+uxkzCzWvY+X+Sq1iPIE1mQhaUnI6kQNiGeSSi9A+QZ7NcDyefCNiMKutaDMYJGDB25dgh@vger.kernel.org
X-Gm-Message-State: APuU4Z9zz1qnJvqTwNoTwY5cOH7aBTOvEYjyyioL0BFR7Ei68QKjEnyD
	hSXB1AXY4AHneO35t+pXQT2AfJssVvolipsHoGKk02yEPxJNef1NUycowueOFhkCmu41A2Zi35i
	Dhf131vqR1H+dvlKeNLzRrY4jmJydltah8mEnAGiVKTPMDxUjox081DdbltfWc+IMwXnn1g==
X-Gm-Gg: AYBFou0AZGGoDbMWWNMd7mgLJCGKQNz2EBVAM/2996NWc6MvVs2rbjNTqBnCavFJ1X1
	oSVqa+CJSczb61QgLIZiDzKKkx2sXcJg/+No+dgVDTc/RElEQdiaTKhI+vULc1rR3AF/HqTySA5
	OwFR6HdaMqOEFkkEidhS5ytZ6Nr5lbNtRoR0Y8QZelMWGxfzZafjM7JTN8Je57kTeWLBbbKay4K
	Yzd6zes+ok5SsH8qwKnJlwoGp/PeG8/6hbdyq1yQ5kSsuP2j/x/29Awjo+RpRuaFVBU45NuSRVM
	BzAvhHPRzn7oEdaQ2h9dYDKsmvZ7/ux2vSaGfXSj20JERAh3VEyQpQoBpb5pEP05nsDAaCefpEI
	OLbXbS5q4DWer5yCr/h6m1K+AbvPs4Q3BnA8l1dvYK9vAd7lGjJNRuBbHIL4mHXBIdGQAQFXEKJ
	pNEso=
X-Received: by 2002:a05:600c:8b31:b0:4a8:9a2f:d27 with SMTP id 5b1f17b1804b1-4ba0938af50mr81189165e9.25.1794476281614;
        Thu, 12 Nov 2026 01:38:01 -0800 (PST)
X-Received: by 2002:a05:600c:8b31:b0:4a8:9a2f:d27 with SMTP id 5b1f17b1804b1-4ba0938af50mr81188685e9.25.1794476281207;
        Thu, 12 Nov 2026 01:38:01 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2538b9sm103301585e9.1.2026.11.12.01.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 01:38:00 -0800 (PST)
Date: Thu, 12 Nov 2026 10:37:57 +0100
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
Subject: Re: [PATCH v5 24/29] sched/deadline: Cancel the replenishment timer
 with the parameters
Message-ID: <avWI9aAp46J0ezI6@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-25-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261108185406.1549770-25-mathieu.desnoyers@efficios.com>

Hello,

On 08/11/26 13:54, Mathieu Desnoyers wrote:
> A task that leaves SCHED_DEADLINE has its parameters cleared at its
> 0-lag time. Its replenishment timer can still be armed then. If the
> task comes back and throttles before that timer fires, start_dl_timer()
> does not restart it, since it is queued. The replenishment would then
> come at the period of the reservation the task left. Too early, it would
> give the task runtime it has not earned. Too late, it would delay the
> task by up to a period.
> 
> Commit a649f237db18 ("sched,dl: Fix sched class hopping CBS hole") armed
> the replenishment timer when a task leaves the class. The timer then
> reset the task if it was still out. Commit 209a0cbda7a0
> ("sched/deadline: Improve the tracking of active utilization") moved
> that reset to the inactive timer, at the 0-lag time. Nothing cancels
> the replenishment timer there.
> 
> The timer of a throttled task fires at its next period, which can come
> after the 0-lag time:
> - A task that yielded is throttled with runtime left. Its 0-lag time
>   comes before its deadline.
> - A constrained-deadline task that overran by little reaches its 0-lag
>   time before the end of its period.
> 
> Fix this by cancelling the timer where the parameters are cleared. This
> includes switched_from_dl(), when it releases the bandwidth of a task
> that leaves asleep past its 0-lag time. A constrained task that overran
> as it blocked has the timer armed there too.
> 
> The Sashiko AI review of the first posting of this series found this.
> It has no reproducer.
> 
> Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

