From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: update MAINTAINERS entry
Date: Thu, 29 Mar 2012 08:53:03 -0700
Message-ID: <20120329155303.GA28941@google.com>
References: <4F73CF7F.8090309@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qSfvRSxdiNjh5tMCcUs5w7gIUY1dyiD0Z4IADbSOZno=;
        b=D+sZK75twCIZCH/X9aYXXBQwA3995ozXxt9IWv21vlU1oO0+7x3ZLs77dXVCIy2CG8
         foI7jsJI7ec4nNRXdi7Q0LETvUc4ahNORtrpuOFABCSDTM658qAO/Dzp0hbTwFwV/mx4
         csx4i8em95bfxjCN+/YnE6YL3PrXtyg9bB8keV+xTJ7rjphJp+qaq6ALiIYEnG987zsE
         M/Hdg6MPWAHYr6ZDZyBFtICLqfYj52dK9E4lUQxGfJxzUXb9CfbGh9UHcmgoBFwU9vX+
         mkOEdGTe44ahAX5xQwQgLxBViPmkyFmuOWGjBqvxqRn2wdWBUJYNIEQPgjyNlWy048Ru
         zz9Q==
Content-Disposition: inline
In-Reply-To: <4F73CF7F.8090309-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Thu, Mar 29, 2012 at 10:57:03AM +0800, Li Zefan wrote:
> Update my email address.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> --- linux-kernel.orig/MAINTAINERS	2012-03-28 22:52:37.000000000 -0400
> +++ linux-kernel/MAINTAINERS	2012-03-28 22:52:01.000000000 -0400
> @@ -1939,7 +1939,7 @@ F:	drivers/connector/
>  
>  CONTROL GROUPS (CGROUPS)
>  M:	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> -M:	Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> +M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>  L:	containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>  L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git

Welcome back!  Queueing the patch in cgroup/for-3.4-fixes.

-- 
tejun
