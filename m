From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: remove extra calls to find_existing_css_set
Date: Thu, 5 Jan 2012 09:35:30 -0800
Message-ID: <20120105173530.GB18486@google.com>
References: <1325654312-32477-1-git-send-email-msb@chromium.org>
 <1325654312-32477-3-git-send-email-msb@chromium.org>
 <4F0506B1.1070909@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=js7nrpF6UMebgmLj50lDCZ4FiV5NCmFAu33WGraTHH0=;
        b=L3kJnZH7ZOCoD+SKd59y1G/tLc7PhhiylQeajO9EVmjOISVkjxi/5i2eUdDIr7QG17
         6VofRMSXgrRVZujfOB2r7Zg7ibjRniQgcnFk4HTN5JA13uA/+jubxN8NcL86clqvwqsT
         cdfZa9AEEnuOQV6+Q5U2eL2zoAFrS2cVTmdh0=
Content-Disposition: inline
In-Reply-To: <4F0506B1.1070909-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

Hello, guys.

On Thu, Jan 05, 2012 at 10:10:57AM +0800, Li Zefan wrote:
> Mandeep Singh Baines wrote:
> > In cgroup_attach_proc, we indirectly call find_existing_css_set 3
> > times. It is an expensive call so we want to call it a minimum
> > of times. This patch only calls it once and stores the result so
> > that it can be used later on when we call cgroup_task_migrate.
> > 
> > This required modifying cgroup_task_migrate to take the new css_set
> > (which we obtained from find_css_set) as a parameter. The nice side
> > effect of this is that cgroup_task_migrate is now identical for
> > cgroup_attach_task and cgroup_attach_proc. It also now returns a
> > void since it can never fail.
> > 
> > Changes in V4:
> > * https://lkml.org/lkml/2011/12/22/421 (Li Zefan)
> >   * Avoid GFP_KERNEL (sleep) in rcu_read_lock by getting css_set in
> >     a separate loop not under an rcu_read_lock
> > Changes in V3:
> > * https://lkml.org/lkml/2011/12/22/13 (Li Zefan)
> >   * Fixed earlier bug by creating a seperate patch to remove tasklist_lock
> > Changes in V2:
> > * https://lkml.org/lkml/2011/12/20/372 (Tejun Heo)
> >   * Move find_css_set call into loop which creates the flex array
> > * Author
> >   * Kill css_set_refs and use group_size instead
> >   * Fix an off-by-one error in counting css_set refs
> >   * Add a retval check in out_list_teardown
> > 
> > Signed-off-by: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> 
> Acked-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

I like this series but it's too late for the current merge window.
I'll apply them on for-3.4 once this merge window closes.  If I don't,
please ping me.

Thank you.

-- 
tejun
