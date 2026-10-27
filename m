Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793094061;
	b=CWiKI4d0e32ZlpVLh054rEYpOuO71UpcGNiV96pRLC53K0t9k/C8G7s/xlC0pQCrKu0I
	 UvCEtlHxTock5TbPHOPuaR9ZXCkaF4fCgs7No4Q/3Xp2MFTOy6lOAy2DKoRC8trqe/6eB
	 5QDcZRUcu7uHRzIe+IiE9HQ9XGrQdo338LPdbY9WHfibWn2qxp/Un/18mfrweEvZBMGgU
	 49EBENSlpX4qEXIy7c3yMybZmSxcq+bTnaNyXT15CkuQiLmpsPIezW1tH39L/Oxa4aI7G
	 WGU3DEkAmKveQXjSudBQlDoXIaMQPFUQyFU8sS0ha7T4fXaq1IlHcIe3XkyXmCnOiag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793094061;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=JVBSyNaPKEtFoMBnmXCIBXxl7RDB3mGMHMJZz01NkVk=;
	b=HRtKVrETbvDM1I1UawfxMBWE31IHwlMBHNAMQij2hTjh+y575DbHoNI1xc4u3Erpzv2V
	 Fgl1JnUVD1dbZ6bZ/jV5FyKvXuepJ0HQxIole1jg91s7bjlbYCgQMrGe6rsldYcDA7drl
	 oFnuzefzB6qKt68bKgSMO6vS2iedti5C7wEN6zc+gEMvxeFmnO2hABm2lJnziPRb+bDy9
	 gV1Gf8jFas09XpMdH13fe8SwOhny/8Lb7NZ2F8WzA/KQiuPepala/pSB4/rWpPE2ErZot
	 S6qyT5182d+5S4qEQ1ySbQINE5ydzw/mC+Gxk1qbTjiQCHv4jeUeiSjxgbUN3wZUSdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Cb3HmVQU;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A313B606A322
	for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 09:41:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A313B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Cb3HmVQU
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so3322265f8f.1
        for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 02:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793094059; x=1793698859; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JVBSyNaPKEtFoMBnmXCIBXxl7RDB3mGMHMJZz01NkVk=;
        b=Cb3HmVQUB4Lk3lJ79uCjsoT4M/qng2XCwVuFJd72c76fT2RpGya+bs94EVQS3lXDmZ
         Cg6Q/94Kp3EhZ+A4j0FZjWN7jGX4D6jypPFwwK0yPUImFmFPBTlpaSeUh2a7bEC1QbUd
         tr+NkkzXvQt6SV1iynM+/8ppGaWS+slHAvSfG53l13e7LLNjulAMqbtEqwtpFqVnOnGW
         JmTaemFR5SrKvLjFC7wFZ54Pxa5aI0vOlssM2QPIltl6RZXoedLpf7CdZLldhKIIu4MS
         bWbXpjrLCpBEtF3JY+6vwFTkIORr9u73Mx3nz3PLfGM63BCnn7/LqxxYIXWVl9C0nZgn
         Klpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793094059; x=1793698859;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JVBSyNaPKEtFoMBnmXCIBXxl7RDB3mGMHMJZz01NkVk=;
        b=nAURNoiQSsFIWItbvHYfaQewBxl3znm/rNXqREoyt/CcjPqgi5sHx8WEq/52l8qdBv
         nt4QNX4YryIhNw5xyXjWCf5GHtqVPC7ZyMVfoyyjDQ+1LY01jBM2uIgkD+ScE/ryIUho
         nCPbH33er9L2ffseiNkzOaveEd+V4og3CCxP6jPE4yzI9RpORhWgWAGxdW/CG9ruH07X
         EVABBNualP9/HHr6QO5pegdUz46asvw+VwWKg45qrk7RQJwsTv6m7LKbI/IDv29vedcp
         XK7YkZIh7BkGMx1OdqOt3f4eC9nAynlVwbZ70EAjonHcmt+sDhwObwGx2wqHyN+i4bU+
         iEDA==
X-Forwarded-Encrypted: i=1; AKwUvBw/O71xKS1tCQGi9cZnHDUo/a5cRjHtUC1xra8F0BlwMdWAehHly1U7x7OYnnYWCF0xSF/seC/b@vger.kernel.org
X-Gm-Message-State: AFq9FYLizoTeokrm7hHspLWJKAVlWA7Q5uB1RTOBq+SNRBPOnMyjwk6d
	oRalrgsJFNietRUYJ9DZzZqA6/M0Pu+WCr4IvCxfgzg3GiFV+GJuncz4A91GSiPdRes=
X-Gm-Gg: AYBFou1Kj9HcvC23V2sxNVvhsEKKbWtHlsFs47xyZ9W9EXq1xOcPfGrHa3Bipe4MIhD
	TQPMnHnbPetObvY+6AkzTGSQjIbAIlizT/9Igvjjo0yLaQoEvPya4MjVPEGFc01vPeoR3StLzeT
	0dx6RppNfd4g9rpZGyiudz78AsRRgEaNN2coTyxKfScguEONg6o6i93b+FcJM/Se5BgINUDgQoB
	JPQIL46PJ1X0PChL3FoCQFc6d09Hyf1eFLQpwYshhYc4I9SM5Kybxb8xIj/WNkEO7m/siTI6MIB
	sAWEkx/+Tp5nvBQ+rpCQ1tzYCFtPRs/uiYNng+iuQzO5r/jceVALRyw92EcwA1lCPefv36LxT2K
	yiwmyy/FDnQA8QsP9gNKGkNR5TG5Vay5nRpo/nAcVfJ4PTqfAcM/I2CJXYyejAjeQX+UNrg4RFr
	DrqgwMv4mUEIiZ6W3NukjJZ4Fzb4Px67teYMcePjLucb+SWlAzmLnsIdIAHBtFCcBP/2FvLQb8C
	difKR5VLI2kTyZ4kJz6lTVf4/cp0PpGoAVuChNEFGZN7qde9HbrVX7RaxOmc4w6DmlwTw==
X-Received: by 2002:a05:6000:2989:10b0:48d:fbdd:4132 with SMTP id ffacd0b85a97d-48e3eb78141mr13538157f8f.18.1793094058994;
        Tue, 27 Oct 2026 02:40:58 -0700 (PDT)
Received: from localhost (109-81-20-177.rct.o2.cz. [109.81.20.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd4bc5sm21909641f8f.34.2026.10.27.02.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 02:40:58 -0700 (PDT)
Date: Tue, 27 Oct 2026 10:40:57 +0100
From: Michal Hocko <mhocko@suse.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	akpm@linux-foundation.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
Message-ID: <auBxqU34FQYauoQr@tiehlicka>
References: <20261023222313.3979455-1-tjmercier@google.com>
 <at9U2HvyUP-iYOCt@tiehlicka>
 <CABdmKX1mLKEJNiecW+meJ=LB_Kb8-ieeWdZDd4T6rNR9gKuq_A@mail.gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABdmKX1mLKEJNiecW+meJ=LB_Kb8-ieeWdZDd4T6rNR9gKuq_A@mail.gmail.com>

On Mon 26-10-26 11:01:51, T.J. Mercier wrote:
> On Mon, Oct 26, 2026 at 6:25 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Fri 23-10-26 15:23:13, T.J. Mercier wrote:
> > [...]
> > > ---
> > >  mm/memcontrol.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index a05d9a8baa1b..84f4a8fd4d16 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2457,7 +2457,10 @@ static void high_work_func(struct work_struct *work)
> > >       struct mem_cgroup *memcg;
> > >
> > >       memcg = container_of(work, struct mem_cgroup, high_work);
> > > +     if (!css_tryget_online(&memcg->css))
> > > +             return;
> > >       reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
> > > +     css_put(&memcg->css);
> > >  }
> >
> > OK.
> >
> > >  static void high_irq_work_func(struct irq_work *work)
> > > @@ -4463,6 +4466,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
> > >
> > >       page_counter_set_min(&memcg->memory, 0);
> > >       page_counter_set_low(&memcg->memory, 0);
> > > +     page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
> > > +     page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
> > >
> > >       zswap_memcg_offline_cleanup(memcg);
> >
> > Should we simply disable_work_sync when the memcg is going to be
> > released instead (mem_cgroup_css_released)? That should both prevent
> > the run reclaim_high during the memcg shut down and and also avoid
> > plaing with limits to work around.
> 
> Hi Michal,
> 
> Unfortunately that won't work for shrink_many() ->
> !mem_cgroup_tryget() -> lru_gen_release_memcg() which can occur before
> mem_cgroup_css_released() runs. (mem_cgroup_css_released() happens
> through the cgroup_release_wq.)

I do not follow. Could you explain why please?

> The high limit reset is also needed for targeting live ancestors above
> the offlined child in try_charge_memcg(). Without the resets,
> high_work is never attempted on them since it gets dropped when
> attempted on the offlined child due to the first hunk, and
> try_charge_memcg() breaks out of the loop.

I must be missing something really obvious here because I really do not
follow you here too. So we are offlining a memcg. We need to coordinate
memory reclaim with the memcg tear down, right? For the high reclaim we
can achieve this synchronization through disable_work_sync in
mem_cgroup_css_offline. For a synchronous high memory reclaim we do not
have such means but we are keeping a memcg reference which makes the
lifetime well defined. If you reset counter you might help to bail out
early(ier) but that shouldn't be necessary from a correctness POV as it
doesn't provide any explicit synchronization.

> Shakeel's remote charging patch
> (https://lore.kernel.org/all/20261010210957.1350874-4-shakeel.butt@linux.dev/)
> sends remote charges through high_work too, so without the resets
> those would lose ancestor reclaim the same way. Before that patch not
> performing the resets means reclaim_high() runs unnecesarily against
> current's memcg (not the remote memcg above memory.high).

-- 
Michal Hocko
SUSE Labs
