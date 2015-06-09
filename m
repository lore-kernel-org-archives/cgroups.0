From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v13 5/5] cgroup: implement the PIDs subsystem
Date: Tue, 9 Jun 2015 13:56:32 +0900
Message-ID: <20150609045632.GR21465@mtj.duckdns.org>
References: <1433547736-11707-1-git-send-email-cyphar@cyphar.com>
 <1433548938-32560-5-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PsHPA6S2j9rsHwm9TZxLvhu6zLX8gOgBM/vw3OyeseM=;
        b=krz7FvpVTS2yPUBz6oJ1BAb2NKe2nI+Jp4bOMG/gk63sKKbUDflhNxdQ4OW11ReMwy
         AGwlcWTJs3jnUa0STBFQYlRa//Tl58FVIisjSd3+wp9AxqFFekCUUcoUeG4s2XrqW1PG
         eCXvA0tucEs4DBBdFOOPKBiBzhCMQBK6K7/y5GispokysKH/461WSPJBiVbLd0gkS+TP
         99qpMrHXpbOo/VcHBAWVycNqmFU1tUSunxBoMBKU3cBNiNUHn+CZ0Zj+DN226TqL+Q2g
         ZyxWhfaH+6yO9Hgg5I/1TpJvacMo/GrizG9lKqNSfpWhI42xowrkgPNvIc3aS2NC+th9
         NJ/w==
Content-Disposition: inline
In-Reply-To: <1433548938-32560-5-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Aleksa.

On Sat, Jun 06, 2015 at 10:02:18AM +1000, Aleksa Sarai wrote:
...
> +/*
> + * Lockless hierarchical accounting (with enforceable limits) derived from
> + * mm/page_counter.c. Original copyright notice from page_counter code:
> + *
> + * -------------------------------------------------
> + * Lockless hierarchical page accounting & limiting
> + * Copyright (C) 2014 Red Hat, Inc., Johannes Weiner
> + * -------------------------------------------------
> + */

I don't think we need the above copyright notice.

...
> +struct cgroup_subsys pids_cgrp_subsys = {
> +	.css_alloc	= pids_css_alloc,
> +	.css_free	= pids_css_free,
> +	.attach		= pids_attach,
> +	.can_attach 	= pids_can_attach,
> +	.cancel_attach 	= pids_cancel_attach,
> +	.can_fork	= pids_can_fork,
> +	.cancel_fork	= pids_cancel_fork,
> +	.fork		= pids_fork,
> +	.exit		= pids_exit,
> +	.legacy_cftypes	= files,

Please also init dfl_cftypes the same way too.  Also, can you please
rename files to pids_files?

> +	.early_init	= 0,

And the above can be dropped.

Other than the above minor points, everything looks good to me but I
think we're a bit too close to the merge window to put this in now.
Once you update patch 4 and 5 according to the review, I'll apply them
after the next rc1 drops.

Thanks.

-- 
tejun
