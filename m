Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748623F1AAD
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 02:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789440486; cv=none; b=F3lcDL3gAV7QQOoHx2GwjwHqAdLdaMm8UlZKmWTFqg99qJ10mfeJtbggYGT0/wpUQJOsmX1etba8DADleUzp6hI3SzHMlvK38ELaQyDkJKTsjhWOvcPh1+0b7I1YvBQSR+X/rHbQ2wZHesMQz/wDuLH0mRMPk6Gn+rD7BTPZoAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789440486; c=relaxed/simple;
	bh=dg2HRw5LMUit+a+Lv3CITObMCSjJD6X/Pd5b9KHsSyQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RQsaNETCSxFdWbkFMhZzvfF+wL7hvGxefl0Esj/BI6kzYkxyQOwm7Y6gu/wJJjVlUL7q8/XbftAunhDg1RPmdO84R3lAvSu8TjWLEw51mN6FtQuJPdjAabZBC6HJrHEEOLGlv8UVuiLBdZuC4Pk6xJAtNyvbomkHgE0TkzqSUtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FlpPN0w8; arc=none smtp.client-ip=91.218.175.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FlpPN0w8"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dg2HRw5LMUit+a+Lv3CITObMCSjJD6X/Pd5b9KHsSyQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789440480; v=1; x=1790045280;
 b=FlpPN0w83eMNQoWDOVcPfvKNm5p7Fctfss/2Enl29uDmZuOL/hdV5KKhv936thie/DqQ+RHt
 lryjeDWvQC+F5V/iTBN5e04ynnT1564Ijl0PDXNLzs1fQgPJ05PEL9rAyvXehs+u4u5vW351paG
 yvrTsESySGmmYOWd+si9ercA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d5573e5db9cff029;
	Tue, 15 Sep 2026 02:48:00 +0000
X-Mizu-Trace-ID: d5573e5db9cff029
X-Migadu-Flow: FLOW_OUT
Message-ID: <04c3ccfb-75e7-484a-b99c-ad68db19153d@linux.dev>
Date: Tue, 15 Sep 2026 10:47:57 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 cuitao@kylinos.cn
Subject: Re: [RFC PATCH v3 1/5] blk-iocost: add BPF struct_ops cost model
 support
To: Amery Hung <ameryhung@gmail.com>
References: <20260914073356.791518-1-cui.tao@linux.dev>
 <20260914073356.791518-2-cui.tao@linux.dev>
 <CAMB2axNkTS-UuH-KctiY+5qh-JZZkKsiyQr_KOnGJt1bPoL3eA@mail.gmail.com>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <CAMB2axNkTS-UuH-KctiY+5qh-JZZkKsiyQr_KOnGJt1bPoL3eA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Amery,

Thanks for the review.  These are all addressed in the upcoming v4,
inline below.

在 2026/9/15 07:02, Amery Hung 写道:
> I mostly looked from a struct_ops perspective.
> 
>> +
>> +static const struct bpf_func_proto *
>> +bpf_iocost_get_func_proto(enum bpf_func_id func_id,
>> +                         const struct bpf_prog *prog)
>> +{
>> +       switch (func_id) {
>> +#ifdef CONFIG_CGROUPS
>> +       case BPF_FUNC_cgrp_storage_get:
>> +               return &bpf_cgrp_storage_get_proto;
> 
> This seems redundant. BPF_FUNC_cgrp_storage_get should already be part
> of bpf_base_func_proto.

Agreed.  get_func_proto() now just delegates to bpf_base_func_proto().
I kept the callback itself, since the verifier resolves helpers
through ops->get_func_proto() and there is no NULL fallback.

> 
>> +#endif
>> +       default:
>> +               return bpf_base_func_proto(func_id, prog);
>> +       }
>> +}
>> +
>> +static int bpf_iocost_check_member(const struct btf_type *t,
>> +                                  const struct btf_member *member,
>> +                                  const struct bpf_prog *prog)
>> +{
>> +       /* calc_cost() is called with RCU read lock held */
>> +       if (prog->sleepable)
>> +               return -EINVAL;
>> +       return 0;
>> +}
>> +
>> +static int bpf_iocost_init_member(const struct btf_type *t,
>> +                                 const struct btf_member *member,
>> +                                 void *kdata, const void *udata)
>> +{
>> +       struct iocost_model_ops *ops = kdata;
>> +       const struct iocost_model_ops *uops = udata;
>> +       u32 moff = __btf_member_bit_offset(t, member) / 8;
>> +
>> +       switch (moff) {
>> +       case offsetof(struct iocost_model_ops, name):
>> +               if (bpf_obj_name_cpy(ops->name, uops->name,
>> +                                    sizeof(ops->name)) <= 0)
>> +                       return -EINVAL;
>> +               return 1;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static u64 bpf_iocost_calc_cost_stub(u64 opf, u64 nbytes, u64 sector,
>> +                                    struct blkcg *blkcg, u64 model_flags);
>> +
>> +/*
>> + * kdata is seeded from the CFI stubs, so calc_cost is never NULL; a
>> + * model which did not implement it inherits the stub, which prices
>> + * every IO at 0.  Compare against the stub to reject it.
>> + */
>> +static int bpf_iocost_validate(void *kdata)
>> +{
>> +       struct iocost_model_ops *ops = kdata;
>> +
>> +       if (ops->calc_cost == bpf_iocost_calc_cost_stub)
>> +               return -EINVAL;
> 
> This should check !ops->calc_cost. CFI stubs are used to construct
> trampolines; they are not copied into kdata for callbacks omitted by
> userspace. Also, should the reserved name "linear" be rejected here?

I already reworked the validation to check for a NULL calc_cost(),
matching your observation that omitted callbacks remain NULL rather
than inheriting the CFI stub.

A model named "linear" is now rejected as well.

> 
>> +       return 0;
>> +}
>> +
>> +static int bpf_iocost_reg(void *kdata, struct bpf_link *link)
>> +{
>> +       struct iocost_model_ops *ops = kdata;
>> +       struct iocost_bpf_model *m;
>> +       int ret = 0;
>> +
>> +       if (!bpf_struct_ops_get(ops))
>> +               return -ENOENT;
> 
> struct_ops core should hold a map reference when calling .reg().
> Calling bpf_struct_ops_get() in reg() and bpf_struct_ops_put() in
> unreg() doesn't seem necessary.

Right, the core already holds the map reference during registration,
so I dropped the bpf_struct_ops_get()/put() calls from .reg()/.unreg().
The per-device binding references remain, so an unregistered but still
bound model keeps its kdata alive.

> 
>> +
>> +       m = kzalloc(sizeof(*m), GFP_KERNEL);
>> +       if (!m) {
>> +               bpf_struct_ops_put(ops);
>> +               return -ENOMEM;
>> +       }
>> +       refcount_set(&m->refs, 1);
>> +
>> +       mutex_lock(&iocost_bpf_reg_lock);
>> +       {
>> +               struct iocost_bpf_model *other;
>> +
>> +               list_for_each_entry(other, &iocost_bpf_models, list) {
>> +                       if (!strcmp(other->ops->name, ops->name)) {
>> +                               ret = -EEXIST;
>> +                               break;
>> +                       }
>> +               }
>> +       }
>> +       if (!ret) {
>> +               m->ops = ops;
>> +               list_add(&m->list, &iocost_bpf_models);
>> +               list_add(&m->lifecycle, &iocost_bpf_lifecycle);
> 
> This seems to contradict what the changelog says: "blkcg
> online/offline notifications follow the model binding, not the name
> registry"

Right, the implementation didn't match the changelog.  The lifecycle
list now follows model binding: a model joins it on the first bind
and leaves on the last unbind.

> 
>> +       }
>> +       mutex_unlock(&iocost_bpf_reg_lock);
>> +
>> +       if (ret) {
>> +               bpf_struct_ops_put(ops);
>> +               kfree(m);
>> +       }
>> +       return ret;
>> +}
>> +
>> +/*
>> + * Unregistering drops the registration reference.  When the last
>> + * reference is gone (no device bound), the node leaves the lifecycle
>> + * list and is freed; otherwise bound devices keep it alive and it
>> + * keeps receiving blkcg online/offline notifications.
>> + */
>> +static void bpf_iocost_unreg(void *kdata, struct bpf_link *link)
>> +{
>> +       struct iocost_model_ops *ops = kdata;
>> +       struct iocost_bpf_model *m;
>> +
>> +       mutex_lock(&iocost_bpf_reg_lock);
>> +       m = iocost_bpf_model_lookup(ops);
>> +       if (m) {
>> +               list_del(&m->list);
>> +               if (refcount_dec_and_test(&m->refs)) {
>> +                       list_del(&m->lifecycle);
>> +                       kfree(m);
>> +               }
>> +       }
>> +       mutex_unlock(&iocost_bpf_reg_lock);
>> +
>> +       bpf_struct_ops_put(ops);
> 
> Mentioned above. Doesn't seem to be necessary.
> 
> [...]
> 
>> +static const struct iocost_model_ops *
>> +ioc_bpf_model_prepare(const char *name)
>> +{
>> +#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
>> +       const struct iocost_model_ops *new = NULL;
>> +       int ret;
>> +
>> +       if (!name[0])
>> +               return NULL;
>> +       ret = iocost_bpf_model_get(name, &new);
> 
> It looks more straightforward if iocost_bpf_model_get() just return
> the ops ptr and ERR_PTR on error.

iocost_bpf_model_get() now returns either the ops pointer or an
ERR_PTR() directly.

I'll post v4 shortly.

Thanks,
Tao

> 
>> +       return ret ? ERR_PTR(ret) : new;
>> +#else
>> +       return name[0] ? ERR_PTR(-ENOENT) : NULL;
>> +#endif
>> +}

