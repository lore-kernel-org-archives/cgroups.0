Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D625E478E28;
	Thu, 17 Sep 2026 22:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789685588; cv=none; b=rXPBaz9Djxud8wfdwSFhLnGrUkjYml9HoN4SXXdDB6jp6kGwi+1I0MfF4Eh+My7XyaBoTQ58MXncErDWvZtyot75bCTF/wM51CN1U/lr7zl5AYJWQKEx8Myw/o3sYfnuyApa9iQGPBjaUeN50RAxHdvxJsZPaiZK9bUjZR6dGuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789685588; c=relaxed/simple;
	bh=C6CjS0eJj6GvLZ5QhSihKjGN9kpySYKWLlROoRXAZJM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=tRSgBhKlX4Jw1QTbNiCt3ehvJUuJlMdWY8DxAnXdgm8WTJi1rL52X/fiEnnqKWgo/DPgQaQwLcqDMzm8mnD5Pvg+jvM7Ahto8ja/DEd5zsTVrSiZrxV19jQC6FqMdhK1S5NGlhcYyTX2ia72gdPFP/mqtu+aN0nJmOgVOHvs9eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=blq+sEHg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="blq+sEHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6E31F000FF;
	Thu, 17 Sep 2026 22:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789685586;
	bh=n2lwDIWkeFYzgSRZvfTcjiNWTjkHsJ7RpCepH/lAHRg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=blq+sEHgAElfZA9X3EQAQ9ZlGWOeuUx/GzEM8ysiMT6PGSSN07TMYIUM0AQuu+85M
	 Lbr7rsJgDCLbt6HZBoFrM/VEATI9bQod/jZ7pNVEz9OVVC5uqFdOAIkd0wCppxYIAL
	 /zVK/kE+enmxOObLdnKnC74anYPnIsFBrd46+hQk=
Date: Thu, 17 Sep 2026 15:53:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
 jack@suse.cz, tj@kernel.org
Subject: Re: [PATCH v6 0/3] memcg,writeback: flush foreign bdev mappings
 separately
Message-Id: <20260917155305.7a63e01ba3ed34ed0aea537f@linux-foundation.org>
In-Reply-To: <20260917065759.2643940-1-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Sep 2026 14:57:56 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> Hi,
> 
> This series avoids owner-wide foreign writeback triggered by dirtying
> shared bdev inodes. Instead, it tracks bdev targets separately and
> schedules writeback of their mappings.
> 
> Problem
> =======
> 
> Bdev inodes are commonly shared by many memcgs. Dirtying their pages
> can cause the owner wb to be tracked as foreign, triggering writeback
> of the entire wb rather than just the bdev mapping.
> 
> In production, almost all the foreign dirtying we traced came from bdev
> inodes. Across our observations, a bdev mapping had as little as about
> 10 MiB of dirty pages, yet foreign flushes targeted the entire owner
> wb. On one machine, we observed 599 such works queued on one wb, with
> an average request budget of about 43 GiB per work.
> 
> Measured impact
> ===============
> 
> The synthetic test used a VM with 4 vCPUs, 8 GiB RAM, ext4 and cgroup
> v2, with device write bandwidth capped at 200 MiB/s. Background fio
> repeatedly overwrote a 256 MiB file using buffered I/O, while
> foreground fio performed sequential direct writes. Four memcgs
> generated metadata and buffered writes to trigger foreign flushes.
> 
> We measured completed block writes to the background fio file,
> including final sync, and foreground fio bandwidth, latency and
> completion time.
> 
> Across three runs per kernel, mean background file write I/O decreased
> by 72.7%, foreground bandwidth increased by 23.0%, and completion time
> decreased by 18.8%.
> 
> Metric                         Baseline    Patched     Change
> Background file write I/O (GiB)    6.154      1.680     -72.7%
> Foreground bandwidth (MiB/s)      150.29     184.81     +23.0%
> Foreground completion time (s)   109.203     88.652     -18.8%
> Foreground mean latency (ms)      212.84     172.74     -18.8%

Thanks.

As I understand it, this is basically ext4-specific.

I don't think btrfs or xfs mess with the bdev address_space at all? 
But google tells me that "roughly 70% to 80% of all Linux machines use
ext4 as their primary or root file system", so there is that.

> Approach
> ========
> 
> Following Jan's suggestion, this series records foreign bdev targets
> separately and flushes their mappings instead of their owner wbs. This
> preserves a way for dirty throttling to initiate bdev writeback while
> avoiding owner-wide writeback triggered by these records. The existing
> foreign-wb mechanism remains unchanged for other inodes.
> 
> Tracking is best effort: each memcg keeps a bounded set of device
> numbers without persistent device or inode references. Closed devices
> and devices with a busy open_mutex are skipped. Device removal and
> device-number reuse may race with lookup.

This part looks plain nasty.  Why are we messing with dev_t's and
risking these races?

At the very least, this description should explain the reasoning behind
this decision at some length.

Surely it's cleaner and safer to grab a ref on something (the bdev
inode?) and hang onto that object.  Use it for these operations, let it
go at the appropriate time.  Clearly there's something wrong with that
approach, but what?

> Flushes run asynchronously on a dedicated workqueue to isolate these
> frequently triggered tasks from existing workqueue users. If workqueue
> allocation fails, the existing foreign-wb mechanism remains in use.

Unclear what this means.  If a kmalloc/etc fails then we fall back to
the current (mainline) behavior?  Fair enough, failure of small
kmallocs are so rare.  The main problem is testing the failure-path
code!


Also, and most importantly, what the heck is "frn"?  Would the world
end if you did s/frn/foreign/g?

