Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912B8595738;
	Fri, 16 Oct 2026 17:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792172997; cv=none; b=Sqra2xGyecRc5AA4iAneGK9NnR+nLZH5oeArdpO+vknZISnKsuUIRkNp0pakMUp4qvQXWsZsnAiUAJ6KNeb+60iHnOW/bmBPmnt5DevUPSR5cshCakR/wucmYHERHkM995uzpmBVij8XsPFRowFrW6YLo/4fAT/PZly5iR4oMGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792172997; c=relaxed/simple;
	bh=+go7rvte6Dt1AU2oMjjJxHvZ50k5JEwWpRZ4LaxaVPQ=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ALe1RzolDTWyT71hYGntjdkYqE+2JcUrMJRiWGx/fzT8ln04pvTlewMYaK3GGeh5bORJNwtTJTtuvVADwOUW74TbEhNaDm20JljqWVsKbOB6E2Kb0nbD7P0RDzIbl3YxEMbmnU1PaRh5kB25aFEm6zEawGGNm0cByO41R9KZOQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IFKmagrf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IFKmagrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E331B1F000C5;
	Fri, 16 Oct 2026 17:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792172996;
	bh=8mFYSu7o6g86uhP8wO/80nNj5W/oeelu78yD3878HLM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IFKmagrfCi9jfME12IcG6mjhmMaSo1JUzXS4KOW1RdePOxEXWUVQJzIgjK//oOMli
	 GqeRPtnoq4bhkE2wQaKhQQr35DToV9OCBu15JgNGZiOA2M+4a/1DxEfK4SL+TzqfGk
	 X2rybZczmK6GSTMyF5NDqEZTGbbbjLehaZdTSjpgUQn677+X6WJM9jqBhIKKeIiP3D
	 oRba617dHn9HoBNhEJ4rwhpR34TXDtUtPIR4ONxMOwobZcpbxhDJ8xkRlWxmlOUZ2s
	 /IQx2PDVkvz0z15SOLgzSeCJHJbuJ39M/QtYU1nfSZyeewiVDnHDuwGpM9eY6XhTTs
	 K6jR2DWSKLytQ==
Date: Fri, 16 Oct 2026 07:49:55 -1000
Message-ID: <d6fb17fccb2338485821141c2ddc3d58@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v10 1/4] blk-iocost: add BPF struct_ops cost model support
In-Reply-To: <20261003124045.1289305-2-cui.tao@linux.dev>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
 <20261003124045.1289305-2-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Tao.

On Sat, 03 Oct 2026 20:40:42 +0800, Tao Cui wrote:
> +config BLK_CGROUP_IOCOST_BPF
> +	bool "Enable BPF pluggable cost model support for the cost IO controller"
> +	depends on BLK_CGROUP_IOCOST && BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF

Does this need to be a separate config option? It doesn't add much code.
Maybe just enable it when all the dependencies are available?
bpf_tcp_ca.o, for example, is built whenever CONFIG_BPF_SYSCALL is set.

> +	 to.  The struct_ops is attached per device, following the
> +	 hid_bpf_ops model.

Can you drop the hid_bpf_ops references here, in the comments and in the
selftest?

> +bool blk_get_queue_rcu(struct request_queue *q)
> +{
> +	return refcount_inc_not_zero(&q->refs);
> +}

I don't like the name. blk_get_queue() fails on a dying queue like
css_tryget_online(), while this only fails once the refcount reaches zero
like css_tryget(). Maybe blk_tryget_queue() or blk_queue_tryget()? I'd
also put it in a separate patch, but it may not be needed at all, see
below.

> +static int bpf_iocost_validate(void *kdata)
> +{
> +	struct iocost_model_ops *ops = kdata;
> +
> +	return ops->calc_cost ? 0 : -EINVAL;
> +}

read_vtime_per_page and write_vtime_per_page aren't checked. With zero,
size_nsec in ioc_rqos_done() is zero for every READ and WRITE, and the
whole on-queue time is judged against the latency targets. Maybe reject
zero or fall back to the builtin coefficients?

> +#include <linux/blk-iocost.h>

The header's name doesn't match its content, which is only the BPF model
interface. Only block/blk-iocost.c and block/blk-iocost-bpf.c include it,
so it doesn't need to be in include/linux either. Its
!CONFIG_BLK_CGROUP_IOCOST_BPF stubs for ioc_bpf_attach() and
ioc_bpf_detach() are never used, as their only caller is built under the
same option.

> +static const struct iocost_model_ops *ioc_model_in_use(struct ioc *ioc)
...
> +static const struct iocost_model_ops *ioc_attached_or_null(struct ioc *ioc)
...
> +ioc_model_in_use_locked(struct ioc *ioc)

Aren't ioc_attached_or_null() and ioc_model_in_use_locked() misnomers?
ioc_model_in_use() returns NULL while the builtin model is in use, and
"_or_null" doesn't add anything.

> +	rcu_read_lock();
> +	model = ioc_model_in_use(iocg->ioc);
> +	if (model) {
> +		cost = model->calc_cost(bio,
> +				is_merge ? IOCOST_COST_F_MERGE : 0);

Can the model cost calculation be wrapped in an inline helper in the
header so that it compiles out completely when disabled?

> +	if (model && (req_op(rq) == REQ_OP_READ ||
> +		      req_op(rq) == REQ_OP_WRITE)) {
> +		unsigned int pages =
> +			blk_rq_stats_sectors(rq) >> IOC_SECT_TO_PAGE_SHIFT;

The model-specific calculation probably belongs on the BPF model side
instead of being open-coded here. Also, ioc_rqos_done(), the only caller,
returns early for anything but READ and WRITE, so the op test isn't
needed.

> +static void ioc_bpf_eject(struct ioc *ioc)

The source file split doesn't make sense as is. ioc_bpf_eject() and
ioc_bpf_walk_iocgs() are BPF-only but sit in blk-iocost.c because they
need struct ioc and helpers which are private to it. If the BPF parts are
to live in a separate file, can a prep patch move the common definitions
into a private header so that everything can go where it belongs?

> +	ops = (struct iocost_model_ops *)rcu_dereference_protected(
> +			ioc->attached, lockdep_is_held(&ioc->lock));

The const cast is still here.

> +	/*
> +	 * ioc->attached and ioc->model are left set: the ioc is freed
> +	 * right below, so clearing them buys nothing, and any
> +	 * ioc_pd_free() which still runs finds the attachment and
> +	 * delivers its iocg_free() through the struct_ops image grace
> +	 * period instead of silently losing it.
> +	 */

blkcg_deactivate_policy() has already freed and cleared the pd of every
blkg on q->blkg_list, and nothing keeps the map alive once ops->q is
cleared, so there is no such grace period.

> +	smp_store_release(&ops->q, NULL);

What's the smp_store_release() for? More on this below.

> +	rcu_read_lock();
> +	model = ioc_attached_or_null(ioc);
> +	if (model && model->iocg_init) {
> +		model->iocg_init(blkg->blkcg, ioc->rqos.disk->queue);
> +		iocg->bpf_iocg_inited = true;
> +	}
> +	rcu_read_unlock();

ioc_pd_init() isn't a hot path, and both of its callers hold queue_lock,
which attach and detach also hold while changing ioc->attached. Can the
synchronization be simplified?

> +		if (iocg->bpf_iocg_inited) {
> +			rcu_read_lock();
> +			model = ioc_attached_or_null(ioc);

Ditto. This runs under blkcg_mutex, which attach and detach also hold. Is
the lockless dance necessary?

The pairing also has holes. blkg_create() calls pd_init before
radix_tree_insert(), and a blkg whose insert fails never reaches
q->blkg_list. If model A is detached and model B attached before that blkg
is freed, neither walk sees it and ioc_pd_free() delivers B's iocg_free()
for a cgroup which only got A's iocg_init(). The attach walk also delivers
iocg_init() to blkgs which blkg_destroy() already took offline but which
stay on q->blkg_list until blkg_free_workfn().

blkg_create() calls pd_online_fn only after a successful insert and
list_add(), blkg_destroy() and blkcg_policy_teardown_pds() call
pd_offline_fn, and pd->online tracks the state, all under queue_lock.
Would delivering iocg_init() from a new ioc_pd_online() and iocg_free()
from ioc_pd_offline(), with the walks skipping blkgs whose pd->online is
clear, work? That would pair the callbacks exactly without bpf_iocg_inited
or the radix_tree_insert() exception.

The catch is that iocg_free() then runs at blkg destruction, and bios
still holding the blkg can be priced afterwards, e.g. the ones
throtl_pd_offline() flushes. Moving only iocg_init() to pd_online and
keeping the flag for iocg_free() avoids that.

> +static void ioc_bpf_walk_iocgs(struct ioc *ioc,
> +			       const struct iocost_model_ops *ops, bool init)

The name is a misnomer, this delivers the cgroup callbacks.

> +	 * blkg_create() holds blkcg_mutex across ioc_pd_init() and the
> +	 * list_add(), and blkg_free_workfn() holds blkcg_mutex across

On the bio path, blkg_create() runs from blkg_tryget_closest() under
queue_lock only. The walk is correct because it also holds queue_lock, but
this comment, the description and the cover letter still give the v8
reasoning.

> +	 * the freeze is taken before rq_qos_mutex; taking the mutex
> +	 * around the freeze instead cycles against the io.cost.qos
> +	 * write path, which freezes with the mutex held.  Holding

ioc_qos_write() drops rq_qos_mutex before freezing. It's io.cost.model
writes which freeze with the mutex held, so the cover letter's "under the
same freeze and quiesce those writes go through" doesn't hold for the
order either.

> +	if (smp_load_acquire(&ops->q)) {
> +		mutex_unlock(&q->rq_qos_mutex);
> +		blk_mq_unfreeze_queue(q, memflags);
> +		ret = -EBUSY;
> +		goto put;
> +	}

What's going on with the smp_load_acquire() here and the
smp_store_release() above? The comment doesn't make clear what they're
ordering against. Is this necessary?

They order the ops->link updates across different devices, which share no
lock. However, ops->dev is set by init_member() while the map is still
being initialized, so it can't change once .reg runs, and every attach of
a map resolves the same dev_t. That should allow dropping bdev, q and link
from the ops:

1. Attach looks up ops->dev and checks disk_live() under rq_qos_mutex as
   now, records the owning link in the ioc next to ioc->attached, takes a
   map reference with bpf_struct_ops_get(), and puts the bdev before
   returning.

2. .unreg looks up ops->dev the same way and detaches only if
   ioc->attached and the recorded link match. If the lookup fails, there
   is nothing to do, as removal ejects the model on its own.

3. Removal clears the ioc pointers and puts the map reference without
   touching the ops.

The map reference keeps ioc->attached valid when .unreg can't find a
device which del_gendisk() has unhashed but not yet torn down. This would
remove blk_get_queue_rcu(), the const cast and the acquire/release
pairing.

Also, the error paths repeat the unlock sequences. Can this use guard()?

> +void ioc_bpf_detach(struct iocost_model_ops *ops, struct bpf_link *link,
> +		   struct request_queue *q)
...
> +	memflags = blk_mq_freeze_queue(q);
> +	blk_mq_quiesce_queue(q);
> +
> +	mutex_lock(&q->rq_qos_mutex);
> +
> +	ioc = q_to_ioc(q);

.unreg holds only a queue reference here, which doesn't keep the tag set
around. If the device is removed after blk_get_queue_rcu(), e.g.
virtblk_remove() running del_gendisk() and blk_mq_free_tag_set() and then
freeing vblk, blk_mq_quiesce_queue() reads the freed q->tag_set in
blk_mq_wait_quiesce_done(). This hasn't been reproduced.

Can the ioc and the owning link be checked under rq_qos_mutex before
quiescing? Removal ejects the model under rq_qos_mutex before the driver
frees the tag set, so a matching attachment under the mutex means the tag
set is still there.

> +				/* staged and committed below, so a parse
> +				 * error later in the same write leaves
> +				 * the model selection untouched
> +				 */

This and the comment in bpf_iocost_unreg() put text on the /* or */ line.
Also, let's not use double spaces after periods. I know there are some in
these files already, but let's not spread them further. Lines are also
broken prematurely in many places, e.g. the calc_cost() call above fits in
79 columns and the ioc_cost_model_prfill() hunk rewraps existing lines
which fit, although I'm not sure what the block tree's policy is here.

Overall, this still looks sloppy. Can you go through the code and make
sure that each part is necessary and sits in the right place?

Thanks.

-- 
tejun
