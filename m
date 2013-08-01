From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/7] cgroup: rename cgroup_pidlist->mutex
Date: Thu, 1 Aug 2013 09:30:38 -0400
Message-ID: <20130801133038.GE24966@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C818.4080308@huawei.com>
 <20130731113518.GJ2810@htj.dyndns.org>
 <51F9BF4F.5030704@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=R5DIVfonIAPWqy8tCQtC8xc4IavTUtIGWrhu2NCMRMM=;
        b=viwaWUKFQIf6INAz31VWlMb0dQor0Oqe7UrPgAf7ZazBX1cVOxwe5XqHLBcNqwXlmp
         afuBljjxQEV6UIMytFiBF8HuatBtHvdOPlRzkkZrCf07cxE/NFvUIpk1WFwczPeYyXjs
         aroO+FgQ/wJljExhKKD4wWxHwGa9soBRaWPYoWE+wBcEwE4HzTUeWoTQjK6+hquE3K3c
         nSPqF+VBavi9jJd9CYmfhFFVqRQRvp6SFJM2DMuaI/X4eG+0E0Lipl+CkbX6NZxXjhiA
         eUEguMeOQdjBz9DV7n2ulotmLznsduK9x5aegtzbifDjRkli49bfFizbKSgM9eda5IHr
         LrZw==
Content-Disposition: inline
In-Reply-To: <51F9BF4F.5030704-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Aug 01, 2013 at 09:52:15AM +0800, Li Zefan wrote:
> It's a rw_semaphore not a mutex.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
