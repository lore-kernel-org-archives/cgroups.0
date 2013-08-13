From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cpuset: remove redundant checks in file write
 functions
Date: Tue, 13 Aug 2013 11:05:49 -0400
Message-ID: <20130813150549.GF26596@mtj.dyndns.org>
References: <5209892D.8070502@huawei.com>
 <52098941.4070600@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4B3aQXoXCG6GrRne7dXgYh6A4KkBRIXM+mc9d4qyBfI=;
        b=Dw6apXpDdPZmHJxv/Zw0M8xsjY46vRGG22F8rwGUV+2vIOhrySc/CxP5+SzPip525J
         m30f40/+79eBmEqereFQlwDhLcIRQZsRiV3n3xNJDwICOj4YXnQp2qWZ6CHnl9HM5Xu5
         bSRxz2BKpo61fiCGJWDl9dyqM48SRxmo7i/3208BG3bG10qTjOSFg41srX8U6ScXs627
         VwGgkugipeoE8rej9iWuRokp5TD1WJJG4nX51ohKsLSzelyQmTLgoHmL1+NvTAQ/Jd4P
         zpP0S3gh/9BrVb8SIxs7gCnyTZ/FByn8fXQOkDcS1zO5vvZ7oxmPw6SYrKgZgnkkMMeG
         GInA==
Content-Disposition: inline
In-Reply-To: <52098941.4070600-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Aug 13, 2013 at 09:17:53AM +0800, Li Zefan wrote:
> Now cgroup core gets a reference to the css when a cgroup file is
> opened(), and the reference is dropped at file release. so it's
> guaranteed the cpuset is online during the write function.

Hmmm... it doesn't really guarantee that as css's can be offlined with
residual css refcnts, os the css may well be offlined by the time it
reaches the rw functions.  What's guaranteed is that their refcnts
wouldn't be zero.  Eventually we need to implement proper sever
semantics (probably by replacing the custom fs implementation with
sysfs) but right now controllers still need to deal with offline
css's.

Thanks.

-- 
tejun
