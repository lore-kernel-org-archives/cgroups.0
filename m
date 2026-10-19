Received: from mta1.migadu.com (out-136.mta1.migadu.com [95.215.58.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B5B48988A
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 09:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792402072; cv=none; b=bo+Td037XrT/+olwuqfjppVqQlFy3+mQ0agc2g4s216l1+JXUvCQBBsTIbZCM7IT1mAfDJJHAKr7zcpqLaSUrm/fOIlKB5Vq0cieNpmQuSYvrmomxgp3RK7qPP7MYvELo6w1v9u0Ml8Mf2VASn6YtNPuXKq8MFjDa52e1ttbRfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792402072; c=relaxed/simple;
	bh=f/nDQXbrNnEKOQiHibkqMq1fQgW6Pkq07/eBQN8jDkk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=G7i9j4E98bASrxB6ewvaWZyxNE6IjNTnSAZnzicmLGkQ0PwrUPGnJcl/e5IzRgo8bYNcd27agxvtW8QXn8ZBl9EhcdgXn4XjYBxKvUujjCJY2dQTr+t4T2BmYrE4Y415+0IZVcTmo+gYtUURuZI/bCzRLg0K0dwduUDUF6iYWk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=trD2hv1x; arc=none smtp.client-ip=95.215.58.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="trD2hv1x"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=f/nDQXbrNnEKOQiHibkqMq1fQgW6Pkq07/eBQN8jDkk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792402068; v=1; x=1793006868;
 b=trD2hv1xOLUH9u2ley3KNwBPvki0+lXRK2uZOwzhrySHYOIo80TIwBWL25iuBpifGQFxzTzt
 K6F9qTBogtLx8RnV1LJsagsonADk6J8HWX0bez9AhlhoEM7RS236tR2fjMavhgS1yM9Oq1y5XfQ
 0CjwHNPszsdMoNjiaSzsKyLw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 09fa13367a78f015;
	Mon, 19 Oct 2026 09:27:48 +0000
X-Mizu-Trace-ID: 09fa13367a78f015
X-Migadu-Flow: FLOW_OUT
Message-ID: <24699b2b-4637-4872-8706-4f92193fa3ac@linux.dev>
Date: Mon, 19 Oct 2026 17:27:40 +0800
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
Subject: Re: [RFC PATCH v10 1/4] blk-iocost: add BPF struct_ops cost model
 support
To: Tejun Heo <tj@kernel.org>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
 <20261003124045.1289305-2-cui.tao@linux.dev>
 <d6fb17fccb2338485821141c2ddc3d58@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <d6fb17fccb2338485821141c2ddc3d58@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Tejun,

在 2026/10/17 01:49, Tejun Heo 写道:
> Hello, Tao.
> 
> On Sat, 03 Oct 2026 20:40:42 +0800, Tao Cui wrote:
>> +config BLK_CGROUP_IOCOST_BPF
>> +	bool "Enable BPF pluggable cost model support for the cost IO controller"
>> +	depends on BLK_CGROUP_IOCOST && BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF
> 
> Does this need to be a separate config option? It doesn't add much code.
> Maybe just enable it when all the dependencies are available?
> bpf_tcp_ca.o, for example, is built whenever CONFIG_BPF_SYSCALL is set.
> 
Agreed, one less option is better. It's now a hidden def_bool with the
dependency list and no prompt, so it's enabled automatically whenever
the dependencies are available.

>> +	 to.  The struct_ops is attached per device, following the
>> +	 hid_bpf_ops model.
> 
> Can you drop the hid_bpf_ops references here, in the comments and in the
> selftest?
> 
Dropped from the Kconfig (which is gone with the hidden option), from
the file comment and from the selftest.

>> +bool blk_get_queue_rcu(struct request_queue *q)
>> +{
>> +	return refcount_inc_not_zero(&q->refs);
>> +}
> 
> I don't like the name. blk_get_queue() fails on a dying queue like
> css_tryget_online(), while this only fails once the refcount reaches zero
> like css_tryget(). Maybe blk_tryget_queue() or blk_queue_tryget()? I'd
> also put it in a separate patch, but it may not be needed at all, see
> below.
> 
It's gone entirely with the rework below; the map reference covers the
queue lifetime now, so the naming question resolves itself.

>> +static int bpf_iocost_validate(void *kdata)
>> +{
>> +	struct iocost_model_ops *ops = kdata;
>> +
>> +	return ops->calc_cost ? 0 : -EINVAL;
>> +}
> 
> read_vtime_per_page and write_vtime_per_page aren't checked. With zero,
> size_nsec in ioc_rqos_done() is zero for every READ and WRITE, and the
> whole on-queue time is judged against the latency targets. Maybe reject
> zero or fall back to the builtin coefficients?
> 
You're right. The zero case would silently change the done path. v11
rejects zero: a model must provide both coefficients explicitly.
Falling back to the builtin silently seemed worse than failing the
load.

>> +#include <linux/blk-iocost.h>
> 
> The header's name doesn't match its content, which is only the BPF model
> interface. Only block/blk-iocost.c and block/blk-iocost-bpf.c include it,
> so it doesn't need to be in include/linux either. Its
> !CONFIG_BLK_CGROUP_IOCOST_BPF stubs for ioc_bpf_attach() and
> ioc_bpf_detach() are never used, as their only caller is built under the
> same option.
> 
Agreed on all three counts. blk-iocost.h moved to block/ as a private
header holding the common definitions, the ops struct lives there now,
and the unused stubs are gone.

>> +static const struct iocost_model_ops *ioc_model_in_use(struct ioc *ioc)
> ...
>> +static const struct iocost_model_ops *ioc_attached_or_null(struct ioc *ioc)
> ...
>> +ioc_model_in_use_locked(struct ioc *ioc)
> 
> Aren't ioc_attached_or_null() and ioc_model_in_use_locked() misnomers?
> ioc_model_in_use() returns NULL while the builtin model is in use, and
> "_or_null" doesn't add anything.
> 
You're right, the names described the call sites rather than what the
functions return. ioc_attached_or_null() is now
ioc_attached_model_locked() and ioc_model_in_use() is
ioc_bpf_model_locked(); the hot-path dispatch moved into the
ioc_model_calc_cost()/ioc_model_size_cost() helpers, which take and
release rcu_read_lock() themselves.

>> +	rcu_read_lock();
>> +	model = ioc_model_in_use(iocg->ioc);
>> +	if (model) {
>> +		cost = model->calc_cost(bio,
>> +				is_merge ? IOCOST_COST_F_MERGE : 0);
> 
> Can the model cost calculation be wrapped in an inline helper in the
> header so that it compiles out completely when disabled?
> 
Done; it's an inline helper in the private header next to the ops
struct, and with the BPF support compiled out it degenerates to the
builtin dispatch and the whole path compiles away.

>> +	if (model && (req_op(rq) == REQ_OP_READ ||
>> +		      req_op(rq) == REQ_OP_WRITE)) {
>> +		unsigned int pages =
>> +			blk_rq_stats_sectors(rq) >> IOC_SECT_TO_PAGE_SHIFT;
> 
> The model-specific calculation probably belongs on the BPF model side
> instead of being open-coded here. Also, ioc_rqos_done(), the only caller,
> returns early for anything but READ and WRITE, so the op test isn't
> needed.
> 
Moved t

>> +static void ioc_bpf_eject(struct ioc *ioc)
> 
> The source file split doesn't make sense as is. ioc_bpf_eject() and
> ioc_bpf_walk_iocgs() are BPF-only but sit in blk-iocost.c because they
> need struct ioc and helpers which are private to it. If the BPF parts are
> to live in a separate file, can a prep patch move the common definitions
> into a private header so that everything can go where it belongs?
> 
Yes, the split grew organically and ended up misplaced. The series now
starts with a prep patch which moves the enums, struct ioc/ioc_gq and
the accessors into block/blk-iocost.h, and the whole BPF side lives in
blk-iocost-bpf.c now: attach, detach, the ejection and the callback
delivery.

>> +	ops = (struct iocost_model_ops *)rcu_dereference_protected(
>> +			ioc->attached, lockdep_is_held(&ioc->lock));
> 
> The const cast is still here.
> 
Sorry, missed that one. Gone with the rework; the recorded owner is a
plain pointer.

>> +	/*
>> +	 * ioc->attached and ioc->model are left set: the ioc is freed
>> +	 * right below, so clearing them buys nothing, and any
>> +	 * ioc_pd_free() which still runs finds the attachment and
>> +	 * delivers its iocg_free() through the struct_ops image grace
>> +	 * period instead of silently losing it.
>> +	 */
> 
> blkcg_deactivate_policy() has already freed and cleared the pd of every
> blkg on q->blkg_list, and nothing keeps the map alive once ops->q is
> cleared, so there is no such grace period.
> 
You're right, and thank you for the correction: that comment was just
wrong, there is no grace period there. The v11 removal path clears the
ioc pointers and drops the map reference, and the comment describes
that.

>> +	smp_store_release(&ops->q, NULL);
> 
> What's the smp_store_release() for? More on this below.
> 
>> +	rcu_read_lock();
>> +	model = ioc_attached_or_null(ioc);
>> +	if (model && model->iocg_init) {
>> +		model->iocg_init(blkg->blkcg, ioc->rqos.disk->queue);
>> +		iocg->bpf_iocg_inited = true;
>> +	}
>> +	rcu_read_unlock();
> 
> ioc_pd_init() isn't a hot path, and both of its callers hold queue_lock,
> which attach and detach also hold while changing ioc->attached. Can the
> synchronization be simplified?
> 
Simplified as you suggest. The callbacks now read ioc->attached
directly. ioc_pd_init() runs under queue_lock, the free path under
blkcg_mutex, and attach/detach update the pointer while holding the
corresponding lock.

>> +		if (iocg->bpf_iocg_inited) {
>> +			rcu_read_lock();
>> +			model = ioc_attached_or_null(ioc);
> 
> Ditto. This runs under blkcg_mutex, which attach and detach also hold. Is
> the lockless dance necessary?
> 
> The pairing also has holes. blkg_create() calls pd_init before
> radix_tree_insert(), and a blkg whose insert fails never reaches
> q->blkg_list. If model A is detached and model B attached before that blkg
> is freed, neither walk sees it and ioc_pd_free() delivers B's iocg_free()
> for a cgroup which only got A's iocg_init(). The attach walk also delivers
> iocg_init() to blkgs which blkg_destroy() already took offline but which
> stay on q->blkg_list until blkg_free_workfn().
> 
> blkg_create() calls pd_online_fn only after a successful insert and
> list_add(), blkg_destroy() and blkcg_policy_teardown_pds() call
> pd_offline_fn, and pd->online tracks the state, all under queue_lock.
> Would delivering iocg_init() from a new ioc_pd_online() and iocg_free()
> from ioc_pd_offline(), with the walks skipping blkgs whose pd->online is
> clear, work? That would pair the callbacks exactly without bpf_iocg_inited
> or the radix_tree_insert() exception.
> 
> The catch is that iocg_free() then runs at blkg destruction, and bios
> still holding the blkg can be priced afterwards, e.g. the ones
> throtl_pd_offline() flushes. Moving only iocg_init() to pd_online and
> keeping the flag for iocg_free() avoids that.
> 
You're right about the hole, and v11 follows that approach:
iocg_init() is delivered from a new ioc_pd_online(), which
blkg_create() calls only after the successful radix_tree_insert() and
list_add(), the walks skip blkgs whose pd->online is clear, and
iocg_free() keeps the delivered flag so it is not delivered while bios
can still be priced against the blkg.

>> +static void ioc_bpf_walk_iocgs(struct ioc *ioc,
>> +			       const struct iocost_model_ops *ops, bool init)
> 
> The name is a misnomer, this delivers the cgroup callbacks.
> 
Renamed to ioc_bpf_deliver_iocg_callbacks().

>> +	 * blkg_create() holds blkcg_mutex across ioc_pd_init() and the
>> +	 * list_add(), and blkg_free_workfn() holds blkcg_mutex across
> 
> On the bio path, blkg_create() runs from blkg_tryget_closest() under
> queue_lock only. The walk is correct because it also holds queue_lock, but
> this comment, the description and the cover letter still give the v8
> reasoning.
> 
Updated; the comment and the description now say the walk is correct
because it holds queue_lock, which is what the bio path uses.

>> +	 * the freeze is taken before rq_qos_mutex; taking the mutex
>> +	 * around the freeze instead cycles against the io.cost.qos
>> +	 * write path, which freezes with the mutex held.  Holding
> 
> ioc_qos_write() drops rq_qos_mutex before freezing. It's io.cost.model
> writes which freeze with the mutex held, so the cover letter's "under the
> same freeze and quiesce those writes go through" doesn't hold for the
> order either.
> 
That's right, the comment was wrong. It now says the attach and detach
order matches ioc_qos_write()'s, which is what the code does, and the
cover letter no longer claims the io.cost.model write ordering.

>> +	if (smp_load_acquire(&ops->q)) {
>> +		mutex_unlock(&q->rq_qos_mutex);
>> +		blk_mq_unfreeze_queue(q, memflags);
>> +		ret = -EBUSY;
>> +		goto put;
>> +	}
> 
> What's going on with the smp_load_acquire() here and the
> smp_store_release() above? The comment doesn't make clear what they're
> ordering against. Is this necessary?
> 
> They order the ops->link updates across different devices, which share no
> lock. However, ops->dev is set by init_member() while the map is still
> being initialized, so it can't change once .reg runs, and every attach of
> a map resolves the same dev_t. That should allow dropping bdev, q and link
> from the ops:
> 
> 1. Attach looks up ops->dev and checks disk_live() under rq_qos_mutex as
>    now, records the owning link in the ioc next to ioc->attached, takes a
>    map reference with bpf_struct_ops_get(), and puts the bdev before
>    returning.
> 
> 2. .unreg looks up ops->dev the same way and detaches only if
>    ioc->attached and the recorded link match. If the lookup fails, there
>    is nothing to do, as removal ejects the model on its own.
> 
> 3. Removal clears the ioc pointers and puts the map reference without
>    touching the ops.
> 
> The map reference keeps ioc->attached valid when .unreg can't find a
> device which del_gendisk() has unhashed but not yet torn down. This would
> remove blk_get_queue_rcu(), the const cast and the acquire/release
> pairing.
> 
Thank you for spelling this out; it's a much cleaner shape. Reworked
accordingly: attach looks up ops->dev and checks disk_live() under
rq_qos_mutex, records the owning link next to ioc->attached and takes
a reference on the map with bpf_struct_ops_get(), putting the bdev
before returning; .unreg looks the device up the same way and
detaches only when ioc->attached and the recorded link both match,
treating a failed lookup as nothing to do; the removal path clears
the ioc pointers and drops the map reference without touching the
ops. bdev, q and link are gone from the ops along with the
acquire/release pairing.

> Also, the error paths repeat the unlock sequences. Can this use guard()?
> 
Switched to guard() for the mutex.

>> +void ioc_bpf_detach(struct iocost_model_ops *ops, struct bpf_link *link,
>> +		   struct request_queue *q)
> ...
>> +	memflags = blk_mq_freeze_queue(q);
>> +	blk_mq_quiesce_queue(q);
>> +
>> +	mutex_lock(&q->rq_qos_mutex);
>> +
>> +	ioc = q_to_ioc(q);
> 
> .unreg holds only a queue reference here, which doesn't keep the tag set
> around. If the device is removed after blk_get_queue_rcu(), e.g.
> virtblk_remove() running del_gendisk() and blk_mq_free_tag_set() and then
> freeing vblk, blk_mq_quiesce_queue() reads the freed q->tag_set in
> blk_mq_wait_quiesce_done(). This hasn't been reproduced.
> 
> Can the ioc and the owning link be checked under rq_qos_mutex before
> quiescing? Removal ejects the model under rq_qos_mutex before the driver
> frees the tag set, so a matching attachment under the mutex means the tag
> set is still there.
> 
Good catch. v11 now performs an initial check under
rq_qos_mutex before freezing, then re-checks after freezing before
quiescing, so a successful second check guarantees that the tag set
is still alive.

>> +				/* staged and committed below, so a parse
>> +				 * error later in the same write leaves
>> +				 * the model selection untouched
>> +				 */
> 
> This and the comment in bpf_iocost_unreg() put text on the /* or */ line.
> Also, let's not use double spaces after periods. I know there are some in
> these files already, but let's not spread them further. Lines are also
> broken prematurely in many places, e.g. the calc_cost() call above fits in
> 79 columns and the ioc_cost_model_prfill() hunk rewraps existing lines
> which fit, although I'm not sure what the block tree's policy is here.
> 
The two comment openings are fixed in v11 already; the double spaces
and the premature line breaks are cleaned up throughout, and the
ioc_cost_model_prfill() hunk no longer rewraps lines that fit.

> Overall, this still looks sloppy. Can you go through the code and make
> sure that each part is necessary and sits in the right place?
> 
Fair. I went through the whole series again rather than just fixing
the individual comments. A number of comments and helpers had drifted
during the v8-v10 rework, so I cleaned those up as well. Hopefully
v11 is a better reflection of the code now.

Thanks again for the review.

Tao

> Thanks.
> 

