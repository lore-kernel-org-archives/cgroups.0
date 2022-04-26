From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 1/4] memcg: introduce per-memcg reclaim interface
Date: Tue, 26 Apr 2022 10:22:42 +0200
Message-ID: <Ymer0qeaJlRY1Ju6@dhcp22.suse.cz>
References: <20220425190040.2475377-1-yosryahmed@google.com>
 <20220425190040.2475377-2-yosryahmed@google.com>
 <a4c3d067-d08d-409d-e7b-b6e0b1d2dfda@google.com>
 <CAJD7tka_96du2UUx0xuseR62wu005-KPf7fSyDTAuXOWsgUQDg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650961366; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NKbpFjMDPqd7TQ514NLGknGrSkR1xvTuZ+twvGBw1Ds=;
        b=Ku8RBnA0Rf9zQsz4S8BTrgHF20lahZ8buxMT5bsutog3s+qQEzlQpjXalln29/WK/9rWTe
        y/9DNr88hxHzQwcPkYA9KVTaL8FZ7DTVb/ZbTuzWAufvvhtv6te6DXO8ZUj85HjsIehW/n
        qbSDE3xjlsTQgKOtmALRZ+WjV1K1F3E=
Content-Disposition: inline
In-Reply-To: <CAJD7tka_96du2UUx0xuseR62wu005-KPf7fSyDTAuXOWsgUQDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon 25-04-22 12:31:51, Yosry Ahmed wrote:
> On Mon, Apr 25, 2022 at 12:15 PM David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
[...]
> > "can over or under reclaim from the target cgroup" begs the question of
> > how much more memory the kernel can decide to reclaim :)  I think it's
> > assumed that it's minimal and that matches the current implementation that
> > rounds up to SWAP_CLUSTER_MAX, though, so looks good.
> >
> > Thanks Yosry!
> 
> I think it could be more complex than this. Some functions that get
> called during reclaim only use the nr_to_reclaim parameter to check if
> they need one more iteration, but not to limit the actual reclaimed
> pages per say. For example, nr_to_reclaim is not even passed to
> shrink_slab() or mem_cgroup_soft_limit_reclaim(), so they have no way
> to know that they should stop if nr_to_reclaim was already satisfied.
> I think the general assumption is that each of these calls normally
> does not reclaim a huge number of pages, so like you said, the kernel
> should not over-reclaim too much. However, I don't think there are
> guarantees about this.

There are no guarantees indeed and it si definitely good to be explicit
about that so that userspace tools expect that and consider that in
the imeplementation. Sure we do not want to go overboard and huge excess
should be considered a bug. I am not sure we do agree on the notion of
"huge" so let's see.
-- 
Michal Hocko
SUSE Labs
