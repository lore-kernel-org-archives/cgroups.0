From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 03/18] mm/memcg: Use the node id in
 mem_cgroup_update_tree()
Date: Wed, 30 Jun 2021 10:18:47 -0400
Message-ID: <YNx9R1lZe7ugwS4n@cmpxchg.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-4-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NHOfskBMscOWo8oHAVTd3r5USS+PMqdTaB3S184K0g8=;
        b=e2VD0gvbg5EBocbr4RU9lsaAxSQrpxjSqnQLMdmbaOOHyqVE2uU5mou9nL+823hYH6
         TUGJ1CgzW8/g2z/dk1giU+QC8JZ2yupy7hxiBSnoU5fBIKs4xcEkjAYhqrde+j6QFyuD
         6TkgwSpSkeCvDSjzz/Cg3X7pgZ0cS8NaaBgUyV6dFuwtHQC0lCdm5s8EKQ3yy8gZZByJ
         g59bRWim7rzZ3YaZb7Nngrrmw4AFQsDuAoM2gI7TrrECRwODxzPc3rumwgPKWrzaHeIQ
         ZNvI0crvydaDuZajEhHf6yf4TjiTQkCb862LKp2G24T5RRTUuC3ARVWli0Bw9cxyJ6jx
         f9Rg==
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-4-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 30, 2021 at 05:00:19AM +0100, Matthew Wilcox (Oracle) wrote:
> By using the node id in mem_cgroup_update_tree(), we can delete
> soft_limit_tree_from_page() and mem_cgroup_page_nodeinfo().  Saves 42
> bytes of kernel text on my config.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
