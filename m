Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218172;
	b=hRudOfgTkMbRbAezHyTwlW3eXNl6o9d7mMXh/Mp6fbqNykeGv4sjd4G7BsbDov2Ra7S+
	 fsHiFtw3YvyXtiTSl1ZgzxZmuoXDnlHJBrG3nH1x0s5NSITr9Gq2BnN5PXBjCwGfeGiP3
	 qbUQQea9F9UZiZRDaWOz49AWW/qlmCy/UkaOy+bAGyFjtL+fsIyW6Mjq8I/C4KbudH3Mr
	 RtFe2LikNXtm6OQRvzB5ZkdaHGLsKXojE7/IIympyjgX1qWcZlYgpu10dSHtKYqM/douP
	 hR02cQ/w7Gz6w+vjAnof8/wq51flh4MHVZQ/4wgdj20vh0E/wqzpPAyKWh9dqmm2k/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218172;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Y9prV6WuIi15Ykaoy1sEEO6x+8TCFI9Z8BWNg0g0Ywk=;
	b=2wNocvp8hrFdtADf8lYBgppPZGx21wOmgOfGEfgVue8It1wbNCL2zI9JSDkWzuFyUQcB
	 sXyDhaaM3G+lutP19LjKK2c8shLX75TQ1EUIAOH620Cwf7VxhuhimLY4PPVCUivSRK22u
	 DQROE4qX9/8cVuOTLIt1lju3JzpapxAG4ISmuvPsLlg8jMeyDSxPGEhD1H9zoAtnU46uY
	 L3J6+SWeDjCumsQJmMr3Kp7TAIyE4K0EGsCtnhL3EXcWaMhz4dkn6hh3tZsUfoEEbryWJ
	 SCa9swOMQgopdZShYSYEe22DYqP7vRCQJXl5vnZWAZtFwhQsV+JgiORLaYv97hs+Ocg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="WND6t1/j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D1260A3820;
	Wed, 28 Oct 2026 20:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WND6t1/j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4ECD1F01829;
	Wed, 28 Oct 2026 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218172;
	bh=Y9prV6WuIi15Ykaoy1sEEO6x+8TCFI9Z8BWNg0g0Ywk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WND6t1/jTFscSVNiNiVqFI+25ygKV43rBTw/IGzypSYvTe95dJR8SahVRynocJz6s
	 IJme8Tw+bnsZrayFVEW9e/VCfLhvsXlE3jsnYpM7xzoAgfiinqstsy/fdVL7hEidlX
	 ey4HcPH5A4Q6oRiAihCsRSxcGo27G7yJXQg6Sj9M/kHUGjYDznI9fyLcAWy2AGc7er
	 8K2JehtT03S1rIasywLfEZEeS9QQYmmczaXqBM53X4HEH5MGRXpJR5k4YNVaYs0VI9
	 NfGWP8hL2r3gR+K/tPfXUC5H86uJLwLcTChcka8RBIZfc44QgUktahYa5jvvglMI1v
	 YSLmq2+fp7B5A==
Date: Wed, 28 Oct 2026 10:09:31 -1000
Message-ID: <72deb196d0dfc413a48f0739013bc610@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [PATCH 5/5] docs: cgroup-v2: document the iocost BPF cost model attachment
In-Reply-To: <20261028143534.135968-6-cui.tao@linux.dev>
References: <20261028143534.135968-1-cui.tao@linux.dev> <20261028143534.135968-6-cui.tao@linux.dev>
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
Content-Transfer-Encoding: 7bit

Hello, Tao.

On Wed, Oct 28, 2026 at 10:35:34PM +0800, Tao Cui wrote:
> +	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, a BPF cost
> +	model can be bound to a device by attaching an

Users can't select CONFIG_BLK_CGROUP_IOCOST_BPF.

> +	Only detaching removes the model, after which "model=bpf"
> +	fails and the device prices with the builtin model again.
> +	Device removal ejects the attached model as well, while the
> +	struct_ops link remains until userspace destroys it.  "ctrl"

"Only detaching removes the model" is followed by "Device removal ejects
the attached model as well".

> +	accepts only "auto" and "user" and never selects a model.  It
> +	keeps describing the builtin coefficients, which take effect
> +	again when switched back.  The automatic profile stepping does
> +	not switch profiles while the BPF model is in use; as with
> +	user-set parameters, the profile selected from the device
> +	class still applies.

cgroup-v2.rst doesn't describe automatic profile stepping anywhere else.

> +	defined.  They remain readable and writable while "model" is
> +	"bpf" but take effect only after switching back to "linear".

The builtin coefficients taking effect again after switching back is
already said above.

Thanks.

--
tejun
