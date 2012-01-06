From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Date: Thu, 5 Jan 2012 18:27:34 -0800
Message-ID: <20120106022734.GB6276@google.com>
References: <4EF9291D.7030208@cn.fujitsu.com>
 <20111227163535.GA17712@google.com>
 <4EFAB2E2.4040008@cn.fujitsu.com>
 <20111228163631.GN17712@google.com>
 <4EFBD55E.5030106@cn.fujitsu.com>
 <20111229162313.GD3516@google.com>
 <4EFD531C.50300@cn.fujitsu.com>
 <20120105174507.GC18486@google.com>
 <4F065B6F.6060506@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zgPAf4NpS1jOxPyulSbE0j5qZbju9j+qQVIUvojwvV4=;
        b=i9LwVltQ1KJABjnYgXNx+vuk04rAxDVTBqcIhzYEcgbsNVuB1Hkzt1cWJCGHLZkxdP
         bJHB6z0ukqmHrcuT3ZHNLziSfJ4XJJ4IoORSffSOX2wrqU/mfqVueDaXsDiP62AkTEyq
         N94SPOao3sEIYwiIeb7LIEQvjr86pp//uCPX0=
Content-Disposition: inline
In-Reply-To: <4F065B6F.6060506-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Fri, Jan 06, 2012 at 10:24:47AM +0800, Li Zefan wrote:
> There's a corner case where "mount --bind" can't be used:
> 
> 	# mount -t cgroup -o none,name=hier1 xxx /mnt
> 	# mkdir /mnt/tmp
> 	# umount /mnt
> 
> Since there's a sub-cgroup in it, umount won't destroy the hierarchy,
> but "hide" it, so the name=xxx is necessary to re-mount it.
>
> > Also, what's the use case for
> > mounting the same cgroup directory multiple times?  Why is that
> > necessary?  Is it useful for some namespace-savvy setup?
> 
> I don't have a use case in real life. It was made so at the very
> beginning of cgroup, and we should't break it without strong reasons.
> We can mount other pseudo filesystems like procfs, sysfs and debugfs
> multiple times, right?

Yeah, we shouldn't break it so I applied the patch with a lot of
grumbling.  This is something which shouldn't have existed at all. :(

Thanks a lot for the explanation and patience.

-- 
tejun
