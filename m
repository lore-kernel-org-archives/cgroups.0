From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: make the default root invisible when it's
 umounted
Date: Tue, 3 Jun 2014 09:01:44 -0400
Message-ID: <20140603130144.GB26210@htj.dyndns.org>
References: <538D4956.5050205@huawei.com>
 <538D4982.10905@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=J8Z8sHV1MTRXjmXcAU0qCoJAHcRBTelzS4QcyH4drEs=;
        b=rrAV4dtsWFDeDS8A1jgu9XLq/sCZN7i8pDcpgJA/I/aQuP/PoH/SoJKnUF8M4BhehK
         r4pC/AWN1bnQgxIUT50NMprgy2Uj1pclwR4a32db7vgRVX3XGxUu8WA14WWpZrPA/rtD
         i+EKyUg1tpf0NIWNpdv2sglFfmqck7sS+hhiE2KhNtiuCpzibng77GSP/TX33pY2zB2I
         zyXbn5Y9SguYUxmVPephvh0seKRXb2BA91oLf9rxOFK5Niw90eVUCcGCWQhRyirfd51h
         Mc0+ImoyYjZmAljBsjMcADAeusaGqRYKYOAL5bcCHk78mI5dvjOX/wNK4qNzk+ySeTas
         5koA==
Content-Disposition: inline
In-Reply-To: <538D4982.10905-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jun 03, 2014 at 12:05:22PM +0800, Li Zefan wrote:
> Before this patch (in a fresh system):
> 
>    # cat /proc/$$/cgroup
>    # mount -t cgroup -o __DEVEL__sane_behavior xxx /cgroup
>    # umount /cgroup
>    # cat /proc/$$/cgroup
>    0:cpuset,cpu,cpuacct,memory,devices,freezer,net_cls,blkio,perf_event,net_prio,hugetlb:/
> 
> After this patch (in a fresh system):
> 
>    # cat ...
>    # mount ...
>    # umount ...
>    # cat /proc/$$/cgroup
>    #
> 
> You won't see the default root after it's umounted.

Hmmmm... I intentionally left it visible tho.  The only reason we gate
its visibility is avoid disturbing userland which doesn't know about
and won't use the unified hierarchy.  If the userland starts making
use of it, there's no reason to hide it again especially as that's
consistent with how other hierarchies behave too - they keep showing
up if they have lingering refs.

Thanks.

-- 
tejun
