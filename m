Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AB03D88E0
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 15:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784215711; cv=pass; b=ICCtzWbmeLnvp41najHZS9EiYzn0MlZV0T4iQqKHmzRl8dGeNzUwFRBGiiT4NJVoXDV1peuyRz1QEz/47kwY1G9XeyEIjxEoEY6cjGwhF4WKR+VTH0Xw6u1y1/v/KSH7BjUn6mgmFvPLtsymS0JNeN34qQbwhegypB1ksW9jflA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784215711; c=relaxed/simple;
	bh=QaFVWLhw7Xm2uibhg3GR9DuxtrmKHWEyAWIfWdAUY+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H6m6fCVz4BdgKx0iHEtjiFpVCdRUPQWRALo2HUtX+NtsvU8BalJki7TS+AyWv3+54LCg+ZihakZVrTyrTEgGIUMEEPXhAmATNCDYioTWQV4JdXIO31fQVECRk+jXGnn6l4cTyWtqFQRQSTL6bhNzGFALY2HzPnFxje98UfZcdYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZSYh5rmn; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZSYh5rmn"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c15a5b265so31511cf.0
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 08:28:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784215709; cv=none;
        d=google.com; s=arc-20260327;
        b=UXcWGHnN+2Lpaaa1OXz9KayI6VHmTicWgawAtmQA29T8gczxao+tsb+BHY6CuKLLaK
         3ykugtdOSDICXAYmXIkuY8drX0AmM1VAFKnLt4oxooOmFrHr0Xfi+hbt2nsVTT4yclCH
         S2j+SjLzLbEk68vlnyLWIfDU8WioImVZVrtErsIA8tMx/ME//Drp0PkfdPLO8lVguFmh
         cks9iwIRZerhPvEdAALVjLL3GwY8NRCbTk6Z+YhEWGjOL4KuK9cY5Kz9WO8W5v4xnjTl
         f3FmgP0KN5U/fby0rYCId/beBF+NxTroO1nMCg33NqeS3Qds0NsbGPMp6xQLs65kqUxo
         xYRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9MTmsp7P9R6NbE0jd3nKRTx/bls+aSkmj63tjPdkby8=;
        fh=HV4bX73V6ggE9Py+QROCXUO4pVJb2wh8UIB/EKhZDVY=;
        b=hfX4QJVakeZlkamNLFzTPwoTNHul6f6Pf70IqOHtB3bzsnZW4ryDe60qqi66YcnuD6
         vYBZEm94mNNcyNX3CHPHUbIwOSO8giKAx2uYN1o7qJF1AzaKS7DWP1DP2S03oJt06on9
         aSfw7hq3ZLdbnuwyTL/A4tsapRh4ihiK0rBHSS/wh6ptM1VR7D2MggPo8KAw/rfosYun
         bB9qgeJ82VBqbnb8NzGjQ+X4j2ge7gNOi+genmWMgUvrWnPfBbp5205gKS+x048W1v60
         NbRnbEMqKleHHgEMBpFxfGakUn5PhVMhdcckQMWmwme440h2mv7xiJlXG9zezTsXl90I
         /Eew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784215709; x=1784820509; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9MTmsp7P9R6NbE0jd3nKRTx/bls+aSkmj63tjPdkby8=;
        b=ZSYh5rmnzmUz8+uBzOZYmUmOZffEGoaJxAzweuJoWmzvaxvF3yLuA+kBSLFuKfQqLb
         2Ij21SXdJXdFGADI2Hr9hXLcEpiJDSiT/KxDJPgI2DcvC4/2XwR0W6ZLvFte13q/ZsGs
         3RBEcIJhIUrbsk55HehToUz5seKsKUtdeFdNk5x834VP9dAu4qSraCTDr0plWv9Iy4yr
         XN/alhnFgrBoG8h4hhulk/yO02upXB4/k2ypzf7hyj+5YNTj88IYkWch+GO1/K/CIofv
         cbHtugI0oML2PwXyzPpAfRPloY/PT6ot+Gs/DMa7VurEf4lHw0JNBvftuGkP8myoqhTz
         bwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784215709; x=1784820509;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9MTmsp7P9R6NbE0jd3nKRTx/bls+aSkmj63tjPdkby8=;
        b=ssFYcS+IboMZmHGRVTvCjTbqSRZ20V/gctLaQt/sJEBJ0l6jAdz66WTnPOAdS1BaWm
         LensdNbLfnhCdIq7YKCFg5sXkQ00/TBDCDuqr5FWJr5Y8du7UpFw8EBwp+bHl03gOaWu
         uYEa6g9rQkzuME8N15WkZnClV2VzLR7pbZmH/bHDztl4cRMVjZ2IYQ7PXSJaHQSV6HXT
         n+obOr2fHQpfFfXF0zSPf9E165L3N7sFo1F7edxDZTH1c54rgrLtZ7G6GeIW+k/W6iCe
         kt9V1B0zau2NCrAHqNXYdfheRUDp1+RWw+lqY7iYOAAC8N5H3dswWZujN+CcpQjax0xT
         vT3Q==
X-Forwarded-Encrypted: i=1; AHgh+RpZ2NMBwYLQ/x+GcCibp4g38hcz/TQ7QR7WKWT4R/kfDr4/f57o1K/RF8DYToeZWQcTQHHocEjA@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbp2OlTLus0x8UpPENFdXCbSDRV6ewngNnrht3xeiGyhrTqSzG
	RgjQZ8klCHHaHVwwj066oSxhPAzpXfOVzRP9Y7oi+0KPZYAARBxQCrdkcP7JsMyTPgwyybZiiLn
	WgI1U/UMLbPzXcNndQSkDnnq8IET1D8o3Nn+REVwB
X-Gm-Gg: AfdE7cl/x5wAzVHomhyi8n3UNYwPnMgAD80vgByDrqBpS30vdhwjbVYHML3YMc6GGhx
	XhxVhnhcIsaMyN6OXUvfCGmMCRWcDVAAz0Yz26+q3aztH0wYdO8X4n/6AH8zKixFDbskGzYVZ+f
	o8LKP8Ov6W3fpzomw5dEas1eUxNeB6pAElc7OxaiI9Eib/6nE/z65UHOWcF0eNyZEXc7PHr0A6y
	UJTjMSc2CPjMCbeIRjSwx7/KOY9nxkakAcLUabKPjg3Y9QYaG3Ygi/1A1cBnkgyNvT3PCCSfWaj
	Dt/HkZ/YdtXneq0=
X-Received: by 2002:a05:622a:2618:b0:51c:e80:9e88 with SMTP id
 d75a77b69052e-51f7f3ca787mr11136661cf.16.1784215708609; Thu, 16 Jul 2026
 08:28:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-8-9a49c4ccf4c3@kernel.org> <CAJuCfpGq3Yv8Dq=2mPgR5LGC=40VSNTA6mg4BjTRE0ADXMZkbg@mail.gmail.com>
 <01aa6803-e6a7-4172-94ef-043914e2f794@kernel.org>
In-Reply-To: <01aa6803-e6a7-4172-94ef-043914e2f794@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 16 Jul 2026 08:28:17 -0700
X-Gm-Features: AUfX_mxXFm8bI5YPQvcEPkQ_QsAl3HLbXj-fL32BvT9M-JPrvDl12nUblHbqJTo
Message-ID: <CAJuCfpGDzsoTp0Byg5QzeiOOJKoPWNXYcADOXC4hieHLNu1HQg@mail.gmail.com>
Subject: Re: [PATCH RFC 08/12] mm/slab: change struct slabobj_ext to a union
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 7:43=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 7/16/26 06:11, Suren Baghdasaryan wrote:
> > On Wed, Jul 15, 2026 at 3:11=E2=80=AFAM Vlastimil Babka (SUSE)
> > <vbabka@kernel.org> wrote:
> >> No functional change intended, the layout is still effectively static.
> >>
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >
> > This is much cleaner than what I was preparing. Nicely done!
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> Thanks!
>
> >> ---
> >>  mm/slab.h | 41 +++++++++++++++++++++++++++++++++--------
> >>  mm/slub.c | 17 +++++++++--------
> >>  2 files changed, 42 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/mm/slab.h b/mm/slab.h
> >> index 3ad9777ad600..359ab8caf61e 100644
> >> --- a/mm/slab.h
> >> +++ b/mm/slab.h
> >> @@ -554,14 +554,34 @@ static inline bool need_kmalloc_no_objext(void)
> >>   * if MEMCG_DATA_OBJEXTS is set.
> >>   */
> >>  struct slabobj_ext {
> >
> > Perhaps we should add a comment here stating that every element of
> > this union should be pointer-sized?
> >
>
> OK, how about this?
>
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -550,10 +550,14 @@ static inline bool need_kmalloc_no_objext(void)
>  }
>
>  /*
> - * Extended information for slab objects stored as an array in page->mem=
cg_data
> - * if MEMCG_DATA_OBJEXTS is set.
> + * Extended information for slab objects stored as a pointer to an array=
 in
> + * slab->obj_exts (aliasing page->memcg_data) if MEMCG_DATA_OBJEXTS is s=
et.
>   */
>  struct slabobj_ext {
> +       /*
> +        * All elements of the union should be pointer-sized to avoid mem=
ory
> +        * waste
> +        */

Perfect. Thank you!

>         union {
>  #ifdef CONFIG_MEMCG
>                 struct obj_cgroup *_objcg;
>
