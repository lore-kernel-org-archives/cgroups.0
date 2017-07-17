From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 4/6] mm/memcontrol: allow to uncharge page without using
 page->lru field
Date: Mon, 17 Jul 2017 19:10:55 +1000
Message-ID: <1500282655.8256.7.camel@gmail.com>
References: <20170713211532.970-1-jglisse@redhat.com>
	 <20170713211532.970-5-jglisse@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xRPJLkBPYuWZEELScexrQJ58sAmlb8hAMlObBBKDBY8=;
        b=dUHPM6RqDce1AqDaO0ivOP5Ms2pGprgZTcRSIFol+1sfVLGjowpBQa0KJDIG0Shhby
         CHltUYGq/EFdfkxqrjyDUDTM3XsjXauOvSIDcqxPYKl5DREii/A99z72lvuCF+UGNjpX
         UxKvHsCCWjsN/UJN8ZG8UmcSzf+rRxOdHTXfwcnFzfgf2Cj8R5c4OUadN078D96dilDz
         zk+AXgmipW/H1FdKvKaz6h7Rm3JxHLpHBUNOroErH4lArbIsFcdxvc86ZRlUk3fgjfhe
         lRADpP2Tr6N1CUXosX36PnhkeP/WanFr/okxHtxitU5fUqueS60Fmx+HuLTXreuup/Ss
         gkRA==
In-Reply-To: <20170713211532.970-5-jglisse@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: John Hubbard <jhubbard@nvidia.com>, David Nellans <dnellans@nvidia.com>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org

On Thu, 2017-07-13 at 17:15 -0400, Jérôme Glisse wrote:
> HMM pages (private or public device pages) are ZONE_DEVICE page and
> thus you can not use page->lru fields of those pages. This patch
> re-arrange the uncharge to allow single page to be uncharge without
> modifying the lru field of the struct page.
> 
> There is no change to memcontrol logic, it is the same as it was
> before this patch.
> 
> Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: cgroups@vger.kernel.org
> ---

Acked-by: Balbir Singh <bsingharora@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
