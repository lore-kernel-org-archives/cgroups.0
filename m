From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: status-quo and userland efforts
Date: Thu, 27 Jun 2013 11:01:43 -0700
Message-ID: <20130627180143.GD5599@mtj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org>
 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+zLiWc+PVMXzZmjo4tlLE0ZNjfl8N661AFZPfkRdIh0=;
        b=Wtw7YvMJjTnUWwmz65aOnzOevhGn7uWzUvfQy4g6R4W27qIfj4WhHEJLdmbLSxcX/B
         POx5dry22wUw+iBsxGoHe3J7pbeYMsLJC2MGPIyVzMAQxCgL3qBdu5+/cU6tYQR051Cq
         fNlzgtUrPyDapoWfo2aCGqtTu9/7/Qn3ycKGhG+jYY0vTwj/iM2lR1A1Xe8iMeRHkKbR
         /WDlkbnfRxz2l/THNdP8ZtQVlnKcxXnVoJQWNtX4coBP8M/XuKb1rdSKfXqkZjePLzTq
         iHmQ66wJRrVVlz+kyfha7HgDikXmgUGeembXr3jtky9VeilYose7jAojMteuYTHPnFPQ
         75Fg==
Content-Disposition: inline
In-Reply-To: <1372311907.5871.78.camel-YqMYhexLQo31wTEvPJ5Q0F6hYfS7NtTn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <bitbucket-BGeptl67XyCzQB+pC5nmwQ@public.gmane.org>
Cc: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bsingharora <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dhaval.giani" <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, jpoimboe <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lpoetter <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, workman-devel <workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Mike.

On Thu, Jun 27, 2013 at 07:45:07AM +0200, Mike Galbraith wrote:
> I can understand some alarm.  When I saw the below I started frothing at
> the face and howling at the moon, and I don't even use the things much.

Can I ask why?  The reasons are not apparent to me.

> http://lists.freedesktop.org/archives/systemd-devel/2013-June/011521.html
> 
> Hierarchy layout aside, that "private property" bit says that the folks
> who currently own and use the cgroups interface will lose direct access
> to it.  I can imagine folks who have become dependent upon an on the fly
> management agents of their own design becoming a tad alarmed.

They're gonna be able to do what they've been doing for the
foreseeable future if they choose not to use systemd's unified
resource management.  That said, what we have today is pretty lousy
and a lot of hierarchical stuff were completely broken until some
releases ago and things *must* have been broken on the userland side
too.  It could have worked for their specific setup but I strongly
doubt there are anything generic working well out in the wild.  cgroup
hasn't been capable of supporting something like that.

AFAICS, having a userland agent which has overall knowledge of the
hierarchy and enforcesf structure and limiations is a requirement to
make cgroup generally useable and useful.  For systemd based systems,
systemd serving that role isn't too crazy.  It's sure gonna have
teeting issues at the beginning but it has all the necessary
information to manage workloads on the system.

A valid issue is interoperability between systemd and non-systemd
systems.  I don't have an immediately good answer for that.  I wrote
in another reply but making cgroup generally available is a pretty new
effort and we're still in the process of figuring out what the right
constructs and abstractions are.  Hopefully, we'll be able to reach a
common set of abstractions to base things on top in itme.

Thanks.

-- 
tejun
