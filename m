From: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Subject: Re: [PATCH] cgroup: add tracepoints to track cgroup events
Date: Thu, 21 Aug 2014 09:35:41 -0600
Message-ID: <20140821153541.GA7625@Dell>
References: <1408592785-6700-1-git-send-email-andrea@betterlinux.com>
 <20140821141330.GA1766@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=betterlinux.com;
	s=default; t=1408635342;
	bh=QVGwlm7fXpb8n4XDdQsuZawabSNPjf+ISWukI4dk7dA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=YfT18hV/uAoMb+iNiaqIQCEEyx9rRimm12mNZVpYyRpOdDuKRUHr+KXUg+MRmT1Gr
	 PAdxkSymwAqWU4frmTNXCXETHjAVKwP8mhjJcK1G4B2uj46tscnvIwF2Q9kWEJoEKT
	 szXhqEg8r2iWA36e71DhW4bcz6zlP3pVci0iDVxk=
Content-Disposition: inline
In-Reply-To: <20140821141330.GA1766-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Heaton <matt-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>

On Thu, Aug 21, 2014 at 09:13:30AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 20, 2014 at 09:46:25PM -0600, Andrea Righi wrote:
> > This patch adds the following tracepoints:
> >  o trace_cgroup_create       when a new cgroup is created
> >  o trace_cgroup_destroy      when a cgroup is removed
> >  o trace_cgroup_task_migrate when a task/thread is moved from a cgroup to another
> > 
> > The purpose of these tracepoints is to identify and help cgroup "managers" to
> > diagnose problems and detect when they are doing an excessive amount of work.
> 
> Using TPs for this looks like a really roundabout way of doing this
> when the whole interface is based on filesystem.  Extending
> kernfs_notity to support directory events seems like a better way to
> do this.
> 
> Thanks.
> 
> -- 
> tejun

Agreed. Thanks for the suggestion, Tejun.

-Andrea
