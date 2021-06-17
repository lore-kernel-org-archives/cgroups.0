From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup-v1: Grant CAP_SYS_NICE holders permission to
 move tasks between cgroups
Date: Thu, 17 Jun 2021 07:41:36 -0400
Message-ID: <YMs08Ij8PZ/gemLL@slm.duckdns.org>
References: <20210617090941.340135-1-lee.jones@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=308dLMmMqDbO4OFxN9kKT0tYjzQ+yKtGYVUA4Fqyf7c=;
        b=j2mlwryJ8j64/CGxPSzcDSq04YPEz/agtkQ2ZMfENonngleTcs0350yQ0AojHiAeCS
         dlhWSMdJbckGk6MJdZwRvNBjo8hWI8MQWq7zXtxHJn+nbxgG+Lo6I8MurqxJnHtpSkNY
         bqm0uXfjO9eQKyBJ11JxWTUikLWek9ua4dgKko+FxJAJX5EjbQlmEBDQ9OJ4TyUjPGau
         xE6nGBI5s2mSYnPrYbc5sui2FTJNRh9df2lbFmZUzlZW6zOQIBbCq2fyOl30HljUbjqd
         mILERgv9iLJhNUC+50SGFdCG0Y4RjmHySuNviIMBK8vBEYSGmu41aryEGBQDxVKC/laP
         jp1w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210617090941.340135-1-lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Jun 17, 2021 at 10:09:41AM +0100, Lee Jones wrote:
> It should be possible for processes with CAP_SYS_NICE capabilities
> (privileges) to move lower priority tasks within the same namespace to
> different cgroups.

I'm not sure that "should" is justified that easily given that cgroup can
affect things like device access permissions and basic system organization.

> One extremely common example of this is Android's 'system_server',
> which moves processes around to different cgroups/cpusets, but should
> not require any other root privileges.

Why is this being brought up now after all the years? Isn't android moving
onto cgroup2 anyway?

Thanks.

-- 
tejun
