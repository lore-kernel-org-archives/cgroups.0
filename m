Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C299396D1A
	for <cgroups@vger.kernel.org>; Mon, 14 Sep 2026 23:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789426959; cv=pass; b=PCRM6jd/7mSZPjNrQPllKAChRzXqqbfkNjpNrelCvWVwuupUWShvd4ZeF7rE/8NYo0R6/5DtewYo0XBLqd4Vn8D8gAUvb3Rg6GFZWv3mtpZIoSUUrXlIMUS2YYIYIECVfvRGPBX9inK7C8OUMoYB/hVmfp2DCFves82IwapGU3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789426959; c=relaxed/simple;
	bh=HnZj22pjlGHIEfM6bhLJdkIF85ojkiFcxZaEA0PyVZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t6EGNR4y1PZEfl347Lva842mrJ0JCBpO/W/8xYJpTh+FCEDHJ9Xls0htlJCy6KEZobUitMFr/n3cA+/crEtGwzSPjmN/IgeIN84pLK1g2RcIsvrD1hcVVMonQ+GoKshsHAOZR0yzda7IVaBXfA2Nq0B1GMMUWUWZQek+0gRVVRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=njLUo9f6; arc=pass smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="njLUo9f6"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7f57db8b5a4so3482374a34.2
        for <cgroups@vger.kernel.org>; Mon, 14 Sep 2026 16:02:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789426956; cv=none;
        d=google.com; s=arc-20260327;
        b=hmD1S8Z16nQWzF8pT8u0PmlEFxuKawh6rBBNyLuRKQIHfV7Frf887jWufYLOYutXtK
         BmcN1JJRuuFg845i+SZf65KJUDzPtwOUceuA+YuA/QUDQj4mxNSG3moLWJXb67p0tfIR
         LUyliCUshzJ68GQ8aY1iccDzxXyTRsPBIHnPDKSCO9UzJhKTtN/UoIsj3JtHKTnbSkyK
         Ng9VXo4sHexV46fQfMKRDMWs58M2KKtZyC2vQm894dxOw3UuW4TXRo369OQoxjsnQjeq
         1gA+BR7VW6UI3uLu7Fra129CSouKwFdKxq6Ablu4h9gKe7kf1Mcr/gEesCXitf58FMOm
         7noQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=pOUFKWLA82ZDA522DpGzRiQP4xIkyg70D3qyVuxPWKQ=;
        fh=j1/I5ivDD/s6arM75zIoTlFFShMomkCGVkIjOHsbV04=;
        b=Gp1z//XXk/8T0oM38v+G7K4AbcYh1htmanmDttsunE/++1+TqRGfoQ+DMfy259o9fZ
         sXv3RcfYgi6vKtUod7LihWEiGbfxSwqj+xoClXiXi4AQKn8mwHhVdoq/jDhdmYdQuyN5
         6qWu77M6VPELBKFC9Be4zUQVg5Imu2u7cRGHZ5oco96LagQ2KEfNupqzJaWjybIwNGJW
         KYxAOn326U+sMfkcA0WMYunXqa8uq/Gd/9weAHxvyPGualAIK6of802J5tGBY4M4tsCJ
         9+KyPLUIKluf/clp/outxube1+TEl1XsO84yeGYmTjmHQjdZ7qUdLKAI7JSzSQTDeYec
         27Yw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789426956; x=1790031756; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pOUFKWLA82ZDA522DpGzRiQP4xIkyg70D3qyVuxPWKQ=;
        b=njLUo9f613ETcTM0BuZQ/4VcFKGxPrUlgbNcdOnqGn1fpgDzwp1a5Q+vdz6tDUJDrZ
         McuIdpwa0U1GX97oEpWaoSnjchGBZ7wpohw1URwfNZm95eWAWjrRuVaLSWzierLNoTi0
         07PqvdfTBb0sG5IDKXJU5B3jrSJ6LT5fF7Otz6TywYI0cAVi9GHmD5F73G7dSpsA0/UK
         C8Nev/wxrYSqIl1F2SGoL2XAUbw5kndaG/pvZsUAv+fIpulOoU6upAXBL1e4JR1qFzfX
         fdlzqM4JazG9sFpLcubUSpj+hVWNfnpd7fZf5lthjq/189Fw0GAzdh+dQQXrgjGoldfV
         9qFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789426956; x=1790031756;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pOUFKWLA82ZDA522DpGzRiQP4xIkyg70D3qyVuxPWKQ=;
        b=HCP6kxRGEqXd/JkUOrzpAUOGnoYDqg5KYHRIEMjtbD2n8H2Gv0exeMCVcDbEv/h8cO
         2YrZluR8pMHHOYCovK9gWkXrE2otBk3RHkkRcG2lxMN2GCvTjugCWjntt0YnFwtofjOF
         WeVimvlGRpI/Ze0TvE0sKPpttkNZVRNxUWV2IGCOw6OpMoxFQR05Iq/dllbj9XoM/dNV
         QnbV8J4l4O0AUKZl3q289cKzzOy7j+Gh9PDBAq2r2Y32XgjNQFDEjkJevW1Zxs48C9AZ
         vD65Dej6hfl/1/A/kODaBBzu7fCnepekaMuQUtYgVoZBmNIYN/AM/VBU0cYk690br9Dm
         Eb7A==
X-Forwarded-Encrypted: i=1; AKwUvBzgYBSKdiIL7nglGNXG3HWFGiaWwEvJojQgw81IhpGv/FCU06VbUmyzODtukHyEq29n7237sgtT@vger.kernel.org
X-Gm-Message-State: AFuF++kLzMSLO7cVodEB4TRLv2pa47ygKLgEe81oKgNXHGqbGTJCXvh7
	e/09ZcSx9pWy7eBobl7gdx7BSBFIAthtthxhqnS8fqSbBWM+2IFh3lHN2QGiLC+XMXuGQjl0B23
	xXoBYymhUyBS9QZ9RsQYfFrSLrplJyok=
X-Gm-Gg: AYBFou14LL9B+B2+qSkIVdXRUOj93r0yUripWSXCQZYDoeoaqB1j9aRhLyoNMGt0Isb
	TB1Oz3sLpd8eOHjOCjQMCTLJDd6Q6Tmb19sNYSTUV19POU4VvlgaCPuCblB4fNBQ0ljPq4dauhK
	t5O8kCKmgLStAxFgwixQthfPbksELL97oO5FW+cjDd5c/m/B2fupJKKhAKWMe7fHAsox7Ie1i9d
	WOKDNHMtjRYbGso5m8TB+89Ka1mSGwJoOv+asaXnbJA1AtdollLrfox2iHC73F4iec4IiLhwNaz
	evwslA+MwN3wn6D4WGsRIQ209NjuMXZy/mE6rh8HA4gwr1oA7yaBb/M=
X-Received: by 2002:a05:6820:2226:b0:6ba:1878:2a6c with SMTP id
 006d021491bc7-6c540088554mr2619502eaf.4.1789426956040; Mon, 14 Sep 2026
 16:02:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914073356.791518-1-cui.tao@linux.dev> <20260914073356.791518-2-cui.tao@linux.dev>
In-Reply-To: <20260914073356.791518-2-cui.tao@linux.dev>
From: Amery Hung <ameryhung@gmail.com>
Date: Mon, 14 Sep 2026 16:02:24 -0700
X-Gm-Features: AcwNN1VZkBQqQYfMVd7gQUm6WpRn7TeG3A6jO20_KXpKUTM9cv8b_LakI3YB1JE
Message-ID: <CAMB2axNkTS-UuH-KctiY+5qh-JZZkKsiyQr_KOnGJt1bPoL3eA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] blk-iocost: add BPF struct_ops cost model support
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk, 
	cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org, 
	ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org, 
	cuitao@kylinos.cn
Content-Type: text/plain; charset="UTF-8"

I mostly looked from a struct_ops perspective.

> +
> +static const struct bpf_func_proto *
> +bpf_iocost_get_func_proto(enum bpf_func_id func_id,
> +                         const struct bpf_prog *prog)
> +{
> +       switch (func_id) {
> +#ifdef CONFIG_CGROUPS
> +       case BPF_FUNC_cgrp_storage_get:
> +               return &bpf_cgrp_storage_get_proto;

This seems redundant. BPF_FUNC_cgrp_storage_get should already be part
of bpf_base_func_proto.

> +#endif
> +       default:
> +               return bpf_base_func_proto(func_id, prog);
> +       }
> +}
> +
> +static int bpf_iocost_check_member(const struct btf_type *t,
> +                                  const struct btf_member *member,
> +                                  const struct bpf_prog *prog)
> +{
> +       /* calc_cost() is called with RCU read lock held */
> +       if (prog->sleepable)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int bpf_iocost_init_member(const struct btf_type *t,
> +                                 const struct btf_member *member,
> +                                 void *kdata, const void *udata)
> +{
> +       struct iocost_model_ops *ops = kdata;
> +       const struct iocost_model_ops *uops = udata;
> +       u32 moff = __btf_member_bit_offset(t, member) / 8;
> +
> +       switch (moff) {
> +       case offsetof(struct iocost_model_ops, name):
> +               if (bpf_obj_name_cpy(ops->name, uops->name,
> +                                    sizeof(ops->name)) <= 0)
> +                       return -EINVAL;
> +               return 1;
> +       }
> +
> +       return 0;
> +}
> +
> +static u64 bpf_iocost_calc_cost_stub(u64 opf, u64 nbytes, u64 sector,
> +                                    struct blkcg *blkcg, u64 model_flags);
> +
> +/*
> + * kdata is seeded from the CFI stubs, so calc_cost is never NULL; a
> + * model which did not implement it inherits the stub, which prices
> + * every IO at 0.  Compare against the stub to reject it.
> + */
> +static int bpf_iocost_validate(void *kdata)
> +{
> +       struct iocost_model_ops *ops = kdata;
> +
> +       if (ops->calc_cost == bpf_iocost_calc_cost_stub)
> +               return -EINVAL;

This should check !ops->calc_cost. CFI stubs are used to construct
trampolines; they are not copied into kdata for callbacks omitted by
userspace. Also, should the reserved name "linear" be rejected here?

> +       return 0;
> +}
> +
> +static int bpf_iocost_reg(void *kdata, struct bpf_link *link)
> +{
> +       struct iocost_model_ops *ops = kdata;
> +       struct iocost_bpf_model *m;
> +       int ret = 0;
> +
> +       if (!bpf_struct_ops_get(ops))
> +               return -ENOENT;

struct_ops core should hold a map reference when calling .reg().
Calling bpf_struct_ops_get() in reg() and bpf_struct_ops_put() in
unreg() doesn't seem necessary.

> +
> +       m = kzalloc(sizeof(*m), GFP_KERNEL);
> +       if (!m) {
> +               bpf_struct_ops_put(ops);
> +               return -ENOMEM;
> +       }
> +       refcount_set(&m->refs, 1);
> +
> +       mutex_lock(&iocost_bpf_reg_lock);
> +       {
> +               struct iocost_bpf_model *other;
> +
> +               list_for_each_entry(other, &iocost_bpf_models, list) {
> +                       if (!strcmp(other->ops->name, ops->name)) {
> +                               ret = -EEXIST;
> +                               break;
> +                       }
> +               }
> +       }
> +       if (!ret) {
> +               m->ops = ops;
> +               list_add(&m->list, &iocost_bpf_models);
> +               list_add(&m->lifecycle, &iocost_bpf_lifecycle);

This seems to contradict what the changelog says: "blkcg
online/offline notifications follow the model binding, not the name
registry"

> +       }
> +       mutex_unlock(&iocost_bpf_reg_lock);
> +
> +       if (ret) {
> +               bpf_struct_ops_put(ops);
> +               kfree(m);
> +       }
> +       return ret;
> +}
> +
> +/*
> + * Unregistering drops the registration reference.  When the last
> + * reference is gone (no device bound), the node leaves the lifecycle
> + * list and is freed; otherwise bound devices keep it alive and it
> + * keeps receiving blkcg online/offline notifications.
> + */
> +static void bpf_iocost_unreg(void *kdata, struct bpf_link *link)
> +{
> +       struct iocost_model_ops *ops = kdata;
> +       struct iocost_bpf_model *m;
> +
> +       mutex_lock(&iocost_bpf_reg_lock);
> +       m = iocost_bpf_model_lookup(ops);
> +       if (m) {
> +               list_del(&m->list);
> +               if (refcount_dec_and_test(&m->refs)) {
> +                       list_del(&m->lifecycle);
> +                       kfree(m);
> +               }
> +       }
> +       mutex_unlock(&iocost_bpf_reg_lock);
> +
> +       bpf_struct_ops_put(ops);

Mentioned above. Doesn't seem to be necessary.

[...]

> +static const struct iocost_model_ops *
> +ioc_bpf_model_prepare(const char *name)
> +{
> +#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
> +       const struct iocost_model_ops *new = NULL;
> +       int ret;
> +
> +       if (!name[0])
> +               return NULL;
> +       ret = iocost_bpf_model_get(name, &new);

It looks more straightforward if iocost_bpf_model_get() just return
the ops ptr and ERR_PTR on error.

> +       return ret ? ERR_PTR(ret) : new;
> +#else
> +       return name[0] ? ERR_PTR(-ENOENT) : NULL;
> +#endif
> +}
