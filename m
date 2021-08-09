From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 24/38] cgroup: Replace deprecated CPU-hotplug functions.
Date: Mon, 9 Aug 2021 12:37:54 -1000
Message-ID: <YRGuQpOaoikOGcyl@mtj.duckdns.org>
References: <20210803141621.780504-1-bigeasy@linutronix.de>
 <20210803141621.780504-25-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3y0PR9hqaxZCbgji9aEKkljrODgvwX/4vrec8nondds=;
        b=hV/65XscHrUVTSXlPXqgMC6M187FxVGO48d2RrLSEcEd1ZVh9XRuET4/wAi9Ht8NvK
         vy3lAN2dWaHEvnIv53DwRAN5+8aFe5LTGgby7GCF2RVjWmzesyFRQgQ+VBWctei6hpUp
         Zdw8b4GCtfJSUDaJDgoczIVrW+gYQnkNOhs7eb6CrzUEcID/MuPhxLZregZkEjQTHNSP
         ZSih/+6fleuLQBQ+BJNq3v40NN4c7e+6eS6QNUBYzicNufv5Kq5XLnq5T7bz3VLO3bW9
         2unQEtTeLqQ/yx9D9a1d9VPUVwwMIg2t0oV5SgrSPzuO6khuzu53BzLKl3E+z9danjj/
         1FIg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210803141621.780504-25-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 03, 2021 at 04:16:07PM +0200, Sebastian Andrzej Siewior wrote:
> The functions get_online_cpus() and put_online_cpus() have been
> deprecated during the CPU hotplug rework. They map directly to
> cpus_read_lock() and cpus_read_unlock().
> 
> Replace deprecated CPU-hotplug functions with the official version.
> The behavior remains unchanged.
> 
> Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Applied to cgroup/for-5.15.

Thanks.

-- 
tejun
