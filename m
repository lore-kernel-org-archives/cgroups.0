From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/51] memcg: add mem_cgroup_root_css
Date: Wed, 17 Jun 2015 14:25:00 -0400
Message-ID: <20150617182500.GI22637@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-7-git-send-email-tj@kernel.org>
 <20150617145642.GI25056@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=sdGqp/FfDeO4ZOBLz/QiKA3k90RouSvpSINa+kbEieo=;
        b=Hb5n9iQZWQSTIpVTSLreZx9IucuEl787XLsaqW1DhmRum8ejxwbTbdxU586hR0h6a0
         AAOVj96paGc4O/u60yj+BC2BXen9tJwnWUIb+PCbKE6LlY4LzStQVroQX+UFCXr2GkO7
         ovtnOj9Qa03FQ5DupglpfN/PFlRqinwOrtO66CTKJH5V7+AMDZa4hqr8RIBrEQe8gVwl
         2aRc2mhxo2NNj8NCWEiiL1lsYwL4uxg7bX6EgREilt1Zuk5ACZwP411XplsViXHMO9FU
         AfUjvQ6v5zZj+ydqpAZmWe43nVLvtJqJdw7zZ4smkV7W947p66SuWrWPCK2/KH1dEPQy
         K3JA==
Content-Disposition: inline
In-Reply-To: <20150617145642.GI25056-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

Hey, Michal.

On Wed, Jun 17, 2015 at 04:56:42PM +0200, Michal Hocko wrote:
> On Fri 22-05-15 17:13:20, Tejun Heo wrote:
> > Add global mem_cgroup_root_css which points to the root memcg css.
> 
> Is there any reason to using css rather than mem_cgroup other than the
> structure is not visible outside of memcontrol.c? Because I have a
> patchset which exports it. It is not merged yet so a move to mem_cgroup
> could be done later. I am just interested whether there is a stronger
> reason.

It doesn't really matter either way but I think it makes a bit more
sense to use css as the common type when external code interacts with
cgroup controllers.  e.g. cgroup writeback interacts with both memcg
and blkcg and in most cases it doesn't know or care about their
internal states.  Most of what it wants is tracking them and doing
some common css operations (refcnting, printing and so on) on them.

> > This will be used by cgroup writeback support.  If memcg is disabled,
> > it's defined as ERR_PTR(-EINVAL).
> 
> Hmm. Why EINVAL? I can see only mm/backing-dev.c (in
> review-cgroup-writeback-switch-20150528 branch) which uses it and that
> shouldn't even try to compile if !CONFIG_MEMCG no? Otherwise we would
> simply blow up.

Hmm... the code maybe has changed inbetween but there was something
which depended on the root css being defined when
!CONFIG_CGROUP_WRITEBACK or maybe it was on blkcg_root_css and memcg
side was added for consistency.  An ERR_PTR value is non-zero, which
is an invariant which is often depended upon, while guaranteeing oops
when deref'd.

Thanks.

-- 
tejun
