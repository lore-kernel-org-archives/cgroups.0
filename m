Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC83A18DB35;
	Wed,  9 Sep 2026 06:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934214; cv=none; b=Bg7Cjly/T1EKWGd8syD6/MY0DGHvcJeSogQPO1eZ2GaKa2bswGMJupDx3d029Vcrh5LlZ0n32IaCPLa01wL0SYC1Mw7D+Vhhhe7JDKojEBVZEWnLwtjMS7gjyILO8EOmQkz4MjRYfXvopTMsQ0OT+/RwbLea/ScB3U0JFx5uV6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934214; c=relaxed/simple;
	bh=iLvK5koVMLb2qPO/VCWjVuq/8qm2q0mgWBFwM3kwN2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkGZuZO5tknZ1aJ9LmcjlHOEP9d3LC9XjAhIIyV5S2FLlrR+Exbe5Mw1bWjoC5lLjX1B7beMDpjbAoelel570ZE5jQbSPLX8fVCusI9YBWJjjXxdis9qpdcLlWeyY1bXooPrBTiCQdrkOKzQv4IxOTaDBbWdotC2hmmCTYy/mY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=qWyMGqcf; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="qWyMGqcf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=CQ
	f10nkRRln1bJkiOeszGQ9fnPOoBo5zbMRzixDC9+E=; b=qWyMGqcfa1rgV8E7oh
	Z69rlWXSQaREsNy8FkIoTClFEKJj226i/HeSzt/qqxt0NWGnHxXdLKKt0wHvtAO9
	skn3T1ASgbwLsEnPcCq+nJOmfpdFPFOYn7fPaDnL6SB5tqb0JuqKBheOtPoV1zpi
	pxL7QVr5yzJsTki5stJSA1hQI=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wBnI_Tq96BqwDFYBg--.22927S2;
	Wed, 09 Sep 2026 14:08:43 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: John Stultz <jstultz@google.com>,
	Tejun Heo <tj@kernel.org>
Cc: Hui Su <sh_def@163.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: Account cgroup CPU time to the execution context
Date: Wed,  9 Sep 2026 15:08:43 +0900
Message-ID: <20260909060843.2524877-1-sh_def@163.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CANDhNCq5iPq87=iKSJv-XzYzTYJ8Hp+bPJ6SoVfWB3pRa=HypQ@mail.gmail.com>
References: <20260904034707.268416-1-sh_def@163.com> <appnKwylGK3QUIJ3@slm.duckdns.org> <CANDhNCq5iPq87=iKSJv-XzYzTYJ8Hp+bPJ6SoVfWB3pRa=HypQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnI_Tq96BqwDFYBg--.22927S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ary7tr4DGw1xZFyxWFyfJFb_yoW8ur18pa
	nYyw1DtFn5JF4fKF4xCw4jqa4ftw4Syrs8tFWDJ347Ar13GFyrGr1IkrWUCF9rJrs3ZF1q
	vw1F9FyI9anFvwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRo89ZUUUUU=
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6gz7W2qg9+xSYAAA3l

On Tue, Sep 8, 2026 at 10:17 PM John Stultz <jstultz@google.com> wrote:
>
> I believe I'm ok with this if you are. Commit aa4f74dfd42b ("sched:
> Fix runtime accounting w/ split exec & sched contexts") was trying to
> allow the owner's cputime to make sense in top, but we still want the
> donor to be "donating" their time, so I thought the compromise of
> charging the donor's cgroup would make more sense. I'm imagining
> something like the cpu bandwidth controllers, where it seemed like the
> donor's cgroup is who we'd want to charge, and eventually throttle,
> even though it is donating time to the lock owner to run (since even
> if the lock owner's cgroup was throttled, proxying will let the donor
> "bust" through the limit and run the lock owner using the donor's
> bandwidth - up until the donor's bandwidth was exceeded).
>
> But if it is causing trouble for the accounting, and you think it
> makes more sense the other way, I'll trust your judgement.
> Tentatively:
>    Acked-by: John Stultz <jstultz@google.com>
>
> Eventually I think we'll want to track per-task "donated" and "gifted"
> time so folks can more finely distinguish the accounting.
>
> thanks
> -john

Thanks John and Tejun.

One distinction that may help here is that this patch only changes the
cgroup CPU usage accounting performed by cgroup_account_cputime(). It
does not change CFS bandwidth accounting.

Under proxy execution, update_curr() still accounts CFS bandwidth
through account_cfs_rq_runtime() on the cfs_rq associated with the
scheduling context. Thus, the donor's scheduling bandwidth continues
to be consumed as before; this patch does not change the bandwidth or
throttling behavior John described.

The change here only makes the observable cgroup CPU usage accounting
follow the task that actually executed, in line with the per-task,
thread-group, and cgroup user/system accounting.

The donated/gifted accounting you mention sounds useful for exposing
both sides explicitly, but I agree that would be separate follow-up
work.

Thanks,
Hui

