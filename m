From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Thu, 23 Jun 2016 14:03:46 -0700
Message-ID: <CAGXu5jJtJJRGchihX8wXOo0NumtdFMT3P4JM=GPeqPt811aM3w@mail.gmail.com>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=ZxnciwCv4704E+nmaDa69+dfR0cf4/ND/ahoxZWT5Jo=;
        b=o0Li/EYB3nySs1ezyq7uGVe3e3nsl8mgoLdq2ER67gDBOYUe8ZARvED+f2B+7qKFf2
         j+Y6l2iIwzxU76MbiDvd2gcta4q98h6lO0q6F/uyTx0hXvInjmT0FnkY4JwrqylIspSh
         +rVD04uJFcUCvF+Y26rg0y2WbCiHJiNNApdi6LPd8j71oetP6WtwW42fDpK2HSHmkKgf
         2S3oJ1oi/SURheMqltblZQTAXlUdioxAGfp7RUb0H705Oqlxf5dahO+4IWqjNEvLjqQx
         k314koh+LguhxV1GuDEO1ey0bDr4MOrDcXlWdQMaQwA+rHfiN7dqwQ0gEsSPTJL0X5ot
         q3bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=ZxnciwCv4704E+nmaDa69+dfR0cf4/ND/ahoxZWT5Jo=;
        b=lFcrLvhVwKVMZhl8BMUKIhVMDlyeZy7wc//kOHh3bLdz4Jm5oB08wyLlRMh6amf4zx
         rCI4pu1jXwpHiKaAcYSUWrv4K6zGQLItJFL3xMQc8AP1vQTdJWRAlYg7gaEA/l231UGr
         nUP0jhEnQoIt0/SFkHFwZPJr6eiidt1qfaYFc=
In-Reply-To: <1466694434-1420-1-git-send-email-toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CAPABILITIES" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jun 23, 2016 at 8:07 AM, Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> There are many basic ways to control processes, including capabilities,
> cgroups and resource limits. However, there are far fewer ways to find
> out useful values for the limits, except blind trial and error.
>
> Currently, there is no way to know which capabilities are actually used.
> Even the source code is only implicit, in-depth knowledge of each
> capability must be used when analyzing a program to judge which
> capabilities the program will exercise.
>
> Add a new cgroup controller for monitoring of capabilities
> in the cgroup.
>
> Test case demonstrating basic capability monitoring and how the
> capabilities are combined at next level (boot to rdshell):
>
> (initramfs) cd /sys/fs
> (initramfs) mount -t cgroup2 cgroup cgroup
> (initramfs) cd cgroup
> (initramfs) echo +capability > cgroup.subtree_control
> (initramfs) mkdir test; cd test
> (initramfs) echo +capability > cgroup.subtree_control
> (initramfs) ls
> capability.used         cgroup.events           cgroup.subtree_control
> cgroup.controllers      cgroup.procs
> (initramfs) mkdir first second
> (initramfs) sh
>
> BusyBox v1.22.1 (Debian 1:1.22.0-19) built-in shell (ash)
> Enter 'help' for a list of built-in commands.
>
> (initramfs) cd first
> (initramfs) echo $$ >cgroup.procs
> (initramfs) cat capability.used
> 0000000000000000 # nothing so far
> (initramfs) mknod /dev/z_$$ c 1 2
> (initramfs) cat capability.used
> 0000000008000000 # CAP_MKNOD
> (initramfs) cat ../capability.used
> 0000000008000000 # also seen at next higher level
> (initramfs) exit
> (initramfs) sh
>
> BusyBox v1.22.1 (Debian 1:1.22.0-19) built-in shell (ash)
> Enter 'help' for a list of built-in commands.
>
> (initramfs) cd second
> (initramfs) echo $$ >cgroup.procs
> (initramfs) cat capability.used
> 0000000000000000 # nothing so far
> (initramfs) chown 1234 /dev/z_*
> (initramfs) cat capability.used
> 0000000000000001 # CAP_CHROOT

nitpick: this is CAP_CHOWN, not CAP_CHROOT

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
