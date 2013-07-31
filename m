From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/7] cgroup: rename current_css_set_cg_links
Date: Wed, 31 Jul 2013 07:38:57 -0400
Message-ID: <20130731113857.GM2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C83F.6010407@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/9EMPn9vphndNP763Rmw3q0JTs+HXlVpVJSxw9NF5ZA=;
        b=one1r309Pue4a9FHW9ELhLHLZ6UNrQUHBYynUGaHyWbX/pwD7OsHT01VPLHoQmzsbT
         LZWkecouFQydSpK4WJoc8d4SyMDSfvpmMLYRTRwu0vTaBzr9cCrEd7TUSeKEUjcf1tCz
         klRrY2WQpXupMejThO4wnrisMDjrVVfw0RwziKfgo+g4lLhXcTmcE/q/mTkaeLDR2+PF
         0WjEMvcqRy79bT1f0oO/N2z/iz7kqhhQMMWt4mDNZzEU5FqlhpA6GYblM+YIIyYDuxHk
         9fGmdk8IRprnPdtCPUVu1D4DTGT2kHsx6670p9g7p6ds6IzWg8Bj7HbYKp8pHoC4NRwN
         1kYg==
Content-Disposition: inline
In-Reply-To: <51F8C83F.6010407-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Wed, Jul 31, 2013 at 04:18:07PM +0800, Li Zefan wrote:
> As we've renamed css_set->cg_links to css_set->cgrp_links (See commit
> 69d0206c79 "cgroup: bring some sanity to naming around cg_cgroup_link"),
> it's better to also rename the debug file.
> 
> As the "debug" cgroup subsystem is for debug only and acts as a sample
> on how to write a cgroup subsystem, it's fine to change the interface.

I'd rather not do this.  It doesn't really buy us anything and stuff
like cgrp_links isn't interesting to actual controllers anyway.

Thanks.

-- 
tejun
