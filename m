Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263E049362E
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 18:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788286121; cv=pass; b=qpnuDVhvAaCq4E7QysvBPgefE8ye1er2WtvLV5g3nvEgWXbgyPsibzpwo0iJbskHuD/Qnsl5rV8Xx9/5hYXc+ARMFqkR0xTujNX/VrQovn/Qe9hlqtVeZlSSODKjERh/3mv0SjhMQbuz+MHteZ1gMwTcD7Eps/G2BqXEP3AuGtE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788286121; c=relaxed/simple;
	bh=X8FXyGo/raPRkoKPVRflMF35yNw57qYqgXG+3mdOgbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LtdU6D2U+OX1TN7TCUcKhuJ59jCwXGwxcr5xyRH21RsIoOn/lCVl2l+p+sJSWd8jTZXGcgqNKRfKdRG/UUv1O7ZTWCIprKf3OBJN46ZgC8orGFZSMrbU3uzrmnpiMeDWbrBnQWZ/PribZeEKOF9CorC5+HRNg9o7bGpbL0tVQHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r3Y+jpYF; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r3Y+jpYF"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-498012a61f6so5575e9.0
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 11:08:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788286118; cv=none;
        d=google.com; s=arc-20260327;
        b=OQ8B6YuuTFva2aXZ5fSB/MowOYWONOd5jpm15yRQ2aJiDNHcJnywA7CfwGTcJhY3vg
         MXHMWZUTCsvK5gUfVQvNPnVaOnUYNsasHA/m7dSlU/D+Fbi2nX+xQT76QmHvp2ZttYbk
         UF37JdVgQ/EQ1fIv2JglHdzs3ZzJHcarFl37uT3cLisMlclghgxfrn9OATpB4HclOybH
         VroWS6X5SOJ6FYvePCf+01Qwo3o+Vtv4hJHatKuHT3bBHncvUpVLugMSAFKMsjAxbNXs
         f7+yPBQwa5eazfDlUbS+u7ymV8a+2/r7Yv0mEpFxHS0Og8uaSbk6TTbuZ5M509EFTWPZ
         4Cbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X8FXyGo/raPRkoKPVRflMF35yNw57qYqgXG+3mdOgbE=;
        fh=wgmxzCq7fS+dK+123mClAslbfdiG8C79iQClNQkyW1E=;
        b=BbWyGEG+4ivKAd68zs+B1Vzr1QbW+42xcltK5Wg3QVoLlld48HPPhAKeg5MM2VObh7
         dT00nYDpFU0X5TUNM+jR4qBI5urcosvShPZ5UxgFJETus66ARGmm8QgPxhlowo9oVPch
         gllSpCcE9a0NqRMe/agB91COLQfTuYLDG5vOaT9oogIILXWaxuhmduZDBDI3/WLJ6v+j
         8FTofcUp8JeDqUVF9PMFqfwXAcrvLXsSMx29IXRiPtRRc7jQVfkrHE0MUIygisk5H/CS
         rm19QmEdDGvz40UtVtjhj9RsSVcTi4S6ZtEMkq1pepJRj6HcirKBY0dCCfdEl41b/ixs
         XowQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788286118; x=1788890918; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X8FXyGo/raPRkoKPVRflMF35yNw57qYqgXG+3mdOgbE=;
        b=r3Y+jpYFBP9QgP3o8VlGeqoGnuVeIsV5aqh3U8uAcTvLNx3+PWGAoN36b6IiAuo/Za
         yXOs843Mt7n4vwklcQy3LfM/ZZnsva1J9KksYHOtoTg6GXuhQ1BmTGrIzfpvU+GP00mn
         WeJa0Nm7C8g8eotHjMpSrOzIbjQaAb8pRJzYGZCJBQcIHG/UPX6gLMkJlXBYgpMAHo8e
         YlR1SdsR/f5V+iCIFL706u0LPTpK+I7FbP1k3daKrm/3WMmAGStwPg+xBwvbx5cykX/F
         ekxPqXl7ng8467YwDpfWUd6+8hx7dUtkI7DNyzRFkkqm70CfaUsCsD+VYBeomSG2rrmR
         /Kuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286118; x=1788890918;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X8FXyGo/raPRkoKPVRflMF35yNw57qYqgXG+3mdOgbE=;
        b=rjSRg3y5ZnmiYWcELUla+N6IHcQBaqbgfvgayf3XP89sDQs9JvqetwCgTV5DzW8GLf
         VmWBoaGssuUbQzbHB2IGrIkhjJcm3V3xDhwh949ZZTRabK/JUMi5oN5Popek8EsvJAqU
         9J/Nf2WNU+VcYSxSb4DuePAXT/SAStC1VPejKcq0T+LnYIPlaIWWOQAA73v2iO67GqAJ
         PbpakAAppYPLzu0ET4/AzGUYfNzgJYLTCpZsWl/CHrpIcsWU9KAAvw+v/dxyWuplOagU
         2w36Yy0oCbiySjZt11rysllVWg6iv+Z5EftwnprANVIsEP3JPbtucKTost3EgzOUiN4c
         AKKA==
X-Forwarded-Encrypted: i=1; AHgh+RrkmfteThspDLHtaBFwjruehAB6SLSpoW2/tupky0e/5n/F470vULPoww2P2fECXnEliUdwolps@vger.kernel.org
X-Gm-Message-State: AFuF++nQ6mNPU3ofSPXBI9hRXpfEKobtIYobh6o8CuDV++3dKq9f+lno
	zvNjKvlbpfswROhZRvPsZvaJ344TB2IgmU00+LjGAXwbImtfBlWD3ULEPKakTLp4afdf6tDhuWa
	nUC1yC4HMOlUaIGp5qwkshKxrvdU6RkoQlm5yX+CC
X-Gm-Gg: AR+sD10RgX3zThOPHSijmn9WUf8StezpxBZRCQIH/kSkvK/xbCNsieP5cZBI0q3fCXQ
	ugkfckl0kis2Ix2/RN7+H+GQzxhM5iWruv0MMO8n1b2pvC6z/tNF57K6QSBxUioPIHhQZqONt5k
	9R08S5pt1GwFwHOn7Wf4DvM7hAgkLMG2WXUUgJb68zWYJL492H53IWmSIqpRx3urmMzcDnE4Nkx
	mn70v5fisSxly+kdDK4kuDFVReCKAPPKjjGl5rSCUC+oJVM1w0vuj+AgHZrGKsoj4xPZLpJpSsX
	rbShxpXTmuNhxwAVrCclg/AdwwOaqUElGadY1TCy4VrgMVpifSRltUFVRuMCKaRi/IUFX1n6hcA
	798mWcGfGHlLOTggRtkPwQOc9Fm86G0n0cxldW/q3UpQ=
X-Received: by 2002:a05:600c:c8:b0:49c:e41a:4c70 with SMTP id
 5b1f17b1804b1-49ce47aad23mr50035e9.6.1788286117650; Tue, 01 Sep 2026 11:08:37
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831234339.280376-1-stevensd@google.com> <apYXCL_GJs9Ovu0v@linux.dev>
 <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com> <apaKRS7TYhlGRRW3@tiehlicka>
In-Reply-To: <apaKRS7TYhlGRRW3@tiehlicka>
From: David Stevens <stevensd@google.com>
Date: Tue, 1 Sep 2026 11:08:25 -0700
X-Gm-Features: AcwNN1UXbwoF_SLVJgTUIv4PDetr6v3cnkw3nV8p3K9PhP-UrCNprRfCd1ZzSOk
Message-ID: <CAOiLmNF6Qfc1M83fYFH030J7UKR=t8zKoW2pGbzeFakBnH9Ycg@mail.gmail.com>
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is allowed
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 1:18=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Mon 31-08-26 18:04:57, David Stevens wrote:
> > On Mon, Aug 31, 2026 at 5:10=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> > > > Memcg charging can be done from any context, but calling schedule_w=
ork()
> > > > isn't safe from an NMI. If memory.high is breached from a context w=
here
> > > > spinning isn't allowed, use irq_work to schedule the reclaim work.
> > > >
> > > > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > > > Signed-off-by: David Stevens <stevensd@google.com>
> > >
> > > Did you hit this issue or just code inspection? I assume this is the
> > > done_restock code path.
> >
> > I just found this via code inspection. I spent a little bit trying to
> > trigger it for real, but the only way I managed was by writing a hacky
> > driver absuing alloc_pages_nolock().
>
> Then this is not really a fix but rather a new feature.

I spent a bit longer looking, and this can be hit via bpf_arena_alloc_pages=
().

-David
