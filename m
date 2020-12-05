From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 5/9] mm: memcontrol: convert NR_FILE_THPS account to pages
Date: Sat, 5 Dec 2020 15:10:48 +0100
Message-ID: <X8uU6ODzteuBY9pf@kroah.com>
References: <20201205130224.81607-1-songmuchun@bytedance.com>
 <20201205130224.81607-6-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607177374;
        bh=GqJgKgKfkXV2E/cKEl+IwBiAIYSLVSK21HRqHXfoboQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=kj2Mfzyav+eSVN9O1zun+6FovXVMb3nkQa66UcHmEHZsRD4wmt8EgH/EDlSXCrzp/
         Fj9n6sPBBIrJrn19nFPxqPLdnApCiqc2doGN4AKNkx8IJCF5DDvTWV9v51cAhZ0FTu
         NhNQ1QGmnXAuazcozS0AFv+54SwfFhg2xS7wR/Q8=
Content-Disposition: inline
In-Reply-To: <20201205130224.81607-6-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Dec 05, 2020 at 09:02:20PM +0800, Muchun Song wrote:
> Converrt NR_FILE_THPS account to pages.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  drivers/base/node.c | 3 +--
>  fs/proc/meminfo.c   | 2 +-
>  mm/filemap.c        | 2 +-
>  mm/huge_memory.c    | 3 ++-
>  mm/khugepaged.c     | 2 +-
>  mm/memcontrol.c     | 5 ++---
>  6 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 05c369e93e16..f6a9521bbcf8 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -466,8 +466,7 @@ static ssize_t node_read_meminfo(struct device *dev,
>  				    HPAGE_PMD_NR),
>  			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED) *
>  				    HPAGE_PMD_NR),
> -			     nid, K(node_page_state(pgdat, NR_FILE_THPS) *
> -				    HPAGE_PMD_NR),
> +			     nid, K(node_page_state(pgdat, NR_FILE_THPS)),

Again, is this changing a user-visable value?

