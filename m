From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol:rewrite mem_cgroup_page_lruvec()
Date: Thu, 5 Nov 2020 10:53:31 -0500
Message-ID: <20201105155331.GE744831@cmpxchg.org>
References: <20201104142516.GA106571@rlk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A3JA9WEFpRuCAbhY2DBNk/bNA/HrXMr9AT46oTgaBJc=;
        b=iE2JW9bLmeyDb8+yOQGwPSMgBWXGejaZMqGA4cvyWkomZy8WrhWPWjVl/6AlmObyKl
         iUvEVobpJggmpeNwPzM0+B4lsSQYI0RGUFGlU+GaKYmNYjeL7RlgXRaOU5vu7BpLmKLz
         b6d5uerULC4QbQ4GTFrYFH9vVziu7NUf2IOv/Gqw+8Yi0bHtTQ2zd7xuJsn5ieVGqJ2/
         8bSXkOZyKtBcrYstoI8nMWWG9zuCuNjvIPHMT/g+lWlruh+BRNpQUCAGXi18LnRPKpgz
         W1KIdVcHHWs2RqTY3NHosrKq8wStbQjj0A16XDgRpYAQMnPZifnI/1QB6PdcMzllpXjs
         ruhg==
Content-Disposition: inline
In-Reply-To: <20201104142516.GA106571@rlk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Nov 04, 2020 at 10:25:16PM +0800, Hui Su wrote:
> mem_cgroup_page_lruvec() in memcontrol.c and
> mem_cgroup_lruvec() in memcontrol.h is very similar
> except for the param(page and memcg) which also can be
> convert to each other.
> 
> So rewrite mem_cgroup_page_lruvec() with mem_cgroup_lruvec().
> 
> Signed-off-by: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>

Nice.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
