From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 2/4] mm: change to return bool for isolate_lru_page()
Date: Wed, 15 Feb 2023 15:39:30 +0000
Message-ID: <Y+z8suWLusQk8N3U@casper.infradead.org>
References: <cover.1676424378.git.baolin.wang@linux.alibaba.com>
 <3074c1ab628d9dbf139b33f248a8bc253a3f95f0.1676424378.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J1HP1AYxs+CPgeT/Uk3lsnz97zGE2SKFHAXmfCAw3bw=; b=Y0PKbb2GdfSnGd5GRhVnYZGNLK
        S2B4glLdiOEykJBOnN/nU8lvfvyNknik1yQ8cOcv9q2fIz9pbnNOYxDhnhIx7ZHeQiWzsjqZCuaTa
        JrddlddthRmAKYwpOF8TuJM0ngO8PaURDxPZTUMO46mwpNTH3bPdUohUwBwc/U4fCEkBEGeWl06U1
        MDA2+xdslRl+t1aRvavQmvMMojmeVVeCG6meQe2Cgxk+Zc2cKz7EFOD2tmMciWoWjk8WhInFX08Ul
        7aqG9lkcHfdkciRCtzifRVf33MBMXUGrjWkCu8rNNLTupObyC6B4bUQ05ytVIIVrpA/9Vmge97DkK
        ecTx6fwg==;
Content-Disposition: inline
In-Reply-To: <3074c1ab628d9dbf139b33f248a8bc253a3f95f0.1676424378.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, naoya.horiguchi-YMj9X0ASwKA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 15, 2023 at 06:39:35PM +0800, Baolin Wang wrote:
> The isolate_lru_page() can only return 0 or -EBUSY, and most users did
> not care about the negative error of isolate_lru_page(), except one user
> in add_page_for_migration(). So we can convert the isolate_lru_page() to
> return a boolean value, which can help to make the code more clear when
> checking the return value of isolate_lru_page().
> 
> Also convert all users' logic of checking the isolation state.
> 
> No functional changes intended.
> 
> Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Acked-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
