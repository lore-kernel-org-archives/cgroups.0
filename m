Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE30F5FDA7
	for <cgroups@vger.kernel.org>; Thu, 26 Feb 2026 00:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772065541; cv=none; b=cRsFlnaPL9w7BAo/ZbNeWWbPcnaez9NvEbYfiJjcOJDBsD7f1uUnQ2KADU2p/EE2Tq0ttPHV0J7XqdZcm7OilPYbTu38fEpsHMRs1kBbeM6zhA/1jtCyk1BmPQyzKOsDcHizkR0Q8oHzMv8CLVRdq1aLU3W94CZpdHRXUmvV+MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772065541; c=relaxed/simple;
	bh=K5LKe6svs8tWQQgxlXMn1Wqs6u8cT7mRfbIARL7w+WI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWsEzK/vH4JI4hERNet9M2SiHfbKRzCLp8As85+9lm0maTvZ+Oc4jfhIB+iaDIMRrDZjKHIHosEVXiaulwiiSQuKUmFQ3kqXi5Hdjtt+/ik0GksV1QEOvdDpip8KvSuhScnJRP6WIQLKNm+m7t3V9PoC8aUADb6hpMtRWsYirmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ey+g63E7; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ey+g63E7"
Date: Wed, 25 Feb 2026 16:25:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772065537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yxPqJ6E7xvNtCuOu5zbMYJVgjaGYkAlt6qTcXlH4PpM=;
	b=ey+g63E7MYcvKk29/8ZzUc3pXSq1elfr4bhlsqngJRjogeai6DH6S2T7UWhCrTJSC1+Bdt
	nyff4LdW470iaVY2rFfXfbEfQtnqRAZ/jH/mY6iGY/XJn1ZQO7iPw3GVDrGvpWDUTW+q5y
	4uMIS9FVfmAwC2lXFCseF48lDsZ7Cy4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <aZ-R87JfacQ2gGq1@linux.dev>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 25, 2026 at 06:58:59AM -0800, Yosry Ahmed wrote:
> > @@ -473,6 +493,29 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> >         return x;
> >  }
> >
> > +#ifdef CONFIG_MEMCG_V1
> > +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> > +                                      struct mem_cgroup *parent, int idx)
> > +{
> > +       int i = memcg_stats_index(idx);
> > +       int nid;
> > +
> > +       if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
> > +               return;
> > +
> > +       for_each_node(nid) {
> > +               struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> > +               struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
> > +               struct mem_cgroup_per_node *parent_pn;
> > +               unsigned long value = lruvec_page_state_local(child_lruvec, idx);
> > +
> > +               parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
> > +
> > +               atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
> > +       }
> > +}
> 
> Did you measure the impact of making state_local atomic on the flush
> path? It's a slow path but we've seen pain from it being too slow
> before, because it extends the critical section of the rstat flush
> lock.

Qi, please measure the impact on flushing and if no impact then no need to do
anything as I don't want anymore churn in this series.

> 
> Can we keep this non-atomic and use mod_memcg_lruvec_state() here? It
> will update the stat on the local counter and it will be added to
> state_local in the flush path when needed. We can even force another
> flush in reparent_state_local () after reparenting is completed, if we
> want to avoid leaving a potentially large stat update pending, as it
> can be missed by mem_cgroup_flush_stats_ratelimited().
> 
> Same for reparent_memcg_state_local(), we can probably use mod_memcg_state()?

Yosry, do you mind sending the patch you are thinking about over this series?
