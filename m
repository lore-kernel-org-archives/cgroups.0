Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794018741;
	b=Qa2e6RwCcwcJ4IT1vppXOOhmBNKDSFCXTWtOnTkMYqO/1nAdb2txRNnn5Ura6Tsrc+J1
	 D07xvDgdDJ/CzUk1/ZLzLtrzkMnxTaTDcutKu9wvPTjalFEb1qq4/IHZsLwqKoyfSfP5D
	 4b+JLVu1xk/JYtUMaiGVrWUs4TS2pgqNl9rjkzy1yIhnK8nUfT5izjjXoIQGBUg4kceZM
	 +rGL3XsipNL2fsreUYxIiTS3PIUwKbbbEEk4Xzrq8PKNgGiIw4JpHoRWF1IpBPfQ5/CgI
	 RDBxhErpxPH+tQxJ/jnHHikyHnF/2xh2ZJpAZmL7TgLDcXlilN1+akXgAPONeg1RqVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794018741;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=HVvkxN+Yu9GQpNIywW+xYkVpi0gO8eGj7Vx/EPDvNeE=;
	b=xeggpwXr2Jm4eNG+WjDOycTGMiXbeelNBOVm9JN5i+guwkYtH7fVky7bNpEg7GK3nL+9
	 +RpsAUKRxfFDVZRB/eoWIxh3uB6ZHVHwmOtxXudVjG7eY/B4OLH7Pjecq0KF7h2PA32nh
	 Zyhh0ZbzXeJzmF1U/eHz2NPgv+5apE/Z3YS/ew64WCmulXPQVR+uMiUeJIIYrnfxx+11B
	 6KJosJPs/h2V/uRf5HYbvOZ6ivpUsGfqTtQuXJa9JcK9nws/oty+0UHJHC1Mwbq2N2rMn
	 nwf+d+04OA2IBfY8c+fBVowEgjX9GIwzqIcQI36UcV8JdHNDcT584SNbMfjFqmebyFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=layalina.io;
	spf=pass smtp.mailfrom=layalina.io;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B94606A32F
	for <cgroups@vger.kernel.org>; Sat,  7 Nov 2026 02:32:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63B94606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=layalina.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=layalina.io
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso11585875e9.1
        for <cgroups@vger.kernel.org>; Fri, 06 Nov 2026 18:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20260707.gappssmtp.com; s=20260707; t=1794018733; x=1794623533; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HVvkxN+Yu9GQpNIywW+xYkVpi0gO8eGj7Vx/EPDvNeE=;
        b=mcIikeeNgfvTGdyCLogsgEX4y/Ky6t3vHAfqFKVF0e85rTLV0MmW1VafUqH8W5pVOF
         Z5zY03CN8nxNCoG0K24eJLSMAqDDdI28sTBjZpRW/Q2jm5zjH4CuX1GD43jk5cD6hCrz
         yhl963T5G3CsozNcw1hv5PkhrzbExcTxzqWIG44tPYm8zKQZkY22D++H9WtDuw0e0fuG
         /Kvpwvrg0lVyMZ7FdeVQ1w3An79oCbQiwxzTaNzpEClCilP2PMgucJhyVz7aVhlg3cZ8
         B9K2t/6uLjkK3i0MGWH16mpa9wsrcd48AvuXsPgGudtURLipkKZz24CKwrD8/pRw6BQt
         mrbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018733; x=1794623533;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HVvkxN+Yu9GQpNIywW+xYkVpi0gO8eGj7Vx/EPDvNeE=;
        b=IO5vu6AKHkefIaQI/m7qH6AgNUJ8RPMv0+zkJX3ji4SnmBnVjuRhyDd6yQQ9OYIFBy
         +GGn7lPGvZGLF5N7YKXm9kkoB1w+v3XOht2qG88x5w6tpNr7+KqF5lNPCacwTzlK0sjE
         QyVhr2BLo24dG+zA0LWqjCX2KHPqFo2yM5ReL5w8TCT3NDqdZ9dco0vOwcnh7w0Hi75I
         N2H5Xl6AaWO6ts4zBml0GsWWyE3fVjJPdgD8H8dCrb8u7lvXH//FduZuy+bNJqskAIp1
         tFVW6h4FuwIfZPoQefJbbpihFN0L3mIv507JNd2sxIFPDdWn5oc2e+S0fmFvqRV0AizU
         pOUg==
X-Forwarded-Encrypted: i=1; AKwUvByYeObeD+wdCZtECsMbZQs1qKUiVcOKGtHVWCiMxAhHnfJqFYhRDzpserK+Z0BRj8oKM4TFBBmZ@vger.kernel.org
X-Gm-Message-State: APuU4Z8ID31VISIGELcIEEbIXSNSBLy3ZU6WLw0VXL5yh2YpOodJ8TYL
	GJA2W15JkSVPYULm5LeMmuMWxT6oVvewdV56ewEwJzFsWeIBP0EeBjimfSTAU7K6u3s=
X-Gm-Gg: AYBFou0+yvwXzVLsxF7n2uhxdG3SirJuabARh+z2xA0lF8B9aYj1TjTopQhsI14ygQb
	lIG15O8E57RtouNTZremErCZiufZ5dj0xhfihv0nYPGJqvIrOrgrJy+nEq+X9Jm2u42pk8aSAe2
	5ZoKhk4w4CGOVbJZkkRrO3OGHD+a2kggb1vylKbxO5FE2D3/LYusMIqWZkO7dkmzgqaSHUKRmO5
	UsCz7qaKZ6M+kNbHkT0pDcDqkweRgXvP6gqVSLWQ7XOeuipk46MK6bCLGb8dN0ANrTeP6qDG+zb
	cD0z+om113TFJY1pEQB2PDQhTznLb/LKO77w8euQ/6ZkAldDXVOPF0Ktn9/m1bVprH1LGtCzFqi
	MxrTBisY3ikKmD27G4kYOvFETD0e2/bpKs5Asi05vo0UbKAG9zCsegR/RUzLpopSEyh81ZLCvfM
	YHUymKlvrSetG7vd0wa1rXC9rNoVaHdDvGgRkeEasYdi3IKF4q4IknFNkW1GcIOuUqPhtPax3f7
	vtATd6BHXHkIVHEZDt3QyIhBSw/5xEWaZKgLFE1uWVAsNm6V5VUlfWo8ieS+jonKGo9LLsZ1Wjs
	DN2AHqelWF2eWbzVPV+Wm0xk3ZElbnAlb4QAr9Eu0ATDo751IwERa7wrw4GE+fWzKqlzSZCIoGl
	HNw==
X-Received: by 2002:a05:600c:8712:b0:4b1:4017:c4f4 with SMTP id 5b1f17b1804b1-4b6df7d4a3dmr72659115e9.20.1794018733064;
        Fri, 06 Nov 2026 18:32:13 -0800 (PST)
Received: from aerith (host86-128-182-179.range86-128.btcentralplus.com. [86.128.182.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b76cbdb9cdsm33903415e9.1.2026.11.06.18.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 18:32:12 -0800 (PST)
Date: Sat, 7 Nov 2026 02:32:07 +0000
From: Qais Yousef <qyousef@layalina.io>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, 
	linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	John Ogness <john.ogness@linutronix.de>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	luca abeni <luca.abeni@santannapisa.it>, Yuri Andriaccio <yurand2000@gmail.com>, 
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: Re: [PATCH] sched: Remove CONFIG_RT_GROUP_SCHED
Message-ID: <au6Ln7JYI1lZll3A@aerith>
References: <20261106112454.GI1779021@noisy.programming.kicks-ass.net>
 <20261106113011.B7YxCMJS@linutronix.de>
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
In-Reply-To: <20261106113011.B7YxCMJS@linutronix.de>

On 11/06/26 12:30, Sebastian Andrzej Siewior wrote:
> On 2026-11-06 12:24:54 [+0100], Peter Zijlstra wrote:
> > We can try marking it broken; see who screams this time ;-)
> 
> okay. Let me try that then. Which reminds me of something…

FWIW I am trying to fix another broken piece due to RT throttling [1] and have
been hitting a wall on how to get my systemd to mount cgroup v1 to run a test
but no luck so far. I'd love for this to be deleted too :-)

For the whole deletion:

Pointless-Acked-By: Qais Yousef <qyousef@layalina.io>

[1] https://lore.kernel.org/all/20261103005953.56271-1-qyousef@layalina.io/
