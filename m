Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AEC498902;
	Tue,  8 Sep 2026 21:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901420; cv=none; b=WsWAyBju9SmDLZMNShU71GOUlCdUT6oX/ViU3n6wxWKSWG7j7kugmCqA8X8A5mYyv0i5xr1iKIC2ucg3Jcl1BJ649S3kxvbHJGmYUlkBYqq3z3B3UXLbwy+RN+lSoEJ4FuXE1dzqVnNNEh3aaerUO4yrhHRdXOszEmQWiBpY4JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901420; c=relaxed/simple;
	bh=3u0sNfVeBUbjtpCOp2l68rc/BwvPcvmOZ6+L/efVB2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OhCVyvl6/Zdmaunq7lxQSyEWOXtso1PER4NTJEgHUala00adPp6LejZTx9chKmZFC18+7kjK2hEht8xRLOcxXiUVy2lLj/y4eecOWnOMvOFIPLmHdTNJcXWDheJL4D9n8gxt2JNtO8f9KzoTUzxhz187Bxbh1nnHDX4mnZf9cKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yfw9Ck3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yfw9Ck3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094DB1F00A3D;
	Tue,  8 Sep 2026 21:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901419;
	bh=t9njwTP72vKSRE3t2HaF/JIP9chd+DAuBEqbAv0V03Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yfw9Ck3cd1cLyRFRL/tmI2yVaR/S990t2FoIzz0E5nIOW8pEhY2tM3tAoLIlzz19U
	 Pcr4Gj6CfGvIkqrfLvIL1usgZYNcOtqzb+CEy1Y8eRBQX25V94lgrMwmXoEpWzkJ+m
	 6+C4XTaHiuXIHDVq/xzvmlnbe2WBz/01H5lgkIRD7hf+vbnEaV5V1Hx+lPaQBwtnWK
	 Cs1Jvr/G5om/0wFEH2kAB1MG+jUAfqWLQ4lcnZgvmqbhBirxuMdR/1G3PIR91tKZ0s
	 VkBJSZklm9DJ6oasKui6TFMn5lCQRMXcPXEqoHNIMg3rLRv1ml9Cn1HXYXUvr09Zqm
	 KNZXvcrxUJKvw==
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 7/8] selftests/bpf: add multi-stream sequentiality
 example model
Date: Tue, 08 Sep 2026 10:31:11 -1000
Message-ID: <178889947168.2.15328144500557108713@kernel.org>
In-Reply-To: <20260908100143.47598-8-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
 <20260908100143.47598-8-cui.tao@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello, Tao.

On Tue, 08 Sep 2026 18:01:42 +0800, Tao Cui wrote:

> +	if (flags & IOCOST_COST_F_MERGE) {
> +		base = 0;
> +		goto out;

Please advance the stream position for merged bios too. With 4K IOs, a new
request at sector S sets expected to S+8. A merged bio at S+8 leaves it
there, so the next new request at S+16 is priced random.

> +		s = bpf_map_lookup_elem(&stream_tab, &iocg_id);
> +		if (!s)
> +			return seqio + RU(nbytes, IOC_PAGE_SIZE) * page;

Once the 64-entry map fills, every new cgroup receives sequential prices,
including for random IO. Please note this limitation in the example.

Thanks.

-- 
tejun
