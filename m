From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 14/18] mm/memcg: Convert mem_cgroup_move_account() to
 use a folio
Date: Wed, 30 Jun 2021 13:31:17 +0100
Message-ID: <YNxkFSGUoaSzZ/36@casper.infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-15-willy@infradead.org>
 <YNwrrl6cn48t6w5B@dhcp22.suse.cz>
 <YNxUCLt/scn1d5jQ@casper.infradead.org>
 <YNxhlr4d7Nl0vCz0@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UBd7x8oOESyXHL0o+sRYkr8wI6RsNQA59DUwMSupoB0=; b=jP+5gMkb2FqkWqcLcLCf3XpWoh
        5QgJSig4Hu9XHjCVUAgIVenQkEoLza5dGOKEq0m/nAO7Wv1ynntYUsaC2Mf7EI9nFROFb6lWvXJ6E
        ncM1tlURSqZmGILjzMUoC41gU+rXWMiOeCIaw501eSJFmWdOhqTYD4zKbw8+TZcR8bGzXFe+A3QK7
        XqTpIc+LBlGc5FtnmFkMyxgePwIqrwXcuANAbl7LHtY8KzlJsUbQ/SX9aFlk548MbUQhdq9XRc4u8
        f1iSuo4eAkhQNnDZuVodgOv4lTWkgDiLrhiVPuOu+XLhbCjWZf45LTN7QrLLEW2nZ5Rq3Eq4ZV+zM
        sYx45zEw==;
Content-Disposition: inline
In-Reply-To: <YNxhlr4d7Nl0vCz0-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 30, 2021 at 02:20:38PM +0200, Michal Hocko wrote:
> On Wed 30-06-21 12:22:48, Matthew Wilcox wrote:
> > We need to decide what 'NR_ANON_THPS' means in a folio-based world where
> > we have folios of all orders.  Does it count only the number of pages
> > in folios >= HPAGE_PMD_SIZE?  Or does it count the number of pages in
> > folios > PAGE_SIZE?
> 
> At this stage we only have PMD based, right? I believe it would be
> simpler to stick with that at the moment and change that to a more
> generic way along with other places which need updating.
> 
> Wrt. counters they do count pages so in this case this shouldn't be a
> problem. But we do have counters for pmd mappings and that might need
> some care.

Looking at how these are reported:

        show_val_kb(m, "AnonHugePages:  ",
                    global_node_page_state(NR_ANON_THPS));
        show_val_kb(m, "ShmemHugePages: ",
                    global_node_page_state(NR_SHMEM_THPS));
        show_val_kb(m, "ShmemPmdMapped: ",
                    global_node_page_state(NR_SHMEM_PMDMAPPED));
        show_val_kb(m, "FileHugePages:  ",
                    global_node_page_state(NR_FILE_THPS));
        show_val_kb(m, "FilePmdMapped:  ",
                    global_node_page_state(NR_FILE_PMDMAPPED));

it specifically refers to 'HugePages', so I think we need to only
count folios with order >= PMD_ORDER.  I'll make that change to
folio_transhuge() and use folio_transhuge() here.
