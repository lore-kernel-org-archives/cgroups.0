Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795785227;
	b=pBFKccTVM9E/Z57fIuTFonWmEDS8qRquLyhTCEZ5aIu/G7RxejQFKsdqinjPtcP94wJJ
	 F/U6JSjmcy7Hv5027/16ZpFmAjTt+fUxjjw0VJXm20W7EioWHWa98FOmo6fmhZxxXcwbe
	 w8fYsXjmH8M9hmOtsdsEvwhm9MwJcPddJdeIhCPEEBpFhJ0xQn5AwSjCRp8vB7eQwKNQf
	 MH29HGmlZpDdZ3PxVtLskgvNdGoS9RQQzumMBQ2WnEua9s3Qy7BTaYEgG+lB5EcdtMyPq
	 vh4OJjz4GJmX4TsfIa9uo01UZ4PBKNLHyDQzwRB3twTsgPuQwRIcYeUnaqKuina2e6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795785227;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=TXv9R/S6GxySJkFGxbVLfaj897K17f1fhoBFMjM7/A4=;
	b=h5sUHzpngEZBZPcwn4+PTNGKm1GCtnOQJmjVFm8MKtdmPwhQlARseSyeugTf69uGAeV0
	 XU5t3NG4jSpyMgva2ptIb2jJan2wqG+aB1WQ1YGH2Lw9SSQWjOAJeukDy4GFIge+lsMPX
	 4Sju4qrmAC4Oq4KfzfV8fnYYwYOIAX17JrXt2VEFOuFE8D6eUjGOAUf/qVCObegBJ0AVZ
	 ZQ3S/nqFIhIeivG6d3pxJUaJc/AZbMMWIAavb5EPazsaDR6kAeDqQOaS9U186QvhAdx1L
	 Ahp5sPGlJZ6b9cTC2Kd+769bLJkB5rEWpSx0buUebu15rgP9xEFI+t+IjqFuoTe6hcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jLgtsWs6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8C5606A326;
	Fri, 27 Nov 2026 13:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jLgtsWs6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BF81F000C1;
	Fri, 27 Nov 2026 13:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795785226;
	bh=TXv9R/S6GxySJkFGxbVLfaj897K17f1fhoBFMjM7/A4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jLgtsWs6gCrrv1c6fsgZwqsOLmHFdtzkx0DxAputJ6kLuHLJSq1KsoiGv+OHibnvw
	 lDNf8xd2B0EDxQnhSJFU1VH/8RrFVmPBL3ma4TqauKhEku+pu0dNI5df3uEb9KXQ9H
	 WzIxPKzdo4nMpHyh86F8zddM+6mAu0xfvyH1gZa5wiLJBszorz6yqAudZ2s0L8OX1t
	 lWy8ZwUMHkhx6xL2NuSbS2Rjtzx9BtPGZDVoElQmrV5fQ4uLNoIO/HA5zEUBmPR1IN
	 jHL+j29zbBkN6Tqp5pFyEvBYrMqwsl2nkHfkSVbfc5zSJrnj/Tf0C+Bk6Ve3F6cUog
	 4x7+eHhM/jT5A==
Date: Fri, 27 Nov 2026 14:13:43 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Ridong <ridong.chen@linux.dev>
Cc: longman@redhat.com, tj@kernel.org, peterz@infradead.org,
	mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	hannes@cmpxchg.org, mkoutny@suse.com, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, guopeng.zhang@linux.dev,
	mathieu.desnoyers@efficios.com, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask
 under cpuset_mutex
Message-ID: <awmCB9vAMovUH8_p@localhost.localdomain>
References: <054a53a3-c038-48fe-ac01-fc24fd8065d0@linux.dev>
 <20261117083915.2971979-1-ridong.chen@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261117083915.2971979-1-ridong.chen@linux.dev>

Le Tue, Nov 17, 2026 at 04:39:15PM +0800, Ridong a écrit :
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Commit a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without
> holding cpus_read_lock") calls housekeeping_update() after dropping
> cpus_read_lock and cpuset_mutex, so the HK_TYPE_DOMAIN cpumask is now
> switched and freed outside of those locks. But readers holding either
> lock may still access it without rcu_read_lock() as allowed by
> housekeeping_dereference_check(), and synchronize_rcu() doesn't wait
> for them:
> 
>   CPU A                                  CPU B
>   rebuild_sched_domains()                cpuset_update_sd_hk_unlock()
>                                            mutex_unlock(&cpuset_mutex)
>                                            cpus_read_unlock()
>     mutex_lock(&cpuset_mutex)
>     p = housekeeping_cpumask(DOMAIN)
>                                            housekeeping_update()
>                                              rcu_assign_pointer()
>                                              synchronize_rcu()
>                                              kfree(old)
>     access p <- UAF
> 
> Fix it by moving the pointer switch into housekeeping_publish(), which
> is called before dropping the locks. Then CPU A either finishes before
> CPU B switches the pointer, or only sees the new cpumask:
> 
>   CPU A                                  CPU B
>                                          cpuset_update_sd_hk_unlock()
>                                            housekeeping_publish()
>                                              rcu_assign_pointer()
>     mutex_lock(&cpuset_mutex) <- wait
>                                            mutex_unlock(&cpuset_mutex)
>                                            cpus_read_unlock()
>     p = housekeeping_cpumask(DOMAIN)       housekeeping_update()
>         <- new cpumask                       synchronize_rcu()
>                                              kfree(old)
> 
> The rest of housekeeping_update(), including the workqueue flushes,
> still runs without those locks.
> 
> Fixes: a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without holding cpus_read_lock")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs
