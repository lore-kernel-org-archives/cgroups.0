Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F842446BEA
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 22:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788560171; cv=pass; b=cT4sAq0cn/HVRivGluyuTpKT5zDJe+eRaaTCdXxKb1K/52408XSmWWBP3IUpYcdTP/lfDuvB5ZzsFy4h8RhnFy9t9Kmn9N/SYYZTH/pi6XPMYMdi2sVug5N46Q0DRkuQ7ovjBmtNvui3oOl9XTdTlc4GIaN0G0WDk4SfjqizB78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788560171; c=relaxed/simple;
	bh=dz2fj88YTNw0Ti+IhRHiMFJ+cu0G95tHI9e8c83/Hzo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A+1cFLTdEeKvc3RyZklD4a39VEmPQ9leso4RQfSoWh+sLhwYpjnbAe+sg1V4tiHJIWCwZRz1b+5AH9HqY5fOgVijTa2Trghy+oDfO2yBP5J7luKG2v414QxVRSA7o68bqpW+kduwUfbEOZ/ccG4wm6+lJwUvQ2dlZ3WITP5Ejp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NKwV3ncZ; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NKwV3ncZ"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b5e50eb70so3055e9.1
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 15:16:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788560166; cv=none;
        d=google.com; s=arc-20260327;
        b=W71sBpxwyRcDY1NNeU4X/0IRmyPAaAKHBE53gjqLc9h+bTJgw/rqGZOUulQzyJTq24
         XhxACxxxSyJZbMCxeakGNuU+Nxp90n89SL0A7Ap3l3LPGvKhhGOFoeBJYZDbrn5JIZS1
         U0heqo2XikVXTPQD5IbxiEKvWO2F9XDP3r/YqzEhK44P+ipTFGRm0jJYLumAZh2CAEge
         9OxvWJUo180zLjrgZkGgkrr8RjOdTtoED/P9oDoiZ97yfA+cUOTifrd04+tiyjBys1Gx
         UHeN8SecQ7u7sAV/E40LY9uEUobKYlWUNz3m4uaOLd89ucVeL0yYGkSGccFE+pWNJ/O+
         NE1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0l8VM1lkkUjt52ORVhFYEbx3JRFVUpwcUSSFpCihGCk=;
        fh=UqFIAKO7hDaRXfD7ex5BEfUjbppDmGxdNyZG72GGZl0=;
        b=iqc75y+RJcSZ9uY+5MBeFLuYCdklDcyw3mfa+VNyB2KoS57yWkTlx8sdVrj+ZhrW6k
         k5Swf7gzSWIiDff319LcInOAb9e/DP8xSfUp9HgjlGBKoU0K1FBd4RH/rHboE8V5P0zN
         /qPO8uXI+nj/qkxtffFeBlp++HDYebyhhW3JrbRj3CrZDvVCH90oIcz5nFrCiQArtSVq
         eBC/tlQHguSZPlDR4dnmZctg8HUY+xAeIYJk8gCBUmqszWRwZogVbNWPDRpBB82toBLU
         Z5ehT6KRtNBduR9H7CKDM66pu7G4dnd+9cj3aua0RxGKwtdOppa4Um/aPEDkc7FQFoFh
         Zvjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788560166; x=1789164966; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0l8VM1lkkUjt52ORVhFYEbx3JRFVUpwcUSSFpCihGCk=;
        b=NKwV3ncZA2lylVdyey7jD7wRUGkdvzs7/XYI2XZD0HgmOwZtp5fcsqw4e5ovBEOGAz
         bm7Ui01c/Yxj8yQhaf5KH5yD/uoaLUljRUuZcGmZJL9KXMUNmJT4x4SUXJ3zNXflXqoh
         i88/QuZJAJz8uGKWXc+PtWZt5egoLWDdrU+vqSM9Sb3coQmjOTVvikd7qslAVYnwBtFW
         U3WrypdHxswdeum18xARveXZQLSi4CvhgBw7RY2P7uH3k7W5I7I6cNeWItj62zEh+Ny/
         uf3KFfnzY3A1TzY3vikPi41R+HGXuJaB+SDrToOro1jeQcLvMB0RXwxvX5xPxDP/qLs0
         GQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788560166; x=1789164966;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0l8VM1lkkUjt52ORVhFYEbx3JRFVUpwcUSSFpCihGCk=;
        b=QpDwDzF3BT36UwWE/1lQB9ODurjU6sMfJpDtQ0e9V8oUJ3AGdixU69pef5NltnE0Eg
         bKZzQIgG61t9HLZ2ocTi/4OkHLPMjZMD7z40Vg8jOcINy1/vVV+GPDuBxIZ2mQ8DgB4J
         RjxEhSlfebbIiV1fWIwAGJrOYna5L0s/RAWJb/nB0DQEQmXJoEoA7by3pfTog2TM/8UR
         J3oESBImCVeP8JGHay8Nxzgi/IjlzWP9+jGPICX7wBotHYBSIZBdL9hEBwecCheD03tF
         82EAtZDjsL4bRmKIp/HM8d8K2MDtTBRIGw/aCtOAb86qpSb4i5E2qAyqnU0QwqasiHYB
         fhVA==
X-Forwarded-Encrypted: i=1; AKwUvByQ7CP/H7JZfZcu3B5asC3DEtsqb3cmdPBwjqbShdm1y1CPLEkPY4FbymHJ7BKy7UXKq+D8pHeB@vger.kernel.org
X-Gm-Message-State: AFuF++mnehFZBrjfyAl6Mp9VenASBjWNjeoW48BsUqlKM7oppKk3Xkti
	6yqqLQls5K+t/AXycooaRAnhjPDAHCo34Lb6/7Lbe/0Uxpdxjt6Psu3UIUhevlTPWkSj1lnXX+O
	QuW9f7ojQQno8qiQdvBfTPerHd/I1DvabrVosOMwf
X-Gm-Gg: AYBFou0c90qun5mJF4g4QvU00yW6McbFnxw5Mo7OcU+C6mskuZwba8v3DqB4kyhNQSG
	p287q6lyYYxJ3lkOTPK7ALhzMbXcSXZQK2LL6tmNEEs1gdKxbY9l/s9zwLssqhO3q0RMwlMkLJ8
	PoVEOvSGe8kvjNkHVAYhD55yzmVf06B+M6iQh1eye94kcHoLPQ87ePLqppeie5KgCu6zRFkHWgl
	/7wlCHugc8Mqv9SVDDcrJuqbjwloLU7EPRVsvfXzyV3Z1u6q/kVKa+RPqb3k4jRaeEcwhHwcSBN
	929+xnM+qkQwynmJ4JW4VDMB4xO1crH2vZHBmgA0LUmZlkRXAwt9z7OGzoOdCfSxMM7uXGuXqGo
	=
X-Received: by 2002:a05:600c:470a:b0:499:c4db:2ea9 with SMTP id
 5b1f17b1804b1-49d01dd5312mr209675e9.9.1788560165981; Fri, 04 Sep 2026
 15:16:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260904173145.2028377-1-stevensd@google.com> <apsTohKZNnZuWIxC@linux.dev>
In-Reply-To: <apsTohKZNnZuWIxC@linux.dev>
From: David Stevens <stevensd@google.com>
Date: Fri, 4 Sep 2026 15:15:54 -0700
X-Gm-Features: AcwNN1VpnwWrsGTRyjmKHtNydJf_FSs12X_Euci9xsJuEck82AevDlkEA_BZZfE
Message-ID: <CAOiLmNGdPk+7v6Aqm9ctQV9J3YKti50gVTP00P=-3cZ8-x5cUA@mail.gmail.com>
Subject: Re: [PATCH v2] memcg: Don't call schedule_work when no spinning is allowed
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 4, 2026 at 12:03=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Sep 04, 2026 at 10:31:45AM -0700, David Stevens wrote:
> > Memcg charging can be done from any context, but calling schedule_work(=
)
> > isn't safe from an NMI. If memory.high is breached from a context where
> > spinning isn't allowed, use irq_work to schedule the reclaim work.
> >
> > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > Signed-off-by: David Stevens <stevensd@google.com>
> > ---
> > v2:
> >   - Added missing includes reported by Lorenzo and kernel test robot
> >   - Added Acked-by
> >
> >  include/linux/memcontrol.h |  2 ++
> >  mm/memcontrol.c            | 13 ++++++++++++-
> >  2 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 8170bb8066a2..4a5ef0aba475 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -23,6 +23,7 @@
> >  #include <linux/writeback.h>
> >  #include <linux/page-flags.h>
> >  #include <linux/shrinker.h>
> > +#include <linux/irq_work_types.h>
> >
> >  struct mem_cgroup;
> >  struct obj_cgroup;
> > @@ -219,6 +220,7 @@ struct mem_cgroup {
> >       spinlock_t       peaks_lock;
> >
> >       /* Range enforcement for interrupt charges */
> > +     struct irq_work high_irq_work;
> >       struct work_struct high_work;
> >
> >  #ifdef CONFIG_ZSWAP
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6dc4888a90f3..0e8b302ca9ad 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -62,6 +62,7 @@
> >  #include <linux/seq_buf.h>
> >  #include <linux/sched/isolation.h>
> >  #include <linux/kmemleak.h>
> > +#include <linux/irq_work.h>
> >  #include "internal.h"
> >  #include "swap_table.h"
> >  #include <net/sock.h>
> > @@ -2360,6 +2361,11 @@ static void high_work_func(struct work_struct *w=
ork)
> >       reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
> >  }
> >
> > +static void high_irq_work_func(struct irq_work *work)
> > +{
> > +     schedule_work(&container_of(work, struct mem_cgroup, high_irq_wor=
k)->high_work);
> > +}
> > +
> >  /*
> >   * Clamp the maximum sleep time per allocation batch to 2 seconds. Thi=
s is
> >   * enough to still cause a significant slowdown in most cases, while s=
till
> > @@ -2752,7 +2758,10 @@ static int try_charge_memcg(struct mem_cgroup *m=
emcg, gfp_t gfp_mask,
> >               /* Don't bother a random interrupted task */
> >               if (!in_task()) {
> >                       if (mem_high) {
> > -                             schedule_work(&memcg->high_work);
> > +                             if (allow_spinning)
> > +                                     schedule_work(&memcg->high_work);
> > +                             else
> > +                                     irq_work_queue(&memcg->high_irq_w=
ork);
> >                               break;
> >                       }
> >                       continue;
> > @@ -4129,6 +4138,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct=
 mem_cgroup *parent)
> >               goto fail;
> >
> >       INIT_WORK(&memcg->high_work, high_work_func);
> > +     init_irq_work(&memcg->high_irq_work, high_irq_work_func);
> >       vmpressure_init(&memcg->vmpressure);
> >       INIT_LIST_HEAD(&memcg->memory_peaks);
> >       INIT_LIST_HEAD(&memcg->swap_peaks);
> > @@ -4337,6 +4347,7 @@ static void mem_cgroup_css_free(struct cgroup_sub=
sys_state *css)
> >               static_branch_dec(&memcg_bpf_enabled_key);
> >
> >       vmpressure_cleanup(&memcg->vmpressure);
> > +     irq_work_sync(&memcg->high_irq_work);
>
> On RT kernels, this will put rcu grace period here while we are holding t=
he
> cgroup_mutex. Easy fix would be to use IRQ_WORK_INIT_HARD instead of
> init_irq_work() in mem_cgroup_alloc.
>
> Something like:
>         memcg->high_irq_work =3D IRQ_WORK_INIT_HARD(high_irq_work_func);
>

This executes as part of css_free_rwork_fn(), so it isn't under cgroup_mute=
x.

-David
