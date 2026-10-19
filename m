Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792431365;
	b=jdc0XNsL5o+U0rggLxODn4T6OimgBTPzV8NoG/up8WFqVKwDWMWdqLYv7FK5ZfKayldp
	 HXbBUka6mHRpYE9isWR/RIFkWxplVOSZq5h+KzzJ3pYgrGtmN3Vb4T5+/GfVFQMcj15jJ
	 D1Q8oqssl3KdunHPm87Op/AnVAOPNbl3+V9Yvno1SBz1efZDiE+4yPDliiCQoHzE1HWMD
	 H6oz9+P02MKc1cT1NAWByNqJATr2NwgtD6RepieV2SzCaDLp1EXHTPnPB8XqJU6zV3cta
	 4ZLeOEtD8ZJELyvEaYo74r+OipG4GbcSkozDTrKdcqb6R8kbBAGh5ykMbQwu6jB75cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792431365;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=HOWMPxhd4f93QJar5jGD1zCLcJhCkyttJ4OvEo5q/4Y=;
	b=FhBfJefhUc9lPOQJPVnMw0J8+s9CK0Oliha8sAXdWGRx44o55BWYSQji/TMM4olA/+Pl
	 1zHFmMCheFTxYvdp4ehOVkrWbAaBwIZc8VwZ3YPJ0P/hltQlPaHxp4BVHkf5a3ySE7EfM
	 ORkWbJH73vjeS7pG/1/O7E7reXV0nUFXOcwIBkjklZuPwmpadta0SoitNX1rQnoGP/SzM
	 fTZBh2uY6jUIbDH3vQeFf4Wz0HYmKYfDLpasFN9iMRn2D8jRX0+akTjHWFLupymu6MpFR
	 qTsveOkKV8x9s1L3ZU8H47lw+cjBW9X+kHv7ZsL+sKNR19vFrvmNX08YDdIUfZIWcIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=okonski.org;
	spf=none smtp.mailfrom=okonski.org;
	dkim=pass header.d=okonski-org.20251104.gappssmtp.com header.i=@okonski-org.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=lHNCFgLO;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CFE606A320
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 17:36:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01CFE606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=okonski.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=okonski.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=okonski-org.20251104.gappssmtp.com header.i=@okonski-org.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=lHNCFgLO
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b1d8944cb0so3359328a12.3
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 10:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=okonski-org.20251104.gappssmtp.com; s=20251104; t=1792431362; x=1793036162; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HOWMPxhd4f93QJar5jGD1zCLcJhCkyttJ4OvEo5q/4Y=;
        b=lHNCFgLOhZw1suFu2q2t9UrH6IdJbQiG14s4vxAgBzqtqbmzJ9VbJDLpB6i0DMhhFt
         F61s2N/0s4aAsvbR64ZwciQoc95mi3clQm4uafNxUwZF9XRoc7KN5qbNILoYWpoCJnM4
         eqnVAINPlQFn+JlKUc7u9Yw3mlt+Mgsvhh/cHP1zLbjJVXXxvqtvhhRmO5P7DeLfAnai
         wd9llXdSdN/vg7MfGZg9otSYjql+sCIyy6takZ7bibn12yyDb+ahOygsC14TJiy1ysai
         wWyC51g4B1w5h9smBnIS+s7ROkqTPWiH4ax0seFl+mK1reCRn6WOr9iDX/UeUyUlppYk
         duJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792431362; x=1793036162;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HOWMPxhd4f93QJar5jGD1zCLcJhCkyttJ4OvEo5q/4Y=;
        b=GR9a4TXCXV0nMBrp8Xd0aczTHsY9QSa9nY7CcEi6qUNsOJGG6/3yA289DRWLP+2RxV
         /8S2NrWTU0mE/p+jduvh+pFq/O0cg/HW8WwKxMXOnmTIAd+PNm68z+hwL8AdodFGRmuG
         g5BYLpwmsNn4icxthkBYXWjP3Pm1ZcHLAi5biHCr+Ogll9m/rxw6FN6WRWLJZ6aRrVlu
         tHvRtrseVcchPwHLA0IjAIIye2+Or7sW8HAiCKScY/jiAynYSWN29GhJRTy2/awvTHmN
         C7i6ADylCfna2DeaAg0yDpRL6cACnH0dIUzTiuW3Ee/zbVWpiWt9rJ7UcWNgckEaPpsu
         zGcQ==
X-Forwarded-Encrypted: i=1; AKwUvBx3hpYyuzQZR91aM4HvtCU2JRp9jISdNRBM8+vOznRb+HIY3QnRE+S8fh+cZxttAfBfV9tyjFil@vger.kernel.org
X-Gm-Message-State: AFq9FYLQnE2lx3JO8FP5y9faaMfCe0oae7rAmFhO2v4KnTneERwUETg0
	EzhlcjrED4rsvKy8pH5FkSjsnaci/Z2ej6XG0fwch476YxHLhdQenBIXdlci6UWNDLc=
X-Gm-Gg: AYBFou1n+A5ZbszxvaGin03qSlIxCkqw1YzV+Ub9aebhNBm7Ka1cchgXVQme/xR43h9
	GQrYkmj7kkrSbzJna1bh+X44I9c/c1ZF5bFcut57Qf2vaa3f7TlvOt87chfn7PqJJKxCOmbzPIL
	okfHNEu/3loFaBiRPlXG0vWrKUjERmqKA9VihNgVAVN0Xj0g6RareS82kP1YdpRwcAoOrEkN2+F
	gaop+EJf9Hx6JAdXgYgId3AqXmgxonXxOYjmsLbzd6x/KV23478+IK5jT25KVPRkQPLIAx07oyb
	khkby2UD+ouiL6+OB7B8hOXC0OdYsT0s1WO2vV9UkLTzGwq4RAYt0KzENj/o1kiLgZ5DF15xv5/
	ezzUF7gaDIE0IBzwwJb8T58EZ1Y1F7P86DEMILetBISyf1M7HxIr7Or7pKbsdcwMyrKemvHujIs
	fUv8UI23k1yP7xkL7oa5XoV6wzNwmkjXUiOyYVXWAwW8HR7cXGsrGOz+CrTftAc9bZ3szfXv9ui
	Mw78dO1BbuYpfTQN5YtHHLtBSk7BGYEJEb7Zg6HCX95UdaInpuOTcoZtpMy/B9QPPSXutC5DsCG
	2Ks9THicDmwPzN+qpOUfW22gA2XWr/83izu+BW/hSHU=
X-Received: by 2002:a05:6402:1d54:b0:6b3:a1ad:ef80 with SMTP id 4fb4d7f45d1cf-6b3a8186202mr5025787a12.27.1792431361999;
        Mon, 19 Oct 2026 10:36:01 -0700 (PDT)
Received: from ?IPV6:2a02:21a0:10:748:1::2? ([2a02:21a0:10:748:1::2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b38a1e9da2sm4455871a12.31.2026.10.19.10.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 10:36:00 -0700 (PDT)
Message-ID: <f1d0fc39-6939-4fb3-a422-273cd5c347c4@okonski.org>
Date: Mon, 19 Oct 2026 19:35:58 +0200
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] sched/eevdf: Move to a single runqueue
To: Vincent Guittot <vincent.guittot@linaro.org>,
 Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
 longman@redhat.com, chenridong@huaweicloud.com, juri.lelli@redhat.com,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 jstultz@google.com, kprateek.nayak@amd.com, qyousef@layalina.io
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org>
 <58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org>
 <b1002150c3e4f877d04790cd8e85d2149d17722f.camel@gmx.de>
 <atZM6uF0CqCNh__I@vingu-cube>
Content-Language: en-US
From: =?UTF-8?Q?Jakub_Oko=C5=84ski?= <jakub@okonski.org>
In-Reply-To: <atZM6uF0CqCNh__I@vingu-cube>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Vincent,

Your patch fixes my cpu.idle test case.

On 10/19/26 19:01, Vincent Guittot wrote:
>  /*
> - * Preempt the current task with a newly woken task if needed:
> + * Preempt an idle entity in favor of a non-idle entity (and don't preempt
> + * in the inverse case).
> + */
> +static bool wakeup_preempt_sched_idle(struct sched_entity *cse, struct sched_entity *pse)

This should return enum preempt_wakeup_action. But with that change, on
top of 7.3.0, it still regresses from 7.2.9 if you test with a nice 19
spinner in the same cgroup. I think it's incomplete.
