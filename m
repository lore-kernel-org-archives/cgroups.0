Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794475197;
	b=3BkCILeJZHtJ/eFIUQ+OtmSdVZItpV4M2hac5wLZjmlftcnKSj0hojORAU1xGX05XtFt
	 leEcALyxL8ciGgBM8+9hYNWGVmNouBf6+73DEtlVsj+sUymAt6jIk5zsARgCmm20Mstv+
	 8x5fXEykeZkX0I4SMC48zsLNU0qtgSzvpPHXP8MdADgEthaEBtpMeDl768lMalD6r5kVP
	 GIafJCr6XOtZiRNP/Q03hsSI04mh88jSZ6z6jH2PMI3YQLVayIlEiuhARx+WK7LK+xfEn
	 kALpikuPZ9+9aKbxZzg17XDos2gmRj+HgvX33GI/r3rm+9Qwo3RBz8LNh9EUu+US2aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794475197;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BbdGJ+QfN/0a61vAo8i3jrwRHXo8FO9ut3fDr0zQx8s=;
	b=clmTaDxxFU91iQ7/CjUjn064c/Z3Wdy8Nh5ayuqLoxYn0OUqFRNu14fbHEikiaoe77u3
	 iX9niOoRGGDpPvCAxrCSWzWVD9eXEJtN6BZ5JUAiYU2KkGAyJ0gXZUd+XLurPXHRsmbG1
	 sy4XJR1kXeC0J4t5whEgHt4l+cF3q7AI4RmyjRtEAVI8YowG8mwFr29YWjG3ddWhpdeij
	 pgkR0aqDO3MF902i5dxB4l5/zrCQhXsImC5FWe++ZQcKb2cc5lGezNlVAWXJwnrllTYYL
	 BnkOmdZr3VK+iBCP1PgkGhdSoYtNrCoKqtPNFx4ZDYmHrvx0N9w8TVAfzccwg1nRFDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=G3nQzf9V;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=JtVRtgR2;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9880606A323
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 09:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9880606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=G3nQzf9V;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=JtVRtgR2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794475196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BbdGJ+QfN/0a61vAo8i3jrwRHXo8FO9ut3fDr0zQx8s=;
	b=G3nQzf9VeRZQYW6rJ6HF59qJk5ITceiEwG2f+AMxq3UujANFYXUKP+lFECb4Wh88auGg6s
	XVJ8Gb7TtoOYxLDnFxc9j80Y2LWmJ9/V3f5TOH4g82Ijt1HSfcPF7mvLQWV9dObL3jhwRz
	hvZhmqZMsBRcyFjOutq6ZWQs5nLK6Ew=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-goeCl-EKOSe63RGpk7DddA-1; Thu, 12 Nov 2026 04:19:54 -0500
X-MC-Unique: goeCl-EKOSe63RGpk7DddA-1
X-Mimecast-MFC-AGG-ID: goeCl-EKOSe63RGpk7DddA_1794475194
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4930269afdcso3238784f8f.2
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 01:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794475193; x=1795079993; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BbdGJ+QfN/0a61vAo8i3jrwRHXo8FO9ut3fDr0zQx8s=;
        b=JtVRtgR2C0SjBS1Nj2DD5s84wQoSkzDiW6g5tqequisbAdDADpoqtam+SxCak1N20E
         wsy31FYzdUXfK4cvt/kYHVBWjHvFFc8Ft8zxLIj5C/5YkbC92dNW5RprSKuL3QLMVnCL
         unTKKMI2fq/SZkMWT7qFhjAu8/Kk/MdJfC0HMrsHO8Xkx433zCkLrp61/tQycThCPLSD
         yBkPMLVncjib3/8E3Kwku3K0bBd9ilDcTs31lU9ye6UDKB8lsT72526F3Rpo8RfgT2vd
         jXNetE64RCurGtlKTvPAoyA6DdlKiXZZuGi2GjajKD7Xd//bsXXZnQJj8bv0EXuLVcgl
         0kbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794475193; x=1795079993;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BbdGJ+QfN/0a61vAo8i3jrwRHXo8FO9ut3fDr0zQx8s=;
        b=xMJRFTVIb7UyhGJM7Lm4m+n+O13AODJLui2UulpTzNf1W7xdHSXvUIwByiDPUt2tM6
         DjWADsrBeQ+sXGWKSr+kCx5+zPEgjtKQlWBZzwGPBV3Z2yfLnxqGCo8L1iLbi13KeDgR
         EOHqAVY+kVrj90yaFtoI3U6DMbni3NrfXLivm5TycmpTVriNedYZbr9qW0B7XU3CnbCE
         pAL7kSslkTjwYZDpxUvh5iDj7qTl3z2VzK4MwSgbOqq6gCAEqvfBYeXqXwgPOwZzt19c
         cWgI7OzvgAcAd9bci+9nOGp6kDldMleVg0wMW0LCUKMGSjsZzghTefPcAYBD+b0Ddg4j
         uolg==
X-Forwarded-Encrypted: i=1; AL+hErFbJX2V1DhnU+GqwYyQz/MguUhYP53FOFy6OqBbF3Igo3oCog3xT3z09LXWF4USa+gPl+p5I/CN@vger.kernel.org
X-Gm-Message-State: APuU4Z8uOuXx0yH+9AzDHRmStphOAOSZS3DC+YZub6/k262VRJtDdB+F
	r6nMfGdV1Y83bXvuAfdH0Jepz+C+fe4yHiEUE3y0fgQpTcbLZnwuXMThDC9p7C9H5JJZBzChBDV
	C5gg51unsYeBJNSG79CLWHcUc1NyDnG9r1xN0IPc4WHmJEaUy5fy0BzTMa1I=
X-Gm-Gg: AYBFou3DpJnu3sQePsZQJkJyqOK0M0Pg0XHn86EBn6Xx7x0EwSCr0HLvHxKf9lywrir
	bMxQLO6+lh4jFvo28Iz4JSxoAdf2HB3q5vY95zT4mHr3P5aO3T0XliJampobeHM20tXSulfvtsd
	tZeDrKbx4w+wnzUTydsQXMPEautzpzIMg1CXbr/QkQ5vbDw8Rs09WR44CDEbXYJPKrWdHuuQ68B
	jTLvfMJ0LFF+McfILiDvRUGrIgjP9JzVaX8TihldCjZFcRKi9l1BXY0cFB+CvTP3cshZa1p6bNa
	Xley5JiYwX9jMiH7AxMwIIJ+qETyksLunp5LT191/VsLBFk1qAVxwBKz539PXVcq2NbC08Q5KzB
	u8T67bbe2lGdhRw0s6XEd3vTSYSEvxsDAKr47sh0cOYcPkdeQEU0RynSJQWZo0Dq8Mx0LnanMCT
	LNaG4=
X-Received: by 2002:a05:6000:144b:b0:488:7496:15b5 with SMTP id ffacd0b85a97d-499c6f8c43cmr8114270f8f.47.1794475193437;
        Thu, 12 Nov 2026 01:19:53 -0800 (PST)
X-Received: by 2002:a05:6000:144b:b0:488:7496:15b5 with SMTP id ffacd0b85a97d-499c6f8c43cmr8114228f8f.47.1794475192931;
        Thu, 12 Nov 2026 01:19:52 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4988f5b1ce3sm13996822f8f.14.2026.11.12.01.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 01:19:52 -0800 (PST)
Date: Thu, 12 Nov 2026 10:19:49 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
	boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org, longman@redhat.com,
	ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, shuah@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, parri.andrea@gmail.com,
	m.szyprowski@samsung.com, kayracizmeci@gmail.com,
	weihengqiuu@gmail.com, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v5 20/29] cgroup/cpuset: Give back the bandwidth an
 attach did not move
Message-ID: <avWEta7b9X4K6hF7@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-21-mathieu.desnoyers@efficios.com>
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
Content-Disposition: inline
In-Reply-To: <20261108185406.1549770-21-mathieu.desnoyers@efficios.com>

Hello,

On 08/11/26 13:53, Mathieu Desnoyers wrote:
> Commit 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach()
> fails") reserves the bandwidth of an attach as one sum.
> cpuset_can_attach() adds up the bandwidth of the deadline tasks it
> moves. Once all tasks pass their checks, it reserves the sum in the
> destination root domain. If another controller refuses the attach,
> cpuset_cancel_attach() frees the sum. If the attach goes through, the
> move of each task uses its part of the sum.
> 
> But a task can change its policy, or die, before the attach:
> 
>  - A task that left SCHED_DEADLINE, or died, moves no bandwidth. Its
>    part of the reservation stays in the destination's total_bw, until
>    the next rebuild of the accounting.
>  - A task that became a deadline task has nothing reserved. The attach
>    still moves its bandwidth. The destination lacks it, and its
>    total_bw underflows when the task leaves.
> 
> In testing, a task switched between SCHED_DEADLINE and SCHED_OTHER
> while it was moved 200 times into a one-CPU partition root and back.
> On v7.4-rc1 with the patches before this one, the partition's total_bw
> ended wrong in 5 of 6 VMs with 8 CPUs. It kept up to two reservations,
> or wrapped below zero.
> 
> Fix this by keeping the tally of what the attach moves, in
> sum_moved_dl_bw. Flag the move of a task only if the rest of the
> reservation covers its bandwidth. Once the attach is through, give back
> what it did not move.
> 
> set_cpus_allowed_dl() decides the move under the runqueue lock.
> cpuset_attach_task() does not hold it. dl_task_offline_migration() can
> change the task's record meanwhile, for a task throttled on a CPU gone
> offline. So the tally counts what set_cpus_allowed_dl() reports in the
> affinity context.
> 
> With this patch, total_bw ended right in 6 VMs of 6. The random_mix case
> of deadline_bw_test, added later in this series, found the bug. It could
> no longer lower a fair server in a partition root with no room left.
> 
> Fixes: 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach() fails")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

...

> @@ -3285,17 +3299,28 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
>  	 * cpuset_reserve_dl_bw() made room in @cs for the bandwidth of the
>  	 * deadline tasks that cpuset_can_attach() counted. Flag the move, so
>  	 * that the bandwidth of this task moves with it.
> +	 *
> +	 * Nothing was reserved for a task that became a deadline task since.
> +	 * Flag its move only if the rest of the reservation covers its
> +	 * bandwidth.
>  	 */
> -	if (dl_task(task) && dl_task_needs_bw_move(task, cs->effective_cpus))
> +	if (dl_task(task) && dl_task_needs_bw_move(task, cs->effective_cpus) &&
> +	    cs->sum_moved_dl_bw + task->dl.dl_bw <= cs->sum_migrate_dl_bw)
>  		reserved = true;

Humm, this is identity-blind: it cannot tell a task that can_attach()
counted (its bandwidth really is inside sum_migrate_dl_bw) from one that
became a deadline task in the can_attach() -> attach() gap, for which
nothing was reserved, can it?

Say A and B, 50 each, are reserved for a sum of 100, and C becomes a
deadline task with 70 in the gap (can_attach() <-> attach()). If C comes
first in the taskset it passes 0 + 70 <= 100 and moves; A and B then
fail 70 + 50 <= 100 and both properly reserved tasks are denied their
moves?

Not sure if we can consider tracking the counted tasks per task? The
taskset is pinned between can_attach() and attach(), so we could build a
list of (task, bw) pairs at can_attach() and let the gate check
membership?

Thanks,
Juri

