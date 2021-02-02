From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 3/7] mm: memcontrol: privatize memcg_page_state query
 functions
Date: Tue, 2 Feb 2021 15:17:37 -0800
Message-ID: <20210202231737.GC1812008@carbon.dhcp.thefacebook.com>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=sUuBUZeXj9tKYEB1GqqpNJRPCnyRfxNPeiFY6u2bwZc=;
 b=SYK6gr5FcMfUCfLNz2XQuIE/xjfH4goCirSEJQjZlXpCKAGb1gqOWQpSFOJqcI045J0i
 WeT5UHwFC3ER103kkv/A9hLA7PWEHK38K7povn8bHRpwXJ2WM6csk45G7RM2/DnnUIOl
 /x4tUmiVUfZ7Pdi9IYQFJYbmghlIjmcHHQI= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUuBUZeXj9tKYEB1GqqpNJRPCnyRfxNPeiFY6u2bwZc=;
 b=fPjfhOZYqFWjuFj7qMIUGWAt7swnrss5zIrpjh+8EAkJ/YA0aHhUn8CFL1MFAq7FVPuw0knukB7VnB2umm3AF/99wrFvELPmQ8PJFCLaeOvd8X36WGrPK8SkbwcSyIkEf6mKlUMzYgqrUbq0Y88RRI66Sman0oWJlzFGhPvssJQ=
Content-Disposition: inline
In-Reply-To: <20210202184746.119084-4-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Feb 02, 2021 at 01:47:42PM -0500, Johannes Weiner wrote:
> There are no users outside of the memory controller itself. The rest
> of the kernel cares either about node or lruvec stats.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
