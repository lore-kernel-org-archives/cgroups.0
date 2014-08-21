From: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Subject: Re: [PATCH] cgroup: add tracepoints to track cgroup events
Date: Thu, 21 Aug 2014 11:45:25 -0600
Message-ID: <20140821174525.GC7625@Dell>
References: <1408592785-6700-1-git-send-email-andrea@betterlinux.com>
 <20140821141330.GA1766@mtj.dyndns.org>
 <20140821153541.GA7625@Dell>
 <20140821170002.GB7625@Dell>
 <20140821170701.GA3940@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=betterlinux.com;
	s=default; t=1408643127;
	bh=zUAf3V6bMCwkpIDIPoAY+dshAgKQiVfBT8pqrTU8QXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=KyKrz4tVpXn44DbkMLHxb0uJO8E7nKvJPBwRzKuLbABKFSQRznPsxy/9u2WWnTmhn
	 TSyVPXbBKDF+W9GK2pgwNzXHQAu3jlf/6ZNtZnZHv7nki34EBLp7KFtlNFxJfLS9dS
	 X6MEh2/n7K41+RIWOmES2nh5/QaSPZg+5V625Dmw=
Content-Disposition: inline
In-Reply-To: <20140821170701.GA3940-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Heaton <matt-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>

On Thu, Aug 21, 2014 at 12:07:01PM -0500, Tejun Heo wrote:
...
> > I still need to figure out a smart way to track which PIDs are
> > added/removed to/from cgroup.procs from userland (inotifywait + git? :)),
> > but all the other informations provided by my tracepoint patch seem to
> > be already available via [di]notify.
> 
> Hmmm... yeah, determining exactly which pids got added / removed can
> be cumbersome from just MODIFY events.  That said, what are you trying
> to do with such information?

Just trying to figure out if a particular application/pid is moved too
much across different cgroups, or collect per-pid / per-cgroup
statistics in general.

Thanks,
-Andrea
