From: Rik van Riel <riel@fb.com>
Subject: Re: [PATCH] mm: memcontrol: add file_thp, shmem_thp to memory.stat
Date: Thu, 22 Oct 2020 12:49:34 -0400
Message-ID: <db4f86f30726a1a33c868155b4c681ac25569179.camel@fb.com>
References: <20201022151844.489337-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cWne/3p9UxzZphn+Oykp8yjMla1uGUvvusPMVbkP5Nc=;
 b=hpKh2aP7i9RsE0XMzgGc9lrjXzrEJ/eUAjsVw49KZ7uOP4JpSxHFy8hTzveY0cDOfgM9
 Q0ld3GSm3JcVYFa4UeCigdsc937WQVOwLx9LKGyBCuPNm2Wp2aEPeQdynHsJ+c6lZn9s
 BX0FvJ17bVuk+YERx36mAxdGvSxkj6dKFPk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWne/3p9UxzZphn+Oykp8yjMla1uGUvvusPMVbkP5Nc=;
 b=S4s753GOHV9B8pEgOmUHIv8KvORGWmBhnZOhWSK7gPV1ImDxXbGPQUutApVv0981VrFTcj2kBFnwNX030+nJmw9dh4sAqBFhp4/0x9sejkSEy+KjeAizd13Qopz6k51Kj2vIwaPnVBYlSCZblW7h+uJ7zOZHV8sjI8CmxBqMGwY=
In-Reply-To: <20201022151844.489337-1-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, 2020-10-22 at 11:18 -0400, Johannes Weiner wrote:

> index e80aa9d2db68..334ce608735c 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -204,9 +204,9 @@ static void unaccount_page_cache_page(struct
> address_space *mapping,
>  	if (PageSwapBacked(page)) {
>  		__mod_lruvec_page_state(page, NR_SHMEM, -nr);
>  		if (PageTransHuge(page))
> -			__dec_node_page_state(page, NR_SHMEM_THPS);
> +			__dec_lruvec_page_state(page, NR_SHMEM_THPS);
>  	} else if (PageTransHuge(page)) {
> -		__dec_node_page_state(page, NR_FILE_THPS);
> +		__dec_lruvec_page_state(page, NR_FILE_THPS);
>  		filemap_nr_thps_dec(mapping);
>  	}

This may be a dumb question, but does that mean the
NR_FILE_THPS number will no longer be visible in
/proc/vmstat or is there some magic I overlooked in
a cursory look of the code?


