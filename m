Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5315744065B;
	Thu, 20 Aug 2026 22:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787264369; cv=none; b=g3EsskvR63CK4TL4DSd4kYQVufc+wfN5UKZ6c1Xql+xfEBiNVddaile5LC7etXujeZyeTE7X32oII1mH/uad2wE8DSpEGlvHPpgOQcgALlhIQhzhn9PvZNDtELbN/QUM9eHgC7UbHVC1KmCZDOSwtSQ4m46j1YXRut8YVjQxgP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787264369; c=relaxed/simple;
	bh=JAHheDJc9ZsmcAFZU61a/rMf9y7wls1qknnKYaaQ3a8=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=OC61e4DIfpyyAUL3HBMSyks5oXIT/0bd1rX4m6hfIfAgyNEAk1wCwx+ug9gzdSz1e+iGc5H2pOfBk10wKjAObRI5UOTT02lPqp0D4hN0RwoXmgXKY+8XTySq06tQTKl+98LGRtYndlxGQGyEA1Cd3igVwIKh+giA+Qap1npc3gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWMmbDNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWMmbDNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544891F000E9;
	Thu, 20 Aug 2026 22:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787264367;
	bh=WyO7QJTGrqqMYhd469ae+1CxVoms/6fTWqL/hfT6//8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=OWMmbDNX/6p9OyK7z17rKa8Y4k6aBULOfNE7af7kYHKfyEonC2eFbZ7b1pm90Z9lI
	 bTE5ay4YmIgVtJQWuyEqkoSBz91izpJn0pV4H6Jvy7kEXBUHA0GkB1IZ0m68iMi32T
	 XqxoAanemhz2duEe3QapvH73csyf+F5Ws9byNJT9vZxP+4DaRhGpcrXBJ3yfzquaF7
	 /I7Qfo03J3tebm4a3rCDS7Hdfjw6qFO5ynVvKpwaPPcF5PIbmjt1Nx2eiIcaxmAIS5
	 MNJFj8mNfb2MoOIO/nA5jd5+3MuxaWVHrZPB7jIhru3y4i0P/HUO32j/IwOnUB2YuL
	 52pO++k+DTxAQ==
Content-Type: multipart/mixed; boundary="===============2862219450226224686=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <8314f1b2a808075d369a73829c884b05258dafbc581ba56e981ad5557bdbfc47@mail.kernel.org>
In-Reply-To: <20260820211758.3393984-4-ziyang.meme@gmail.com>
References: <20260820211758.3393984-4-ziyang.meme@gmail.com>
Subject: Re: [PATCH v3 3/4] block: add BPF kfuncs to read blkcg io.stat
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,kernel-team@meta.com,axboe@kernel.dk,tj@kernel.org,josef@toxicpanda.com,hannes@cmpxchg.org,mkoutny@suse.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,shuah@kernel.org
Cc: mingo@redhat.com,peterz@infradead.org,vincent.guittot@linaro.org,bsegall@google.com,dietmar.eggemann@arm.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,roman.gushchin@linux.dev,shakeel.butt@linux.dev,inwardvessel@gmail.com,mykolal@meta.com,ziyang.meme@gmail.com,linux-block@vger.kernel.org,bpf@vger.kernel.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 20 Aug 2026 22:19:27 +0000 (UTC)

--===============2862219450226224686==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/kernel/cgroup/bpf_cgroup.c b/kernel/cgroup/bpf_cgroup.c
> index cd28c838dc7b..e253633e8278 100644
> --- a/kernel/cgroup/bpf_cgroup.c
> +++ b/kernel/cgroup/bpf_cgroup.c
> @@ -8,12 +8,50 @@
>  #include <linux/bpf.h>
>  #include <linux/btf_ids.h>
>  #include <linux/cgroup.h>
> +#include <linux/rcupdate.h>
>
> +#ifdef CONFIG_CGROUP_SCHED
>  #include "../sched/sched.h"
> +#endif
>
> -#ifdef CONFIG_CGROUP_SCHED
>  __bpf_kfunc_start_defs();
>
> +/**
> + * bpf_cgroup_css - Get a reference to one controller's css
> + * @cgrp: cgroup to look in
> + * @ssid: controller ID
> + *
> + * The returned css must be released with bpf_css_release().
> + *
> + * Return: The referenced css, or NULL.
> + */
> +__bpf_kfunc struct cgroup_subsys_state *
> +bpf_cgroup_css(struct cgroup *cgrp, int ssid)
> +{
> +	struct cgroup_subsys_state *css;
> +
> +	if (unlikely(ssid < 0 || ssid >= CGROUP_SUBSYS_COUNT))
> +		return NULL;
> +
> +	rcu_read_lock();
> +	css = rcu_dereference(cgrp->subsys[ssid]);
> +	if (css && !css_tryget(css))
> +		css = NULL;
> +	rcu_read_unlock();
> +
> +	return css;
> +}
> +
> +/**
> + * bpf_css_release - Release a css reference
> + * @css: css to release
> + */
> +__bpf_kfunc void bpf_css_release(struct cgroup_subsys_state *css)
> +{
> +	css_put(css);
> +}
> +
> +#ifdef CONFIG_CGROUP_SCHED

[ ... ]

> @@ -30,29 +68,33 @@ bpf_css_to_task_group(struct cgroup_subsys_state *css)
>
>  	return container_of(css, struct task_group, css);
>  }
> +#endif /* CONFIG_CGROUP_SCHED */
>
>  __bpf_kfunc_end_defs();
>
> -BTF_KFUNCS_START(bpf_cpu_cgroup_kfunc_ids)
> +BTF_KFUNCS_START(bpf_cgroup_kfunc_ids)
> +BTF_ID_FLAGS(func, bpf_cgroup_css, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_css_release, KF_RELEASE)
> +#ifdef CONFIG_CGROUP_SCHED
>  BTF_ID_FLAGS(func, bpf_css_to_task_group,
>  	     KF_RCU | KF_RCU_PROTECTED | KF_RET_NULL)
> -BTF_KFUNCS_END(bpf_cpu_cgroup_kfunc_ids)
> +#endif
> +BTF_KFUNCS_END(bpf_cgroup_kfunc_ids)
>
> -static const struct btf_kfunc_id_set bpf_cpu_cgroup_kfunc_set = {
> +static const struct btf_kfunc_id_set bpf_cgroup_kfunc_set = {
>  	.owner		= THIS_MODULE,
> -	.set		= &bpf_cpu_cgroup_kfunc_ids,
> +	.set		= &bpf_cgroup_kfunc_ids,
>  };
>
> -static int __init bpf_cpu_cgroup_kfunc_init(void)
> +static int __init bpf_cgroup_kfunc_init(void)
>  {
>  	int err;
>
>  	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
> -					&bpf_cpu_cgroup_kfunc_set);
> +					&bpf_cgroup_kfunc_set);
>  	if (err)
> -		pr_warn("error while registering cpu cgroup kfuncs: %d\n", err);
> +		pr_warn("error while registering cgroup kfuncs: %d\n", err);
>
>  	return err;
>  }
> -late_initcall(bpf_cpu_cgroup_kfunc_init);
> -#endif /* CONFIG_CGROUP_SCHED */
> +late_initcall(bpf_cgroup_kfunc_init);

This isn't a bug, but the patch adds two controller-agnostic kfuncs
(bpf_cgroup_css and bpf_css_release) in kernel/cgroup/bpf_cgroup.c, along
with a three-way rename (bpf_cpu_cgroup_kfunc_ids to bpf_cgroup_kfunc_ids)
and an ifdef restructure of the whole file.

The immediately preceding commit in this series (382c3bd4 "cgroup: add BPF
kfuncs to read a cpu cgroup's stats") already touched this same file under
a "cgroup:" prefix.

Would it be worth splitting the generic css acquire/release and the rename
into a separate "cgroup:" patch, so this one stays scoped to the block
changes?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32419919743
--===============2862219450226224686==--
