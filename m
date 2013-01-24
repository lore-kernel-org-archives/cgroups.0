From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: fix exit() vsrmdir() race
Date: Thu, 24 Jan 2013 10:19:23 -0800
Message-ID: <20130124181923.GK2373@mtj.dyndns.org>
References: <5100D810.5020406@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=c13dKVHlxaJwUXtD2ZIzkN9/ObjhtTYayYgJlXdKgIY=;
        b=IOdGZOj+K2vo0nWR5RQ/4tQ+/454euRbqsGVEtzauvTbu+Wg3D6jQUzu3Pp+XJRATG
         KbTo1c7SKHGVG3dO8wxxcvbeLD606UsCbJBf/t1k/Y+/+DY4V1/1dlMZk5I/+CdwLsLy
         uGBP2MIT2dQilDH03d9bG16JjzOP74PurNNRIfjuhOsNjPzAm9/EWzvHwQGVA0vbHeVq
         k/pJ/kjyhz1IIAjOL6V5SweL3kMTBBmcSn1Rw8Hrv+1Z0zn39EVm/ZkRVegUzA+MyZAf
         R9/rJawCf5+Mx9Yr4BCUUuMZpftgT47+Vykt/VqA8IVAg/A1WjKagGxfEj+fee1K4vXE
         pNGw==
Content-Disposition: inline
In-Reply-To: <5100D810.5020406-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jan 24, 2013 at 02:43:28PM +0800, Li Zefan wrote:
> In cgroup_exit() put_css_set_taskexit() is called without any lock,
> which might lead to accessing a freed cgroup:
> 
> thread1                           thread2
> ---------------------------------------------
> exit()
>   cgroup_exit()
>     put_css_set_taskexit()
>       atomic_dec(cgrp->count);
>                                    rmdir();
>       /* not safe !! */
>       check_for_release(cgrp);
> 
> rcu_read_lock() can be used to make sure the cgroup is alive.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applying to cgroup/for-3.8-fixes w/ stable cc'd.

* Can you please add WARN_ON_ONCE(!rcu_read_lock_held()) in
  check_for_release()?

* cgroup_release_agent() seems broken too.  It's accessing cgrp after
  removing it from release_list.  Can you please fix it too?

Thanks.

-- 
tejun
