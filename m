From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: remove obsolete memcg_has_children()
Date: Mon, 16 Nov 2020 13:12:24 -0800
Message-ID: <20201116211224.GA45468@carbon.dhcp.thefacebook.com>
References: <20201116055043.20886-1-lukas.bulwahn@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=o1iZuedaHVX9QPpoa8Tlvfg/x2o+U3Mjh57arAG4JDM=;
 b=Fgu4ngqZTKM/M7RkPoZt5gV6/gGqBUqkQMQf+Jnwrjoiv3VbGsw3jGn+Yx8+18ylXNql
 4bL5lEG1K3Z1FPvrzp/XLIEhV8B8J1V0/TkSY1DcGYCK4qwZ6XbWPsqrIk7m8n8b/DwW
 VBvpadhBjDkc/mIPXHivzfQ3OHlIo7NIS64= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1iZuedaHVX9QPpoa8Tlvfg/x2o+U3Mjh57arAG4JDM=;
 b=Jris96DEucHJbGCxbzwXcrR1zveuLzrEMh5ij7zAYxxiKM5MYKmiXRmDEuURLuJT8KAb/knfc8V4OCkMo1dUkf07kMB0wYzvnyP0EBqBQsMFKKWORt/AVJLfURT+iaWzWD4o5g9mV29JeJiuxuRpL4JEpkA9GftKTTbntGED54A=
Content-Disposition: inline
In-Reply-To: <20201116055043.20886-1-lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lukas Bulwahn <lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nathan Chancellor <natechancellor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nick Desaulniers <ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, clang-built-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 16, 2020 at 06:50:43AM +0100, Lukas Bulwahn wrote:
> Commit 2ef1bf118c40 ("mm: memcg: deprecate the non-hierarchical mode")
> removed the only use of memcg_has_children() in
> mem_cgroup_hierarchy_write() as part of the feature deprecation.
> 
> Hence, since then, make CC=clang W=1 warns:
> 
>   mm/memcontrol.c:3421:20:
>     warning: unused function 'memcg_has_children' [-Wunused-function]
> 
> Simply remove this obsolete unused function.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> applies cleanly on next-20201113, not on current master
> 
> Roman, please ack.

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
