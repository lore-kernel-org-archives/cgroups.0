Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A2C3845A6
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 04:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787199670; cv=none; b=dPy04fI4YVkSy6js2A0wprRk6+ktdU7y59GD8h5F0svYc4/t0BPPZd84tjaOrMAYevNGRlZs/zsby22qBaxGj3HrO0dbqYtMEuJT9jg+uKphi8FlUWzhyGofsNZvwip+JkdW2hxokx7vGMzrD5Ue3W+0kQI+rBAwpgo6tLjX7Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787199670; c=relaxed/simple;
	bh=RLyUExN8fVPgQWYI7kpPw9+TUlnM1EtUbY0W7IeaZw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfXyBVh9IPSj38ppv303rBW6CJxsDtRirv3P2uC7YcUzQpEnwRg2zxGIsGCqjCYFWfzfiNnVK0ylar/YkYw+3dCB6fvlLJ78bhiBPXfoBYwbQokYRo2Tfi35Js7e/Kg6u9Ns6BRMfEQqKvxDIShbah4cEXaDu3tr+hvRA2NXYcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dxg72U0A; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dxg72U0A"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ced3386430so15317445ad.1
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 21:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787199668; x=1787804468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=34TzclDonaRBC/uFBFwYDupP16pmzizlO9UWq1m3bXE=;
        b=dxg72U0AnpILDfaZYKLe17PeRt83KWq575kOIBxWboK5k8fL8Pbu1UZNnMWC3nHbha
         NhJ2iGtJxusDXfzU1zgjS9SbBAyhForovS3gzQz6a2hJHbYcFDIvtI3ZgM2B/bzIOlJe
         V9V0zLupKRFc5FNKP1Ol609XQwg8hzgfx2UcPnd4EVkMoAR4rzFKaf9Psl5uVEv0tvCJ
         EZ1FQ5Ct4gGU49/AEsziYImyja3NrfeOnbX6qtBtL5Ly8UdiOpYl6U0kWuDQ6IlgSumj
         qG3jgVN80qRJVJHts7ib8MteY2y4VqbMM1WjIlXKHIZ8tGl6G3peIKgOKyVM37HxAvbo
         SsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787199668; x=1787804468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=34TzclDonaRBC/uFBFwYDupP16pmzizlO9UWq1m3bXE=;
        b=Z6YFHCtv8TjKCAfB/CyKd3i9EW52Lr64DYC1qdJulC7kDe++q9VhQdmL8e4yahjdF3
         iRkNkBijPJHtEv+zWqAoX+U/p6Jl9V3oBMK+gm775KSr4GPXBIUiAkh9VEXS9F0J8eQw
         Trh5BHPQCbtpVy7Z585cqNIbXd9rqOhrZ3qaQKeXlhpejJ/elkQf3doCd0erT2jlpjVs
         aIY1Ah5LQQyDzf84rKljhg6O7ce3MskDfK6Djjx3W3QnrEQs8uWNDPgn4nB1oJy14l1g
         8Y4vCdVF3q5tyQTDb+M+QNYztwIyU4/Uj3PJyjlnp2Sr0g98XczTeJhrud2oBt4NF/Bs
         bgGA==
X-Forwarded-Encrypted: i=1; AHgh+Rr4QdDSdP0OU6clbLlMulS8C/m/P4q6yjkm81q8mGsYdXEuOjv+lOl3/qjFIqKjOqL8JsUbNyhZ@vger.kernel.org
X-Gm-Message-State: AFuF++mJrYEvC0QBjm07O0UX7T81JOlpQ/TnvPrrjEBa4PDjFVuBz7EA
	OVwbZkl6t3yZ9QCXUmR0jVM+L1oNBS0XU+63L6W58Lzhl2dCkRTyk758
X-Gm-Gg: AR+sD12rCditDFiRbycGlzpBeia1cG3bHw0LSIFrBpbLs5Y1KjWg6dfdnlggjhuXaLK
	O8tYC9TpgL7tH5P+bzdzFxxE3KYAlJa4sr7hkbszfD8fuvOWfOHGEbkuNPC/vE2KP7GZHj10BTY
	ryDShQQlbX6XtGm8ihUBfOBFmmAv0r80ywLsyEqjEXsyHHb0xACIPb90ITCBBxiHkgnzkmV9mFv
	mPmrPdX/69uqDNurTyQfAnkdCKGtvFsmonAXvjullNZOCCHgcGYsTVIVkQ+f6/uDUPH42+tQNOn
	AK5w1QQbKIcHja/P+V5/3m4dFErXIY+tSwNqIALqMiJAU1cEzzoNAfbicZxMsTWUdYOJeMa8MyK
	YVtYkQX3IM0yiiMwglIujGYTxft6V7GyvNLQighMgSlwzgzjCAYr9oZE1o95y+L4rL7pPSPzVi8
	+bNHNURRmsT+XJAQprS+hJhtCd+pwGxvI7cTxpEa5DsZZkl32W/Z/oAKZIq2Id9Wnpwus5nfr2M
	Wonwiw=
X-Received: by 2002:a17:90b:1e49:b0:38d:ef48:b04 with SMTP id 98e67ed59e1d1-39580f6c037mr16864194a91.10.1787199667842;
        Wed, 19 Aug 2026 21:21:07 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395a9e1d336sm349605a91.1.2026.08.19.21.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 21:21:07 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
Date: Thu, 20 Aug 2026 12:19:38 +0800
Message-ID: <20260820041940.443214-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806184254.3790858-3-nphamcs@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu,  6 Aug 2026 11:42:45 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

Hi Nhat,
[...]
syzbot reported a NULL dereference in the v3 series:

  __vtable_get()
    vswap_to_phys()
      swap_entry_backend_has_flag()

Seems like the underlying issue is introduced by this patch's
`virtual_table` lifetime management.

This patch adds:

> @@ -70,6 +70,7 @@ struct swap_cluster_info_dynamic {
>       struct swap_cluster_info ci;
>       unsigned int index;             /* for cluster_index() */
>       struct rcu_head rcu;
> +     atomic_long_t *virtual_table;   /* Backing pointers for vswap slots */
>  };

[...]

while the read side does:

> +static inline unsigned long __vtable_get(struct swap_cluster_info_dynamic *ci_dyn,
> +                                      unsigned int off)
> +{
> +     VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
> +     return atomic_long_read(&ci_dyn->virtual_table[off]);
> +}
> +

`atomic_long_read()` only makes the access atomic; it does not protect
the lifetime of the allocation being accessed.

[...]

> +static inline void vswap_cluster_free_vtable(struct swap_cluster_info *ci)
> +{
> +     struct swap_cluster_info_dynamic *ci_dyn;
> +

and frees it synchronously:

> +     ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
> +     kfree(ci_dyn->virtual_table);
> +     ci_dyn->virtual_table = NULL;
> +}
> +

The existing `ci->table` already has an RCU-aware lifetime: readers use
the corresponding RCU access rules, and the storage is not freed until
after the appropriate grace period. `virtual_table` introduced here does
not have an equivalent lifetime rule.

The syzbot crash shows that the current teardown/read-side synchronization
is insufficient: `__vtable_get()` can observe a torn-down
`virtual_table` and dereference NULL.

I don't think a NULL check in `__vtable_get()` alone would be the right
fix. The NULL dereference is a symptom of the missing lifetime guarantee.
`virtual_table` needs to remain valid for as long as a reader can reach
and access the corresponding dynamic cluster.

It probably makes sense to make `virtual_table` follow the same lifetime
scheme as the existing cluster table, or otherwise tie its freeing to the
lifetime of `swap_cluster_info_dynamic`.

[...]


Thanks,
KunWu
