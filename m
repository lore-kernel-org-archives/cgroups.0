From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Bug in cgroup_do_mount()?
Date: Tue, 13 Jun 2017 11:11:43 -0400
Message-ID: <20170613151143.GD28327@htj.duckdns.org>
References: <25030.1497364047@warthog.procyon.org.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u0syEBK5ANXUNMTK9FoVvjS6PIhjMYIAsWiXYWFYHRA=;
        b=npypFqKF7IWsktyJSi38KYiByu3f2at5tjlR11/DoqYG1afak0WLBiwcrXx0USgK8O
         7zcxXEdoPLiVZQB5bNLqSSmO4bRa53rqEm1mEEorbjM1MpY1TvuVcG7b2lQxIRfh17NH
         muaHhZSJH2NNF5Tjjg3VNLvMbZw70bE/xJdXdGGGsTovHBhy/xlWIYQg79gV8bgucEEi
         pmk7RAm8v2V57Z+3abhuGAUb8QCG5dL19geU+Ksdtx3cdDQb5z+IggHuRaMLnISDlK8n
         oryEymYKeuNolY+/k0uvXPnbY3W/qPW+Z4tT1fJeU/God8A1ANWAN9TzyGGs8Klujkdu
         YxiQ==
Content-Disposition: inline
In-Reply-To: <25030.1497364047-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, David.

On Tue, Jun 13, 2017 at 03:27:27PM +0100, David Howells wrote:
> I'm having a go at converting cgroups to use my fs_context stuff, and I've
> spotted a potential bug in the existing code.  In cgroup_do_mount(), there is
> the following snippet:
> 
> 		mutex_lock(&cgroup_mutex);
> 		spin_lock_irq(&css_set_lock);
> 
> 		cgrp = cset_cgroup_from_root(ns->root_cset, root);
> 
> 		spin_unlock_irq(&css_set_lock);
> 		mutex_unlock(&cgroup_mutex);
> 
> 		nsdentry = kernfs_node_dentry(cgrp->kn, dentry->d_sb);
> 
> Given that locks must be taken to call cset_cgroup_from_root(), is the value
> of cgrp trustworthy once the locks are dropped?

Heh, yeah, that does look suspicious.  The css_set_lock is protecting
the list structure itself and cgroup_mutex is required to exclude
cgroup destruction and migration; however, the ns is pinning the
root_cset which is immutable and in turn pins the cgroups which are
associated with it, so the cgroup will stay pinned even after the
mutex is dropped.

The mutex lock there is to satisfy the lockdep assertion inside
cset_cgroup_from_root().  We definitely should add a comment there
explaining what's going on.

Thanks.

-- 
tejun
