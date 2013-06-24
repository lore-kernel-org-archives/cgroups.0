From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/6] cgroup: clean up find_css_set() and friends
Date: Mon, 24 Jun 2013 13:03:30 -0700
Message-ID: <20130624200330.GH1918@mtj.dyndns.org>
References: <1371864854-28364-1-git-send-email-tj@kernel.org>
 <1371864854-28364-5-git-send-email-tj@kernel.org>
 <51C8206F.90404@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=N7s22XN7Xv2diVtGg+RYPaJlDtdIz6dZmtLi4LBVfHc=;
        b=FU9l365AdO9hnwAAHlpEUsdcCGQhxSL42WAqEhLgUH8RQWlzl+BanX/mNB3nsvzzOm
         XOqCH5maS5blLnFZOspzkVF0twf3KlUYUkyVP0QmULfDd0Xr7UKKkGaBFsZ/1WYgI748
         6m9kxwAEODAoO+ywUQlbXm0zpEFWBpxIdqrtZFaNlpufuIH10HWhfgbwCyt1jPvK6by/
         A+fJF/QFwu4zuaOrBMhTTQLxUqdz8jTRAedC41kmwC49WB8D4D01LuEYH7Yay3bA+oPm
         k3V2sYSXHTVmiM9XW83hDZU1n6DsMsCuJ7nD9b3NgA2PJI7DyciAU5Tx3CD6iyNnmztv
         TeMQ==
Content-Disposition: inline
In-Reply-To: <51C8206F.90404-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jun 24, 2013 at 06:33:19PM +0800, Li Zefan wrote:
> On 2013/6/22 9:34, Tejun Heo wrote:
> > find_css_set() passes uninitialized on-stack template[] array to
> > find_existing_css_set() which sets the entries for all subsystems.
> > Passing around an uninitialized array is a bit icky and we want to
> > introduce an iterator which only iterates loaded subsystems.  Let's
> > initialize it on definition.
> > 
> > While at it, also make the following cosmetic cleanups.
> > 
> > * Convert to proper /** comments.
> > 
> 
> I thought we only use this for external functions, but then I read
> Documentation/kernel-doc-nano-HOWTO.txt:
> 
> We also recommend providing kernel-doc formatted documentation
> for private (file "static") routines, for consistency of kernel
> source code layout.  But this is lower priority and at the
> discretion of the MAINTAINER of that kernel source file.

Yeah, for functions which are tricky, important and/or used in many
different places, I prefer proper function comments.  There really is
no reason not to do it.

Thanks.

-- 
tejun
