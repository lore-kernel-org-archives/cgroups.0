From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
Date: Tue, 21 Aug 2012 14:48:56 -0700
Message-ID: <20120821214856.GC32596@google.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174454.087507415@napanee.usersys.redhat.com>
 <20120816200006.GG24861@google.com>
 <50340110.50607@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RR8nV+OLCxJgzF7HmwnCbiAT6jT6h7qLsTB+Hz2LUjc=;
        b=ot4YejHnXtDl8OlawTWVXfLVaKnfJxm7fcT3Ek+qpEne5j3dqPf7ZHIJtxG6XlxKlp
         QepJ96+Npma2ulSXNR/ILU4UKC60juzdmpArSzI7AWh+8g3Npunv17ZBrzLrGiuuAk9V
         oZKBL/eHHdqGUNZgct7KPmqJ7vO4Iw2eTUuwrzgviVkjVPrrMMauYYl+saOC/4THpOdF
         /8WFNTFcBbVH92eS6rurPZQeYcK0VrfO3UYcfZA1ja7rwt8PZVYdvGNWtolK/xtpVXZV
         L+IVzkbFJuQ6TV9gEs0dVMC6ibIQE8gvOuiqdmcTQ4+OSNvp9lSdgXWPWnkA2ce9al7R
         QLeg==
Content-Disposition: inline
In-Reply-To: <50340110.50607-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello,

On Tue, Aug 21, 2012 at 11:43:44PM +0200, Lennart Poettering wrote:
> >I'm not against this but unsure whether using kmem is enough for the
> >suggested use case.  Lennart, would this suit systemd?  How much
> >metadata are we talking about?
> 
> Just small things, like values, PIDs, i.e. a few 100 bytes or so per
> cgroup should be more than sufficient for our needs.

Alright, then.  I think there's gonna be one more round to address
Hugh's comments.  Hugh, how should this be routed?  Is there some git
branch that tmpfs changes can go in so that cgroup tree can pull?

Thanks.

-- 
tejun
