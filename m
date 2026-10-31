Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793473121;
	b=kH9NIJWSSevwnrPJyGbkeWv+oUzbO0QXjQQzfacnWRACIPtN6NjPajsR78njQtoSjnhB
	 0jU8mQi7Q6bXAOx+ztgArXXY1Emip+QOc4L63ZKqNpUUOKVwe6r1tFDoiXIXBMUE78nA8
	 qVz+v+ytEub0d+IODHkBWFAUWQ/deZbXW1atdU5lK7khieFikZCYc7TGr6F9iKV3Lrz4x
	 rUsmft4rwD7lkj2Im4SGhKmeaGM+nBivGOzQ/NlZ0L2TDdV4uqZQwmnM0LOdLcQkwsgSK
	 GH/UfDspqwcScEAaSAv8Ga3ZaZLDHpn2fbfLWGkUBgywVSryiqrEz92vOFWa9B4TDcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793473121;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WTXPO9m21ChhSJhJsMR1jm9N3k/S9PtVs0GDOD3AsIY=;
	b=tp2HFMc29y8Bd3tYyZPBI/IL/MuOuTZOBo2Eu2gUz9Z3ZdHj6CfDRXhvHXJ9AjQqD79L
	 VTc8uo5vcgKob7l89sskkGUGJbEnfoErsN/MTs0DdgO9e2PyQwIe5DQFt9sCJFoi6Qcfy
	 3ijnyN0Dn6G9zYVDgcspCwSjFESyjy4t1EApW0NxxZt65yteSElZHOlvhqsAqVY+ATcN9
	 7o0OPAsnh9o1JHwlYk5rh9bVFINcpmkm+y+bqevWCFiN8RL2Lp4CqrxSvtarBMhab1wML
	 ltfloAkh6reFSUr9eleT0QfbBCYoDtbYSXdfCgKnKT9flYrrDf74naelGk1Ek3Q0AHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FgLPquBt;
	arc=none smtp.remote-ip=91.218.175.80
Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5F6606A31A
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 18:58:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B5F6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FgLPquBt
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nhn60L6iDcU1tEzuh3dkIqEoHLNq1R18VibAiPoFZc4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793473113; v=1; x=1794077913;
 b=FgLPquBtbge3POVC+2Dr8m+4QENK0dVztMZkqUikUBrZvJtE6H91VKKswJxIsBJL67pY6Jz9
 6g8qzsLTfA9LttvrY33jPtsEM+SjPu1YN01qWSJr0tzgcny6phbIpfbk016/wYEPf6rRAq9FOJQ
 UmOda5mSHbWZxP2yJv5ZIimA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d88e81d4557f9af7;
	Sat, 31 Oct 2026 18:58:33 +0000
X-Mizu-Trace-ID: d88e81d4557f9af7
X-Migadu-Flow: FLOW_OUT
Date: Sat, 31 Oct 2026 11:58:31 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowangio@gmail.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, 
	linux-mmc@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost_task: do the return-to-userspace work between work
 items
Message-ID: <auY57Gu5NBtLWKoY@linux.dev>
References: <20261031181004.4193627-1-shakeel.butt@linux.dev>
 <20261031141506-mutt-send-email-mst@kernel.org>
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
In-Reply-To: <20261031141506-mutt-send-email-mst@kernel.org>

On Sat, Oct 31, 2026 at 02:15:40PM -0400, Michael S. Tsirkin wrote:
> On Sat, Oct 31, 2026 at 11:10:04AM -0700, Shakeel Butt wrote:
> > A vhost task is a user worker: a thread of a user process that runs only
> > kernel code. It never returns to userspace, so it never runs the work
> > that is queued for the way back. resume_user_mode_work() does that work
> > when TIF_NOTIFY_RESUME is set. For a vhost task this means:
> > 
> > - memory.high is handled at the wrong time. When a charge goes over
> >   memory.high, the task counts the pages, and should reclaim, and sleep
> >   if needed, on its way back to userspace. A vhost task only reclaims
> >   when more than a batch of pages has built up and the charge can block.
> >   Then it reclaims and sleeps in the middle of the charge, maybe while
> >   it holds a lock. vhost-scsi, for example, can fault in guest memory
> >   while it holds vq->mutex. If the charges can't block, nothing is done
> >   at all, and the count keeps growing.
> > 
> > - Block cgroup throttling never runs. blkcg_schedule_throttle() asks for
> >   it, but only resume_user_mode_work() acts on it.
> > 
> > - Task work queued with TWA_RESUME, like a deferred fput() or a NUMA
> >   balancing scan, waits until the task gets a signal or exits.
> > 
> > io_uring workers had the same problem, and io_run_task_work() calls
> > resume_user_mode_work() for them. Do the same in vhost_task_fn(): if
> > TIF_NOTIFY_RESUME is set, call resume_user_mode_work() at the top of the
> > loop. That is between work items, no locks are held there, and the task
> > is running. Passing a NULL regs is fine, io_uring and KVM already do it.
> > 
> > This covers every user of vhost_task_create(): the vhost workers and
> > KVM's NX huge page recovery thread.
> > 
> > Tested in a VM with a version of tools/virtio/vhost_net_test that puts
> > each RX buffer on a new page, so the vhost worker faults in, and
> > charges, 256M while its cgroup has memory.high=64M. Before, all 285
> > calls to __mem_cgroup_handle_over_high() came from try_charge_memcg(),
> > inside handle_rx() with vq->mutex held. After, all 589 came from
> > vhost_task_fn(). memory.peak stayed at 64M, and the run took about the
> > same time (0.66s before, 0.67s after). A lockdep kernel showed no
> > warnings.
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Is this different from:
> 
> Message-ID: <AS8P251MB00012469E6ECBEA2B7D87BB0C86C2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>

Oh wow, it is same but somewhat for different reasons. I am fine that patch, I
will comment on it.

