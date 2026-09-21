Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7623AB285;
	Mon, 21 Sep 2026 19:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790019437; cv=none; b=nPsGJzfTyduMS+f5dGPZFf8Jy9UN3brRnuyCPJXjZ3q/CH/c/JHh2e24TVW9oeVOy/QU85eTjiNbvbmTxWQkCne80VbS6ejmNoHUp5DmpNrAQENENqOwy6MotRi4+Dl2l8R/BH+nf9Y3cGjKm7o0hwee38BbgyJiaQckH3AZHOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790019437; c=relaxed/simple;
	bh=bjtvupucEyb/Lj+tMZY1BxWruj7KXDijzJrlHWmBV1Q=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iLAaUmPo6RDvDVrYU1mSvTFj5Rc53Xy5qa2BlXrZM7jEHZvkbH6e6+oXgKIoxdVv4cfMvSK5FrNedrI3Gy9GfEBBxap/MiZOtoiJYcFQZ92rPrNLH5fC0ItvQAW2s56F8Ib+NVKuQi7ajs0WrYOeCXwyFLWo3c2azzbZALxc0Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RAzZx6Zy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RAzZx6Zy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF79B1F00898;
	Mon, 21 Sep 2026 19:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790019436;
	bh=ySzWx1xSQBsNp+c9aoHmykOTuTGRcZG9S6R1gGtJWhs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RAzZx6ZyrY+ItF5e6rOMHjxYj4h0Kp25Q+doLBaIJd8OL5PTuBzV2sk2detBwS5PZ
	 OQTIh7C7M4xhwff6WTEoZwZ50x+jWI8jQL/iAnB5SsMTdMgKC4U4MW5aV+xyiglf2P
	 MWJ7V2FimofnSXMaEPM0Xe3gyKrX3elfb9UvAdA4dlPGSFgCRkPANqAgnCK4WSZhoH
	 DO4ciOs+Y82mgmXDse05uSI9RB1y/VAlXpqlhCOCM7WNcs3yb47P5zpTNwQlppQ/7A
	 dXl5S6KgLHjJtgVub02NqyNe5cZBrlpF4BBL9BOy4uE6oTiH9g2bDXOQWduaLRKt0j
	 mtB4j3uY789aQ==
Date: Mon, 21 Sep 2026 09:37:15 -1000
Message-ID: <e95fad14874587df6ca17c5cf767d24e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 ameryhung@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH v6 1/5] blk-iocost: add BPF struct_ops cost model
 support
In-Reply-To: <20260918055001.1273840-2-cui.tao@linux.dev>
References: <20260918055001.1273840-1-cui.tao@linux.dev>
 <20260918055001.1273840-2-cui.tao@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello, Tao.

On Fri, 18 Sep 2026 13:49:57 +0800, Tao Cui wrote:

> +	mutex_lock(&iocost_bpf_reg_lock);
> +	{
> +		struct iocost_bpf_model *other;
> +
> +		list_for_each_entry(other, &iocost_bpf_models, list) {

No need for a block to scope a variable. Declare it at the top of the
function, or in the body if it has to sit inside an #ifdef block. Same for
the other blocks in this patch and the cursor block in the 2x example
model.

Thanks.

--
tejun
