Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="znOmtLPs"
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C679683
	for <cgroups@vger.kernel.org>; Wed, 13 Dec 2023 07:09:32 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-551ee7d5214so2068939a12.0
        for <cgroups@vger.kernel.org>; Wed, 13 Dec 2023 07:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702480171; x=1703084971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LK3vjqOp8cH1cTBvK+w7wJkNBATd6DJiwq75K2sbxxc=;
        b=znOmtLPsjGDax+9whpRzjxNUp7TXhHM5DUiUxLoT2H/jsCekc/ebQolglfGlviS6NM
         vw3WcXikfklFoNbUusRItrpRxCnZzbfY79jWv7V6Of+GAjSJvvB9oFj0VKxs7S66veSA
         V5mOhS/uWwzajelaAY/cdZha5q+sqXsWgEs+zFT5ai12MwSD2/FYfhMIcsIQaZkdBHIe
         uek7wAkMjdHuQBxTD3CH5e7n5OhVJRljYe5k2eo+i0lGMyJUZjbioYAEzttqymEOabgw
         Xih3oAu39vIvIjv+Mvdt/SVEeteUqTZTF5sz9Keumzre4/gJzJJJ8mTPPg0KMaeIeHk7
         fi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702480171; x=1703084971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LK3vjqOp8cH1cTBvK+w7wJkNBATd6DJiwq75K2sbxxc=;
        b=JfL+8Oe7YIsyCfHG+Y/G2AoIiNpqbwQIQ6hMb/OU7oPMrb+nLufTKTNXgwYqiUeMET
         5ztq8eRkS6TQbNuux07srPF5OxV/hzF5ezf4sY0hJldSePPLUh6MnrDTMguda8Mob3jS
         oyRSZfAuenRc256V7DOoyqFVR1wt4MSEvr+/8rz61ppHO4q8MAgLUFJPptSeT7a/CC9Q
         JrdkULy+8ENHTdz5FLiYBOYPiHNL6FmTAoD5YCTUnnHfCsBKiocaaJBJcHV4YkOcR776
         QL7ltE+CbX/phUOLAc5zdHsrT00bZ/YqHLW2BZ6hoJxF4lhz7IeqS2P4AsN5+l6EiOC1
         RVJg==
X-Gm-Message-State: AOJu0YxKSrVmXSdC3am49+e6/aXNUL0umcZJjD5I0R5xQ1omdhSZLkDH
	fwT3Y0NJFAsJ0Cly3q0J/WkZBQED/aVTVSmB0wXmxg==
X-Google-Smtp-Source: AGHT+IHTzs71PhOa9uLWN2GzFVclITVZN+wQ/OQ8AStazrt0s3s/+fvBHO0hManjbRp35Zbwr49yR0JuZFFn9ru3lG0=
X-Received: by 2002:a17:906:cb10:b0:a1c:5592:aa45 with SMTP id
 lk16-20020a170906cb1000b00a1c5592aa45mr7160722ejb.69.1702480171094; Wed, 13
 Dec 2023 07:09:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231213130414.353244-1-yosryahmed@google.com> <ZXnHSPuaVW913iVZ@casper.infradead.org>
In-Reply-To: <ZXnHSPuaVW913iVZ@casper.infradead.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Wed, 13 Dec 2023 07:08:52 -0800
Message-ID: <CAJD7tkbuyyGNjhLcZfzBYBX+BSUCvBbMpUPyzgHcRPTM4jL9Gg@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: remove direct use of __memcg_kmem_uncharge_page
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 7:01=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Dec 13, 2023 at 01:04:14PM +0000, Yosry Ahmed wrote:
> > memcg_kmem_uncharge_page() is an inline wrapper around
> > __memcg_kmem_uncharge_page() that checks memcg_kmem_online() before
> > making the function call. Internally, __memcg_kmem_uncharge_page() has =
a
> > folio_memcg_kmem() check.
> >
> > The only direct user of __memcg_kmem_uncharge_page(),
> > free_pages_prepare(), checks PageMemcgKmem() before calling it to avoid
> > the function call if possible. Move the folio_memcg_kmem() check from
> > __memcg_kmem_uncharge_page() to memcg_kmem_uncharge_page() as
> > PageMemcgKmem() -- which does the same thing under the hood. Now
> > free_pages_prepare() can also use memcg_kmem_uncharge_page().
>
> I think you've just pessimised all the other places which call
> memcg_kmem_uncharge_page().  It's a matter of probabilities.  In
> free_pages_prepare(), most of the pages being freed are not accounted
> to memcg.  Whereas in fork() we are absolutely certain that the pages
> were accounted because we accounted them.

The check was already there for other callers, but it was inside
__memcg_kmem_uncharge_page(). IIUC, the only change for other callers
is an extra call to compound_head(), and they are not hot paths AFAICT
so it shouldn't be noticeable.

Am I missing something? Perhaps your point is about how branch
prediction works across function call boundaries? or is this not about
performance at all?

>
> I think this is a bad change.
