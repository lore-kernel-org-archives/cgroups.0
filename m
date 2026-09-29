Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E38B52B1D3
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 13:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790689153; cv=none; b=OwFUSih4zha3q1RQxDJGN3IqNVCn5GcdFs6bLDzPDXhBV0jKwAL1OH7C6txjyp5r3j/y+/I3k8EAEBKf1XVmkoU/SSFwaOybY6e7eO9x04EMPTYbf/QlUMzNAphyZmX0DxcTL0ENprKqWeOJu7y36xycROvtJm3Ph30dtTZ5CSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790689153; c=relaxed/simple;
	bh=p0HopqRbmThSdHTCdVhwQwUjMsWdv84GVBnYu35sdLQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Nmt1kLlEUsTz8Ybhn9TM+1D8RFugyDGrvwX6n+m6p2nUA2dowtIbddjbQwWaYbHLeJcvw1H1bkm6wTqhEVEgTvyBAtc9/f5UIdZa5MYrSv1eb8htgZatuBMfvjkPwiqdAyaS7FvJ/jNPbTysJC1Qj3Sd53/ZZt/u2YHNTaBoC5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eOZQiVso; arc=none smtp.client-ip=91.218.175.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eOZQiVso"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=p0HopqRbmThSdHTCdVhwQwUjMsWdv84GVBnYu35sdLQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790689148; v=1; x=1791293948;
 b=eOZQiVsooQobzNEYBrZz8JvKpe2lnq36dZZFAwBPG26qKrOJDdy03BgJQYBMFG4hxmZfhyTD
 3UO1JCJ0DTdsojyKgqNBlh0Wzj+yFDcYkQZb9oEt36g1sbgZhXSzNEDP+kKJRaAx8TukXejdK4B
 QXfeFug0RB7rP1EKTNVdUFUo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fd0607d5a2665ee1;
	Tue, 29 Sep 2026 13:39:08 +0000
X-Mizu-Trace-ID: fd0607d5a2665ee1
X-Migadu-Flow: FLOW_OUT
Message-ID: <4f1571a1-7e56-4264-aa7f-8dce32931ddb@linux.dev>
Date: Tue, 29 Sep 2026 21:39:00 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>,
 ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v7 0/4] blk-iocost: BPF struct_ops cost model
To: Tejun Heo <tj@kernel.org>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
 <6f80eca83c87b60398110c3a6d735aec@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <6f80eca83c87b60398110c3a6d735aec@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Tejun.

在 2026/9/29 08:42, Tejun Heo 写道:
> Hello, Tao.
> 
> On Thu, 24 Sep 2026 13:45:45 +0800, Tao Cui wrote:
> 
>> loading attaches the model to
>> that device and switches it away from the builtin linear model,
>> detaching the struct_ops restores the builtin model, and the
>> struct_ops core owns the program lifetime.
> 
> I don't think attaching should enable the controller. v7 currently turns
> it on without the queue freeze and quiesce that ioc_qos_write() goes
> through. Attaching can create the ioc if needed like an io.cost.model
> write does and switch the model under the same freeze and quiesce,
> leaving enabling to io.cost.qos.
> 
> This is different from what I said on v1, where switching back to the
> builtin model detached the struct_ops, but with the controller state left
> to io.cost.qos it seems more consistent to keep the attachment independent
> too. Writing enable=0 or model=linear wouldn't detach the struct_ops,
> model=bpf would switch back to the attached model, and only detaching
> would remove it. This is the same as the linear coefficients, which are
> kept while the BPF model is in use and take effect again when switched
> back.
> 

Done.  The implicit enable and the wbt_disable_default() are gone.
Attaching now checks disk_live() and creates the ioc under
rq_qos_mutex, like blkg_conf_open_bdev() does, and switches the
active model under the same freeze and quiesce sequence as the
io.cost.model writes.

To make sure I understood correctly: attaching switches the active
model to the attached BPF model, while model=linear and model=bpf
only switch between the attached model and the builtin model without
affecting the attachment itself.  The attachment survives enable=0,
and only .unreg removes it.  Please shout if I still got that wrong.

>> iocg_init()/iocg_free()
>> callbacks, invoked from the iocg policy init and free paths with
>> the same per (cgroup, device) lifetime, let models manage their own
>> per-cgroup state.
> 
> Existing cgroups don't get iocg_init() on attach and iocg_free() isn't
> delivered on detach, so init and free don't pair up. Can you call
> iocg_init() for all existing iocgs on attach and iocg_free() for the
> remaining ones on detach? That's what sched_ext does with
> ops.cgroup_init() and ops.cgroup_exit() on enable and disable.
> 

Done.  One note on the implementation: the existing iocgs are walked
over q->blkg_list under q->blkcg_mutex, the same walk the blkcg
policy teardown uses, rather than over the cgroup tree - this is a
per-device walk and the queue is frozen and quiesced at that point.
Cgroups without a blkg on the device yet are not missed: their blkg
is created later and ioc_pd_init()/ioc_pd_free() deliver the
callbacks then, so init and free pair up either way.
>> Writing "ctrl=bpf" or "model=bpf" is accepted as a no-op so a saved
>> configuration still parses; re-attaching the model requires loading
>> the struct_ops again, not writing to this file.
> 
> ctrl keeps describing the coefficients and never reads back "bpf", so
> ctrl=bpf shouldn't be accepted. model=bpf should fail when no model is
> attached.
> 
Done as suggested; the bpf-ci review of v7 reported the same two.

Thanks.
Tao> Thanks.
> 
> --
> tejun

