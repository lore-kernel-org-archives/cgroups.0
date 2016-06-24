From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Fri, 24 Jun 2016 12:35:27 -0400
Message-ID: <20160624163527.GZ3262@mtj.duckdns.org>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623213819.GP3262@mtj.duckdns.org>
 <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
 <20160624154830.GX3262@mtj.duckdns.org>
 <20160624155916.GA8759@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9y4xfIBn/C1tlfOQNZsVsZjWj76s3nFl71fq28AZrOU=;
        b=Px02iOeKme9OK1EvfgZ+kxYV1lAg0jCWBsZTbT5z2RJ97L6mB2k+cV7R/jFe3uyZai
         zS++rrIoFErPJHfMJ58wTXcRBtRGe+1tf13yjPSObYLP3Ujgst9gySXQOjXAPo5PCRc+
         fdZJVXxyN2bwu36iHxEODdVU8mwFQdFhIRNTImWdn5r7J6jromc9wrOi1QDuLLNuVb2o
         WZV6U1nVxImc31a8hQtnzrRnBIqc9qap7kGPmmW3HujRIKwe5MADgsN6RJ1DagLfKA59
         T0beO2Z2RX1ufgmlweEVo6z35jpOiOoKMe6k77hAI251k6IijVTvufHRXkHzT1vnPapD
         AbgQ==
Content-Disposition: inline
In-Reply-To: <20160624155916.GA8759-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CAPABILITIES" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Fri, Jun 24, 2016 at 10:59:16AM -0500, Serge E. Hallyn wrote:
> Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> > But isn't being recursive orthogonal to using cgroup?  Why not account
> > usages recursively along the process hierarchy?  Capabilities don't
> > have much to do with cgroup but everything with process hierarchy.
> > That's how they're distributed and modified.  If monitoring their
> > usages is necessary, it makes sense to do it in the same structure.
> 
> That was my argument against using cgroups to enforce a new bounding
> set.  For tracking though, the cgroup process tracking seems as applicable
> to this as it does to systemd tracking of services.  It tracks a task and
> the children it forks.

Just monitoring is less jarring than implementing security enforcement
via cgroup, but it is still jarring.  What's wrong with recursive
process hierarchy monitoring which is in line with the whole facility
is implemented anyway?

Thanks.

-- 
tejun
