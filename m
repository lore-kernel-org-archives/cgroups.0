From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RESEND PATCH v2 01/12] mm: memcontrol: fix NR_ANON_THPS account
Date: Thu, 10 Dec 2020 17:00:45 +0100
Message-ID: <20201210160045.GF264602@cmpxchg.org>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201206101451.14706-2-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6cqy3h6zeyXBfeazWGfRXkH+RsOnGkrK4uYLa4meA10=;
        b=F55eqp5BdR+2SiD7cUjPc/dE5pm//HKBnJEcNN5JIQ3kahgaFcm0unTLLFNeCYA/Hd
         mo7zbwH1GSpHvmwgMtLlswl7zttk633FKLWuA8j2R6zKbbTOwJPzK9qAjGbt32uLuL9E
         3qT0+KI8QM1ZnsV+MPMeOJmcQZ+hGQTxRAC3++ooyZlY35akuYScnqpB0mLR0PT38nzY
         3/i0V4j1Rd3vnz8E/9ditif0EzUdhdzgBSvDcW91585TV28VDRDMer1gez6ryZTsRRya
         xFaWZ7TA5GBO/ZOctXMy2slNo0Ju3Vf9KOqund3aOhniPqFeoR78cVC+bfD2xzG5pIjZ
         +F+g==
Content-Disposition: inline
In-Reply-To: <20201206101451.14706-2-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, will@kernel.org, guro@fb.com, rppt@kernel.org, tglx@linutronix.de, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, surenb@google.com, avagin@openvz.org, elver@google.com, rdunlap@infradead.org, iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Sun, Dec 06, 2020 at 06:14:40PM +0800, Muchun Song wrote:
> The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
> by one rather than nr_pages.

This is a real bug, thanks for catching it.

However, your patch changes the user-visible output of /proc/vmstat!

NR_ANON_THPS isn't just used by memcg, it's a generic accounting item
of the memory subsystem. See this from the Fixes:-patch:

-                       __inc_node_page_state(page, NR_ANON_THPS);
+                       __inc_lruvec_page_state(page, NR_ANON_THPS);

While we've considered /proc/vmstat less official than other files
like meminfo, and have in the past freely added and removed items,
changing the unit of an existing one is not going to work.
