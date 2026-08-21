Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9613815D9
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 17:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787332188; cv=pass; b=eZIGQYdj+oUwRAWAgDhVNrIOig+S3IHbSfZu0zPFAr5+xHN9f8WKlpz3X19tcO3Yuu2mh/+fMK/9+MjUM8BLfGE2NN4sYYBnbylm4x1djr80tNznZzmYDagycCi/ceBM50+FXVVgsSS3/7m82carWVF00iDyIhd3HjK/WbZmN+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787332188; c=relaxed/simple;
	bh=xudCWQpjT5lp5cYm05GhPWn57VEG+OCVRyJHd/J1yaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SQSLDLOraGjONi9LDkC3yHBNQG9B7O3pTTg7CsIp8oMFqr3zlY8XPKEvCPmQoo7pDKyilQ4iY9kh2mJ3LMinUV8W9xO7um+EC+0Mw6ZnUAjBoMpA7jMbzpflwRboCTofG03/oTDWZ0ZPvhKvZkv0jMUyVHrU1DVSuEulZWqm8wY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rrPEhqvo; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rrPEhqvo"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47f7872abb6so720094f8f.3
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 10:09:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787332185; cv=none;
        d=google.com; s=arc-20260327;
        b=rja/2HG6RhIEUACwgCF9sXo/w/po/hMwiDWY7023+0FlfRC5MuEp1/bscvJRIgRoFy
         qL+MAEQyHMEpX0ZOGqgdTb2kVgAONgSuCT7HLDCI1erZFrvO/XFkXhWt/6EiFyWwo56e
         gPXSbh5S9cMTsYF0oL2lcAmkmQIwvD+qYrxfnZfYALZ9qxgThCDEC3xSgUQ37e8M+ziv
         vhY3vVNUA7gyhpDVRHrG3y2mWhAhORErKWy8Faha6/5uu0L2tTIICdP/zcLbCyYvhoPG
         hSkx+cwTEeFKPTM88yF23tT1D6BQh9r4ERalKi9fE++X2/546i+rG6xTmbOnJAX2o+Bp
         0SYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=veZnyf/dfYhbTVP9YeELLr3c4PfKlTUdiQo55s2EN7I=;
        fh=gz48+Uimd06aNF68qPlMxd/oSjbbFfGj+E24UMhysY0=;
        b=Z+IQcrHPUvP4PuxBJw2wOmJf5IJH+zcmiX3fNllbYpJf5Yf1uv1jnPM1w+31e85b+d
         2dJZ+F2ZRG6QX0oipue/8LYpMUvyQ7ZgP+Csg0FwzWkPWqu5Kc69TE4oWiVlEooMACn8
         YyJAIFGgez7PQHkMABDUXDBQMVqbqd2Ra8KK72fql2FUMPUZKVVilCX8jwSwbCIR47BY
         dx3xa/8XyMj3VzS9Neldod7VfzkDUYiGnXhp8/knOI2XdhvJcrhyJ3Na+vttuAwFZt4y
         2t+O3lU2wwggQSLjvlcy4mIFtViZ3/XNwo2DJu/QqSkJZf/F2tY/Yokx5cZ7ujAVPDPA
         rL3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787332185; x=1787936985; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=veZnyf/dfYhbTVP9YeELLr3c4PfKlTUdiQo55s2EN7I=;
        b=rrPEhqvo0fFBadj7+ZkJlh9iOBHTQ1Dn/9R//IjfMy0vkbfiT6bwADsYzuhc/ekkbr
         xjT5tsad+QZEwpfp7d2HW6UKHuuscGGkiXLKRjQW3dhNSmW9/HB4zTwDm8N7IUV6CuzK
         CqVHoS2YYx2QjOzu69GhHcwBSz2WrQvfRZZ58zT6g658ghUNeV7VSjj7uU5uiNTy/GuM
         tUKF3wFn+/LjzIScmEM13ePa87/iTYtC7ll74EbF+9n92Njqe84xNN8rTmBYawMAmLi+
         F27XpCRDHWbBYh1JvMs0m1BNvVEVVujdHalyUavd4aYZ9QXsyGF8P0AES1GYqmWKSFvy
         2Rsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787332185; x=1787936985;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=veZnyf/dfYhbTVP9YeELLr3c4PfKlTUdiQo55s2EN7I=;
        b=hAtRSa1mazm9fd9vCd4UiO21qkPW1Sfe3EAmDKdC5zLf0XR1ghNg2BrrdP2MjMwqwI
         2FdbC5OEv1ebWqn2hIirMQjxnVxC4jaU+oS2Y+5lwQ9P9bats87ysd9azpfMyjmcLJ8v
         /5cN+nWJpIaPEYSSKMyWfZdkdgdg+SrDUPovohII9Qk95dESWY1aM40cHcZeAjGv6FrA
         Hze43r15+gzUcTwJoBmhjjV/9SEp5XNcUJctpWfKXnv8zJP4D2gFju/D5zIiy4zpqlC9
         RFGu7ISrHXFdE3JfxP+Ie1el5GUcG3omGQ/fF1uf1IKGG90hPKLrOtaZ8eCwey2NZKvP
         PxNA==
X-Forwarded-Encrypted: i=1; AHgh+RpurhyPhZ+UR7tuVbk2ZzS7cO6sIZ7wMXAsR3oQwEkQSxw4UJnuakM0zRn1jnkiOGZ6Q87SyuFI@vger.kernel.org
X-Gm-Message-State: AFuF++kWaXsukxBxjz7QIZbYdh+Rk6kFyoRRZcUy+mwFvk5SfdrEuANI
	/mL0vFGOtYt5wB61/FhOeC963GB5H88GMrMt/UttBWF1xMiy1n8uz07RQygtbx7Nx11GoODDGOk
	a5hv3fY4H5ht/JBWv4UQCvN5FUVRe5/4=
X-Gm-Gg: AR+sD12uC37kegxyj+ZJ75GnKP9qg7NKZEKoG8L3m30EfPEL964fLpqeh7E+j5Z1TI+
	nmT7f65bUh3mSrUuTp/B8cjaM9mALURFJ+lDlJ4zqNQEgTyLA9bvFGFND2lPzJnhIi/X6ewqmF7
	5gkKraahm5z92MAA/weCGk8gNCOmMSVRxB83GHuAFw+X2+ge7jrBwiZ9c4sfexp6R7yNGQFTkDj
	o5O2/TrN6VcVRWsNGVPGUJUZtlvhNurZJOv1mJjo+AKrKQrCTHBsfnxl3oKKZKcFXJGjAe0+ts4
	zbw0imHsYnvDPY3RuGfuSRYZqicZvevZPpq9NHlhCWZtEheFwYCwTw98j5Qu5owoIRk74y1Mvbj
	y
X-Received: by 2002:a05:6000:1acb:b0:47f:71a6:970e with SMTP id
 ffacd0b85a97d-482c0b55d3fmr11033799f8f.2.1787332184426; Fri, 21 Aug 2026
 10:09:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806184254.3790858-3-nphamcs@gmail.com> <20260820041940.443214-1-kunwu.chan@linux.dev>
In-Reply-To: <20260820041940.443214-1-kunwu.chan@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 21 Aug 2026 10:09:32 -0700
X-Gm-Features: AcwNN1Ugn_Yvgh2BA7rl2-6Ryj849JsdlpzstMFnk3QEm_uy8ugTFY1jdBeldW4
Message-ID: <CAKEwX=Mj7QVArjKVvKOKnuQoTmN1Wu=vXe4jkLshnzKoYF4XkA@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, 
	david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net, 
	kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 9:21=E2=80=AFPM Kunwu Chan <kunwu.chan@gmail.com> w=
rote:
>
> On Thu,  6 Aug 2026 11:42:45 -0700 Nhat Pham <nphamcs@gmail.com> wrote:
>
> Hi Nhat,
> [...]
> syzbot reported a NULL dereference in the v3 series:
>
>   __vtable_get()
>     vswap_to_phys()
>       swap_entry_backend_has_flag()
>
> Seems like the underlying issue is introduced by this patch's
> `virtual_table` lifetime management.
>
> This patch adds:
>
> > @@ -70,6 +70,7 @@ struct swap_cluster_info_dynamic {
> >       struct swap_cluster_info ci;
> >       unsigned int index;             /* for cluster_index() */
> >       struct rcu_head rcu;
> > +     atomic_long_t *virtual_table;   /* Backing pointers for vswap slo=
ts */
> >  };
>
> [...]
>
> while the read side does:
>
> > +static inline unsigned long __vtable_get(struct swap_cluster_info_dyna=
mic *ci_dyn,
> > +                                      unsigned int off)
> > +{
> > +     VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > +     return atomic_long_read(&ci_dyn->virtual_table[off]);
> > +}
> > +
>
> `atomic_long_read()` only makes the access atomic; it does not protect
> the lifetime of the allocation being accessed.
>
> [...]
>
> > +static inline void vswap_cluster_free_vtable(struct swap_cluster_info =
*ci)
> > +{
> > +     struct swap_cluster_info_dynamic *ci_dyn;
> > +
>
> and frees it synchronously:
>
> > +     ci_dyn =3D container_of(ci, struct swap_cluster_info_dynamic, ci)=
;
> > +     kfree(ci_dyn->virtual_table);
> > +     ci_dyn->virtual_table =3D NULL;
> > +}
> > +
>
> The existing `ci->table` already has an RCU-aware lifetime: readers use
> the corresponding RCU access rules, and the storage is not freed until
> after the appropriate grace period. `virtual_table` introduced here does
> not have an equivalent lifetime rule.
>
> The syzbot crash shows that the current teardown/read-side synchronizatio=
n
> is insufficient: `__vtable_get()` can observe a torn-down
> `virtual_table` and dereference NULL.
>
> I don't think a NULL check in `__vtable_get()` alone would be the right
> fix. The NULL dereference is a symptom of the missing lifetime guarantee.
> `virtual_table` needs to remain valid for as long as a reader can reach
> and access the corresponding dynamic cluster.

Thanks for taking a look, Kunwu.

Null-check by itself is not sufficient, correct. But I think a full
dance of: rcu read section + spin_lock + checking for
CLUSTER_FLAG_DEAD should suffice. As long as cluster is valid inside
this rcu read section, we can get the lock. Once we have the lock, no
one can free the cluster under us. and as long as the
"CLUSTER_FLAG_DEAD" flag checks out under the lock, we can exit the
rcu_read_section(), and proceed with reading the vtable. I already
fixed this in (to-be-sent) v4.

Note that this is actually only required where we don't have any
reference pin. One example is the one syzbot detected phys swap device
backend flag check, because at do_swap_time() we don't actually have
any reference pins. The PTE is not locked, so swap entry can gets
released underneath us. But if we have a pin - for e.g if we own the
swap cache folio, then we don't really need this dance.
