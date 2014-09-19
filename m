From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove redundant check in cgroup_ino()
Date: Fri, 19 Sep 2014 09:17:08 -0400
Message-ID: <20140919131708.GA30493@mtj.dyndns.org>
References: <541BE96B.1090605@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=T12zJUizA0P8EvbtGJQD4945OXlO2eUxp5ogn1qjyCc=;
        b=pCU1/h7J2NHG+ui7e/AbD6kfmjxBXfyUa8Ki/oEbmE0kW9MrKvbHnqeUzNajhPTQ7i
         3CLqW/QJa4p8/Y0FA18IJPERYUo9K07y7MoCwrFd+1kOcRzMg9AFclShqatBr+Skjw/H
         DSSgk8gxRY4i8Y+cu5WpjVKkbpjFHV+ihLhXwV6r5JQQWdarBJyKDovBG6l4OrFl/K77
         wLYX6z1c9MHNDQ839IhfO2gl5xdZMC+6E7FLOu6ETUEoHnbaB1k4PJkWxUBNZo7mhS88
         u7WusTPv9Lx/pclZ6ElXnRdyxxCWWx94Neky3U9cQwj/lL3lmzhJmzDdoLhqxHeXzZSk
         YT4Q==
Content-Disposition: inline
In-Reply-To: <541BE96B.1090605-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>

On Fri, Sep 19, 2014 at 04:29:31PM +0800, Zefan Li wrote:
> After we implemented default unified hierarchy, cgrp->kn can never
> be NULL.
> 
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
