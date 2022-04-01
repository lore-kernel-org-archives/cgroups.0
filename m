From: Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH] mm/memcg: remove unneeded nr_scanned
Date: Fri, 1 Apr 2022 01:06:50 +0000
Message-ID: <20220401010650.reelvkf2pbxkf4gl@master>
References: <20220328114144.53389-1-linmiaohe@huawei.com>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c4Oi4+nEs2DuySa9fWn+II5/KnAf5RCOAxddnuEBjOo=;
        b=lfJTMOnXLxxBegeJG4M42CyKemTU/7xuAJV2g/QkGorJ5kHTAh/M5uKr6kG4xoBNfR
         L1xhi5B2ZyPy/f0mZ5YRo3ikrGrYDzZRu3RAdN18kTWK+UujBZoPAObDDm+F9YRAGl+l
         FOw9eob8rUJZ/k8ShN5GTEUW0dc6D+LeL5F/EO/BDprdVBrO5HTrWdE9CSvV6SdLG+X/
         Gpy6uKexODNQePKE2QVgrMi3JfsQhqsK4g6innaeK6jizr/lMKYbhtOZS4+ONqPy8B3m
         wZWZqn/cMxIqqWyzj7B2Nyk02w5F6p87DndFTpuoA+usFGlgs94EnlTR30hzdxOktTrD
         hiaQ==
Content-Disposition: inline
In-Reply-To: <20220328114144.53389-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Mon, Mar 28, 2022 at 07:41:44PM +0800, Miaohe Lin wrote:
>The local variable nr_scanned is unneeded as mem_cgroup_soft_reclaim always
>does *total_scanned += nr_scanned. So we can pass total_scanned directly to
>the mem_cgroup_soft_reclaim to simplify the code and save some cpu cycles
>of adding nr_scanned to total_scanned.
>
>Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>---

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

Thanks

-- 
Wei Yang
Help you, Help me
