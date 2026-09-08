Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FB5486BBA;
	Tue,  8 Sep 2026 21:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901418; cv=none; b=flWOC2OgxZNQ0OUyfsi8NmovXYel0ONEE8bdFoPfHD14BHCMFyP4LtRGjnJgpVmFLiMfRcA6llGeGkJQ/IzeQBaEpPHyBoIbFdpZcWcUyajrXmSAlWQuKnX92GF2zt1iCxZ/Zt6IVb7PpFUlKatPUaOzZvCe7JqXeNJraqXhXo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901418; c=relaxed/simple;
	bh=Uv9BUuKdOHwKtitU1A2LN8pShA9XzVMAomxGgSpfV/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nEdjqcPfGxPXXgiP2EVCgJh7KbD8vA4QYeJ6fXYogbfWiPwa1NKTwPpGt9pzyr+b3FUnzLtdy2Gt2SoRUWaEdQY2vvx1O0H/p207j8zU29rh7hhsGcdj2g9xJZ96Ur4rOKAdg9tN8C+DV/DjgTlLv6C4l92twXIGIHAO8PnEF+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWhAWEOS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWhAWEOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182C81F00A3D;
	Tue,  8 Sep 2026 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901417;
	bh=SSKA7iWZ9ilk1jqKiGIP1AqhqMfphe75pbl/x/QioAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWhAWEOSLVE5oNWRrQ/WDH6T8XAYLXTERHwzJx7RtLb3fLl6My748/VMKnHosKRq4
	 nJqSl+wPINFsnbMYNnsBhZ3U/xhmXH46npo+4jJCOAs+HGPeIQOV6RHv9wroEDmY3b
	 VGeLUoSsIXZUlR5awefLJp2lwe8inFWQan+H++4WUN3V575H/WOvd8M3kbknuldk3g
	 lprdvtQAyDtPAfXzm3RvhZhju45CouEBOy9h0hls/+9LdOze6qdPBnxB+5ryNMO+j5
	 VFdWMHKdL0jjthF2OAnMvJU+t5IQ8GCb/7EfqA6Fub/eksXEj/6wknWKR3nDo1Vg/6
	 DnFreSsAuRSbA==
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 4/8] blk-iocost: dispatch cost calculation to
 registered BPF model
Date: Tue, 08 Sep 2026 10:31:11 -1000
Message-ID: <178889947167.2.14929031776522673392@kernel.org>
In-Reply-To: <20260908100143.47598-5-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
 <20260908100143.47598-5-cui.tao@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello, Tao.

On Tue, 08 Sep 2026 18:01:39 +0800, Tao Cui wrote:

> +		if (iocost_bpf_calc_cost(bio_op(bio),
> +					 bio->bi_iter.bi_size,
> +					 bio->bi_iter.bi_sector,
> +					 iocg->cursor,
> +					 iocg_to_blkg(iocg)->blkcg->css.id,
> +					 is_merge ? IOCOST_COST_F_MERGE : 0,

bio_op() drops REQ_PREFLUSH and REQ_FUA, and the flags argument only carries
merge status. Please preserve the operation flags.

Thanks.

-- 
tejun
