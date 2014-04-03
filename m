From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
Date: Thu, 3 Apr 2014 11:11:20 -0700
Message-ID: <CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com>
References: <20140403164911.GE24119@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=4hgJsJLntmUAmYPrycYdd26pwRCnrpWyQ2XLi/Kc9c8=;
        b=hh/kPqgvY+o/szTn+Y9X0J+r0nYubL5WGl8EyWm4r60P4teXzve64UN4qbQSPjTdkW
         k3lMBvbFyvrvEBS8MBaszYJDhN9UORPa+KNTcLQSCA8pD6YChxfJ/G4e2+7R/JS2PrbW
         cHd+z1Tjq+0Ga1LbZB6bORJF1ff8lB67iHXL1l6jeqS2mi5AZatvOCOiNp1U7b5XPxx0
         tPXumwSiPU0fQFveiYKMUdTVmqZl2CszDPGnE6gzZgI6IY0Xn8CRK5a57YjbEDOLQUyZ
         WYePSVrrFsXdLMFwkJ8hTXji2A7Iw5TrK+qPrLkeemqfL7OkYoMnA1lwuthNtCb8gRn7
         qddQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=4hgJsJLntmUAmYPrycYdd26pwRCnrpWyQ2XLi/Kc9c8=;
        b=dGljTpN0PJjYdsNF+9tozB0mDyULHsAnPq8r5mM3gUh63wOTNsOSy3W7llZQoXAzie
         0PLg+vJtH5fKkaQKpoYzfRBTpL5nbVwKnnT2+p8u95JJ8btlfiVAPkudqC2uZl83rk2y
         jLJbEOTpImbU8PJkMUiRcEmp1iC/D611XFS3E=
In-Reply-To: <20140403164911.GE24119-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 3, 2014 at 9:49 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> C3. fed95bab8d29 ("sysfs: fix namespace refcnt leak") added an
>     argument to kernfs_mount() and was routed through driver-core-next
>     after cgroup pulled the tree.  cgroup's usage needs to be updated
>     accordingly.

This one I find very annoying. There's exactly *one* user of that
interface (back in fed95bab8d29 there were none), and it doesn't want
that dummy argument.

WTF? Why did the driver-core-next development add that argument at
all, rather than just pass in NULL directly? Do we expect to grow more
users of kernfs_mount?

And the "bool *new_sb_created" argument really makes *zero* sense to
kernfs_mount(). It was added to fix a namespace refcount leak, BUT
kernfs_mount() DOES NOT TAKE A NAMESPACE PARAMETER!

So quite frankly, that kernfs_mount() calling convention change looks
completely f*cked up.

I think I'm going to resolve that conflict differently from your
suggested one - I'm going to just remove the broken stupid
"new_sb_created" argument from the kernfs_mount() helper function.

(It obviously stays around for kernfs_mount_ns() that *does* take a
namespace pointer).

People, holler if you disagree, I'll hold off pushing out my
resolution for a while anyway (do all the normal build tests and
reboot into it).

                      Linus
