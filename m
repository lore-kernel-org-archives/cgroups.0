Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98953C873F
	for <cgroups@vger.kernel.org>; Mon, 30 Mar 2026 11:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774871147; cv=none; b=TnWktzbzfw1Hso2yze3M6lKFhtcvixZ2yWS7DWZgiEV2uv8kUfC4r9m2MyBxWYWF4mFlGEkugRrx+Dkot9xS3YkDsk1y7P99ix0GIRRj0rapC7svISwu7F8glTbYuHp8YLtFGJ0O/3GYDDSEcbwhnfHPJJhI0PUbjJbP3dKaP8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774871147; c=relaxed/simple;
	bh=ENYJkWvXLcVtI7Jk9TnX7QADJtn30XJLoRyTZBf96yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCVGAFOqu80bzlO9lPns1ITXMKl2hHLlWP9XGIEpXCKHeukggrSqBko9K5UlDvuU2RLt62f6F9Z45yPv735spa2l50qw6UAuzD51lAApyzPB00fN+FaQQzIfLXDSkWICHjss+UWU3b4oQuL5CbnqnJi+zL3lAwwuD2bmnyLrT7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=csz2Yapg; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csz2Yapg"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-126ea4b77adso5961308c88.1
        for <cgroups@vger.kernel.org>; Mon, 30 Mar 2026 04:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774871145; x=1775475945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MnDbxuScG9Rm/YGh2qPYK61S3SeIJ/p/OHYJTOIzac4=;
        b=csz2YapgXBdCd1QSpBVbPiyh1Z8pcOHOAezCYSwazGTtMUNhPAGpgezRcwV7WrUbAk
         1ffqvlWFZ9Le3E126zVCMIkrzIRaKbvN1S/8NLyts1QlQIbp0DSPR10SnirxQ5plA7Q3
         XOHSwleO+0y36mQf6b8XOvdM5Sl4EdMvWGfkilgZAADybQXBBgaUTLwyjWk+842K1eGE
         1Pw6ygco4yfpDBCuU4DU7/xUZFzrGeu2k+KWJ+IiHABHtpVxEyAIcsCExnQrfr79cXXD
         77H/3UumUSmRB3z3QxWbJ9oeCdr+FCWeVIp8dg1Bi8zl/Mb5ZcwqVPE6qebiX0m7qcOE
         UYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871145; x=1775475945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MnDbxuScG9Rm/YGh2qPYK61S3SeIJ/p/OHYJTOIzac4=;
        b=Ss1A7QrumJ+O9GSWGeIyPAZ/J33/UvovWIDkthkG3KTZW5r0mvT9XClGa6aqWu8mMC
         U4LpOjJsVsp6DV2oKBDZAQ/cdeCrA9kWJNd8vpqIm23K8Al4UqI6i/ko4ZpLbDVkebOf
         VgnEBSmlWcwgPQ2aBeoeYOeobE0tpY8NPAh2YIXGbqH441sgn+jS8N3UnunbnilwSj76
         QVhZaHSAjyyVbwQSbUliS6a3hgjZv2D0UvEbH9una1/xDiXTu+vY9mvJDy7pCNAU6+i4
         vkqiQc9ZSI56oOuHpOalX8wU4hyG+UKuMy22ftbX/71S1p0VowdehE8Rb9K/wPJe/NuW
         d4MQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHYb5fqsoETnUqgOKSyMvphSgXtYSvEsWxM6g10IgH+A5qdeQMsLMgq3pyxb21oUD5vAKIP/71@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0ktmF09X5AWH4fRadu3EzpSXQexinvY5KdVwX4JIh/ngZT+jn
	ZI6BprZdJvVZPuGDg7H6ehUgT+MCy2Rhjn+6fgxNBKXIF7iqp+ZO+vgH
X-Gm-Gg: ATEYQzy5CedFeTBP/n5BoPWk6cSjSC7V/6RWgEBah6G/1nb0ZZLSUUsK481LGpzxOUD
	2/18VgLLooaOhm9xXeLkpqr4zg8Oj4h/wCdW9wlPTrbDdQBFG6uv7EEJCPATfF7epcBmyhFsmEV
	3JyfiZ5x3+xfJAQD2pifOxs8RK2kU2+VbLYXlTpYrLMtujIfcJgURLmpCB99lv1Jtd3bSUXa89b
	z6Gf9AdXZz4lufV+91Iu+0qgsQ4KQmRqr2nKJ+R2FiLt/g2zLPdUi4/L7rq02aaWLTzeh264rhs
	2EGRiEohvmzrECIHgTaXl9+IQCJdIBSbOVAk2Kqb4Pt8BdgeXDaFMfXxpuIbbZloMu2RdU1TZ40
	lViHQwz7xrmUEI+f+3wkC2cpnPwfJjLe+fWl30ub/6FYj62LK9vjfkU18zZPJ4Ms/D8pCjxKj/q
	t+7btpnzLYfLt7dZjz2cKNcA+nc3sommpjBCg=
X-Received: by 2002:a05:7022:b91:b0:128:e0dc:6428 with SMTP id a92af1059eb24-12ab2897c4emr6271373c88.17.1774871144768;
        Mon, 30 Mar 2026 04:45:44 -0700 (PDT)
Received: from localhost.localdomain ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ab97e7a57sm9176288c88.6.2026.03.30.04.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:45:44 -0700 (PDT)
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
Subject: Re: [PATCH 06/15] sched/core: Dynamically update scheduler domain housekeeping mask
Date: Mon, 30 Mar 2026 19:45:16 +0800
Message-ID: <20260330114516.103451-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325140053.GC3738786@noisy.programming.kicks-ass.net>
References: <20260325140053.GC3738786@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Mar 25, 2026 at 03:00:53PM +0100, Peter Zijlstra wrote:
> Sched domain boundaries are not static, they are easily changed by 
> cpuset partition (v1 and v2 both support this).

You're absolutely right. My description was imprecise. The goal of this 
patch was to ensure that the housekeeping mask for scheduler domains 
follows the partition boundaries dynamically as they are resized.

In V13, I will explicitly integrate the housekeeping update logic 
directly with `cpuset.cpus.partition` transitions. This way, any change 
to the isolation level of a partition will automatically update 
the kernel-internal housekeeping state, avoiding any parallel management 
logic.
