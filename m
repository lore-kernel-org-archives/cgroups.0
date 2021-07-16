From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove cgroup_mount from comments
Date: Fri, 16 Jul 2021 06:18:01 -1000
Message-ID: <YPGxObHzJFMeQZOn@mtj.duckdns.org>
References: <20210716091853.1049-1-zhaoxiaoqiang11@jd.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=amX7qutlZhujxzkVI8h2MRjygSTlMU+z05sQsjTc09A=;
        b=Z6cx7oOfjGT/bqo9cOCBh4nVHwF7jXwmbr8Jj/+TlHpueGN904486L2JjfhzoKxAmV
         2n3W94KJi32sEwFcVXXBEY+GnSY7zya1JImCg6egRRFj2R6Ato5OqzTlbCLVwA4GEBWi
         BJbf06wb6v85bbHBefrWfcacWDjSbg1s6z85k/+kyODmbPTpzpJI9A/uWnEj48+P8XXQ
         9lKRcDvJtM1nKWfaX9PU4fWgz2yk9TZ5zCeXANTiPC/JR/02SA80S9HJqG4owN1JG1rV
         4CV4pglY8wKpmatjqvrnuhBNotSYH9VLrWkfRrh0nX8/UMM3MAUmuETNkG4Wh8mlPvbC
         EF5g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210716091853.1049-1-zhaoxiaoqiang11-zFXdYKnZPWw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhaoxiaoqiang007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zhaoxiaoqiang11 <zhaoxiaoqiang11-zFXdYKnZPWw@public.gmane.org>

On Fri, Jul 16, 2021 at 05:18:53PM +0800, zhaoxiaoqiang007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: zhaoxiaoqiang11 <zhaoxiaoqiang11-zFXdYKnZPWw@public.gmane.org>
> 
> Git rid of the inappropriate comment
> 
> Since cgroup is fully switched to fs_context, function cgroup_mount
> is removed and it's confused to mention in comments of cgroup_kill_sb.
> Just wipe it out.
> 
> Signed-off-by: zhaoxiaoqiang11 <zhaoxiaoqiang11-zFXdYKnZPWw@public.gmane.org>

Applied to cgroup/for-5.15 w/ some description tweaks.

Thanks.

-- 
tejun
