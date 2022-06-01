From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH mm v3 0/9] memcg: accounting for objects allocated by
 mkdir cgroup
Date: Wed, 1 Jun 2022 11:15:43 +0200
Message-ID: <20220601091543.GA21320@blackbody.suse.cz>
References: <06505918-3b8a-0ad5-5951-89ecb510138e@openvz.org>
 <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab@openvz.org>
 <YpSwvii5etfnOYC9@dhcp22.suse.cz>
 <ef9f7516-853d-ffe4-9a7a-5e87556bdbbe@openvz.org>
 <YpTTL3Ys35kgYyAW@dhcp22.suse.cz>
 <3a1d8554-755f-7976-1e00-a0e7fb62c86e@openvz.org>
 <YpXA35F33hvrxNLf@dhcp22.suse.cz>
 <118bcb39-1281-0d1d-b163-3f6bcc99c3e2@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654074945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yUzM6SCTjaU1mIdMVCprAWHtHI7nDAT4AcyKtphheFU=;
        b=sepJCSScSco/ygJugTWsZ6WDsOVoPXEAXUJWsBt1nE7P68p+7hhw14Ir0wKgMPbTy6rfz2
        uJoz2n6eIokFP4GbMKS4omn+EwCMNr51JNoG7uqDjtuvMQboSxieTjGqWXdvPY23kte/BX
        JNH8XgJ/JPc4f6ZESPn8deR8utON5ZI=
Content-Disposition: inline
In-Reply-To: <118bcb39-1281-0d1d-b163-3f6bcc99c3e2-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 01, 2022 at 06:43:27AM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> CT-901 /# cat /sys/fs/cgroup/memory/cgroup.subgroups_limit 
> 512
> CT-901 /# echo 3333 > /sys/fs/cgroup/memory/cgroup.subgroups_limit 
> -bash: echo: write error: Operation not permitted
> CT-901 /# echo 333 > /sys/fs/cgroup/memory/cgroup.subgroups_limit 
> -bash: echo: write error: Operation not permitted
> 
> I doubt this way can be accepted in upstream, however for OpenVz
> something like this it is mandatory because it much better
> than nothing.

Is this customization of yours something like cgroup.max.descendants on
the unified (v2) hierarchy? (Just curious.)

(It can be made inaccessible from within the subtree either with cgroup
ns or good old FS permissions.)

Michal
