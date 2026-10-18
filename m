Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C16949A3B2
	for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792334125; cv=none; b=MWONbKyCkHwhvL7M2aN+xb7PZdY3XEvNAT2AiTCcTTL+qGWjYhPwVFEu5hqiyjIr3AWnJxurF3M6Rh4jT+Gd9tyg2LmpvSLx62z3L1JF+JdpWDxDfVCkfz0PBZnufOHnV1qMCYXHpvIKC03GAuwCrMZSpehH5lfwDP2TGwmarf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792334125; c=relaxed/simple;
	bh=eO/WpemlM+38Ff3MAOTaRXXs7vCFrZAkH1w0zKId17o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNdWGCqsmBbuV7yPEjWLUzq2e1vdwRKxPjKWAHFdIeR67YN88eApa+n9W8lSCFEul8KAf9pYBbTi3C2z0Of8eTYwTHkI0Fr2q2f/sSpMWG6ylqT5NLIY61mg7wTghaPI4D7VtHjMqKhecoHGcOpW5Cfsgy4OzoswPob72QjY7Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=aSWciVD4; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="aSWciVD4"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5eaa1b5b84aso1822699e0c.0
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 07:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792334122; x=1792938922; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=briTVmjslxeUx0FiA5Z2sKc9bXZYk9yUUpEJ168UtpQ=;
        b=aSWciVD4IV1q+u8Q3JHXyxEIQBwuvcBnjcZO+f/tCQcq6MvWVWVkYhNGa7xaa8eOXM
         c5FHTgzAarXx+tmW6rxcpjNvpn63B8ZXq0WDD2HPLB1YHOlTvq0QCZ+tpm1rnSpY/TB8
         fo+UT0ittGvD3X5GjSAh+6blce9s/s6KXI1xW6rebtERI7q4ymwj1Z2CgHZL+piBb9tq
         C//btUX2M5Tj62Svbnq0sUNzyRqSSL8J9wcd3GZq/Mmt1rRDjHDF6V1+ip6hYMyLoKfK
         DZr5CKQutHZ6x9BIyEo9DlfqbHqCcOCt2BT+PkII97QnzL3LcbLEb6rb65iKcQGs+E1M
         nNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792334122; x=1792938922;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=briTVmjslxeUx0FiA5Z2sKc9bXZYk9yUUpEJ168UtpQ=;
        b=CmZdRIzrpoT6iE54Q3OOXSsBfK6g67ZKWClU5hGBL1+atHREauDlsPHx53aK7/iVFP
         TzbYRKdNLLyUe4cQW0xGC66FB1lGzxs5Wp6zWjNe5oG//ZpreF8lPzOeCThs3IezWmim
         yvlMRj/eL5y8h9Mxj07UybsFPUByIfHvdmBe1t+XqcO2dmf6XyZhXskFF2KXq9NjaBsO
         Koqzky1p5QbxqW0Itm445a+ywzxiaX0cnxJ+9+qk7bbZW+cF6fLWZL4wuNEJZco6fRht
         DTHK0u09Ah9zvYAIfW3yZ5yfWJiAJ0WoWYlgVPkJWeLQhC/QTVecIwTSkVJK91W3vRBT
         7Y5Q==
X-Forwarded-Encrypted: i=1; AKwUvBytghYzCKlVL21NXoPLfO2CmFDencDinF1CgbYHdvMdLy4nxjtK3qrrlGi9wSKWzqByo+QpVi77@vger.kernel.org
X-Gm-Message-State: AFq9FYL5lMx0AC1hYe+Qvan7YZ4QBhkRPOtXfUux8yHt6grVCGmgYMUW
	uUIz5aGEKp/hL4Twi03kilF9BI3GtG+8V8R2QEeHzOnXNrdSXZbXlrxSba301sXWeh8=
X-Gm-Gg: AYBFou3AKtyAoTzfbTQSXBzMMZU1bJXmZef8Ihp8tKviEaAug6YlsW+zOMon8ZNg2mq
	lqKFi2Kht8szbdTLJ7nik51Z9fSmAAjDPikueI8XLCO1/dGrbvWENrkQxvuJu7gQ4u5pLoyk6rx
	8zrGQgpmxRPirSzf3DKPzIBAa8ztGQYYRgojQ/jeO2fPGY43e4S/5d1Hjzw349iAEGYxaAqAEgy
	Lqx/dkHzLG43sf8WvYwXLZY0LRE4DaedUIty7rn7Q1DvMLQeYoqELN6HcDYYvINCYzXMjcHbF3U
	n5eSrolZZO6jaCsoprA5EajSn0Mq2UbX3+EOFPWvOoOuq/UK17oq/XUbhrtxeKRRdkLcNv4Pvaz
	7EyuOpptQMFQ/jUoDM5QKANpwSljY6+aeZiGaHGDV/u0RoYnIkrhXqXtrYVfoWe7nxT6l4+Z2Tx
	TSqzlazOT8WcPjpT1fVJqcczi6cnzLbTaMKEup1TRDTbhqRtfW5EkSmupi8k2Y2ZUsMIQYAGGFm
	aAreo084DnFe4Z4q1ZcOIRP89eKG8bEhJzoi/bkRbmFec+WEG4D/pMdraOCaQMXuytibtGUjNc=
X-Received: by 2002:ac5:c64e:0:b0:5ea:ca0a:374d with SMTP id 71dfb90a1353d-5eaca0a3bd0mr42477e0c.17.1792334122018;
        Sun, 18 Oct 2026 07:35:22 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eac20d6aa6sm1663781e0c.7.2026.10.18.07.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 07:35:20 -0700 (PDT)
Date: Sun, 18 Oct 2026 10:35:19 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kees@kernel.org,
	rppt@kernel.org, juri.lelli@redhat.com, nik.borisov@suse.com,
	tglx@kernel.org, vschneid@redhat.com, vincent.guittot@linaro.org,
	bp@alien8.de, thorsten.blum@linux.dev, cgroups@vger.kernel.org,
	tony.luck@intel.com, david@kernel.org, mingo@redhat.com,
	akpm@linux-foundation.org, linux-mm@kvack.org, seanjc@google.com,
	ljs@kernel.org, zhangguopeng@kylinos.cn, dietmar.eggemann@arm.com,
	mhocko@suse.com, vinicius.gomes@intel.com, tj@kernel.org,
	vbabka@kernel.org, linux-kernel@vger.kernel.org,
	peterz@infradead.org, surenb@google.com, hpa@zytor.com,
	x86@kernel.org, dmatlack@google.com, tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org, pratyush@kernel.org,
	dave.hansen@linux.intel.com, rostedt@goodmis.org,
	gmonaco@redhat.com, jgross@suse.com, mgorman@suse.de,
	graf@amazon.com, linux-edac@vger.kernel.org, liam@infradead.org,
	ridong.chen@linux.dev, longman@redhat.com, bsegall@google.com
Subject: Re: [PATCH v1 5/8] sched/topology: Avoid redundant O(N^3) group
 capacity walks and unused allocations in build_sched_domains()
Message-ID: <atTZJ6Q3vTjvDjgG@google.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
 <20261015153331.1872641-6-pasha.tatashin@soleen.com>
 <b618f528-ba35-4fb3-881b-e0ca12bc9558@amd.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b618f528-ba35-4fb3-881b-e0ca12bc9558@amd.com>

On 10-16 11:53, K Prateek Nayak wrote:
> Hello Pasha,
> 
> On 10/15/2026 9:03 PM, Pasha Tatashin wrote:
> > diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> > index 0248227d983a7..02c38089a80c9 100644
> > --- a/kernel/sched/topology.c
> > +++ b/kernel/sched/topology.c
> > @@ -1259,32 +1259,49 @@ build_group_from_child_sched_domain(struct sched_domain *sd, int cpu)
> >         return sg;
> >  }
> > 
> > -static void init_overlap_sched_group(struct sched_domain *sd,
> > -                                    struct sched_group *sg)
> > +static int init_overlap_sched_group(struct sched_domain *sd,
> > +                                   struct sched_group *sg)
> >  {
> >         struct cpumask *mask = sched_domains_tmpmask2;
> >         struct sd_data *sdd = sd->private;
> > -       struct cpumask *sg_span;
> > -       int cpu;
> > +       struct cpumask *sg_span = sched_group_span(sg);
> > +       struct sched_group_capacity *sgc;
> > +       int cpu = cpumask_first(sg_span);
> > +       struct sched_domain *first_sd = *per_cpu_ptr(sdd->sd, cpu);
> > +
> > +       sgc = *per_cpu_ptr(sdd->sgc, cpu);
> > +       if (sgc && atomic_read(&sgc->ref) > 0 &&
> > +           first_sd && first_sd->child &&
> > +           cpumask_equal(sg_span, sched_domain_span(first_sd->child))) {
> > +               atomic_inc(&sgc->ref);
> > +               sg->sgc = sgc;
> > +               return 0;
> > +       }
> 
> 
> This insanely specific check perhaps can be something like:
> 
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 06cc9f6397bd..a7d7a3b51c71 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -1203,6 +1203,33 @@ int group_balance_cpu(struct sched_group *sg)
>   */
>  
>  
> +/* Find the group_balance_cpu() */
> +static int find_group_balance_cpu(struct sched_domain *sd, struct sched_group *sg)
> +{
> +	const struct cpumask *sg_span = sched_group_span(sg);
> +	struct sd_data *sdd = sd->private;
> +	struct sched_domain *sibling;
> +	int i;
> +
> +	for_each_cpu(i, sg_span) {
> +		sibling = *per_cpu_ptr(sdd->sd, i);
> +
> +		/*
> +		 * Can happen in the asymmetric case, where these siblings are
> +		 * unused. The mask will not be empty because those CPUs that
> +		 * do have the top domain _should_ span the domain.
> +		 */
> +		if (!sibling->child)
> +			continue;
> +
> +		/* If we would not end up here, we can't continue from here */
> +		if (cpumask_equal(sg_span, sched_domain_span(sibling->child)))
> +			return i;
> +	}
> +
> +	return nr_cpu_ids;
> +}
> +
>  /*
>   * Build the balance mask; it contains only those CPUs that can arrive at this
>   * group and should be considered to continue balancing.
> @@ -1212,17 +1239,19 @@ int group_balance_cpu(struct sched_group *sg)
>   * can fully construct this using the sched_domain bits (which are already
>   * complete).
>   */
> -static void
> -build_balance_mask(struct sched_domain *sd, struct sched_group *sg, struct cpumask *mask)
> +static void build_balance_mask(int group_balance_cpu,
> +			       struct sched_domain *sd,
> +			       struct sched_group *sg,
> +			       struct cpumask *mask)
>  {
>  	const struct cpumask *sg_span = sched_group_span(sg);
>  	struct sd_data *sdd = sd->private;
>  	struct sched_domain *sibling;
> -	int i;
> +	int i = group_balance_cpu;
>  
>  	cpumask_clear(mask);
>  
> -	for_each_cpu(i, sg_span) {
> +	for_each_cpu_from(i, sg_span) {
>  		sibling = *per_cpu_ptr(sdd->sd, i);
>  
>  		/*
> @@ -1281,7 +1310,17 @@ static int init_overlap_sched_group(struct sched_domain *sd,
>  	struct cpumask *sg_span;
>  	int cpu;
>  
> -	build_balance_mask(sd, sg, mask);
> +	cpu = find_group_balance_cpu(sd, sg);
> +	if (WARN_ON_ONCE(cpu >= nr_cpu_ids))
> +		return -ENOENT;
> +
> +	sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
> +	if (sg->sgc && atomic_read(&sg->sgc->ref)) {
> +		atomic_inc(&sg->sgc->ref);
> +		return 0;
> +	}
> +
> +	build_balance_mask(cpu, sd, sg, mask);
>  	cpu = cpumask_first(mask);
>  
>  	sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
> ---
> 
> We just find the first CPU and reuse the scg. Otherwise, build the
> balance mask.

Yes, this is cleaner, thank you.

> 
> With those changes ...
> 
> > 
> >         build_balance_mask(sd, sg, mask);
> >         cpu = cpumask_first(mask);
> > 
> > -       sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
> > -       if (atomic_inc_return(&sg->sgc->ref) == 1)
> > +       sgc = *per_cpu_ptr(sdd->sgc, cpu);
> > +       if (!sgc) {
> > +               sgc = kzalloc_node(sizeof(*sgc) + cpumask_size(),
> > +                                  GFP_KERNEL, cpu_to_node(cpu));
> > +               if (!sgc)
> > +                       return -ENOMEM;
> > +               sgc->id = cpu;
> > +               *per_cpu_ptr(sdd->sgc, cpu) = sgc;
> > +       }
> > +
> > +       sg->sgc = sgc;
> > +       if (atomic_inc_return(&sg->sgc->ref) == 1) {
> 
> ... we can be sure this is a new sgc and just do an
> atomic_set(&sg->sgc->ref, 1) here and initialize the rest of the
> fields.
> 
> Thoughts?

+1, Since sgc is lazily allocated on demand in this patch, reaching 
the slow path guarantees we are initializing it for the first time.

> >                 cpumask_copy(group_balance_mask(sg), mask);
> > -       else
> > +               sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
> > +               sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
> > +               sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
> > +       } else {
> >                 WARN_ON_ONCE(!cpumask_equal(group_balance_mask(sg), mask));
> 
> Do note this check will be lost with the optimization for the
> fast-path case but that should be okay(?)

Yes, that is fine: find_group_balance_cpu() already verifies that 
sg_span equals sched_domain_span(sibling->child) for cpu.

I will fold this into v2.

Thanks,
Pasha

> 
> > +       }
> > 
> > -       /*
> > -        * Initialize sgc->capacity such that even if we mess up the
> > -        * domains and no possible iteration will get us here, we won't
> > -        * die on a /0 trap.
> > -        */
> > -       sg_span = sched_group_span(sg);
> > -       sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
> > -       sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
> > -       sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
> > +       return 0;
> >  }
> -- 
> Thanks and Regards,
> Prateek
> 
