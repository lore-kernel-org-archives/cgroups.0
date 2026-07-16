Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EEF329396
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 15:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784215499; cv=pass; b=X7GlJ106ZFPOE5x3X8//hI2BmApE1uKCh0k1bh9/tjFRSdVs4xjV63ho2nqw+Q1Vo5SOb2oXtghG8SXJkNQ78JWOCmJQo4q//WDy8jUNA8M//iVdE6EZSdc1yS/YvR4ZuVRr8UGLhiOUwLZteBPO+V8wHue0cFc5zuvkZ2yl/VM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784215499; c=relaxed/simple;
	bh=302NZ0hs3aq0nDa3mLY8oktXwMLcJ9Nw9Q45+xT+p38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ObchMe3piWlGcMuplXipHq9AKI26z3zS/GCNrRXZuHBG41BYun+UVXVh+JMTgexLCH60yIOX9kcgq9bFcGTlSL0AvKiaVbOHa+yv5+NcQ5wKmDXFA/1VrIAH+jf48AXTz/GO7IaBlIkUT6gleGKgenC2HhehRzd/XH6j+S0sdSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uvl5f12u; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uvl5f12u"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c01c79467so26621cf.0
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 08:24:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784215496; cv=none;
        d=google.com; s=arc-20260327;
        b=rFx8ejtb3DSeQAZXLkUYx8kuloItlbFF5srxK7tg8qAovvRsF7IxKsF/ufDcGZZ3mA
         EoeOZBZoJIdtdhk+OyajaB0DI8d9zzih4ck//WFz8jxJRfc4UBpdN8r8b8K8KK+ZWGPK
         BQZAqxMQ3cWhcz4CeFVTaBOI5IVZyeFRAprjBtLjGrav8EcC8X9ifz8tNpNxiVySdI9A
         Tthyg2bnhdiWga2chxlPvXI5p3S8W8jj1CLbsvnWUCQJ0nudzPbJNmdILh1xmY1yYFII
         Jxa5J6IbVGY/0DEdGxK1s4/HwS71Yfk1xX6EW9SZEcY2fRvzCfFPw0/y+74L6EaYiVAa
         E04Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xaD9c48fHMgNy3q+I/Rbm0Bfm/gP8epzzG1NNo6X0eA=;
        fh=oIGb+NuFTqJPAkzgzE75wshE6tOhydHCp7gPV6j62Ps=;
        b=IkwNJEs3YnblDFnSOrWEa7jiSiCB/AFPZP8r4WhcymWJ69R7dc99ZvkFqR0x3r2LJ1
         rfl6Zwe7XmbtKNNv2FOZVu4jC0CFns4rprPpbOqiXa902mLiDFqIrgrN/dWW6yYvLPa5
         cTzRDHJApgXXfCqmb2c0X+xmrhcqdsITe4hJm7spLgpmjjDU8t/2jLnI4OCsdYwE0sPI
         MiNNFQ6BCtPItkjwWo8gDBiRbxe2KMQEEYqvxb37jdFJRYXkqz5FNMn7qG5oMrf++Cpt
         opW5rOo5BhoWAw/uchs699K6MA94tycMQLPWETAAhC5w0pvWa6fzPh/+/LQDM9DQkLYD
         oFAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784215496; x=1784820296; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xaD9c48fHMgNy3q+I/Rbm0Bfm/gP8epzzG1NNo6X0eA=;
        b=Uvl5f12uBoOMOxGGqxyBmxWxC1OA2W1z0MdqEZ09/EySWqokUGKFoI74BboybydkFG
         9DLpbBok/Cd2bGSXt32IkemI+dp5ChddXUCPoLr/APcCOLtAZe3FzQVDtxppb1hZv2wo
         aZywfRaMBtYQ6iFqvULDEn28Q6ufbs/y/MApPQ7zArJwjIwoWi9eLt6tKvuDG4x4/Reh
         TRjU67TmHXM+v0Vlg+9ai8LsV1pPOi1C/udz+vDC1l9VxGb5Uy81c29Tkmau/3dxAYKV
         ISiJm/ZCZSxX/G93ropeLg2i6BfjNYnWGGvHaYkA/QTbzWwqTLWiKtrFs7R7G9TQQHli
         W6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784215496; x=1784820296;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xaD9c48fHMgNy3q+I/Rbm0Bfm/gP8epzzG1NNo6X0eA=;
        b=A3dG7dw9QHq6jGGZ7r06ab5sAP/EV6ACb0Frpcn9yH6XeCV7ChIV+ZDfqxll/YMzcD
         5DB2lgusLK60nFoUOJUu/7zHs9TvNbFQ3WZLBTZkcuGiQc2r5Z9GsC1mBjfNqNHH+PXV
         UTEh5e/oyEZxXoyKDd3yghEVN5bgUSnUQPfouIfnHuAoI2weEOLxn7ZMTRkaCpuYOLcB
         Y86J4GEGPfr6TbLmTAC0e7xXtmivd9/CgCOFMwxK76dxxuBW0bPwjMDL44GmQZG2mnds
         807n4ex1UK18GjSBhzF9Y43p9bQQEJei39XIEUjFqNLqWQJDCLkDxQbUnoOxDDgVTzri
         FCVA==
X-Forwarded-Encrypted: i=1; AHgh+RryVF+TzK27y8xLZFssWxj/GsRwcrmWxdeqW6gmb/8ZPlFV2VOfjQEVO0S+d7oePIfsm/cmM3il@vger.kernel.org
X-Gm-Message-State: AOJu0YwsUtGXIrSadVb4cl3E5PKDxFukEL+ykUuT11xgGUYQo9VJG3Y7
	LvF6NPyT3TZLQoKKI28vEKkoWzWrdyy1Qcfbmv6zJI3+MxCTBweTiFwLsPqg+2s+ASupIgizzYt
	ZdWlUs7Hkv8zm8QKQUSi4DH6y6fLmfxXg9MC6ObnC
X-Gm-Gg: AfdE7cmEqqIJMb+fBJEIeLBN1T8r0BI99LQHsrY0i2+0ETDym26Cr6A92SCyBhcar5k
	HfknvaP1V/ZRZnUiQIj2E+2h6qRFvWeON96pJrIYg1JIu/lVddbYrNu2wDOavUN7u/pr1w2iK/0
	zqGKKnfAaB/LrFjX6zKu45nb970uNDe7vSaatHoUYzoQ+kexLnvqWfZAiGNg+uMVaZkslPjNKo3
	icpKX2Q7Xp8Iqs9WGl4X5pzaNYKrQi1ESYegeaHZCyz8dY+nPQhG4SLhIEXGmrSImHw3UiN/PLg
	1g5hHKkuM9bcpp0=
X-Received: by 2002:a05:622a:4d95:b0:51b:fd21:c077 with SMTP id
 d75a77b69052e-51fa50ac9f9mr8409571cf.21.1784215495436; Thu, 16 Jul 2026
 08:24:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-1-9a49c4ccf4c3@kernel.org> <CAJuCfpHgMwM7SK-sanGpEyCxCi-T+gDqFJHnV_AMt=S-x5oynw@mail.gmail.com>
 <ab9782bf-d3dd-4cb5-ae66-127b3a16330b@kernel.org>
In-Reply-To: <ab9782bf-d3dd-4cb5-ae66-127b3a16330b@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 16 Jul 2026 08:24:43 -0700
X-Gm-Features: AUfX_myqpLnbRL2quNm_tjL_Hd-IYL14KeopYjkYUcXz5awHSzMzA6UH-PT2010
Message-ID: <CAJuCfpG3SWhrow=wScgsFe5orhKz8Djf8MHvFBH+T7uTG+AUJQ@mail.gmail.com>
Subject: Re: [PATCH RFC 01/12] mm/slab: skip kfence objects in allocation profiling
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 2:11=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 7/15/26 18:02, Suren Baghdasaryan wrote:
> > On Wed, Jul 15, 2026 at 3:10=E2=80=AFAM Vlastimil Babka (SUSE)
> > <vbabka@kernel.org> wrote:
> >>
> >> struct kfence_metadata only has obj_exts with CONFIG_MEMCG.
> >
> > I don't quite understand this statement. obj_exts are allocated when
> > either CONFIG_MEMCG or CONFIG_MEM_ALLOC_PROFILING is enabled.
>
> See in mm/kfence/kfence.h
>
> struct kfence_metadata {
> ...
> #ifdef CONFIG_MEMCG
>         struct slabobj_ext obj_exts;
> #endif
> ...
>
> then in mm/kfence/core.c kfence_init_pool()
>
> #ifdef CONFIG_MEMCG
>                 struct slab *slab =3D page_slab(page);
>                 slab->obj_exts =3D (unsigned long)&kfence_metadata_init[i=
 / 2 - 1].obj_exts |
>                                  MEMCG_DATA_OBJEXTS;
> #endif
>
> So the slab kfence fakes only has this pre-inited obj_exts
> with CONFIG_MEMCG.
>
> What happens if we run memalloc profiling without MEMCG and this
> fake slab doesn't have a pre-assigned obj_exts? I guess
> __alloc_tagging_slab_alloc_hook() will allocate it via
> prepare_slab_obj_exts_hook().
>
> But it's something that was done consciously and probably
> just accidentally works.

Ok, I see. Maybe you can expand this description to explain the
details more thoroughly? This whole kfence.obj_exts deal is not very
intuitive.

>
> >> If it's
> >> enabled, it does also work for allocation profiling, but there's littl=
e
> >> value recording tags for KFENCE objects.
> >
> > Unless we are leaking them, right?
>
> Well if there are leaks in a particular callsite, we should see that from=
 all
> the allocations that don't end up in kfence (as kfence allocations are ra=
re).
> So we are very unlikely to miss a leak due to this.

Ok, makes sense. Thanks for the explanation!

>
> >> Furthermore it would complicate
> >> the upcoming changes, so just skip them in the slab hooks.
> >
> > Ok, I can understand that. If we do this, we should document that
> > kfence objects are no longer tracked.
> >
> >>
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  mm/slub.c | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 0337e60db5ac..a4be70d080fb 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2352,6 +2352,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cach=
e *s, void *object, gfp_t flags,
> >>         if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
> >>                 return;
> >>
> >> +       if (is_kfence_address(object))
> >> +               return;
> >> +
> >>         slab =3D virt_to_slab(object);
> >>         obj_exts =3D prepare_slab_obj_exts_hook(s, slab, flags, alloc_=
flags, object);
> >>         /*
> >> @@ -2399,6 +2402,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache=
 *s, struct slab *slab, void **p
> >>         for (i =3D 0; i < objects; i++) {
> >>                 unsigned int off =3D obj_to_index(s, slab, p[i]);
> >>
> >> +               if (is_kfence_address(p[i]))
> >> +                       continue;
> >> +
> >>                 alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref,=
 s->size);
> >>         }
> >>         put_slab_obj_exts(obj_exts);
> >>
> >> --
> >> 2.55.0
> >>
>
