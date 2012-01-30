From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove extra calls to find_existing_css_set
Date: Mon, 30 Jan 2012 13:01:28 -0800
Message-ID: <20120130210128.GA27051@google.com>
References: <1327956716-11537-1-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Hjhhqp09ZeALgzw6XT5EUoMokKBgpE07ssATmdGC2l0=;
        b=hnJWe8gZNgVxTyJdAV2hpvkaeA0WeaD6ZNQ8VsnIdKAdgVZq92aMIY48Rcb/MBhYmO
         oXeQRNqVm47LEry4q9qSVF5/yM7uPOZ01G+wLJ7GAR3594U/EISs4cfr4Joi33FN0Nor
         2lzK142TM4fmY8jni/2rYI81JkcGBkwhpHoQ4=
Content-Disposition: inline
In-Reply-To: <1327956716-11537-1-git-send-email-msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

Hello,

On Mon, Jan 30, 2012 at 12:51:56PM -0800, Mandeep Singh Baines wrote:
> -	/*
> +        /*

Whitespace contamination fixed.

Applied to cgroup/for-3.4 w/ previous Acked-by's added.  Please
collect them on submission.

Thanks a lot!

-- 
tejun
