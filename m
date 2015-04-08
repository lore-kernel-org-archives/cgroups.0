From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH -mm] slab: use cgroup ino for naming per memcg caches
Date: Wed, 8 Apr 2015 08:46:22 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1504080845200.13120@gentwo.org>
References: <1428414798-12932-1-git-send-email-vdavydov@parallels.com> <20150407133819.993be7a53a3aa16311aba1f5@linux-foundation.org> <20150408095404.GC10286@esperanza>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150408095404.GC10286@esperanza>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=comcast.net;
	s=q20140121; t=1428500784;
	bh=3EJqU/c7vpjv52fzKPqYdIKwtnfIh7A3JYq7wsemE1o=;
	h=Received:Received:Received:Received:Date:From:To:Subject:
	 Message-ID:Content-Type;
	b=JEUBEPmCM4dwuyY3RaHRKNCKYfjxAfsi2jJzZ5lyJwTBYO0oXJw8gO3eu/kqtimIV
	 UBhjx0NOdmFnm+7EDKCdKX7BzPT6Wq7F48jTlOdzIYo3qqo9EkoiR2zWKUY/xBnk8r
	 p3ja8IfaKhdNX9FKUQWkofriOGiybCfO6SmIPkQAeamhHXA8g6MCXPUJl0kBL7LWUs
	 qJtSYbL1cnUELWsmqBVKR3LlOBSk3MP7SVsNdnMQHIoOApsh2mKCCE40fTSY7S9Onl
	 +1lOvhwvh7EZe53P/lMLkzy9UJq/20ZkrvZcl07x/y9efXKO6O2JK9e4Up5U8t6hCm
	 28L7ZcIVQRGig==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 8 Apr 2015, Vladimir Davydov wrote:

> has its own copy of kmem cache. What if we decide to share the same kmem
> cache among all memory cgroups one day? Of course, this will hardly ever
> happen, but it is an alternative approach to implementing the same

/sys/kernel/slab already supports the use of symlinks. And both SLAB and
SLUB do slab merging which means effectively an aliasing of multiple slab
caches to the same name.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
