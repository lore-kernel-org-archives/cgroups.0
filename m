From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH-cgroup v7 0/6] cgroup/cpuset: Support remote partitions
Date: Wed, 30 Aug 2023 09:26:24 -1000
Message-ID: <ZO-X4KnEtOjhJffR@slm.duckdns.org>
References: <20230817132454.755459-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693423587; x=1694028387; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GTF8uU39IXGUS1zNRIqYR6R0K0rtvdFudoKrSX9kw1k=;
        b=AFvvh2vedbt/Klxv5llmSY+4QZo7dpggLb3kn7secLTvsXomFbp0WQwvKzDXKFrDYE
         7YXAutZH0rOeSoE3JwB14MaLRHTdvosZsrUd15kje8ItKdHnhbBk2ILhxyhWR0zlwgrq
         8iYqoWEGHidbCWVM+M+N/zPrRM+MbpVx1CDHVdXSF2XRoIAz1ZWFUpO4NO/GSTBH7YWN
         jwts8l7QgK7PmRxFodyEMLPNMAKWg+d4RKBChA73FLZrpgVlgXHDS5sx5sBIgay9BKgN
         b/IJzuSMt4oY00we0lXlY9i0gfv+DQcBJBvB2yJyGqPvejuiMCeweQA0LT4xGlA5ywOX
         PFLg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230817132454.755459-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Waiman.

On Thu, Aug 17, 2023 at 09:24:48AM -0400, Waiman Long wrote:
>  v7:
>   - Fix a compilation problem in patch 1 & a memory allocation bug in
>     patch 2.
>   - Change exclusive_cpus type to cpumask_var_t to match other cpumasks
>     and make code more consistent.

This overall looks fine to me but I'm afraid we're a bit too late for this
devel cycle. I'll merge these into cgroup/for-6.7 when it opens.

Thanks.

-- 
tejun
