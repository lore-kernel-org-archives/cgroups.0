From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cgroup: export list of cgroups v2 features using
 sysfs
Date: Mon, 6 Nov 2017 12:02:31 -0800
Message-ID: <20171106200231.GF3252168@devbig577.frc2.facebook.com>
References: <20171106173854.GE3252168@devbig577.frc2.facebook.com>
 <20171106183029.21297-1-guro@fb.com>
 <20171106183029.21297-2-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JBE21bW4Q4686F1NAVEuMvuzfLiHq2CY5WUHzFVlzTc=;
        b=cGJvZeVlOGsZ7E737ktRsx6+uFNJoVYOF67UJB7JAlo4zrgkYRkZZ8RkRTi2UKe9Fl
         D0mJbYpMWSLdrjf64sB4MigkrGRWRRHi1GZ1IYihDD5miQoAJXaVJumJQjEJZ/B3I7pu
         ObKIg9ytN+a7juUxwWxidRpRNR02sQAv4Sgt+SSfx4B6QrI/dafYvQwjZ52LHqYzupYK
         DPV+BNco18s+t0pVfshDvRNU6zouo7PbmezeVYLYqL29H4khJMzGXGXDH4F4o5MhKJ7R
         l7cVir8ER+suvpMqfqoYX+PsOUukMpVaQUZ3PIc0LBOU4TqkYErl923JWsqkKG5OeooY
         EM0A==
Content-Disposition: inline
In-Reply-To: <20171106183029.21297-2-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 06, 2017 at 01:30:29PM -0500, Roman Gushchin wrote:
> The active development of cgroups v2 sometimes leads to a creation
> of interfaces, which are not turned on by default (to provide
> backward compatibility). It's handy to know from userspace, which
> cgroup v2 features are supported without calculating it based
> on the kernel version. So, let's export the list of such features
> using /sys/kernel/cgroup/features pseudo-file.
> 
> The list is hardcoded and has to be extended when new functionality
> is added. Each feature is printed on a new line.
> 
> Example:
>   $ cat /sys/kernel/cgroup/features
>   nsdelegate
> 
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: kernel-team-b10kYP2dOMg@public.gmane.org

Applied 1-2 to cgroup/for-4.15.

Thanks.

-- 
tejun
