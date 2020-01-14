From: David Rientjes <rientjes@google.com>
Subject: Re: [Patch v2] mm: thp: grab the lock before manipulation defer
 list
Date: Tue, 14 Jan 2020 12:57:22 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001141254460.84781@chino.kir.corp.google.com>
References: <20200109143054.13203-1-richardw.yang@linux.intel.com> <20200111000352.efy6krudecpshezh@box> <20200114093122.GH19428@dhcp22.suse.cz> <20200114103112.o6ozdbkfnzdsc2ke@box> <20200114105921.eo2vdwikrvtt3gkb@box>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Yw4+mImP3xYemjNvEkTXmDMcGpXxaxAKM4GUBoCUQVE=;
        b=meEWzXz0iIiGD+szilzJbFn93Ka67aSbLRJ9wne3w2YWA+jsC7qemaDkmGSUrhndjx
         6LzOtL6Vvux8f8xKsXQz0p5sHQTf7/Z14qIDx7ZCfiRZLg11JY86JF48ZSFoSYisTPgD
         Z3hyNfR+nHSLcmiWbGyA1E0X3mCdGHa1iLNwBOIXcLHS1cEhv5502Gjcp/H3L4bYi5VM
         EhWQLy65l4h/wnaGDxqWu+Ve/UMFwaq3Cx79sI7wDGUNcwpMuwUnuJFvI5Z7bewxIlR9
         7Ol2MY1JtdE0ZkhBTpaPEv+yR8x1MNHBaqg+G2fPLK1WiBBZ2VGvkUhAq2WVsHpdcF7A
         JonQ==
In-Reply-To: <20200114105921.eo2vdwikrvtt3gkb@box>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@kernel.org>, Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, alexander.duyck@gmail.com

On Tue, 14 Jan 2020, Kirill A. Shutemov wrote:

> split_huge_page_to_list() has page lock taken.
> 
> free_transhuge_page() is in the free path and doesn't susceptible to the
> race.
> 
> deferred_split_scan() is trickier. list_move() should be safe against
> list_empty() as it will not produce false-positive list_empty().
> list_del_init() *should* (correct me if I'm wrong) be safe because the page
> is freeing and memcg will not touch the page anymore.
> 
> deferred_split_huge_page() is a problematic one. It called from
> page_remove_rmap() path witch does require page lock. I don't see any
> obvious way to exclude race with mem_cgroup_move_account() here.
> Anybody else?
> 
> Wei, could you rewrite the commit message with deferred_split_huge_page()
> as a race source instead of split_huge_page_to_list()?
> 

I think describing the race in terms of deferred_split_huge_page() makes 
the most sense and I'd prefer a cc to stable for 5.4+.  Even getting the 
split_queue_len, which is unsigned long, to underflow because of a 
list_empty(page_deferred_list()) check that is no longer accurate after 
the lock is taken would be a significant issue for shrinkers.

