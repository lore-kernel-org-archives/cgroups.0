From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix bogus kernel warnings when cgroup_create()
 failed
Date: Tue, 22 Jan 2013 16:29:50 -0800
Message-ID: <20130123002950.GC5359@htj.dyndns.org>
References: <50FD15F9.1090701@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=sfkw/Mhjno49yXQKNEUohWxqwqpoBKb91ulQhetQ9Rg=;
        b=RHXnmEJBYIskrKoQuzKdfdqQSmTsXaGTBqMGTOK5A2JbsbhgFvGhz0k7zKc6Hw/9Ht
         lOBwJq/t1C8dCpFTSliXSPfP3G+SkLpAdSlWGA1qeYjJCxZpHzOOvJOSN2Pzq3XF+kXi
         bf3wy66uc79uAnttOmxIQo/M9v9hD6fn8jYvGO4cduZWa/0DFlr2BleEMLS6v0NHT5/J
         2V+xbN0/MSA4ZorRnsooyebcQfQagYnTm8iq6goVjuuljTWg8WdNYCTdy7HrojBfnhZQ
         se/y6psVh0ABg6BI9VgOkFFz3vkNq9XQacE4GTWhxc6jodEbk9aubQloj/lXiMOWdGTW
         nhwQ==
Content-Disposition: inline
In-Reply-To: <50FD15F9.1090701-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jan 21, 2013 at 06:18:33PM +0800, Li Zefan wrote:
> If cgroup_create() failed and cgroup_destroy_locked() is called to
> do cleanup, we'll see a bunch of warnings:
> 
> cgroup_addrm_files: failed to remove 2MB.limit_in_bytes, err=-2
> cgroup_addrm_files: failed to remove 2MB.usage_in_bytes, err=-2
> cgroup_addrm_files: failed to remove 2MB.max_usage_in_bytes, err=-2
> cgroup_addrm_files: failed to remove 2MB.failcnt, err=-2
> cgroup_addrm_files: failed to remove prioidx, err=-2
> cgroup_addrm_files: failed to remove ifpriomap, err=-2
> ...
> 
> We failed to remove those files, because cgroup_create() has failed
> before creating those cgroup files.
> 
> To fix this, we simply don't warn if cgroup_rm_file() can't find the
> cft entry.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.9.  Thanks!

-- 
tejun
