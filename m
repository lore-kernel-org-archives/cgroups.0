Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4013911C0;
	Mon, 21 Sep 2026 19:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790019436; cv=none; b=PvKdYK4gjFaB6CWQU+zT6RnSxqmViM8Wn+dktDcL3RZoze+PLzyz/0m85Y1IZBmY+Fq+qytd54z5g5CfTOcBx2094btToaQAXjaIUyhDwVDVzzwYdmrt48aeUS6W3CBZ4/18BdJTp+jRQptO2D6xskr8RAzyFIJM56mOroDKe2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790019436; c=relaxed/simple;
	bh=QwZCsT1DORnDWXFIR/vQs043enX7Vq2qJtZWdwbEMpc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UpZ9JAI//nrCsGwnlP4K6YGAMSq/2XXdsmqT9JltwxSMZN4Fn/c+/H2Rmo1dAVt3ZN5Y10GJXkc9p8n69J2A8QfrPAqkp2HdZmB/4nqLQXsOhqUHVKcU637/LDS/ICx9bJNIgQ9VQ2jKrFgwQuemn5PH8c46zMlhD259p5TsUxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bjs6E4uv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bjs6E4uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11841F000FF;
	Mon, 21 Sep 2026 19:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790019435;
	bh=niXzpMSw8m+T314eCpbts0SigBo4L6YAB5X+H9i6fL4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Bjs6E4uv6+9Tk/Bl84AErOExrdTESlCqnVehotVYm1zm6Xu+ZZ/cB0n/Mj5urjSpn
	 QeynM1bUUWrK55mOJ2E8GAFK9xPA0GDSo9xOQZa9RT3MB2bSLkJz8kBhNXdXI/T0qI
	 VSGM7acr7UpBb+7xIULQvqc/7DTfA/BUpvE5g8dJ+rq5mAdGTb1arY+/onZzbCmr7x
	 xe4nO08qUOq6t4gKTxQO7R4yE4JA6j5JSbYB/05rAt1ZGEh6lS9lsiZ8F15cffe2ED
	 FPuCFKM1P8mhidOIcmKn0C53vPo2GcYFdaxrYRCHYLDPw42ngIgWKp0sdrHqvc2Z9x
	 ElQP5pMPrpGig==
Date: Mon, 21 Sep 2026 09:37:13 -1000
Message-ID: <e5656ccd4760f26772f5db86dfdea80a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 ameryhung@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH v6 0/5] blk-iocost: BPF struct_ops cost model
In-Reply-To: <20260918055001.1273840-1-cui.tao@linux.dev>
References: <20260918055001.1273840-1-cui.tao@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello, Tao.

On Fri, 18 Sep 2026 13:49:56 +0800, Tao Cui wrote:

> The registration and binding model follows the TCP congestion
> control model registration pattern: registering a struct_ops makes
> the model available by its name, while io.cost.model binds one
> registered model to a device with "model=<name>" and restores the
> builtin model with "model=linear".

Alexei is right, this isn't what I meant. One struct_ops instance per
device: attaching binds the instance to the device and switches the device
to the model, detaching switches it back to the builtin. That removes the
name registry, the lifecycle list and the refcounting on top of the
struct_ops map reference. Putting the device id in the struct_ops the way
hid_bpf_ops does works fine. I don't have a strong opinion on how the
device is identified.

>     u64 calc_cost(u64 opf, u64 nbytes, sector_t sector,
> 		  struct blkcg *blkcg, u64 model_flags)

Why not pass the bio itself? The model can read whatever it needs from it.
The merge indicator still needs the flags argument as it isn't a property
of the bio.

> blkcg is passed so the model can key
> per-cgroup state; state stored in BPF_MAP_TYPE_CGRP_STORAGE
> follows the cgroup lifetime, and optional blkcg_online()/
> blkcg_offline() callbacks mirror the css lifecycle for models
> which want eager setup or teardown.

With a per-device instance, these should be bound to the iocg pd init and
free rather than the blkcg css. That gives the model the same per cgroup
per device lifetime as the builtin cursor and drops the global mutex from
the cgroup online and offline paths.

> The completion-time request sizing for the
> latency met/missed accounting still uses the builtin coefficients
> (the request's bio, and with it the issuing cgroup, is gone by then);
> extending the model there is left open by this interface.

Let's be explicit here. For now, the struct_ops should carry the transfer
cost coefficients, vtime per page for reads and writes, and the builtin
latency tracking and vrate adjustment should use these instead of the
linear coefficients while the model is attached.

Down the line, a model should be able to take over the QoS side too. The
vrate adjustment is driven by an empirically derived table and being able
to replace it is a good part of the value of a pluggable model. The shape
I have in mind is an rq_done(struct request *) callback which disables the
builtin latency tracking and periodic vrate adjustment, with the model
modulating directly through kfuncs to set the base vrate and the
saturation state and to read the block layer clock. That doesn't have to
be part of this series.

While a model is attached, the linear coefficients are inert. Coefficient
writes can be stored and take effect again on detach, autop shouldn't step
profiles based on vrate the same way it doesn't when the cost model is
user-set, and io.cost.model can report the model in the model field, in a
form which identifies it as a BPF model, with ctrl still describing the
coefficients.

Thanks.

--
tejun
