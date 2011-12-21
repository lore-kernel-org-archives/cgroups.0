From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2 v2] cgroup: Drop task_lock(parent) on cgroup_fork()
Date: Wed, 21 Dec 2011 18:52:03 +0100
Message-ID: <20111221175201.GE17668@somewhere>
References: <1324432958-20414-1-git-send-email-fweisbec@gmail.com>
 <1324432958-20414-3-git-send-email-fweisbec@gmail.com>
 <4EF14176.9040206@cn.fujitsu.com>
 <20111221024849.GC17668@somewhere>
 <4EF14F7B.2040507@cn.fujitsu.com>
 <20111221175024.GG9213@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hpkX+GZ6quM2DvY1Jbxko8ypiUXGOC4P7JB90f3962A=;
        b=wP9t9OA63cCOWfMpSo3D1TNsNBNrxE/7gA374EJV32YkWjGCVOWVHj+tFqVv9QXm+r
         7+Y78OxmIfyA1ammaBoseWMhTIWYuG3D8nLB2bX/a3qW4qSvhhIqoSzWItwTl3P1kmL6
         diAx+chvO7ZRhE9OXqHUeN3xNXLTlUsSDwmRo=
Content-Disposition: inline
In-Reply-To: <20111221175024.GG9213-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Wed, Dec 21, 2011 at 09:50:24AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Dec 21, 2011 at 11:16:11AM +0800, Li Zefan wrote:
> > So I'll ack this patch.
> 
> Do I have your ack on the first one too?  If so, I'll go ahead and
> apply these two.
> 
> Thanks.

Lemme just update the comment on this one before, I'll resend a new version
quickly, thanks!
