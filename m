From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 5/6] mm/memcontrol: support MEMORY_DEVICE_PRIVATE and
 MEMORY_DEVICE_PUBLIC v3
Date: Mon, 17 Jul 2017 19:15:38 +1000
Message-ID: <1500282938.8256.9.camel@gmail.com>
References: <20170713211532.970-1-jglisse@redhat.com>
	 <20170713211532.970-6-jglisse@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A4zpS19rDw07ZTc5n+UabKnGPD7uk04h8qFSKwN/XWM=;
        b=LhnLwKWQHT97/ExOjpEWcH6pX8DJt09OQ1O4qxFDK5s9owFk+KJcWoparosm7mJpBr
         /NkmDXfSNfOvgMcgUATjsrE7+NwZTAArQLJQglpRBjXHPRbqXTyEqvBKldutQbDl+3BA
         SZEesMa4Bb6zbHRShfaCxGM1Fre4WOTpALN/jIfmDxXrdDHPDI5izWigjtHcaw6wqs/5
         M0UKyMBI2g78FrcL633ybzUMuop4MjKeAMvxdq5ve0zlDZSPKjts6GYzjIfL1+LDfQA8
         x5QJo7PGMBP/l+UL+DRHK7wjipkSv97D42KFpEU7Ly8Xke1i4vWbzqhKHTlDBUXEd18o
         EMxA==
In-Reply-To: <20170713211532.970-6-jglisse@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: John Hubbard <jhubbard@nvidia.com>, David Nellans <dnellans@nvidia.com>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org

On Thu, 2017-07-13 at 17:15 -0400, Jérôme Glisse wrote:
> HMM pages (private or public device pages) are ZONE_DEVICE page and
> thus need special handling when it comes to lru or refcount. This
> patch make sure that memcontrol properly handle those when it face
> them. Those pages are use like regular pages in a process address
> space either as anonymous page or as file back page. So from memcg
> point of view we want to handle them like regular page for now at
> least.
> 
> Changed since v2:
>   - s/host/public
> Changed since v1:
>   - s/public/host
>   - add comments explaining how device memory behave and why
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
