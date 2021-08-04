From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Disable task obj_stock for PREEMPT_RT
Date: Wed, 4 Aug 2021 10:52:35 +0200
Message-ID: <YQpVU4/QNE251IcX@dhcp22.suse.cz>
References: <20210803175519.22298-1-longman@redhat.com>
 <87h7g62jxm.ffs@tglx>
 <8953e099-356e-ee09-a701-f4c7f4cda487@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1628067158; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0b7BpAenRMJ5oMid71xEw73/C0eBnz+/7D1hkNZyYUk=;
        b=fnvlgV0kQl5eGqkDNi1u2Fd9DECKfV794NWwudenH7QZzVVYgIWsOBi6tw43Fh4ce4d9Mp
        1vv98NW/26rcwniF04DbenIJpRKWAkwzOfU4s1ww693aKL8jcC6ikPXBuELG2IckXoNypI
        xeRV4NcCVvBCCEz0PRsgzEqqlN8bK4s=
Content-Disposition: inline
In-Reply-To: <8953e099-356e-ee09-a701-f4c7f4cda487-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Luis Goncalves <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue 03-08-21 21:40:35, Waiman Long wrote:
[...]
> The purpose of this series is to improve kmem_cache allocation and free
> performance for non-RT kernel. So not disabling/enabling interrupt help a
> bit in this regard.

Johannes has explained the irq disabling role in the stock draining just
yesterday. Have a look at http://lkml.kernel.org/r/YQlPiLY0ieRb704V-druUgvl0LCNAfugRpC6u6w@public.gmane.org
-- 
Michal Hocko
SUSE Labs
