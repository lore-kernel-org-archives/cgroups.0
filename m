From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcg: Remove obsolete memcg_free_kmem()
Date: Tue, 5 Oct 2021 18:15:52 -0700
Message-ID: <YVz4yEziz1sBwttv@carbon.dhcp.thefacebook.com>
References: <20211005202450.11775-1-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=k0tjnFViLN2uO6CvVb0hdc8X4ETpwvZS8qXlOiNEIvY=;
 b=hLhUQb/iFmkHGhFGvdwuyvN8chUKbVOAN6eu6hbSE3OMMIDLsx9x4C2PbOSGxj4AvU4r
 ERgR/HYQc/iwYHScFB0nAEpIHZ5hFwO/3JFH/tvSo5ycLaBsX1JYH3L0S0Qu0QjPRBAz
 dwLU4RCHKxyGIdS7+VTiDrzH7Qx4piX2Z24= 
Content-Disposition: inline
In-Reply-To: <20211005202450.11775-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Tue, Oct 05, 2021 at 04:24:50PM -0400, Waiman Long wrote:
> Since commit d648bcc7fe65 ("mm: kmem: make memcg_kmem_enabled()
> irreversible"), the only thing memcg_free_kmem() does is to call
> memcg_offline_kmem() when the memcg is still online which can happen when
> online_css() fails due to -ENOMEM. However, the name memcg_free_kmem()
> is confusing and it is more clear and straight forward to call
> memcg_offline_kmem() directly from mem_cgroup_css_free().
> 
> Suggested-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks, Waiman!
