From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm/memcg: fix obsolete function name in
 mem_cgroup_protection()
Date: Sun, 23 Jul 2023 21:37:27 +0100
Message-ID: <ZL2Ph5g05Ud5vAdT@casper.infradead.org>
References: <20230723032538.3190239-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qy3ZfgxHtTZ+H6cA0c7w6ZZsFamgKKUHdZT7/5uteAk=; b=kTr4Znvd56MMHUXN0EHN8A34Ch
        yiVFzsJ9la7YOzyYLmo8iAxAVQiM+usii43xNwFPgEB3Dm89Ext45zyoZLgfbRA4T8YE2AeEfACaF
        hdlN4RXUJW4jvNU4NOJzGo99BTK+HQo9ASaYlCCYkYPE+iNCCcK8LV1kVkn/JsqOaCl/XMoyn0hJx
        RQw2aR4JbD5kt7Z+XuffKRiNWeewjEJlhH9GuiZ0SgDFWquMWUKmsqdV/kHmkhcqVJkPVS4IHakPG
        tjL6ymvrdGUk+ht5MZQDwVUrFlesfweWrITUN076QSLeriL/Y/lb2HtYOOEDJfCYwzH0LEY4YDomT
        0eS8ohCg==;
Content-Disposition: inline
In-Reply-To: <20230723032538.3190239-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Sun, Jul 23, 2023 at 11:25:38AM +0800, Miaohe Lin wrote:
> @@ -582,9 +582,9 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
>  	/*
>  	 * There is no reclaim protection applied to a targeted reclaim.
>  	 * We are special casing this specific case here because
> -	 * mem_cgroup_protected calculation is not robust enough to keep
> -	 * the protection invariant for calculated effective values for
> -	 * parallel reclaimers with different reclaim target. This is
> +	 * mem_cgroup_calculate_protection calculation is not robust enough
> +	 * to keep the protection invariant for calculated effective values
> +	 * for parallel reclaimers with different reclaim target. This is
>  	 * especially a problem for tail memcgs (as they have pages on LRU)
>  	 * which would want to have effective values 0 for targeted reclaim
>  	 * but a different value for external reclaim.

This reads a little awkwardly now.  How about:

 	 * We are special casing this specific case here because
-	 * mem_cgroup_protected calculation is not robust enough to keep
+	 * mem_cgroup_calculate_protection is not robust enough to keep
 	 * the protection invariant for calculated effective values for
	 * parallel reclaimers with different reclaim target. This is
