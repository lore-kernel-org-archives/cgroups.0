From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [bug report] writeback: sync returns with dirty pages exist
Date: Mon, 4 Dec 2017 12:21:00 -0800
Message-ID: <20171204202100.GE2421075@devbig577.frc2.facebook.com>
References: <dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hDQCOoSiJvaPMvpDdoOBJ0w7QUTl9D2cS2M8fZQIE7c=;
        b=s7Q+OnvagTP6jUWbkXX/N1UqBG/Yt9gZs7N4cf4bp6QdvO4BL0ClngdO7CFl4c8NKc
         wNOn2zyORNEtDM93vM66aFlXg0hQGasBjZ1TJKbq9iaCnpEA/JmWGrKztOSzCs3+SdBr
         bT7PJyF3vO8MwEpr2YSDnWZsNraKYuE4Nb+5xlI+KClQ2HCZTFkGaFF+XUkKMjDDnl8h
         hjLLmwA4GjBRGFcPOsnEshPk6+OEZIaOgFUPaFRRAxonsGYzIpSOWKYgYO2gf5yafmV/
         IfIl83aNIDGteFiqJfTVfgIF2KGabZjk8B3RyP+hTecs1pQZKfldF3MQ7RZ5CzhljOeO
         tc1Q==
Content-Disposition: inline
In-Reply-To: <dc694ae2-f07f-61e1-7097-7c8411cee12d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xuejiufei <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Dec 04, 2017 at 03:13:34PM +0800, xuejiufei wrote:
> I have found that system call sync may return even if dirty pages still
> exist. This is caused by the following case:
> 
> sync
> -> sync_inodes_sb()
>   -> bdi_split_work_to_wbs() queue works for each wb
>   -> wb_wait_for_completions() wait for these works to complete.
> 
> >>>>>> race window. Writeback thread found it should switch to another
> new wb while doing foreign cgroup detect. So a new wb is created, and
> the inodes are move from old wb to the new one. The writeback work for
> old wb is done, so the sync process is woken while the inodes with dirty
> pages are still queued in new wb.

Oops, yeah, that sounds plausible.  Will look into it.

Thanks.

-- 
tejun
