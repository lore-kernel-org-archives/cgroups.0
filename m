From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] fs: add documentation to simple_xattr functions
Date: Wed, 5 Sep 2012 15:50:27 -0700
Message-ID: <20120905225027.GB29092@google.com>
References: <20120905183132.806473183@napanee.usersys.redhat.com>
 <20120905183133.461178345@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GSP+R9JtpLRxOZrW1lpWNH/QPLq57Z/q9S2lufH7hiI=;
        b=nkou+KwpnXEsyhRdbzFFwMgD4pU0oCRXf+IUOhGajNT6+jK9qBnQZpGLOuGvv2mHai
         7zCqNz/x0BkvFPC/HgdsUeLT5ZZcDcVf/X6EclMAtA663qjTSmRb0KJu6zD4DOY1QBH6
         5Ncj2s6oX3lRFvj90MxoG6VYUR0B8wiJ3++v4G2MWKISKWYahnhJNloAvV/eA+Kg4+US
         c/wg1jJI4L45c/rn4H/gvIeVqdq+BNIzulfDd3ACP2XGNeYlZk7ofvTfnxNaocaJMGTl
         5u6SxzToAq1DWtofwDM8Y7xc7Xe1Ung61+AMKlW8zp0e8LLJimozLkDPgHTb+TQzCRBW
         mTlg==
Content-Disposition: inline
In-Reply-To: <20120905183133.461178345-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Sep 05, 2012 at 02:31:34PM -0400, Aristeu Rozanski wrote:
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Can you make these function comments instead?

Thanks.

-- 
tejun
