From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: Implement cgroup2 basic CPU usage accounting
Date: Sun, 13 Aug 2017 12:44:21 -0700
Message-ID: <20170813194421.GB1438922@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
 <e9682f27-a23c-802c-daed-e49fc9d4613c@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/oUjGZEzRR1POR3sBhYtsRDUQoLd4zLcHeXlEJu1Ht4=;
        b=RTbwCzLCnILD5YYyiZj1ZoMOOOnYspvApIGhVfY+XQ+u6KlbEb5eA03SHjNAnMJbyA
         3lVHBy4qHuhGFSwd6EcL7HeESkQ19VIK1+6ORNz48fAvacDYclmKOSJEgdxZVGCmU3Xz
         GnzyUNDM0mQcYAJEEgkWXSt5oIZcIMgyhr4CBWPav6sozJCvOVIck7WO952evW4FhR/h
         cRHdJsz58RwX967zKIQJ0C8hP5yVjfLC7fSFQndqrP2UJUVF308M3Upbwz5ogA37GDC+
         b7v9qFMwWoYaB0ECuuukRF5mFUkQzxdseC2/WRGLSovYV+vxSd0CFEYyTCxC/j5RimjM
         Vl2Q==
Content-Disposition: inline
In-Reply-To: <e9682f27-a23c-802c-daed-e49fc9d4613c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello, Waiman.

On Fri, Aug 11, 2017 at 04:19:07PM -0400, Waiman Long wrote:
> > * CPU usage stats are collected and shown in "cgroup.stat" with "cpu."
> >   prefix.  Total usage is collected from scheduling events.  User/sys
> >   breakdown is sourced from tick sampling and adjusted to the usage
> >   using cputime_adjuts().
> 
> Typo: cputime_adjust()

Oops, will fix.

> > +static DEFINE_MUTEX(cgroup_stat_mutex);
> > +static DEFINE_PER_CPU(raw_spinlock_t, cgroup_cpu_stat_lock);
> 
> If the hierarchy is large enough and the stat data hasn't been read
> recently, it may take a while to accumulate all the stat data even for
> one cpu in cgroup_stat_flush_locked(). So I think it will make more
> sense to use regular spinlock_t instead of raw_spinlock_t.

They need to be raw spinlocks because the accounting side may grab
them while scheduling.  If the accumulating latency becomes
problematic, we can test for need_resched and spin_needbreak and break
out as necessary.  The iteration logic is built to allow that and an
earlier revision actually did that but I wasn't sure whether it's
actually necessary and removed it for simplicity.

If the latency ever becomes a problem, resurrecting that isn't
difficult at all.

> > +static struct cgroup *cgroup_cpu_stat_next_updated(struct cgroup *pos,
> > +						   struct cgroup *root, int cpu)
> 
> This function is trying to unwind one cgrp from the updated_children and
> updated_next linkage. It is somewhat like the opposite of
> cgroup_cpu_stat_updated(). I just feel like its name isn't intuitive
> enough to convey what it is doing. Maybe use name like
> cgroup_cpu_stat_unlink_one() to match cgroup_cpu_stat_flush_one().

Hmm... the name comes from it being an iterator - most interators are
named _next.  But, yeah, the name doesn't signifiy that it unlinks as
it goes along.  I'll rename it to cgroup_cpu_stat_pop_updated().

Thanks.

-- 
tejun
