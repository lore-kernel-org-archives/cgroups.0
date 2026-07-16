Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C734165F16
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 04:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784176232; cv=pass; b=p7uzKZgUpUsvDGFeOmvrEe5daQPeCfKK41w99/NtOG0eZmUSlNTfUbB8jpXuDBLyyLY8/89mLU5wuyszyeY7A8fDU5YV/lzH1n8YHAti10mR5cC6AoO20BK6yNs/hnWprtxzYtSeNyW/KP+btvC8D4Bf5tqYqtAkW6BwlbHWPug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784176232; c=relaxed/simple;
	bh=SYCpj20mrnqCJsYJKMaG/fCD9cb7J7wKhfAlelM2+rY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tkfrTNISgDh/ZNPaDqTrW3dms2QzMk1BGgVXZMIvgoJ2yAv+bmnXRPnox68qv19mgOVu91HzZzoHlOaLRH1yLNUrvoW0iS09xeePqENsjjuqCiFy9PFdM55aSDRVmuLZxoB+V3ECUoSm7PCrcmLRSrwg7I782/WgD7npIO2z5Ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VH5SYrMd; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VH5SYrMd"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c15a5b265so161641cf.0
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 21:30:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784176228; cv=none;
        d=google.com; s=arc-20260327;
        b=gK3kA/t0XtxGYNbzSlhYvUrCEF3xRFvjwfO/SyQMfmpICoKTCTlPRR40VNr1EzaeSC
         gyv2F6qv+dQ77pn3tpzaidEki398YXqZxgoI8NNGQiNTpddoizqIXSDc/+tkKN4/CWE1
         Zz74mLUrdCkZo0SX9443q90HMkD2X7ZbHfkwl/jVWhwLNNJ3XTTsrtzadrN6Mg+1ZWLk
         u44MESSPuoe5dMIrLZJExKAIlDCMzQFShImDfHGbfMvuJu1swX/uwy+hq0DkKHeIlSmF
         4u8BuweBiIu+lqrhP7B2SA1/5LebBf5blPf1XiltTI8TUlcRd7QwbEXGBWksLvz5L4ih
         0GTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qPXbsSDypy3wPiCJBi1gr0/t6OIelw2fg6uTNPSbR/w=;
        fh=OUbkFIrCTZ8vVe9ohHwYoTfwmbcuNZUNFNfm+SoPI9k=;
        b=LQvvSaDAQGLNUC8N1l1DmMW/NtisR8TCr9wojyPYyNIOa7N7tEcLdIrjoqLRxDr1Th
         GS2uQA2U0SLqHmGDdswPokg33UiV95Slg4fysPOKmAmMd9sSPxx4b1uer9OgU967Gkfe
         84Ex37Yw0ZAOMtHYYcCSPnz602jEpvKUO05srlqaQz3o2mwImRYEECy0QHactpCqYHPt
         fnvTODlHzn8AgRo1RUImSwaVVC3w8Abgafo5h28eHliiHvs8EMEvgxItiqisTmzNjsWV
         sLb50fQTUX+pVQFGZGsvakwDNCMNPuiUNvi1/KBI8pG4tMG0sjzncF1my7aARMJgY1xz
         P6Tg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784176228; x=1784781028; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qPXbsSDypy3wPiCJBi1gr0/t6OIelw2fg6uTNPSbR/w=;
        b=VH5SYrMd9gUmK50mv/7gfrqByU4ipsL3cAoA+gGLNVZuXfRrxRcZvsMnZvN4JFZEtO
         XDq0Al7c+Ad92Sy3P8uDcIqjtuGQ0cTB7rcNOVbLriYdAiIYw8+h4SykSy0iFrEz7iCk
         xpQjAr8qaIKpqD7YZ5vii6vQK1PkDGxvBypNAqKaUnH0t9L6M9GjBc8FXtkMVqv5/BAo
         5S+Gdhjb1I4wU2RsRyByQbBlIpKcsifOp/QohTFk30bOLyE9AXnFszhCLHMCBtzOOn4y
         xIGYdHwiRXudsx2k0ieExgOeW/dAfyuQAP/OP4+LZSuDBnvnk+xm86OUsMkDiXE2e4fK
         ffpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784176228; x=1784781028;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qPXbsSDypy3wPiCJBi1gr0/t6OIelw2fg6uTNPSbR/w=;
        b=VxSgBKaHUWWP6FG+NvtX5UK32Yzbm8S3ZI7BXbaFGN88Fz4F47dej3ZEaLcL6Y38FC
         yS2UDaI7vAaIfYn8wu73hFFpWc+8lYKJoW/YsMzu9V7VQmac/ALsrcuaB9gi18F5HHtq
         UR7jp5Fn8Vq2B3Kc7enJHJ4yfLRnrNPYcs8hDgqB6MwCb6fT9Wiusouh819pUuYpvGC+
         ZvO7GdE0G+6nKcbDJGHmNE/gOxyPpCdHdQoWCUBq9BNnT36iXFetH0sxbNmRalmj4p6Z
         RO91nBHLiIbqw7GZMeH5ehXKgcHOfMajfI9cVGbI2cY66smjdLh7HsStFXkaXuICzEDr
         UmUw==
X-Forwarded-Encrypted: i=1; AHgh+RpDfuIM/+izbepeiATmrmaWt+Gm9ocD184pRRZQkwRz7kDBF9L0GS9I1ICgRCbgb41YkNunljOX@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc8sUe8mnavfw33EsomEcrAJUcaq1rNIqeWB5MkVAIO1IRy4kF
	bB10FEgqlGQfM5RUBrQDu6hjaws41x+IXL/pyMu20LY7PkZrKyLHnfsD5TDxW7nJH77FKdWOXz6
	TUQJPHml4sdWaeyRfGXerFePTgqBPvcvZFsy5EL3j
X-Gm-Gg: AfdE7ckW3JnIIwQrisDwMbIwSGXqMA9z0kUK+SZKpNm/qh0XzBDFclUuC2Rn6zfA3TG
	VUmi1ZiZAxD1h3SJNo/AetqwjpxJ/xu9fyZfHIOJSX0jVEmabT6xBF5yxTmmghBaFed2hccW7Bn
	RyvjUGItVX7j5Alzvc1/yt1zdg6MRZ1xLTtYbAoRHWYmFYfLKPfW5uNkXZ1Uxs3C/A8OehiuxHC
	yCNUEA97MnyWSutpVculPU5vUTQ0UJdw3x6krBe3LYtBYw+UFsBdvYGxroi
X-Received: by 2002:ac8:5cc5:0:b0:51c:7a90:a798 with SMTP id
 d75a77b69052e-51f7f4c185cmr4875081cf.24.1784176227519; Wed, 15 Jul 2026
 21:30:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-10-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-10-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 21:30:15 -0700
X-Gm-Features: AUfX_mzIwvD1EOJsmMk-LTsWWBZMYbvxEoZzeUE17X8MFBwGAL5qNSujdZODcvs
Message-ID: <CAJuCfpGXHuhLmTJFXKrBmCOMb_j8bA3wndekuewh=TULjXTXNw@mail.gmail.com>
Subject: Re: [PATCH RFC 10/12] mm/slab: reduce slabobj_ext memory with
 allocation profiling disabled
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 3:11=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> When memory allocation profiling is compiled in but permanently disabled
> on boot with (implicit or explicit) "never" parameter, stop allocating
> (wasting) memory for the codetag_ref parts of slabobj_ext metadata.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Looks good but we should verify that slab allocation performance is
not regressed, especially if
CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=3DY and then profiling was
disabled via "never" in the command line. I think that would be the
worst case scenario for performance.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slab.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/slab.h b/mm/slab.h
> index dcca86799fc9..a50347c9dbe3 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -587,7 +587,7 @@ static inline size_t static_obj_ext_size(void)
>         if (IS_ENABLED(CONFIG_MEMCG))
>                 sz +=3D 1;
>
> -       if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
> +       if (slab_obj_ext_has_codetag())
>                 sz +=3D 1;
>
>         return sizeof(struct slabobj_ext) * sz;
>
> --
> 2.55.0
>
