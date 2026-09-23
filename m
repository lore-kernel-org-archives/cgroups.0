Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4C439A7FD;
	Wed, 23 Sep 2026 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790179674; cv=none; b=kd6cMsYWxSBDkQKW6OVNBFIB8tgDRYtXqekMUsdOjl4k8FgcXCG/MIuuhfG/sBX2YjDK2X3f1WofRmpksBYYOBZdL6DBFOkTA4fb3zxDWGeOv5j16H5J9kYGCrxMxwJaK/cFdyzLqHQiepg84dR7R6xDg9y8zRJ87VYte4iylRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790179674; c=relaxed/simple;
	bh=euLSbnq+m/aBAj4e1zXIld0AwlOk9H+SofHbW8ygS3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c2IogYQwQQAcXhyX28CiOiTM8y2StkM+BvS9RHOgXUaLhaN/bo3Ne1S1cmv24GFntkWyTdOeY8z5/57Xvn820W4KT6fWuvR46JiDObRsFAmEftx/p1MCAHxNCESweyoaXTfaOBsoqVUX34FyTCU8I5NxoWn/T0t01fL8lqZPYmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZSrSEvAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZSrSEvAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9131F000FF;
	Wed, 23 Sep 2026 16:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790179673;
	bh=s8h+i8TI8RVhGqbKMBXf4PsT3ZH7LCuWakUEtizm3gM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZSrSEvAs1VbM0BqeBHEqAEdLWNVfD0BuLnotK0z5Ovaj60GTCWoW5Hx4Wv+S8P5iP
	 mNrIo6x13zNHEDXVSj6hfpXENUcoDbORVrLs3kgu+4McEsxgfQ8K9IJZdXDPsneGSX
	 WWT2+p4Kk8MwXJTnoa01U8sHJhJ3uL032AcQURPwbv6ltV1nlvdQ+ELR/jisUZOftG
	 GQZI+wuQq7fuI+Bfn/XfxEcwzp1cl97Gcac3/5L2nYHdghEtnjMLWvTy+aZ1OHq53s
	 z6qd7rzEk52+k+klpJNq7t6Cy8Fg59QiUtaBF6jKc4XN/Ktcl5EHBRrPwh4GNEfb8Y
	 S49aGzAJdoDSQ==
Date: Wed, 23 Sep 2026 18:07:50 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Jing Wu <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Tejun Heo <tj@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH v4 07/11] tick/nohz: add runtime tick_nohz_full_mask
 update for CPU isolation
Message-ID: <arP5VgdUIUykJRik@localhost.localdomain>
References: <20260710-wujing-dhm-v4-0-2e912e5d9645@gmail.com>
 <20260710-wujing-dhm-v4-7-2e912e5d9645@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260710-wujing-dhm-v4-7-2e912e5d9645@gmail.com>

Le Fri, Jul 10, 2026 at 11:28:18AM +0800, Jing Wu a écrit :
> When kernel-noise isolation is requested for a CPU at runtime via a
> cpuset isolated partition, tick suppression must be activated on the
> affected CPU without requiring nohz_full= at boot.
> 
> tick_nohz_full_mask and tick_nohz_full_running are currently set only
> during boot by tick_nohz_full_setup(). There is no runtime path to add
> or remove CPUs from the full-dynticks set.
> 
> Add tick_nohz_cpu_isolate() and tick_nohz_cpu_deisolate(), both called
> with the target CPU offline (between remove_cpu and add_cpu in the
> hotplug cycling path):
> 
>   tick_nohz_cpu_isolate(cpu) - lazily allocates tick_nohz_full_mask
>     if it was never set up at boot, sets the CPU's bit in the mask,
>     sets tick_nohz_full_running, and calls ct_cpu_track_user() to
>     activate per-CPU context tracking so kernel/user transitions
>     suppress the scheduler tick.
> 
>   tick_nohz_cpu_deisolate(cpu) - reverses the above: deactivates
>     context tracking via ct_cpu_untrack_user(), clears the CPU's bit,
>     and clears tick_nohz_full_running when the mask becomes empty.
> 
> A per-function mutex guards the lazy allocation and running flag
> updates against concurrent isolation requests.
> 
> Co-developed-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Signed-off-by: Jing Wu <realwujing@gmail.com>
> ---
>  include/linux/tick.h     |  4 ++++
>  kernel/time/tick-sched.c | 45 +++++++++++++++++++++++++++++++++++++++++++++

tick_nohz_full_running is essentially a duplicate of
~housekeeping_cpumask(HK_TYPE_KERNEL_NOISE) and tick_nohz_full_running a
duplicate of housekeeping_enabled(HK_TYPE_KERNEL_NOISE).

Perhaps those two variables should be removed?

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
