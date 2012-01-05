From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: fix to allow mounting a hierarchy by name
Date: Thu, 5 Jan 2012 10:00:42 -0800
Message-ID: <20120105180042.GD18486@google.com>
References: <4EF9291D.7030208@cn.fujitsu.com>
 <4EF964F3.8090705@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fmFiNEK8vlpyj1h0D0ueT8Y93R76LGn3owKfMKIhf+Q=;
        b=pRWad/a3z+YI31rkTXyRUeonnSWqu5GE67/smhgJrZecSnZUGUSkESaBDkwAdfUb0S
         CNy/CkisPVi7cJdznQWG5W0nORCIF0bcUchRrjIr++FCb01SoO3xAA71Q19i7fkDUdpA
         xVJW5NbQJhUHqG5uZgKA+OwZwtipDBfj+A5Q0=
Content-Disposition: inline
In-Reply-To: <4EF964F3.8090705-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Dec 27, 2011 at 02:25:55PM +0800, Li Zefan wrote:
> If we mount a hierarchy with a specified name, the name is unique,
> and we can use it to mount the hierarchy without specifying its
> set of subsystem names. This feature is documented is
> Documentation/cgroups/cgroups.txt section 2.3
> 
> Here's an example:
> 
> 	# mount -t cgroup -o cpuset,name=myhier xxx /cgroup1
> 	# mount -t cgroup -o name=myhier xxx /cgroup2
> 
> But it was broken by commit 32a8cf235e2f192eb002755076994525cdbaa35a
> (cgroup: make the mount options parsing more accurate)
> 
> This fixes the regression.
> 
> Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Applied to cgroup/for-3.3 w/ cc to stable added.

Thank you.

-- 
tejun
