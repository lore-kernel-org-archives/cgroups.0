Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794191825;
	b=Ha5FK4HO1SktQWSnIwFCmKxLkaqhWg3CtnRIOjDtnk3MUurzifdDol7Cs8Q7q4ETprTL
	 IafxXJs0hW0MhMdjWOPvuawDMxtBzvcGnYTszKQ7UUg0rNVSe2FVqoZq+B9H2akMJgoAx
	 Y/qhUX0137bn2ePE3RtRktB62dYxaCfCocqyz0QKkJa9mQ8+GokpujaackYBcNkkLT8Ih
	 +aicKBH+XbWUzhGiTc20EatPRQEqhPyW6EWb2eNBIOgkEuPgoDZ8jtyf/HmtRQqXZD0ro
	 AJjH4UGFFA+H2LhhrBbcGOZj3+4Cn307clbalqtRoEZefBYZhnaZZzwEwHShwFLiNGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794191825;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2Do46NlydZKutDqVv5QFGwv55q73NYhW6ATlnOrb580=;
	b=bWq/pw4/w+P72lLzyWN0JQmDKA6MNIOtM8rwBdiaaQ17C0Doy3bbb57F/7ZGeCBAfavF
	 ZK/OU6YwT1QiYvbKo85TQMC0ozboQ+3l/JpwIvZH8d/+dIBoORxRoemWVCcNXJ+wS5oFY
	 xSM80RBv0ORoGRVxklrl+uD3s88DZxCaPJx1ItuEJZWB6FcrRTFks7d+7WNMHDhBKdZ3w
	 crE47X0VhlDJvm+uhdEQ0b2wPbMk8ezTLid9DAqCAp4HmlqLjo/fGRHAqbZBBMmawVzHy
	 nECcp5T1gExzHHFEBD9IDn68DC6H1Z8POb7mh2gLxQsS7zZRyGAkQu8RFiVsD+BgsJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="OVpf/Zcj";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2B0606A322;
	Mon,  9 Nov 2026 02:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF2B0606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=OVpf/Zcj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794191823;
	bh=2Do46NlydZKutDqVv5QFGwv55q73NYhW6ATlnOrb580=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVpf/Zcj+TGbED8ldGS2qiEK6CtDPt94fPd6v4n/mQUEZ0bRLyE+xA+BvAnf8d28N
	 rbUOQNGKdVsL04d3QzhSKFHI7vG6pbpVAWAHEKeL3T6cHcFed0idxdK1JYOYgwZAxQ
	 HxzBEG57n16HX5xANIgTin+w+taJE+yJnuxKGIuur6YL1Q5zPt9rkDacZ2kacBVChk
	 FiuJl6RMppQW7/bb4YorOV883KGX6JVpg/EkqRMZL6kbC7YURyREDqhQBDam9nyMnd
	 8O1mcVYy6NRxWzEluEw6qB0RsivtSHGC3ZtGKAwS0e2Y4hbWrBIvJLJs+XT8gTone1
	 EIZoWDr1rtQ5g==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jNDSv4MkkzMGJ;
	Sun, 08 Nov 2026 21:37:03 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Waiman Long <longman@redhat.com>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu: Fix online housekeeping CPU check in _cpu_down()
Date: Sun,  8 Nov 2026 21:37:03 -0500
Message-Id: <20261109023703.1551928-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108180849.1268263-1-longman@redhat.com>
References: <20261108180849.1268263-1-longman@redhat.com>
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

[ Resent with the lists in Cc. The first copy went to Waiman only. ]

On 2026-11-08 13:08, Waiman Long wrote:
[...]

This is not about the patch itself, but about the mask it reads. The
Sashiko AI reviews of this patch and of my sched/isolation patch [1]
both flag a race on the HK_TYPE_DOMAIN cpumask. I checked it against
the code. It is real in some configurations, and older than this patch.

Since commit a84097e625f2 ("cgroup/cpuset: Call housekeeping_update()
without holding cpus_read_lock"), housekeeping_update() replaces the
mask and frees the old one with only cpuset_top_mutex held. Its message
says that CPU hotplug can run in parallel. But
housekeeping_dereference_check() still accepts cpus_write_lock, or
cpuset_mutex, as enough to read the mask without RCU. _cpu_down() reads
it that way, with or without this patch:

  CPU 0                                  CPU 1

  write to cpuset.cpus.partition
    cpuset_update_sd_hk_unlock()
      mutex_unlock(&cpuset_mutex)
      cpus_read_unlock()
                                         echo 0 > .../cpuN/online
                                           _cpu_down()
                                             cpus_write_lock()
                                             m = housekeeping_cpumask(
                                                   HK_TYPE_DOMAIN)
                                             <preempted>
      housekeeping_update()
        rcu_assign_pointer(...)
        synchronize_rcu()
          CPU 1 is not an RCU reader
        flushes workqueues
        tmigr_isolated_exclude_cpumask()
          the !CONFIG_NO_HZ_COMMON stub
        kfree(old)
                                             cpumask_any_and(..., m)
                                               reads freed memory

With CONFIG_NO_HZ_COMMON, tmigr_isolated_exclude_cpumask() takes
cpus_read_lock() before kfree(old). That waits for CPU 1. So most
configurations are safe, but by accident. Without CONFIG_NO_HZ_COMMON,
nothing makes kfree(old) wait. The same holds when one of its two
allocations fails: it returns -ENOMEM before it takes the lock.

This comes from reading the code. I did not try to reproduce it.

A fix could make housekeeping_update() take and release
cpus_read_lock() before kfree(old). That waits for any hotplug reader
of the old mask, whatever the timer code does. It holds only
cpuset_top_mutex there, which comes first in the cpuset lock order. I
did not find a reader that holds cpuset_mutex without the hotplug
lock, but I did not check every caller. I can send a patch, if you
agree with that direction.

[1] https://lore.kernel.org/all/20261108185129.1549419-1-mathieu.desnoyers@efficios.com/

Thanks,

Mathieu
