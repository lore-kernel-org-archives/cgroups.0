Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926563C7E17
	for <cgroups@vger.kernel.org>; Mon, 30 Mar 2026 11:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774871089; cv=none; b=pRbesaACDLQODYw8qTXmR59qhM1nwKudmLstJFIU42ymhUD73w//cGGSZqPiY8l+7QESipIvSXVlXPeVLDaN5/LZRt9FHvIspMP5gQ8nU8SKjuVv9eH6MUGmxxO5n/RGHNtnaUOZuhIFX6DIWH9rNWOkwXTtr7FLCgvhD7OhLmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774871089; c=relaxed/simple;
	bh=H1BlQ5IvpIHaXNiKZ4Crk+CrZpV44NGK4rXai+J0uB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvpYR9PVM0D/Xs2nTQmyRwfXmMaWEouO1jUF2IFNzBLImqUoTZu7ukb+vq4FXjbdeABTHopOMJJ6fy064c5poV8wuOEkvbyZnmeHjH6JLh8fcvfzFIfyYT3MsnVXYEWELxEhXFAdaK4wj+TJ+SFg/tSDYtpG7Ey3zzdiQMf8Zqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QmchxzRz; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QmchxzRz"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-12a693cdf29so4109488c88.0
        for <cgroups@vger.kernel.org>; Mon, 30 Mar 2026 04:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774871088; x=1775475888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzzaOpPhZbZN55mNe4Js19w6I5yLbDcoIKbm6OR7/GM=;
        b=QmchxzRzUkf0fY2KTPRaFRUX6qILhNf8pZiJuAve/+IF4WZ1XuuYSNE6w06Rt4ZKn6
         S2QjunsY3xCH4vWjjI95jq958o999C8hI5wUc9TSdVoFV4piVq2tc+8co3NASmFKeMYu
         HxmWNBKWKR2Rj0gSWDwoMGiXnnUqk/hVGhaCROhqXnsx/VhUiLRy2dzjIT9H5A5jyFEs
         GbNDIol3EGa7hwkL2oiJMbBR/kjUiKqb3fbgdAUw50qoFl3yT/wCQkXtwCBybzF/5G2o
         98MZFbKtkgH7a+mpjqAQHhyejfSFR0P0XvcLyLGqE1SYBmNpzXaZ8AcciBd1krZFlOFr
         5IRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871088; x=1775475888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IzzaOpPhZbZN55mNe4Js19w6I5yLbDcoIKbm6OR7/GM=;
        b=Em7flGkUu1roS0vAuD43+DqV/Qdb2SgONBXyJcP6h+C444OVbqYhYgEGB4S3Jpy+wB
         sYuWGmHyDwU44A4t4fUg+y5RII8fzWAPjlTvcJQV3kIJ6HAIVC23Buozsd7pGlNtx1eb
         vpQ7H0Kx1gOCbb3yEA06FLcHmpquBmSlAtAAWTDgNypiPZzdqDkAToIKrPKkrLpG3s8/
         B90gADtbn+Fzx8lLg5Ibi93PAoOQD2B1dAWY6UIm3Rk2UVmFfP5fFKuyfmWA/5yStoxO
         awBfR5vtVuQmJpqw3R4n7dHah1QrRhRIJhrQxSjJsKqe5UBtmsGoe14G1+3hiCZ0ulFu
         l3Kw==
X-Forwarded-Encrypted: i=1; AJvYcCXM1LPA8FwqiOu3gIqFjmKALYyMKV2CPest4cJHrMquf3sxf7HdksMXg0UV3+kJqeiY2H8zGJD8@vger.kernel.org
X-Gm-Message-State: AOJu0YyS1GILLExPOtrAmPdhCILau8Z18j4HAVHkugTdSf8j6fF5oxCW
	c1xtPsbBF+ZZOosWYbFdOSptTEntH+YzNkXmCtSC8ZjJZSb1VEDYhYPA
X-Gm-Gg: ATEYQzy7nkwt6VhsaxAbWCFwwtQEkbJg7ELUdjxh5vQLNdQw3oHpKJKcFgPGYVenk9U
	x8mTQ8G/WoCmuZNcTiLgY53BSTu5R/DxsD3EzzBGlaqzDkg5ChfyWoiZmoWuEceboFH58cNyiUH
	s0aCevZSeRtI83ArJ7oFpwz9VFaT740FuOoxtNIJnkZQFRZdnm7jqRwxDOCqBO81GM0t36He2Om
	lq8AXo8t6kQs5ZF/ikGJ374AiJYSHGCeDl2X6a9xvpA6UHfcL2fmevqU3rCjObfhY4cDd4AACSQ
	ixNfky0wacqhOqFaG5m2ticehFPKkfMtPPuA+2mQxdVzT/854N+sae2rFmyf/MvpN2twbIP2ahl
	lU9ecDl5I4QJo4jcUZgrvHpLjBUldt7TWK/czfoFfvUd8Oa4kl2CFK9Ss86u9Pjp2mh3wvf/Zxj
	X9h053uMGBKEyBqOjXFlmu3CnNiBeRfbWMdHp7mn3b3Q/8zQ==
X-Received: by 2002:a05:7022:238d:b0:12a:68cc:3ee4 with SMTP id a92af1059eb24-12aaba5a813mr7281333c88.0.1774871087497;
        Mon, 30 Mar 2026 04:44:47 -0700 (PDT)
Received: from localhost.localdomain ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c3c7971d97sm7227739eec.30.2026.03.30.04.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:44:47 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
To: peterz@infradead.org
Cc: longman@redhat.com,
	cgroups@vger.kernel.org,
	akpm@linux-foundation.org,
	anna-maria@linutronix.de,
	boqun.feng@gmail.com,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	frederic@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	jiangshanlai@gmail.com,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mathieu.desnoyers@efficios.com,
	mgorman@suse.de,
	mhocko@suse.com,
	mingo@kernel.org,
	mingo@redhat.com,
	neeraj.upadhyay@kernel.org,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	rcu@vger.kernel.org,
	realwujing@gmail.com,
	rostedt@goodmis.org,
	shuah@kernel.org,
	surenb@google.com,
	tglx@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	vbabka@suse.cz,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	ziy@nvidia.com
Subject: Re: [PATCH 02/15] sched/isolation: Introduce housekeeping notifier infrastructure
Date: Mon, 30 Mar 2026 19:44:17 +0800
Message-ID: <20260330114417.102812-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325135821.GA3738786@noisy.programming.kicks-ass.net>
References: <20260325135821.GA3738786@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Mar 25, 2026 at 01:58:21PM +0100, Peter Zijlstra wrote:
> Drop the DHEI name, it makes no sense.

Fair enough. The acronym is indeed obscure. I will drop "DHEI" in V13 
and rename the features to "Dynamic Housekeeping Management" to 
better reflect their purpose.
