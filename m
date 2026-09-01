Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9950038BF72
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 01:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788224714; cv=pass; b=nLrMJ+TPnNEyQexdlZ4KhadtZwv2OztX6ABNI64Tj3x9rGWRu0r3heGN/RsGiIADuXbW4eyGIRvLHu10/O6M20uKnQsDgZ9Zj10sIfqZuPit2Cz7yp6N/ujY/MZqwum9OJAFgcyBFY5r8lZHnPiXb/lyHRbD+wdnCu1frIrsZ/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788224714; c=relaxed/simple;
	bh=rCXar17b9Zfs8+JbBMEwMyfXf7r3W/8xbeDNprk7fJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ir6fdyHnkz2gArStOzjoAH1CSogXCwMcVk9BmkMiLtU9UB5VysdjGBtFblahoFmVfVtcuuYgTva/c3oDM7Jls7u71fY9FYLxL5k3+LAkE9ltO24i8lJ6pATTK2qx17Os0Vxxw+ZuJ235W4lZaZENFWXSPWn9XfNeKl4rYBK4okg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cfuu/kbN; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cfuu/kbN"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-499add6348fso11375e9.1
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 18:05:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788224709; cv=none;
        d=google.com; s=arc-20260327;
        b=WRD761qmxVl2QvJX2KhgAilN/iRDaTn+TLjdeI6zP+ltb4uNxcsXRJwVCUAqy+i7OL
         +C7L63VoJV0PajjPHsXbibKtc0u1DRrQU+5nkji5Pmh6hbR7NjmJO/pTypMvcMt4oqG7
         8nm+jolrr9panDDit7ZnWu7UQ1upoBH4Fxqi+9pj4dMvO1n6JwWNB2FN8iZAhebsFJ4w
         AvTKJHiOLw6lnmrdCdHM6Ikj1m7CTVHmkGRCk/1VC6XNdjEKej+3F2TpZvlx1xoOO1ZG
         HgYzaD75WfqhB1K8xT3HVdtWaY4h8mmNrMjQlCx1qiz/s1nqD8sg6BvauOYE4uVQntkg
         iiHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mFR8aYSnOaVLnjgwM+vo5O2WKxjAzys+M0VrDg9dEOw=;
        fh=gIN7OavdTvA9SVWs2YpcggjGKuXm8tR8F/9/GYl+93s=;
        b=YRRiBizOe7INrEQnV77lIYCSFhRU/59YdvXxSWUcw7onPdHh2Lyfx2+pj8srvm/w5m
         IqfTvERNdEi5JZ2HesPMN4f568fnRvrGBsOAtAstfCWgGuV4PlngpgiaTu15I32XptV6
         OMaYhpzCgb2kZpLukjPvlfK8aDrDUtd4VA1v/+PskP4TIiIIGyih2luYSea+KxWr9F5z
         C+6CQVCOFPUCt4LnGePeajiGZUgyREMZ9Ais1QCK/6CAK1ibCsUijnZ0/8BeJ477F6Ij
         d0KG0zrkZdjguvpMCA5Eifa+QPsud3BY+l9hwGeT+DkN57nIwv93DjI3ZPPFkJct5hai
         HFPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788224709; x=1788829509; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mFR8aYSnOaVLnjgwM+vo5O2WKxjAzys+M0VrDg9dEOw=;
        b=cfuu/kbNiiHChyxAPhsjcDeOOX0SY9zZzOw9+6+wMMoonHk82+31sB6EQpIRXn4JOv
         hhFsWmK93uF3LBX5rstp9oaIgw+1HYEqcCxfXMtdFa7taZrIdWhl/McZvri46trtZHzp
         tWY+CQpYmPbnFTo8NIJipfqO6ULoEOnEP3Fmj6RHKMmaRlqpkE3PLDF4GoERHuf1Wyye
         xmWdwg3tR9Pe3kM7Q8QUJdEKWfEYYnSIzz/C9/wEkSYeujR6OCdzOfPSnsglghjQIQo2
         Ix89W7ubMPM5isfbr7kapi6nnQnuSGinehhXuMvOpDdiw6XUml3+rLz+Nul8A6xN1KK8
         RDew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788224709; x=1788829509;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mFR8aYSnOaVLnjgwM+vo5O2WKxjAzys+M0VrDg9dEOw=;
        b=i7U0p/fP/iVa/EjDE0i6lKMnMs3yPc+RR6mJuQ1kYUA2tubeapGm6u5STcM5ZqJ+so
         pT6qcm0fKBRZUw1mAgPbaqEXYT2/o4ZG2o/ea4wF8hssGI8R4f8B0i1fIQxA87xTsEt4
         vHnRAHSo0Sf4QArOv+bqEoOGalGbkyrKdGOhf20wFllLbuHbVkbfIEvni9IlmcobTSKU
         DvFueu+MtO0PkfA0nw913eTAGgefUewwDt0QZZSLN8knw2uBgEwbDt8hYBuiDqnfW+pV
         hHUM6vMIb8P5LBv/0uQvEn3MZOi+5SqTsBCflCMDdt2TQNjum5kSVTnd86etM5mWDGGK
         YyJg==
X-Forwarded-Encrypted: i=1; AHgh+Rqk+f7mN+J7/wTHjuoiGxkpVk+bNYvC4+o+yAbBg+V9lguP6fmXkj2ikVbd5fpbuc9n87XF5i+C@vger.kernel.org
X-Gm-Message-State: AFuF++lFuiCmue9/WrWhHzK0/nJDrMuq2W0rKmD1BK9QqYvIdFp8X7uH
	YabbWwTU2xqdIZMaM8rerWQ7bk85I2l6ZyPaJ+Mr6gFxTJdGTHdh0hz81JQwNPAIPvRQWN807W1
	Wvjaaj802EkKp19oVNFiSPc6CZEn777+AOvvg8KOP
X-Gm-Gg: AR+sD12fiU5yTjADnVtMmpD75oF+k3RN94deRZ24W2toD2ChCBNKJ145O6DDvizqanV
	wIVs72crsIEdxl5lMySKbvPBXFBDwzQtpcK/y9hUWEoqLYRwML8F0EbowYYjX3ebGO+aCKt8o+9
	0pqKp6eLjec75JtqzqP1KxurG4RhV8dwAP0hwmqeQvdGLgF8hVz2BCKoAnePShnXx2kiP/3oNg/
	7CRMD90J4Ym6vYbC+EipNCq7X//TYTsP1uXsYIkYWzw9GomOuSPbI7fbiePhZ0A/N86KbWPe9/O
	R7jRbqZGyAsRQ4JziORq9m2j7U+zKxSJlePTg9R9DxhQyABmDGGMZqe59T3f5LJ+QCjKLKDG2es
	=
X-Received: by 2002:a05:600c:c088:b0:499:c4db:2ea9 with SMTP id
 5b1f17b1804b1-49cde7bdfaamr142075e9.9.1788224708321; Mon, 31 Aug 2026
 18:05:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831234339.280376-1-stevensd@google.com> <apYXCL_GJs9Ovu0v@linux.dev>
In-Reply-To: <apYXCL_GJs9Ovu0v@linux.dev>
From: David Stevens <stevensd@google.com>
Date: Mon, 31 Aug 2026 18:04:57 -0700
X-Gm-Features: AcwNN1UUQ5wS7WM0_atlL1tQIeuhEAKnPM1Hr-Z68q5Q2CNXNYgeVFoYiElXs7Y
Message-ID: <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is allowed
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 5:10=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> > Memcg charging can be done from any context, but calling schedule_work(=
)
> > isn't safe from an NMI. If memory.high is breached from a context where
> > spinning isn't allowed, use irq_work to schedule the reclaim work.
> >
> > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > Signed-off-by: David Stevens <stevensd@google.com>
>
> Did you hit this issue or just code inspection? I assume this is the
> done_restock code path.

I just found this via code inspection. I spent a little bit trying to
trigger it for real, but the only way I managed was by writing a hacky
driver absuing alloc_pages_nolock().

> > ---
> >  include/linux/memcontrol.h |  1 +
> >  mm/memcontrol.c            | 12 +++++++++++-
> >  2 files changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 8170bb8066a2..036d973ceca6 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -219,6 +219,7 @@ struct mem_cgroup {
> >       spinlock_t       peaks_lock;
> >
> >       /* Range enforcement for interrupt charges */
> > +     struct irq_work high_irq_work;
>
> Instead of adding more complexity, let's just return if we can not spin o=
n
> done_restock path.
>

There would be no guarantee that memcg reclaim would ever be
triggered, which also would also stop MEMCG_HIGH events from being
generated. Overall that seems a more serious than just dropping
userspace notifications like is done for MEMCG_MAX.

That said, it is very much an edge case. I can send a patch with the
simpler fix if dropping the events is preferred.

-David
