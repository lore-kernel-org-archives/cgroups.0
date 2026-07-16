Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A62239FCB5
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 15:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784215659; cv=pass; b=NPixUZaEXcddy+x43Yd71a3B+fgYOCc9NWWMxsJfARfZfAqlyYI/joWUJGR/BX3i/PYPh8QWoHLDCkg9cxpvfkVCIWdjhk2iZSY8U36ATtv0pm7bcaU07x6pRgaF5aoNwezyrA8i6bCv6X9zePzw3pHioxONmTCymJosLv81JnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784215659; c=relaxed/simple;
	bh=AkPk8DH4+MLV9l0SRKwhxPXiX3RBVqSKWSFcnGZfWks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hqvlO45DdkTVs2yT4y1AEfeRmP+mLt3QT8MvCLiRZ3PQrBHe1XRlf7fszU6LxGTy7wk7JJTInZDqLFtUfxiE83q+cRj/8vFSHCrayBoM6fCB3JOT93l+6+1EDMmeFtPDhwXtC5cgSW9La9iofyv76CpFmykZKRRGVgh32AuwvvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uaAcDvhG; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uaAcDvhG"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c10e86e52so29881cf.1
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 08:27:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784215655; cv=none;
        d=google.com; s=arc-20260327;
        b=NqxhyPrxr2zpwKSJLu4ocbtaISOhC+ctF66Kkb2XE9PfRxFISbi8Rk1med3eykbr6E
         b5SdykQwojsrxXv1kgR8MT2aHGEjluaexO4UXGio8DhzFo1jKr/fvfJgHrhnfKMlzaFf
         Q2gKj3HSgFWjYLdv8tIOSpUNXdUzxn/oTfH96ZrMu9VI5+aHeWCpPa78SBHg7fnNpWUA
         kFzXQdgBySZHaitXv63rOQTZbU+ANpObHKCqMtACl1i77qe7ul626kAnJEphjQ5KJImW
         6iBVpidN7TOpCm3Zhd9qcl0req/IHUFFtY6G3QdMnnge3NpVn1i9aBXMHNNf2ZuSVEHi
         qfdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1F/olKLrWB4qqHnjLjJSF9FomuDg/Zv/XEA7HymFvKM=;
        fh=OO2exjEraPDMFgyoMZ6q+S3ax5wknnOdktIRqQD8gjk=;
        b=Al0jNW7/jvACNMKYvGux/kTYMq7NEn1BOpTJSYXdTPteIRrxJRmHT9mo0fUK+Ulsl0
         hVtJ8/brknroseuu/THie7bP7dM93rwQFb3frfKFNCxGo+HqTGbIa3lbU2WPnda/H5BR
         kxzuIW7NPwk/BPCA6S7YjZsH9xrEQS9vAONz5gWWk3Ix+swDKjXZEZcZGdg7d/ZmEuJT
         2s5julHdi4CVw76it5GdWrYpKBBs9SuPsEw3iKf1PqAuqj/4Tjvojm39jFBVf5HMaytA
         UAhC9W9oG2cTui+dkAfRR99+UpxB7MJw1huZq25Ab3h13Zne8LcnAKLlywgLqC3gwgJ/
         pnjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784215655; x=1784820455; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1F/olKLrWB4qqHnjLjJSF9FomuDg/Zv/XEA7HymFvKM=;
        b=uaAcDvhGw4X1W/kWqZMZFAMSc4W/GmMKEaTO4K4f4pzSb2W5mLZjbtib7JaQ4VrQEq
         Haai+LAwjEVuz25h5IpqFiQTxXSYum3O79LXHIndAXs2NAthN92evgfuQTSFe7z1spsv
         kSp2Ad3u3NjdJ58at/dIQQCS9FR7/f6MfcJsc+/y1pSnTk2uDlYQ+6K3zaU4uGUY7gxb
         kBfVqb63F5OMOfhcfN8iA+dGCLBqwaQ7QK8J9jR/mVgBkimhk4oEjecsqsNoUDHGsHwG
         FZm7wEtun9iPkh7D0yXvap/Rw0DdmFGvLt5+k9tjHlUDQ1vFbVIvfp9IYRMwMP/Dhg7I
         bPpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784215655; x=1784820455;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1F/olKLrWB4qqHnjLjJSF9FomuDg/Zv/XEA7HymFvKM=;
        b=UR0uME01hrK38pdlXziFDFfwXfjpSYt0QNOKmA5V8IkfugARmOoy2jRooXPEVnZsn+
         kebiGhX/52VviyBvNkvBST3JerRPwC+4K/0LZ/17zcwIF3rq8p3gUTz0/K1HllgKNh8Y
         ArZZv86I5JuASded0z5XyliKqZ4rBwFgeCBmAABmF18iegfaUrtlwYjt1KkoKhkf34tY
         IqA8vseKsGgrcnNajPIWas2QWvodsf+wK3e9KjaoC4hlaC964a9k0+JR/owVZihPnWAi
         hZwLlNtDF0vJyofGIyzFRLqw8Uc9F/jDRasA3jxT/nWgJmJVFU+SyunKbVS3Nz9QBF07
         A8WQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp+L4bKyZLsph7KBdhrvsoEP5mkrS0abF0QceMLf9rxplhY4jj0MOuD2xdL9lPba044NvEdgO66@vger.kernel.org
X-Gm-Message-State: AOJu0YxzEGbQKsuTO3Tsn6q9tb7VECJ2ZE1081jalahW2+nnNz+9O44G
	YXJbmv9YyMRCWlNhKqf5Db7qKhZbhZh3PGrchdxk1sq5bMOaz+3M1wEFSLSkAwCGMi5sNxl8Sfn
	tlw/0pa4UiGkXsrsa48kD3BeO/Qf9/R+itLkZgaSA
X-Gm-Gg: AfdE7cn0Y6KcWQ7c87joBKGNKEcZFJ4SoR03E9I1JiayjAfaM02ZfxnZAE1/f5qjbDY
	0XRahd6itkjstsUfwgSIaoi3avUmk0w+6EvPUkFNJjsbZRfwMYFqEDxBDHZuoSVbry+ODAjsd5B
	CiMtJ7q3h8aIG6dNmEd4ifqQJ452CYVeg400dA0tRV03E2ZMPQ1dQce4a7YumsYwMlsiHdwMw02
	NOKYCR12P+6DiVGBpF9hiHbouCmny+Rn/Un1IxArc2SgXguZYC0cOvznGKSeEwcayI000jwfu/Y
	jOGjOzQOjDRG4pk=
X-Received: by 2002:a05:622a:94:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-51f7d273976mr9799081cf.4.1784215654893; Thu, 16 Jul 2026
 08:27:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org> <CAJuCfpEJV=OgCmQ9=tuMHOjMMh8bgHrpFe1gLtTXjagAenKZsg@mail.gmail.com>
 <eb3fc4d3-c8bd-44e9-88ba-7fb974a58aa3@kernel.org>
In-Reply-To: <eb3fc4d3-c8bd-44e9-88ba-7fb974a58aa3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 16 Jul 2026 08:27:22 -0700
X-Gm-Features: AUfX_my_bAm9pMs_cq2llYbd6SUBazq-pBVNFKSQG59fVdB5bXaPSKf2ohfyPJ4
Message-ID: <CAJuCfpFX-9Cahs5ZCTU+P2g5eLnhR_2mhrUR9JhF8ZG6cj8=AA@mail.gmail.com>
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 6:58=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 7/16/26 03:27, Suren Baghdasaryan wrote:
> > On Wed, Jul 15, 2026 at 3:11=E2=80=AFAM Vlastimil Babka (SUSE)
> > <vbabka@kernel.org> wrote:
> >> --- a/mm/slab.h
> >> +++ b/mm/slab.h
> >> @@ -555,7 +555,7 @@ static inline bool need_kmalloc_no_objext(void)
> >>   */
> >>  struct slabobj_ext {
> >>  #ifdef CONFIG_MEMCG
> >> -       struct obj_cgroup *objcg;
> >> +       struct obj_cgroup *_objcg;
> >>  #endif
> >>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> >>         union codetag_ref ref;
> >> @@ -661,6 +661,13 @@ slab_obj_ext(struct kmem_cache *s, struct slab *s=
lab, unsigned long obj_exts,
> >>         return kasan_reset_tag(obj_ext);
> >>  }
> >>
> >> +#ifdef CONFIG_MEMCG
> >> +static inline struct obj_cgroup **slab_obj_ext_objcgp(struct slabobj_=
ext *obj_ext)
> >
> > I understand why you need to return obj_cgroup** but maybe instead we
> > can have a separate setter function and just return a pointer here?
>
> Yeah I rewrote it now and it looks better. Thanks! It ended up like this =
due
> to some previous attempt I made.
>
> > That would also help catch cases when someone wants to set
> > obj_ext._objcg that was optimized away (for that the setter would need
> > an additional parameter to identify whether we allocated optimized
> > objext vector).
>
> It would need passing the slab parameter to assert
> slab_obj_ext_has_codetag() in debug mode. I don't think it's worth it giv=
en
> the get/set is only called from few specialized places.

Sounds good.

>
> >
> >> +{
> >> +       return &obj_ext->_objcg;
> >> +}
> >> +#endif
> >> +
> >>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> >>                         gfp_t gfp, unsigned int alloc_flags);
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 5e3f53bcd0d3..48e10198a3ce 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2523,7 +2523,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags=
)
> >>         if (obj_exts) {
> >>                 get_slab_obj_exts(obj_exts);
> >>                 obj_ext =3D slab_obj_ext(s, slab, obj_exts, p);
> >> -               if (unlikely(obj_ext->objcg)) {
> >> +               if (unlikely(*slab_obj_ext_objcgp(obj_ext))) {
> >>                         put_slab_obj_exts(obj_exts);
> >>                         return true;
> >>                 }
> >>
> >> --
> >> 2.55.0
> >>
>
