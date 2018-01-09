From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting /sys/kernel/cgroup files
Date: Tue, 9 Jan 2018 19:52:39 +0100
Message-ID: <7e64c6a5-123f-0341-7f35-c9b616c48322@gmail.com>
References: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
 <20180109112811.GA31373@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bVdarnEq4A3MZIZlpMxx2IYBfMPRIbS9PGx16Ic0rTI=;
        b=o7yDG119mpqVveLiPOE4nJEqcrUglkINq6QOEbbkjNqUan4ac1kNnG0RDjcXh7XEAz
         I8UafHyOFqBpMfbzHAIjcMDc8mTy5bfDcmRneWrKIWvPHZxQAFiR3/oQM6s8PDg3n13a
         bCb+3awnYkoBb03IPw1Yt+G1tt0MkT7V00VG7JhLfMmwthH0K/DU4cdTALDAoqLXzU5s
         ANcV4HOxaWDkunurQGiJkku7hOfnpSczc2R4FDXzCChnGOIVWbTjfEUsuDc5I9iBU3aY
         Iws1fl6Ojxg4LqQy504NyKU6gI1Wi9gXdIRf8enX/O9o7zoGgw9GHEydoKrcoFVg6znd
         Ou6w==
In-Reply-To: <20180109112811.GA31373-B3w7+ongkCiLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello ROman,

On 01/09/2018 12:28 PM, Roman Gushchin wrote:
> Hello, Michael!
> 
> Overall looks good to me, one small nit below.
> 
> On Mon, Jan 08, 2018 at 10:11:43PM +0100, Michael Kerrisk (man-pages) wrote:
>> Hello Roman,
>>
>> I wrote cgroups(7) text below to document the files added by you in
>> Linux 4.15. Could you let me know if the following text is okay please:
>>
>>    /sys/kernel/cgroup files
>>        /sys/kernel/cgroup/delegate (since Linux 4.15)
>>               This file exports a list of the cgroups v2 files  (one  per
>>               line) that are delegatable (i.e., whose ownership should be
>>               changed to the user ID of the delegatee).  In  the  future,
>>               the  set  of delegatable files may change or grow, and this
>>               file provides a way for the  kernel  to  inform  user-space
>>               applications of which files must be delegated.  As at Linux
>>               4.15, one sees the following when inspecting this file:
>>
>>                   $ cat /sys/kernel/cgroup/delegate
>>                   cgroup.procs
>>                   cgroup.subtree_control
>>
>>        /sys/kernel/cgroup/features (since Linux 4.15)
>>               Over time, the set of cgroups v2 features that are provided
>>               by  the kernel may change or grow, or some features may not
>>               be enabled by default.  This file provides a way for  user-
>>               space  applications  to  discover what features the running
>>               kernel supports or has enabled.  Features  are  listed  one
>                                 ^^
> I would replace "or" with "and" here.

Yes. Done.

> Please, feel free to add
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Thanks!

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
