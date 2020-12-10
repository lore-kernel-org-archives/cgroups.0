From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RESEND PATCH v2 02/12] mm: memcontrol: convert NR_ANON_THPS
 account to pages
Date: Thu, 10 Dec 2020 17:10:29 +0100
Message-ID: <20201210161029.GI264602@cmpxchg.org>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201206101451.14706-3-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zUKjdCr35kTtWg9pE3u73paElIIDHX8nqIkj6s1ib6s=;
        b=hrMth0SEQRxie/k9/Vd7afehjyxbhsINzLj3zAnJA9Yc81plSsX6q1YfAyDsHvD8Cs
         NhXOc1znnPbG3vyEKM9DACHYZ5NFqG9IRNduTMAMmU+NSnCAFrqSyFlul4FWnPlN+V2I
         xXoo9Rk9qDlkvKVMd9QCC2rDMzMv7lhhfCTYJckuWL/jfgBUWm7byY5YYFauJjdhobmM
         ZzTSn051klLcV4J6Q6Uh5PMzfZeFk1hLNSNbsP+wnhYDED0htSljIwO0Zj8wFkzlTzQs
         +GObVaXpGhdCoMMkgmsXpeE1vBErVdcDEDV897ys+aI1sNw5+s/MI7VAHS7pcqsHcUuk
         yiIQ==
Content-Disposition: inline
In-Reply-To: <20201206101451.14706-3-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, will@kernel.org, guro@fb.com, rppt@kernel.org, tglx@linutronix.de, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, surenb@google.com, avagin@openvz.org, elver@google.com, rdunlap@infradead.org, iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Sun, Dec 06, 2020 at 06:14:41PM +0800, Muchun Song wrote:
> @@ -1144,7 +1144,8 @@ void do_page_add_anon_rmap(struct page *page,
>  		 * disabled.
>  		 */
>  		if (compound)
> -			__inc_lruvec_page_state(page, NR_ANON_THPS);
> +			__mod_lruvec_page_state(page, NR_ANON_THPS,
> +						HPAGE_PMD_NR);
>  		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);

What I mistakenly wrote about the previous patch applies to this and
the following patches, though:

/proc/vmstat currently prints number of anon, file and shmem THPs; you
are changing it to print number of 4k pages in those THPs.

That's an ABI change we cannot really do.
