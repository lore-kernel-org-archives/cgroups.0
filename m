From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] cpuset: initialize cpuset a bit early
Date: Thu, 5 Mar 2015 08:06:03 -0500
Message-ID: <20150305130603.GD23912@htj.duckdns.org>
References: <54F6CBCD.50009@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=r7cNb7hkow4p2GJr2igeyetb2aX1v+22VBrVMxbzDfs=;
        b=yxE3YaFQk1Diu+cACo1OJa62UQG1LofQp8G1Hjhw7BFJdidvxOx8RaW/TD1BKDMzHk
         ICM9YyvPjIKVBtUOVr9TMzyfbHWJH2AU6lY3hvmDFIU1rRirUzbxsHQELwMWzWp9uDLP
         ramdvgFFN30X0PMsyU1CPxxhBWeyzhb+5EPO+ncdQGFdrQUBkIcjY0BcbDqoGaJoznsY
         YAl6o0yjr1djYiVf5OAkqU1xDBqYTAHF0lAfcx6E7malNPDzy6/YgnOR5ql3oEmz1SFN
         SkHqhq9zrFPqihjjzasgqZUBBQSq6Lpsx/PigrXE+EysVJgbho33WFMFqKACDQJTcH6D
         pofg==
Content-Disposition: inline
In-Reply-To: <54F6CBCD.50009-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Wed, Mar 04, 2015 at 05:09:33PM +0800, Zefan Li wrote:
> Now we call ss->bind() in cgroup_init(), so cgroup_init() will
> call cpuset_bind() and then the latter will access top_cpuset's
> cpumask, which is NULL, because cpuset_init() is called after
> cgroup_init()
> 
> The simplest fix is to swap cgroup_init() and cpuset_init().
> 
> Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Fixes: 295458e67284 ("cgroup: call cgroup_subsys->bind on cgroup subsys initialization")
> Reported by: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.1.

Thanks.

-- 
tejun
