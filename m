From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: separate out cgroup_attach_proc error
 handling code
Date: Tue, 20 Dec 2011 16:13:47 -0800
Message-ID: <20111221001347.GQ10752@google.com>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
 <1324422873-31001-6-git-send-email-msb@chromium.org>
 <20111220233502.GN10752@google.com>
 <20111221000231.GX13529@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=BemFeTl3KaOWZ4aSMyKCwAXZHY707E/dGLh8YjWBDPg=;
        b=BwsmOdyTa3q+ut1oKbM41ZbP3wD20bTEunoakyyVWlQ55zHBt/kC6rVwNTHlJ0IJ8k
         B6s8zGZhxHPyXMeVflgNjTl/XuY93y/lyP9vvRe8Sxb/wQ7oP36aRNclGk/SlWayg5vm
         asgnX7R6IdZnTcM1CvV3YdCoQxjGnnTkRnjm0=
Content-Disposition: inline
In-Reply-To: <20111221000231.GX13529-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

On Tue, Dec 20, 2011 at 04:02:31PM -0800, Mandeep Singh Baines wrote:
> > Hmm... maybe goto out_free_group_list?  Duplicating cleanup on success
> > and failure paths can lead future updaters forget one of them.  The
> > exit path in this function isn't pretty but I don't think the proposed
> > patch improves it either.
> > 
> 
> Should I drop the patch or add the goto? Its 5/5 so easy enough to drop
> since nothing else depends on it.

Yeah, let's drop it for now.  Thanks.

-- 
tejun
