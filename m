From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [cgroup:for-next 1/5] kernel/cgroup/misc.c:61 valid_type() warn:
 unsigned 'type' is never less than zero.
Date: Mon, 12 Apr 2021 23:21:18 -0700
Message-ID: <YHU4XrOW1dBIZfVl@google.com>
References: <202104131244.3qFwbTtx-lkp@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7kAWcxxGaZDdCTj+s71PpqO4XR9FwpgXo0FGzfVw7hk=;
        b=eL9auHf68NXfFnDkcsjCpMCXrh5rvNxRLJssb7wVGWq/DcUdBrdZi7TvMDF5juIEn9
         QKhGGDcAGNKNIdQNdKreXHn/xc5ooDuPoTGiOxGA1aPznQehg7PU3JAYGTOc0g25hj7B
         9dcsd0bRiviK9J0bW6h5prbTdBvqZJIQ6Up+dtkkMXycBNXkl4JEJPp9KCXvc4GgPx/x
         sSA+ISxQehVD0yb7rVVwH+OUfBzI7SJdecrJ2VFi6Zmbr8MktOcl/N/+JAtxpJuzG39f
         eQ+akmaUIrEOAGJ4sdVeKdeeLL/dG23HnuF0VvR0qm0CxrL90LtBwLcn8ATwzjS92tJX
         JtuQ==
Content-Disposition: inline
In-Reply-To: <202104131244.3qFwbTtx-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Tue, Apr 13, 2021 at 12:30:50PM +0800, kernel test robot wrote:
> smatch warnings:
> kernel/cgroup/misc.c:61 valid_type() warn: unsigned 'type' is never less than zero.
> kernel/cgroup/misc.c:210 misc_cg_max_show() warn: we never enter this loop
> kernel/cgroup/misc.c:257 misc_cg_max_write() warn: we never enter this loop
> kernel/cgroup/misc.c:299 misc_cg_current_show() warn: we never enter this loop
> kernel/cgroup/misc.c:323 misc_cg_capacity_show() warn: we never enter this loop
> kernel/cgroup/misc.c:376 misc_cg_alloc() warn: we never enter this loop
> kernel/cgroup/misc.c:376 misc_cg_alloc() warn: unsigned 'i' is never less than zero.
> kernel/cgroup/misc.c:376 misc_cg_alloc() warn: unsigned 'i' is never less than zero.
> 

Tejun,

Should this be ignored because MISC_CG_RES_TYPES is 0 as no resource is
defined but the code has 'for' loops and condition checks which are valid?

If there is a way to fix these let me know, I will make the change.

Thanks
Vipin
