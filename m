From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: restore the call to eventfd->poll()
Date: Fri, 26 Apr 2013 12:00:28 -0700
Message-ID: <20130426190028.GB1433@mtj.dyndns.org>
References: <5179EC7C.5060208@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=cATV+tnjK0Nj2JhtNwROCieH6s9pcoDQPx0OdWmI4P0=;
        b=tkFlyfTBSJRZIAH2ruNlJ9Nwty/VaGZendKjxwHBodP6P2KirGs65cqyM+usMBnVsC
         brkTEdchUuWKdjlVyp7iC8iGXDFPjIaHo8UJRQyNvwvrvzY9Sw1W3sWe7uh+K+UKZQYD
         wiWZwUCxBubeKhavITz3byRco7Q7lQ8cy3V4rtHOO2Ylj41RYeTqRI1wonYfVDukjLbi
         VZ3oRV5X5qWAkddjLwHllP75A8ScQ7xWVVZZBW6p0oCo5Xrt1QLFV8K6Uw0/P62B+zDP
         X8ldJT8T5GXrS8FKih53Dzt2tMQl2zIzrWVQKbO0WdYMXHI2JNHx3/EuyZ/5fxsvLJ5H
         mK4A==
Content-Disposition: inline
In-Reply-To: <5179EC7C.5060208-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Apr 26, 2013 at 10:54:52AM +0800, Li Zefan wrote:
> I mistakenly removed the call to eventfd->poll() while I was actually
> intending to remove the return value...
> 
> Calling evenfd->poll() will hook cgroup_event_wake() to the poll
> waitqueue, which will be called to unregister eventfd when rmdir a
> cgroup or close eventfd.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.10.  It'd have been better if the patch
description pointed to the specific commit which caused the problem.

Thanks.

-- 
tejun
