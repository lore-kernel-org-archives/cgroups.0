Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC57599A43;
	Fri, 16 Oct 2026 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792173000; cv=none; b=FsVhNILpihLRFDWigmeQqPi45DEzBahdPXlZRSxOlKk/12A1k9bT4V9+e/yOjUuRR5D5ikidrQKM52WOmBtvIq070+/4jBL4Mw0xHYiumIm7WwTD3NkJmomizXxni9Pgy099TdxCPFayfNA3nfF9Ktpe1TbWHv6VJCTmF47wjQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792173000; c=relaxed/simple;
	bh=sU4pZhbT1lb+nddSv3Vgs9evB7fIVdFzKSbtU/yz+Ig=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=poLehVPlGEu9E2r5vIThbco+p3JyiwlIhr0FqYu1ewpdW9QBV4vb0f6SpcLAVopMrGii3NaF0ttRZJSQqXeJT/UygPboOqI2N6lVoDcFfKKETufdv5UpnX0X9+/TE6y3UODylzhumETlKZC4zPz/4riYyH19o+fVe4ngJCXC6ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSpb6G4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSpb6G4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7701F000C4;
	Fri, 16 Oct 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792172999;
	bh=xZAgAHLdYRRI5hQx62O9uzg561Z0UyCRFefGSVMPztc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bSpb6G4rhiiKoVfyTfkTKOPs7nQOnArsPl/jclUJSS1MOTcMcisEcHtAYktKC/ewL
	 ol3u8VwnvBIU985ghi6jVLGYTqlpKGANX/9vxIg/Ma8cERZdGPN6+sCfY3HClZXfRR
	 HzFJrIXo62WIR1le20BRrW5V0hw9uAFyZ9M11wTvogI9kfBAUixCVN1XlUw7l0F39t
	 khTyRRQyniMoNMg+cTkj3Oo+M7BmPO76Kw7QQ3jbRMF8pzcL6Z7LfMxDPtO1QafyWK
	 3LS6siXOk+DCPQq+rHulXNljc7VSlSbQ4UTQl1K3WFpCuRejkchIGCD6EL/XuTkEdg
	 L3e7NkUNm96Uw==
Date: Fri, 16 Oct 2026 07:49:58 -1000
Message-ID: <eae39daec12cf6f121cc5010574a6c03@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v10 4/4] docs: cgroup-v2: document the iocost BPF cost model attachment
In-Reply-To: <20261003124045.1289305-5-cui.tao@linux.dev>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
 <20261003124045.1289305-5-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Tao.

On Sat, 03 Oct 2026 20:40:45 +0800, Tao Cui wrote:
>  	  model		The cost model in use - "linear"
> +			or "bpf" while the BPF model
> +			is in use

"linear" or "bpf" is enough here.

> +	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, a BPF cost model
> +	can be bound to a device by attaching an "iocost_model_ops"
> +	struct_ops carrying the whole disk's major:minor in its "dev"
> +	member (a partition's major:minor is rejected).  Attaching
> +	creates the controller if needed, like an io.cost.model write
> +	does, and
> +	switches the device's pricing to the model; enabling and

Attaching now also populates the device's line, so the existing sentence
saying the line is populated on the first write to "io.cost.qos" or
"io.cost.model" needs updating. The paragraph also runs 21 lines with a
leftover break after "does, and". Can it be split into three, attaching,
model= selection and detaching, and removal and ctrl?

Thanks.

-- 
tejun
