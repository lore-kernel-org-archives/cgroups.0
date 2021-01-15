From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Fri, 15 Jan 2021 15:11:18 -0500
Message-ID: <YAH25uulZr1BiQVc@mtj.duckdns.org>
References: <20210115093717.79474-1-chenzhou10@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nwZUHOzxfZQxlqIcBZBTaBRxR48aAaQTr4GFdmPla/o=;
        b=XhLNFQOaif4Y0uy7rduwG0XPxHM3IWWhRsuje0KoDdBE8uyJjD3QVeA58vUc3LdWfP
         b65+6MLKVmTZ7UsyoV79W6/2QXcm19ftztAQLLz2002HxEM8IBdLvcT7Psohbt2lFbqS
         eqosBwYIzo2vLv6x7VB7ikPkwDmwWigAXzDsvkZ1njY9RnZ2w5CDDbFiuKZdOrGPdf7o
         qtTCflIqyndRj+7jhG5/mY9YqxW5jt1YHfn69lFvp78EL7NfkZqUQYt1eGjpqXrpmnjM
         CgsUeuvmMvLIVdJ8hqKTUBYdMSdgJQd34V9/7oJ2LXUOeoC1g23usnGLC+x/Wpph1ykg
         NCrQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210115093717.79474-1-chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri, Jan 15, 2021 at 05:37:17PM +0800, Chen Zhou wrote:
> When mounting a cgroup hierarchy with disabled controller in cgroup v1,
> all available controllers will be attached.
> For example, boot with cgroup_no_v1=cpu or cgroup_disable=cpu, and then
> mount with "mount -t cgroup -ocpu cpu /sys/fs/cgroup/cpu", then all
> enabled controllers will be attached except cpu.
> 
> Fix this by adding disabled controller check in cgroup1_parse_param().
> If the specified controller is disabled, just return error with information
> "Disabled controller xx" rather than attaching all the other enabled
> controllers.
> 
> Fixes: f5dfb5315d34 ("cgroup: take options parsing into ->parse_monolithic()")
> Signed-off-by: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Applied to cgroup/for-5.11-fixes.

Thanks.

-- 
tejun
