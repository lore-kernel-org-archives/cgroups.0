From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH-next v5 1/4] mm/memcg: Move mod_objcg_state() to
 memcontrol.c
Date: Wed, 21 Apr 2021 16:08:45 -0700
Message-ID: <YICwfY6VmqPbuX1g@carbon.dhcp.thefacebook.com>
References: <20210420192907.30880-1-longman@redhat.com>
 <20210420192907.30880-2-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=EnFPed14JJKK4kfYWEkFku45rv9aEq2HEWAVsbhS3iE=;
 b=kKjjkKZtBSFXw1c1zcomGZXMmINz3K8TxO6AmfTTjjEIz283lYCHAVC/25I13aHKNjVZ
 MLBGcLTlk3Zas520dy9ddEae2m1AVqyyA0jpKCTk5srdYnd4o+IDeXkcz/oOoZHUUNvw
 7HoP4JIpqJBExUHPslSqUKzXrlYs9YinxwM= 
Content-Disposition: inline
In-Reply-To: <20210420192907.30880-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Tue, Apr 20, 2021 at 03:29:04PM -0400, Waiman Long wrote:
> The mod_objcg_state() function is moved from mm/slab.h to mm/memcontrol.c
> so that further optimization can be done to it in later patches without
> exposing unnecessary details to other mm components.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
