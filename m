From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroups v2 thread mode
Date: Wed, 10 Jan 2018 14:29:13 -0800
Message-ID: <20180110222913.GH3460072@devbig577.frc2.facebook.com>
References: <b2d54ae2-62db-7402-ed99-7a0e72f90ff4@gmail.com>
 <20180109211000.GT3668920@devbig577.frc2.facebook.com>
 <5c9ea5dd-12dc-99d6-7905-40fdbc34e6ae@gmail.com>
 <20180110144708.GC3668920@devbig577.frc2.facebook.com>
 <704d0cd5-0bab-f876-a09c-9d60e9d2ef93@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=6HZC3GQ3nJkXb/xiBer3u58CGs5s3CDUAni1w8Pdr+s=;
        b=uCnaM8L0X7U3HtS9OcbktFBFGCBtqt4ECn77KzD7khQnWhS4MDrgM7TdwCOMH/wV3M
         OtLGQTQ/8urxKQtVr9ewnUeoxa9gvYJDr6TYu1InnucDJR0NoZWY+mUgA3mZMdSL11eR
         nwUGkqWimjaRW2av395M+mwCB9sEfeAVMSg4L5ixo6wVIjQQRv2+7E+w4Lo2yAFDi0K/
         Ub2a5uIuXSfJL9iZjOpZykVIQ4rKZc8Mn7q5p7kzwDqpDEJ6+u4OZiRkx2Fu1gAxyGBH
         mGlRROtP9MMob9fvocH/99i3iOb/BNaVPWs0R9RB/6hyvC4XTbVTzZJK+ou7+wPHCKRD
         uOpw==
Content-Disposition: inline
In-Reply-To: <704d0cd5-0bab-f876-a09c-9d60e9d2ef93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Lauro Venancio <lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Wed, Jan 10, 2018 at 11:18:48PM +0100, Michael Kerrisk (man-pages) wrote:
> Ahh yes. Now I understand. I made the description of the containment
> rules for cgroup.threads more explicit in the text:
> 
>        As with writing to cgroup.procs, some containment rules apply when
>        writing to the cgroup.threads file:
> 
>        *  The  writer  must  have  write permission on the cgroup.threads
>           file in the destination cgroup.
> 
>        *  The writer must have write permission on the cgroup.procs  file
>           in  the  common ancestor of the source and destination cgroups.
>           (In some cases, the common ancestor may be the source or desti‐
>           nation cgroup itself.)
> 
>        *  The source and destination cgroups must be in the same threaded
>           subtree.  (Outside a threaded subtree, an  attempt  to  move  a
>           thread by writing its thread ID to the cgroup.threads in a dif‐
>           ferent domain cgroup fails with the error EOPNOTSUPP.)
> 
> Okay? (I realize that the last bullet point is a rather different way of
> formulating your idea that "the only extra restriction is that the domain
> cgroup must be the same for the source and destination". But I think the
> reformulation is easier to understand, no?)

It looks great to me.  Me explaining that way is mostly from internal
/ conceptual POV.  Yours is definitely more approachable.

Thanks.

-- 
tejun
