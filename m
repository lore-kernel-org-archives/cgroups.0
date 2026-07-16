Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A90D2EBBA1
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784215990; cv=pass; b=bgw7HS/dJXKWUwwT19DYc56jJKEFy2ic3HnFHKnI1djDt8LguLmS6Q79i+D12oUE0WjmGGT8hp/NUPRuvu662dIVMz302BGvs3PlejqT3trKfnn69S7mtEKLHrhLcE0ZM1s+86T2b6MDw0rz1Bc2HDIUiGAUCGOGTKAcBAmIJi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784215990; c=relaxed/simple;
	bh=Ncccfq9bemV6U06GJLQTddb7aqngGVT6JOZmXW1rCrc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WN6xPo0gnL6szhkloh+St+YBCZ6L34/piJO/CPzTvSRdGQJT/n2U8YpzjVeD0L8jRQ/wHGg7VKhKF0WUeZjrVuYfwXbzZzFgH00+uhx+x8BnbNo3QbsqdZT4xstpLaRHzMTEuOZMYEJGHR4Az1MoTEEd9IPNUKP7y2Fc6CM34yc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bNEkWnUH; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bNEkWnUH"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c01c79467so29971cf.0
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 08:33:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784215988; cv=none;
        d=google.com; s=arc-20260327;
        b=G5nlKvNWwhYRsz6sb7ZGqFwd/Gz0pcvMyH94nIneh8CZCvqA1mw2xoq4X9fVIKyjr6
         qQMkjZlLEY/30X0LnqQz+OfD1Z+wPmWTB1zJ4eJMAn2CtgIgtbdRAAOLvBJkTeD5doex
         odImx9cdl5bPs2XGEeqhrVc0E9G+lEV1d9dklBsh852M+evFj8MNcSh4FHfx2ACPb0eR
         SbbWFVSLU67SDZXsVIVMMoYBcZ56ZFV6rm3Dl56qPUxpfaGtnvoS0vG6pwJJGvbDft4u
         psoa1NpgxfbiijF2eXL5jAEqWcKx/9N8cuu+rvZ1jVSnkrOWxXUcbl3TuheuwxhlNT1C
         p/GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gqP+mYqeDojLhRDbRbXpVEiCGBcqs/tKJr25Bs+t6+0=;
        fh=B9jhKdFbLibFsiLapBXg6IS8H3vfebYzUNkdSLXPvKg=;
        b=fNCv4kFd/kpAF5t700JVTtmQzr62AmveLAwUtFWoPReacLdMYE0EBAZmeeebeA7kWo
         6HBIc+oYJQIuAbvQC0PkaQ8IG+a+ZJezbnDXEuXLhoiiWvAje5/pPvzRc7HEtNRt/8fa
         4XYySGkl68McCYnft3QukcyOIc7DjA7qW97viSC0gbUiQAvLSWOCo4iuxEv0B5nh8aiL
         qy5ydCejejI9Q0YckySLVt4R/CFjGKIeAXXKTmTRjRHXHXNtfYKr6yyBT3mbqj0B7c23
         qx55W+H/0vQmxpYwpCBvePjH+CiMge8ETeE5o9snzKyD9XwQKohuj2aG4n3MqjNVs9AI
         DRvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784215988; x=1784820788; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gqP+mYqeDojLhRDbRbXpVEiCGBcqs/tKJr25Bs+t6+0=;
        b=bNEkWnUHo4Pf5OeHVwhoXdd2hWpSW9l0r5UbfS6Ika8pLNGoQ1y0MS3vbhdcBmjFad
         OPwM7MOi9jxGARc601XJXfqeeHst2b3QSZraKzBwbJvUWxBV8q+vhROESEdPN2hJrKR0
         SkwUj4z7ZHDUISponMGQFSly3fePzLmhd3FKadL0U+6/HLmpXn1uCHv5Gxes7s1es4j7
         THnfXn+CEZ+zgIH2JE96vmAgW3lvqkWdeV3X0qrm272l2vgktJIvboOIbCQXKa2MSJX+
         99tk0lSxAt0yCAM3Sx3qu2+SXG4Kh6IOySg5cOtEsNFZgQ811ConSuyktBdNPAPU5eZA
         M0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784215988; x=1784820788;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gqP+mYqeDojLhRDbRbXpVEiCGBcqs/tKJr25Bs+t6+0=;
        b=irsDMukNt7fadYZ+FoHw5D6pXEzzzfQY9iINvF0bQks2oe4ITSrDCnPWVEjhS69ySg
         oI1fm4Pi7vh/yGATPxyFsbBbMQQhnyjlbKcjqeHU3G+GvLq9dV0jkIqVWdwumgIy50H5
         XTnttv4r0THWYZpgud+jL/H/USUjPzhC6AgC+g0qkTRBXK/46WaU8Q63r75ZGaQi5+1W
         CU2qlPV7tCrVrgLQJ/fXK7Vfb6ZQrqMlkQTg7DGP/mBmkosbxnfFL76GRGqba/y4g2PR
         bTyIMzwP7seKr8ZI9WZ1mnqaZ0SlMKZEX4Fr35wjaeB7vUZ1VXZhroi8QqcQFIRpAqko
         hd/Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr8KZ3RR5IAqMyhwiMCOVPqKEY7RsJe5MPLHnWn5WC3AW7PqPOrDmptIArcwLptQ5Jby7aOOp1A@vger.kernel.org
X-Gm-Message-State: AOJu0YyLTd8eMCnHGD35P1x+dmVjMf3hS+xQtP5qJ/ONFyE8rZpLohKI
	2qcMZaiS7DK9JqO2801gHwihFO7mMiZlQYbcndcBBx4fxwr7Uk/+E2di5BsmiWl8+0yB4v6U9Ez
	Q0JK2D+nEpogs6ZOxhaQRm/ryltsGlsehpGkRm3Aa
X-Gm-Gg: AfdE7ckwA6ZyL867CkYPOjH1NgGTNMzOQkKvp5vo3r580EiRtBVlRm4lmRWQJia+2X5
	zC3on28in2oPuQQpfgPiEkv51WdwNqRFvoCHhKjSF/w1zfmA29rN6TOCxG9A24YkrXC+FYZs43u
	PAVtHsG7Yc969JtxqaU9PZ2rDsonRBsRZgAGu5k55fgJ8vank2yt5i63AmEVRO1d56rsCEnhZaV
	Tb36nh6+DpWPrMjH2lxtXvQJFrFdOdaBaQoQpMYmk6lpXE27uNqTCUXjHJosO0j3ggnJ4Pg1yL+
	4Kk9qsIedYpsxoXoaqvbwmJ/ow==
X-Received: by 2002:ac8:5996:0:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-51f7e705596mr9599801cf.10.1784215987211; Thu, 16 Jul 2026
 08:33:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-12-9a49c4ccf4c3@kernel.org> <CAJuCfpHuXu3BDf93zeBQWSW_k5wApegp44rHoZwk5Ym6xxbqEA@mail.gmail.com>
 <e126d6b1-bed7-46bb-a8a3-cc555707b516@kernel.org>
In-Reply-To: <e126d6b1-bed7-46bb-a8a3-cc555707b516@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 16 Jul 2026 08:32:55 -0700
X-Gm-Features: AUfX_mwOlgPh2vQsFfJAl8XC3VAb0x-hSX4wZUGMP4QuR9xJ87PvP5NzdSVYcPQ
Message-ID: <CAJuCfpFicmMa54V5qVY7BYQuNih9u+-bQ+x51VDza7zWPK_mOg@mail.gmail.com>
Subject: Re: [PATCH RFC 12/12] mm/slab: stop allocating objcg pointers when unnecessary
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 8:08=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 7/16/26 06:46, Suren Baghdasaryan wrote:
> > Maybe now we should rename static_obj_ext_size() to
> > static_obj_ext_max_size() as it reflects the max possible size of
> > slabobj_ext?
>
> Hm with _max_size() it doesn't have to be called static_ anymore?

Yeah, static_ is an implementation detail anyway.

>
> But maybe we can get rid of it completely.
>
> The only caller is calculate_sizes():

I was thinking the same but either way sounds fine to me. Keeping
obj_ext_max_size() would be a bit more self-documenting I think.

>
> #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
>         if (slab_args_unmergeable(args, s->flags) &&
>                         (aligned_size - size >=3D static_obj_ext_size()))
>                 s->flags |=3D SLAB_OBJ_EXT_IN_OBJ;
> #endif
>
> We don't have slab pointer to pass to static_obj_ext_max_size().
> But we should be able to figure it out from the cache via
> cache_needs_objcg().
>
> So we'd need cache_obj_ext_size()?
>
> The static max size here works, but may prevent SLAB_OBJ_EXT_IN_OBJ
> needlessly if padding can only fit codetag_ref and not objcg, but
> we don't need objcg.
> Which is probably only theoretical at this point as kmalloc_normal
> caches (that have no objcg) have no padding, at least without
> slab_debug. But still.

Maybe keep it simple as is for now and then we can optimize it further?

>
> >> +       size_t sz =3D 0;
> >> +
> >> +       if (slab_needs_objcg(slab))
> >> +               sz +=3D 1;
> >> +
> >> +       if (slab_obj_ext_has_codetag())
> >> +               sz +=3D 1;
> >> +
> >> +       return sizeof(struct slabobj_ext) * sz;
> >>  }
> >>
> >>  #ifdef CONFIG_SLAB_OBJ_EXT
> >> @@ -741,7 +749,7 @@ static inline struct obj_cgroup **slab_obj_ext_obj=
cgp(struct slabobj_ext *obj_ex
> >>  static inline union codetag_ref *
> >>  slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_e=
xt)
> >>  {
> >> -       if (IS_ENABLED(CONFIG_MEMCG))
> >> +       if (slab_needs_objcg(slab))
> >>                 obj_ext +=3D 1;
> >>
> >>         return &obj_ext->_ctref;
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 771d73abacb6..09c4931e5435 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2503,6 +2503,9 @@ void memcg_slab_free_hook(struct kmem_cache *s, =
struct slab *slab, void **p,
> >>         if (likely(!obj_exts))
> >>                 return;
> >>
> >> +       if (!slab_needs_objcg(slab))
> >> +               return;
> >> +
> >>         get_slab_obj_exts(obj_exts);
> >>         __memcg_slab_free_hook(s, slab, p, objects, obj_exts);
> >>         put_slab_obj_exts(obj_exts);
> >>
> >> --
> >> 2.55.0
> >>
>
