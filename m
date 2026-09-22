Received: from mail-oo2-f41.google.com (mail-oo2-f41.google.com [74.125.231.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E8D3CB54C
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 04:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790050859; cv=none; b=VbRSLAqD0pxKb2efHPKYLkCYpWAhw5hyuw3pJ7EXs/T04Ifpr8iO9/nGh5X975An8QTJhJYHL302u6T656F8u8t25rDhD/XkNYn2KNEzmHLoBC7vgNBjJInfT2xeLPcdZssa+ahj0RCTAXuG76eWStsbeNvESbJfsU5vXjaYqD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790050859; c=relaxed/simple;
	bh=TZM1KYX85yBCMfB6pkxSOsIHrKLKOo+AjP2+UyNJ9j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=safH6F21b8ocT+SROjMKYteZ8vLjNXMJ0E3MKz2sqRudZ53XVtlE2Gk/ngQxccnoxUTZICXQ5VOzSU7ouxWndOdsykDp2WLG2IzWqeYzqNKpk1HO9KBCxCbx22ma5YdlyioR3gsQ7BgO3DUKarQWjIKs7CFE+B4YBPA5fh7pi9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TaKwNzYQ; arc=none smtp.client-ip=74.125.231.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TaKwNzYQ"
Received: by mail-oo2-f41.google.com with SMTP id 006d021491bc7-6b1ae6b200fso2068919eaf.1
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 21:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790050856; x=1790655656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vw7F89gHzb0bwYi7GFQ9WYKMfHucMYNinHqo/LXrYrc=;
        b=TaKwNzYQC3IV4k5u1R0e6DP13oNkdZC59ofnDcM2oCUXDHaIhYHvlBrnrBifPexisF
         OVSBW2rtCqRzY2/DAomwW5sZzaA3AmkVw3vgMTMoJSPlMaSWfxWArz4jZ6GUXBWdMdUU
         SSv0g8yjGSiz+qzTGsW2XX0ONq9XizjcbGcQWQtIs8WNdQesXyQMVlxiZ8dsjdhihfTE
         qjRDjD0Hvyk744paP7XZrjFwW5aQou5InNmo5T8828oVSPezSpMfF4V3l7gnj995bmKD
         XkW/PTNQp6YlNQErYmaEP9xL1qd5/C4ZJwk41kLAWDGoSUDdA3Mj/k4dwvWZXwLYMwPW
         HnUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790050856; x=1790655656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vw7F89gHzb0bwYi7GFQ9WYKMfHucMYNinHqo/LXrYrc=;
        b=mKxfZ6P4peA5DhE+8Lcf1M0bzzoo1dgW0YS3CCIdilSy0qsbS4gV5qEhK6FEdmS1ep
         P7gebaC2gXOh9ogeOu5tVCekyYerte/hafQlaBabnnsCMa28RO0QC3MsP7MOMOiB7zSw
         fTe9UQ33OKJs3PKXW9gAsAgXSn5N/R1n1iJDzBBBCMJiB7ii2QHmKXbf36HZhG8T8+kg
         afL0khTzfzVH5UTxo+QPpOtlR0bq0ANs94zfjIjAsbvTdnUf7NuLxvYRy7OTf6Z22uFS
         lxAp0vS13SdsU7t2MR0FFWXO2sgyL7MKCJ2h0msSBxsTN1qkjLOGaqNTc7JaCANL997X
         RlCA==
X-Forwarded-Encrypted: i=1; AKwUvByWL4y057jBJceCV+aKkV50x5fXkLtyj4u90wfGQqEmNgzuKSmq53zQsO09OzndLWoh19GB/c57@vger.kernel.org
X-Gm-Message-State: AFuF++lRUEkYEX1u8hyVRFi0/NMKlAMozoztmpTdWrD4GjgfELbNdu5k
	Zge1X8nOHqQe/iJ+mOiFZMgRL6vwInlihAXCQfhqgFO27dY5pG/bap7o
X-Gm-Gg: AYBFou1DU35ZHq8DBnmA5iQNETi8c47KACI3RtAbt612Xagu6i8BqRXcSKDj39c5+kW
	gltVG1DqNfuRu3twYK/FjBEq3PHxq2uLWkCRdDYkPQ2bEHdZPAvsFwDJnorfeGeF5rR/spZmgxf
	wix5k4EQavn+OUesWvVxLHzD8LXZ1R+/rNNvnT+I2tpe1eMuy+tLaFqcIYoPGEg7fQ3ZSAOmIV/
	LXaqLbD5gV+PEmdth0JciYxrrJfa2ETPec59MBtnRK4r1znxJze1tWGd3VdAeMdMUbyd28H6W/S
	KcXusRbcgZ1N6UJ9a9v73wfUCD6y7sGtgqdcqw0vp839+dzNpADqVR3AicPjUoyieAm1/XlRO5V
	6wjx+4Y1aNyCfEnvxMtvxlCu/4079KQFlO+KO3CtDjcRhMKFJZxpFAwgNqKSghfZNlx3Su4vp5r
	cpXn4TqH28qwd5KAZMEa3B0twQ5bT5cwAvOh3puM4jhvuZ8MEIlkxTu3eJsKUAiYdQ7NyqjJuKr
	x1a0mwcdhp319OXcSgUUm1JvUfUmA==
X-Received: by 2002:a05:6820:4b8e:b0:6bd:bf80:9796 with SMTP id 006d021491bc7-6ca9be50072mr13917974eaf.41.1790050856466;
        Mon, 21 Sep 2026 21:20:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-814e394ac61sm881122a34.1.2026.09.21.21.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 21:20:55 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Hongfu Li <hongfu.li@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio
Date: Mon, 21 Sep 2026 21:20:53 -0700
Message-ID: <20260922042054.3264663-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <arIAyyjYcCKHFmyD@localhost.localdomain>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 22 Sep 2026 06:15:07 +0200 "Oscar Salvador (SUSE)" <osalvador@kernel.org> wrote:

> On Mon, Sep 21, 2026 at 05:12:35PM +0800, Hongfu Li wrote:
> > From: Hongfu Li <lihongfu@kylinos.cn>
> > 
> > memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
> > stats. These stats are accounted against folio_nid(): incremented on
> > the folio's node when handed to a user, decremented when the folio is
> > returned to the pool.
> > 
> > During hugetlb folio migration, mem_cgroup_migrate() moves the charge
> > to the new folio and drops the memcg data of the old one, so the free
> > of the old folio right after the migration skips the memcg per-node
> > lruvec decrement. The hugetlb count stays attributed to the old node
> > for the rest of the life of the charge, while the target folio gets no
> > increment on the new node; its later free decrements a counter that
> > was never incremented.
> > 
> > Migrate the per-node lruvec accounting alongside migration. Global
> > memcg totals remain balanced because they track resource consumption,
> > not node placement.
> > 
> > Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> 
> For the fix itself:
> 
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> 
> question below:
> 
> > ---
> >  mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1460cba53588..9c96ebd5436f 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5598,6 +5598,34 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
> >  	rcu_read_unlock();
> >  }
> >  
> > +#ifdef CONFIG_HUGETLB_PAGE
> > +static void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
> > +				     struct folio *old, struct folio *new)
> > +{
> > +	long nr_pages = folio_nr_pages(old);
> > +	struct mem_cgroup *memcg;
> > +	int old_nid = folio_nid(old);
> > +	int new_nid = folio_nid(new);
> > +
> > +	if (old_nid == new_nid)
> > +		return;
> > +
> > +	rcu_read_lock();
> > +	memcg = obj_cgroup_memcg(objcg);
> > +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
> > +			       NR_HUGETLB, -nr_pages);
> > +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
> > +			       NR_HUGETLB, nr_pages);
> > +	rcu_read_unlock();
> 
> Why do we need the whole thing to be embraced by rcu?

Hi Oscar,

I believe it's because now getting the memcg from the objcg requires
an RCU lock to make sure it doesn't get removed while we work on the
memcg. I think this is since Qi Zheng's "Eliminate Dying Memory
Cgroup" series.

Joshua
