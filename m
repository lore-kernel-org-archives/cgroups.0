Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1466F3EDE43;
	Thu, 24 Sep 2026 06:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790231418; cv=none; b=npPQnwM2OyHqaNheNSSbjDkyC+nOyZ/4+YiRmpKtGhWBZFy0cguhnh1koUBX8K34+lPV5YAHr8IO1KMVuz/66QjIRVlhSf4X3f/ks8GXC8g3pdHtzn/AjTj5nC6Q0o/g5hLAcxmNFPtD3Co6btpfYoQBazKzLE8VFlqx0TCLZf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790231418; c=relaxed/simple;
	bh=/JZ9eTH+cCJ8CPcHJGFAzukhXlFXtJ6fBtRKjn2tIGg=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=Vb3amD2elKGNHg3jHhRkQu3wzBteMN//Mgw26EdWzLXi+UozK6cD6/VruUHcyq83EAyR5baWGa3qf4vR9c7G0oIGIn6TuwiwrphSXmfGP8D/r67c0aOPYsyxMZNaZzbF/Hd2YEwHzuqFFvGn52Lvo5IHb0D/OPitF5RUOHZcy54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nv2eY9Q+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nv2eY9Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D801F00893;
	Thu, 24 Sep 2026 06:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790231416;
	bh=PbUnL7Dp8W4lDbAThqkmUJ0eg5I5/4s5qPPqTg4hmVQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Nv2eY9Q+EOCRBN8dAA4cSOUc5FOoaNc9lGhYgb6ontWHYPb5AOVPAXN2c80gkknci
	 Ulhwqjn/RxVRuQTsjbRUL5RQ39hTIeBYgyFeBlGaVYPdB36UhkqPMZwvVXOTLjdcx1
	 sTLWKHE0AQH+P5jFGtN30DB8vtvv//LqquGrs7w5QTxnRzGEx9TOYprI77WKjaMKC7
	 IreWkAk/AdpRuHLxf3fB3FA/Y/i3t5xUZQDpiZsYL6JuWD0uupsmD6/VzKMkZKzqHU
	 Dg9YNL3WEynqCWEHPOogU6fLSAktHZnxT9eDq+gyJMm2aVDM55NiUBmkjsj8CnhWIT
	 JgxSHjXMoZ0RQ==
Content-Type: multipart/mixed; boundary="===============0377911730758240839=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <708eecd95cb24c85757f7f217915bfbb2bbd855b8f963a4cc32aa61ad6031034@mail.kernel.org>
In-Reply-To: <20260924054549.2271705-2-cui.tao@linux.dev>
References: <20260924054549.2271705-2-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v7 1/4] blk-iocost: add BPF struct_ops cost model support
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,alexei.starovoitov@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 24 Sep 2026 06:30:14 +0000 (UTC)

--===============0377911730758240839==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/block/blk-iocost-bpf.c b/block/blk-iocost-bpf.c
> new file mode 100644
> index 000000000000..2306c5fd6d8d
> --- /dev/null
> +++ b/block/blk-iocost-bpf.c

[ ... ]

> +static int bpf_iocost_reg(void *kdata, struct bpf_link *link)
> +{
> +	struct iocost_model_ops *ops = kdata;
> +
> +	if (!ops->dev)
> +		return -EINVAL;
> +
> +	return ioc_bpf_attach(ops);
> +}

Does this guard against multiple registrations of the same struct_ops?

bpf_struct_ops_link_create() allows several links from one BPF_F_LINK map.
bpf_struct_ops_valid_to_reg() only checks the map type, BPF_F_LINK flag,
and the READY state.  The state stays READY after a link is created, so
every bpf_link_create() on the map calls ->reg(st_map->kvalue.data, link)
on the same kdata.

hid_bpf_reg(), which the commit message names as the model, guards this
case:

    /* prevent multiple attach of the same struct_ops */
    if (ops->hdev)
        return -EINVAL;

While the first link is attached, a second link on the same device is
refused by the ioc->model check in ioc_bpf_attach() with -EBUSY.  That
check stops working once the device goes away:

1. link1 = bpf_link_create(map). ioc_bpf_attach() opens f1 =
   bdev_file_open_by_dev(dev) and stores ops->q = q1 and ops->bdev_file =
   f1.
2. The disk is removed, for example a null_blk device deleted through
   configfs. null_del_dev() calls ida_free(&nullb_indexes, nullb->index)
   and then del_gendisk(). __del_gendisk() -> rq_qos_exit() ->
   ioc_rqos_exit() clears ioc->model and calls ioc_bpf_detach(), which does
   WRITE_ONCE(ops->q, NULL) but deliberately leaves ops->bdev_file = f1.
   The old disk and queue stay alive because f1 pins them. __del_gendisk()
   also calls bdev_unhash(), so the old bdev can no longer be looked up by
   dev_t.
3. A new null_blk device is created. It gets the same index, and so the
   same dev_t, because null_add_dev() sets disk->first_minor = nullb->index
   and the index was already freed.
4. link2 = bpf_link_create(map). bpf_iocost_reg() sees ops->dev != 0.
   ioc_bpf_attach() opens f2 on the new disk and finds no model on the new
   ioc. It then runs:
       rcu_assign_pointer(ioc->model, ops);
       ops->q = q;
       ops->bdev_file = bdevf;
   This overwrites f1, and nothing ever releases f1. The dead gendisk,
   request_queue, bdev and the driver module reference held through the
   open file are leaked, so null_blk can no longer be unloaded.
5. Closing link1 then runs bpf_iocost_unreg() -> ioc_bpf_unreg(). It reads
   q = new queue and bdevf = f2, detaches the model from the new device and
   fputs f2. link2 is still alive but its model has been silently removed.
   When link2 is released, ops->q and ops->bdev_file are both NULL and
   nothing happens.

The map's dev cannot be changed after the first update, because
map_update_elem requires state INIT, so dev_t reuse is the trigger.  Every
step can be reached by a user with CAP_BPF, CAP_PERFMON and the ability to
add and remove block devices.

> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 2745bffcd5ee..21e4f8cbd9f2 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c

[ ... ]

> +#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
> +/*
> + * Attach a BPF cost model to the device named by ops->dev: resolve the
> + * queue, make sure iocost is on it, and publish the model.  Attaching
> + * switches the device away from the builtin linear model; detaching
> + * restores it.  The struct_ops core holds the program alive for the
> + * whole registered period, so no extra reference is taken on the ops.
> + */
> +int ioc_bpf_attach(struct iocost_model_ops *ops)
> +{
> +	struct block_device *bdev;
> +	struct request_queue *q;
> +	struct ioc *ioc;
> +	const struct iocost_model_ops *old;
> +	struct file *bdevf;
> +	int ret;
> +
> +	bdevf = bdev_file_open_by_dev(new_decode_dev(ops->dev),
> +				      BLK_OPEN_READ, NULL, NULL);
> +	if (IS_ERR(bdevf))
> +		return PTR_ERR(bdevf);
> +	bdev = file_bdev(bdevf);
> +
> +	if (bdev_is_partition(bdev)) {
> +		fput(bdevf);
> +		return -EINVAL;
> +	}
> +
> +	q = bdev->bd_queue;
> +	if (!queue_is_mq(q)) {
> +		fput(bdevf);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	mutex_lock(&q->rq_qos_mutex);
> +	ioc = q_to_ioc(q);
> +	if (!ioc) {
> +		ret = blk_iocost_init(bdev->bd_disk);

Does this check that the disk is still live?

ioc_bpf_attach() takes q->rq_qos_mutex and, if the queue has no ioc, calls
blk_iocost_init() to add one. It never checks that the disk is still live.
The only liveness check is the one bdev_file_open_by_dev() does under
open_mutex at open time, and __del_gendisk() does not wait for existing
openers.

The blkcg config path handles the same race explicitly in
blkg_conf_open_bdev():

    mutex_lock(&bdev->bd_queue->rq_qos_mutex);
    if (!disk_live(bdev->bd_disk)) {
        blkdev_put_no_open(bdev);
        mutex_unlock(&bdev->bd_queue->rq_qos_mutex);
        return -ENODEV;
    }

Without that check, this interleaving is possible:

1. bpf_iocost_reg() -> ioc_bpf_attach(): bdev_file_open_by_dev() succeeds
   while the disk is live.
2. __del_gendisk() on another CPU: bdev_unhash, GD_DEAD, blk_unregister_queue,
   device_del, blk_mq_freeze_queue_wait, then rq_qos_exit(q). rq_qos_exit()
   unlinks every rqos under rq_qos_mutex and runs ioc_rqos_exit(), so
   q->rq_qos no longer has an ioc.
3. ioc_bpf_attach() then gets rq_qos_mutex. q_to_ioc(q) is NULL, so
   blk_iocost_init() runs on the dead disk. rq_qos_add() only checks for a
   duplicate id, so it links a new rqos, and blkcg_activate_policy() succeeds
   because the blkgs are only destroyed later in disk_release(). The model is
   then published and blk_stat accounting is turned on.

Nothing tears down an rqos added after rq_qos_exit(). disk_release() only
calls blkcg_exit_disk(), and blk_free_queue() does not look at q->rq_qos.
The consequences depend on who owns the queue:

- GD_OWNS_QUEUE: the ioc and its pcpu_stat leak.
- Queue not owned by the disk, e.g. SCSI sd, where __del_gendisk()
  unfreezes the queue and it is reused for the next disk on sd rebind: the
  stale ioc stays on q->rq_qos with ioc->rqos.disk pointing at the freed
  old gendisk. The following paths then dereference it:
  - the next rq_qos_exit(), via ioc_rqos_exit() ->
    blkcg_deactivate_policy(rqos->disk, ...)
  - ioc_rqos_queue_depth_changed() -> ioc_refresh_params() ->
    ioc_refresh_params_disk(ioc, force, ioc->rqos.disk)
  - an io.cost.qos write on the new disk, where q_to_ioc() returns the
    stale ioc

[ ... ]

> @@ -3531,11 +3778,31 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
>  				user = false;
>  			else if (!strcmp(buf, "user"))
>  				user = true;
> +#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
> +			else if (!strcmp(buf, "bpf")) {
> +				/*
> +				 * readback value while a BPF model is
> +				 * attached; attaching is done by loading
> +				 * the struct_ops, not through this file
> +				 */
> +				continue;
> +			}
> +#endif
>  			else
>  				goto unlock;

Is ctrl=bpf meant to be accepted here?

The COST_CTRL case now accepts "ctrl=bpf" as a silent no-op. Before this
patch the write failed with -EINVAL. The comment justifies this as a
"readback value while a BPF model is attached", and the documentation
(da89d4c2165e) says ctrl=bpf is accepted "so a saved configuration still
parses". But the read side never produces ctrl=bpf. ioc_cost_model_prfill()
still prints only

    dname, ioc->user_cost_model ? "user" : "auto",
    model ? "bpf" : "linear",

so only model= can read back as "bpf". The same docs commit also says
"ctrl keeps describing the builtin coefficients" and lists ctrl as "auto"
or "user". So no saved configuration can contain ctrl=bpf, and the stated
reason for accepting it does not hold.

The branch adds a write-only io.cost.model token with no read-side
counterpart and no effect. As user ABI it would have to be kept forever.
It is also accepted when no BPF model is attached, so a mistyped config is
taken silently where it used to be rejected.

The model=bpf branch in COST_MODEL is consistent with the readback and is
not affected.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35962141400
--===============0377911730758240839==--
