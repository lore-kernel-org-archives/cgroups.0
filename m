Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795011654;
	b=zHJ2mufygd7K3vkXfrD8wwELCAgp+IKZNFu8jxCh5qI1GK1NTrbPnO1251zrpOZ9ZvGS
	 A3XSNCu9+eRgXrnmr3wJ5u4U67eDe/r7RExDHN4a7aiW/D53pr1VDVPFTaYIFiFDPM5mV
	 hH8A90oLWCmfWSNMrItQ9cD0AJP05RQNObElwaRBD7dA+uXdQXPwHH4aimmk4V1Ru59Av
	 zxUw+vxzF0dUQK2zekGXM01U18K8KvPpAk6lMENV6tg4xKHvPMooOIeA6fmzPlJeAXXGV
	 XoDfSwYRMsY4V/qqUo7fj8ZNn9y2t6Ue5xWJmWQVXR/x3UhTBn6EnTOhdieB6ArdrJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795011654;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=gJZYIJR/KVRhmRv58xDPqzK1j0F7y63tdZWkx/0vk7o=;
	b=Ew43V7z/4fAD1dvzxd0YqOEF7xCzVWJQXbWjafMMdsYE+6ZWcNUA68ud3YlO9MBypb6t
	 qJCBHyZforo40l/L812fQkZAb/urFV6rNTvM8q+yRsTTSd5v9Rc8y3ReFm5mLSoItQ/hA
	 deNb7i0QZ1MULdgs/ziiJNm+CVGXQ1+zt43K0MY2m93XtSfnJ23fu4poA9XbVVE/pQ8At
	 mMzOBMv7Sm0nqBVh/4pzOj2Fx94zUKx5zfoL8oV+2J/NQTX5af0bRvGqEBKkgccb9Ji2q
	 duNYyD604nN6ep+8sXOjREjDsD6AW07McSu9L8CNnmzwPI+lZQGAcW8kwkCIcfJcR5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQ58xOzN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04C0606A31C;
	Wed, 18 Nov 2026 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQ58xOzN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2321F000C4;
	Wed, 18 Nov 2026 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795011653;
	bh=gJZYIJR/KVRhmRv58xDPqzK1j0F7y63tdZWkx/0vk7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TQ58xOzNpdg44+qwpzeTh77kIJgJX1IYttnKIGMYn9Em347kAw3UgT05XeCM70yvm
	 u6ahlLyz6MSTP7XEhrYMvA74OH0JwUSYIiR3eB3mL3iUeR/RNapVjK41YyK/DF8TpL
	 sEE2JtaxCXGwC4WHH5vCw62/a4trSaMwjQF3/BJciy/j87J8bAK+naRUVsGZ2AYMCZ
	 AWZ7upSDR+uCz9FPiPAVulOX6MtcBi8gfb8B1P3fcBpHmfiu5XYN/PWsbI2p2HAOpm
	 BDXHpVemOio0K+q+iBUmq8sghsKg396f5wCStKee7fbya4ITlomEG3JkT9LnXpEVp6
	 +rc4YFUQfIEDQ==
Date: Wed, 18 Nov 2026 15:20:50 +0100
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
Message-ID: <av20QrLUdOC_ysS0@localhost.localdomain>
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

Ok that should work but, IIRC this whole locking puzzle is there because
cpuset_handle_hotplug() can change isolated partitions. Why is it the case
since cpuset.cpus shouldn't care about offline CPUs?

I remember Waiman said it could be fixed in the long run. I don't remember
the details though.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
