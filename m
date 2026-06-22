Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE972AD00;
	Mon, 22 Jun 2026 05:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782105734; cv=none; b=GC5Rvv04JijapjK3y0sFbn185sJKyKuFDlpxwhGOxwDoEUShVV9EvcqG6jg1wQE0s8niu+S2EQHfe77yIhkiYezb5VVM0TWMdbRafFnefQomx4fEET0X3s82bvTtJID45/d2Bbo2+DCCXsvbOZ/PgINaE+0k6Zr2Wv8fqwylLeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782105734; c=relaxed/simple;
	bh=TLqjtoxyQNBS4x+LOScCt7CwmrTyt3kjY6p33duqeE4=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=Ev/zTAYT7vazGoPoDRAYDe8Faj81Pf7zpbO73ibC6hSmt1pENNFvRiz8Xr1qWVczOdInpNCIw0Zg0Jxi/9NRnuf6AOv6bheQEBEozzhykDAIccQkihO4A5KMvIMoCAwvsmZCQWVD69UH5tfx3yEeuqOp0+AZ8HmoSjAtrVKEbug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPoPKF9k reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPoPKF9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378331F00A3F;
	Mon, 22 Jun 2026 05:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782105733;
	bh=IjSWiRWMU9Ee27IawNNdMZlcd+pdKiRJTFL+L2RHmwk=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=VPoPKF9kD8SQIQF6VNPVqYW4nAuqARtP874wgBw9ktl1VwB0bHFPLCbcXYj7HUMxH
	 Mj3NKz7moMW1j+SXZ5JmJDnOZXBZW5IRtgrf/R6VIt2WEKZCRvzJOEpijHbPfQq0b0
	 nm0TeCZgQXRR4HX/TRhbDsnY+V7xNwuVA9DRk2Y55c/zCXC+PjQS50Jq+EMuggkTRd
	 9oW5HaoUighBQ6x6uk8YcD6TgdtMpwCo25V+L/RnXeQZlOC/g45FDA5+g0tzRvIsbT
	 YyCpmQk1Wl7rkCzOR5GCrA3tMSulv6dAwtezT3ajTjhRDdDcAq0rBDJrWSlu6Ht97u
	 uxcDgxs29F2vw==
Content-Type: multipart/mixed; boundary="===============3341382443539626176=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <a431d311fb11ec06b89a5986cbacf2ebe983bdaddc4a93076564d83799471cad@mail.kernel.org>
In-Reply-To: <20260622042811.31684-1-kaitao.cheng@linux.dev>
References: <20260622042811.31684-1-kaitao.cheng@linux.dev>
Subject: Re: [PATCH v3 5/7] kernel: Use mutable list iterators
From: bot+bpf-ci@kernel.org
To: kaitao.cheng@linux.dev,paul@paul-moore.com,eparis@redhat.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,davem@davemloft.net,kuba@kernel.org,hawk@kernel.org,john.fastabend@gmail.com,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,dev@lankhorst.se,mripard@kernel.org,natalie.vock@gmx.de,peterz@infradead.org,mingo@redhat.com,acme@kernel.org,namhyung@kernel.org,mhiramat@kernel.org,oleg@redhat.com,oberpar@linux.ibm.com,akpm@linux-foundation.org,baoquan.he@linux.dev,rppt@kernel.org,pasha.tatashin@soleen.com,pratyush@kernel.org,naveen@kernel.org,jpoimboe@kernel.org,jikos@kernel.org,mbenes@suse.cz,pmladek@suse.com,will@kernel.org,boqun@kernel.org,mcgrof@kernel.org,petr.pavlu@suse.com,da.gomez@kernel.org,samitolvanen@google.com,steffen.klassert@secunet.com,daniel.m.jordan@oracle.com,rafael@kernel.org,dave@stgolabs.net,paulmck@kernel.org,josh@joshtriplett.org,frederic@kernel.org,neeraj.upadhyay@kernel.org,joelagnelf@nvidia.com,urezki@gmail.com
 ,juri.lelli@redhat.com,vincent.guittot@linaro.org,kees@kernel.org,bsingharora@gmail.com,anna-maria@linutronix.de,tglx@kernel.org,jstultz@google.com,kpsingh@kernel.org,mattbobrowski@google.com,nathan@kernel.org,martin.lau@linux.dev,song@kernel.org,mark.rutland@arm.com,mathieu.desnoyers@efficios.com,dietmar.eggemann@arm.com,void@manifault.com,rostedt@goodmis.org
Cc: audit@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,netdev@vger.kernel.org,cgroups@vger.kernel.org,dri-devel@lists.freedesktop.org,linux-perf-users@vger.kernel.org,linux-trace-kernel@vger.kernel.org,kexec@lists.infradead.org,live-patching@vger.kernel.org,linux-modules@vger.kernel.org,linux-crypto@vger.kernel.org,linux-pm@vger.kernel.org,rcu@vger.kernel.org,sched-ext@lists.linux.dev,llvm@lists.linux.dev,chengkaitao@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 22 Jun 2026 05:22:12 +0000 (UTC)

--===============3341382443539626176==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/kernel/trace/trace_dynevent.c b/kernel/trace/trace_dynevent.c
> index c4dfbc293bae..9e076106bee7 100644
> --- a/kernel/trace/trace_dynevent.c
> +++ b/kernel/trace/trace_dynevent.c

[ ... ]

> @@ -100,7 +100,7 @@ int dyn_event_release(const char *raw_command, struct dyn_event_operations *type
>  		return -EINVAL;
>
>  	mutex_lock(&event_mutex);
> -	for_each_dyn_event_safe(pos, n) {
> +	for_each_dyn_event_safe(pos) {
>  		if (type && type != pos->ops)
>  			continue;
>  		if (!pos->ops->match(system, event,

Does this leave the variable n unused? Looking at the function
declaration around line 74, it still has:

	struct dyn_event *pos, *n;

but after this change n is no longer passed to for_each_dyn_event_safe().
The macro now hides the temporary cursor internally, so n appears to be
dead code. This would trigger -Wunused-variable warnings and break builds
with CONFIG_WERROR=y.

For comparison, the sibling change at line 219 (dyn_events_release_all)
correctly removed the *tmp variable from its declaration.

> diff --git a/kernel/trace/trace_dynevent.h b/kernel/trace/trace_dynevent.h
> index beee3f8d7544..a4dc0812284f 100644
> --- a/kernel/trace/trace_dynevent.h
> +++ b/kernel/trace/trace_dynevent.h
> @@ -115,10 +115,9 @@ int dyn_event_create(const char *raw_command, struct dyn_event_operations *type)
>  /*
>   * for_each_dyn_event	-	iterate over the dyn_event list safely
>   * @pos:	the struct dyn_event * to use as a loop cursor
> - * @n:		the struct dyn_event * to use as temporary storage
>   */
> -#define for_each_dyn_event_safe(pos, n)	\
> -	list_for_each_entry_safe(pos, n, &dyn_event_list, list)
> +#define for_each_dyn_event_safe(pos)	\
> +	list_for_each_entry_mutable(pos, &dyn_event_list, list)


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/27930295027
--===============3341382443539626176==--
