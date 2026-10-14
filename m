Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB4947F788
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 19:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006218; cv=none; b=EwpT536R7xvdZFC+AR63KEIIFmfLQX2yHeh+nxUSBgZRF47Kr+BlCp7pqyr8E5xUx+VPK7d5mlv/6EOeItCrW2gEEN/ekFyrx4d3JbIu5ZKi5h3M2KpuHfc12PEDnCS9R/mQTBfOFYNwJ/U2gekSZZe5JT9cE2xplqHNYut58ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006218; c=relaxed/simple;
	bh=Vo+C+VaDz8rRmsZiOg83Zd7zWAVcln5wCz63bpyC8tc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OBoixA4sqbFJrQY3SOV0l7VT8irK6KFwCI+CT/8QU1Mrt/AYvgF3ech/XzMG5ECH3iMaEuCcISOyRdA5MNjdA5hAlz9MICjuKfZEjXknAxDUABHCCPgLbJ++2e9xLwg5wkF8swzuUuS5u98rkri22cJFkE/Skq1V5GDOYrrDCbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PWIma+7y; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PWIma+7y"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48c4be28b82so910636f8f.2
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 12:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792006215; x=1792611015; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2CNBamaaMCHB2WF9+SfyKf4vOVrbkIcaY3A7Ac/PFC0=;
        b=PWIma+7y7+iKQfABmWoPx7Y0KZ0c3ZfM28yXHKWD9Hlgq6p8ZqT0qE88YotUMptdVc
         9kA+xl/5j/gAP7p1CJ55GQa9eVLakLBmeqJ1THTW/B/VTSGG6NAyoMLeJoyqhe0w90mc
         oD3DPK4fYSx5SKddkxGPKWIP/FPZoi52xoM0N8OvoHH2AgLL/aET0zPYhDL8Y8P0U+CX
         8WwzWAn4ItrYfQ5ijmWGYyxZRi0NBakJQoUqzU3xbiiWNlOYgVTyML4PRwlyjEzdtbLp
         yT3L0VP6+7k4oRACaiPHP1qU8cUrN7XOeLXh2b7/TZD+njMOpuMC54jQdYKHIniZeje4
         iw+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792006215; x=1792611015;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2CNBamaaMCHB2WF9+SfyKf4vOVrbkIcaY3A7Ac/PFC0=;
        b=EX/rOOEXeGvPWvXLAGCntpoZrb2cp/2bou9CdqZtZHjhzYVx4ZIJEt91Hefv0PUT5O
         8SnHgOen3o9Tevrb8HNELzB9YPW0kkcWlsELNYtfItTxVv9i7YVZYTBG2x1yDJMbzV2p
         G9mhxkNz+AImHr7C230J3Ct3LEejNhLSopgrELL+jk75TP+rl30bvixrvXaCBVHZcCf9
         j23w+SCvt6KaSNF5F3aDeULjlv852ypzvALlD3Ak2GxddociMeVSyunsH/cdRAhZ+YxT
         zdsz7TrcyahBgf5ZglmJ2ge+zmevugIwqFJLvFAyWj6jSPxBKZKxkRCSjA2pGGwyNrAS
         6UsQ==
X-Forwarded-Encrypted: i=1; AKwUvBzFfDCpGgd5AiG04J34zyG4FBHhUw1ozkAFuMkbfkGdR8XadRzHryb5kDWwz177IDMHudT2GkrC@vger.kernel.org
X-Gm-Message-State: AFq9FYKvo8TuhZO6ASY7eaXEnMZBO0rgOxVgodVnxAXl24R7ASDC7xax
	K+aRtm3mjTCaU8QlKPszh+ZkDGPvWW6SlWW9wa376mDyg+YVpZjz/hOr6uOIFDVKkHs=
X-Gm-Gg: AYBFou2HBAiAlHUaF0Med2gPjfJ8N7EVfvhaysgNU9Ao+2Xckw+54+nxPSQL6DQVX1q
	I4y8/DPn5lJLepU8okiUesjviF/iQ2U7+ETtJqJQJ62Cg6zsCRbcwXf/j8KibQ1zg7v/PJGquR1
	GuogczJI7o2cTragMdN/QquWpOY3duleWXx0LZXuZBvJmiKMPqYQ7IXsVRmpxdGQ8aLtmeIOklI
	ZxWIDF1vvBTvPc9WDJizg9Epurx7/FmmR0Mn4NE7pH/ME3JEToryYKf9ijR0C8VAreJ8xrCdaFG
	qtXh+kVZs7a5w7bFeLp/jI+MUVfOmOZTp/YzSulKCLYFQzxbLCt3BAp/OGsjUY7Tuuf5HadCgFS
	cuxJxmRqmknbCijcOpDpO/FqVXRBAs3jTE9u3vYcRhs+/Y+0AlKP8Hg0Kp+qdOFGkwYri19dnO1
	JQf9r0AXeOmMuxNELt0wSnHES3G7NIA29xjD8YdQZW3cOyz4Qgc8lNbao63yeq1nT5zzbEdJA40
	UFWDOoLupDi
X-Received: by 2002:a5d:58dc:0:b0:48c:77aa:2f78 with SMTP id ffacd0b85a97d-48dbacecfd8mr24520206f8f.56.1792006215459;
        Wed, 14 Oct 2026 12:30:15 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ab4f34sm14183540f8f.28.2026.10.14.12.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 12:30:15 -0700 (PDT)
Date: Wed, 14 Oct 2026 21:30:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 5/5] memcg: simplify high limit handling after a
 charge
Message-ID: <as_YRh2qflANGs5F@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-6-shakeel.butt@linux.dev>
 <as9rj8KoF1oKO8rE@tiehlicka>
 <as-sE3hZqFA_Wb5B@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as-sE3hZqFA_Wb5B@linux.dev>

On Wed 14-10-26 10:43:33, Shakeel Butt wrote:
> On Wed, Oct 14, 2026 at 01:46:23PM +0200, Michal Hocko wrote:
> > On Sat 10-10-26 14:09:57, Shakeel Butt wrote:
> > [...]
> > > -	/* Interrupts, kernel threads, and remote chargers stop here. */
> > > -	if (use_worker)
> > > +	/*
> > > +	 * Use a worker for interrupts, kernel threads, and tasks whose mm
> > > +	 * does not match the charged hierarchy.
> > > +	 */
> > > +	if (use_high_work) {
> > > +		if (!iter)
> > > +			return;
> > > +		if (allow_spinning)
> > > +			schedule_work(&iter->high_work);
> > > +		else
> > > +			irq_work_queue(&iter->high_irq_work);
> > >  		return;
> > > +	}
> > > +
> > > +	if (iter) {
> > 
> > Would it be much simpler to bail out on iter==NULL (i.e. nothing over
> > high limit) right after the loop?
> > 
> 
> I want this patch to not change any behavior. If we return here when iter is
> NULL, we will skip a potential call to __mem_cgroup_handle_over_high() when
> current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH. Though I agree that is
> very subtle and most probably unexpected. If we decide to remove it, we should
> do it in a separate patch.

OK, makes sense.

Acked-by: Michal Hocko <mhocko@suse.com>
-- 
Michal Hocko
SUSE Labs
