Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B553B2D39
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 12:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792414670; cv=none; b=WRk8z6hueG0JNpy7TwQ6hvl+3A/3SHZDQ6wVzfGPInYG8npWK6fTlcXzrGkZiCz7f5bk2BmFX/66dZu47AA7UXRz51JggcGX7QhT43uvFMb6fhBsqIw6v5ME+aTwrBWRwM7DqSwbvhx4J6t5khx9oi5olvoOTEoHhQGJWWKPCCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792414670; c=relaxed/simple;
	bh=w046RqlnctneZ8SARYX+vlfSsfJJViupwrW+GsN5Rgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUxmYmzkQ6hZ0V5Odg7YsNhsmOcRK7dw3LH+hfyl6XQ4jOeZCvga3vBbqnkjsHnjieq885RmxkRYu4xOU7qzLkFZrB02MpSkMU72bMvutZBTBvYnGsehaZgjm3uBPb1JYA1f6QMaPUQ/ZDZv6dpP+5usVBl+d9WLC6STR9CLjdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BqkNg0fH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BqkNg0fH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792414668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hRfvEtCLzTcglOUE0NGocUwOc/vYbOtviBwd3XYhKMk=;
	b=BqkNg0fHDyKDdl/xJHZrO+GaxFMoQOLPrg8pd+O4z6XSGHBHMTTJPD3t6L6wcl5vc+GgXS
	HzN0EPRcz1IUQJEINso5uTpf75BkoSG05YQZAqmHMCl+3fcRnSDX/GLS6L2vbzNVEupnH7
	yQAsYXfLviI70RGrhhwidyixOsPctQY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-310-efvPfy7BMFi2s6zVjB3iJQ-1; Mon,
 19 Oct 2026 12:57:38 +0000
X-MC-Unique: efvPfy7BMFi2s6zVjB3iJQ-1
X-Mimecast-MFC-AGG-ID: efvPfy7BMFi2s6zVjB3iJQ_1792414656
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B069E1954AC2;
	Mon, 19 Oct 2026 12:57:35 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id CDFA21955E76;
	Mon, 19 Oct 2026 12:57:31 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Mon, 19 Oct 2026 14:57:35 +0200 (CEST)
Date: Mon, 19 Oct 2026 14:57:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kir Kolyshkin <kolyshkin@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Serge Hallyn <serge@hallyn.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/2] cgroup: fix cgroup.kill for exited thread group
 leader
Message-ID: <atYTukAn0-7CAXmp@redhat.com>
References: <20261018-cgroup-kill-exited-leader-v1-0-c71ad94c20cc@gmail.com>
 <20261018-cgroup-kill-exited-leader-v1-1-c71ad94c20cc@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018-cgroup-kill-exited-leader-v1-1-c71ad94c20cc@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 10/18, Kir Kolyshkin wrote:
>
> cgroup.kill does not work in case a process' thread group leader is gone
> but other threads are still running. This is because __cgroup_kill()
> only walks the thread group leaders and sends SIGKILL to each of them
> with send_sig(), which uses PIDTYPE_PID:
>
> 1. The exited leader is still listed by CSS_TASK_ITER_PROCS as long as
>    the process has live threads, but a signal directed at a single
>    exiting task never takes effect: complete_signal() does not look for
>    another thread to deliver it to, and __send_signal_locked() now drops
>    it altogether.  The process keeps running.
>
> 2. The live threads of such a process can be migrated to another cgroup
>    by writing any of their IDs to cgroup.procs, while the exited leader
>    stays behind.  The destination cgroup has no thread group leader to
>    iterate, so writing to its cgroup.kill does nothing at all.

...

> Case 1 can be fixed by using do_send_sig_info(..., PIDTYPE_TGID) instead
> of send_sig(), so that the signal is taken by a live thread even if the
> task found by the iterator is exiting. Note it was pointed out by Eric
> in [1] while reviewing v2 of cgroup.kill patchset, and v3 was meant to
> switch to it, but the change was only made in cgroup_post_fork(),
> leaving __cgroup_kill() with send_sig().
>
> Case 2 can only be fixed by iterating over all threads, so this is what
> the fix also does. Once a thread group is being killed, its other
> threads are skipped since they already have a fatal signal pending.

...

> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -4289,7 +4289,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
>  	cgrp->kill_seq++;
>  	spin_unlock_irq(&css_set_lock);
>
> -	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS | CSS_TASK_ITER_THREADED, &it);
> +	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_THREADED, &it);

I guess this change alone is enough to fix both problems?

But even if I am right,

> @@ -4299,7 +4299,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
>  		if (__fatal_signal_pending(task))
>  			continue;
>
> -		send_sig(SIGKILL, task, 0);
> +		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_TGID);

I agree that do_send_sig_info(PIDTYPE_TGID) makes more sense.

Acked-by: Oleg Nesterov <oleg@redhat.com>


Either way, I am not sure about SEND_SIG_NOINFO. Perhaps __cgroup_kill()
should use SEND_SIG_PRIV? I dunno.

Oleg.

