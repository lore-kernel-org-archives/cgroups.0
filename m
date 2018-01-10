From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting /sys/kernel/cgroup files
Date: Wed, 10 Jan 2018 05:23:32 +0100
Message-ID: <CAKgNAkhk-527Rh6tGYJO-U3UXgwBC1+t5nB+5JEq62nTO2p15A@mail.gmail.com>
References: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=1flYUag69IveTuaRohQAz2qw7qrCONfO+ficr4qxRBA=;
        b=JTjhXOWE6yobWEhwIsHDNkVVP8+GoZWw3z+vfeT5fCOY5A73VOHqESDqRYFP+3qwfp
         2zXNLL9r9SVJpzQf43E8w8YZv/jr0gfKJMdfw2Em7xJ9B/FC4yTk75REoS+6kB8Qel/X
         XHokRLUlv+vQhVcffpKyTwP4ZhM6g9ORDxparE6rKpUR38PfRqEViU7lgokay4CVQFo6
         uS+lLSMEhSEy4+Vbv3KsnTK239EZiykBNSm94i2UnmyQLFhr6w9x+tQ2fk8NTTu/i5m9
         c85PK6MF34iFWiBP4otfJcBz9djBsEBDpnL8E+ptoX4rrYPQNNMefpKKFE6Zy6n+33Sz
         AKRA==
In-Reply-To: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Roman,

On 8 January 2018 at 22:11, Michael Kerrisk (man-pages)
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello Roman,
>
> I wrote cgroups(7) text below to document the files added by you in
> Linux 4.15. Could you let me know if the following text is okay please:
>
>    /sys/kernel/cgroup files
>        /sys/kernel/cgroup/delegate (since Linux 4.15)
>               This file exports a list of the cgroups v2 files  (one  per
>               line) that are delegatable (i.e., whose ownership should be
>               changed to the user ID of the delegatee).  In  the  future,
>               the  set  of delegatable files may change or grow, and this
>               file provides a way for the  kernel  to  inform  user-space
>               applications of which files must be delegated.  As at Linux
>               4.15, one sees the following when inspecting this file:
>
>                   $ cat /sys/kernel/cgroup/delegate
>                   cgroup.procs
>                   cgroup.subtree_control

I have a question about /sys/kernel/cgroup/delegate: why does this
file not list cgroup.threads, since that is also a file that
(potentially) should be delegated?

Cheers,

Michael
