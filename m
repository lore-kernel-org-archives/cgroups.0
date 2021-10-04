From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: rstat: optimize flush through speculative test
Date: Mon, 4 Oct 2021 07:00:36 -1000
Message-ID: <YVszNI97NAAYpHpm@slm.duckdns.org>
References: <20210929235936.2859271-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pqoXBReWZTHvQNJRRiye0Xfo5/CYCSyS20QIvLAs+Oc=;
        b=RNg9WE6gurFAuclja1md8Z0NgpR7kRF419Lfq/1FBEY4FvTK31TnekkHmWasNe+C81
         2Qf24+qnVfqCnBg0pl5JqIUNn59KlKxY5SE2ATXqXyduo1FxV2Xeh1OO2kubNdwNtjAG
         UJm8LWP4NkJzpKHwR5RMCdClAlMDlQgqf3bxnhmk1oWWLHaFxrpyOZkeXcZC+qtCv1pj
         INwuFn3eMzaewx9I9bsaLSnK3FtI4iqkTTdaeomSYzFf5J8USqmB60JPQKAZHaYVbMx0
         6Pn3qDDShj9beVqCvMwxJQRZmRgdDAQ6C8SdugwvvlDnnjdMOQjhDXtBm/mNQ4o5YSMd
         Tujg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210929235936.2859271-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Shakeel.

On Wed, Sep 29, 2021 at 04:59:36PM -0700, Shakeel Butt wrote:
> Currently cgroup_rstat_updated() has a speculative already-on-list test
> to check if the given cgroup is already part of the rstat update tree.
> This helps in reducing the contention on the rstat cpu lock. This patch
> adds the similar speculative not-on-list test on the rstat flush
> codepath.
> 
> Recently the commit aa48e47e3906 ("memcg: infrastructure to flush memcg
> stats") added periodic rstat flush. On a large system which is not much
> busy, most of the per-cpu rstat tree would be empty. So, the speculative
> not-on-list test helps in eliminating unnecessary work and potentially
> reducing contention on the rstat cpu lock. Please note this might
> introduce temporary inaccuracy but with the frequent and periodic flush
> this would not be an issue.
> 
> To evaluate the impact of this patch, an 8 GiB tmpfs file is created on
> a system with swap-on-zram and the file was pushed to swap through
> memory.force_empty interface. On reading the whole file, the memcg stat
> flush in the refault code path is triggered. With this patch, we
> observed 38% reduction in the read time of 8 GiB file.

The patch looks fine to me but that's a lot of reduction in read time. Can
you elaborate a bit on why this makes such a huge difference? Who's hitting
on that lock so hard?

Thanks.

-- 
tejun
