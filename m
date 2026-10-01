Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62091B3925;
	Thu,  1 Oct 2026 00:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790814059; cv=none; b=iFpAHuLYtDU7qzJ+pyygQwCQkRzVm5eYJCuKHwuiBIQRrcLnbwh4h/imeShrBCNlS335SbAfg4DDbqC/tn/TH5aNAnQGkazLjc3wwVbfrPFeZLh92lO8UDNNIcLuxo1xTWpeqgGJjClIDfIPHMvmyVNB/pHNQZ4lapZSBWf176o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790814059; c=relaxed/simple;
	bh=1oedzK2hN4slJTlXaeU62TmQrzclvWcZvT21Zjgs+7Q=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=s1NRn6MEYn7T3YnJT2euUv69p75rcrIKnRe9vSFLoTkCqkynf7qJKDKMvLptIoZczSbtu57wm6+O2llzWBhhj+upyIfj5NPMgaSP6wTnVSUW7MKi7Dl6ryTvYcxr1BF3+Uek4IQVsgBpg2TFrBNO99iC+7+7PrCiL0QUZzXV+jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/JY0sC0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/JY0sC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354D91F000FF;
	Thu,  1 Oct 2026 00:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790814057;
	bh=B2qWkqGbqpnCIKtcX9etnZxOetQ00/33kAik+5t47/U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=P/JY0sC0sOz1ZN+szWipRKk4coC6cGaHKxPXrBX9oX/TYbfcIUCK2QGc+s0fQli6R
	 OjomjRVBLBS4R6vjzY5dnmBHANITdpG1n1DqTV7ZYKkVbJooi3jYfYgCXR8SEk1qPR
	 ipNmAq8ZNBQzYJIXLKrdBB0HluUVq5w0u8WteHZDNWAoGTDjtMsHiIBqUOyAcSdc+k
	 3wmrXpr5riEO9D82yEx5r3ltkbcpWW9wt6inLCR35d/57Jt3yyS6F+YRkipix68mSP
	 YWPHa/NFiux/KYPjebx8qRw9n3F/Irqac3baksTRSdD2nDfkM9XBF0FOBRHSRGJPXJ
	 PJ3Wz8+Gn1TLw==
Date: Wed, 30 Sep 2026 14:20:56 -1000
Message-ID: <6c97ba9ada55be8e7191f78c4db8bcf9@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com,
	ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
	alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v8 1/4] blk-iocost: add BPF struct_ops cost model
 support
In-Reply-To: <20260930075154.189958-2-cui.tao@linux.dev>
References: <20260930075154.189958-1-cui.tao@linux.dev>
	<20260930075154.189958-2-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Tao.

The following is a Claude-generated review.

On Wed, 30 Sep 2026 15:51:51 +0800, Tao Cui wrote:
> Add the iocost_model_ops struct_ops.  Attachment follows the
> hid_bpf_ops model: the struct_ops instance is per-device, the target
> device is set in the dev member from userspace before load, .reg
> attaches the model to that device and switches it away from the
> builtin linear model, and .unreg detaches it and restores the builtin
> model.  The struct_ops core owns the program lifetime, so there is no
> name registry and no bound-state bookkeeping.
...
> The cgroup callbacks are bound to the iocg policy init/free paths,
> one (cgroup, device) pair per invocation, matching the builtin
> cursor's lifetime, instead of the blkcg css lifecycle, which also
> drops the mutex from the cgroup online/offline paths.

The description is written against earlier versions. There is no name
registry, css lifecycle binding or mutex in the tree, so a reader of the
commit can't follow it. Can you open with why a pluggable model is wanted
and then describe what the patch does: attach creates the ioc and
switches the model under the same freeze as io.cost.model writes,
model=bpf and model=linear select between the attached and builtin
models, device removal ejects the model, and so on? Also, the model
prices every charged IO, not every IO. Root cgroup IOs and IOs while the
controller is disabled never reach it.

> +bool blk_get_queue_rcu(struct request_queue *q)
> +{
> +	return refcount_inc_not_zero(&q->refs);
> +}
> +EXPORT_SYMBOL(blk_get_queue_rcu);
...
> +struct block_device *blkdev_get_no_open(dev_t dev, bool autoload);
> +void blkdev_put_no_open(struct block_device *bdev);
> +bool blk_get_queue_rcu(struct request_queue *q);
> +void blk_put_queue(struct request_queue *q);

blk_get_queue_rcu() has no prototype in any header, so every build warns
on it. Can you declare it in block/blk.h, include "blk.h" from
blk-iocost-bpf.c and drop these local prototypes? blkdev_get_no_open()
and blkdev_put_no_open() are already in blk.h and blk_put_queue() in
blkdev.h. The export isn't needed either as the only user is built-in.

> +	case offsetof(struct iocost_model_ops, bdev):
...
> +	case offsetof(struct iocost_model_ops, q):

The struct_ops core rejects non-zero non-function members that
init_member doesn't claim and kvalue starts zeroed, so these two cases
can go. Same for the name lookup in .init, the core has already found the
struct by then.

> +	rcu_read_lock();
> +	q = rcu_dereference(ops->q);

ops->q isn't __rcu annotated, so sparse will complain here. Either
annotate it and use RCU_INIT_POINTER() for the stores, or READ_ONCE() it.
The RCU section protects the queue, not the ops pointer.

> +#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
> +	{
> +		struct iocost_model_ops *ops;
> +
> +		spin_lock_irq(&ioc->lock);
> +		ops = (struct iocost_model_ops *)rcu_dereference_protected(
> +				ioc->attached, lockdep_is_held(&ioc->lock));
> +		rcu_assign_pointer(ioc->attached, NULL);
> +		rcu_assign_pointer(ioc->model, NULL);
> +		spin_unlock_irq(&ioc->lock);
> +
> +		/* eject the model completely on device removal */
> +		if (ops) {
> +			WRITE_ONCE(ops->q, NULL);
> +			blkdev_put_no_open(ops->bdev);
> +		}
> +	}
> +#endif

Once ops->q is NULL, .unreg returns without taking rq_qos_mutex, the link
can go away and the struct_ops map which holds ops can be freed after a
grace period. This path isn't in an RCU read section, so reading
ops->bdev after the store is a use-after-free window. Read bdev first and
make the NULL store the last access.

This is also a block scoping a variable. Can you make it an
ioc_bpf_eject() helper next to attach and detach, with an empty stub for
!CONFIG_BLK_CGROUP_IOCOST_BPF? That removes the #ifdef and the const
cast. The remaining #ifdefs in ioc_cost_model_write() would go away too
if the two pointers in struct ioc were unconditional.

> + * Deliver iocg_init()/iocg_free() to the cgroups which already have a
> + * blkg on the queue, the same q->blkg_list walk the blkcg policy
> + * teardown uses.  The queue is frozen and quiesced and blkcg_mutex
> + * serializes against blkg creation and destruction.  Cgroups without
> + * a blkg on the device yet are not missed: their blkg is created
> + * later and ioc_pd_init()/ioc_pd_free() deliver the callbacks then.
> + */

blkcg_mutex doesn't serialize blkg creation. The IO path creates blkgs
from bio_associate_blkg() through blkg_lookup_create(), before
bio_queue_enter(), so the freeze doesn't stop it either, and
blkg_create() runs pd_init and then list_add() to q->blkg_list under
queue_lock only. Against the attach:

1. ioc->attached is published, blkg_create() runs ioc_pd_init() which
   delivers iocg_init(), then list_add(), then the walk delivers
   iocg_init() again.

2. blkg_create() runs ioc_pd_init() while attached is NULL, the walk runs
   before list_add(), and the blkg never gets iocg_init() but gets
   iocg_free() from ioc_pd_free() or the detach walk.

Detach has the mirror cases. The walk is also the only q->blkg_list
walker without queue_lock, and a plain list_for_each_entry() against a
concurrent list_add() isn't safe. The teardown walk this mirrors holds
blkcg_mutex and queue_lock. Can you publish and clear ioc->attached and
walk under queue_lock as well? ioc_pd_init() already calls iocg_init()
under queue_lock, so nothing changes for the BPF side.

While at it, the walk goes newest first, so children usually get
iocg_init() before their parents. blkcg_activate_policy() walks in
reverse for that reason.

> +	/* prevent multiple attach of the same struct_ops */
> +	if (ops->q)
> +		return -EINVAL;

On the link path the map stays READY after .unreg, so a map can be
attached again through a new link. If the device goes away, the ejection
clears ops->q while the old link is still open, a device with the same
dev_t comes back and a new link attaches the same map, closing the old
link then detaches the new attachment. Recording the owning link in the
ops and having .unreg detach only when it matches would close that.

> +	/*
> +	 * check liveness and create the ioc under rq_qos_mutex, like
> +	 * blkg_conf_open_bdev() does; enabling stays with io.cost.qos
> +	 *
> +	 * the queue reference is held across the unlocked window below:
> +	 * the bdev reference does not pin the queue, bdev only holds a
> +	 * raw bd_queue pointer, and concurrent device removal may eject
> +	 * the model and free the ioc while we are off the mutex, so
> +	 * without our own reference the second mutex_lock() would touch
> +	 * a freed queue
> +	 */
> +	mutex_lock(&q->rq_qos_mutex);
> +	if (!disk_live(disk) || !blk_get_queue(q)) {
...
> +	ioc = q_to_ioc(q);
> +	if (!ioc) {
> +		ret = blk_iocost_init(disk);
> +		mutex_unlock(&q->rq_qos_mutex);

Why drop rq_qos_mutex here? ioc_cost_model_write() holds it from
blkg_conf_open_bdev() across blk_iocost_init() and its own freeze and
quiesce, so attach can hold it from the disk_live() check through the
unfreeze. Then the ioc can't be freed under us and the queue reference,
the second q_to_ioc() check and this comment go away. The comment is also
wrong: a whole-disk no-open bdev reference holds the disk device, and
disk_release() is what drops the queue reference.

Thanks.

--
tejun
