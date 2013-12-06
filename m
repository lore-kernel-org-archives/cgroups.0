From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
Date: Fri, 6 Dec 2013 11:25:03 -0500
Message-ID: <20131206162503.GD13373@htj.dyndns.org>
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com>
 <20131205211814.GA29598@mtj.dyndns.org>
 <52A1766F.5090808@parallels.com>
 <20131206161312.GC13373@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zm7k8XfqLyuB0Eid87nM0XzlSPxdPoTdjUF0Uni+jJM=;
        b=eI5lbF6KmS3deLsGiIjJNy+LZfBWUSFPUQ+98DhmI9ljOLHuq7zX8da58SIa3eMPWZ
         WclEQpIn8U7htjkJMNbBYpMsKGzz5JOnuUNtY2DqLYn33C7pk/Rgps4UMdlCAoUdD7vu
         5Z0YW2dyfjtbOOfoRCB6VG4m+etTVz5KQjgbHAVXeSVNxgIUQQqGQ3qGbSOBokiAoRAK
         u7CiQU9+AfxLzFOKUuknGafzh+1IvF69QwnjF+hVRtKyirGSeYVeBpfxiIWdPPcnYSAp
         GGJjyp9mjVJyIbXVhjI3ncvSfHUdN29aE9FpekPlpkDyUQN4c52auwie/fHgNuUNZFnn
         QZIg==
Content-Disposition: inline
In-Reply-To: <20131206161312.GC13373-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Fri, Dec 06, 2013 at 11:13:12AM -0500, Tejun Heo wrote:
> > Second, it's not clear to me why we need the CSS_ONLINE flag at all if
> > we never assign css's that we fail to online to a cgroup. AFAIU we will
> > never see such css's, because in all places we call offline_css(),
> > namely cgroup_destroy_locked() (via kill_css()) and
> > cgroup_unload_subsys(), we use cgroup_css() which will return NULL for them.
> 
> The whole thing is in flux and will look very different in near
> future.  I actually had patches queued which deal with the issue you
> spotted but they are being blocked on other changes ATM.  So, yeah,
> there are some spurious stuff now.

LOL, I found the patch.  It was posted and acked I just forgot to
apply the whole series.  I'm a moron.

  http://permalink.gmane.org/gmane.linux.kernel.containers/26804

This should do it, right?  I'll update the patch description and
repost the series.

Thanks!

-- 
tejun
