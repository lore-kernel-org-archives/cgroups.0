Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE03C3B8950;
	Sun, 20 Sep 2026 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789907893; cv=none; b=hBV/isfzBZ1UQO6M4odfvYggZNrFsBi/IX49ref9BzsyZuxOYkyA1s80UKN/LjNXKBje/+7VjPEg9cg8jAtPUGiPmqEhJdbqmdNW25dwmhkgG99XMhjAaGD94ZoLrU0Ix5SlyKv9OoxZtLU7UKHY8/MJy1XMHHWSTEkOvtkeWAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789907893; c=relaxed/simple;
	bh=7nBd7keEM0+xZExEzrMDyD3wNXVvbEfKLHPe1/8pqxs=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=LVL9T0nfapnpcLseu8nSZExfHrTEiZ/aos4wPTMhP404QVzhQX2XwWf7BkxOWI6RQj/Q+cB4K7OgNjMOVxoZ+ggVNkEFlp2c2bV9a/0K8mekY0Faa3L0NJtiQmy/gdf3Fpl+FLp+M3MpCDVf1GZDxlEU/gio2bunQryd8iSosT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tfu41fTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tfu41fTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE64E1F000FF;
	Sun, 20 Sep 2026 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789907875;
	bh=8TXSOAoauEDqUAiNkN8UacM8jNoYS5sAyxYgzMe9pLY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Tfu41fTWM3gSmOu+hwWOtrDgVn/zpXFuQKqN4APJo9TJ6fTyPNi3LOPbntxjrJJSG
	 1bsh/nbFLU6vZMTNc5t0vf12EPKFsVn5AslSlAFmaH+xhFke54Wy5ooF6qf2xK3VPT
	 sFcKlcldYLJRlSTOvWtI35zrL3DZ/xECZ9uZYb51Ot2YNcZuQiM5aJZF7UEDj5ivHg
	 bSPgO0lbP0rQUuma110bhuBfcla6JnB4ssj1aETv/y3Y+hZij8loVdqYPyHFLyhrXE
	 dfxa2riyC4X6MD9eEti4MVRAo9+/pzs4G6i/gwsPLKnfUO45sbrXfg59ay4plIvA5x
	 L+umh4UtxqPrg==
Date: Sun, 20 Sep 2026 02:37:54 -1000
Message-ID: <b40622ed67f77f3ff88d5772e7ea8476@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH v6 1/3] block: introduce bdev_flush_by_dev()
In-Reply-To: <20260917065759.2643940-2-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
	<20260917065759.2643940-2-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Julian.

On Thu, Sep 17, 2026 at 02:57:57PM +0800, Julian Sun wrote:
> +void bdev_flush_by_dev(dev_t dev)
> +{
> +	struct block_device *bdev;
> +
> +	bdev = blkdev_get_no_open(dev, false);
> +	if (!bdev)
> +		return;
> +
> +	/* Prevent the device from closing between the check and writeback. */
> +	if (mutex_trylock(&bdev->bd_disk->open_mutex)) {
> +		if (atomic_read(&bdev->bd_openers))
> +			sync_blockdev_nowait(bdev);
> +		mutex_unlock(&bdev->bd_disk->open_mutex);
> +	}
> +	blkdev_put_no_open(bdev);
> +}

This holds the disk's open_mutex across the whole writepages pass, so every
throttle-triggered flush blocks opens, closes and partition rescans on the
disk for as long as submission takes, which can be a while on a congested
device. bdev_release() syncs before taking the mutex for the same reason.

I don't think the mutex or the openers check is needed. If the device is
closed underneath, the last close syncs and truncates the mapping and
truncate waits for writeback, so a racing no-wait flush either finishes
first or finds nothing left. Holding just the reference from
blkdev_get_no_open() should be enough.

> +void bdev_flush_by_dev(dev_t dev);

The neighbors have !CONFIG_BLOCK stubs. The only caller is under
CGROUP_WRITEBACK so it builds either way, just noting for consistency.

Thanks.

--
tejun
