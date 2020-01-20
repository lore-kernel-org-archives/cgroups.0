From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 5/6] clone3: allow spawning processes into cgroups
Date: Mon, 20 Jan 2020 16:39:30 +0100
Message-ID: <20200120153930.GE30403@redhat.com>
References: <20200117181219.14542-1-christian.brauner@ubuntu.com>
 <20200117181219.14542-6-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579534779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PlTLiw4VTkftWvjolml/QIq+8aGtfq5D8y4S3zLmz20=;
        b=AvFF6f0puOM1GFlpluPvNNDWJCxdtT9s1Aj64zU2CMm+NT7LoMF9VU+FmjFH5aqxOMkyrA
        ak4Cvo5D3k7tmDV/z600rz320g+iUUhtYOwN/hyx9tGbZygWTQmEqqJutpZot8FpdYD1vT
        h1DmOgPm/UtEoJfuIahPQfVyGs2v4ic=
Content-Disposition: inline
In-Reply-To: <20200117181219.14542-6-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 01/17, Christian Brauner wrote:
>
> +static int cgroup_css_set_fork(struct task_struct *parent,
> +			       struct kernel_clone_args *kargs)
...
> +	kargs->cset = find_css_set(cset, dst_cgrp);
> +	if (!kargs->cset) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	if (cgroup_is_dead(dst_cgrp)) {
> +		ret = -ENODEV;
> +		goto err;
                ^^^^^^^^

this looks wrong... don't we need put_css_set(kargs->cset) before "goto err" ?

Oleg.

