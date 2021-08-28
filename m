From: Guillaume Morin <guillaume-/FyPzM6KSZdAfugRpC6u6w@public.gmane.org>
Subject: Re: [BUG] potential hugetlb css refcounting issues
Date: Sat, 28 Aug 2021 21:37:17 +0200
Message-ID: <20210828193716.GA21491@bender.morinfr.org>
References: <8a4f2fbc-76e8-b67b-f110-30beff2228f5@oracle-com>
 <20210827225841.GA30891@bender.morinfr.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
        ; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Eg7jIAyWdnvSe9BizhWpgYxEQwOfxC+45v1t71BBM2Q=; b=FIrTWsfqFMjx6IsmX3sH67wt/S
        vrvMIZYejksNVNuxGibFxvlSZWDrxZBNEwb87X5iSIWPcWYF7oI7JA58Glx/pwiIlu3d56yrnAgJt
        tfnGq0tRMzjjO1IbbrI6v+kZ3KXaWAjHbPne5Aee8A2zi6JNwgJDXliGbP7DvDPJdGS8=;
Content-Disposition: inline
In-Reply-To: <20210827225841.GA30891-iHhE99jIcVYJQ5r9O9UB6R2eb7JE58TQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guillaume-/FyPzM6KSZdAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 28 Aug  0:58, Guillaume Morin wrote:
> > I am not sure about the above analysis.  It is true that
> > hugetlb_cgroup_uncharge_page_rsvd is called unconditionally in
> > free_huge_page.  However, IIUC hugetlb_cgroup_uncharge_page_rsvd will
> > only decrement the css refcount if there is a non-NULL hugetlb_cgroup
> > pointer in the page.  And, the pointer in the page would only be set
> > in the 'deferred_reserve' path of alloc_huge_page.  Unless I am
> > missing something, they seem to balance.
> 
> Now that you explain, I am pretty sure that you're right and I was
> wrong.
> 
> I'll confirm that I can't reproduce without my change for 2.

Confirmed. With the patch for the first issue, the issue is indeed
fixed. I must have messed up something during my testing...

Anyway, this is the change for 1:

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8ea35ba6699f..00ad4af0399b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4033,8 +4033,11 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
 	 * after this open call completes.  It is therefore safe to take a
 	 * new reference here without additional locking.
 	 */
-	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+		if (resv->css)
+			css_get(resv->css);
 		kref_get(&resv->refs);
+	}
 }
 
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)

-- 
Guillaume Morin <guillaume-/FyPzM6KSZdAfugRpC6u6w@public.gmane.org>
