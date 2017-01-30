From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.11] cgroup: misc cleanups
Date: Mon, 30 Jan 2017 17:08:15 -0500
Message-ID: <20170130220815.GA9569@htj.duckdns.org>
References: <20170120170608.GB5093@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x3wPavr2P7sjuibA6eSPnsvF2mWun4oAhLcP1/e6nyM=;
        b=dFEflaMZPU/EAZRVgtRO5qwlrdgWObjBW85kR+DENMPZJ/JtjKFOqEvUQiWbQYb348
         1qcTlD7e3hnzuCZQQGNLR89vrkn2DRLraUlIn9Lut9FgMToljGPJNgwTL/mlKwNghpOO
         xuoDG0pDrSTqAxJnbUiv3/rSGwoI/6Kjtkwr9ME+0hvclFhDxeCm54iLGRbqii6YMIvW
         OOmmghTBfNiHdolrkGnkSR5pkSgPLP8XTYDQLsH4cUqAQNMLecuMxL05aYKEEZr3SPBS
         el5IFs8TwNgBiS6rj3xkEm9XvZ1zne58uSeON/+H4RzK9RiJEQbZE1tux7O2k81Hum/r
         lVHQ==
Content-Disposition: inline
In-Reply-To: <20170120170608.GB5093-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Jan 20, 2017 at 12:06:08PM -0500, Tejun Heo wrote:
> * cgrp_dfl_implicit_ss_mask is ulong instead of u16 unlike other
>   ss_masks.  Make it a u16.
> 
> * Move have_canfork_callback together with other callback ss_masks.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-4.11.

Thanks.

-- 
tejun
