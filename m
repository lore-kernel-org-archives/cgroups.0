From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: replace the loop with a
 list_for_each_entry()
Date: Thu, 4 Feb 2021 10:37:43 -0800
Message-ID: <20210204183743.GB1837780@carbon.DHCP.thefacebook.com>
References: <20210204163055.56080-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=I+wcMkxu1gHxvwkIdOKsW51gMV+OmCz66XS8BFzjvio=;
 b=DMipOF940rKIY7luBNZy3ohCcaR/lnZSIQ612+Wh69Gw5sqjqO6hBLBe97AgzSb9WYkW
 IGT3NvxQ+3Bmg6C91tr38KLGRA8YnhvYBfHpNzDAjjo+mDJmZV7J6MCk+pgbx/K5PMV1
 EHZvQ3r52BEKvoVe7giQ0JZyVa683KRSrho= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+wcMkxu1gHxvwkIdOKsW51gMV+OmCz66XS8BFzjvio=;
 b=HNY5O6zS32kjp3jXkpXafmnSlBjsRLO1iP1hTirncRSpHgDUDOtmQaW8GAUxYXKzFWkI0wGNUuinNrPsGxlSRPpvHphTGgUGc1S+rUNxCT5EZT9J8cPNj/dx9+Svt9ZrT6J5AR75tw4OJygoip/a6TsS3BSpg9riQqFMt9fZIds=
Content-Disposition: inline
In-Reply-To: <20210204163055.56080-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Feb 05, 2021 at 12:30:55AM +0800, Muchun Song wrote:
> The rule of list walk has gone since:
> 
>  commit a9d5adeeb4b2 ("mm/memcontrol: allow to uncharge page without using page->lru field")
> 
> So remove the strange comment and replace the loop with a
> list_for_each_entry().
> 
> There is only one caller of the uncharge_list(). So just fold it into
> mem_cgroup_uncharge_list() and remove it.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
> v2:
>  - Fold uncharge_list() to mem_cgroup_uncharge_list().
> 
>  mm/memcontrol.c | 35 ++++++++---------------------------
>  1 file changed, 8 insertions(+), 27 deletions(-)

Nice cleanup!

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks.
