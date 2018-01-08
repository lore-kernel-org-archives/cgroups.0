From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting the nsdelegate mount option
Date: Tue, 9 Jan 2018 00:26:28 +0100
Message-ID: <4768da37-ba3e-7d0c-841a-1b026c558bdd@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=O5iI4ABZLn4meFr3/8E6TFWQu/3bwJBXpPKfyzI2GPg=;
        b=KLCF+hp3DxjevcTlmdRneTqfvP+2z/LZxmdDoqStQ/lxE/97eqc0HshePMv6SF5SIz
         x8yoVIDNGLnk+VAbqS2whpTzf7tXXrig8Qsx98z9iu7kud0uQANqZ6Rw+E9dormXmwpG
         RiNWF/49uYaNPuf3jUwxnQ6Iobzwo/gxSAbnjNiZ3/EgOU6Q6DLAr6jwKxqSh/ddvVfh
         1dCyR+Magb04P9/nHMVdREFVnsQV65aOC35k66O9blgaotRw7wLcq9KZ3SFUX3nZTmVS
         6gJhNk0EQegvE3hujJnagCyG4Pmj5z+kW3e9A3cVX7qAPHIZy3sOsFOuBwm6IXI+2rBI
         qLnA==
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Tejun,

Here is my attempt to document dgroup v2 delegation using 'nsdelegate'.
Could you please take a look at the text and let me know if anything 
needs fixing:

   Cgroups v2 delegation: nsdelegate and cgroup namespaces
       Starting with Linux 4.13, there is a second way to perform  cgroup
       delegation.   This  is  done  by mounting the cgroup v2 filesystem
       with the nsdelegate mount option:

           $ mount -t cgroup2 -o nsdelegate none /sys/fs/cgroup/unified

       The effect of this option is to cause cgroup namespaces  to  auto‐
       matically  become  delegation  boundaries.  More specifically, the
       following restrictions  apply  for  processes  inside  the  cgroup
       namespace:

       *  Writes to controller interface files in the root directory will
          fail with the error EPERM.  Processes inside the cgroup  names‐
          pace  can still write to delegatable files such as cgroup.procs
          and cgroup.subtree_control, and can create subhierarchy  under‐
          neath the root directory of the cgroup namespace.

       *  Attempts to migrate processes across the namespace boundary are
          denied (with the error ENOENT).  Processes  inside  the  cgroup
          namespace can still (subject to the containment rules described
          below) move processes between cgroups within  the  subhierarchy
          under the namespace root.

       The  ability  to define cgroup namespaces as delegation boundaries
       makes cgroup namespaces more useful.  To understand  why,  suppose
       that  we already have one cgroup hierarchy that has been delegated
       to a nonprivileged user, cecilia, using the older delegation tech‐
       nique  described  above.   Suppose  further that cecilia wanted to
       further delegate a subhierarchy under the existing delegated hier‐
       archy.   (For example, the delegated hierarchy might be associated
       with an unprivileged container run by cecilia.)  Even if a  cgroup
       namespace  was employed, because both hierarchies are owned by the
       unprivileged user  cecilia,  the  following  illegitimate  actions
       could be performed:

       *  A  process  in the inferior hierarchy could change the resource
          controller settings in the root directory of the  that  hierar‐
          chy.  (These resource controller settings are intended to allow
          control to be exercised  from  the  parent  cgroup;  a  process
          inside the child cgroup should not be allowed to modify them.)

       *  A  process  inside  the inferior hierarchy could move processes
          into and out of the inferior hierarchy if the  cgroups  in  the
          superior hierarchy were somehow visible.

       Employing  the nsdelegate mount option prevents both of these pos‐
       sibilities.

       The nsdelegate mount option only has an effect when  performed  in
       the initial mount namespace; in other mount namespaces, the option
       is silently ignored.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
