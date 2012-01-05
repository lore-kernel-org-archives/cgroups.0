From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Date: Thu, 5 Jan 2012 09:45:07 -0800
Message-ID: <20120105174507.GC18486@google.com>
References: <4EF9291D.7030208@cn.fujitsu.com>
 <20111227163535.GA17712@google.com>
 <4EFAB2E2.4040008@cn.fujitsu.com>
 <20111228163631.GN17712@google.com>
 <4EFBD55E.5030106@cn.fujitsu.com>
 <20111229162313.GD3516@google.com>
 <4EFD531C.50300@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iPT3YEzBazwpWuJ2g1HA7Y54carccUvWqyJ3QQu7cFU=;
        b=hUC7qogYa6Ti7Gh+has0avu6NGXjevsJ8eD6WcxWrbj13S2d7ksd4p846AY853xnrt
         Gbiba/16bGuGlEiDIhpdoj8BzrW9OC6iRTiCPueWm/s5cqhZmcqBvAz/gs2vjXrnBrHf
         ygV2Rbal1Z3hwRjn9ZjGuiSWF9T380VfhdcOo=
Content-Disposition: inline
In-Reply-To: <4EFD531C.50300-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Fri, Dec 30, 2011 at 01:58:52PM +0800, Li Zefan wrote:
> Normal filesystems can have multi mount points, and an fs instance
> is identified by device name, but cgroupfs ignores device name like
> other pseudo filesystems. Instead a set of subsystems is used, so
> to mount the same cgroupfs instance in different mount points, we
> can do this:
> 
> 	# mount -t cgroup -o cpuset xxx /cgroup1
> 	# mount -t cgroup -o cpuset xxx /cgroup2
>
> Now we have the "none" option, so a cgroupfs can have no subsystems
> bound to it, and we allow multi instances of such cgroupfs, so we
> have to assign names to each instance:
> 
> 	# mount -t cgroup -o none,name=hier1 xxx /cgroup1
> 	# mount -t cgroup -o none,name=hier2 xxx /cgroup2
> 
> Then we want to also mount "hier1" in another mount point, we can't
> do this:
> 
> 	# mount -t cgroup -o none xxx /mnt
> 
> because we have two different instances with "none" subsystem. So
> we specify its name:
> 
> 	# mount -t cgroup -o none,name=hier1 xxx /mnt
> 
> Hope I have made things clear to you?

mount --bind?  It's not exactly the same thing but I don't think the
differences would matter for cgroup.  Also, what's the use case for
mounting the same cgroup directory multiple times?  Why is that
necessary?  Is it useful for some namespace-savvy setup?

> What I try to fix here is the behavior of "mount -t cgroup -o name=xxx ..."
> (no other options are specified), so what behavior do we want?
> 
> 1. find if any existing cgroupfs instance matches the name, which is
> the orginal behavior.
> 
> 2. the same as "mount -t cgroup -o all,name=xxx ...", which is the
> current behavior due to the commit that broke (1).
> 
> 3. make it invalid and fail to mount.
> 
> 4. any other idea?

I guess I'll apply the patches but it still seems like a silly
redundant feature.  If not, please enlighten me.

Thanks.

-- 
tejun
