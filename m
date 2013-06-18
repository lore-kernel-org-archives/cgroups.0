From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup: fix umount vs cgroup_cfs_commit() race
Date: Tue, 18 Jun 2013 09:05:07 -0700
Message-ID: <20130618160507.GG2767@htj.dyndns.org>
References: <51C03913.5020008@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5WuGnTuTUacdTTeDqmpNE6gpHD4P0y411PQaAKeVKuE=;
        b=KQFRZioGkR15lmpzelp8A0DwPavKAHXOi8epaGXJYl2ah3UL8FFkP0cScAlm6KlYZ0
         NyqbkIkG55m2Rfx/6hecaSkqp65VaACPZdycsgi998i/t7S5DnWdKHLp8Rfrd622ar7A
         dffa712mswsaxRMPCCCvkyXDdJgkrRCEmj/1F35ky10C3VQ+CUbK8fFioJ6llWJnUhj6
         6kGZ8Q7UmRBbrW8Dgy+YMyoSO0fgEcG9b06m8eQMRGlZTpEuTj6VnDxMycmaGFyA2b2B
         YN3YEWVG5Yz5hGVVukmk1kVo/1O4rfTzxSl2tDJwKze5Q8KNnKzdSpZmVB9sNKOC8Lmg
         KgGg==
Content-Disposition: inline
In-Reply-To: <51C03913.5020008-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jun 18, 2013 at 06:40:19PM +0800, Li Zefan wrote:
> cgroup_cfs_commit() uses dget() to keep cgroup alive after cgroup_mutex
> is dropped, but dget() won't prevent cgroupfs from being umounted. When
> the race happens, vfs will see some dentries with non-zero refcnt while
> umount is in process.
> 
> Keep running this:
>   mount -t cgroup -o blkio xxx /cgroup
>   umount /cgroup
> 
> And this:
>   modprobe cfq-iosched
>   rmmod cfs-iosched
> 
> After a while, the BUG() in shrink_dcache_for_umount_subtree() may
> be triggered:
> 
>   BUG: Dentry xxx{i=0,n=blkio.yyy} still in use (1) [umount of cgroup cgroup]
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-3 to cgroup/for-3.11 w/ stable cc'd on 1 and 2.

Thanks!

-- 
tejun
