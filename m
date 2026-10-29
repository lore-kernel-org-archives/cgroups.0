Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793296649;
	b=cpYyQpY0ie3PYDUTxT2sioHCoRU5MPzjJwZDgljSHCN0tKy58VI/3IkiGyKJAV9WRTrt
	 Lz32ZucJVvOOpEDHpaULuoQbsHw/rfj6+mQHrxkap40hlNsGk1avkOs81l9QREVvC4Yrw
	 9rfDV+IfFPhfALDJo52It32JHAC0c6Baa2dpG9yqTA2tZ3Opq93R1a+tw4SCLYIOiVJuF
	 5RtA5trR2zXadn7JzuHdZQU2UL557nSC+NTdZfB92KAyn397YqJGf6ZCSMwIYxL7glTtf
	 h9NTDRA2D/zk1OoajUUcRD9Q2pN2PsFkfcC47JO1m5O7z7an0QDDzSa63I/9HqW1OaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793296649;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Bo7AGglowNOqbJg/RzmeJY9UwlIjuNUgtaQL0Gm1c8c=;
	b=IWXtkLeZ429QaOTz31tuW9PjOFJYGmQRSqBTSaXNFk0BFSCW5gUylIfq8uLBFfEHy0Qf
	 8yC8r3H4LKIbNYVOLZUykjDBaSi8lxbRaemk1sHYqa3rKjyu3T+lHtXKQ9mMwpE0RSRTq
	 VYz3Wvvjqpnw5tyNXf1oNzCTQwH0X53wPyvTJk3p/plBAHWKt0ge63EF1SAx5gBrvFptn
	 XkSxxnoVpcoMHIPuX9szXQQCHZdxnWTGYAWemq3H9OxEMLLjoRzVzuFB6HhlPugewWHZa
	 KawtrqapwyQMkLR32oAH5S2wQhJD0lX5wWu4arwzk3pTPL7FXeGajtJ8lbCEaRNV4BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lqkF0Aw5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3027F606A31E;
	Thu, 29 Oct 2026 17:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lqkF0Aw5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873451F01825;
	Thu, 29 Oct 2026 17:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793296648;
	bh=Bo7AGglowNOqbJg/RzmeJY9UwlIjuNUgtaQL0Gm1c8c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lqkF0Aw5klXIOjNhV+gSV2CN1VDhZheNuW+Q0MFB4wsX5Vw/SyR9HrtC1+AllKoYg
	 2SAkFBklrLhp2FJBIo0y8ND+WU7+PX05isWiHcS+YXSMLSTI3UURWigURHeNNYHKre
	 1qeRrKed2U6Hmridm/PGAK7mG9/MFJm7oHRr7Y9uUoQO1rMhh41C4Of6BjxtJr0d7O
	 39UMEQdQkje2AVhvfNhLe2Go75FX7x2phGzf0QfUtTQnCJBbiJacn9DawO0WcUcgAJ
	 Ebu3RGzndLqO27JH8cwjnVUoWihUTrfQYV3nW2Uu4Yte8lJjWB99ijUNJkakiou2l/
	 Idp7YytbFqoHg==
Date: Thu, 29 Oct 2026 07:57:27 -1000
Message-ID: <17d94c41da65e31e1579a7211ebb7aa1@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Peng Yu <yupeng0921@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, Keith Busch <kbusch@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11] nvmet: add cgroup_id to charge namespace I/O to a cgroup
In-Reply-To: <20261029153103.13689-1-yupeng0921@gmail.com>
References: <20261029153103.13689-1-yupeng0921@gmail.com>
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

Hello, Peng.

From the cgroup side, this looks okay to me.

The following is a Claude-generated review.

On Thu, Oct 29, 2026 at 08:31:03AM -0700, Peng Yu wrote:
> Considering this scenario: The LVM creates multiple logical volumes on
> the same physical disk, the logical volumes are assigned to different
> nvmet subsystems/namespaces. We want to stop a remote noisy user from
> using all the disk iops via nvmet. So add a per namespace css. Each
> namespace could be throttled separately.

The grammar of this paragraph could use a pass ("Considering this
scenario: The LVM ..."), and "add a per namespace css" isn't accurate.
The patch associates the namespace with a cgroup rather than adding a
css.

> The per namespace css is good enough for the io.max, but is not good
> enough for the io.cost and io.latency. The io.cost and io.latency may
> put a thread to sleep. If the thread is shared by different namespaces,
> all of them will be impacted together. Submit the IOs via a workqueue to
> avoid this impact.

What the change guarantees is only in the changelog below "---" and
could be said here:

- every I/O command except Reservation commands runs from its own work
  item on a per-namespace workqueue, and the file backend's Flush, DSM
  and Write Zeroes and zone management run directly in that work item
- a command whose queue is being deleted is aborted
- the work runs under memalloc_noio
- the effective io css is looked up for each command
- buffered_io is refused

> With this patch and no cgroup_id set, the peformance is almost the same.
> When we set the cgroup_id, we can see a performance decrease but it
> is still very fast.

With cgroup_id set, IOPS drops 14-20% (424.4k to 363.4k file, 446.4k to
356.7k bdev) and p99 goes from 330us to 1171us (file) and from 313us to
864us (bdev). The description doesn't say whether any io controller
limit was configured for those runs. Typo: "peformance".

The commands now run on blkcg_wq's normal-priority workers (nice 0)
instead of nvmet_tcp_wq and ib-comp-wq, which are WQ_HIGHPRI (nice -20).
In this setup fio runs on the same 4 CPUs, so the target's I/O now
competes with it at equal priority, which might account for part of the
p99 increase. Should blkcg_wq be WQ_HIGHPRI?

> +What:		/config/nvmet/subsystems/NAME/namespaces/NSID/cgroup_id
...
> +Description:
> +		Shows or sets the cgroup2 ID of the cgroup to charge this
> +		namespace's I/O to. Writing 0 clears it. The I/O is
> +		charged to the cgroup's effective io css: the cgroup
> +		itself or its nearest ancestor with the io controller
> +		enabled. The namespace must be disabled before
> +		modification. Enabling the namespace fails if the cgroup
> +		can't be found or if buffered_io is set. A cgroup that is
> +		removed and created again gets a new ID.

The entry could say that the cgroup must be visible in the cgroup
namespace of the task that enables the namespace (cgroup_get_from_id()
checks this), that I/O goes to the nearest online ancestor's io css if
the cgroup is removed while the namespace is enabled, and that only
direct I/O is charged, with Reservation commands and the admin Write
Protect flush left out.

> +	/*
> +	 * Buffered writes will be handled by a separate thread,
> +	 * these IOs have no namespace/cgroup information at that time,
> +	 * so we don't support buffered io.
> +	 */

The reason could be stated more directly: buffered writes are written
back later by the flusher, and writeback attributes them through the
page cache's memcg, not through this association.

> +	ns->blkcg_wq = alloc_workqueue("nvmet-blkcg-%u",
> +			WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus(),
> +			ns->nsid);

nvmet doesn't set a bio ioprio, so bio_set_ioprio() derives it from the
submitter's nice value: best-effort level 0 on a highpri worker, level 4
on a normal one. That matters on devices with an I/O scheduler, and
WQ_HIGHPRI would keep it as before.

With more than WQ_MAX_ACTIVE (2048) CPUs online, wq_clamp_max_active()
prints a warning on every enable. Maybe min_t(int, num_online_cpus(),
WQ_MAX_ACTIVE)?

The name uses only the nsid, which is unique only within a subsystem, so
namespaces in different subsystems get identically named workqueues and
rescuer threads.

> +	/* a disable waits for the command: don't throttle it any more */
> +	if (!ns->cgrp || !READ_ONCE(ns->enabled))

The !ns->cgrp test can't be true: only wrapped commands get here, and
ns->cgrp is cleared only after the namespace's references drain.

With io.max, blk-throttle holds throttled bios instead of putting the
submitter to sleep, so this check and the dying-queue check only catch
commands that haven't started. A disable or queue teardown then waits
for the held bios at the io.max rate, with nvmet_config_sem held for
write during a disable. That's inherent to throttling, but maybe worth a
short comment?

> +static void nvmet_blkcg_init_req(struct nvmet_req *req)
> +{
> +	if (!req->ns->cgrp)
> +		return;

This keys on ns->cgrp and nvmet_req_run_work() keys on ns->blkcg_wq.
They agree because both are set and cleared together while no command
exists. Maybe nvmet_req_run_work() could test whether the request itself
was wrapped, e.g. req->execute == nvmet_blkcg_queue_req since nothing
reassigns ->execute after the wrap, or a per-request flag set when
wrapping?

> +static inline void nvmet_req_run_work(struct nvmet_req *req,
> +		struct workqueue_struct *wq, struct work_struct *work,
> +		work_func_t func)
> +{
> +#ifdef CONFIG_BLK_CGROUP
> +	if (req->ns->blkcg_wq) {
> +		func(work);
> +		return;
> +	}
> +#endif

The file backend's Flush, DSM and Write Zeroes and zone management now
count against blkcg_wq's max_active for their whole duration
(vfs_fsync(), vfs_fallocate(), submit_bio_wait() over the zones). With
max_active at the number of CPUs, a few slow flushes can fill it and
hold up the namespace's reads and writes. Without cgroup_id these ran on
nvmet_wq and zbd_wq. Probably fine, but worth noting.

Thanks.

--
tejun
