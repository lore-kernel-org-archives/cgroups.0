From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/9] cgroup_freezer: add ->post_create() and
 ->pre_destroy() and track online state
Date: Thu, 8 Nov 2012 07:41:42 -0800
Message-ID: <20121108154142.GH12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-9-git-send-email-tj@kernel.org>
 <509B3999.6060505@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MWD5S3QtTx0L+H4+7VtNiHSR0XghAN/MyI5zRH4oNM0=;
        b=RaX6UVjIO/0erHU5t05anKmM22vV0I33PsDOv1odmjYzXuekyJutYtK34Ej14nHp9A
         wcIaGdlhcyzU7RSrbFxUy5og7mkodeVgT7xyidFw9o/CcBBglZNCrryLlj1pYMC8BLdK
         O1ZDVneKmLGD/0HEX6VmiYJ5vBKtKY3d+7mdwJNCvZpHu735gK1aL6QzYxWQ9gcyaRFa
         vHdb9CvFd8O8dre9FINmzTpxJjOkPT4hGh/NaVcwMXAdVdRykh0sdaKzsiz09OQGuHzn
         8u2WkHgpVqLCi5c/NaUtFWyLSEcDDqA9qHWKIn6PSQaiLh/44e2i+iWxG8HrMxSynb5C
         6phw==
Content-Disposition: inline
In-Reply-To: <509B3999.6060505-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello, Kamezawa.

On Thu, Nov 08, 2012 at 01:48:25PM +0900, Kamezawa Hiroyuki wrote:
> Could you explain what 'online' means here again, rather than changelog ?
> BTW, 'online' is a shared concept, between post_create() and pre_destroy(), among
> developpers ? Is it new ?

I'm prepping a patch to rename create, post_create, pre_destroy,
destroy operations to allocate, online, offline, free, so yeah the
terms and concepts will be used for all of cgroup.  I'll update the
docs in that patch.

Thanks!

-- 
tejun
