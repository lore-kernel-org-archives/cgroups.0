Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792429295;
	b=sQ6vdRV7CaRRoAalDxBWFswBrBgsXOD90L1NxRrJ+V19rSzasdGQZ0Yw8XHZ6U5N7K9/
	 zGrme/0WHpIq039YIhQtA9REI61xLKI9PiNrKM3DFMExHdL4Hb3S7yw3dTy7aZBxjrQ56
	 1ES2aboSSqD4Zby6sb9hSlt9Fw8hHr9mqkdkdpHloHiaKIfdlh8+wxZRpHENdp0jUKt11
	 ark8QAn9XgGKVCpGXzRFckLTNX/ZZtUFky3O2Qo0lLXBgwN3ttqWXvMHm/mSIJQjLNQtI
	 y8bS/jF5cBCTnMhCCLUEjHxTCpLWD/2IrZ02bzZk3rHLGhg3k/EVesem+pr4GaM8zRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792429295;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=vsZoKkf/63QUUV+/hh6ioJr032KhsZj9uAMNX2Dlcog=;
	b=dt4+Q1etQtN1dU7NMILQ0lEQuYj5CP/AmIC9DgzzIRSVg8EtFVkiKTGfvIoH8GJL90px
	 cX7fzHEYB/evXzLooTfqfDL0pP7kWlvxMoiDQpJbNi4Nm5cQnUCYWdFTBMbLyPZm5pcq/
	 tsuVLL4JkHu3vRJ0hHtu7Agnk3b42y8a3705iugSHXDxoAD5VWcM46SCrVEuxGFMHN0mZ
	 ubz4PBhTIyh5tUyfjFkxGwn2wvf964W0Ai3RpeCeAn5tTatFoYzQKoj915GRVEJ5AZfQG
	 EFvvJQNmyubXNics1qD5F62AFbpxH5koAl6ZspKSoTlR+F/wgB1j7afSFj8LUoTErsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=Wn246gnT;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8649606A324
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 17:01:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8649606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=Wn246gnT
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a1d484b4a9so31137705e9.0
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 10:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792429293; x=1793034093; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vsZoKkf/63QUUV+/hh6ioJr032KhsZj9uAMNX2Dlcog=;
        b=Wn246gnTwfh2TzC8k33ec+ij+UvPi+cTRt5+AC3iJocK8F2YsNsSoalaPrwxIWl7+c
         P8FtEVVqwU2EKgkNs8INNsUw0+/Xj2JYXt1pviLzzUyN6iS9ImdhMcq0BNrDWcwX0if1
         nQMMg3nntIZX0aFnXPrl8Cruo/T6Kgzb/3iWlTE32oNYyoncov5Ci5AOVi686osgJ0y6
         rGc2eVoyXxOxyNBWjVgCcMEabE+/ioleKncMq23zM1uQjoe88+mqTbfxCMdY9xjeVOCl
         3AUpb0DjMw8CgNHzZz4r4Ydd+GHl2ysV9n2Dr4C9O2DSDzx2fEcVCmqiQtjEOPOnUMDz
         W16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792429293; x=1793034093;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vsZoKkf/63QUUV+/hh6ioJr032KhsZj9uAMNX2Dlcog=;
        b=hES7CE9v9ZB0fhzt8bB90I+SQ6safVHwviTpGp5gxFDduIB0McO3ookk+dvG3X6EUX
         UavC/V0c+OeWjO5ltqEWRG/WEOSAvJ5cgc1koJbqVnh3mbjZLxxs3RH4CVzlJfbGlF/X
         /peEbqAW11lIuP/VjyCGPRTsyrW/IFAHNfeTC4Y3uTzpk4/zYsR4/g8kTN96B1KeGscn
         TxjeQKonGlIvYjqB4NfCIT9J3Ar8E4RpYg434TgnmNIfaINssD0XYFybFtGSGYEuUnfG
         rBTi5vDCCXtgCMNpDfYVmEm1vZQ/ZixwxY2B0/rQ0KuN7fnC/QWtWULno1LoDGt2oMjm
         r87Q==
X-Forwarded-Encrypted: i=1; AKwUvBxz73iBvfAJmJwn76nlzm3hPNQD41rfN5KCkGyiQlGVFrnI7vwtCOaAtXtKuJqAZxGK5HmuwTA6@vger.kernel.org
X-Gm-Message-State: AFq9FYJgqPJKrcqds41lmjh+ewuxpjRr/fttVhi5XRLDFuPUqk1/ht6r
	Kw6qlDBQ2ZXAV6Y2JKwBaaOgmdXGYI9e77ryqwRhjERRjA8rZrFAEkTvuMnDJz5JxgQ=
X-Gm-Gg: AYBFou2MtNpsvwut0Lw6GbZ78BcpNWrV4L2rW9bzugJ57qej55Y8s8F+01BAWQoEDJg
	59Tw2I6JfE+0unLaQyRyZWLfuAdFDNz9F26xi06JTgFIFmHmI1nmsM1fRI8tUul4X8fSzJ7j16V
	HzjkrdR27rK9DGwCT7GPN10SFrNN6GYqvMSp2GaRvpXlM5ji8IkJkn3iKR76S6/StVjlArDU5Uj
	LeE/y4tpB+y+yqZn5rAZkv9T/WiX0JA2OO60vXVaeDWiWJuvqk8wvu8YCRiK75mE9Ut36W76Aly
	A/RQzuCT8TvAEgrPsxmgiuTus7gGcPycDBIzNWuu2kUeJ92NGTYB0FF2wyaQAc6C/NpWw3w3FPm
	xiH4xdPm4q9OMLg/tOe8ZAGRei3qIxPhXWsSFQo6fCkKj61zGKWztnUoGAL+5TIHL0w+5kmXBX0
	s0UyCvnidDXcz9DWcF9BV95zp8CdKGFmXXuIDNyAQvmtlnb6RjSO6FBT99fl+V2IyIrdJIXRb84
	LaBdU0SfSlL4kQb4Ts=
X-Received: by 2002:a05:600c:4e8a:b0:49f:ffd0:4039 with SMTP id 5b1f17b1804b1-4a1d763ca4amr165614635e9.32.1792429292723;
        Mon, 19 Oct 2026 10:01:32 -0700 (PDT)
Received: from vingu-cube ([2a01:e0a:11f4:3020:aea:8007:d7bd:c2c7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1ce325107sm241842155e9.3.2026.10.19.10.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:01:31 -0700 (PDT)
Date: Mon, 19 Oct 2026 19:01:30 +0200
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Mike Galbraith <efault@gmx.de>,
	Jakub =?utf-8?Q?Oko=C5=84ski?= <jakub@okonski.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
	longman@redhat.com, chenridong@huaweicloud.com,
	juri.lelli@redhat.com, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, jstultz@google.com,
	kprateek.nayak@amd.com, qyousef@layalina.io
Subject: Re: [PATCH v3 7/7] sched/eevdf: Move to a single runqueue
Message-ID: <atZM6uF0CqCNh__I@vingu-cube>
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org>
 <58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org>
 <b1002150c3e4f877d04790cd8e85d2149d17722f.camel@gmx.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b1002150c3e4f877d04790cd8e85d2149d17722f.camel@gmx.de>

Le dimanche 18 oct. 2026 à 08:49:29 (+0200), Mike Galbraith a écrit :
> Greetings!
> 
> On Fri, 2026-10-16 at 15:18 +0200, Jakub Okoński wrote:
> > Hi Peter,
> > 
> > On 6/5/26 14:40, Peter Zijlstra wrote:
> > 
> > > Change fair/cgroup to a single runqueue.
> > > 
> > > [...]
> > > 
> > > --- a/kernel/sched/fair.c
> > > +++ b/kernel/sched/fair.c
> > > @@ -9916,7 +9837,6 @@ static void wakeup_preempt_fair(struct r
> > >  	if (!sched_feat(WAKEUP_PREEMPTION))
> > >  		return;
> > >  
> > > -	find_matching_se(&se, &pse);
> > >  	WARN_ON_ONCE(!pse);
> > >  
> > >  	cse_is_idle = se_is_idle(se);
> > 
> > I think this changes how cpu.idle affects wakeup preemption.
> 
> My box claims this to be unrelated to the jitter you're seeing, as it
> is present in 7.2.11, with and without the sched-flat set applied.

Yes, we don't take into account whether the task group is sched_idle

Jakub, Mike,
Could you try the patch below ? It solves the problem on my setup

---
 kernel/sched/fair.c | 80 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0f2364479f9d..d17e88ad12a5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -433,6 +433,38 @@ static inline struct sched_entity *parent_entity(const struct sched_entity *se)
 	return se->parent;
 }
 
+static void
+find_matching_se(struct sched_entity **se, struct sched_entity **pse)
+{
+	int se_depth, pse_depth;
+
+	/*
+	 * preemption test can be made between sibling entities who are in the
+	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
+	 * both tasks until we find their ancestors who are siblings of common
+	 * parent.
+	 */
+
+	/* First walk up until both entities are at same depth */
+	se_depth = (*se)->depth;
+	pse_depth = (*pse)->depth;
+
+	while (se_depth > pse_depth) {
+		se_depth--;
+		*se = parent_entity(*se);
+	}
+
+	while (pse_depth > se_depth) {
+		pse_depth--;
+		*pse = parent_entity(*pse);
+	}
+
+	while (!is_same_group(*se, *pse)) {
+		*se = parent_entity(*se);
+		*pse = parent_entity(*pse);
+	}
+}
+
 static int tg_is_idle(struct task_group *tg)
 {
 	return tg->idle > 0;
@@ -476,6 +508,11 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
 	return NULL;
 }
 
+static inline void
+find_matching_se(struct sched_entity **se, struct sched_entity **pse)
+{
+}
+
 static inline int tg_is_idle(struct task_group *tg)
 {
 	return 0;
@@ -10129,7 +10166,34 @@ preempt_sync(struct rq *rq, int wake_flags,
 }
 
 /*
- * Preempt the current task with a newly woken task if needed:
+ * Preempt an idle entity in favor of a non-idle entity (and don't preempt
+ * in the inverse case).
+ */
+static bool wakeup_preempt_sched_idle(struct sched_entity *cse, struct sched_entity *pse)
+{
+	int cse_is_idle, pse_is_idle;
+
+	find_matching_se(&cse, &pse);
+	WARN_ON_ONCE(!pse);
+
+	cse_is_idle = se_is_idle(cse);
+	pse_is_idle = se_is_idle(pse);
+
+	/*
+	 * Preempt an idle entity in favor of a non-idle entity (and don't preempt
+	 * in the inverse case).
+	 */
+	if (cse_is_idle && !pse_is_idle)
+		return PREEMPT_WAKEUP_RESCHED;
+
+	if (cse_is_idle != pse_is_idle)
+		return PREEMPT_WAKEUP_NONE;
+
+	return PREEMPT_WAKEUP_PICK;
+}
+
+/*
+ * Preempt the current task with a newly woken task if needed.
  */
 static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_flags)
 {
@@ -10174,22 +10238,14 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
 	if (!sched_feat(WAKEUP_PREEMPTION))
 		return;
 
-	WARN_ON_ONCE(!pse);
-
-	cse_is_idle = se_is_idle(se);
-	pse_is_idle = se_is_idle(pse);
+	preempt_action = wakeup_preempt_sched_idle(se, pse);
 
-	nse = se;
-	/*
-	 * Preempt an idle entity in favor of a non-idle entity (and don't preempt
-	 * in the inverse case).
-	 */
-	if (cse_is_idle && !pse_is_idle)
+	if (preempt_action == PREEMPT_WAKEUP_RESCHED)
 		goto preempt;
 
 	update_curr_fair(rq);
 
-	if (cse_is_idle != pse_is_idle)
+	if (preempt_action == PREEMPT_WAKEUP_NONE)
 		goto update;
 
 	/*
-- 
2.53.0


> 
> > With the single runqueue, find_matching_se() is gone and se_is_idle()
> > reduces to task_has_idle_policy(). Wouldn't this mean that SCHED_NORMAL
> > tasks in a cpu.idle cgroup are no longer treated as idle for
> > wakeup_preempt_fair()?
> >
> > 
> > I tested my existing 7.2.9 desktop against 7.3-rc6 with the setup below.
> > cyclictest doesn't reproduce it because it just sleeps and wakes, no CPU
> > burn and therefore its accrued EEVDF lag keeps the latency low?
> > 
> > cc -O2 -o wakelat wakelat.c
> > systemd-run --user --collect --unit=spin -p AllowedCPUs=7 -p CPUWeight=idle sh -c 'while :; do :; done'
> > systemd-run --user --collect --wait --pipe --same-dir -p AllowedCPUs=7 ./wakelat 1000 15 200 |
> >   mlr --inidx --ifs space --opprint --barred --right label lat \
> >     then stats1 -a count,p50,p90,p99,max -f lat then rename -r '^lat_,' \
> >     then put -q 'emit mapsum({"kernel": system("uname -r")}, $*)'
> > systemctl --user stop spin
> > 
> > wakelat wakes on a fixed 1 ms schedule, records how late each wakeup
> > was, then busy-loops for 200 micros (wall clock).
> > 
> > +-----------+-------+-----+-----+------+------+
> > >    kernel | count | p50 | p90 |  p99 |  max |
> > +-----------+-------+-----+-----+------+------+
> > >     7.2.9 | 14998 |  11 |  11 |   12 | 1869 |
> > > 7.3.0-rc6 | 13853 |  11 |  12 | 2029 | 2116 |
> > +-----------+-------+-----+-----+------+------+
> > 
> > count is out of 15000 periods. rc6 had 1147 wakeups delayed by over 1 ms.
> 
> Thanks a bunch for the proggy. I've been looking for a clear signal
> with various loads, and stuffing wakelat+awk into one of my scripts
> provided a perfectly clear signal, which I bisected and confirmed.
> 
> Note: below is box pointing it's little silicon finger at the source of
> aforementioned jitter, not necessarily at breakage.
> 
> Reverting the fingered commit removed the jitter from 7.2.11, and force
> reverting 68e37487810a + 333238da9a19 removed it from master as well.
> 
> 333238da9a193ffc58792995f3e951e4cb87bfd2 is the first 'bad' commit
> commit 333238da9a193ffc58792995f3e951e4cb87bfd2
> Author: Vincent Guittot <vincent.guittot@linaro.org>
> Date:   Fri Aug 14 15:52:41 2026 +0200
> 
>     sched: Update time before requeueing delayed entities
>     
>     In order to compute the right lag, it is required to update time to 'now'.
>     Without this, the delayed entity might appear younger than it really is and
>     receive less compensation for having waited.
>     
>     Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
>  kernel/sched/fair.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
