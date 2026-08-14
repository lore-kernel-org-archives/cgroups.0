Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B12431813A
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 18:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786730769; cv=pass; b=Xsqo4rHY8qoSIqFKbwMXc848adgQGp/y3X6ggrkJe6Ne0Pidi6ZpFZjHrQqAqLQZtVYsgabKh8tXcR9slTe6zyb/AFPNuabQ4fdCsA4rsxVcbuocJZAflLUD/CQN84TA57FEU7rzCllMmCzJ9JRe20fP/pxGvESIzbJ0/DzYJ2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786730769; c=relaxed/simple;
	bh=zWlTVnRwWJq3y9zL8+CuEA3pufUj+20JSxIcAvgiMH4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LkW+vaoIoPLKN7eG9luvEgcwy4LRENHzhsXMJEE+zKdH5OlgLaRqPmxgZbgi2MEqryYT/6QILZEbkhCUfWENiC/T0F+uOZVCf/nsWOLQRosNRutBuY3xaFBU3C7om8zLjMmxDALChF2AhAR4Wg4R/qDH6YP1E51OfMyjG7ieDSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OrDkB8a9; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OrDkB8a9"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15e2dab83eso211950566b.1
        for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 11:06:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786730766; cv=none;
        d=google.com; s=arc-20260327;
        b=TuUebb0UceGeE6h3lFsUFdsEUC9W4u4VgYOHcR5uDGOnmGic+gurG+t1ZgmF/V6PSc
         l+2cOSC/zyRKgXtIkjbLgPRpyhomu8czMeSql0HjRnXTYO74zmVi2bPqfLGQXmTAwva0
         DWvoAaA0aw2vzK7VmL6R6p4iRvGPXErIvrs2FCMzjTYOYKGDW635tbchwjGHZn1dVjF9
         KJ6LM0yT83eRwBqqTmYS3ocDLMTPlogSyi79LYd9cmXeBc/IgNPD2R1WfHYbEGyPPaNq
         2raN1RuBIjhp+PNrwzVNKtxXIynE/84VxozALNs4OEDklYqotLp3vsoSiA6I+2hJ9Sbd
         eugA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zm4Hmz4cnln8QUqQ6YrVjCpF/yuLG0D7za0RMRiIjkY=;
        fh=cG7zBrKtIC7zEgXdOKZm4pAhwvE7WkmDoVKwToHZzvU=;
        b=Tx/cWiTu4umOddg/CD+kuUVJiTuHegdc/njZzGqn4qFH0hOQekDOeVPagAckrwaQHE
         qhovCcDtYmfxi8WL0cAXEupy62+K1JtCningJRIl/NsMoXXjYHJJoOxbXe1Rbb07iZ5q
         4KzoS7EnZe4kHKYZH6NcRq4guabzJXC6/bSxSriuQY1oPy5FhDIgm2hRuRmeoprk3EP9
         Do4up+tDDWl4moSh88wiTg++EHK291PnXnGRfVEEnIkonW1L7nFOaseMQmcCWuMGwE0D
         bbRi35yRwXCRM5fr2sto86hJKpHoh7vZR+FglAONHUyf5XDnXmWklq0iTMJGzR3aPI8P
         wc1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786730766; x=1787335566; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zm4Hmz4cnln8QUqQ6YrVjCpF/yuLG0D7za0RMRiIjkY=;
        b=OrDkB8a9U8YnH55SakstdNOacJWL9/8wWY3bn9mFZuaOjcnYHZfcT1E39+pgiLn/+a
         BJ2fzayyWtDfyRdwh6n4Cyg2fiPFWcHD3STwHGzg7BMNxilLYyAHQnf5dKSAkfdq0bCw
         qG97yIoU+by3Js9kh4YOhQJ8IvDLsNO7s5LpSUYfCrcDPY8FCRPI39T8gP2rGqwwKqtb
         iHNYXOV+q89bMIOgKDOy1//h5v35FrrwGtK69H7Txag9Bob9Squpo2dWERRSTIKGfcEH
         qaW75EmG+siW0zw3yB7QSyIVlBXSh8NFAOLDjaO4EGPV+DeR63V6WKA2WIAQaqU0JwN5
         r3jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786730766; x=1787335566;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zm4Hmz4cnln8QUqQ6YrVjCpF/yuLG0D7za0RMRiIjkY=;
        b=cnSQihbRdYvbSXx3tpeeIiFB8ZT+A2p8p6ggbl4Jb85xDQ9/ZXcU05+653nqJilFre
         FAzLJBKGqlU2KnZ5fs30//7RPNTU7JHdZGemjBn8bO8hAr7lmmqMykE+l3H/aQn8iFFI
         9fyhX7Jt4CZP+qL6mlrNoBakiL9ZF1esePrcr5OhaBxPe+cUCa/lGZi+zmeO+6Ed4DjS
         UlwIhguP3xC4BOv8GoleCCy7wAhD8cAvOAwD7M4yaykPNYviLcbKWFNqVT8MT5dGO8tv
         KTjoo8eiqxFr3FxMcf4sFgM63ytdt/por2DUUnJkp/U5HWcElXoOj+rx8RzAmGPHJQ6T
         EvzA==
X-Forwarded-Encrypted: i=1; AHgh+RqG9cKHRv3dKb97AEbyFXab3NCCBSyVaBs2tkOIO7RZF7ylKhSSfnFLUtcQp+i0qiR/qLYaR3pl@vger.kernel.org
X-Gm-Message-State: AOJu0YyazYugmpPovEnxTt/WPzPKq1m/ZtPHDGrXyC+5l5re2mlK/+/4
	SJXKgf4Ypne9nk7yED2j725HLxM2VKlGgqLzqXVk6fiGJP4Jrj+zvCRnvfRkN77w13Pr7UDHG71
	AiwBxxFDTkcVLVikUw/6/DHchEwEskeo=
X-Gm-Gg: AR+sD12gMlmMlulQe8RAnkcjKIlh8vdVoAM10gRG6uRR0Cl/XXyM5LFLzXK2aGT5UAa
	jPcAV1Zvv7ocNE9tRH2f2Pi7NrlCvrJBgqqAncwcSXnLpZm7+oLpiR85RZIr3hFfttLZuTTDWci
	wr4miqcPGDAg6/4HKkxpUzzIWVq5viVT4NpYTBD7kN0mnqwWkRfs92CVQ42Zbso24ydUw+iRBtO
	KLaR/6WpJfiWPB+unEbUTWNEG5Y4IxaEV8tpYGZQvEKS75avaaqeMTCnoVIHyIr49DSN7nsQ0Ji
	TqzBryLDlk1DMh1X30r8yh/Aux71giAsdc7pQgXXTn/l6Q0eWQj49U5cmbShTga7sC7gV9nIzFX
	KYg==
X-Received: by 2002:a17:907:c02:b0:c1f:c061:569a with SMTP id
 a640c23a62f3a-c2129b5b0fbmr346098166b.7.1786730765397; Fri, 14 Aug 2026
 11:06:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com> <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
In-Reply-To: <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 15 Aug 2026 02:05:28 +0800
X-Gm-Features: AcwNN1WIkKuwTmt7PEJzah-_70R5p92KJ_QmRackAHM_2sCEQfB9h1jocetz118
Message-ID: <CAMgjq7DupViQ_MbZCMRSb_Bw57C+Lcg2fFnpaJ1xsjftzYHUSA@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 3:19=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Complement MGLRU's eviction-time tier-PID protection with access-time
> > frequency-guided promotion.  Introduce a unified set of helpers built b=
ased
> > on referenced (access) count of a folio.
> >
> > Each access increments a folio's referenced count stored in folio flags
> > (refs), refs still mappes to a logarithmic tier just like before, but w=
ith
> > more formal bit definitions, a few special thresholds are introduced:
> > LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED (3=
),
> > and LRU_REFS_MAX(7). When it reaches certain threshold, the folio is
> > promoted proactively instead of wait for the PID controller to kick in.
> >
> > Also simplify MGLRU's usage of PG_workingset and PG_referenced, now
> > these 2 flags are purely used as the lower 2 bit of refs for MGLRU. Thi=
s
> > doesn't effect classical LRU in any way. This will actually simplify an=
d
> > make MGLRU's certain metric reading more accurate, and reduced MGLRU's
> > original tier / referenced count bit by one since only one extra bit is
> > now needed to record a max referenced count of 7 (previously 2 extra bi=
ts
> > are needed). This changes make sense because MGLRU doesn't have demotio=
n
> > so these 2 flags are never separately useful for MGLRU.
> >
> > This addresses several shortcomings of the old model:
> [...]
>
> > + * Update the folio's lru refs indicator without taking the folio lock=
,
> > + * isolation, or lruvec lock. Used by both page table access (@is_faul=
t=3Dtrue)
> > + * and by file access (@is_fault=3Dfalse).
> > + */
> > +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exe=
c)
> > +{
>
>
> This is really hard to follow, especially with call sites like:
>
> folio_inc_lru_refs(folio, true, false);
> folio_inc_lru_refs(folio, false, false);
>
> The reader needs to remember what the first true and the second
> false represent, which makes the call sites quite opaque.
>
> Could we have something like this instead?
>
> #define LRU_REFS_FAULT BIT(0)
> #define LRU_REFS_EXEC BIT(1)
>
> folio_inc_lru_refs(folio, LRU_REFS_FAULT);
> folio_inc_lru_refs(folio, 0);
> folio_inc_lru_refs(folio, LRU_REFS_EXEC);
> folio_inc_lru_refs(folio, LRU_REFS_EXEC | LRU_REFS_FAULT);

Thanks very much for the review and suggestion!

Good idea, but to distinguish from macros like LRU_REFS_PROTECTED and
LRU_REFS_WORKINGSET, which are special referenced count number, maybe
LRU_REF_EXEC and LRU_REF_FAULT? BTW we have macros like
FOLIOREF_RECLAIM_CLEAN, FOLIOREF_KEEP, and folio_referenced, etc.,
which are commonly used already, that's one main hint behind the name
choice here.
