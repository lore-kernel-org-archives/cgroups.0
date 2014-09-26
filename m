From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Revert "cgroup: remove redundant variable in
 cgroup_mount()"
Date: Fri, 26 Sep 2014 00:26:17 -0400
Message-ID: <20140926042617.GA14426@htj.dyndns.org>
References: <1411704205-28995-1-git-send-email-lizefan@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=s7Jb/BIBmHCBofu2fUORGIve+4wT/7WHWXea5OfFl0c=;
        b=OQrYgpX7lVKSL+uBUNY7KB3xb7QhguaTt4SyRk2D7/sETWSuaO1P71efWba0HhCdh1
         3k/wu3RK7Cys/0YlEZJX1HxPOOfbj8bGWXJ3uvB6zYi7WKP39a/S4n+i7/aHp6mcEdN8
         ufdgMrpbPmGKNXorvYg2J1WpNegXmTWM6JK2Il6qrjwsFtTjqWGyd0Bh20C+JauUJVgm
         aOGM7HR8Ekw2CVftIISgC4gE59rOtPniJ1kMfNkqIfwbJLPZdlPPG6D5dvaGuvYpGvjG
         4MncPx7fiNj7BxLK2RWUSvwQZs+NVyEjoVl5YkZH9gl7luDuBfErnfeTAh5hYPMMHixi
         5f1A==
Content-Disposition: inline
In-Reply-To: <1411704205-28995-1-git-send-email-lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

On Fri, Sep 26, 2014 at 12:03:25PM +0800, Zefan Li wrote:
> This reverts commit 0c7bf3e8cab7900e17ce7f97104c39927d835469.
> 
> If there are child cgroups in the cgroupfs and then we umount it,
> the superblock will be destroyed but the cgroup_root will be kept
> around. When we mount it again, cgroup_mount() will find this
> cgroup_root and allocate a new sb for it.
> 
> So with this commit we will be trapped in a dead loop in the case
> described above, because kernfs_pin_sb() keeps returning NULL.
> 
> Currently I don't see how we can avoid using both pinned_sb and
> new_sb, so just revert it.
> 
> Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Reported-by: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
