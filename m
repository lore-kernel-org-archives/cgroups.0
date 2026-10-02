Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4047437880B
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790950674; cv=none; b=ozpt2cGw1iWtCH1z8Q9QjbHvala08FTleDmgZtG57SjFLStcMRCcxgYeINBA+r2jAln57ls+6oW9lHQBC6peW44NRmmmngZ/lEK+cJkUbWxbuqq1sLOCDkpEu2kkoIH7Eaq3+tYCwmmFul7TBa0F2m3OBhZPsyg33Uga/Lk3occ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790950674; c=relaxed/simple;
	bh=KVvd3mTqD0OezG5YoQKXKSUl1mfAZ3w3xJhCc5bbS0w=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Wu2Nd0jgGiW2nUDROGsqWgIBdJT6+lh3RR6u4I3ETFJEAmr0T385GvH6FnB7Yi09Me3cuHFVwzkcPPTBe3Np5nwav6Vj7OwADUBVrTs2z7OJOxxUl+zZcfGplDb/Ueh54olmvMyFZaaPpVThECJb3CJMWOoCktK2jFkgxXF2yfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xugd8xf6; arc=none smtp.client-ip=91.218.175.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xugd8xf6"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KVvd3mTqD0OezG5YoQKXKSUl1mfAZ3w3xJhCc5bbS0w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790950670; v=1; x=1791555470;
 b=Xugd8xf6lf0ZhY1tQHrRgLBONtg9vpCiToKhkCPLaG+9OiaOalCdjZ7yrxxeLqnXo9xDfNzH
 bjcWDEdTQBaM596FZk61Qcn0KVQQXaR7yau5xcQhL5k0+TediTCDCPMYYfWKJ8ZzSaMQo1SHNEA
 0zj5EBX3UHF5bKKaHzEOg1xM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 74ad76f5439c6670;
	Fri, 02 Oct 2026 14:17:50 +0000
X-Mizu-Trace-ID: 74ad76f5439c6670
X-Migadu-Flow: FLOW_OUT
Message-ID: <b83447c2-564a-4d9a-af24-60ad675f59ff@linux.dev>
Date: Fri, 2 Oct 2026 22:17:36 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>,
 ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v8 1/4] blk-iocost: add BPF struct_ops cost model
 support
To: Tejun Heo <tj@kernel.org>
References: <20260930075154.189958-1-cui.tao@linux.dev>
 <20260930075154.189958-2-cui.tao@linux.dev>
 <6c97ba9ada55be8e7191f78c4db8bcf9@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <6c97ba9ada55be8e7191f78c4db8bcf9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Tejun.

在 2026/10/1 08:20, Tejun Heo 写道:
> Hello, Tao.
> 
> The following is a Claude-generated review.
> 
> On Wed, 30 Sep 2026 15:51:51 +0800, Tao Cui wrote:
>> Add the iocost_model_ops struct_ops.  Attachment follows the
>> hid_bpf_ops model: the struct_ops instance is per-device, the target
>> device is set in the dev member from userspace before load, .reg
>> attaches the model to that device and switches it away from the
>> builtin linear model, and .unreg detaches it and restores the builtin
>> model.  The struct_ops core owns the program lifetime, so there is no
>> name registry and no bound-state bookkeeping.
> ...
>> The cgroup callbacks are bound to the iocg policy init/free paths,
>> one (cgroup, device) pair per invocation, matching the builtin
>> cursor's lifetime, instead of the blkcg css lifecycle, which also
>> drops the mutex from the cgroup online/offline paths.
> 
> The description is written against earlier versions. There is no name
> registry, css lifecycle binding or mutex in the tree, so a reader of the
> commit can't follow it. Can you open with why a pluggable model is wanted
> and then describe what the patch does: attach creates the ioc and
> switches the model under the same freeze as io.cost.model writes,
> model=bpf and model=linear select between the attached and builtin
> models, device removal ejects the model, and so on? Also, the model
> prices every charged IO, not every IO. Root cgroup IOs and IOs while the
> controller is disabled never reach it.
> 

The commit message is rewritten to open with why a pluggable model
is wanted and describe the current behavior.  It also clarifies that
the model prices every charged IO rather than every IO.

>> +bool blk_get_queue_rcu(struct request_queue *q)
>> +{
>> +	return refcount_inc_not_zero(&q->refs);
>> +}
>> +EXPORT_SYMBOL(blk_get_queue_rcu);
> ...
>> +struct block_device *blkdev_get_no_open(dev_t dev, bool autoload);
>> +void blkdev_put_no_open(struct block_device *bdev);
>> +bool blk_get_queue_rcu(struct request_queue *q);
>> +void blk_put_queue(struct request_queue *q);
> 
> blk_get_queue_rcu() has no prototype in any header, so every build warns
> on it. Can you declare it in block/blk.h, include "blk.h" from
> blk-iocost-bpf.c and drop these local prototypes? blkdev_get_no_open()
> and blkdev_put_no_open() are already in blk.h and blk_put_queue() in
> blkdev.h. The export isn't needed either as the only user is built-in.
> 

Done: declared in block/blk.h without the export, and blk-iocost-bpf.c
includes "blk.h" instead of carrying local prototypes.

>> +	case offsetof(struct iocost_model_ops, bdev):
> ...
>> +	case offsetof(struct iocost_model_ops, q):
> 
> The struct_ops core rejects non-zero non-function members that
> init_member doesn't claim and kvalue starts zeroed, so these two cases
> can go. Same for the name lookup in .init, the core has already found the
> struct by then.
> 

The bdev and q cases in .init_member() are gone, and the redundant
name lookup is removed from .init().

>> +	rcu_read_lock();
>> +	q = rcu_dereference(ops->q);
> 
> ops->q isn't __rcu annotated, so sparse will complain here. Either
> annotate it and use RCU_INIT_POINTER() for the stores, or READ_ONCE() it.
> The RCU section protects the queue, not the ops pointer.
> 

ops->q and the owning link are written with WRITE_ONCE() and read
with READ_ONCE().

>> +#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
>> +	{
>> +		struct iocost_model_ops *ops;
>> +
>> +		spin_lock_irq(&ioc->lock);
>> +		ops = (struct iocost_model_ops *)rcu_dereference_protected(
>> +				ioc->attached, lockdep_is_held(&ioc->lock));
>> +		rcu_assign_pointer(ioc->attached, NULL);
>> +		rcu_assign_pointer(ioc->model, NULL);
>> +		spin_unlock_irq(&ioc->lock);
>> +
>> +		/* eject the model completely on device removal */
>> +		if (ops) {
>> +			WRITE_ONCE(ops->q, NULL);
>> +			blkdev_put_no_open(ops->bdev);
>> +		}
>> +	}
>> +#endif
> 
> Once ops->q is NULL, .unreg returns without taking rq_qos_mutex, the link
> can go away and the struct_ops map which holds ops can be freed after a
> grace period. This path isn't in an RCU read section, so reading
> ops->bdev after the store is a use-after-free window. Read bdev first and
> make the NULL store the last access.
> 

Done: the ejection reads bdev into a local before clearing ops->q.

> This is also a block scoping a variable. Can you make it an
> ioc_bpf_eject() helper next to attach and detach, with an empty stub for
> !CONFIG_BLK_CGROUP_IOCOST_BPF? That removes the #ifdef and the const
> cast. The remaining #ifdefs in ioc_cost_model_write() would go away too
> if the two pointers in struct ioc were unconditional.
> 

Done: ioc_bpf_eject() with a stub drops the #ifdef from
ioc_rqos_exit(), and the attached and model pointers in struct ioc are
unconditional, so the remaining #ifdefs in ioc_cost_model_write() are
gone too.

>> + * Deliver iocg_init()/iocg_free() to the cgroups which already have a
>> + * blkg on the queue, the same q->blkg_list walk the blkcg policy
>> + * teardown uses.  The queue is frozen and quiesced and blkcg_mutex
>> + * serializes against blkg creation and destruction.  Cgroups without
>> + * a blkg on the device yet are not missed: their blkg is created
>> + * later and ioc_pd_init()/ioc_pd_free() deliver the callbacks then.
>> + */
> 
> blkcg_mutex doesn't serialize blkg creation. The IO path creates blkgs
> from bio_associate_blkg() through blkg_lookup_create(), before
> bio_queue_enter(), so the freeze doesn't stop it either, and
> blkg_create() runs pd_init and then list_add() to q->blkg_list under
> queue_lock only. Against the attach:
> 
> 1. ioc->attached is published, blkg_create() runs ioc_pd_init() which
>    delivers iocg_init(), then list_add(), then the walk delivers
>    iocg_init() again.
> 
> 2. blkg_create() runs ioc_pd_init() while attached is NULL, the walk runs
>    before list_add(), and the blkg never gets iocg_init() but gets
>    iocg_free() from ioc_pd_free() or the detach walk.
> 
> Detach has the mirror cases. The walk is also the only q->blkg_list
> walker without queue_lock, and a plain list_for_each_entry() against a
> concurrent list_add() isn't safe. The teardown walk this mirrors holds
> blkcg_mutex and queue_lock. Can you publish and clear ioc->attached and
> walk under queue_lock as well? ioc_pd_init() already calls iocg_init()
> under queue_lock, so nothing changes for the BPF side.
> 
> While at it, the walk goes newest first, so children usually get
> iocg_init() before their parents. blkcg_activate_policy() walks in
> reverse for that reason.
> 

You were right that blkcg_mutex alone did not serialize against blkg
creation from the IO path.  The attachment is now published and
cleared under blkcg_mutex and queue_lock, and the blkg walk is
performed under the same locking; the init walk goes parents first
like blkcg_activate_policy().

>> +	/* prevent multiple attach of the same struct_ops */
>> +	if (ops->q)
>> +		return -EINVAL;
> 
> On the link path the map stays READY after .unreg, so a map can be
> attached again through a new link. If the device goes away, the ejection
> clears ops->q while the old link is still open, a device with the same
> dev_t comes back and a new link attaches the same map, closing the old
> link then detaches the new attachment. Recording the owning link in the
> ops and having .unreg detach only when it matches would close that.
> 

Done: .unreg records the owning link in the ops and only detaches
when the closing link matches.

>> +	/*
>> +	 * check liveness and create the ioc under rq_qos_mutex, like
>> +	 * blkg_conf_open_bdev() does; enabling stays with io.cost.qos
>> +	 *
>> +	 * the queue reference is held across the unlocked window below:
>> +	 * the bdev reference does not pin the queue, bdev only holds a
>> +	 * raw bd_queue pointer, and concurrent device removal may eject
>> +	 * the model and free the ioc while we are off the mutex, so
>> +	 * without our own reference the second mutex_lock() would touch
>> +	 * a freed queue
>> +	 */
>> +	mutex_lock(&q->rq_qos_mutex);
>> +	if (!disk_live(disk) || !blk_get_queue(q)) {
> ...
>> +	ioc = q_to_ioc(q);
>> +	if (!ioc) {
>> +		ret = blk_iocost_init(disk);
>> +		mutex_unlock(&q->rq_qos_mutex);
> 
> Why drop rq_qos_mutex here? ioc_cost_model_write() holds it from
> blkg_conf_open_bdev() across blk_iocost_init() and its own freeze and
> quiesce, so attach can hold it from the disk_live() check through the
> unfreeze. Then the ioc can't be freed under us and the queue reference,
> the second q_to_ioc() check and this comment go away. The comment is also
> wrong: a whole-disk no-open bdev reference holds the disk device, and
> disk_release() is what drops the queue reference.
> 

Done: the attach holds rq_qos_mutex from the disk_live() check
through the unfreeze, like ioc_cost_model_write() does, so the unlock
window, the queue reference, the second q_to_ioc() and its comment
are gone.

Thanks.
Tao

> Thanks.
> 
> --
> tejun

