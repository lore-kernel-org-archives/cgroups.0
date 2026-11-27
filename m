Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795785296;
	b=ZEne1RwVA9mid8JkiRd3sZA8GPSM34C5kPUyeJCD3S8+C08OYkJ0uW7C25/3yVbNNEVW
	 pwLCH3QBhjFWGUQe55ZExUlqPz0AuCODrzFdfWfwl6GiEQfBDxuySHObRwdxH54mKd80u
	 CO+OtqAbo3Lf+exr0WxulpmDpEvlDlaVJ+Vvhd7TXqESWgzZEh+fXTAdNZavungVIGU96
	 6ad65gxTiO4Rv5pq+6MZeUM4wwiMzvpnUXZ3Vvc/lyWEmg5dEcQcSTt+gimV1YWDonl91
	 pOBoBMkYBCcMnJminYOuB6HEOjXFfzVMJmWkz/gaRK5FU6h+k6bopX95HTbFGwiy1ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795785296;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=EL6FxK8fRP7BQGrhBbgzhM1RJGPlOlES+j74TJFPn6M=;
	b=HrDES1TXtPb3kAJdGQ8hPw4qJ3LgYoWpceOP6PVWWpE5JrgsuKvb9DwEzibWK5p2DST/
	 //cjR69uyKB6NNXt9vO41CIKGlC+SlhV3nyD6jlnWoZQcnfBqE6LT1tsLjnigQ69NUsU1
	 ln2jkff8w7kmbpS1hg1x44zTQBhrDe532qKzaSNS40fnol83gkr4GjTBqN/UtwCoB/W2j
	 dN0EaCpGbRcLrHNGvwna3yOuSwCOPcZkSAnUVLxSbxUC37TONpU4mWN3xR7VEWOxSgfZ6
	 jPkvBu2iZ2WCRY8ciLjIBzWstU6KLU2mmaJI6gs9eTfM21rLqKoZi+ZHUZeI0jiNLGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gNRoSEoo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59256606A326;
	Fri, 27 Nov 2026 13:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gNRoSEoo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC6A1F00899;
	Fri, 27 Nov 2026 13:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795785295;
	bh=EL6FxK8fRP7BQGrhBbgzhM1RJGPlOlES+j74TJFPn6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gNRoSEoo3drwJX3lNqFsjs8odnOc/yYZrLOq9yMu+ifH8Tio5VVYoSjy3kC4z/Miq
	 kKmWUNiYvgPKCtfF34d2OVrymoYp4kEWAWzDrZXYNCz3Hpvsw+vJx0nVccSvCVEjox
	 9mZC5IlMfLYP5720KRjFxzlLmjF4bYq5puH1PR8uFZRPeS2JnyZzg70RoIAMMF0X0g
	 9F0a+jh+9nXIh6FT9afwAas52Txnm4992dQUWjlLuOrZ4bJFfwEqT22u7D9NU6Odub
	 X+npTwfNpwJhrrQjqNceP1vIxXphwTW7m4tCx8iYOTd6Ay370Cko/K/lW8mZ4Q07VI
	 jGSPOZKHkEqdA==
Date: Fri, 27 Nov 2026 14:14:53 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: longman@redhat.com, tj@kernel.org, peterz@infradead.org,
	mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	hannes@cmpxchg.org, mkoutny@suse.com, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, guopeng.zhang@linux.dev,
	mathieu.desnoyers@efficios.com, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask
 under cpuset_mutex
Message-ID: <awmCTbP_SaIPGRYf@localhost.localdomain>
References: <054a53a3-c038-48fe-ac01-fc24fd8065d0@linux.dev>
 <20261117083915.2971979-1-ridong.chen@linux.dev>
 <bc6e38f6-1412-49d0-95e2-76d5e9fc3858@linux.dev>
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
In-Reply-To: <bc6e38f6-1412-49d0-95e2-76d5e9fc3858@linux.dev>

Le Fri, Nov 27, 2026 at 10:15:07AM +0800, Ridong Chen a écrit :
> 
> 
> On 11/17/2026 4:39 PM, Ridong wrote:
> > From: Ridong Chen<chenridong@xiaomi.com>
> > 
> > Commit a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without
> > holding cpus_read_lock") calls housekeeping_update() after dropping
> > cpus_read_lock and cpuset_mutex, so the HK_TYPE_DOMAIN cpumask is now
> > switched and freed outside of those locks. But readers holding either
> > lock may still access it without rcu_read_lock() as allowed by
> > housekeeping_dereference_check(), and synchronize_rcu() doesn't wait
> > for them:
> > 
> >    CPU A                                  CPU B
> >    rebuild_sched_domains()                cpuset_update_sd_hk_unlock()
> >                                             mutex_unlock(&cpuset_mutex)
> >                                             cpus_read_unlock()
> >      mutex_lock(&cpuset_mutex)
> >      p = housekeeping_cpumask(DOMAIN)
> >                                             housekeeping_update()
> >                                               rcu_assign_pointer()
> >                                               synchronize_rcu()
> >                                               kfree(old)
> >      access p <- UAF
> > 
> > Fix it by moving the pointer switch into housekeeping_publish(), which
> > is called before dropping the locks. Then CPU A either finishes before
> > CPU B switches the pointer, or only sees the new cpumask:
> > 
> >    CPU A                                  CPU B
> >                                           cpuset_update_sd_hk_unlock()
> >                                             housekeeping_publish()
> >                                               rcu_assign_pointer()
> >      mutex_lock(&cpuset_mutex) <- wait
> >                                             mutex_unlock(&cpuset_mutex)
> >                                             cpus_read_unlock()
> >      p = housekeeping_cpumask(DOMAIN)       housekeeping_update()
> >          <- new cpumask                       synchronize_rcu()
> >                                               kfree(old)
> > 
> > The rest of housekeeping_update(), including the workqueue flushes,
> > still runs without those locks.
> > 
> > Fixes: a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without holding cpus_read_lock")
> > Signed-off-by: Ridong Chen<chenridong@xiaomi.com>
> 
> 
> Hi Frederic, Tejun,
> 
> There are two fixes for the HK_TYPE_DOMAIN UAF after commit
> a84097e625f2, and neither is in linux-next yet:
> 
> [1] Waiman's v2, which takes cpus_read_lock and cpuset_mutex once
>     before kfree(old), so readers holding either lock are done
>     before the old cpumask is freed.
> 	
> [2] This patch, which switches the pointer before dropping the
>     locks, so readers holding either lock only see the new cpumask.

Yes the second one is clearer.

Thanks.
-- 
Frederic Weisbecker
SUSE Labs
