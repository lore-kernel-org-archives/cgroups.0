From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm/page_owner: Dump memcg information
Date: Tue, 1 Feb 2022 11:49:11 +0100
Message-ID: <YfkQJ4QhfY0dICB9@dhcp22.suse.cz>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-4-longman@redhat.com>
 <YfeuK5j7cbgM+Oo+@dhcp22.suse.cz>
 <YfgT/9tEREQNiiAN@cmpxchg.org>
 <YfgnUZQBRkqhrEIb@carbon.dhcp.thefacebook.com>
 <Yfgpknwr1tMnPkqh@dhcp22.suse.cz>
 <12686956-612d-d89b-5641-470d5e913090@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643712552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l6Bn0nz2rnpcXkXYw/gRthu/0RqSHCGbN5yIH2/zMno=;
        b=LsrFLxhXhW9MQ5itj+U/rbYQQCU2+RZgxSgqRPFPCH62iHD/1uuU1u+XTeTmuwRN7c3vBl
        7xp0WzHh84RoSxn0EONv306e8MJ1H89YhCsuKp+FnGzVoE92rGb1n/4pI20rWUQi1J/SmO
        giL7UgDUxBg/dDgNhnO46MAaplPB8qo=
Content-Disposition: inline
In-Reply-To: <12686956-612d-d89b-5641-470d5e913090-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon 31-01-22 13:38:28, Waiman Long wrote:
[...]
> Of course, it is also possible to have a debugfs interface to list those
> dead memcg information, displaying more information about the page that pins
> the memcg will be hard without using the page owner tool.

Yes, you will need page owner or hook into the kernel by other means
(like already mentioned drgn). The question is whether scanning all
existing pages to get that information is the best we can offer.

> Keeping track of
> the list of dead memcg's may also have some runtime overhead.

Could you be more specific? Offlined memcgs are still part of the
hierarchy IIRC. So it shouldn't be much more than iterating the whole
cgroup tree and collect interesting data about dead cgroups.

-- 
Michal Hocko
SUSE Labs
