From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: cgroup_rm_files() was calling simple_unlink()
 with the wrong inode
Date: Mon, 9 Jul 2012 10:11:07 -0700
Message-ID: <20120709171107.GC1341@google.com>
References: <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
 <20120629165809.GB21048@google.com>
 <4FEE98EE.1050409@huawei.com>
 <20120630064724.GC14083@ZenIV.linux.org.uk>
 <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com>
 <20120630083421.GD14083@ZenIV.linux.org.uk>
 <20120703171033.GC555@google.com>
 <20120703173806.GD555@google.com>
 <4FF3D757.9060905@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ua+NDJLgCqmkg/NwM974ODH5tlMRjSYZjGEyGKh4AiU=;
        b=fGsF6yx/HqiCKtXgWSL1CO/tNKor/3DYUTobNpbVmicN6flaJtkUgyPHxElMdbcC/2
         Hnh2vghqD2uMChI11NFi6Z6Yco8Yt2nDPx+qHSpvZPWg9OYY6SCFc9AbB7fH7wCKEUda
         aJbJXrHNMfrNIZ7SmgdgJMYm0cL9tqrI85qOsUvZg0l6VAimL5nStJWUwlLMvPxwLLvj
         vZkqFx6ILdgeflouT+jjWPRsUxt/7kUh0r6962SsQJcGK1wBlB3jVT3YTjLu5oHNFFCb
         OA1BMuRroVuymoTHx/wDkcnt+CpY7qeo/++oBpRycE6Rol8p/r/6tZ5ngqP9jUjWlbjl
         JmRg==
Content-Disposition: inline
In-Reply-To: <4FF3D757.9060905-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jul 04, 2012 at 01:40:39PM +0800, Li Zefan wrote:
> Tejun Heo wrote:
> 
> >>From 6da2689412c78b97716ec524cc30baf7b46508cd Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Date: Tue, 3 Jul 2012 10:32:26 -0700
> > 
> > While refactoring cgroup file removal path, 05ef1d7c4a "cgroup:
> > introduce struct cfent" incorrectly changed the @dir argument of
> > simple_unlink() to the inode of the file being deleted instead of that
> > of the containing directory.
> > 
> > The effect of this bug is minor - ctime and mtime of the parent
> > weren't properly updated on file deletion.
> > 
> > Fix it by using @cgrp->dentry->d_inode instead.
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Reported-by: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> 
> 
> Acked-By: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

I think it's now a bit too late for for-3.5-fixes and the effect of
the bug is rather minor.  Applied to cgroup/for-3.6 w/ stable cc'd.

Thanks.

-- 
tejun
