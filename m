From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 0/4] Improve mm documentation
Date: Fri, 18 Aug 2023 21:06:26 +0100
Message-ID: <20230818200630.2719595-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=sS4yQXJ2Ya3KF8lqJJez/ry2mxKfhg1PxX5ngqnXF1w=; b=Odxo8IkqUnJLxGrSY+DvFGfooH
        vN+ao/DDJPwfKbeLt8qj9IuL1ZDN1NGpEL/LvlZ5ixQyLt1dNz8c7rJJYraWBJvqWa2QYDyuhRmJS
        /dNWPMrBKeMQm2eUN3tqTYt2wNsE/q7NMsavULQgQgN6F5EbX1PZ5d2ZVaF+UnchLCSDpNzK3yDCU
        0VUy5K31ZVPWwGxjaEARqeh07lVygSoTG+RJAZKVIXjEQRj+lgJ5FLX/XHVYxYkguU1POn5V0lBCr
        F0ha0kOAx8ywFl/XMawCQYsXk7yqhZuQDWglk8fnQpw8bvNEbjOeXDdeJYTaOZ+IzSjejRcFp58Qt
        1kr/K7Xw==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

If you build with W=1, kernel-doc complains about tlb_flush_rmaps().
Then I ran scripts/find-unused-docs.sh against mm/ and found a large
number of files which weren't included in the ReST documentation.
I fixed up a couple of them, and added all those without erros to the
rst files.  There's a lot more work to do to organise all of this, but
at least now if we have documentation that refers to these functions,
we'll get a nice link to them.

Matthew Wilcox (Oracle) (4):
  mm: Fix kernel-doc warning from tlb_flush_rmaps()
  mm: Fix get_mctgt_type() kernel-doc
  mm: Fix clean_record_shared_mapping_range kernel-doc
  mm: Add orphaned kernel-doc to the rst files.

 Documentation/core-api/mm-api.rst | 25 +++++++++++++++++++++++++
 Documentation/mm/highmem.rst      |  1 +
 Documentation/mm/zsmalloc.rst     |  5 +++++
 mm/mapping_dirty_helpers.c        | 11 ++++++-----
 mm/memcontrol.c                   | 31 +++++++++++++------------------
 mm/mmu_gather.c                   |  1 +
 6 files changed, 51 insertions(+), 23 deletions(-)

-- 
2.40.1

