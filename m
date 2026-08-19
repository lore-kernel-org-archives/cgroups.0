Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA39A95E
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 03:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787111215; cv=none; b=dQrYsVOMdqn/38sVYmkNbrQWdhWYOaUbr6fIvUf6NshTnwccKI9NrkrvuCaxrWQJbMh6tWgtFzHzGIahzn8F29Ko+QAY6L+bmZxXvHdD8f2was6ZiWW7nqosAyw2YSRUrA9Oi3RnkWxqmvFHYmRIix/gMqp2poCbFUbNh9n29qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787111215; c=relaxed/simple;
	bh=2kpwbvLUbGYWq3YDOK4UcWjIZVsG8O3FbxaIgWRz6Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+34Me5Gh7k4/3szgqyr+yA5BoCFR8z+t9uEHVTB1rQsInIULX62GCf0jbXb9EFlQtp1fF9FfamjvYANsudcrJGcd0zE1MfPbfRAeVqmTTktJX4DQNF1FZP7CVsZViF3Pp9XoTh6p/QWh6mdPv7RzVQ6+5rPpth0tWbUeUuL7BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dVsITPIj; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dVsITPIj"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-4b28d9537bcso337366b6e.0
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 20:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787111213; x=1787716013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wnMZaxIAAqG9Z6waMDFWf6/fX7Qd0skMNVzaHv1c1+U=;
        b=dVsITPIjBlqToHAoDV3Yi/7Suspj1HXy/9gbZbw6O1hhA/zPYg3Xs1noIzb/NY7O+D
         2cfuUVlkXLaX8m80ByWUXrYvQAQSAzjyX5Kdd0cYOSslpb2JEf02CXu9uJGbKaHCT/Wb
         ASlvxxs/+r6WyIHFn9GVsG9Zz7f/zWWepHBXV92tNs2AAlUeKJ6wqfPK4CZi+eGgGztr
         Awc5cPvsxrkQIQCZnnmS/WlQoc+gRoWVh0vWG1NFWU+8PwVG/Vks4AfhIWtxQqd4Hu9q
         56JxPZ4DQ0Z791f+k8C+SgDJvFemq9zPKFAZ9cAL2ZcEfGvPT8L+Xw4KcpXGgK06wrgk
         Ay1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787111213; x=1787716013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wnMZaxIAAqG9Z6waMDFWf6/fX7Qd0skMNVzaHv1c1+U=;
        b=dG2nFkfIvE0d9wCuBSwUiKLaF7QnwZNtv7Uc6ytktAKIJVFfVkMiMaGMHPYhjKt6oc
         cyaSxoBvjnxtyIKpbEjWQLqtaxrFEp2KejAjaUCQAU7Jr9U7nvy24iGMQ2vhItSg6mSJ
         ttBokJNjIM0gxgbRxKHvlwtNWj5V3qI2iCfkL4683dkJXdjLAcTgmcC/UsnY69O2Z39V
         7/7zaBlU+R1IPpjdC9ntpe5euVkaRM5afE4tXORtK/9a4OVSvgNOGCL1Z1c1X6OYoKCg
         LQ9B2lKNH9HYnKmfV5c9IrJhbgNHgJhl9jguvXtcL1UaONIzpCeC3Uk/2HhPqu7T9D76
         JmKA==
X-Forwarded-Encrypted: i=1; AHgh+RrCT8i7tqdG6PduykgFp+MvbeQX2CHHGZ+7/0KV0inNRd60oegBUl5MC7Pmf5kB+9tn84tonv66@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0Blzd1RtqDf1SWIux7Ux4jN2XuKtcXJf0M3UNJ0mLI8ktSGAV
	MiBiNpU9u/ofGKZqHC4qo0S82Ybc7hONYOhscjgx3yvIKSLzqyze1dZt
X-Gm-Gg: AR+sD10t9wnxbu6UK3GR7GwkuVvQYjNeA+5owB6d8wlZ4UHMDX6hF0VGfJupBddTBy0
	LUS/CYw+RoU55WBevRgeRq/YBdzHw4Z4rRClsjX1qNwSTRt5nzvlpy9Kbj0PNK797lyfHAqftKN
	v4Ah27QiP5kzlgl9CF99nTegTOrfYWMt8D7lyvDv3SmHVrKpbqsHb3XhjxbtKUh7bIWfGwUWV0H
	ECocWc53HxJ9eD9qle1r4QM79ynMheGGNug2fssEMvkVRRpw74U4ykdCB2TqXyMUrAHFmKpPvyi
	N3YSZEdeyYUiEsiduuHH67w+5Vo4YDYcW9eaAEuirMAjVWfB+lCbA3VVctHna7EdpOGd74JvgRg
	5ix2p30QoMfXIXaiEIqnHDMfHO19gsVyGr/P52kQg+GqccLrnmXxOllidxvNHgy7xMNRe5yGS2n
	Gc29I25GB9eQSPdcH5nqyr13KpmZNCQsWn9/uI7nrHPUIlfsbLiQJa+TpNKYE7q4roeP768Fl69
	CJHbEovZ7MGqsxlDDI=
X-Received: by 2002:a05:6808:d54:b0:4b2:9bf4:ae15 with SMTP id 5614622812f47-4b2baa4ad0amr1628346b6e.11.1787111212097;
        Tue, 18 Aug 2026 20:46:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b2960493ebsm4717715b6e.11.2026.08.18.20.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 20:46:51 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Song Hu <husong@kylinos.cn>
Cc: joshua.hahnjy@gmail.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	bsegall@google.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	david@kernel.org,
	dietmar.eggemann@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	harry@kernel.org,
	jackmanb@google.com,
	juri.lelli@redhat.com,
	kasong@tencent.com,
	kernel-team@meta.com,
	kprateek.nayak@amd.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mgorman@suse.de,
	mhocko@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	muchun.song@linux.dev,
	peterz@infradead.org,
	qi.zheng@linux.dev,
	rakie.kim@sk.com,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	rostedt@goodmis.org,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	tjmercier@google.com,
	vbabka@kernel.org,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry@kernel.org,
	yuanchu@google.com,
	ziy@nvidia.com
Subject: Re: [RFC PATCH v3 09/14] mm/memcontrol: Make memory.high tier-aware
Date: Tue, 18 Aug 2026 20:46:49 -0700
Message-ID: <20260819034650.708665-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818012115.65838-1-husong@kylinos.cn>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 18 Aug 2026 09:21:15 +0800 Song Hu <husong@kylinos.cn> wrote:

Hi Song, thank you for your reply.

> (pre-existing, not from this series - mentioning it here because
> it reworks memory.high behaviour)
> 
> The penalty computation in calculate_high_delay() can overflow:
> 
> 	penalty_jiffies = max_overage * max_overage * HZ;
> 
> max_overage is a fixed-point relative overage:
> calculate_overage() returns (usage - high) << 20 / high, so the
> square times HZ wraps once (usage - high) / high reaches
> 4096 / sqrt(HZ).  That is roughly 130x at HZ=1000 and 259x at
> HZ=250 - reachable when memory.high is tightened far below the
> current usage of a large working set.
> 
> Most wrapped values are still caught by the 2s clamp in
> mem_cgroup_handle_over_high(), but residues below the clamp pass
> through, and some of them produce far less throttling than
> intended - down to no sleep at all.
> 
> check_mul_overflow() with a clamp would saturate the penalty
> instead of wrapping it.  Could be folded in while memory.high is
> being reworked, or a standalone fix.

I think this could be a real concern, but I'm not sure that my series
is the right place to fold this change in. Namely because I don't
touch the penalty_jiffies / throttling part at all.

Maybe a standalone fix could be worth it? : -) I have no plans at the
moment so please feel free to take a crack at it if you think it's
a good idea!
Joshua
