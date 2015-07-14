From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: add documentation for the PIDs controller
Date: Tue, 14 Jul 2015 17:32:01 -0400
Message-ID: <20150714213201.GE2273@mtj.duckdns.org>
References: <CAOviyagqdXEk=_4u0ijc2AJ-dkAEYYWVbjH_gy2TACmHAnhOOA@mail.gmail.com>
 <1434129718-8823-1-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=za3H9R/8b/w+VXMSnXWxQnIhMy/RymL7HBg44DksJvQ=;
        b=VW4EWAeFNlztUGEX0HqLzjLfRCqMDigi8pmLa1B95UufNrB+xuQwVUSUFe/9WIhH55
         cvfMuhBXP/64bl51Z31mKaEh4dtZ7kqknT2MCJqBVG15k6rjvQReH8IaawCR8Ne6K0lW
         daQG++Z6lWPLWrKaJ0WS9nh2lUvuUTUoVnBHHm9lXvDqiLYwcw2e9h5Gc4vQt5CAzVVi
         7CVUFinciuOHkobGJKHdlSu68O7eMKlb2g9pygHkguT54tA0j9mAhJ1mz/jCcZgBXUEA
         V4Mamm8LqyXtmw563P+eUpq7qeesk+xAYssM14YaTNdgcpeIJqSKGDIIUZtYprCYOTu3
         x8Rg==
Content-Disposition: inline
In-Reply-To: <1434129718-8823-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 13, 2015 at 03:21:58AM +1000, Aleksa Sarai wrote:
> The attached patch adds documentation concerning the PIDs controller.
> This should be applied alongside the rest of this patchset[1].
> 
> [1]: https://lkml.org/lkml/2015/6/9/320
> 
> 8<-----------------------------------------------------------------------------
> 
> Add documentation derived from kernel/cgroup_pids.c to the relevant
> Documentation/ directory, along with a few examples of how to use the
> PIDs controller as well an explanation of its peculiarities.
> 
> Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.3.

Thanks.

-- 
tejun
