Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B9133EB01
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 11:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790682586; cv=pass; b=d6VRhBKlRN7vvG8B8avoi5oOKgSur5fzOHai3ySEN+fdrRl6OXHRhv+hK51Tn54i3ikBZEbdsIxolxNnsHl4lFRUJqEHsFAuXTxT75+/GFAE9pfXoXPYv/XYKGw9HOWX94rz5NG8QVS4+1f+wGcFE+xvKMcf9naoS8Ne6Jppoyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790682586; c=relaxed/simple;
	bh=kgjy2BB8Nwb8PNLZfFsqLbfjDohsf0KQ3TZfyRHIEYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=axOHBVZXSGMQiiK23k7EOpDPm/idBIYAT84yW36AzC4t3PG0bcCp2A3KpyBArqEiwS1VvMwcouAFXvd2/rbbg02XmYqO4ZFZV1cj/gFlmWVaNU29aM8wXSUTV6pH5Zo+yYno9Dl9PhvO1v7W/b++TtFaiUYBMI/ULfWH/jws/PU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GwhE5rIr; arc=pass smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GwhE5rIr"
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-6729ca45e37so4173088d50.2
        for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 04:49:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790682583; cv=none;
        d=google.com; s=arc-20260327;
        b=A6Ef8RohdT4a/J9NguqWWerSGe7iW5bO+mk13guoV0heahWfsvZn3xVToayiLAClNd
         oLmyTtOBNvxoX2eVEsNSEsa6JjhAPd1VLuze24yJmqK0qSCKZdeAzUHRkZvSDoQ558Pj
         66qnXqK9+SEQd89E8+Whmi0eBt4pBN20VyN22K28mn9vfC2hhp+iYNuCV4l3XHoVhgSe
         mhiA9lcf/EWt9aimgi6N/RiZpn5U6OTmQrncau3uUqFDWS5UM4X5hUk38/kT624xaTPQ
         j+GRzQgWplu8IFUBrPxUy0gGRspMNArebOghk7Ben5wtl2MUMTeZ6hhxfy38ecT72oTy
         euGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PinsfWb5o3H1N8+JPrpcg6f6Oxc9ozJUPh0iCkDqvJw=;
        fh=1xtYh4+JNnQKzTRCiqj3oksZjCGMJmfntHhMffRq2DE=;
        b=my3CGKg7YM9708vBaygqwZTWqleuhKT6sg0C6h+oTl0ShIx+h1bdV0WtK4IzDFyO3U
         vM8tYGYKchmeE8k6J3FJNlqoK3PuXx/MculJsZwY1REyjS1E1e2KKbm2GD+JrGG/OK9g
         s/YQ4AnJzjsAWSfdwsJssJvsf88sEEl8XHvLV/7yWsWxOteowCmEiCtSzMMeOWzRvV4Q
         E2VaoQ9NIZlPOzB7Wq1X7IscEA2N39psyy7CJ+WH3twwI740FfUZ9OSuPRQ6LZ2LNzkR
         d4upf+sHd9YBadLKIgjzbalW4VCHpTN9bhwJzTyleRFwfrNisnA1LDlM75ZKE/rPpHhv
         UzFQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790682583; x=1791287383; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PinsfWb5o3H1N8+JPrpcg6f6Oxc9ozJUPh0iCkDqvJw=;
        b=GwhE5rIrih0pY2UIXirrTWjpTlblATUKmmDYILdI35pc/2y7JVOR/hYrvlTxQV+10A
         pCA5Ta12ibOETBKTEwhMjKjM8NCJJ/PqInEC721YWfO/BCM+hilBXJUTI5OxizkA2K+v
         GuS0ibKZH6CtMb39fU4MBNlgRH8AxZWlHAloTlZZF22NyhU5wn9N5xKZ7SDD1u8vDBhm
         zVq1/C5zayoM2IOhl7wBVBc5n7Q6LV6He53wTiCyugtTQgIB1Q+0UaTg+74+8GjaMppv
         DYyl9SxXRcNJXoD3yd2/GUopP2MBEXEiflJs4DHtWlTmJ4zFQ4xNI0mZMYsg5AQ3C0be
         dxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790682583; x=1791287383;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PinsfWb5o3H1N8+JPrpcg6f6Oxc9ozJUPh0iCkDqvJw=;
        b=FpvGKcetfpVoZrYfBiMFINhQ2/LIyptPnSPfq209ofFpjkrsZ+qDynTafkAKwLvSFD
         PODPemdG9JOEDXBVGq3ybVZvQn6XacjCsJKd723woL+87D6pRPX/Pr0gCbY+q21Vjgjk
         F+uwnuDGaX1FYog0sM6VcJpmlo0E+670Hn6oukRF5sn+h0Lzo77hBIGy1/qIVdG2a9Ev
         2tD54zMJXRGJ6OAoDHzqCoWV6aDLKgAWamzDBLvfwVK5uPlQuOj5eGRLAb3eAGsVrI02
         GMPJ1Ys0qLhC4Tnr3qTKZJ1NvIY1uLJb6MhcwASik2LO0tv5WDRWtN4YDwG77Ta+dYLT
         4cQQ==
X-Forwarded-Encrypted: i=1; AKwUvBwSCxOIs7TLeRPwzybVBUlQ31xHrxmQj6kXVD2iv1R2iWft5NfZzhxPPH3InTsqkAXo8Mb91Qxh@vger.kernel.org
X-Gm-Message-State: AFq9FYKMzpYFhn7wno0eS3kvWXPNSbDvdF5DEiWq8oVxLu2cPzmfKHBI
	LqvWq3t59omiVFeszg8s1xR/cdBf4P0GbS5ig1XaaPRphrwzmJ6B1/BRLBVi5cTCjvblqGTR0os
	8ye0qQQAdeySOKkufa7UO3thuRY6ADUo=
X-Gm-Gg: AYBFou1AkmOs8C602FB1kgC+2OU10c70I8sa+y9ZCgqwJ0UMUpF7gOi5Fy0wKuJqDkb
	o+vXa282pLU6zNL8D6MP365H8E9ieuoit8KP2FArshblVyzqFNXyhik8GOtxG0js0TCcrbZRhZV
	/5jvVNfrWFjD5qYXTg5U3lvnH0xSJH50mIY/Ha1NnEGZ9Dlu27P9qZYXGXMXQifoBHvqQcXCQgQ
	Z1q1C9dwjZBrDj6R26gr3cYV4OWHLVrN+rBGYBgRb3CO9tgKMf29eonOIsDFsj5jPWxzUHxWcX6
	za0rjKIvwaR4UJgb9c2VQIhrKnPRdKKL9OH14GSD3dUJcGY8TfipEq/X3bJP2UvG/5kLpecCWYH
	DRWIsON9tug==
X-Received: by 2002:a05:690e:144e:b0:668:9230:e266 with SMTP id
 956f58d0204a3-674112442a9mr4372761d50.46.1790682583424; Tue, 29 Sep 2026
 04:49:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921192559.2619635-1-shakeel.butt@linux.dev> <20260921192559.2619635-2-shakeel.butt@linux.dev>
In-Reply-To: <20260921192559.2619635-2-shakeel.butt@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 29 Sep 2026 19:49:02 +0800
X-Gm-Features: AclHuK-nFEkgx8S0aZZQyW2aKsafwpBB_ccNYji7zHIK6DtT7XurPCTCqUpsYEY
Message-ID: <CALOAHbAb_aKHNxKV3ecUW6ZxK3VR8XAwxD0vHiaZa__6e2pKwQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] bpf, cgroup: fix cgroup struct_ops query for a
 second attach type
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Amery Hung <ameryhung@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 3:31=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> Two things in __cgroup_bpf_query() work only because CGROUP_TCP_SOCK_OPS =
is
> the only one struct_ops attach type.
>
> It calls cgroup_bpf_enabled(atype) with an atype that
> find_atype_by_struct_ops_id() works out at runtime.  That macro is an asm
> goto and needs a constant.  Today the compiler can see there is only one
> value; add a second type and the build breaks with "impossible constraint=
 in
> 'asm'".  Add cgroup_bpf_enabled_runtime(), which reads the key instead, a=
nd
> use it here.  This is a syscall path, so the cost does not matter.
>
> And find_atype_by_struct_ops_id() matches on type_id alone.  An attach ty=
pe
> whose subsystem is not built keeps type_id 0, so a query for type 0 finds=
 it
> and returns success with nothing instead of -ENOENT.  Skip such slots.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Yafang Shao <laoar.shao@gmail.com>

Could you please send this fix separately from the series so it can
land in bpf-next on its own?

> ---
>  include/linux/bpf-cgroup.h | 9 +++++++++
>  kernel/bpf/cgroup.c        | 3 ++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 8a75a6cd7309..3b2c127d401d 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -76,6 +76,14 @@ to_cgroup_bpf_attach_type(enum bpf_attach_type attach_=
type)
>
>  extern struct static_key_false cgroup_bpf_enabled_key[MAX_CGROUP_BPF_ATT=
ACH_TYPE];
>  #define cgroup_bpf_enabled(atype) static_branch_unlikely(&cgroup_bpf_ena=
bled_key[atype])
> +/*
> + * Same test when @atype is not a constant.  cgroup_bpf_enabled() uses
> + * static_branch_unlikely which creates jump-label site and requires sta=
tically
> + * selected key. Since key is selected dynamically, use static_key_enabl=
ed here
> + * and keep it off fast paths.
> + */
> +#define cgroup_bpf_enabled_runtime(atype) \
> +       static_key_enabled(&cgroup_bpf_enabled_key[atype])
>
>  struct bpf_cgroup_storage_map;
>
> @@ -508,6 +516,7 @@ static inline int cgroup_bpf_struct_ops_attach(struct=
 bpf_map *map,
>  }
>
>  #define cgroup_bpf_enabled(atype) (0)
> +#define cgroup_bpf_enabled_runtime(atype) (0)
>  #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, uaddrlen, atype, t_ctx) (=
{ 0; })
>  #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, uaddrlen, atype) ({ 0; })
>  #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 696b27383974..99b4e96f5db7 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -45,6 +45,7 @@ static enum cgroup_bpf_attach_type find_atype_by_struct=
_ops_id(u32 type_id)
>
>         for (atype =3D 0; atype < MAX_CGROUP_BPF_ATTACH_TYPE; atype++) {
>                 if (cgroup_bpf_is_struct_ops_atype(atype) &&
> +                   cgroup_struct_ops[atype].type_id &&
>                     cgroup_struct_ops[atype].type_id =3D=3D type_id)
>                         return atype;
>         }
> @@ -1448,7 +1449,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, =
const union bpf_attr *attr,
>                         return -ENOENT;
>                 from_atype =3D to_atype =3D atype;
>                 flags =3D 0;
> -               if (!cgroup_bpf_enabled(atype))
> +               if (!cgroup_bpf_enabled_runtime(atype))
>                         goto skip_count;
>         } else if (type =3D=3D BPF_LSM_CGROUP) {
>                 if (!effective_query && attr->query.prog_cnt &&
> --
> 2.53.0-Meta
>
>


--=20
Regards
Yafang
