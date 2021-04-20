From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 1/5] mm/memcg: Move mod_objcg_state() to memcontrol.c
Date: Tue, 20 Apr 2021 10:05:55 +0200
Message-ID: <YH6LY/N/fqqnv2QT@dhcp22.suse.cz>
References: <20210419000032.5432-1-longman@redhat.com>
 <20210419000032.5432-2-longman@redhat.com>
 <YH2eT+JCII48hX80@cmpxchg.org>
 <ffb5705e-8629-808d-9d09-0c9c7f509326@redhat.com>
 <140444ea-14e7-b305-910f-f23fafe45488@redhat.com>
 <YH26RrMBOxLaMg4l@cmpxchg.org>
 <b7c8e209-3311-609b-9b61-5602a89a8313@redhat.com>
 <d1c36f26-b958-49e0-ae44-1cf6334fa4c5@redhat.com>
 <YH3yCZn9EeSPKKGY@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618905956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QI+jU+hQq4MG4fnEZIyp1J+yoW7z3R2nnTri1hPIMb0=;
        b=LDwx87FWadOHK1RH2RC0IFbccjafULornqRJg3LIpFf66O+6qZ/1S6Teqsh1nd5G8PYKYe
        SX0GjTu6vo5dK98WipgCgvNj2KpHbjFV+9pgpliHBfHGvIuGWDbsJtuWuQ1Ok7NtjAxamm
        IPOMk7r5giucoElK3B7f8YLpbFMIyko=
Content-Disposition: inline
In-Reply-To: <YH3yCZn9EeSPKKGY-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <wi>

On Mon 19-04-21 17:11:37, Johannes Weiner wrote:
> On Mon, Apr 19, 2021 at 01:26:29PM -0400, Waiman Long wrote:
[...]
> - the soft limit tree and soft limit reclaim
> 
> - the threshold and oom event notification stuff
> 
> - the charge moving code
> 
> - remaining v1 interface files, as well as their helper functions
> 
> From a quick scan, this adds up to ~2,500 lines of old code with no
> actual dependencies from the common code or from v2, and which could
> be moved out of the way without disrupting ongoing development much.

Moving those into its own file makes sense to me as well. If the code is
not conditional (e.g. like swap accounting and some others) then moving
it would make memecontrol.c easier to navigate through.
-- 
Michal Hocko
SUSE Labs
