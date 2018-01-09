From: Roman Gushchin <guro@fb.com>
Subject: Re: cgroups(7): documenting /sys/kernel/cgroup files
Date: Tue, 9 Jan 2018 11:28:18 +0000
Message-ID: <20180109112811.GA31373@castle.DHCP.thefacebook.com>
References: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=toSP/dNK4sWZJuOErp0VGlkRos1nk0BjDcM5kYio0+E=;
 b=fBmLEXOMUeJDY2x2cODJk5m7AyTwG41S/PZBF89zgPd24OER7ZrMSVRsFvYgpJZm9cMa
 YohCibRNhFyiONmSgEiMima7dzh+PJ3T3MhZifBOGjKrpqpo3I7XyNE/gnSACfEkCkKv
 n4nBd+zvFxDopksTEdPn9Xr+NTp7f79vHqg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=toSP/dNK4sWZJuOErp0VGlkRos1nk0BjDcM5kYio0+E=;
 b=cF972Mw02UEdWeRL8Pv5pke0r+J3G/Zk5lyja2bir8O3fEa3EFSycW+qVIIrZyrq8P8wL/4iuTqm/6KkN7hAz1WHbVclg6YytZafpBs+REkmeKCKl5+6eYGdmAi8HOciI1wQc2GDRj5SKi6LwyepcVqGyxi5sB7A0rWysHzYg7I=
Content-Disposition: inline
In-Reply-To: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, linux-man <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org

Hello, Michael!

Overall looks good to me, one small nit below.

On Mon, Jan 08, 2018 at 10:11:43PM +0100, Michael Kerrisk (man-pages) wrote:
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
> 
>        /sys/kernel/cgroup/features (since Linux 4.15)
>               Over time, the set of cgroups v2 features that are provided
>               by  the kernel may change or grow, or some features may not
>               be enabled by default.  This file provides a way for  user-
>               space  applications  to  discover what features the running
>               kernel supports or has enabled.  Features  are  listed  one
                                ^^
I would replace "or" with "and" here.

Please, feel free to add
Reviewed-by: Roman Gushchin <guro@fb.com>

Thank you!

Roman
