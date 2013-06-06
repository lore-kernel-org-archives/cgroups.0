From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 08/10] cpuset: allow to keep tasks in empty cpusets
Date: Thu, 6 Jun 2013 14:24:50 -0700
Message-ID: <20130606212450.GI5045@htj.dyndns.org>
References: <51AF0183.8070602@huawei.com>
 <51AF020B.3030701@huawei.com>
 <20130605205146.GI10693@mtj.dyndns.org>
 <51B063E6.30107@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+US8bjO1o62MSMSbY4EFRcYPxP+hZfQ64lpczv5PSEQ=;
        b=yeyY16Q79SRffZSgsAN/GTJnY/WzNW/HMc0fIxTn0i+f43C5bQGBuUUYPmkpDeIi91
         NMuVcV4PbLwrSzRqxb/j7EWzC4Ug5IWupzVsZiYeqF7AghhRc+GbySq1wHUM7mNWeJra
         DnBOubHcWl0GUn0cbh+d1yhFECPGTccScL6UKp/iXRfYMlspMoLn60eTm+hghE0wDaCH
         OOKHm3SBZdYbr9I30RPYQrSlk715tLG7l5gGuGE5Aqxi5DZuyEbUsTKCqj9W0djUb3xQ
         Oe3QCyPTlI9h+vfc06VstpBPofAm893e5KaJpYs1XVkkE9Oq7hfRe1Hng+B3jhAAF99H
         4H+g==
Content-Disposition: inline
In-Reply-To: <51B063E6.30107-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

Hey,

On Thu, Jun 06, 2013 at 06:26:46PM +0800, Li Zefan wrote:
> > I wonder whether it'd be possible to merge the two paths.  My
> > suspicion is that we probably don't need propagate_hotplug_work
> > anymore now that we can drop RCU read lock while doing the pre-order
> > walk.  What do you think?
> 
> It indeed can be confusing. I'll see if we can make the code clearer.

Yeah, if possible, it'd be great to remove the propagation work item
and do things inline first and then add the new online propagation.

Thanks!

-- 
tejun
