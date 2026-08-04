Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8573AAF53
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 20:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785877046; cv=none; b=tsLuwZynolAcMxB4qgeISFU8G6WJzuaL9H+pZaYloWOUrdA+FsFD8fb+lf50M1gOjsLx3EXjRO67wia5yihV+s0QjFehskqTwiy5CIGXp2rmnZkG3UPnwS6Iod2Za5GW9QEoXSe8i2hti75wFVLYUHZ+cc98F9D2txfyNlrtRjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785877046; c=relaxed/simple;
	bh=/8OaqdC0+N/xkEa8UDTxRHzlE+LASje9S1qTb9JpWgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h71Gb5rxevobdtL5wtm2PqTOkJSgQHF2LEsB5CGnmyMxvNTcGJ8qwJ6hM/31qIvpQ8kpfE83dKjOXezSHT6664TlbfSI+HT0XJ9UAx7whsa3DV2QZZSCbByZia/4dswZNyRGGsnq2ZEmM/IWyeDincNui33oz5nOmo/uMxMAMAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=B1lZVG4Z; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="B1lZVG4Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:From:Reply-To;
	bh=NRWVZbN3PfkY4R5jatPQIr04idcr7DcBsDOGBqPe2gw=; b=B1lZVG4ZpSK2R2+thY4r3TdSoM
	i6tGZ+bWlPMl1ptPGyXNnQz2J68VXs6MLHB9dms+vHvlux5fGoFQye/nsy1ezYo90w4y2D+aDMJMg
	oNcDZgSb1QHgllRILo/8yA+7ri7pcfyKkm8he33UjubQup0X5WvZAwS2m7q0sWwdEDLZX8nTnwShI
	6/npukegeyNgp7iriLF3AFQFo69DXSQKCsfmA0qv7JcYtRM5/M1CC4PfoS963s+l3Au7yr4Mo+h1D
	4CsBgxsUpyAQuD0MjgCiizMVuwIOhONrM2KBcFEGqwsmSgvU07mmGCrkg/6xMWrzZE2ROub4WWDfs
	rgea0O5A==;
Received: from 179-125-86-101-dinamico.pombonet.net.br ([179.125.86.101] helo=quatroqueijos.cascardo.eti.br)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wrMBr-00E0hx-NC; Tue, 04 Aug 2026 22:56:48 +0200
Date: Tue, 4 Aug 2026 17:56:38 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: Maarten Lankhorst <dev@lankhorst.se>
Cc: Natalie Vock <nat@pixelcluster.dev>, Maxime Ripard <mripard@kernel.org>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Timur =?iso-8859-1?Q?Krist=F3f?= <timur.kristof@gmail.com>,
	cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v8 2/6] cgroup,cgroup/dmem: Add
 (dmem_)cgroup_common_ancestor helper
Message-ID: <anJSBu2zbo8_lG7N@quatroqueijos.cascardo.eti.br>
References: <20260804-dmemcg-aggressive-protect-v8-0-07af96681bf8@gmx.de>
 <20260804-dmemcg-aggressive-protect-v8-2-07af96681bf8@gmx.de>
 <b5b80acd-feea-408b-87eb-4264ffc7e2cd@lankhorst.se>
 <7b2887b1-ecb7-4d6e-ad34-068ab1d7d41e@pixelcluster.dev>
 <bd7c2432-a34b-400a-8351-ca4398b24981@lankhorst.se>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd7c2432-a34b-400a-8351-ca4398b24981@lankhorst.se>

On Tue, Aug 04, 2026 at 10:41:25PM +0200, Maarten Lankhorst wrote:
> Hey,
> 
> On 8/4/26 22:26, Natalie Vock wrote:
> > On 8/4/26 22:18, Maarten Lankhorst wrote:
> >>
> >>
> >> On 8/4/26 10:25, Natalie Vock wrote:
> >>> This helps to find a common subtree of two resources, which is important
> >>> when determining whether it's helpful to evict one resource in favor of
> >>> another.
> >>>
> >>> To facilitate this, add a common helper to find the ancestor of two
> >>> cgroups using each cgroup's ancestor array.
> >>>
> >>> Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
> >>> ---
> >>>   include/linux/cgroup.h      | 21 +++++++++++++++++++++
> >>>   include/linux/cgroup_dmem.h |  9 +++++++++
> >>>   kernel/cgroup/dmem.c        | 41 +++++++++++++++++++++++++++++++++++++++++
> >>>   3 files changed, 71 insertions(+)
> >>>
> >>> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> >>> index f2aa46a4f871e..83a17ded1c516 100644
> >>> --- a/include/linux/cgroup.h
> >>> +++ b/include/linux/cgroup.h
> >>> @@ -623,6 +623,27 @@ static inline struct cgroup *cgroup_ancestor(struct cgroup *cgrp,
> >>>       return cgrp->ancestors[ancestor_level];
> >>>   }
> >>>   +/**
> >>> + * cgroup_common_ancestor - find common ancestor of two cgroups
> >>> + * @a: first cgroup to find common ancestor of
> >>> + * @b: second cgroup to find common ancestor of
> >>> + *
> >>> + * Find the first cgroup that is an ancestor of both @a and @b, if it exists
> >>> + * and return a pointer to it. If such a cgroup doesn't exist, return NULL.
> >>> + *
> >>> + * This function is safe to call as long as both @a and @b are accessible.
> >>> + */
> >>> +static inline struct cgroup *cgroup_common_ancestor(struct cgroup *a,
> >>> +                            struct cgroup *b)
> >>> +{
> >>> +    int level;
> >>> +
> >>> +    for (level = min(a->level, b->level); level >= 0; level--)
> >>> +        if (a->ancestors[level] == b->ancestors[level])
> >>> +            return a->ancestors[level];
> >>> +    return NULL;
> >>> +}
> >>> +
> >>>   /**
> >>>    * task_under_cgroup_hierarchy - test task's membership of cgroup ancestry
> >>>    * @task: the task to be tested
> >>> diff --git a/include/linux/cgroup_dmem.h b/include/linux/cgroup_dmem.h
> >>> index 1a88cd0c9eb00..9d72457c4cb9d 100644
> >>> --- a/include/linux/cgroup_dmem.h
> >>> +++ b/include/linux/cgroup_dmem.h
> >>> @@ -28,6 +28,8 @@ bool dmem_cgroup_below_min(struct dmem_cgroup_pool_state *root,
> >>>                  struct dmem_cgroup_pool_state *test);
> >>>   bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
> >>>                  struct dmem_cgroup_pool_state *test);
> >>> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
> >>> +                                   struct dmem_cgroup_pool_state *b);
> >>>     void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool);
> >>>   #else
> >>> @@ -75,6 +77,13 @@ static inline bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
> >>>       return false;
> >>>   }
> >>>   +static inline
> >>> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
> >>> +                                   struct dmem_cgroup_pool_state *b)
> >>> +{
> >>> +    return NULL;
> >>> +}
> >>> +
> >>>   static inline void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool)
> >>>   { }
> >>>   diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
> >>> index 9df3b33c65046..a587611ca2235 100644
> >>> --- a/kernel/cgroup/dmem.c
> >>> +++ b/kernel/cgroup/dmem.c
> >>> @@ -762,6 +762,47 @@ bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
> >>>   }
> >>>   EXPORT_SYMBOL_GPL(dmem_cgroup_below_low);
> >>>   +/**
> >>> + * dmem_cgroup_get_common_ancestor(): Find the first common ancestor of two pools.
> >>> + * @a: First pool to find the common ancestor of.
> >>> + * @b: First pool to find the common ancestor of.
> >>> + *
> >>> + * Return: The first pool that is a parent of both @a and @b, or NULL if either @a or @b are NULL,
> >>> + * or if such a pool does not exist. A reference to the returned pool is grabbed and must be
> >>> + * released by the caller when it is done using the pool.
> >>> + */
> >>> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
> >>> +                                   struct dmem_cgroup_pool_state *b)
> >>> +{
> >>> +    struct cgroup *ancestor_cgroup;
> >>> +    struct cgroup_subsys_state *ancestor_css;
> >>> +    struct dmemcg_state *ancestor_dmemcs = NULL;
> >>> +    struct dmem_cgroup_pool_state *pool = NULL;
> >>> +
> >>> +    if (!a || !b)
> >>> +        return NULL;
> >>> +
> >>> +    ancestor_cgroup = cgroup_common_ancestor(a->cs->css.cgroup, b->cs->css.cgroup);
> >>> +    if (!ancestor_cgroup)
> >>> +        return NULL;
> >>> +
> >>> +    rcu_read_lock();
> >>> +    ancestor_css = cgroup_e_css(ancestor_cgroup, &dmem_cgrp_subsys);
> >>> +    if (css_tryget(ancestor_css))
> >>> +        ancestor_dmemcs = css_to_dmemcs(ancestor_css);
> >>> +    rcu_read_unlock();
> >>> +
> >>> +    if (ancestor_dmemcs) {
> >>> +        pool = get_cg_pool_unlocked(css_to_dmemcs(ancestor_css),
> >>> +                        a->region);
> >>> +        if (IS_ERR(pool))
> >>> +            pool = NULL;
> >> This should probably be a warn_on as this can never happen, sashiko is wrong here.
> >>
> >> If a and b are charged, all their ancestors are charged too. And when they share a
> >> common ancestor, then the common ancestor has to have an existing charged pool as
> >> well because there's a huge bug in the code otherwise.
> >>
> >>> +        css_put(ancestor_css);
> >>> +    }
> >>> +    return pool;
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(dmem_cgroup_get_common_ancestor);
> >>> +
> >>>   static int dmem_cgroup_region_capacity_show(struct seq_file *sf, void *v)
> >>>   {
> >>>       struct dmem_cgroup_region *region;
> >>>
> >>
> >> Otherwise looks good, so feel free to extend my r-b to this patch too, and with that minor fix up commit it.
> > 
> > Thanks a lot! Correct me if I'm wrong here as it's been a while, but I think sashiko's current comment about the css_put(ancestor_css) being wrong seems to have merit too? Since dmem_cgroup_pool_state_put() also puts a css reference but get_cg_pool_unlocked does not get another reference to the css on its own? (Kind of a footgun if you ask me, but not something for this series)
> > 
> > Mind if I also drop the css_put() line while I'm at it and *then* (finally :D) commit?
> I'd keep the css_put for the failure case then.
> 
> Since the get_cg_pool_unlocked() is a local function, it's less of an issue that it doesn't
> obtain a reference itself, as all callers outside dmemcg.c never notice.
> 
> Maybe do a final round of testing too, in case it introduces new failures. :-)
> 
> Especially device unload/reload might show double puts. But otherwise looks good to me.
> 
> Kind regards,
> ~Maarten

I wrote the fixup at [1] that included that css_put. I will look into the
possibility of get_cg_pool_unlocked returning NULL or error. But I find
that unconditionally calling css_put here is wrong. If pool is NULL, it
needs to be called, because otherwise the css_tryget will be unbalanced.

The reason not to call it unconditionally is that it will be called when
dmem_cgroup_pool_state_put is caled, hence, balancing the css_tryget.

I also need to consider whether doing it outside the RCU section is fine.

I just looked here and one of the possibilities for pool to be NULL is that
the region is unregistered in a race condition. region->unregistered is
protected by dmemcg_lock, but that is taken by get_cg_pool_unlocked, so it
seems possible.

By the way, while testing the whole series, I see many different issues
here that I am still looking at as they may be otherwise hidden
pre-existing bugs.

Regards.
Cascardo.

[1] https://lore.kernel.org/cgroups/ahW8MY4XBox_nsmB@quatroqueijos.cascardo.eti.br/
