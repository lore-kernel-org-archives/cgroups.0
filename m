Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218171;
	b=R5e/rx9I7EM4YpRNqe5tuDkFnf3Iy1DP3Q7p3LxBrmIALw7tl9ZR1ScUD2tviXrVXnHq
	 Ax2zryUGn4w+UBLi+jxufU4KkQ/rY6x4tTuhEQMeQ/Rb5VP5jekcmR8ZaaTs4a6aX2fR1
	 1LwQEUKUXVUKfuh26eVytgOMFH9Oedm8uw6ps6Rl9Sz0xQdpNxKul2n9JfXljBN8stXnM
	 59LhdLYznwzsQIZSr2AdjamscLW/OUnL1O8huKr/1FZQsJHIZA9mIs/zGB/cVqFqye51a
	 D7EMxyHwANA0nTQyCwjg2m5FSMq9wklkk5hK4h4BM3H1ztBGLdz5cfuuGe+DU5rv4jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218171;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=mnMiENV9iiGt5Ln0FNczg1dR/kUQWH9k/F5fEuPMClk=;
	b=zuvrGEHhw8B02Rjh5vYzlFzCk0XveTv9E4Bn8HExKmG6gpOxkdK43HlrpdEH9BQC/FE0
	 TK3oALwS+LjXOMMBAGiV/n9y47vL7kFGgMW9ewXwYGgbmo18TKoXr5c0i1d/2SdeVAsIU
	 X9JCyiRfHIvKybQUzRshI6OBpd/l7pcaMXeitfSj2OUZ349vjudtLt5Zy3L6PA4pgnf8Q
	 1yeYA1zN0yllhfFOI+oYYx2mHunwdj84vaZ7qnWK3NfLCgomjbJXYVcjbNxnWQ+GYC06d
	 MenmOEAZuIR4Drc1nL2B79TzrpY6O7C7yuPsZQR0G2aMmxvTZY7Yk90GA/GBf80N6CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oTSD4Zo2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE0760A380C;
	Wed, 28 Oct 2026 20:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oTSD4Zo2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F051F031E3;
	Wed, 28 Oct 2026 20:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218171;
	bh=mnMiENV9iiGt5Ln0FNczg1dR/kUQWH9k/F5fEuPMClk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oTSD4Zo2w9t8c3fEkQn+OjxBiMTcap9YffNtM9g68PkMRPpqe3StRXHBW/HCV8Sp3
	 bCGJv5xTjZ9rwEbCfGa0OLYOyTiqYBpTf8dkRm1Fhfa6OiCvM7WWv+N8tcriAV3FTa
	 vekLoxcxqxeqApO82N/gWA1+KgMdnQAq1INkupPZP1WksJjUKbt8JBQSlgGvH4Zl0V
	 6owXpV3jVX9MKCZo7fs1vlaMl4Tcug+FcDphL0CPagufhTjj3JLAMUP6cYmIKUasvg
	 EIk5ZUCGN540Ic5IdysaJnlzaMFOYgZXNjfzDR9+4KWcTg6z1YpQHQkgpzJxdMaxRJ
	 nhvURshNGgeSw==
Date: Wed, 28 Oct 2026 10:09:30 -1000
Message-ID: <75384a99148fbd477e003453718b1717@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [PATCH 4/5] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
In-Reply-To: <20261028143534.135968-5-cui.tao@linux.dev>
References: <20261028143534.135968-1-cui.tao@linux.dev> <20261028143534.135968-5-cui.tao@linux.dev>
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

On Wed, Oct 28, 2026 at 10:35:33PM +0800, Tao Cui wrote:
>  		u64 vdone, vtime, usage_us;
>  		u32 hw_active, hw_inuse;
>
> +		nr_active++;

nr_active is counted even when the tracepoint is disabled.

> +	/*
> +	 * Everything the tick reports is final here: busy_level was just
> +	 * computed, cur_period hasn't changed, nr_active and usage_us_sum are
> +	 * complete, and vrate and period_us still hold the values this period
> +	 * ran in. usage is wall time over wall time, summed over iocgs, and is

An io.cost.qos write in the middle of a period changes both period_us
and vrate.

Thanks.

--
tejun
