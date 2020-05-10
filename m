From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] netprio_cgroup: Fix unlimited memory leak of v2
 cgroups
Date: Sat, 9 May 2020 21:02:14 -0700
Message-ID: <20200509210214.408e847a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <939566f5-abe3-3526-d4ff-ec6bf8e8c138@huawei.com>
        <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
        <20200508225829.0880cf8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589083336;
        bh=iIlip5Pvd+/nd22NeY8yhi15wbomwAP7PKDtjMfhDj4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jt/Lu4MpG2XiLOF+j8YPcqZ4sHVm+vw975QlQVLhxR2U4bY7oXARENrwmZCyuzPr6
         zFdhJhlfElJeK4kEP4G3Teypdvui3NPeLMLlqE26xrQjZ5nexhMPbWUN0Tiu7bxTvM
         xGyXC1XUZ7RA2Bc3pdE+POWvblB2W29X4MnUmmXc=
In-Reply-To: <20200508225829.0880cf8b-CbGlpYbfshD2+ikPA6JUzH8MC5kE+Go+7OQnqPW8cmTNHmdVIy2bbWItS4zQEDct@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, yangyingliang <yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, guofan5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, 8 May 2020 22:58:29 -0700 Jakub Kicinski wrote:
> On Sat, 9 May 2020 11:32:10 +0800 Zefan Li wrote:
> > If systemd is configured to use hybrid mode which enables the use of
> > both cgroup v1 and v2, systemd will create new cgroup on both the default
> > root (v2) and netprio_cgroup hierarchy (v1) for a new session and attach
> > task to the two cgroups. If the task does some network thing then the v2
> > cgroup can never be freed after the session exited.
> > 
> > One of our machines ran into OOM due to this memory leak.
> > 
> > In the scenario described above when sk_alloc() is called cgroup_sk_alloc()
> > thought it's in v2 mode, so it stores the cgroup pointer in sk->sk_cgrp_data
> > and increments the cgroup refcnt, but then sock_update_netprioidx() thought
> > it's in v1 mode, so it stores netprioidx value in sk->sk_cgrp_data, so the
> > cgroup refcnt will never be freed.
> > 
> > Currently we do the mode switch when someone writes to the ifpriomap cgroup
> > control file. The easiest fix is to also do the switch when a task is attached
> > to a new cgroup.
> > 
> > Fixes: bd1060a1d671("sock, cgroup: add sock->sk_cgroup")  
> 
>                      ^ space missing here
> 
> > Reported-by: Yang Yingliang <yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Tested-by: Yang Yingliang <yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Fixed up the commit message and applied, thank you.
