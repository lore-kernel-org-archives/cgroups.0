From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 7/9] devcg: split single exception copy from
 dev_exceptions_copy()
Date: Tue, 29 Jan 2013 11:54:22 -0800
Message-ID: <20130129195422.GH6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190800.291395350@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=WWWNQwgXTuYdbUWQmHjUoz8ZmhISr5NQfXjj+DGn/j0=;
        b=LqOOvCsdV9iy27CXoajPOMCuBBlzzlkLRStQh2TUBosRwnwYeRX21WQK9Njv+aKT6Y
         awpv9NDUNMmTDUiHTZpUwJHUwEgyiziyu7wqnOnxk+3ILrizp2kEExaieNbZ6cwNXnbC
         61P/lU022FMpiBwb2Y0fN5VUTz523VVkyRV8IDe6CFH2tUfXwgbQUTIaXYYIaWklvN5l
         Lht1HiXut5AMdrKhv0AuFBxGtCGqcnN3EMO3OrLlEf5nIsy+HuF0DRLYvH99H4nripVf
         HeA6LORMOmjoDx5ckgP/wXesihzUreIwX1INQNC2uqW6hbWegA7tkQlvN87bQDZ3jU1Y
         KryA==
Content-Disposition: inline
In-Reply-To: <20130129190800.291395350-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Jan 29, 2013 at 02:08:06PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> This patch is in preparation for hierarchy support

It would be nice to note this is purely organizational and doesn't
make any functional changes.

> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
