From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 2/4] mm: Fix get_mctgt_type() kernel-doc
Date: Sat, 19 Aug 2023 17:52:04 -0700
Message-ID: <df2ec434-69cd-fe3b-50de-462a9c7eda41@infradead.org>
References: <20230818200630.2719595-1-willy@infradead.org>
 <20230818200630.2719595-3-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=c94fHYxIWl9lBifgcspinxKU2QHJURmIgDdd+1otOjo=; b=GDPo+eqAkD2WDQPmJ2y2konEcv
        fp4a5Zv29YS4L903aE7mPxLttTS8765T5saJnuvJPvyLla6eC4H2k15yRLsZk3R7Ki3u/Lvn+Z6zE
        TGWQQ/eEvCNmfI5O51mNrdR+vrat/83NmlbCiG0Fm+d+ri9Km+r67lVW3RYuVeaYKW7ngGHR5K5Si
        zK6NheDXhSjOVaSmWrHbtKSoO6sXELTTK5D77Co26QjB5BuNUzGZ8UtJO7lZS2QwY/IwZQuYup6w+
        GTVhZEM9xaKiFQzvO2CwBclmBFzETmmMymycokOU0UkC254WwvrdvT3PfUFGAUDDFCZPe1AlAbuNf
        YcJfsVmw==;
Content-Language: en-US
In-Reply-To: <20230818200630.2719595-3-willy@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org



On 8/18/23 13:06, Matthew Wilcox (Oracle) wrote:
> Convert the return values to an ReST list and tidy up the wording while
> I'm touching it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/memcontrol.c | 31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e041ba827e59..cd8b3ae6b8d9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5850,25 +5850,20 @@ static int mem_cgroup_move_account(struct page *page,
>   * @ptent: the pte to be checked
>   * @target: the pointer the target page or swap ent will be stored(can be NULL)
>   *
> - * Returns
> - *   0(MC_TARGET_NONE): if the pte is not a target for move charge.
> - *   1(MC_TARGET_PAGE): if the page corresponding to this pte is a target for
> - *     move charge. if @target is not NULL, the page is stored in target->page
> - *     with extra refcnt got(Callers should handle it).
> - *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
> - *     target for charge migration. if @target is not NULL, the entry is stored
> - *     in target->ent.
> - *   3(MC_TARGET_DEVICE): like MC_TARGET_PAGE  but page is device memory and
> - *   thus not on the lru.
> - *     For now we such page is charge like a regular page would be as for all
> - *     intent and purposes it is just special memory taking the place of a
> - *     regular page.
> - *
> - *     See Documentations/vm/hmm.txt and include/linux/hmm.h
> - *
> - * Called with pte lock held.
> + * Context: Called with pte lock held.
> + * Return:
> + * * MC_TARGET_NONE - If the pte is not a target for move charge.
> + * * MC_TARGET_PAGE - If the page corresponding to this pte is a target for
> + *   move charge. If @target is not NULL, the page is stored in target->page
> + *   with extra refcnt got (Callers should handle it).

I would s/got/taken/.

> + * * MC_TARGET_SWAP - If the swap entry corresponding to this pte is a
> + *   target for charge migration. if @target is not NULL, the entry is stored

s/if/If/

> + *   in target->ent.
> + * * MC_TARGET_DEVICE - Like MC_TARGET_PAGE but page is device memory and
> + *   thus not on the lru.  For now such page is charged like a regular page
> + *   would be as it is just special memory taking the place of a regular page.
> + *   See Documentations/vm/hmm.txt and include/linux/hmm.h
>   */
> -
>  static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
>  		unsigned long addr, pte_t ptent, union mc_target *target)
>  {

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

-- 
~Randy
