From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [cgroup:for-next 1/5] kernel/cgroup/misc.c:61 valid_type() warn:
 unsigned 'type' is never less than zero.
Date: Fri, 16 Apr 2021 16:42:04 -0400
Message-ID: <YHn2nDHqakJLG3di@slm.duckdns.org>
References: <202104131244.3qFwbTtx-lkp@intel.com>
 <YHU4XrOW1dBIZfVl@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XB7njt+oGvZctAMxlmgcAtP5yDpC3NFFKZ6SHAuxUDM=;
        b=Jxemyxd9Q7CqrK7A61vstQkvzmVDdkSAa2JDVElwLoSy6GSWrakwVG6tqvpBp6X4aQ
         rR1RR9yI1flIahOxrdJYfskfdFcg73imCsSBMwtuAP1Vrt276ElpzgGF9FkKrBlaSZfQ
         JtmP5TZ9bTmUu1FW7GCme7m/rF8r5Rzi4r296Ds+iHb8m4+K2ZrULrig1Z4gbJ7+9ey1
         QlWQQsBJVPToRapQTjnAXHH6ZFIvic8Y5SKjLCJ+8HnM522Nrzdbz9Ke2Okn3EAMtUlw
         2q+BdrMNopvgne0A/gCueLfJzXkhNcgFqIcPoh8C/1f1UKS++SlzraTHZQOKRW7h4mv9
         /F7g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YHU4XrOW1dBIZfVl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Mon, Apr 12, 2021 at 11:21:18PM -0700, Vipin Sharma wrote:
> On Tue, Apr 13, 2021 at 12:30:50PM +0800, kernel test robot wrote:
> > smatch warnings:
> > kernel/cgroup/misc.c:61 valid_type() warn: unsigned 'type' is never less than zero.
> > kernel/cgroup/misc.c:210 misc_cg_max_show() warn: we never enter this loop
> > kernel/cgroup/misc.c:257 misc_cg_max_write() warn: we never enter this loop
> > kernel/cgroup/misc.c:299 misc_cg_current_show() warn: we never enter this loop
> > kernel/cgroup/misc.c:323 misc_cg_capacity_show() warn: we never enter this loop
> > kernel/cgroup/misc.c:376 misc_cg_alloc() warn: we never enter this loop
> > kernel/cgroup/misc.c:376 misc_cg_alloc() warn: unsigned 'i' is never less than zero.
> > kernel/cgroup/misc.c:376 misc_cg_alloc() warn: unsigned 'i' is never less than zero.
> > 
> 
> Tejun,
> 
> Should this be ignored because MISC_CG_RES_TYPES is 0 as no resource is
> defined but the code has 'for' loops and condition checks which are valid?
> 
> If there is a way to fix these let me know, I will make the change.

Can't think of a pretty way to slience this, so ignoring sounds good to me
for now. Maybe smatch folks have better ideas?

Thanks.

-- 
tejun
