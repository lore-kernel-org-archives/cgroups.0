From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Tue, 21 Feb 2023 09:48:53 -0800
Message-ID: <Y/UEBc4qyLIqHGIA@P9FQF9L96D.corp.robot.car>
References: <20230220230624.lkobqeagycx7bi7p@google.com>
 <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
 <61CA5FFC-547B-4F56-9238-C9096223BF80@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677001755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JaPQBeAqUbK/3uqJSLJQEsHhoRu/puBJx1HPQm6lT2k=;
        b=k4AQBnnNlebWncyyit/YQ4icinXPdj7y+dPZM0jGb8f0Q87q0GA2cL+WHiURqTE7xqk/LQ
        ZasPA7nfI8VWU2k5NRuBbPxbjzzff5gy14YAPvMueZUMEpggw0lDSCOIidUbvK+0WMuvsj
        ptaJ8q09dJHrgHQOuhx0x3iMvIEFJzI=
Content-Disposition: inline
In-Reply-To: <61CA5FFC-547B-4F56-9238-C9096223BF80-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 21, 2023 at 03:22:32PM +0800, Muchun Song wrote:
> 
> 
> > On Feb 21, 2023, at 13:17, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > 
> >> On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >> 
> >> ﻿On Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin wrote:
> >>>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> >>>> The knob for cgroup v2 memory controller: memory.oom.group
> >>>> will be read and written simultaneously by user space
> >>>> programs, thus we'd better change memcg->oom_group access
> >>>> with atomic operations to avoid concurrency problems.
> >>>> 
> >>>> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>> 
> >>> Hi Yue!
> >>> 
> >>> I'm curious, have any seen any real issues which your patch is solving?
> >>> Can you, please, provide a bit more details.
> >>> 
> >> 
> >> IMHO such details are not needed. oom_group is being accessed
> >> concurrently and one of them can be a write access. At least
> >> READ_ONCE/WRITE_ONCE is needed here.
> > 
> > Needed for what?
> > 
> > I mean it’s obviously not a big deal to put READ_ONCE()/WRITE_ONCE() here, but I struggle to imagine a scenario when it will make any difference. IMHO it’s easier to justify a proper atomic operation here, even if it’s most likely an overkill.
> > 
> > My question is very simple: the commit log mentions “… to avoid concurrency problems”, so I wonder what problems are these.
> 
> I think there is no difference in the assembly code between them in most
> cases. The only intention that I can think of is to avoid the potential
> complaint (data race) emitted by KCSAN.

+1

And it might be a totally good reason for this change, let's just make it clear,
instead of pretending to fix non-existing concurrency problems.

Thanks!
