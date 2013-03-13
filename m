From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: consolidate cgroup_attach_task() and
 cgroup_attach_proc()
Date: Tue, 12 Mar 2013 18:19:39 -0700
Message-ID: <20130313011939.GC2999@htj.dyndns.org>
References: <513FD395.7000906@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=9SbMoCY4XEUkbJdYOLyuyE5JqnE3BFwKW4U1wxG6M3o=;
        b=ZBT21Hihdvnq2JmZYn9pUDNiU1DxdP0L8wj9oX73KXl0rsk8EdFLxaH2q/8o/hhvoN
         m+HbdL5yrTe7eqELRqDYuhBuO2OF1/txjLRSqXB4piG6DMgiYyWWzLe3y84CETkAfwTi
         LymryspBoWnrZVCAro4swQlPIOd3mnEh+J2yNtGYKXZ3vCZrX+tDsN+ts+EKMSrwmUmw
         7BP772YJWSYJh8mLJAzGQKsu3sWp9BEzksa7m5X3CkKBqw0iyAb7VxNJEHvlJLBlaZN6
         88IpUYpIt0fFIy5glS0ylzlgwLwwqIPw7yGHym0kSZQauY3pdWXacPfZS7lNgrYaQFOf
         8wpw==
Content-Disposition: inline
In-Reply-To: <513FD395.7000906-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Mar 13, 2013 at 09:17:09AM +0800, Li Zefan wrote:
> These two functions share most of the code.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> 
> v2: Not necessary to move cgroup_attach_task_all().

I supposed this one is the one to apply?

-- 
tejun
