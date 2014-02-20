From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] sysfs: fix namespace refcnt leak
Date: Thu, 20 Feb 2014 09:30:18 -0500
Message-ID: <20140220143018.GE6897@htj.dyndns.org>
References: <53018813.7030409@huawei.com>
 <20140218231242.GJ31892@mtj.dyndns.org>
 <53040B50.4060600@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=bIoaJXYtTl3WBeYO7Tty/XFd2gw6hH97jDUffN+jrOU=;
        b=uYKrG346LlZb3HVCOy91dnab2+eQNYBO1ydcH3mcmYrOzmK9QxuoTSnfYWp6V2GIHY
         jkjqBgbtpz+tcZwLFJbyk/pPfENFXIy4fSSVSBMElCFIWZpwHARm8JW5Zm1RwUJ0S1XW
         DLXeNBIxu+OKfh5QGQUX29e9I1Tv2VxFlKlB4mjqsNCTViG7mlNCSxGMrAV21MQSF0xZ
         al+3VqFZbE5UUWslhzrPRaSHe+6gm1oH7NyJoINetS2OHZt1LPftWPFNC6qO3MdJ2N8T
         tnUaYWKC5YRjj19RD1PXJPYDpnhJZanCstYwTW5MyvqNS7GIzWk8INIR91pjBw5iaD0E
         JLgA==
Content-Disposition: inline
In-Reply-To: <53040B50.4060600-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Wed, Feb 19, 2014 at 09:39:28AM +0800, Li Zefan wrote:
> > Can we make it optional so that users who don't care about it can
> > ignore it?
> 
> cgroupfs also needs this to fix refcnt leak.

Ah, okay.

> Because success in finding an existing cgroup_root doesn't mean no new
> superblock is needed. For example:
> 
>   # mount -t cgroup -o cpuacct xxx /cgroup
>   # mkdir /cgroup/tmp
>   # umount /cgroup    <--- sb will be freed but cgroup_root won't
> 
>   // this will allocate new sb, but we find the cgroup_root is there.
>   # mount -t cgroup -o cpuacct xxx /cgroup
> 
> But debugfs won't need this if it's converted to kernfs.
> 
> How about I keep kernfs_mount() API intact, and when this fix gets
> merged into mainline, you merge the fix into cgroup-next, and then
> I make a fix for cgroup by changing kernfs_mount()?

If we need kernfs_mount() modified anyway, let's do it in this patch.
I still think it'd be better to allow the parameter to be NULL but
other than that, no objection.

Thanks!

-- 
tejun
