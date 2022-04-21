From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH -next] mm/memcontrol.c: remove unused private flag of
 memory.oom_control
Date: Thu, 21 Apr 2022 10:17:52 -0400
Message-ID: <YmFnkPhMSilL92nq@cmpxchg.org>
References: <20220421122755.40899-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NGvnES751j4Kpm/2yGGRz1dr4K8jefdTS2zO6HL1LQo=;
        b=ZPAZ/ahk5mYAJFvXYDcer5zr1glKh98W1H94yE7fJYu3RfJdgQHb+WdQHFWNuH77tn
         RlRNbAEEiuQi3ELJfSo2IneS6DY7/piylSJtKZ8jsMRSY9wLoi7PPZ6OEg9+xxb7y/Nx
         4V2VfujoAiPffqcRvQL7bJum8Q6uGNQmRM84Uo0xYIEVspG2jjnyzH9MszH7L0GBx7P2
         oJumAdYl7SAAZJV1LN6U5BZh0EIl4w+6t/TSGJLshuGWFDlfTftMFwDjr1vMk/HcXlMx
         DGbx9ITYWAVBlbk85h0sIwNvZc6vou9qMuxYT1rEoyEgaAcYn1bHe6KAeyuUu1ZIty0o
         RMBw==
Content-Disposition: inline
In-Reply-To: <20220421122755.40899-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Apr 21, 2022 at 08:27:55PM +0800, Lu Jialin wrote:
> There is no use for the private value, __OOM_TYPE and OOM notifier
> OOM_CONTROL. Therefore remove them to make the code clean.
> 
> Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Good catch, it's been unused since 347c4a874710 ("memcg: remove
cgroup_event->cft").

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
