From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] cgroup: Avoid compiler warnings with no subsystems
Date: Mon, 30 Aug 2021 08:10:34 -1000
Message-ID: <YS0fGvwqLWKpcejZ@mtj.duckdns.org>
References: <20210828000255.3213497-1-keescook@chromium.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hD0xppJLT6aEBN2umsxRQUAtIA9VVamYDNavPG9ZrFA=;
        b=nUGFYmCE9vU9tp3VIixtY28HUGWuJn0CQpFrlaTEOAG5ks+zzZg7SYZJ7uVTIEYh5+
         4nwFaQDapsEvEUbOOxE1L7PC+rlnZ0lvvjt2qL/4R+L5rcV1GC+aBRDkCLipRuN5pKbQ
         a//RaTkbMnyB/xZJiFJUbubqXtIBczqDj8PFZY6ncK0LISWmPHX9QrJ62gOBuTZaMZOM
         jy+MFzlTkYm3+OIERk1+WlY2Q1yZyk6qT1s7z+Eq6qXeFk5BMssrLaiszlG/yqNM7lad
         5YwMiZKgSh+rPPv8N0Wn3G5qNGleu5StVthZpta/ubqWJCw4jsZIZEhzlpTZbnAYZoZe
         4zwg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210828000255.3213497-1-keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Aug 27, 2021 at 05:02:55PM -0700, Kees Cook wrote:
> As done before in commit cb4a31675270 ("cgroup: use bitmask to filter
> for_each_subsys"), avoid compiler warnings for the pathological case of
> having no subsystems (i.e. CGROUP_SUBSYS_COUNT == 0). This condition is
> hit for the arm multi_v7_defconfig config under -Wzero-length-bounds:
> 
> In file included from ./arch/arm/include/generated/asm/rwonce.h:1,
>                  from include/linux/compiler.h:264,
>                  from include/uapi/linux/swab.h:6,
>                  from include/linux/swab.h:5,
>                  from arch/arm/include/asm/opcodes.h:86,
>                  from arch/arm/include/asm/bug.h:7,
>                  from include/linux/bug.h:5,
>                  from include/linux/thread_info.h:13,
>                  from include/asm-generic/current.h:5,
>                  from ./arch/arm/include/generated/asm/current.h:1,
>                  from include/linux/sched.h:12,
>                  from include/linux/cgroup.h:12,
>                  from kernel/cgroup/cgroup-internal.h:5,
>                  from kernel/cgroup/cgroup.c:31:
> kernel/cgroup/cgroup.c: In function 'of_css':
> kernel/cgroup/cgroup.c:651:42: warning: array subscript '<unknown>' is outside the bounds of an
> interior zero-length array 'struct cgroup_subsys_state *[0]' [-Wzero-length-bounds]
>   651 |   return rcu_dereference_raw(cgrp->subsys[cft->ss->id]);
> 
> Reported-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Applied to cgroup/for-5.15.

Thanks.

-- 
tejun
