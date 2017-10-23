From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC PATCH] mm, thp: make deferred_split_shrinker memcg-aware
Date: Mon, 23 Oct 2017 13:54:50 +0300
Message-ID: <20171023105450.jv4qerpzlrodfws6@node.shutemov.name>
References: <20171019200323.42491-1-nehaagarwal@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NG3xitf/ighuhJCc2dESfpDVzppbfBEklExRGQL3h34=;
        b=LfnsXKmQBDVZ5Ei1o8smW0qEW/6vULOKMewjSEmPhoLyqZI6f4T8zY/EDc92anCzRw
         mxOaypicOtqskFcXIbOsQTRXEkZCEQdh0ikUd15mHDg0ImSFqN0xAvAm7a1O5JZX8DGp
         +1dLa3C4gu6iLCmy5ysWpAUTFLPwLjSz9GhLvlOZJsteolFpXUIl4bJ3XbTazNgV8Uax
         gpmyU18nqeBuPRwjfBwMrRsu1e6w94q0FWRSI9Vdjbdl0+r3xuWFb0Wz5Slrd4UhuiTS
         R9lJggm7DAzZD4/kzLvldKTA29a+Ptcp/0iJ/gBih0YowJ1CJjoexBQLORNZB9q8V5+h
         mkgg==
Content-Disposition: inline
In-Reply-To: <20171019200323.42491-1-nehaagarwal@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neha Agarwal <nehaagarwal@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Dan Williams <dan.j.williams@intel.com>, David Rientjes <rientjes@google.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>, Kemi Wang <kemi.wang@intel.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Shaohua Li <shli@fb.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Thu, Oct 19, 2017 at 01:03:23PM -0700, Neha Agarwal wrote:
> deferred_split_shrinker is NUMA aware. Making it memcg-aware if
> CONFIG_MEMCG is enabled to prevent shrinking memory of memcg(s) that are
> not under memory pressure. This change isolates memory pressure across
> memcgs from deferred_split_shrinker perspective, by not prematurely
> splitting huge pages for the memcg that is not under memory pressure.
> 
> Note that a pte-mapped compound huge page charge is not moved to the dst
> memcg on task migration. Look mem_cgroup_move_charge_pte_range() for
> more information. Thus, mem_cgroup_move_account doesn't get called on
> pte-mapped compound huge pages, hence we do not need to transfer the
> page from source-memcg's split to destinations-memcg's split_queue.
> 
> Tested: Ran two copies of a microbenchmark with partially unmapped
> thp(s) in two separate memory cgroups. When first memory cgroup is put
> under memory pressure, it's own thp(s) split. Other memcg's thp(s)
> remain intact.
> 
> Current implementation is not NUMA aware if MEMCG is compiled. If it is
> important to have this shrinker both NUMA and MEMCG aware, I can work on
> that.  Some feedback on this front will be useful.

I thin, this should be done. That's strange compromise -- memcg vs NUMA.
And I think solving will help a lot with ifdefs.

-- 
 Kirill A. Shutemov
