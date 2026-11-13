Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794577875;
	b=yC9xa5xvAwHDzwowwFfSL9SIZDi+dslzKdqomLIITj2bvtTSlLvDBZw/k9W9bWnv3SXE
	 crAoD3905zerdXU435KrLC8rXUHaYskFDmBeeI8JdUz/glqIetfCB1TuZPypv037TWTfk
	 CvTa8qHgs/54CBtq6jTH7/9KpKd092qVWvOl9lFv7Cb7i9vRtdecamsF/LUp/vczDAvrE
	 Mgku4zfXhLwUOZ5tHCOaK73d/KuC+euEpC0TXMtAR6xcr7OHYyvODnyH8Nt9Jzz6TyglV
	 RdJPyCWkhOPox0MTAd/Hu1hR0fUWu+Cz04jaO0kCTQ0FFqnbKz6GdZwu8G4/y9TCZMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794577875;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0uudVa8z72PwtwfzxLux5kJ3sUVKvJn/6ULtjmYSFoQ=;
	b=3HlgZ9i/BdVtIokgcb/wuPl9uJ1r2BXdFDGK9E4UD9hYOpy+vNZ9eQ4zYHkScgEeGc6q
	 kjsR+ROKkrsJQRpwUW1t3BMPWtnWNfcTcGwbB86aBESWcMLiJNgmYcIhrc1O2GSHxtVHB
	 CuuUPYH1wSf+1KXqXjOOaZgOmkAWpkkepUqunpYHYGiYz2zaULg42bY2pyRUfA//tb8Wb
	 GvDRS891l6z46Mv3nOkfpH0P593H5UNCeWT2mwKAP3lC7gJ9omDmNQDhkJ4ghZ9k58Y2y
	 LrE3uAJooAaBbTuIDQKF0oPcpzk0uMFywhQUVB2WMUe+VEhdh1oZnIz2PvcUS2kgb7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=sZSubH3t;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EDF606B1A5;
	Fri, 13 Nov 2026 13:51:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01EDF606B1A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=sZSubH3t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794577873;
	bh=0uudVa8z72PwtwfzxLux5kJ3sUVKvJn/6ULtjmYSFoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZSubH3tjT/GPjjeCdOxx/4cAgGsCuWEr6VACo4J2PTl8cRs5IpBTlKtUeO8AylmD
	 HxCjGdd7QZ5smjr12rihK+BJyiAzlixZDSllUgXVr4MHyyLW7PcQ9Wnpi7XkFIslFE
	 rcuy+edXu9wYLvwf5/dIzqnXRt2MfU7UGg9/grL4Ak3diKTNTIOZDHXbfWohcyo5w7
	 qztzm/74PzPKzqfD/FXvvQDUrATZGQ/+1ucflwQcEvss6bM5+lRWCP/0YO5Y3yZ2S0
	 nH+p6zs7xK1urRLQWxFQ5Dfym4sSzAwDiXFnovryLmzb4K5dQpokPnGVIeCT4c+dlx
	 dxtfHsmfgGuvA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jQzDx5zJWzPQg;
	Fri, 13 Nov 2026 08:51:13 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: longman@redhat.com
Cc: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	parri.andrea@gmail.com,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v5 18/29] sched/deadline: Move a task's bandwidth only where room was made
Date: Fri, 13 Nov 2026 08:51:10 -0500
Message-Id: <20261113135110.160083-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <bcb60245-abfb-4e3a-aa4e-f134ed310381@redhat.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com> <20261108185406.1549770-19-mathieu.desnoyers@efficios.com> <bcb60245-abfb-4e3a-aa4e-f134ed310381@redhat.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Waiman,

On 2026-11-12 23:37, Waiman Long wrote:
> For cpuset v2, it is not possible for a cpuset to span two root domains.
> I believe it is not possible for v1 too, though I am not 100% sure.
> Please let me know if you are aware of a way to do that.

It happens with isolcpus="domain". The CPUs it isolates stay in the
effective CPUs of the top cpuset, and of any cpuset that is not a
partition root. They are in the default root domain. The other CPUs
are in another root domain.

The message should have named isolcpus. The planned next version does.

This is on tip sched/urgent (v7.4-rc1 based), in a 5-CPU guest booted
with isolcpus=domain,1,2. A is a plain cgroup v2 cpuset:

  # cat /sys/devices/system/cpu/isolated
  1-2
  # echo 0-4 > A/cpuset.cpus
  # cat A/cpuset.cpus.effective
  0-4
  # cat A/cpuset.cpus.partition
  member

Two tasks in A call sched_setattr(SCHED_DEADLINE). Task 95 is pinned to
CPUs 0,3,4 and asks for 10%. Task 98 is pinned to CPUs 1,2 and asks for
20%. Both are admitted. /sys/kernel/debug/sched/debug gives total_bw of
the root domain of each CPU. "Before" is the fair servers alone:

  CPU     before    with the two tasks
  0,3,4   157284    262141   (+10%)
  1,2     104856    314571   (+20%)

So the two tasks are in the same cpuset and are counted in two root
domains. Then task 95 is given CPU 1 alone:

  # taskset -p 2 95
  taskset: can't set pid 95's affinity: Device or resource busy
  # echo -1 > /proc/sys/kernel/sched_rt_runtime_us
  # taskset -p 2 95
  pid 95's new affinity mask: 2

After that, total_bw is 157284 for CPUs 0,3,4 and still 314571 for
CPUs 1,2. The 10% of task 95 is counted nowhere. That is the case the
patch fixes.

I did not test cgroup v1.

The planned next version has a new cpuset patch for the same
configuration. A deadline task in such a cpuset can also change root
domain when its cpuset loses CPUs. The patch refuses that:
- a write to cpuset.cpus fails with EBUSY if it leaves a deadline task
  no CPU in the root domain that counts it;
- cpuset makes a partition root invalid if it would do the same.

My reply to Juri on patch 20 describes it with two related patches:
https://lore.kernel.org/all/e21aaf40-b929-444c-b707-3200e21d7301@efficios.com/

I would like your opinion on these two refusals before I post the
patch.

Thanks,

Mathieu
