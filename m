From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix obsolete function name
Date: Mon, 17 Jul 2023 08:39:22 -1000
Message-ID: <ZLWK2q9OVath4J05@slm.duckdns.org>
References: <20230717112800.2949233-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689619164; x=1692211164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zw4pfToCDzbwKl5whorLOvvLRVs7p/9il+TGwrm7FW4=;
        b=WbCf7Pvxbd5alM4qarjJypY0xX0G2HGUACwFvzhosxjp9f2/b9QcbmhAf1i2D2b+8q
         Kj0Qyr843i2e35Pd3EjxM8eWpncjATlCOKkc2sOwGVaCV59Uqa3mF0YZ+4XZp7o705kE
         8jUGbw/LYWab5l5dBzhRyKfykFo7EJst/cC7TBeLm0ZkyImUZTZNWCBG4bBAQhpg6urv
         gDI0HZiWpAmlecMbCK21cJmpWHZnu6J/gbQ7LHzMCSfx+BQAlM6JdBD0+6eaaiJEy000
         VcdpPrsqSTKn2gLgI+Simyj1PwohqhlxcZemESymq0ECseqziwcSHS2DxgeyZtMO3YPq
         eSyA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230717112800.2949233-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jul 17, 2023 at 07:28:00PM +0800, Miaohe Lin wrote:
> cgroup_taskset_migrate() has been renamed to cgroup_migrate_execute() since
> commit e595cd706982 ("cgroup: track migration context in cgroup_mgctx").
> Update the corresponding comment.

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
