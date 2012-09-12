From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] xattr: mark variable as uninitialized to make both gcc
 and smatch happy
Date: Wed, 12 Sep 2012 11:42:00 -0700
Message-ID: <20120912184200.GQ7677@google.com>
References: <20120912022813.GA17922@localhost>
 <20120912075517.GZ19396@mwanda>
 <20120912143112.GE19694@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DnOWTGv6au3nRwFqw9AHeLoFbyZ5g1O+BB3vtS2rMhI=;
        b=NzHbCHtMjZTDx5x/Xr4x9zdBffEEOBSFMOgEVPNgd5chOJh9QKAv6zfV9dbis3Tp4x
         C0Ej7RFnfpWZ2jCtuk98Az/FKYlkuxe8W8Il/n150kWExj/J0hhzip2E4DL9TIlVoJJ1
         IyOqlZm5YTEimxOqv6RyNJwTeCNjGGshO3gJg4AZbNyMMSsak2SHozqOmDOhSsR7Kuh2
         bYNyTBtmA6vbGbwsrM9uUlE4SuDrK1sKj7hJOlIa57/bVV2ByqpDac5L/7aB7ZQQyzO0
         epcvEbnLe0QnQo0GGTEFhBlgxFgLF3Ig2CVR8Wjz7c2087+1usiUNIvqwqiLVWleMqlh
         hEbg==
Content-Disposition: inline
In-Reply-To: <20120912143112.GE19694-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Wed, Sep 12, 2012 at 10:31:13AM -0400, Aristeu Rozanski wrote:
> new_xattr in __simple_xattr_set() is only initialized with a valid
> pointer if value is not NULL, which only happens if this function is
> called directly with the intention to remove an existing extended
> attribute. Even being safe to be this way, smatch warns about possible
> NULL dereference. Dan Carpenter suggested using uninitialized_var()
> which will make both gcc and smatch happy.
> 
> Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

applied to cgroup/for-3.7. Thanks.

-- 
tejun
