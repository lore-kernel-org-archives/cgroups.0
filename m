Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AD037F756;
	Tue, 29 Sep 2026 00:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790642544; cv=none; b=Hsebo1nBFrSaJwDfiLr2mGTllsYfz9kmX5l6MwJv04CS3Xoc5nO7qejrYZVwd4tyYzttrdynjqnfLhDxDLj2WfLPdDPNInLWgDZ1hClLtGgaxgJQEzfdX5HWvHrcHwUW04YXR7BGm4wJIAro1+lJyr8LTF5M3vA6gHLWbbHWsAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790642544; c=relaxed/simple;
	bh=iCOr47U1US0/MzlD0PEVg5YWbbJbDs9iH7rvb52PWbw=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hd8YJX+TaLKV8XPWtd9MAoygAax6ivBS3UaKoBYxw3a48HmnKI+97lvQZsMQlVBy33YJx/HwdenZX84QriP9pzsXDn4UkxfM1/7flMouBXqZoxS91TqpRKRjusbWgAl28wjznQuLbB0Hy6hMPUifNgIA7uYr5S3cuJtcCmndw6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=be7GGEM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="be7GGEM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FEE1F000FF;
	Tue, 29 Sep 2026 00:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790642542;
	bh=iCOr47U1US0/MzlD0PEVg5YWbbJbDs9iH7rvb52PWbw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=be7GGEM6Gl1Zuj3OlinDUbWLUmeCcdNKEx5toCqJYB9aeYM6dKP8qbqlORDsSE+j1
	 tqwafD+QS8OOeuqL+FPqOWuyOTf49NTAl8jTgWKchv+yJxeETx+ErUBorIrk+35Upd
	 bdz4qjUPFE2blHqILxrTOc4wAIbh7oBRMj7PS88twyB4/PAVpOqWfmRNFwDIhOpPCB
	 oVCw+sypwR5/z8U5HZjOZgP6dvQIRtEUkmWI42/YKnubwR3/a4Vxw5LD+HDnEsyLpS
	 IhEsviAFBPst6JTsMRzVRosD6h4iBGODO1dzRmew96dyv4v+NcqSHeCk/PkaDnCvkg
	 KD911IalsgrXA==
Date: Mon, 28 Sep 2026 14:42:21 -1000
Message-ID: <6f80eca83c87b60398110c3a6d735aec@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v7 0/4] blk-iocost: BPF struct_ops cost model
In-Reply-To: <20260924054549.2271705-1-cui.tao@linux.dev>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Tao.

On Thu, 24 Sep 2026 13:45:45 +0800, Tao Cui wrote:

> loading attaches the model to
> that device and switches it away from the builtin linear model,
> detaching the struct_ops restores the builtin model, and the
> struct_ops core owns the program lifetime.

I don't think attaching should enable the controller. v7 currently turns
it on without the queue freeze and quiesce that ioc_qos_write() goes
through. Attaching can create the ioc if needed like an io.cost.model
write does and switch the model under the same freeze and quiesce,
leaving enabling to io.cost.qos.

This is different from what I said on v1, where switching back to the
builtin model detached the struct_ops, but with the controller state left
to io.cost.qos it seems more consistent to keep the attachment independent
too. Writing enable=0 or model=linear wouldn't detach the struct_ops,
model=bpf would switch back to the attached model, and only detaching
would remove it. This is the same as the linear coefficients, which are
kept while the BPF model is in use and take effect again when switched
back.

> iocg_init()/iocg_free()
> callbacks, invoked from the iocg policy init and free paths with
> the same per (cgroup, device) lifetime, let models manage their own
> per-cgroup state.

Existing cgroups don't get iocg_init() on attach and iocg_free() isn't
delivered on detach, so init and free don't pair up. Can you call
iocg_init() for all existing iocgs on attach and iocg_free() for the
remaining ones on detach? That's what sched_ext does with
ops.cgroup_init() and ops.cgroup_exit() on enable and disable.

> Writing "ctrl=bpf" or "model=bpf" is accepted as a no-op so a saved
> configuration still parses; re-attaching the model requires loading
> the struct_ops again, not writing to this file.

ctrl keeps describing the coefficients and never reads back "bpf", so
ctrl=bpf shouldn't be accepted. model=bpf should fail when no model is
attached.

Thanks.

--
tejun
