From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Date: Wed, 28 Dec 2011 08:36:31 -0800
Message-ID: <20111228163631.GN17712@google.com>
References: <4EF9291D.7030208@cn.fujitsu.com>
 <20111227163535.GA17712@google.com>
 <4EFAB2E2.4040008@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=az5r2+Ze2ICyp8U6nlaCBY3XJwu+l/qsx2yuZ7GYuoo=;
        b=ZFLUo4LFtfvlCWBLM3u4xRY4IuD8PORqWoiPnkMBW1W2W808cGQ8hiS57/owfactdv
         WYClLU/HHIaZ8eclAcahOBovXOW+IQYBCPLfb709F/7Sy/bsI3y7HQJA3qbCUW2h+Ncj
         clp6yPFpT/HHKvuvtbH/cF+6Ua45BxwfFn27A=
Content-Disposition: inline
In-Reply-To: <4EFAB2E2.4040008-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Wed, Dec 28, 2011 at 02:10:42PM +0800, Li Zefan wrote:
> The "name" option was introduced along with the "none" option, so we
> can distinguish between different cgroup hierarchies which have no
> bound subsystems, like this:
> 
> 	# mount -t cgroup -o none,name=hier1 xxx /cgroup1
> 	# mount -t cgroup -o none,name=hier2 xxx /cgroup2
> 
> As the name is unique, we have this "mount by hierarchy name" feature.

I could be missing something but does that add anything other than
naming convenience?

> It looks reasonable, but I guess few people know this feature. We can
> live with it, as it only saves us some typing when mounting an existing
> hierarchy. On the other hand, removing this small feature can hardly
> result in code reduction.

If it's a redundant feature which has been broken over a year without
anyone complaining, it really doesn't need to exist.  It might not
save a lot of code but would save some WTH moments.

Thanks.

-- 
tejun
