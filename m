From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Workqueue lockup: Circular dependency in threads
Date: Tue, 5 Sep 2017 06:22:43 -0700
Message-ID: <20170905132242.GA1774378@devbig577.frc2.facebook.com>
References: <1504101538-20075-1-git-send-email-prsood@codeaurora.org>
 <bc1016ee-792e-87f8-5158-777b7f9405b8@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QKZObg/ojEh3jXx6Xi5FQESJF6Sn56c6+f24loHYJw0=;
        b=KhFHnF2DmPjMrLZPrHXoNNkSeCRtCIeQRNNG06NkKfAV6CeqFJNVQxNbaaGXenF+XF
         iE1qBCsPeEnxU9usWpnC4YVadm1gaQN5E+C6yy/HQ4uVJ2Qmjv9xf3cMNfP5ZrKcHITw
         2eULyTwRTXrgnmmvPH3BaQLkXqL4DZvaSAoYBzIs7ZdCflfv+mIIqODDkPARG1497Dpy
         naRFxeWD7SA6MfC351k5MiN6WmWBZFNzS9Ap8Umh8yvGooFilye18P1Hi1NrpUSSG5DW
         3codse1s9tYBXY0dM/uYmEkGcKDuqMzRKDrkkuZjFdJTTWEOhhNbmRdzdm3cPGbxi7wA
         vwJQ==
Content-Disposition: inline
In-Reply-To: <bc1016ee-792e-87f8-5158-777b7f9405b8-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, apkm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello,

On Thu, Aug 31, 2017 at 06:43:56PM +0530, Prateek Sood wrote:
> > 6) cpuset_mutex is acquired by task init:1 and is waiting for cpuhotplug lock.

Yeah, this is the problematic one.

> > We can reorder the sequence of locks as in the below diff to avoid this
> > deadlock. But I am looking for inputs/better solution to fix this deadlock.
> > 
> > ---
> > diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> >  /**
> >   * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
> >   * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
> > @@ -930,7 +946,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
> >  	rcu_read_unlock();
> >  
> >  	if (need_rebuild_sched_domains)
> > -		rebuild_sched_domains_locked();
> > +		rebuild_sched_domains_unlocked()(without taking cpuhotplug.lock)
> >  }
> >  
> >  /**
> > @@ -1719,6 +1735,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
> > +	get_online_cpus();
> >  	mutex_lock(&cpuset_mutex);
> >  	if (!is_cpuset_online(cs))
> >  		goto out_unlock;
> > @@ -1744,6 +1761,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
> >  	mutex_unlock(&cpuset_mutex);
> > +	put_online_cpus();
> >  	kernfs_unbreak_active_protection(of->kn);
> >  	css_put(&cs->css);
> >  	flush_workqueue(cpuset_migrate_mm_wq);
> > 

And the patch looks good to me.  Can you please format the patch with
proper description and sob?

Thanks.

-- 
tejun
