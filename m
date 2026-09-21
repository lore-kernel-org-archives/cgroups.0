Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3CD4DE701;
	Mon, 21 Sep 2026 16:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009489; cv=none; b=FsrcpCR+/bAiW/CtOCIdo1VehfwWqzesit1KRH+U05JX/G41eem9Sg5cX1q9vru87y52dm10kNKZcxqVG62tMDkVGZo60lNER7LdU6jguQt1k8eOXEyTLFSsr1LbP8sT3t5icdxZPt9GUG8CiO1xIBZioLLq62lySm3HFAFCR+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009489; c=relaxed/simple;
	bh=TwCCuhT7Ima8OnppsoS1NQ7VB7yMzVzx8ASg1v8NLDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyEPROMuFNofJu8RliKFDHRSfMYJ7Pw3XnMvpw9yY+bc0DJNM2Ir65+/XUzApZLfBndLj1BL4M3hzipSpxMhV6yZ0NOlHlwp4VKSSZFY3OFP6RuzVaQOjyH2EvzOwgPE7tYvLQf0k42cnaGeHL8q0EzEv/CRiSO2AWX6CayVtys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0LEWUPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0LEWUPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BBF1F000FF;
	Mon, 21 Sep 2026 16:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790009487;
	bh=0Rk95nbCHvSDXKzKHRytip9QY2TC4q23JnFsZN3gYMM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W0LEWUPAXKQ99l86x5srS05ioOguB9WT4+1+Fuc7Mx837xB1LILUehGNoa2FnUqtf
	 9b4lnVH/yvjvQXRt6J6fxi4mZtn4KGLZHMGFUYfYG/WIzCzVEtgHuGcOIRMEpbtozj
	 EyzS4WnrUdOIPqJl5fKHBLBgEa55c0b/RcDmmxFkCz7EGl31zZJESinWWym4pm7t8J
	 sWYuaLXA68wN1g93BResBXSlhfFvSBDZmk3hBFcbjes9I5yIvZscIc8wa8Tx43Byur
	 wqwqwb7yBjVLIu0dINTpY91/4khzJwPihi2i4GEDx+z0M5z16TJE+1UleT+kBG2q9D
	 7rVbTJCi7NMjw==
Date: Mon, 21 Sep 2026 06:51:26 -1000
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	yukuai@fygo.io, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [RFC PATCH 1/1] block: charge passthrough requests to the
 submitter's cgroup
Message-ID: <arFgjkKUwYGWbV8H@slm.duckdns.org>
References: <20260921070647.1928289-1-cui.tao@linux.dev>
 <20260921070647.1928289-2-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921070647.1928289-2-cui.tao@linux.dev>

On Mon, Sep 21, 2026 at 03:06:47PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> Passthrough requests (SG_IO, bsg, nvme passthrough ioctls and uring
> commands) are dispatched via blk_execute_rq{,_nowait}() without ever
> passing through submit_bio(), so the bio mapped by blk_rq_map_user()
> carries no blkcg association: the transferred bytes never show up in
> cgroup io.stat, and every rq_qos policy on the queue (iocost,
> iolatency, wbt) is bypassed, as is blk-throttle, which hooks
> submit_bio_noacct() directly rather than going through rq_qos.
> 
> A quick demonstration on a scsi_debug device with iocost enabled and
> vrate pinned to its 1% floor: a direct fio writer was throttled ~10x
> while the same cgroup issuing sg_dd writes ran at full device speed
> with zero io.stat accounting.
> 
> Associate the mapped bio with the submitter's blkcg at dispatch time
> and run the regular bio accounting (blk_cgroup_bio_start()) and
> rq_qos throttle paths with it.  DRV_IN/DRV_OUT commands are mapped to
> READ/WRITE so io.stat classifies their bytes normally; request
> completion already pairs with the throttle through bio_endio() ->
> rq_qos_done_bio().
> 
> The charge is gated by opcode (READ/WRITE/DRV_IN/DRV_OUT) and to
> queues that already have a gendisk: commands issued during device
> probing (SCSI INQUIRY etc.) have no gendisk yet and stay exempt,
> following the same probe-exemption reasoning as the passthrough
> iostats support.

Do you have an actual use case where this matters?

Thanks.

-- 
tejun
