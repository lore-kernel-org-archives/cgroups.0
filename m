Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA692BD59C
	for <cgroups@vger.kernel.org>; Mon, 15 Jun 2026 04:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781498946; cv=pass; b=pHPsT+P9aukhEPbHR9klXzWz3PqKcXJb9OOsv28iu3gE0Xue1FfTahbpUMm/kWp9C+82SRAUYKbANSoNsrpxwlAWg1m4Von8GI2SxJ3+gX5quSCHxLJwsVfNyPSph0ECQN456ScWUaAob0gfyH95UnHZ9M6bykaJw6ks9K+6/7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781498946; c=relaxed/simple;
	bh=1ZVaLJtm9AF4TOsY+PiZF62OILxvgSgyaIycciCQOwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J1IM50udlhUK/4a2NQ64YtlBGBPJmnlM92X/WLJG71uPclFz3FPngl/KSrIYzgtYerLSrOLsgWI8v7LCv/I6a3oz+nKbwv34QDGFq7DxbIPXR+2bvm2h73fDNwoXBkQiJwxae/CIsdQPefXUotGQihDBxygJDH6+fV3+U4S2sFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A9urIWNn; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A9urIWNn"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51765531803so857351cf.0
        for <cgroups@vger.kernel.org>; Sun, 14 Jun 2026 21:49:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781498944; cv=none;
        d=google.com; s=arc-20240605;
        b=YGxYNpRgh8Mt4Oe4JPqISTJLEF44+Zjh7268YsIjmvJ6HNzIniJ+7wZjG7dsVoyDV4
         egQ4JPoddD3U2LNINVCX234o7imCTrpdUZaHCL6Dg9kNgxAZUm4OFqB3hFM/xJl3MQQn
         6Xct6WOLlHz9rxxgWSHrtbmHNGOmv3EDd6xiWNCKNdsvyXbCeT3E4Oy1GhlnWubleXMr
         4QAyu1uo3N8ycNMpFswkbDzUGCbQaRN2jAcKtQFiBoC2yO9zoGuPAnsAoWj8LSFlUQcn
         eAjFnbLj26YQKbwaCL+evisMY0Pp6H2+ql6+yFOR83GMHuxtx6S6+iGCI8eSJlena+yA
         cbkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a5X6KhbPcr6peWO5DbUfE0fIt/7M+wDHETmaVkQi2jY=;
        fh=4Jir+4w9t92xLzmunG5BnkExHS0FF6l6iBmC2pOnwjI=;
        b=hShVU+GO9vSHqAw5INPiRk4bRqJY+5yhy9zBo4H+MnBe3aus1Cj3IsS39V48DCQRo+
         WfcqJ57rK1E6ozpcRVqLfSIYJnowYK2vhNLUS8TaT8KNflSDwF/MAc6A+mnsrVR6HDP4
         v7oJ7giK6V4u/LcpnbMAncbGHW+KY5kA4rl2aYU4OASmp5UBoX8PT9Qa4PQljVVFqVPP
         vzAOgkH98DlTd4uQ2sMiVYG9OdLBviSAnMHpNZcbIqddH+sFgPywYOmxfyCT8qGkA9+3
         YOlMQGQCnTO69izArX1wP1J1Tq8qkKXZGnJBbg3BjjOIfCOQZ6qjhjlc5RLfz2nvQ+fz
         tyfw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781498944; x=1782103744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5X6KhbPcr6peWO5DbUfE0fIt/7M+wDHETmaVkQi2jY=;
        b=A9urIWNnOIlztfTzf1gJdr1LzauPBxdoRM37QM3VSZcE026EAbTOT5P4PMgLvAZivs
         0VBDrIdQPPMXWD9t7Rh5PSZvN682kCgFbwfTCk64zU9txE+tfRCx7AOFnFqIDwDV/UVr
         BN0tGFQBUp/X8j79qs96QhB87kToMw6G5KBpFMw7mLlF1D8Ht99FjXg3Bm2siNdLAaGR
         Z9MQ2IrHK75czOkXL8WIcv2iqCYoILgfqkM3v++13fw/zRBh/CI2JpkZy3pfvdtyu9qe
         rPkCJcyRNxbHJqdR93YWWl5N+Q1TM3OnrKbaqJ12rIBcY/ajHh8Ku0LvcXaybRAuMSJf
         uN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781498944; x=1782103744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a5X6KhbPcr6peWO5DbUfE0fIt/7M+wDHETmaVkQi2jY=;
        b=QyrV17LOHviQkQrRffnEiqW12jGR7xxBKys9+jEU/XYlFH5UnQeZVBuEgBBPHzywom
         8U03K133GmHjMz1R1vD7mKkNXI5/eKvimWfi4ARPXSf5/sZ4JYLF+kiD1GW144ZpM4lM
         2ymY5ARS46h0kVtRn2JRn2wNC1uo1zclEwGRxVoG+PC6vn0U519bWck19SIDME/ziJN0
         e/O/tEbeZOvdjIFEsefVD1HTsTN+SImkQ3sS5+ZDdzl7Uoq+AwHpq0MkidRJ3m6sDLvC
         hN2lU2XcppHeVO/wXGukMU0BrHbZQfTeKO1Sca77a5hgiVwCqzMBMROdDym0vmz4SqS7
         M8yA==
X-Forwarded-Encrypted: i=1; AFNElJ8qDvnUz7fK1TDaOpBDmAPs9b5DiEgeTPT5MGZee09WtwecfXfsL/QNO6eqX7b7vqNGsod+1Jwl@vger.kernel.org
X-Gm-Message-State: AOJu0YwCcqkf+h6BvEwubYp7egZa+sxHkUIS5GQflmENtt2uzIkpvuQi
	KR2Vlk/kKbx2jAOZRMuiHPI7Rn4fBRw/6KYjaNi3Eb0IzGrEvKhnE6LEDtinXpbM7PESOPfAqQD
	PSQTKn4hcqDBQRrCZlagThBavm2zZy/8t6KxcBMGj
X-Gm-Gg: Acq92OGawEvS9kYqjLvtEAnp0Q2am1tlsUnz0L5uuC29750BP812E7hRSCFxeZdnR5E
	A4/qc/3UDWPyTSOOu/KfOlrZQqKNCHQQcEIAuUnZVh4PtCbh0UxqfsZmVO+v17J3qbzZKl3fi75
	pYPgIMV+GOAM3n/OmIYFQafojtzKQoKCGg/9PPrVv4kQE5tV0bX3rKku518xmHMMAmmo2yhPSNt
	XUtDIakz//AHoV4MTn1+Ghs4AXAazGf+NzD0xjM8wlgWovGhgXoHZnjZ+7WD/Vf7RC+c001K5ob
	Z03UJQ==
X-Received: by 2002:a05:622a:4c12:b0:516:4f62:85e7 with SMTP id
 d75a77b69052e-51954a8ed36mr13872781cf.18.1781498943745; Sun, 14 Jun 2026
 21:49:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-11-7190909db118@kernel.org> <ait6ojueVi38-s85@fedora>
 <3f53fc18-838f-44ab-acad-4323daa0fbcc@kernel.org>
In-Reply-To: <3f53fc18-838f-44ab-acad-4323daa0fbcc@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 21:48:52 -0700
X-Gm-Features: AVVi8Cenjgv4vhVicxVOeHvw2PJU_Jy9c064pi49GikljHiOJMDuYR0H3JQF4wI
Message-ID: <CAJuCfpFcqtHjoE9yVOr2KeEK2+hRdHsgBLTSdr_DcVJpBu-KKg@mail.gmail.com>
Subject: Re: [PATCH v2 11/16] mm/slab: allow kmem_cache_alloc_bulk() with any
 gfp flags
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 12, 2026 at 3:05=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/12/26 05:21, Hao Li wrote:
> > On Wed, Jun 10, 2026 at 05:40:13PM +0200, Vlastimil Babka (SUSE) wrote:
> >> The last user of gfpflags_allow_spinning() in slab is
> >> alloc_from_pcs_bulk(), which is only called from
> >> kmem_cache_alloc_bulk().
> >>
> >> It turns out that gfpflags_allow_spinning() is not necessary, because
> >> kmem_cache_alloc_bulk() is only expected to be called from context tha=
t
> >> does allow spinning, so simply replace it with 'true'.
> >>
> >> With that, we can remove the "@flags must allow spinning" part of the
> >> kernel doc, as there is no more connection to the gfp flags in the sla=
b
> >> implementation.
> >>
> >> Also remove a comment in alloc_slab_obj_exts() because there should be
> >> no more false positives possible due to gfp_allowed_mask during early
> >> boot.
> >>
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  mm/slub.c | 11 ++---------
> >>  1 file changed, 2 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 0b9974bfcb24..ef457e07db83 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2171,12 +2171,6 @@ int alloc_slab_obj_exts(struct slab *slab, stru=
ct kmem_cache *s,
> >>
> >>      sz =3D obj_exts_alloc_size(s, slab, gfp);
> >>
> >> -    /*
> >> -     * Note that allow_spin may be false during early boot and its
> >> -     * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only support=
ing
> >> -     * architectures with cmpxchg16b, early obj_exts will be missing =
for
> >> -     * very early allocations on those.
> >> -     */
> >>      if (unlikely(!allow_spin))
> >>              vec =3D kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
> >>                                   slab_nid(slab));
> >> @@ -4867,7 +4861,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cac=
he *s, gfp_t gfp, size_t size,
> >>              }
> >>
> >>              full =3D barn_replace_empty_sheaf(barn, pcs->main,
> >> -                                            gfpflags_allow_spinning(g=
fp));
> >> +                                            /* allow_spin =3D */ true=
);
> >
> > we can remove the `gfp` arg as this function no longer use it.
>
> True, done!

I see it fixed in
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=3Dsl=
ab/for-next,
so

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
