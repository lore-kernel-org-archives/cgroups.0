From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] fs: buffer: use raw page_memcg() on locked page
Date: Tue, 9 Feb 2021 11:20:01 -0800
Message-ID: <20210209192001.GA524633@carbon.DHCP.thefacebook.com>
References: <20210209190126.97842-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=TvFQt/37N+pab5u4BkJ+omiVcJ0zEeZ4RjfMbC/IUVQ=;
 b=bckJodcqj+cA6C24L6fksQywtXGtRRdTNgB9yyBJpLnD6ewAxk4/N10Wme0EkDf9IWeH
 nPm8oCWoVjwVobZh8SHCP3ivoAUHx2dPa+9wK12CU6JxSWPLugc+rRhQDRzoQMAoYadY
 +1jdKSjTbeykCZU5veZ+wSmtIMZhOGwVEaM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvFQt/37N+pab5u4BkJ+omiVcJ0zEeZ4RjfMbC/IUVQ=;
 b=BaOhtVbAMFY+oUEaiGWTKKFCP2WOYi/zr961K+A1zvrGfiuAc26JodWUo3FFRkUCNttIp/Ve16FVd3J4gBdLscgz1BBomFFsSSCj4qUlgXqp50Is+BWd6dNjPv44Xwo5pOIC8jPSbf/Za202MlhiySymPtmqHwy93U+MI1/TwmE=
Content-Disposition: inline
In-Reply-To: <20210209190126.97842-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Feb 09, 2021 at 02:01:26PM -0500, Johannes Weiner wrote:
> alloc_page_buffers() currently uses get_mem_cgroup_from_page() for
> charging the buffers to the page owner, which does an rcu-protected
> page->memcg lookup and acquires a reference. But buffer allocation has
> the page lock held throughout, which pins the page to the memcg and
> thereby the memcg - neither rcu nor holding an extra reference during
> the allocation are necessary. Use a raw page_memcg() instead.
> 
> This was the last user of get_mem_cgroup_from_page(), delete it.
> 
> Reported-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
