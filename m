Received: from mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1985476F9
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 13:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082718; cv=none; b=RQl0ZKxGOSe02WvVax4RJu118igEbqy06owAOkRaL0ntnO0sUHq9cGo3dVFks9ryUJL+UZLtOz3DygmosEMwovQxVIup7XPHeDIB7XCM7wEVSls761YAe6R3v8rAdzYEi0731diXBYIS0bE821TPfnOGl7h/aKO5AYOnVsCTZh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082718; c=relaxed/simple;
	bh=wGfhs1JUoZWlzQjOG4m/OoSrn0nHg+mo1158dIosQAk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dT30CNrCkJVze8mPYU1s8gtbXh1ZM7SB+/pGMCmE7JVOnis+2qpjpWIwge4cMJuJgkSFYqWg1acVUf3jR4k17NW6rJTVoVbOBjY+W1u+ZSUlQ9XOBj63t0ZjfnG2vFlI3i5oACx2L9IWm5U1MGJiS3pZ7YVHY3Qm/r+LWOsvhGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nbW4g3rK; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nbW4g3rK"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wGfhs1JUoZWlzQjOG4m/OoSrn0nHg+mo1158dIosQAk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790082714; v=1; x=1790687514;
 b=nbW4g3rKdfWmRz3tODJTkXHyEhmxEKMFXjZtMMkhuNEoV/31BVSjlsDCQ6imVTupIrcpQTVQ
 OGlRgelbDtOgC0oALvX9eyucpf0K7rdog+OJY7G9800QL0MqsOsLt2KVjlC6QHYFmHGdDPR5Hrr
 Nre5CquD3FI/SMXe+pd/5o9E=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1857d476125c5e27;
	Tue, 22 Sep 2026 13:11:54 +0000
X-Mizu-Trace-ID: 1857d476125c5e27
X-Migadu-Flow: FLOW_OUT
Message-ID: <25b59080-42f7-4b2b-a488-db7c99d68c07@linux.dev>
Date: Tue, 22 Sep 2026 21:11:49 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, josef@toxicopanda.com, axboe@kernel.dk,
 ameryhung@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH v6 0/5] blk-iocost: BPF struct_ops cost model
To: Tejun Heo <tj@kernel.org>
References: <20260918055001.1273840-1-cui.tao@linux.dev>
 <e5656ccd4760f26772f5db86dfdea80a@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <e5656ccd4760f26772f5db86dfdea80a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Tejun.

在 2026/9/22 03:37, Tejun Heo 写道:
> Hello, Tao.
> 
> On Fri, 18 Sep 2026 13:49:56 +0800, Tao Cui wrote:
> 
>> The registration and binding model follows the TCP congestion
>> control model registration pattern: registering a struct_ops makes
>> the model available by its name, while io.cost.model binds one
>> registered model to a device with "model=<name>" and restores the
>> builtin model with "model=linear".
> 
> Alexei is right, this isn't what I meant. One struct_ops instance per
> device: attaching binds the instance to the device and switches the device
> to the model, detaching switches it back to the builtin. That removes the
> name registry, the lifecycle list and the refcounting on top of the
> struct_ops map reference. Putting the device id in the struct_ops the way
> hid_bpf_ops does works fine. I don't have a strong opinion on how the
> device is identified.
> 

I misunderstood what you meant by per-device.  v7 reworks this in the
hid_bpf_ops style: one struct_ops instance per device, with the target
device identified through the struct_ops instance.  .reg binds it to
the device and .unreg detaches it and restores the builtin model.  The
name registry, lifecycle list and additional refcounting layer are
gone; attaching a second model to an already-bound device fails with
-EBUSY.

>>     u64 calc_cost(u64 opf, u64 nbytes, sector_t sector,
>> 		  struct blkcg *blkcg, u64 model_flags)
> 
> Why not pass the bio itself? The model can read whatever it needs from it.
> The merge indicator still needs the flags argument as it isn't a property
> of the bio.
> 

calc_cost() takes the bio itself now, so the model can read the
operation, size, sector and issuing cgroup from it; only the merge
indicator stays in the separate flags argument.

>> blkcg is passed so the model can key
>> per-cgroup state; state stored in BPF_MAP_TYPE_CGRP_STORAGE
>> follows the cgroup lifetime, and optional blkcg_online()/
>> blkcg_offline() callbacks mirror the css lifecycle for models
>> which want eager setup or teardown.
> 
> With a per-device instance, these should be bound to the iocg pd init and
> free rather than the blkcg css. That gives the model the same per cgroup
> per device lifetime as the builtin cursor and drops the global mutex from
> the cgroup online and offline paths.
> 

Done: the callbacks are bound to the iocg pd init and free paths,
giving the model the same per-(cgroup, device) lifetime as the builtin
cursor and avoiding the global mutex in the cgroup online/offline
paths.

>> The completion-time request sizing for the
>> latency met/missed accounting still uses the builtin coefficients
>> (the request's bio, and with it the issuing cgroup, is gone by then);
>> extending the model there is left open by this interface.
> 
> Let's be explicit here. For now, the struct_ops should carry the transfer
> cost coefficients, vtime per page for reads and writes, and the builtin
> latency tracking and vrate adjustment should use these instead of the
> linear coefficients while the model is attached.
> 

The pricing paths now use the transfer cost coefficients (vtime per page
for reads and writes) provided by the struct_ops while the model is
attached.  This covers completion-time request sizing, latency tracking
and vrate adjustment, which no longer use the linear coefficients in
this case.  There is one remaining model call in the completion path in
my current tree which does not belong to this interface; it will be
removed in the posted version.

> Down the line, a model should be able to take over the QoS side too. The
> vrate adjustment is driven by an empirically derived table and being able
> to replace it is a good part of the value of a pluggable model. The shape
> I have in mind is an rq_done(struct request *) callback which disables the
> builtin latency tracking and periodic vrate adjustment, with the model
> modulating directly through kfuncs to set the base vrate and the
> saturation state and to read the block layer clock. That doesn't have to
> be part of this series.
> 

Understood.  The QoS-side takeover (rq_done() and kfunc-based vrate
and saturation control) stays out of this series.

> While a model is attached, the linear coefficients are inert. Coefficient
> writes can be stored and take effect again on detach, autop shouldn't step
> profiles based on vrate the same way it doesn't when the cost model is
> user-set, and io.cost.model can report the model in the model field, in a
> form which identifies it as a BPF model, with ctrl still describing the
> coefficients.
> 

Yes, coefficient writes are stored and take effect again on detach.
autop will only step profiles when no model is attached, matching the
user-set cost model behavior.  io.cost.model readback will report the
BPF model in the model field while ctrl continues to describe the
coefficient source (user/auto).

I'll send the reworked series.

Thanks,
Tao

> Thanks.
> 
> --
> tejun

