Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFDC47CC6F;
	Tue,  8 Sep 2026 21:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901415; cv=none; b=aTtVzH12Ofnyxrk7aWFwKxSf7hcnotuib5YP+eUj0YD7uW6onecDFTydme2fMpnMWvB4c+rMQfGzPwVbAQb3h1SW+A5c8K6YyMvbfhHWTQ06CpN4rDOsMFJCVy6htH5xeBhqPLM60/CW/WBKkY6K4JvQIeP/ZGvpJY6RgbQwO0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901415; c=relaxed/simple;
	bh=nrE7XH+uaM1JjTkFkOPtdo6zHOHrdmFGk3KtBd1IkeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cAbe5WsbSUXl1HkZH78Yt3PxLOeSTr4VrMr914XsKiStnPMMvzO7cUWRZi7KWLRTnIgErEOMlVTpDPcuIE9lYTgKDvge8XwYQs6rHS+d7Jz6EPLZf2/PAsJEDwSIOUozUoVYODSPeT3vEz4h8eftwNWPAXAKYX53ujp9N4ai2N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nniMX7EP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nniMX7EP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312D21F00A3A;
	Tue,  8 Sep 2026 21:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901414;
	bh=K+Lnmiutk70KMR8EjJyDURKE0+snUfE8ZgReUTuPsko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nniMX7EPY9tlJcBNCixUzf80cOlraXFGA1wjDlTpgjiEQCVGcHwoJiTnlGnXzYUOx
	 9x6zCBkOv6/Ir0odgPUVRUMDjsa+OZZSSdoOmkN3H5pDyJZO1RRV2xJsF5dUvqynVx
	 CC7EMkklf0ZMBrtQ1Mdq4cywpTuyjfjjfntxH4KuudUDUZOxXg2R4VdcxWf4mTkz0w
	 geQEepzXpHNOAizyFT3dXfrTZT038TJBxvCNLxBQgMW6cm5aXxnQ38KFIfYKFH10wE
	 K10Ep81buLEXOFi6dAj8b4BzuwK1rlXIG72w6F8N3wxcRrM3n7hUlpHIaA8VA6Jigm
	 ruyPDS9w0VHvg==
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/8] blk-iocost: BPF struct_ops cost model
Date: Tue, 08 Sep 2026 10:31:11 -1000
Message-ID: <178889947167.2.14514677804554939704@kernel.org>
In-Reply-To: <20260908100143.47598-1-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello, Tao.

On Tue, 08 Sep 2026 18:01:35 +0800, Tao Cui wrote:

>  4. One model system-wide vs named models selectable per device (as
>     tcp-cc names are per-socket)?

The struct_ops instance should be per-device. Loading a model for a device
should switch it to BPF automatically. Switching back to the builtin model
should detach the struct_ops.

>  2. Per-cgroup state lifetime: iocg_id is the css id and is recycled
>     once the cgroup is removed, so models must treat it as a
>     transient key.  Does the interface need a release(iocg_id)
>     callback so models can clean up per-cgroup state instead of
>     detecting reuse, or is per-cgroup bpf local storage, which
>     carries its own lifetime, the better home for model state?

I'd pass blkcg as a kptr and add online/offline callbacks so the model can
manage its per-cgroup state.

> return value of 0 delegates the IO back to the builtin formula, so a
> model which only handles some IO types cannot make the rest free.

I don't think mixing BPF and builtin pricing makes sense, either per IO or
between charging and request sizing. It seems convoluted and error-prone.
Implementing the linear model in BPF is straightforward.

Please combine the interface, registration, dispatch and configuration
changes into one patch. These patches are small and implement one feature.

Thanks.

-- 
tejun
