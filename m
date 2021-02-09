From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v3 7/8] mm: memcontrol: consolidate lruvec stat flushing
Date: Tue, 9 Feb 2021 12:21:28 -0800
Message-ID: <20210209202128.GD524633@carbon.DHCP.thefacebook.com>
References: <20210209163304.77088-1-hannes@cmpxchg.org>
 <20210209163304.77088-8-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rQZ+1AV1cqgvwWTAojFxcAp22b/WbMienHTZZOLmlaY=;
 b=QJVbSMAnSwX4yKvePwDX/odVGv7p5u7kr545GNN5ZfHKbeYpnKRSZgjomhmNzYcqigjH
 bmMe20pTM5FXa4n60Wd5C+39ZZuWVqLfBmfwQUbxmQJ9i58qMFgDosafWIFFiJ4LwH01
 wwuOkxKxmFLsGnEftg3r8grleAqXHLquYg4= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQZ+1AV1cqgvwWTAojFxcAp22b/WbMienHTZZOLmlaY=;
 b=FVh4sxX7Sf57gDlmV3Qym0WiB6hI9ljKkJ0MYPJv6ChWTFYW4/FfghaP/ZQkNaIej7tx4sPEnf9em2aohR0/I9ht4CJGtxCK1bRNrjOsnvNzFrAba8+g50bP/FYg/ERwYBAM/jdznDTx4+GHQcpx+8fF/xmnJ9v5dbtfyP95Ujg=
Content-Disposition: inline
In-Reply-To: <20210209163304.77088-8-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Feb 09, 2021 at 11:33:03AM -0500, Johannes Weiner wrote:
> There are two functions to flush the per-cpu data of an lruvec into
> the rest of the cgroup tree: when the cgroup is being freed, and when
> a CPU disappears during hotplug. The difference is whether all CPUs or
> just one is being collected, but the rest of the flushing code is the
> same. Merge them into one function and share the common code.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
