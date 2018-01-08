From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cgroups(7): documenting /sys/kernel/cgroup files
Date: Mon, 8 Jan 2018 22:11:43 +0100
Message-ID: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=N7e6R8mMlK8VJhav8xpE94xD1HlUO4rJntDekdbO0KM=;
        b=XHIv/QTvCQ50fgUVx24pW/IyPe69ri3unWwOt4Ww/tPPdadfNIlX8gDlog0ou6PwyF
         cQUx9dHg5jcInrBgd80Y3r7on5gQJkOutFYsBHiee/gvM3T/PGDoa002pZbNT5yC7ocN
         SjmIwk+ZEgX1lDElcFcQknq29CjDYp5pLD2HFbPM8IlogApVxEXyJNP4aGbRh9Yq3WvR
         H4qjHaWvVAz0ZjeFKWhtj/gUFzOwriSU1EH+vgh6zHTxfVpkyksBy9d9vKXKx7oYujUb
         xTO1IYElgGqWpflG847rGwKdqUkjGL9WBwon48QQzeVyMAM7E0vsa022lUR/v3H1RoZv
         4r+g==
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Roman,

I wrote cgroups(7) text below to document the files added by you in
Linux 4.15. Could you let me know if the following text is okay please:

   /sys/kernel/cgroup files
       /sys/kernel/cgroup/delegate (since Linux 4.15)
              This file exports a list of the cgroups v2 files  (one  per
              line) that are delegatable (i.e., whose ownership should be
              changed to the user ID of the delegatee).  In  the  future,
              the  set  of delegatable files may change or grow, and this
              file provides a way for the  kernel  to  inform  user-space
              applications of which files must be delegated.  As at Linux
              4.15, one sees the following when inspecting this file:

                  $ cat /sys/kernel/cgroup/delegate
                  cgroup.procs
                  cgroup.subtree_control

       /sys/kernel/cgroup/features (since Linux 4.15)
              Over time, the set of cgroups v2 features that are provided
              by  the kernel may change or grow, or some features may not
              be enabled by default.  This file provides a way for  user-
              space  applications  to  discover what features the running
              kernel supports or has enabled.  Features  are  listed  one
              per line:

                  $ cat /sys/kernel/cgroup/features nsdelegate

              The entries that can appear in this file are:

              nsdelegate (since Linux 4.15)
                     The kernel supports the nsdelegate mount option.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
