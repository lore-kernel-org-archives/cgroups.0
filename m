From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm/page_owner: Dump memcg information
Date: Mon, 31 Jan 2022 19:25:22 +0100
Message-ID: <Yfgpknwr1tMnPkqh@dhcp22.suse.cz>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-4-longman@redhat.com>
 <YfeuK5j7cbgM+Oo+@dhcp22.suse.cz>
 <YfgT/9tEREQNiiAN@cmpxchg.org>
 <YfgnUZQBRkqhrEIb@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643653525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FTFA2b8ZYqmua0W1dg2oBKqfoda+M3kBiT0mJekqZsw=;
        b=XjVzr1CnsL27EfZQj2F2hpCP5vbc4QBXNF1eoFWrbyL2VFCRPnJydl3ZVbHSVp5xUVA7lF
        QwQr3bMoRIBAy7byOQcMSGSh7g7wv07HDD4L3O9V/0Obawh8FZcQ+JUekpCtFpTdW3gypp
        sBg/1U1rWLah6wt4shoX2WxFPps9PYo=
Content-Disposition: inline
In-Reply-To: <YfgnUZQBRkqhrEIb-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon 31-01-22 10:15:45, Roman Gushchin wrote:
> On Mon, Jan 31, 2022 at 11:53:19AM -0500, Johannes Weiner wrote:
> > On Mon, Jan 31, 2022 at 10:38:51AM +0100, Michal Hocko wrote:
> > > On Sat 29-01-22 15:53:15, Waiman Long wrote:
> > > > It was found that a number of offlined memcgs were not freed because
> > > > they were pinned by some charged pages that were present. Even "echo
> > > > 1 > /proc/sys/vm/drop_caches" wasn't able to free those pages. These
> > > > offlined but not freed memcgs tend to increase in number over time with
> > > > the side effect that percpu memory consumption as shown in /proc/meminfo
> > > > also increases over time.
> > > > 
> > > > In order to find out more information about those pages that pin
> > > > offlined memcgs, the page_owner feature is extended to dump memory
> > > > cgroup information especially whether the cgroup is offlined or not.
> > > 
> > > It is not really clear to me how this is supposed to be used. Are you
> > > really dumping all the pages in the system to find out offline memcgs?
> > > That looks rather clumsy to me. I am not against adding memcg
> > > information to the page owner output. That can be useful in other
> > > contexts.
> > 
> > We've sometimes done exactly that in production, but with drgn
> > scripts. It's not very common, so it doesn't need to be very efficient
> > either. Typically, we'd encounter a host with an unusual number of
> > dying cgroups, ssh in and poke around with drgn to figure out what
> > kind of objects are still pinning the cgroups in question.
> > 
> > This patch would make that process a little easier, I suppose.
> 
> Right. Over last few years I've spent enormous amount of time digging into
> various aspects of this problem and in my experience the combination of drgn
> for the inspection of the current state and bpf for following various decisions
> on the reclaim path was the most useful combination.
> 
> I really appreciate an effort to put useful tools to track memcg references
> into the kernel tree, however the page_owner infra has a limited usefulness
> as it has to be enabled on the boot. But because it doesn't add any overhead,
> I also don't think there any reasons to not add it.

Would it be feasible to add a debugfs interface to displa dead memcg
information?
-- 
Michal Hocko
SUSE Labs
