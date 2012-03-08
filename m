From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Date: Thu, 8 Mar 2012 10:26:22 -0800
Message-ID: <20120308182622.GC25508@google.com>
References: <4F587199.6050404@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=AVXqr/SnEDa4VeH0388O3Y0fhpZQD1/lKQRYk4mv1pY=;
        b=zZlsgIdeuplfye2BuNC4EF88K+rdYgg+mNRrc6Fz8Gfm4qnkc3pwzqvCIPmHOOqmkS
         UEkep8g3jhc3I5ETa8e6DD7E7yRY36EINdh5QgKojMeDCEn35MYBPSHiAP7KlHAo6bkv
         /BMkQ5X2AKRtghnaMkxfIYn+rPhLc/inrnfWaV2Ch1r6iAFONmwLKbfJ6laE2mfNuAeo
         R9Viqz/41K6a42gZFepDuGI8X0rNNktG4XiygXnqrokglCMCGcRtMKdJfpmLNpK863bY
         8hHP3iRNlZXQFHJ70IhLX/LaX8TZMOqDSONLaAjqChb/u8rZ6H4/1s6ybQs42pWefaot
         oS+g==
Content-Disposition: inline
In-Reply-To: <4F587199.6050404-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?57yqIOWLsA==?= <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Li, Frederic.

On Thu, Mar 08, 2012 at 04:45:13PM +0800, Li Zefan wrote:
> +static void freezer_post_fork(struct cgroup_subsys *ss,
> +			      struct task_struct *task)
> +{
> +	struct freezer *freezer;
> +
> +	cgroup_lock();
> +
> +	freezer = task_freezer(task);
> +	if (!freezer->css.cgroup->parent)
> +		goto out;
> +
> +	spin_lock_irq(&freezer->lock);
> +	if (freezer->state != CGROUP_THAWED)
> +		freeze_task(task);
> +	spin_unlock_irq(&freezer->lock);
> +out:
> +	cgroup_unlock();
> +}

Urgh... this is requiring policy implementations to synchronize with
problem caused by cgroup core optimization and it's so very subtle.
IMHO, this definitely should be contained in cgroup core and in a very
confined form even inside cgroup core.

Any other ideas?

Thanks.

-- 
tejun
