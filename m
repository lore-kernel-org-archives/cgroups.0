From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-4.6] cgroup: update migration destination
 cgroup handling
Date: Tue, 8 Mar 2016 11:50:22 -0500
Message-ID: <20160308165022.GB3447@mtj.duckdns.org>
References: <1457025602-4193-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WuTby+pfJwBuVsMpoENk1f3s8lyrRXKk2BVpwQqoG+w=;
        b=Nc6NYnhQlKIUFwbyKApbfluTHL+piwgDF3gFChLDpjCQm2xInjZ8f7Ir1jYSEUM617
         YLx9ymS2lgIVqPhgm2eAqYjl6l+qNNsZvP3gCkmma5e7ALgojCd+M9svfpudd/C+ArBJ
         SAciqDhE+jkudgCtcALW3iC1zjSQVuiNI3j+/14hKo4F6hAhZEBB+xAXpoTv+3Y/O1Bq
         +kNcWbIWK5RdlFQu/llziaIZTcXFqd4L+wLrlEYnLwTrlM63K2P9y92BIVjyrmCkwcaY
         d8q6cp5QWTEh+O7vMoG9zLQsIwW1A4AJTR5A3mF+R5Frg8W8ClAe0rM2ouxDWSMFiuBh
         BQ/g==
Content-Disposition: inline
In-Reply-To: <1457025602-4193-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Mar 03, 2016 at 12:19:58PM -0500, Tejun Heo wrote:
> cgroup migrations used to always be single destination.  There could
> be multiple sources but there was only one destination cgroup.  This
> changed with default hierarchy as enabling a controller would move
> processes in child cgroups into separate csses.  This was developed
> over time and is working correctly now but the way multiple
> destinations are handled is hacky and fragile.  This patchset updates
> migration logic so that multi-destination handling is integral.
> 
> This patchset contains the following four patches.
> 
>  0001-cgroup-fix-incorrect-destination-cgroup-in-cgroup_up.patch
>  0002-cgroup-move-migration-destination-verification-out-o.patch
>  0003-cgroup-make-cgroup-_taskset-_migrate-take-cgroup_roo.patch
>  0004-cgroup-use-css_set-mg_dst_cgrp-for-the-migration-tar.patch

These changes are mostly mechanical and I want them to be in for-4.6
for a while before the merge window opens up.  Applying to
cgroup/for-4.6.  In the unlikely case that this breaks something,
let's fix with followup patches.

Thanks.

-- 
tejun
