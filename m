From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 0/4] cgroup: add xattr support
Date: Fri, 24 Aug 2012 15:58:39 -0700
Message-ID: <20120824225839.GM21325@google.com>
References: <20120823205327.237533518@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lG1QGxhenbfwSofB3eMWYIqgkEla10yRvKxaCJ7mnTE=;
        b=RwD54702sts3Sx6Zyon6ntW29v2HH4MUJZLoMWbTt/dHs7kgpZo4hz9ZXc1C7D6brp
         lgzOWylCU2Nz0E2ePpqY4oCVZAaSa0JF3t5Yu1YlnIqWiPeKovbs63Eb1oW5yzsc+6bt
         SQ28sSB9H9x9Rz2N/nlcKq0fAGyREe5bnxhXeGSdWZBUhDYN4DNwt2MO/+2u8pJtuWAB
         8JEVrFxY8gIyLoeagb1k6HKxMQms2tztnGY+fkaKNOx/wZoIPThxkoJ7W9GjsxLy/mKx
         hhmpNjweWOiVul+3fEXlAFIw+LUJfF8QgP+bYDzjLQM0B0JEyW5PutZos4ZJFohG9IkK
         lOZg==
Content-Disposition: inline
In-Reply-To: <20120823205327.237533518-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Thu, Aug 23, 2012 at 04:53:27PM -0400, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> This series are a refreshed version of a patchset submitted by Li Zefan back
> in march:
> 	https://lkml.org/lkml/2012/3/1/13

Applied to cgroup/for-3.7 w/ "Original-Patch-by: Li Zefan" added for
the first three patches.

* Can you please update MTA setting so that the From: header contains
  your full name?  Importing the series to git ended up with
  "aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>".

* Can you please add some comments and documentation regarding this?

Thanks.

-- 
tejun
