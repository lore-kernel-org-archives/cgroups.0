Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4616727456
	for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 00:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786752814; cv=none; b=C1smNNkohQ0y0sRUfy4tSZwe+sNMzqxxfcMbNTwZKvCAVCCwHw09Yv9Y36iunq//7i5XA3YFYtormgrJaTOKLTFxE/LfSCBZ0vHH+NNq8sE8Om7nWfT3lscHn1lt9ceiBT8KL8ihU6nNfCw3gKxTr+EUhytI4n4bV6pYdB2Vx0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786752814; c=relaxed/simple;
	bh=qOPFiHT/kUIfKCD05kIN5OLuJynG6bi3eMYVoDdLNMU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=shyn5rEThGZ7OSW+k2bBW3TgGVyToIxqbnSEoORP/xSlG1zLENDzmepVzOg7INif8SSPAQ+RgihpzugXiIsiNkh02nSbELymZo47eWW+60/4QvyNE7nMN4+QSMp2Mt5nPDiSyU3qRv3G/IMaUuighCQbwIsFJx8VODA9Du/og6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dqoEwn30; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dqoEwn30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3731F00ADE
	for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 00:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786752813;
	bh=9jvOz7gLQ+ALLm0WYnHzgNDgyhzkJGjXvSYPB3mG6sY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dqoEwn30/vycYL6Go/BWZoiD2lQMZV5Ll52bNyKh7Dz6E+kIMFOyuAw4iXj0dZ4kn
	 Ja7f0rP+V+Uz+Sh9mheOt+EEPqlude967KCF7VFFHeF/7n/jwx5ey7CBZjSUarZrWk
	 rIM/1hMIu8VuN5smQw/mzfSG7+Gwlxs2BpagisY16cfQcEZkkuMYQAvcvzSsen4QQP
	 0tKoYY0hkFfv339ybMfjOFBtcyp+mZlXbwQKLGcTNt06lc0KbYTYKp8a0GKN+K1mSW
	 OHgGXM05qf5lziER+6JL2GlOGs3MwK6MsQmWjt7/Aq7t+yl9nWha+0piwwyA3prRE3
	 BiWMXeEkMSEOQ==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e50a650a0so94894085a.1
        for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 17:13:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoNTim8uGGtRwTFt6dhVRVNM9joSq1vkm1F1iw9MlDYxfhiHcSbBxpjWWOcVbvzLNTaIaGRNtKv@vger.kernel.org
X-Gm-Message-State: AOJu0YxrzFF5TC/Ska3HiWMdlDS27vvP3E+5efaIx+0ovwwRbrOyB8nI
	XYnh0JuugmRAZ+XO4R9iV+u+fEDJbzQIrdN4/JTIdCGt6chhAdHreJbohWNZ0seJSu2EP0T1c8W
	MgsFExa8S4KQ++1NW03mvajH0dpbsfic=
X-Received: by 2002:a05:620a:26ca:b0:936:af34:ea68 with SMTP id
 af79cd13be357-936d2340858mr789756885a.22.1786752811745; Fri, 14 Aug 2026
 17:13:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com> <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
 <CAMgjq7DupViQ_MbZCMRSb_Bw57C+Lcg2fFnpaJ1xsjftzYHUSA@mail.gmail.com>
In-Reply-To: <CAMgjq7DupViQ_MbZCMRSb_Bw57C+Lcg2fFnpaJ1xsjftzYHUSA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 15 Aug 2026 08:13:20 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xhxELewwy=X+K8WurSnLDzaz2kD384gt93Ha=uVpyHDA@mail.gmail.com>
X-Gm-Features: AUfX_mz01S3FRaDWxpmO125End5DGeS2QEpieNwXWJUlW3ZhqthGFxzRQRVC5uM
Message-ID: <CAGsJ_4xhxELewwy=X+K8WurSnLDzaz2kD384gt93Ha=uVpyHDA@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: Kairui Song <ryncsn@gmail.com>
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

On Sat, Aug 15, 2026 at 2:06=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Aug 14, 2026 at 3:19=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Complement MGLRU's eviction-time tier-PID protection with access-time
> > > frequency-guided promotion.  Introduce a unified set of helpers built=
 based
> > > on referenced (access) count of a folio.
> > >
> > > Each access increments a folio's referenced count stored in folio fla=
gs
> > > (refs), refs still mappes to a logarithmic tier just like before, but=
 with
> > > more formal bit definitions, a few special thresholds are introduced:
> > > LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED =
(3),
> > > and LRU_REFS_MAX(7). When it reaches certain threshold, the folio is
> > > promoted proactively instead of wait for the PID controller to kick i=
n.
> > >
> > > Also simplify MGLRU's usage of PG_workingset and PG_referenced, now
> > > these 2 flags are purely used as the lower 2 bit of refs for MGLRU. T=
his
> > > doesn't effect classical LRU in any way. This will actually simplify =
and
> > > make MGLRU's certain metric reading more accurate, and reduced MGLRU'=
s
> > > original tier / referenced count bit by one since only one extra bit =
is
> > > now needed to record a max referenced count of 7 (previously 2 extra =
bits
> > > are needed). This changes make sense because MGLRU doesn't have demot=
ion
> > > so these 2 flags are never separately useful for MGLRU.
> > >
> > > This addresses several shortcomings of the old model:
> > [...]
> >
> > > + * Update the folio's lru refs indicator without taking the folio lo=
ck,
> > > + * isolation, or lruvec lock. Used by both page table access (@is_fa=
ult=3Dtrue)
> > > + * and by file access (@is_fault=3Dfalse).
> > > + */
> > > +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_e=
xec)
> > > +{
> >
> >
> > This is really hard to follow, especially with call sites like:
> >
> > folio_inc_lru_refs(folio, true, false);
> > folio_inc_lru_refs(folio, false, false);
> >
> > The reader needs to remember what the first true and the second
> > false represent, which makes the call sites quite opaque.
> >
> > Could we have something like this instead?
> >
> > #define LRU_REFS_FAULT BIT(0)
> > #define LRU_REFS_EXEC BIT(1)
> >
> > folio_inc_lru_refs(folio, LRU_REFS_FAULT);
> > folio_inc_lru_refs(folio, 0);
> > folio_inc_lru_refs(folio, LRU_REFS_EXEC);
> > folio_inc_lru_refs(folio, LRU_REFS_EXEC | LRU_REFS_FAULT);
>
> Thanks very much for the review and suggestion!
>
> Good idea, but to distinguish from macros like LRU_REFS_PROTECTED and
> LRU_REFS_WORKINGSET, which are special referenced count number, maybe
> LRU_REF_EXEC and LRU_REF_FAULT? BTW we have macros like
> FOLIOREF_RECLAIM_CLEAN, FOLIOREF_KEEP, and folio_referenced, etc.,
> which are commonly used already, that's one main hint behind the name
> choice here.

Yep, LRU_REF_FAULT and LRU_REF_EXEC sound good to me.

BTW, is FAULT really the right term here? It looks like you're
actually using it to indicate the result of PTE scanning.

In the other place, you use "promote" instead:

+static inline int folio_inc_lru_refs(struct folio *folio, bool
promote, bool is_exec)
+{
+       return 0;
+}

So perhaps LRU_REF_MAPPED  would be more appropriate?

Best Regards
Barry
