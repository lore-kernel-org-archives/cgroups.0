Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DD22E5B2D
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 00:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784163418; cv=pass; b=sNskOX068MQAV/sQW9mqRX90qO7O41e8FUZYm3fGyxwdQTjNSbgPIG/vpI0h2mGzPeUl/RxxDQVWqWqnQencvZFIlVEqYX3KjisP21sKFw5rA5P3jxQzzgir5IV/7+oJcI6jUFVr4uz0l+LxrIgP7PCbk9iA+aUS+mM7ItlvGQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784163418; c=relaxed/simple;
	bh=QHmgYMxgbOKG0Rkl6t+pPGbt9s4Heo8/Ob0ugz8hBDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mwJvsUhMQdWDhgtdd3j+DZSHL22thJaFkDzXSov+VqKFq15dHpp7aeMvNPVJkSCcb565XrFP6CvkicKnLhnND9y0z0VNj3E1JVU1Lb+PtAY+EIwbaRIPDhzTFUq2JOZL4S41LvWxY3INmx7RAGGNJGeCW0DZaUdnf0W6Ql++qwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eyowBDBH; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eyowBDBH"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c10ed63c0so76371cf.1
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 17:56:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784163416; cv=none;
        d=google.com; s=arc-20260327;
        b=pIjGPlIQYhtTc0zMQOcx0ySMt6aFSIAg+ROCon8JUT+/vviyKyNH/3YtKbBrCkoGpY
         MuA0xDnXZ9NgVnUgDi84du/Lw9IU1mMJIado9M6tZu8H+AUQSt8jltTtr738Ug/AY06l
         OdEBMPRSP60o/jeLOlcaYz4+71Tq4cMRxnP8e79fpLiscwXCVLhwdW3jWiojPGoEHOwP
         I1K8na5rg6F3axBl1+ozcEoh5rcGHjVv6QVw+V9SUrZOHJol1vT2S5MMaaKfWnNlRd5a
         YlznE0xrGAmeZYYBFaccLigDHCisX8gL4YxsQVlolElfsPZ8bXa/bR6dl2plWukX1SeN
         lqUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PqON3OrUt0fOomb2BLaFL3MREMgEqqs5y6so9+j5zoo=;
        fh=YeLMoUoin4EW5Do2qVNhZFl3/bLhnzrGAlvZ4haayaY=;
        b=VGamlV9VQiClPBn3UlGPsGK/Rddw5bw2cKQ3kDN6Oh9eYyetiFhNCGPclOUgkeyObA
         YdHGiOdHncBmBLq4SRYE1YoJcqE7D+1tOncq6wFiDiSU6blJCwdlUKBnX+z+IX5sYWiC
         vVsqKngzqkJxtLIbne4FJioKUH9IjCOcNqnZhYRsvTOm9IZJkTk7QkskZues5BvxRHYH
         l+0Tjl/kekg6304VBAEuUH8p5E9R4dfSZJVyFVllvGuN28WftQgqkqM6pzfMbNidf722
         pFhRfE2EM7jtQ0OyygozRoDksQIH9R7IlNm5b690zycyjJty5+bU196dLGnqYvvegUss
         GZwA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784163416; x=1784768216; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PqON3OrUt0fOomb2BLaFL3MREMgEqqs5y6so9+j5zoo=;
        b=eyowBDBHlAX5NVht3NrLZk5Y0sDzCD/NfwuZ5W5qOwLIkB0nCxrDGpLjdKJCxpXkqD
         FbcAjhmhyPufVTVEhtbQMGDGSjkFX5hkppldY/oyWafiHup/Hnmh7d+QkAlmysUgdc5V
         tAq9mtdFFBQnKCMhSUVerhGgAg+kKb8QRnhygfCc2g2M5MdWrtTzJXUKVdyjutzFzZMf
         2/oEDP1S6AE1+CYgcgzimNy1TcVw/nVtqZDUEbAPh0JFMJ1b110Z9eH2mDxjfHP2uqMk
         8+Rdbundbj2c7+QQjDIJnewAhnjrACXeUsYssE3NkbxBXeENG4bCnuJmtdDAdDkZi6kw
         Ni7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784163416; x=1784768216;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PqON3OrUt0fOomb2BLaFL3MREMgEqqs5y6so9+j5zoo=;
        b=RvXkKnfJMFKMBzLqgDumKr3i2zWNDD+rfhKMfaiaGd57APczR4T7VwksoDZtfgpDSE
         XMv4MTWFGMsa/omBnKSpSZIrLaL5I9r0VENo+pYgpzKCx3yVfyOMRHzSpiZ38d19GbU4
         UJbGZLF3UcoADxYJGhov/mbb4kymdI0GsXRNPUrRqriBB+jAIP0mM2Lucc26GLYAiS+y
         JWKDNv2Hxk9i3dj02W+SwrBVbHPVg4uhF2L8GcfDcRdDZ9gCRm2yyfWWGbRBlIORP2Oa
         Mai/gmmz1kQOUvLSZTM7oyLX10JEcA71w7hXVjpQYTx9JVJAH/zZ8EXjSlmxIG9dT9AC
         XBCw==
X-Forwarded-Encrypted: i=1; AHgh+RoU87gSfK3ABUIgkjALVTrimTGGuaBTeI1VURuiiEVw1c6wSysnCkQCF9bH0nkjewu6vT+kXjTT@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4x5WtUQI7/xbBOChHE+ZxiH9kz1LZ9DG1rcKlep5Xdu1tNHqk
	WsYBFqTRLmL5CPHUOkX08Cx1bdZo9mDim3GeEQjSPanObrhGuoT2h05ZczCxUjy9pIXv45XLtB+
	xV8B3EYQSGims7nLunBDuCnjWucymJtXrs/J13ZWt
X-Gm-Gg: AfdE7clVwQ16UXQTLA0z+N8piWH12Cm2pnK3QhkHVl4P4KI/WHvjR4PsvREF6uO7ICU
	tu+HlF4jpmDB6X0T8sgu/ESoxXwS0+C/GDvX1pawrEsxyeCKg4yPvDmLQ/bS+RmolUsXwjDrOpC
	gJRJjwRHnpcgIXN7BePiNQUoYJXpeT/40ZOCv6qPzxoQv373E0HXDxlNyczt5CV9VJK97PUNFTh
	7FGqSijJMLgEWez+G32O/Ma5qkKRad3VV/+1rt3oq7lhx27apr4LK2vn3Br
X-Received: by 2002:a05:622a:4d95:b0:51b:fd21:c077 with SMTP id
 d75a77b69052e-51fa50ac9f9mr2206021cf.21.1784163415394; Wed, 15 Jul 2026
 17:56:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-3-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-3-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 17:56:44 -0700
X-Gm-Features: AUfX_mz6azLOlVXfbVD-t1IDS1r91veMOOF5VyiUSpL7t9Z77OmdvGy3eUFl1w4
Message-ID: <CAJuCfpEoPjFttCsZPo158pH95ChoBV6N9SMD6Qs5vi4w-G8y5w@mail.gmail.com>
Subject: Re: [PATCH RFC 03/12] mm: move struct slabobj_ext to mm/slab.h
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
> Users of include/linux/memcontrol.h don't need to see this internal
> structure. Further changes to the struct will reduce recompiling.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/memcontrol.h | 13 -------------
>  mm/slab.h                  | 13 +++++++++++++
>  2 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e1f46a0016fc..93869cc35c25 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1440,19 +1440,6 @@ static inline void mem_cgroup_flush_workqueue(void=
) { }
>  static inline int mem_cgroup_init(void) { return 0; }
>  #endif /* CONFIG_MEMCG */
>
> -/*
> - * Extended information for slab objects stored as an array in page->mem=
cg_data
> - * if MEMCG_DATA_OBJEXTS is set.
> - */
> -struct slabobj_ext {
> -#ifdef CONFIG_MEMCG
> -       struct obj_cgroup *objcg;
> -#endif
> -#ifdef CONFIG_MEM_ALLOC_PROFILING
> -       union codetag_ref ref;
> -#endif
> -} __aligned(8);
> -
>  static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
>  {
>         struct mem_cgroup *memcg;
> diff --git a/mm/slab.h b/mm/slab.h
> index 01535e1e2d3c..7bd361447c54 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -549,6 +549,19 @@ static inline bool need_kmalloc_no_objext(void)
>         return false;
>  }
>
> +/*
> + * Extended information for slab objects stored as an array in page->mem=
cg_data
> + * if MEMCG_DATA_OBJEXTS is set.
> + */
> +struct slabobj_ext {
> +#ifdef CONFIG_MEMCG
> +       struct obj_cgroup *objcg;
> +#endif
> +#ifdef CONFIG_MEM_ALLOC_PROFILING
> +       union codetag_ref ref;
> +#endif
> +} __aligned(8);
> +
>  #ifdef CONFIG_SLAB_OBJ_EXT
>
>  /*
>
> --
> 2.55.0
>
