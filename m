From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 20/26] cgroup/misc: allow users of misc cgroup to read
 specific cgroup usage
Date: Mon, 14 Nov 2022 12:31:48 -1000
Message-ID: <Y3LB1BFd/sOLsXzO@slm.duckdns.org>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
 <20221111183532.3676646-21-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e5A16Ay9WyYCQmWvCX/jvqpdD2vUzvsfZOGGNVeLuVY=;
        b=TFl1ZbdlJOpsDfCgBjQF2vn2LxlHXUTAHsMp2CbR2TqdFWeND8Q+z+rRTpBQOrzdcM
         Jp+XdMQPArXvPAwCVtd9/KVVP8ONG/UHUUx/W9wYWi/dcJvXM2xw1eb2R6agutHbh/3t
         +gfQBflCAjwo+mSUg/ksCviOednjdYYfSsJ/u+0yOlO3wpmvckn4ybsMOUZ9gy2rGshp
         27kV4j0/706xRFvAhEo+S1bLasJ7wMUrn7xvMOBb2aZ/2+OcGwFG6qbjh/2g6PIOg91b
         h/SKsiQ9/FcfzwKurf/rFL8l86uH5Q00ZxRTgV3+9y/X2r5XRjoV+GCEGBbWGlZ5OOXf
         dkUw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221111183532.3676646-21-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Fri, Nov 11, 2022 at 10:35:25AM -0800, Kristen Carlson Accardi wrote:
> Add a function to return the current usage of the specified cgroup.
> The SGX driver will need this information to decide whether to
> reclaim EPC pages from a cgroup.

This looks fine to me. It'd probably a good idea to keep all the interface
function names consistent with this.

Thanks.

-- 
tejun
