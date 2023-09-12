From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Tue, 12 Sep 2023 13:03:00 +0200
Message-ID: <ZQBFZMRL8WmqRgrM@dhcp22.suse.cz>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-5-yosryahmed@google.com>
 <ZPX0kCKd4TaVLJY7@dhcp22.suse.cz>
 <CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com>
 <ZP8SDdjut9VEVpps@dhcp22.suse.cz>
 <CAAPL-u8NndkB2zHRtF8pVBSTsz854YmUbx62G7bpw6BMJiLaiQ@mail.gmail.com>
 <ZP9rtiRwRv2bQvde@dhcp22.suse.cz>
 <CAAPL-u9XwMcrqVRu871tGNKa3LKmJSy9pZQ7A98uDbG6ACzMxQ@mail.gmail.com>
 <ZP92xP5rdKdeps7Z@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694516581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2ueVFGBowAWqGipfNQqUaUPs7n50soYsOXj5+ijJC44=;
        b=QtRF3jYdgfuACICva/StORZig/bbcCipPnzhVC2F+GBibpItfwEZroTW4ipaKaDUcEYrci
        CIdZ6hWQ6nZI17dJMYDjydq7tl5/V9H1nOPckllPAQlAkuUNPxXzDulaN8ZBxrsOXiLp91
        A+MUbTATQKvgsJiK3kpJGdkLyxR3GwQ=
Content-Disposition: inline
In-Reply-To: <ZP92xP5rdKdeps7Z-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon 11-09-23 10:21:24, Tejun Heo wrote:
> Hello,
> 
> On Mon, Sep 11, 2023 at 01:01:25PM -0700, Wei Xu wrote:
> > Yes, it is the same test (10K contending readers). The kernel change
> > is to remove stats_user_flush_mutex from mem_cgroup_user_flush_stats()
> > so that the concurrent mem_cgroup_user_flush_stats() requests directly
> > contend on cgroup_rstat_lock in cgroup_rstat_flush().
> 
> I don't think it'd be a good idea to twist rstat and other kernel internal
> code to accommodate 10k parallel readers.

I didn't mean to suggest optimizing for this specific scenario. I was
mostly curious whether the pathological case of unbound high latency due
to lock dropping is easy to trigger by huge number of readers. It seems
it is not and the mutex might not be really needed as a prevention.

> If we want to support that, let's
> explicitly support that by implementing better batching in the read path.

Well, we need to be able to handle those situations because stat files
are generally readable and we do not want unrelated workloads to
influence each other heavily through this path.

[...]

> When you have that many concurrent readers, most of them won't need to
> actually flush.

Agreed! 
-- 
Michal Hocko
SUSE Labs
