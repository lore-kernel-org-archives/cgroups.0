Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B533BF300;
	Thu, 22 Jan 2026 11:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769082342; cv=none; b=AYb4Noh6s9bnkNST/tThjy6Oa2eoWigHvk7Gc3mAg/sh8TeJ6D4ThpcPH5t8QLMJXc96WyWxIeeVTEW+EW/SIs/RFxa48TBFLc0wLfj/AVcNjuhYWW+3cz8Qd96E2JPglYpcHuprkgzcTnOBvkGMQ7Xf/tXTF9TLh21G9F6Gv2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769082342; c=relaxed/simple;
	bh=EU05nC2RKuvOKEhcp+Aym37+YjQAdG1CjAsCKcp1BVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epu7KHHx4/J8AyH1Hu1L/yXR/329UMp4mRB9V78xTnSEHeLq+yo+ZEQMwtnfOGENGvJd5uqKB33FCB0ARmoJi9YXqKweN1TbAEFXZJs7MDBzJ01+3rx+c0M9JV4oEYJrBSfxvTJzfTY9SlliK8B+IOkw++7PKzK7zXmEPewlZ6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqXdCaE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqXdCaE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B2CC116C6;
	Thu, 22 Jan 2026 11:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769082342;
	bh=EU05nC2RKuvOKEhcp+Aym37+YjQAdG1CjAsCKcp1BVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UqXdCaE/0nQLDGNISwb8hH/Cdz4mgCPnaNvTeuG8gZ6LCmdIAIhk+bHpAfYkC/Sea
	 C5feqqcuWX7e/uT5pLotFr1zUh7gaft/dMYujEtfW1EQf96o6kr6NGkY0qMPJWAoCR
	 EdSfeizu3zw81RZPmx+iDdXYtXv3tF+fqqZyUFOD24FNBbUzHhJ+vBrVEPZjUFfhra
	 bnVm0VwzUStnUEJfXDiaSiEl/6zwfIjzmMBlg+QFmcyP0bzM7voac4XG4CsLOrPBSw
	 XnFwdm04l7z549qc31VaqoIOdpBvGO916Bship0u1yVKKf4PrPDRXl2QKNm3NelfPB
	 2PGKAxDXA38Cg==
Date: Thu, 22 Jan 2026 12:45:39 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, lujialin4@huawei.com
Subject: Re: [PATCH -next] sched/isolation: Use
 static_branch_enable_cpuslocked() on housekeeping_update
Message-ID: <aXIN45kR5_PQgtK2@localhost.localdomain>
References: <20260122080902.2312721-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260122080902.2312721-1-chenridong@huaweicloud.com>

Le Thu, Jan 22, 2026 at 08:09:02AM +0000, Chen Ridong a écrit :
> From: Chen Ridong <chenridong@huawei.com>
> 
> The warning is observed:
> 
>  WARNING: possible recursive locking detected
>  6.19.0-rc6-next-20260121 #1046 Not tainted
>  --------------------------------------------
>  test_cpuset_prs/686 is trying to acquire lock:
>  (cpu_hotplug_lock){++++}-{0:0}, at: static_key_enable+0xd/0x20
> 
>  but task is already holding lock:
>  (cpu_hotplug_lock){++++}-{0:0}, at: cpuset_partition_write+0x72/0x10
> 
>  other info that might help us debug this:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(cpu_hotplug_lock);
>    lock(cpu_hotplug_lock);
> 
>   *** DEADLOCK ***
> 
>   May be due to missing lock nesting notation
> 
>  stack backtrace:
>  CPU: 11 UID: 0 PID: 686 Comm: test_cpuset_prs  6.19.0-rc6-next-20260121 #1
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x82/0xd0
>   print_deadlock_bug+0x288/0x3c0
>   __lock_acquire+0x1506/0x27f0
>   lock_acquire+0xc8/0x2d0
>   ? static_key_enable+0xd/0x20
>   cpus_read_lock+0x3b/0xd0
>   ? static_key_enable+0xd/0x20
>   static_key_enable+0xd/0x20
>   housekeeping_update+0xe7/0x1b0
>   update_prstate+0x3f2/0x580
>   cpuset_partition_write+0x98/0x100
>   kernfs_fop_write_iter+0x14e/0x200
>   vfs_write+0x367/0x510
>   ksys_write+0x66/0xe0
>   do_syscall_64+0x6b/0x390
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>  RIP: 0033:0x7f824cf8c887
> 
> The commit 7109b22e6581 ("cpuset: Update HK_TYPE_DOMAIN cpumask from
> cpuset") introduced housekeeping_update, which calls static_branch_enable
> while cpu_read_lock() is held. Since static_key_enable itself also acquires
> cpu_read_lock, this leads to a lockdep warning. To resolve this issue,
> replace the call to static_key_enable with static_branch_enable_cpuslocked.
> 
> Fixes: 7109b22e6581 ("cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Thanks for spotting that! Funny that it didn't deadlock when I tested it.
Ah probably because I always booted with isolcpus= filled.

So ideally I should add your change as a fixup within
7109b22e6581 ("cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset") in order
not to break bisection.

Do you mind if I do that? I'll still add your Signed-off-by to the commit.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
