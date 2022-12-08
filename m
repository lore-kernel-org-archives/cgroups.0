From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for-6.1-fixes] memcg: Fix possible use-after-free in
 memcg_write_event_control()
Date: Thu, 8 Dec 2022 15:36:34 +0100
Message-ID: <Y5H2clPCac1gIE7I@cmpxchg.org>
References: <Y5FRm/cfcKPGzWwl@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XpT/D9wiadtdd3e4LD/NlNKNROKlLGu0EeO/Y2cMVkU=;
        b=yaLVQV2sZvB66nEBKpEDKn1QIIFVfhV06yDQIM+8N2W90AxPc9Vrl/BgiiNABpQZYo
         w2p4bz4FMdjPz2rhPDLmHgcUK5wfEhpob+2m9bwgMetjD8AUuPdt4/KsnbczW1yU25ZM
         Te1vHw41kmz6KTwhNxqnrZeUeeuuJC18TCZWuJRIaOmq8wM85+i/9IicaILlnBHalFwQ
         oagzbVgq6jkXLuezmCsOnnFVTZc0eqHwOIpWYWgI8BlNgC0Tbeo9PXFRolB1/9l2IiVa
         Sl2a4vyf83n1mIs2h/qlWXgiX8yqbZdwCpFONfyadCGCxoYjpSmzplWq/5XmV2UI31qq
         0/MA==
Content-Disposition: inline
In-Reply-To: <Y5FRm/cfcKPGzWwl@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org

On Wed, Dec 07, 2022 at 04:53:15PM -1000, Tejun Heo wrote:
> memcg_write_event_control() accesses the dentry->d_name of the specified
> control fd to route the write call. As a cgroup interface file can't be
> renamed, it's safe to access d_name as long as the specified file is a
> regular cgroup file. Also, as these cgroup interface files can't be removed
> before the directory, it's safe to access the parent too.
> 
> Prior to 347c4a874710 ("memcg: remove cgroup_event->cft"), there was a call
> to __file_cft() which verified that the specified file is a regular cgroupfs
> file before further accesses. The cftype pointer returned from __file_cft()
> was no longer necessary and the commit inadvertently dropped the file type
> check with it allowing any file to slip through. With the invarients broken,
> the d_name and parent accesses can now race against renames and removals of
> arbitrary files and cause use-after-free's.
> 
> Fix the bug by resurrecting the file type check in __file_cft(). Now that
> cgroupfs is implemented through kernfs, checking the file operations needs
> to go through a layer of indirection. Instead, let's check the superblock
> and dentry type.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Fixes: 347c4a874710 ("memcg: remove cgroup_event->cft")
> Cc: stable@vger.kernel.org # v3.14+
> Reported-by: Jann Horn <jannh@google.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
