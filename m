From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] kernfs: fix kernfs_node_from_dentry()
Date: Fri, 14 Feb 2014 11:03:01 -0500
Message-ID: <20140214160301.GE31544@htj.dyndns.org>
References: <52FDDA77.6070606@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Y2q5n43n/QhHw2ZvmUmpmLafkf1NRuG6RvQJULnnduY=;
        b=pBAfYtABN4cqwPK/JEeDR8VScL/nOiRW2Eyo6+Nsp3M5gfniITmWvj3PG4HtMxUPpK
         Z3vuI+Fbnl1QtKLWDe9KrVtg6FXgHBqAsDJVGPKNxv8KOdtZTfZRpF84+B/JALgoIabs
         L1H33XiMs8nKFRPztKY7Rm8SgSEmJAoh9puJs2Dw8B8WdqL82z7UPysnoOzg0uarlWxW
         CupKK1BUjXyRpD/fV/X58ixIJ7rh1szn3/pt6ttKTXTJYBczP8K/v+uiYp57oeuileUB
         8jbdVfLqw1VRfYCSzFv8uJS1hB+Qa13sMNxRfmFvN+6n8iDoAaWtvYyB+KdJpnqhsp2w
         ff2w==
Content-Disposition: inline
In-Reply-To: <52FDDA77.6070606-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 14, 2014 at 04:57:27PM +0800, Li Zefan wrote:
> Currently kernfs_node_from_dentry() returns NULL for root dentry,
> because root_dentry->d_op == NULL.
> 
> Due to this bug cgroupstats_build() returns -EINVAL for root cgroup.
> 
>   # mount -t cgroup -o cpuacct /cgroup
>   # Documentation/accounting/getdelays -C /cgroup
>   fatal reply error,  errno -22
> 
> With this fix:
> 
>   # Documentation/accounting/getdelays -C /cgroup
>   sleeping 305, blocked 0, running 1, stopped 0, uninterruptible 1
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks!

-- 
tejun
