From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: Return if dst_cgrp equals to src_cgrp
Date: Thu, 26 May 2022 13:22:28 +0200
Message-ID: <20220526112228.GG11007@blackbody.suse.cz>
References: <1653066120-21262-1-git-send-email-shisiyuan@xiaomi.com>
 <Yo6zAi+Y/uXLYUI7@blackbook>
 <CAC=y0ud7oPtFqj=dqBSicoWwoN0knAwA6svidiYjbFn9BJMR3w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653564149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hv0r7+P52bHUfxGCUQuHehbuy065ANoliNcm3V+0PFI=;
        b=utAQl6liQ+JUOSurMy22DRK/WHQEwUNAJPY0hO3x8ST/3ghDSYABv66ADrFm/rLcXGZbwL
        id0nrWLqSv+f/Re52lXyOhtxCSs1Tk51+U/rLpTMsbvmdpGjUFczTfQusPkTjTLUvbjwp2
        1JUNuLjIcjQLoyETNXg5L8Htt00NnlQ=
Content-Disposition: inline
In-Reply-To: <CAC=y0ud7oPtFqj=dqBSicoWwoN0knAwA6svidiYjbFn9BJMR3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?5Y+y5oCd6L+c?= <shisiyuan19870131-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 26, 2022 at 12:40:17PM +0800, 史思远 <shisiyuan19870131-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> echo 1413 >  /dev/cpuset/foreground/cgroup.procs
> echo 1413 >  /dev/cpuset/foreground/cgroup.procs
> echo 1413 >  /dev/cpuset/foreground/cgroup.procs

Thank you.

> In this situation, since the second echo, dst_cgrp equals to src_cgrp(both
> cgroups are the 'foreground' cpuset).
> cgroup1_procs_write（）-> __cgroup1_procs_write()
> -> cgrp = cgroup_kn_lock_live()
> -> task = cgroup_procs_write_start(buf...)
> -> cgroup_attach_task(cgrp, task, threadgroup);
>   -> 1) cgroup_migrate_add_src(task_css_set(task), dst_cgrp, &mgctx);  //
> detect the (src_cgrp == dst_cgrp), don't need to continue the following
> migration flow.
>   -> 2) cgroup_migrate_prepare_dst(&mgctx)

Here, I'd like to let you know about [1]

>   -> 3) cgroup_migrate(leader, threadgroup, &mgctx)
>   -> 4) cgroup_migrate_finish(&mgctx) // cleanup
> -> cgroup_procs_write_finish();  // cleanup


> >> The main purpose for this patch is to handle the situation above, and
> just noticed that cgroup_update_dfl_csses() also
> calls cgroup_migrate_add_src(). So I assume it's a similar situation. We
> can discuss more about it.

So I think the patch doesn't save that much and identical css_set is
better condition to check on (covers cgroup_update_dfl_csses too).

Michal

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/cgroup/cgroup.c?h=v5.18#n2710
