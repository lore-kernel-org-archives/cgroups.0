From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: fix RCU lockdep splat in
 cpuset_print_task_mems_allowed()
Date: Tue, 12 Mar 2013 14:25:47 -0700
Message-ID: <20130312212547.GL25266@htj.dyndns.org>
References: <513E92D7.9050903@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=pnMojC2yxwgFtzUAuf4Q3C92NRoQlNsXbPxtm+AkfbI=;
        b=A+rXjdSPrP0StHQoF3XNcqZ9xA9hnYLq4g5ChmnwyKsUVeVdsZ1m03EfCWXjZNnKw1
         hqupK4oAaCnj7Qr/uC9cjUFvXFCKp2AHNXzj+uDPC9S/fRF29JGvzUSi0NGDbAA2tq9N
         tg4zUk4as2HwKkuahoCHXOLaidCMmRspEj3IwLLSZ+DLvSYi8Pf6myL5XFYKJB+FQFNm
         eo+DQplBxhvZPP1cwGB81+a5+SUfjRRcA4L6NBcLxEQiLUpQdN5mk6gCfT6rEDj5V3zE
         5/wBVTOMzn+a9Lzm5LETEFTf4cerZO1cI6ARlL597xfooDEerQpmCUNWsEXR3cIkelCy
         ydCg==
Content-Disposition: inline
In-Reply-To: <513E92D7.9050903-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 12, 2013 at 10:28:39AM +0800, Li Zefan wrote:
> Sasha reported a lockdep warning when OOM was triggered. The reason
> is cgroup_name() should be called with rcu_read_lock() held.
> 
> Reported-by: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
