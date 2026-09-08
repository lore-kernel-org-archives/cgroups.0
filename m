Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E6347DF85;
	Tue,  8 Sep 2026 21:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901416; cv=none; b=D/rrNNoAYJD2HVwpF5PO11zZ18y25ws+GPqLqjQ2mYm7Z/DXaYlnnzVPFMN0WWwledeyd06yfIFGB6sIMDKkzjU1rf22sKg9Dj1SFZQavCdF2ApWJhWrIdadQwV8HuJUJ0D/J3kn17LoFs1OHXbechmyvu+iU9ROf38LZ9c6ZWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901416; c=relaxed/simple;
	bh=rl/WelV0cCYJl1RLGKd2Pb4UEI2Tvq5bfyfRacbPMbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rpbpBwIbAtTMgEyhqtfiBj8aLyN9w/vEI/cad+Yf1KYMjqqmmu83rLeHrDgAoQGnahFzFEKkWIG0A6qQv/Fn2vdcsmlqkzQBSDGwmddEuw1B3AxaOjHiLE9sss7r7M16mCuXkQGg3dbN+rLC8QYvrv8Lsu9fumHqsgu+0ePIil0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P65WIT3R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P65WIT3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283F21F00A3D;
	Tue,  8 Sep 2026 21:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901415;
	bh=JZJjBYS6s6gnlUuYFtaOmSi33aTkdr2WdvogNR0qcbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P65WIT3RqLmbT5EvXl4LZ5I1h81g3JIlJvHsFZy0ejcFweqPoQPzbMiyDjjXuTbTd
	 8d4SNO2zkkyM/5XVqoRJND5jGkAburJ7Y063HyDY4kD1/VjcqDUByIrje7ZV0QROVe
	 S8lvnkxXdd6g5OjiS6YoPRJBZ0dxl6p58R80evplS3wE5zAGLfQhB3P7XlEotQMoLE
	 joqREhwbAB19xNVnIS5UiWDYGC3Yi3vbrMr9Df09KYLt2pZ/sAq4xpe/IytatiF5q0
	 oK9RStbTo/WESevMfwP2cT3wC/mQPESqF5fdRMpuVPFLWDWbGfSG/R3fnzJnxN8UJZ
	 bY2h/P+Vmldcw==
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject:
 Re: [RFC PATCH 2/8] blk-iocost: define iocost_model_ops cost model interface
Date: Tue, 08 Sep 2026 10:31:11 -1000
Message-ID: <178889947167.2.7544023096586414638@kernel.org>
In-Reply-To: <20260908100143.47598-3-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
 <20260908100143.47598-3-cui.tao@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello, Tao.

On Tue, 08 Sep 2026 18:01:37 +0800, Tao Cui wrote:

> +config BLK_CGROUP_IOCOST_BPF
> +	bool "Enable BPF pluggable cost model support for the cost IO controller"
> +	depends on BLK_CGROUP_IOCOST && BPF_SYSCALL && BPF_JIT

This also needs a dependency on DEBUG_INFO_BTF. Otherwise the option can be
enabled without the BTF required to register iocost_model_ops.

Thanks.

-- 
tejun
