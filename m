From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: cgroup-v1: do not exclude cgrp_dfl_root
Date: Tue, 5 Oct 2021 06:14:23 -1000
Message-ID: <YVx5342KvJ1RFoL+@slm.duckdns.org>
References: <20211004201948.20293-1-vverma@digitalocean.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sWV3eCSW91vjz0ZnFEdePdyFv0khCWAXj63KXD3BxX4=;
        b=m9fVw7Q4ARqPYCSirL0dcKTTY9WiiGEUQx/SHaP6js1Ej2mc3rFteVrje7naDzeB6w
         k2u+A+0jUEbEI6P3EcTkTW93cOpQAQdP5Dic8C2Gyw2W1jNspuMSujON6JiDhr+w7i22
         xflC2ZH1aT+3JYPgtUjbxZ8ASpXrFp9G7PEfBfw/QPAOuzWepkByV8l6h3WOT0xWW6CW
         /CGh1qZtmK36Fjgg8juAgUp48tMVF5076wGTM9yG4oXs24AL/uhbtz37bTq0as3WIgS7
         eb7EvA6L5SdU7YE/i+1PXymvJ252kYhyy/n8iUblDtBwlkbXz2xF5WZYDwOJsr/rKUc2
         q+Rg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211004201948.20293-1-vverma-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vishal Verma <vverma-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 04, 2021 at 08:19:48PM +0000, Vishal Verma wrote:
> Found an issue within cgroup_attach_task_all() fn which seem
> to exclude cgrp_dfl_root (cgroupv2) while attaching tasks to
> the given cgroup. This was noticed when the system was running
> qemu/kvm with kernel vhost helper threads. It appears that the
> vhost layer which uses cgroup_attach_task_all() fn to assign the
> vhost kthread to the right qemu cgroup works fine with cgroupv1
> based configuration but not in cgroupv2. With cgroupv2, the vhost
> helper thread ends up just belonging to the root cgroup as is
> shown below:
...
> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Vishal Verma <vverma-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org>

Applied to cgroup/for-5.16.

Thanks.

-- 
tejun
