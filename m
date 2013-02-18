From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: fix cgroup_rmdir() vs close(eventfd) race
Date: Mon, 18 Feb 2013 09:18:17 -0800
Message-ID: <20130218171817.GF17414@htj.dyndns.org>
References: <5121C647.7030608@huawei.com>
 <20130218171647.GD17414@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=RT1EklHxNf07F1Lvd20WUQl9qe8F7i8xJScpR3PAf8I=;
        b=Db3NxcwteDMVMbFE1icyTL6+P97ZCwMv3qg4doFuPEfOQBjp748Cat86Y16elFDe/3
         pFIFPGGE/dWlLmD4TuJgBf58TkZhOBQkkI1+XL9hjgBlYdXZe6UcVOZLyWd4lnJ+lVDA
         6R8iTpdkud3q60Tz/tlosxo5dmdsqZ4SYV5igKjSFmSLYrAr5EWIxbCXVZcLLXN7Ad2k
         hRjbcgW7CmZO89lrWxh6iIe+2G1/sgU1EFAYDKPK8r1+bQLqKUiOhwWHe4zHosjiSS6H
         M/1hzZBUfx+asA4oa6O6zzgaIpSj+hJCEXlmk1hVU0tAwjEgAUmodlJQrW2fDIxSkQva
         f/zA==
Content-Disposition: inline
In-Reply-To: <20130218171647.GD17414-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

On Mon, Feb 18, 2013 at 09:16:47AM -0800, Tejun Heo wrote:
> On Mon, Feb 18, 2013 at 02:12:23PM +0800, Li Zefan wrote:
> > commit 205a872bd6f9a9a09ef035ef1e90185a8245cc58 ("cgroup: fix lockdep
> > warning for event_control") solved a deadlock by introducing a new
> > bug.
> > 
> > Move cgrp->event_list to a temporary list doesn't mean you can traverse
> > this list locklessly, because at the same time cgroup_event_wake() can
> > be called and remove the event from the list. The result of this race
> > is disastrous.
> > 
> > We adopt the way how kvm irqfd code implements race-free event removal,
> > which is now described in the comments in cgroup_event_wake().
> > 
> > Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Applied to cgroup/for-3.9.

Never mind.  Just spotted v3 and applied that one instead.

-- 
tejun
