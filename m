Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B4E4035BB;
	Tue, 31 Mar 2026 15:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970542; cv=none; b=FAJAe9rQveAGQTJ7TU36kMFOHABuHW/ql5qbbJxXQEWFlpr9npmRjhli4oCsTPKU++IVwDgF2jX/TLw6Y3SJd9+9c1OC8++9Q4IRPc049UA0T0s6PYUyHXf+Yxw/2XLh4g3v0VLhr5+aqMA2DptzXx5dXTVSw28vNJfOlAMjrEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970542; c=relaxed/simple;
	bh=Q3HWBeZ7zGj03IMzjy2FlWgXs4sy18IVtFZPvkMCobI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHMRYGCdAA1aKy2g8epBJfxqwNkh66uW+CwxuGhA5fxGaaBMO4ekrxpOO4C/oP3NCoYtA0b46A5E1c4w/YBMyjLKI/bbhk9y4noRHQ3X+mpxJHZ2WKLufk6uyW+eop48J0Y3TsczG5A6Oncku+VDcdd8HdHbcj9yP71qf2gZhjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7F1CA68AFE; Tue, 31 Mar 2026 17:22:17 +0200 (CEST)
Date: Tue, 31 Mar 2026 17:22:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jackie Liu <liu.yun@linux.dev>
Cc: tj@kernel.org, hch@lst.de, axboe@kernel.dk, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH] blk-cgroup: fix disk reference leak in
 blkcg_maybe_throttle_current()
Message-ID: <20260331152217.GA8074@lst.de>
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
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 31, 2026 at 04:50:54PM +0800, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
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

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

