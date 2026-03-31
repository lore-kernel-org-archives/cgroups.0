Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749463A3E9A;
	Tue, 31 Mar 2026 19:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774983907; cv=none; b=VEnnrqJPWfxpGZkU94thK2/J6Oop34DsmyJAwcdupAUsD9GLOCkM8OgbX21kUm/Cmr0hitO0uD80tH7QAR6GXFEB2LkLkJnPqRb3o2QhmAx1+NIqS47BZbwYn1UP3O3kGR4svN6kOlLyf9hdQfs29nHYtBE5NqEE7Mvji38Jnv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774983907; c=relaxed/simple;
	bh=Nn8nJ9ACyiayGIy4vaoRzdPmvTc+PqkI2j2N8Z/yEHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQBPje5K+Pn1FxCFEIJmzoeARg2+qQn1nwvSnCzPeVenb+ix02lfDn6Trq8D3f/Jd71YL+dCBVPGzzXiwabVXoxza89nHootrMGD5YjJkVsRw/S2O6gUggcAfX048DQsyVMsLGUfD75VX+qhI1jRyC4ilSOEUXYjl+Fcp05H9yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltDdDrho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltDdDrho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF90C19423;
	Tue, 31 Mar 2026 19:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774983907;
	bh=Nn8nJ9ACyiayGIy4vaoRzdPmvTc+PqkI2j2N8Z/yEHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ltDdDrhojmUVgrVlRwfoQReNDwpr72og04x0q105qzcJAymDtPFaiEHO+c+5ea5CI
	 l9iRkdcmQuQX93qX+4onS31dfh20p7OHu/TFqpRNKz26MV3C1gTDRW3iNdMspri2cV
	 0smR6ujOeUcleBwt5MKnV+3FL9TsGqHQ4nL945KTFSgoeIc/bulsn+P6YYFM48sf4B
	 /O7RUhmLxLSO3s3tCtZ3DQpS5IVU11U3EZSXRYrSL1ew4VbhR/cb/7Xqucyb9dDACX
	 4/Qcq275UM/kUNdU/sIiUlN/NRteeZzXMj82wgkDtfeQi1SVyJT6J7EXTQb+V1yhsg
	 19I3h+xc4Q8aQ==
Date: Tue, 31 Mar 2026 09:05:06 -1000
From: Tejun Heo <tj@kernel.org>
To: Jackie Liu <liu.yun@linux.dev>
Cc: hch@lst.de, axboe@kernel.dk, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH] blk-cgroup: fix disk reference leak in
 blkcg_maybe_throttle_current()
Message-ID: <acwa4uiQX0L6XynR@slm.duckdns.org>
References: <20260331085054.46857-1-liu.yun@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331085054.46857-1-liu.yun@linux.dev>

On Tue, Mar 31, 2026 at 04:50:54PM +0800, Jackie Liu wrote:
> Add the missing put_disk() on the error path in
> blkcg_maybe_throttle_current(). When blkcg lookup, blkg lookup, or
> blkg_tryget() fails, the function jumps to the out label which only
> calls rcu_read_unlock() but does not release the disk reference acquired
> by blkcg_schedule_throttle() via get_device(). Since current->throttle_disk
> is already set to NULL before the lookup, blkcg_exit() cannot release
> this reference either, causing the disk to never be freed.
> 
> Restore the reference release that was present as blk_put_queue() in the
> original code but was inadvertently dropped during the conversion from
> request_queue to gendisk.
> 
> Fixes: f05837ed73d0 ("blk-cgroup: store a gendisk to throttle in struct task_struct")
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
