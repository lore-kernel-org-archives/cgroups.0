From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 4/4] driver core: Allow showing cpu as offline if not
 valid in cpuset context
Date: Mon, 14 Jun 2021 17:52:28 +0200
Message-ID: <YMd7PEU0KPulsgMz@kroah.com>
References: <20210614152306.25668-1-longman@redhat.com>
 <20210614152306.25668-5-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623685950;
        bh=trCbMGPAbt9/hzrWlV6LYuE+SaIgEDWh+DuiywOoDhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1BXHD7aM5xf8LRFVUUHxCZ+Yl93ZkZLcH9KouwmBEbG/fCvejrJXDiOYN0Js5XS8k
         8TSvta5Pm1Po7SmLwZ4YqKncEIcqI9CPnPZFqhyjRpq9PRPWzHmdwLp460+PGcldi9
         pwUibem6vahztLNFxVphy+pMq5W1O681ZGxp+Bbg=
Content-Disposition: inline
In-Reply-To: <20210614152306.25668-5-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman
        <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Rafael J. Wysocki " <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jun 14, 2021 at 11:23:06AM -0400, Waiman Long wrote:
> Make /sys/devices/system/cpu/cpu<n>/online file to show a cpu as
> offline if it is not a valid cpu in a proper cpuset context when the
> cpuset_bound_cpuinfo sysctl parameter is turned on.

This says _what_ you are doing, but I do not understand _why_ you want
to do this.

What is going to use this information?  And now you are showing more
files than you previously did, so what userspace tool is now going to
break?



> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/base/core.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 54ba506e5a89..176b927fade2 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -29,6 +29,7 @@
>  #include <linux/sched/mm.h>
>  #include <linux/sysfs.h>
>  #include <linux/dma-map-ops.h> /* for dma_default_coherent */
> +#include <linux/cpuset.h>
>  
>  #include "base.h"
>  #include "power/power.h"
> @@ -2378,11 +2379,24 @@ static ssize_t uevent_store(struct device *dev, struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RW(uevent);
>  
> +static bool is_device_cpu(struct device *dev)
> +{
> +	return dev->bus && dev->bus->dev_name
> +			&& !strcmp(dev->bus->dev_name, "cpu");
> +}

No, this is not ok, there is a reason we did not put RTTI in struct
devices, so don't try to fake one here please.

> +
>  static ssize_t online_show(struct device *dev, struct device_attribute *attr,
>  			   char *buf)
>  {
>  	bool val;
>  
> +	/*
> +	 * Show a cpu as offline if the cpu number is not valid in a
> +	 * proper cpuset bounding cpuinfo context.
> +	 */
> +	if (is_device_cpu(dev) && !cpuset_current_cpu_valid(dev->id))
> +		return sysfs_emit(buf, "0\n");

Why are you changing the driver core for a single random, tiny set of
devices?  The device code for those devices can handle this just fine,
do NOT modify the driver core for each individual driver type, that way
lies madness.

This change is not ok, sorry.

greg k-h
