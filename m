From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup1: don't allow '\n' in renaming
Date: Thu, 10 Jun 2021 10:03:25 -0400
Message-ID: <YMIbrRdktYmolPXZ@slm.duckdns.org>
References: <1623223039-35764-1-git-send-email-wwfq@yandex-team.ru>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uSsccOa0ekLtQf+hjaaxgyVTpWcAkGjfjGCSWyqjUOg=;
        b=p+uFJn94QQUXOOtDh05HomeTNaioo2qs4MgUtE/BgEbOOymvokye9OWZZ6USc/gkix
         C3LmNlDP8EsLhpowFNdRa8lgOcWkWd0+2liquUXTo8FkQIMSeufT+JYW3IdTKbSFhTG4
         qP0cRqnA/g0BAFxkJuCQJaK5lM3JKvckL9qA0xPQJbHM5Qm+W8eb/UzE46XudJarXxAU
         TTsdaYbZpwwRZXJeukfOpFSdHaXQh0M1Ce56IrC3ysLqdUPzSPuK1ntKs6STEyTE1n/L
         0iPAmFIQ3YbicX4g8ZpkyMVgoWR7tNbU1WGZHL1ESGQSIo9ugwp8KfTFHwwawRO6u1zw
         R07Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1623223039-35764-1-git-send-email-wwfq-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Kuznetsov <wwfq-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, dmtrmonakhov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Wed, Jun 09, 2021 at 10:17:19AM +0300, Alexander Kuznetsov wrote:
> cgroup_mkdir() have restriction on newline usage in names:
> $ mkdir $'/sys/fs/cgroup/cpu/test\ntest2'
> mkdir: cannot create directory
> '/sys/fs/cgroup/cpu/test\ntest2': Invalid argument
> 
> But in cgroup1_rename() such check is missed.
> This allows us to make /proc/<pid>/cgroup unparsable:
> $ mkdir /sys/fs/cgroup/cpu/test
> $ mv /sys/fs/cgroup/cpu/test $'/sys/fs/cgroup/cpu/test\ntest2'
> $ echo $$ > $'/sys/fs/cgroup/cpu/test\ntest2'
> $ cat /proc/self/cgroup
> 11:pids:/
> 10:freezer:/
> 9:hugetlb:/
> 8:cpuset:/
> 7:blkio:/user.slice
> 6:memory:/user.slice
> 5:net_cls,net_prio:/
> 4:perf_event:/
> 3:devices:/user.slice
> 2:cpu,cpuacct:/test
> test2
> 1:name=systemd:/
> 0::/
> 
> Signed-off-by: Alexander Kuznetsov <wwfq-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
> Reported-by: Andrey Krasichkov <buglloc-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
> Acked-by: Dmitry Yakunin <zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>

Applied to cgroup/for-5.13-fixes

Thanks.

-- 
tejun
