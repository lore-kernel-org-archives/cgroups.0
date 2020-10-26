From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Mon, 26 Oct 2020 09:47:11 -0400
Message-ID: <20201026134711.GB73258@mtj.duckdns.org>
References: <20201012102757.83192-1-chenzhou10@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QpRl8nb/okmu5mxEF73+jt6XHfqyPJBohilPccW7jX0=;
        b=cahbSm9HrLJ2d6FZyd5IykINox1xnvgkhJ0BkJLnnP31WgnC1PDdIzcn8fAOvXdtxC
         s7kKJ6X/SkGJs/f1Q/PjP7KfEWjgJqJu7oHEoxOKulcGYDjQk4ZT9zp9RO/rXkoAGQLt
         zZGs9GMuYOrl837w73p8EikFy9UUVdhy7fhC+cjFEvI9WJQJ6+iIqnJiyg5XAJV3Pikb
         ft6ertavexvL1d8ycx6THkVI2XszqmdAKC2h95QAn+KGOdbjQON259St8Y5zVGTpncR9
         RLaa5tjgP2sXD/Xycvtzdpz49YedMY744Out/6+LhttoDcOTcv6jCxmxLLqjH5n4ZMSv
         BAVA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20201012102757.83192-1-chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon, Oct 12, 2020 at 06:27:57PM +0800, Chen Zhou wrote:
> When mounting a cgroup hierarchy with disabled controller in cgroup v1,
> all available controllers will be attached.
> 
> Add disabled controller check in cgroup1_parse_param() and return directly
> if the specified controller is disabled.
> 
> Signed-off-by: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

check_cgroupfs_options() is already checking the condition. How does also
checking in parse_param() help?

Thanks.

-- 
tejun
