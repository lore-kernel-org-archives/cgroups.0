From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 04/11] sched: adjust exec_clock to use it as cpu usage
 metric
Date: Thu, 6 Jun 2013 16:00:12 -0700
Message-ID: <20130606230012.GN5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
 <1369825402-31046-5-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mtJ8RresPLQ/Hw0JJrq7FO09HPryfKWpJzvcsioOWII=;
        b=fCYelUWA0DqHh17C+4WmHp82ErtAl+MNkm/1rIBRgMPKf+qTQ9IHIevM7jKO7mVA/k
         zCVnUIwAN+EikXQREKs7oxDwOdJibyqjG8b/bRumfMqogsYRTTlnZtjSfRy5eGDCHPGQ
         br5QYRw5+2S7ibW0LX9gE+PF6dI+VdpEsjumAwF4YyRaphDFl3yrq+LBFmQzRS1Ky7XK
         hZy5XgoVFlFFdLuQ06dE5ZZwYbr0QN61GPI6w7iUBubVdlnNYUU+62YfbzJRSwzs3iDJ
         fI1eoNwpUdRtk8oxC37UnMsFpXqKmU3jecvmisNg06gtTC4tKsKufodKLcLYcbot3wHx
         6hZQ==
Content-Disposition: inline
In-Reply-To: <1369825402-31046-5-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

On Wed, May 29, 2013 at 03:03:15PM +0400, Glauber Costa wrote:
> exec_clock already provides per-group cpu usage metrics, and can be
> reused by cpuacct in case cpu and cpuacct are comounted.
> 
> However, it is only provided by tasks in fair class. Doing the same for
> rt is easy, and can be done in an already existing hierarchy loop. This
> is an improvement over the independent hierarchy walk executed by
> cpuacct.
> 
> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> CC: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
> CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
> CC: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
> CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
