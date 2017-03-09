From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Used void functions follows non void
Date: Thu, 9 Mar 2017 13:29:01 -0500
Message-ID: <20170309182901.GF28982@htj.duckdns.org>
References: <65a50f47-b87a-790d-cc16-0b873bffdc97@marian1000.go.ro>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=7gQW3Sk1WIX7Y4kgZstjOrh0G9rDT4HhRemGXedIl2U=;
        b=jfk+8lD6NaG32WvQ/hNlqgydHGm+F20HMptl7laek0WGeesdzXTTuNtPlriF/7VMlz
         uTeXNjlWBj1NuDcg7z7y5fEgoUYPT19Uzvznrstbk79nfmsziWMFkmczj6dQfCcL5o7t
         V+aYftsj94kp9Uh1RmLFUdpHtmcjaZbqFqguXNOyfhcvF4aSakxGrlmURY3VRObTzrx9
         LnFdzS0I9MgkfYmAMFkw4UIq7eX0YDSHeuA7vbeXubWpy7H94YSB+Fj0ED28tt6cFXzc
         jRQJO3Ndzh+eSzAxp+us3qt20nNSrA6CRWCV8Fkq4Of/nzuk+2FUJYYk9cqZwz2RKnM2
         0rSw==
Content-Disposition: inline
In-Reply-To: <65a50f47-b87a-790d-cc16-0b873bffdc97-jrA/B3VWHiL2D7C+UIOg5A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Corcodel Marian <asd-jrA/B3VWHiL2D7C+UIOg5A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 09, 2017 at 04:39:10PM +0200, Corcodel Marian wrote:
> 
> Make compiler to print errors message ;
> run make;
>  Bellow is  errors message from compiler:
> include/linux/cgroup.h:424:2: warning: ‘return’ with no value, in function
> returning non-void [-Wreturn-type]
>   return task_css_set_check(task, false);
>   ^
> include/linux/cgroup.h: In function ‘task_css’:
> include/linux/cgroup.h:414:35: error: expected expression before ‘->’ token
>   task_css_set_check((task), (__c))->subsys[(subsys_id)]
>                                    ^
> include/linux/cgroup.h:437:9: note: in expansion of macro ‘task_css_check’
>   return task_css_check(task, subsys_id, false);
>          ^
> include/linux/cgroup.h: In function ‘task_css_is_root’:
> include/linux/cgroup.h:414:35: error: expected expression before ‘->’ token
>   task_css_set_check((task), (__c))->subsys[(subsys_id)]
>                                    ^
> include/linux/cgroup.h:475:9: note: in expansion of macro ‘task_css_check’
>   return task_css_check(task, subsys_id, true) ==

Can you please share the .config used and the kernel version?

Thanks.

-- 
tejun
