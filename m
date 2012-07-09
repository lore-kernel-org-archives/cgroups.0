From: Hugh Dickins <hughd@google.com>
Subject: Re: [patch 03/11] mm: shmem: do not try to uncharge known swapcache
 pages
Date: Mon, 9 Jul 2012 13:37:39 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1207091311300.1842@eggly.anvils>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-4-git-send-email-hannes@cmpxchg.org> <20120709144657.GF4627@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=4JbofggH4u4dIvCrWHLrosWp2Ihb6tOZgaeuFguX1OE=;
        b=NvOPdYFXPeRrQyi8vgGcYTHpULpdVbXVPmkNCH0rxoN1cDHwO+3LUmUHPJrg9uqY7F
         HPcMtt/kNwXT1rc24zu+TsITdkXcvScXykpuC0MuOVfs1+hrK/CcmbagKB0iwheXIJVk
         bWaLv4qNdTMhGstNx531vcXFRJqdCxn8Lc/IvZuNBPEdJMk24BkfKub6YQqGvolpo9Hp
         sxaHTUjvawqVFpATHaZe4/ak+yaC3erdplnO5wqg6JcNoYhvp0TcRzU+Tb+h/kPf/mQf
         xu2oKKIph3QmDcay8V/DuM0E+DGwzmhJxrt794tz+0kWfumRaIQNpNscgdRqvYcWMIOd
         nHqA==
In-Reply-To: <20120709144657.GF4627@tiehlicka.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Michal Hocko wrote:
> 
> Maybe I am missing something but who does the uncharge from:
> shmem_unuse
>   mem_cgroup_cache_charge
>   shmem_unuse_inode
>     shmem_add_to_page_cache

There isn't any special uncharge for shmem_unuse(): once the swapcache
page is matched up with its memcg, it will get uncharged by one of the
usual routes to swapcache_free() when the page is freed: maybe in the
call from __remove_mapping(), maybe when free_page_and_swap_cache()
ends up calling it.

Perhaps you're worrying about error (or unfound) paths in shmem_unuse()?
By the time we make the charge, we know for sure that it's a shmem page,
and make the charge appropriately; in racy cases it might get uncharged
again in the delete_from_swap_cache().  Can the unfound case occur these
days?  I'd have to think more deeply to answer that, but the charge will
not go missing.

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
