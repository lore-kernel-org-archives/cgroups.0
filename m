From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 13/18] mm/memcg: Add folio_memcg_lock() and
 folio_memcg_unlock()
Date: Wed, 7 Jul 2021 13:08:51 -0400
Message-ID: <YOXfozcU8M/x2RQ4@cmpxchg.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-14-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zKFzxaicRuEWN6JDVuwxf/5fHNRnvOJNXCo8RqlfnUo=;
        b=K07Xb99QcriEOisR00l22wLQPQEOIpOXNJAf9NhgVco/oZ9jwUnQ0BR4m/V9l2aVu3
         7Ue85P+ZxUFOf7SP+RuJxDYfEyBUPkLCBoJ2Tbjlh0beKAnJ/INjxQ6Fkx+jJqhYaVGT
         RjMT0XF4LKj/9H7bu0nqsgCsRncfO3IsCb6RKkdDyvHJKow5YHLgaVkGWPoyOig8rF7q
         u37fNGzarIMgfy9mJlnW7SqjOVYt3o9RJ+FxXglVlM5PGmawY/NT4yBDQxiPBNUMYhNM
         7eUk/7LFiyrGoo6WBmJpGhK+MbzOdBSwOgaZRXJY+665Xnpq9Ws4ZIiUBCaYBAKXhqZ0
         Bv+Q==
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-14-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 30, 2021 at 05:00:29AM +0100, Matthew Wilcox (Oracle) wrote:
> -static void __unlock_page_memcg(struct mem_cgroup *memcg)
> +static void __memcg_unlock(struct mem_cgroup *memcg)

This is too generic a name. There are several locks in the memcg, and
this one only locks the page->memcg bindings in the group.
