Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488053955D7
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 16:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784131391; cv=pass; b=fhM9EIvb6MRsVu5QINSGLceAEeGNpqOMTn7ky2GCkc8GZbKXpQ80Jxaxz+SOpLvu/5omiS2ppwKTcKV8ND1GawdVOV7P3my3/zatloDL/6Wpz3eb8jO/VTgkq3GdWfwRkwOm0STekw6afjXFFaTtepGROpM5a7EpMBWcnPaxeLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784131391; c=relaxed/simple;
	bh=UBFkpBobkCpyvWchtnbzp2XwteRK2S6RS+sMZiz7rRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fQ4u2YjB0KBco3bzsVvjlU4WZltl1EfQyzHelkZ77fgOstI9RDpKGU0/5c4wCHM41JxBeHER1BAEuQKRR/yA5PrcqbcSKK4kgzbAK3hdOvio4LdQFgCd3DWLBJvmMmlM8pvQk/VsUdrMzCDYgbMSrFfRD/ZqsxMh9Kpv0I0DQ9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wJEJscGL; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wJEJscGL"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c15a5b265so256731cf.0
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 09:03:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784131389; cv=none;
        d=google.com; s=arc-20260327;
        b=hRF2mchJMl2fV6LvSdWNxKLJGth3SagHeUKPlsIrU3tWsBF54o7mDP3znSw5xkY1AK
         QToIMHQxBxHg3Kq4Xu6/rhwzMOAhm9YaU6mU9zkTdoBDIV2g61a8N/ENUAY3p0pSaCKj
         YyoIKNDe2JUuiZz+mk7K1AtruBLdGEgXDsGa9xlQFlklMal4MalGAH1fEuGcQgaify3i
         C5tt42x72sPw4qT3nuUVOMhVQ43INsJMYfCqREuyqksehf5Cd2cZ2WSCamZtIJOw9y5u
         4kmREybZl0pPglZolxb4V48tT4amxbEoFvH5f7ItXBUz7NKIbwKaqNyarSBE+30IC/8W
         3I4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2S+ZWXaS5Irs26a/6PxuDhmL7tMg+BK9b3L0EQ5QhKo=;
        fh=PiYqkw7WJe58A3LG35Y1OUT8CpKKdjkfm6MOOwuMqXY=;
        b=OFPcjlMboCYmDgD8d/dwyTg8xXP3N27PUIy8m94yUHVWFOFstTXzo2+Q/p8ZFpVPPm
         t+lADRfeu+GarhNZc6c8YkSqatuaolPMFBQFhk1VBZ8LMy0H+WP1s0yx7jqNBNhwSIui
         707FRPMj8YQJy4M8eahWUiq3q0dBse5wHOhgDGs0+gwFSgAC3zmXGENB9BkqJzQTdYcT
         cHC09UfOTqWuglKYdkZ1OZ+6dXDb6neGhbLfY9KcqeNUtu0JZZB9kJnTQCHCid2/U8F1
         Q2AuskLXJcLghxTnYqI+0WGaU/W0vKuHRqehwLNGusgslYg00RflxxEbUixUTU7ESL4y
         6nwA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784131389; x=1784736189; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2S+ZWXaS5Irs26a/6PxuDhmL7tMg+BK9b3L0EQ5QhKo=;
        b=wJEJscGLowVOltyP4zLUmCyBMk9K3Ah77arcn9BnM8AegmM4pyCHyku00TZ5Hcx1q3
         hVuZVGdJmZcV4RaewD2rx3QjRJUu13gdKaak44VD6kSvrHK4twX3rENK/wTxtVjTcMWj
         TYmtbU211JDM756a3K1pG3rpM9XDdRgj8sabkpImxL7OroaRtoHumCZuEncHeJB1x7Bp
         N3iITf1sfJc/G7iFv0aW6iPTKDGCiISgKl4tmJWydp3JljHX8EJoPh8Lbpq2gCyhTeW9
         ear0AgAVorYa19OaxJVKP8c/IvjrUdtjvWVdPDLJNmkci+z7QoucCn5/Ap/V6YpZnq2R
         RoFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784131389; x=1784736189;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2S+ZWXaS5Irs26a/6PxuDhmL7tMg+BK9b3L0EQ5QhKo=;
        b=EbwvgBnLRq9aJOIVAzJzGJNctyu+FAoGr0C9R1PWUYgEERWLb8unOu991qWrb35ZCD
         m7VHsJCOGn4aZFV6cm2SlSrn/iJftYGm2UWiMRvWbqm5dfS2AvpJfAYYTqqKnduKyV9Y
         3H40AoevrnEF+aQN6ZwWr5vQ5DXXNGtbj1I4L8ykKBrH1FEOjH5n/HKrp2U2f70kD97i
         SEp7KPgzCHlr1405Qc3kZDBO5/rE2T6SkacqxlnGlbb+v5/m9rXlb8bwHo0mMOimRD4V
         01+iXO9d7UKslExIf8zvo2OWTGdPiDDq28Ic1VQ7PCLGEyPPaQMfQKoiC/HRpHQgsn/S
         rZ4g==
X-Forwarded-Encrypted: i=1; AHgh+RrQC+HMXmnVMmLnAEwpp6zTcBb8pKmEwwqC2SY7U089UFduASwm0en+vGR3zs7JFucTaDocR+4H@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2S/9V8pm7RjaJTEAnjEQgXtOWHexDTgPEKOWIdLk5qPu1BBmA
	P0L2a5xyt72tvKMoGRutGc/y4QS+jbbhcuHbH6bBlHrzeXaDgEAdPf6oMJBb6HIg4EOsCoxzUZf
	dzjkw8Bt3xyhKENX648NvZfY5h8aTFa+80B+v35IO
X-Gm-Gg: AfdE7ck17flSCmeLhWFBU8t9xE+iv4VXmscnWW2iT9q6CNUel/bgkNPc8ALkEKdd8Ya
	SF/Ip9Re4iRcCTzT+9I7juh8vhkRv/QQVz2KHPUWg+LZz7T7VvAb/K4WbCOxaCvB44i8LifLqZz
	zhGQdt/RiTnYfK1WrVWpYx/OpnHCeUo07snJz+9rq25gQXvfMXbhXE7Ce3wgcleTlj71lJhGAI4
	Bmgf83JXOS+xoz/JMzu0gtWsmgpCK1nrzCW99Xp4k+/kg8Dxz4+vXhcpyKnVyjwC5t/EP1h3b6N
	i1/PXOVHEnWHcAWyPcCcO091yr85aHnjR2WnnA==
X-Received: by 2002:a05:622a:1f13:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-51d7bc99378mr30368621cf.5.1784131388244; Wed, 15 Jul 2026
 09:03:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-1-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-1-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 09:02:56 -0700
X-Gm-Features: AUfX_mycrnHJ859GMB84BD6ws8uva6PPMJW56YPeFhhPhkZ4LCFIUAMmQPY6LoU
Message-ID: <CAJuCfpHgMwM7SK-sanGpEyCxCi-T+gDqFJHnV_AMt=S-x5oynw@mail.gmail.com>
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

On Wed, Jul 15, 2026 at 3:10=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> struct kfence_metadata only has obj_exts with CONFIG_MEMCG.

I don't quite understand this statement. obj_exts are allocated when
either CONFIG_MEMCG or CONFIG_MEM_ALLOC_PROFILING is enabled.

> If it's
> enabled, it does also work for allocation profiling, but there's little
> value recording tags for KFENCE objects.

Unless we are leaking them, right?

> Furthermore it would complicate
> the upcoming changes, so just skip them in the slab hooks.

Ok, I can understand that. If we do this, we should document that
kfence objects are no longer tracked.

>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 0337e60db5ac..a4be70d080fb 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2352,6 +2352,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *=
s, void *object, gfp_t flags,
>         if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
>                 return;
>
> +       if (is_kfence_address(object))
> +               return;
> +
>         slab =3D virt_to_slab(object);
>         obj_exts =3D prepare_slab_obj_exts_hook(s, slab, flags, alloc_fla=
gs, object);
>         /*
> @@ -2399,6 +2402,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s=
, struct slab *slab, void **p
>         for (i =3D 0; i < objects; i++) {
>                 unsigned int off =3D obj_to_index(s, slab, p[i]);
>
> +               if (is_kfence_address(p[i]))
> +                       continue;
> +
>                 alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s-=
>size);
>         }
>         put_slab_obj_exts(obj_exts);
>
> --
> 2.55.0
>
