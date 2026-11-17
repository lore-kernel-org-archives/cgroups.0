Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794950305;
	b=DKjmqVNX4SHCSvQiQ9JaxizknPJx/Th4lwHA5lOep0EaaxmD7ASnqYVU5DtzYJlXYc+L
	 pHq/bWGNdn6Yx7QXHXKifxoWlvUZer0jpZkq/A+Gfbzm/6iwrfxOXBpt9/g6k62CL6bX0
	 6G67At3xIqSoKkF0kMs4YmvxpKTOkSxaxn7AVNq/2T7F1QwEFEA60BgZd21y0gc8MTiUc
	 GpYws6wux6iVzsY9OErlgbJvlw2qsS46ZC4RhWmfcbK51D4oGCSDQ4/GTshiBqsc8xlcR
	 vn5qxe4zqzrldzJe8faIdrc4TFGzCPknPgJ6cE6TsCN3ExcfYfPd7aiSb8Ks0VzM1Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794950305;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=NTTnbaysgPXEbdujo7EmiVnsgEbUKQos9+XAHzanvlA=;
	b=zK+ZYDCBAk0f/mSLCo6/m4vZX6LrkBgTndy8JWkpRzOv9ErS5u7ium+GhO5LzlFdL/D/
	 JS2X8Dgj+JoiTdKTVhjVfXH/m776OATyYJUsn2Y270w8hx2omjszajFxnOZkVWNk2l1i7
	 cQkZ2PWiXv8X9fS+F8mOszq0hpwsKsSTbQr+rcnlbWjxmilfsqe9Ai2GKRo6kQub6TC5k
	 CTY1i4r4YPVfFbTXo0grhk2mcyNRVWRzA9CPKkws4zxzM6VH0ajLMdXK52BfNH2+tSd3e
	 Trxl/x9XGgzsB+TVwcG6DVbb3evDuvMJGakmJ82HDBCSAgyxAyCw0e1MF9IEIl3IEmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqHH24Sm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E82606A330;
	Tue, 17 Nov 2026 21:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqHH24Sm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159CD1F000C4;
	Tue, 17 Nov 2026 21:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950305;
	bh=NTTnbaysgPXEbdujo7EmiVnsgEbUKQos9+XAHzanvlA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fqHH24SmUl0010mnrEKgByKHd4QBOfFyuy47SWk5NfQ35yRpjw9UxCk4IYtDax6Ca
	 cXjldyW26rMmcqAdRGM/O9dBSkP1MDX2/0eLnNO3g/Iz1gvR+KO4jsKI58RJjK3PgL
	 FSD8HZov0FAzmnPqY0s1EfshhHaayovzL1i4TgPntVw97XkSeoSaAfNWHD6h6J/3LH
	 y+2VZUy8wFN/ru6G5h2k1Gk2y3dRcoX74U1nBMUOZ/5sKa1LI6dMzpj4sn7Dfaf+j8
	 YDIZcFqQGecQMsEofIhn1zEqQL76Bgp/4DryO/FbL0Ol/de7YOl8bDfIlSB1O7r7YA
	 R2+c8djUlLF+A==
Date: Tue, 17 Nov 2026 11:18:24 -1000
Message-ID: <1475d2102374ff6ed54c888d65edd640@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ridong <ridong.chen@linux.dev>
Cc: longman@redhat.com, frederic@kernel.org, peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, hannes@cmpxchg.org, mkoutny@suse.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, guopeng.zhang@linux.dev, mathieu.desnoyers@efficios.com, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask under cpuset_mutex
In-Reply-To: <20261117083915.2971979-1-ridong.chen@linux.dev>
References: <054a53a3-c038-48fe-ac01-fc24fd8065d0@linux.dev> <20261117083915.2971979-1-ridong.chen@linux.dev>
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
Content-Transfer-Encoding: 7bit

On Tue, Nov 17, 2026 at 04:39:15PM +0800, Ridong wrote:
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

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
