From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] capabilities: audit capability use
Date: Tue, 12 Jul 2016 10:59:36 -0400
Message-ID: <20160712145936.GH3190@htj.duckdns.org>
References: <1468235672-3745-1-git-send-email-toiwoton@gmail.com>
 <20160711170711.GB3337@htj.duckdns.org>
 <683cdbb9-c414-07c7-16d3-41c4138ddf8d@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+2ieaLoA/lyfNovAcl5Hr2Qzb5MTFvXhALQYbXnwVGs=;
        b=iSKLOHr69JPsXrkF98NrzLg9lP88jbCTlL6yO99l8zoNYsucfqBnDt26Y8e0SZnOjJ
         9smiIXM+DyKzEhGuxG81QHxldNU3E2HL7ItRqgdTR5Ky2spydZ5kjyF21+mdA7V07GXm
         ZYTOx8gcMd1o07dtqMxaBzq/u8B12qDrjNjSEs43ogFVXGzLNygel3vcZpQkg/hNXBmJ
         Lw57d90O8lh0+ur0hOqRCsB1GE9ZPpyxS7RzDmZmfM+1EYBQFBpMLVrP6l+qz13JplDc
         BuXMZZkPdjnMn4WENjp0CMjqIygYae6VWCd1bWAWDLLmipcgwY+eK/HQxKtvQa0iZM4h
         BisA==
Content-Disposition: inline
In-Reply-To: <683cdbb9-c414-07c7-16d3-41c4138ddf8d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, pmladek-IBi9RG/b67k@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "moderated list:AUDIT SUBSYSTEM" <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CAPABILITIES" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jul 11, 2016 at 07:47:44PM +0000, Topi Miettinen wrote:
> It's really critical to be able to associate a task in the logs to
> cgroups which were valid that time. Or can we infer somehow what cgroups

When is "that time"?  Without logging all operations, this is
meaningless.

> a task was taking part, long time after task exit? Perhaps task cgroup
> membership changes and changes in available cgroups should be logged too?
> 
> Some kind of cgroup IDs could be logged instead of long paths. Then
> these IDs should be reliably resolvable to paths offline somehow.

I don't think that's doable.  That pretty much requires the kernel to
remember paths of all past cgroups.

> How usual migrations between cgroups are? Why would a task ever move
> from (say) systemd/system.slice/smartd.service to anywhere else?

In most cases, they won't move once set up initially but that's not
the point of audit subsystem.  Logging this once one exit isn't gonna
help anything for auditing the system.

Thanks.

-- 
tejun
