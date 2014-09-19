From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] perf/cgroup: Remove perf_put_cgroup()
Date: Fri, 19 Sep 2014 09:18:13 -0400
Message-ID: <20140919131813.GB30493@mtj.dyndns.org>
References: <541BEEFA.1020800@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DmDhgpXiZd/xVwj4TCrT07OnpTfBCC3Y09Bsh4vsgaE=;
        b=HKe7kgd6rhSymcnq/57X+Uddcy9I3CKJOvuUvCm4J+O3tWW6YYsao4jghK/Q9S7hN6
         Tl8nUYUO1mX1ncYdG4OkXDR3eTUaVarwbtg9YPiGJbHjX2P8aSx2xFoJSJqhlYCP3sQx
         CvZASHvkqAK9gFYCJFZA9WWIipxpOsOjyBZL7xWylRnx0TgO9zMJoQ1RU3GSx3uwid3H
         5if05yS+vSlHsI9yH+x3jOauwW8ROtmSbJYPZnVnqv9BbafH2o540b/CvfSBlBcw0FhH
         V7SPRgCuYIOSpn3mQw9CGWg2tLcHrqis79M+tB9igQw+U7HxZn9zK/faRlU5wNL3eKtT
         Cdjw==
Content-Disposition: inline
In-Reply-To: <541BEEFA.1020800-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Sep 19, 2014 at 04:53:14PM +0800, Zefan Li wrote:
> Commit 5a17f543ed68 ("cgroup: improve css_from_dir() into css_tryget_from_dir()")
> removed perf_tryget_cgroup(), so let's also remove perf_put_cgroup().
> 
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
