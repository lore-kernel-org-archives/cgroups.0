From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 1/2] cgroup: fix psi monitor for root cgroup
Date: Tue, 19 Jan 2021 11:52:37 -0500
Message-ID: <YAcOVZ9hceK3gwWT@cmpxchg.org>
References: <20210116173634.1615875-1-odin@uged.al>
 <20210116173634.1615875-2-odin@uged.al>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uGojdeA20zzASlYpdW76UKnqe50ntC8qShndn6zJIz4=;
        b=xtAjKAEtfJQvTQE5lGL0o/pBMwEY1osKiNGCA40ER/PyoQC6arxZqOi3F65vp97cKN
         h+lMfbHribwS5JhD+aM32o5RCl7lTiUuS4dsKUM0nJ8J/V4y8xND8eWXhbfYz935LOuH
         Oygf+8ZTdrQUK4JsMzhoMVERDJnqu7csEnK5zT75ytSHbN7YI8FOvCBn/LZSz7DOvAwY
         6GvraSTztJHRercM9PV46hF8l53VyDol1fxk7eJUlraR/FfdKKf2/tpxctc9l/tfB7JP
         qwQhf7xoRiBqJLidHBzAtWUem0/wr1XEQeC0oFNFhYaFgbHqiOmNo1Baurzc1aS0pcu8
         9iXg==
Content-Disposition: inline
In-Reply-To: <20210116173634.1615875-2-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dschatzberg-b10kYP2dOMg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Sat, Jan 16, 2021 at 06:36:33PM +0100, Odin Ugedal wrote:
> Fix NULL pointer dereference when adding new psi monitor to the root
> cgroup. PSI files for root cgroup was introduced in df5ba5be742 by using
> system wide psi struct when reading, but file write/monitor was not
> properly fixed. Since the PSI config for the root cgroup isn't
> initialized, the current implementation tries to lock a NULL ptr,
> resulting in a crash.
> 
> Can be triggered by running this as root:
> $ tee /sys/fs/cgroup/cpu.pressure <<< "some 10000 1000000"
> 
> Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
> Reviewed-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Fixes: df5ba5be7425 ("kernel/sched/psi.c: expose pressure metrics on root cgroup")
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Since this is a userspace-triggerable NULL ptr crash, we should
probably also

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.2+
