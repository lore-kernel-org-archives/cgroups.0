From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] misc_cgroup: introduce misc.events and
 misc_events.local
Date: Thu, 9 Sep 2021 16:37:02 +0200
Message-ID: <20210909143702.GA13761@blackbody.suse.cz>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631198224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XkjD8/xyvDQHdHUfoLy2/8tk1jskQyMQBKAq3vWNNNw=;
        b=cGUl4e12Cz7LifcU+dCpN+PO0BFGCuqyMjoxtq4Q+YiKgGXCS2Ui6xTYRabhmIM/bTWJsm
        +g24jV+E2yxs/Pj65vIuaeXCAp9L6FdAid3wIBZ6FnFfZADQllqBWlODlZ+mSf5IkAtWJ2
        fqxrzsrTmRAnZssIOypJQgIzdLJyNr4=
Content-Disposition: inline
In-Reply-To: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Chunguang.

The new version looks like a good step generally. 

My main remark is that I wouldn't make a distinct v1 and v2 interface,
it's a new controller so I think the v2 could be exposed in both cases
(or in other words, don't create new v1-specific features).

On Wed, Sep 08, 2021 at 01:24:34PM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Introduce misc.events and misc.events.local to make it easier for
> us to understand the pressure of resources. The main idea comes
> from mem_cgroup.

BTW what are the events you really are interesed in? (See also the
proposal in my reply to 1/3.)

> @@ -171,6 +171,16 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
>  	return 0;
>  
>  err_charge:
> +	if (cgroup_subsys_on_dfl(misc_cgrp_subsys)) {
> +		atomic_long_inc(&i->events_local[type]);
> +		cgroup_file_notify(&i->events_local_file);
> +
> +		for (k = i; k; k = parent_misc(k)) {
> +			atomic_long_inc(&k->events[type]);
> +			cgroup_file_notify(&k->events_file);
> +		}
> +	}
> +

No reason to wrap this for the default hierarchy only.

> +static int misc_events_show(struct seq_file *sf, void *v)
> +{
> +	struct misc_cg *cg = css_misc(seq_css(sf));
> +	unsigned long count, i;
> +
> +	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
> +		count = atomic_long_read(&cg->events[i]);
> +		if (READ_ONCE(misc_res_capacity[i]) || count)
> +			seq_printf(sf, "%s %lu\n", misc_res_name[i], count);

More future-proof key would be
			seq_printf(sf, "%s.max %lu\n", misc_res_name[i], count);
or
			seq_printf(sf, "max.%s %lu\n", misc_res_name[i], count);

(Which one is a judgement call but I'd include the "name" of event type too.)

> +static int misc_events_local_show(struct seq_file *sf, void *v)
> +{
> +	struct misc_cg *cg = css_misc(seq_css(sf));
> +	unsigned long count, i;
> +
> +	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
> +		count = atomic_long_read(&cg->events_local[i]);
> +		if (READ_ONCE(misc_res_capacity[i]) || count)
> +			seq_printf(sf, "%s %lu\n", misc_res_name[i], count);

Ditto.

Thanks,
Michal
