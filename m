From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: Implement cgroup2 basic CPU usage accounting
Date: Thu, 17 Aug 2017 06:13:59 -0700
Message-ID: <20170817131359.GC3238792@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
 <20170817120741.GA22854@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6J7d9gOiY4GBw0aAddIbHRxIzePiLjyMySce7OWEfbI=;
        b=bllNcApMecT/dENXVg9V4/71JtFjfzTF3fPJXeBmScwZoLD5zwFN7wJFtqWz8u+HBg
         Oc2pKbNDcxFRMxrTuGOlEl3zsQXcguy0QgXKMSw0JuvsdRZmFH6jTrbksI69pzQZLkwO
         hbQ/3E02DUZIGo8OVFDjChvV0DQVdx3a2hKVtKkDstxTXez4LUcldZ9WEKpsh/OyD8ab
         T4YxW7fMd3KypGEw6xhl/vWeHADIyoYogM9m8Gz1xdtfKI7SaeWjrInLQufRsRgbuSiT
         5xnRd/7AKCQ/ZhcNXiHgKBi8sI4vioiaBgB7BRPuOUDJiK2CbD8kUiJ8uUnf4zgCqixy
         E4Rw==
Content-Disposition: inline
In-Reply-To: <20170817120741.GA22854-B3w7+ongkCiLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello,

On Thu, Aug 17, 2017 at 01:07:41PM +0100, Roman Gushchin wrote:
> On Fri, Aug 11, 2017 at 09:37:54AM -0700, Tejun Heo wrote:
> > In cgroup1, while cpuacct isn't actually controlling any resources, it
> > is a separate controller due to combinaton of two factors -
> 
> s/combinaton/combination

Fixed.

> > @@ -4466,6 +4470,8 @@ static void css_free_work_fn(struct work_struct *work)
> >  			 */
> >  			cgroup_put(cgroup_parent(cgrp));
> >  			kernfs_put(cgrp->kn);
> > +			if (cgroup_on_dfl(cgrp))
> > +				cgroup_stat_exit(cgrp);
> 
> It looks like this "if (cgroup_on_dfl(cgrp))" works here and further similar to
> "#ifdef CGROUP_V2". I wonder, if it's better to move this check into the
> calling function: cgroup_stat_exit() in this case.

I have a slight preference to keeping these topology-aware tests on
the core / management part of code because that makes it obvious that
these stats aren't available for all cgroups.  Also, during cgroup
creation, because @cgrp isn't linked to its parent yet, we'd have to
pass @parent to cgroup_stat_init/exit() too.

> > +void cgroup_stat_show_cputime(struct seq_file *seq, const char *prefix)
> > +{
> 
> What are any other possible prefix values except "cpu."?

Empty string when the stats are exposed through cpu.stat.

> > +void __init cgroup_stat_boot(void)
> > +{
> > +	int cpu;
> > +
> > +	for_each_possible_cpu(cpu)
> > +		raw_spin_lock_init(per_cpu_ptr(&cgroup_cpu_stat_lock, cpu));
> > +
> > +	WARN_ON(cgroup_stat_init(&cgrp_dfl_root.cgrp));
> 
> I'm not sure WARN_ON() is enough here: if cgroup_stat_init() returned -ENOMEM,
> the following OOPS is not avoidable, as you don't check cpu_stat pointer.
> But it's very unlikely, of course.

Sure, will switch to BUG_ON().

Thanks.

-- 
tejun
