From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix the retry path of cgroup_mount()
Date: Thu, 17 Apr 2014 11:20:48 -0400
Message-ID: <20140417152048.GL15326@htj.dyndns.org>
References: <534F6C44.2060800@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NqM62sLvWUqBLjlAfYKdIPnOM4xxcTGWNBDUNYll3BA=;
        b=TKyG+nXwTBIqDTZGpoAuUEvblG14MPxgBDJeRXrco3uFNmQGR11nJ6sqL/fSOtMtv7
         dhduRSDjvDMOgUO1hZjgz/rke8kQAl/MiT0pUIncTUOMg8on8BLbZ/BCE/wOxUFGWGXo
         SxkGjyPkrMknpVw9xsMIzzKOtlMxFlDwew29twsU9P26eUXCUz9xquA+wCsoocWBYHNn
         67xxpZK14jUtHEkzjR6DRtlBbuLJ8CwNsOtRBd7HPjNIQ2yaBsW1XvlQabZVTvflFuAp
         ixztadzxC5WP3cwQJf1/AHDjQ35M+pn0dW6ddS6nMYEu4tEaOg/KIcy+dWTWv/WqsazF
         rY3w==
Content-Disposition: inline
In-Reply-To: <534F6C44.2060800-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Apr 17, 2014 at 01:53:08PM +0800, Li Zefan wrote:
> If we hit the retry path, we'll call parse_cgroupfs_options() again,
> but the string we pass to it has been modified by the previous call
> to this function.
> 
> This bug can be observed by:
> 
>   # mount -t cgroup -o name=foo,cpuset xxx /mnt && umount /mnt && \
>     mount -t cgroup -o name=foo,cpuset xxx /mnt
>   mount: wrong fs type, bad option, bad superblock on xxx,
>          missing codepage or helper program, or other error
>   ...
> 
> The second mount passed "name=foo,cpuset" to the parser, and then it
> hit the retry path and call the parser again, but this time the string
> passed to the parser is "name=foo".
> 
> To fix this, we avoid calling parse_cgroupfs_options() again in this
> case.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.15-fixes.

Thanks.

-- 
tejun
