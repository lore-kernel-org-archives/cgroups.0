From: Zi Yan <zi.yan@sent.com>
Subject: [PATCH v2 0/7] Split a folio to any lower order folios
Date: Tue, 28 Mar 2023 21:17:05 -0400
Message-ID: <20230329011712.3242298-1-zi.yan@sent.com>
Reply-To: Zi Yan <ziy@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680052654; x=1680139054; bh=JI
        hj9np4mbbgqAGn5v0t2MJdvOZp0Xk+M5zFinazxgw=; b=Y75fKkXMy8AqDoNb1z
        WUxKUuoEatALeZNXp3NsVv9yNgvzcF4Dwo7X87U2OqlWnb4jarG/ZQrNHEeHulG9
        AZEzLYY+mpAqDBUnzhQagPB+bwAua8pZxwUonO26ma6Szwfiv4Lqw2iG2Snj5V6b
        3FESEK32JezQ6q6lWR5ZAoT96o+key82qGItVNY2Rcq227zzRdiwq7vHasKZWkEK
        J3qB5/+O9yYWoiqmk8Af5HV3Ndjq4Z1aASr5haenQJtyZbwJQn76+UANw7qSHWvb
        XYR9VzwM1iH8TrnhYlCjRusDvSfcRUjXlM1K0TlGBqVrrCRUT3Hv/RAgi0USIlus
        SNfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; t=1680052654; x=1680139054; bh=J
        Ihj9np4mbbgqAGn5v0t2MJdvOZp0Xk+M5zFinazxgw=; b=dnFIZgno8DAeHWb8t
        QVevHEkRVdHPNRmSjtBeYGtD7S351lY8WeeJN0r6RHnS8mkiBDdUT3HKiszdUXA4
        OCI8scZQx+lBJ1c+RCrGPrQEHUDUmo9vNbJ7A7eF3fofFxITUdH27acBpZTCqvBT
        ERU3A94thqIT7v89E1mBi8iVh3l2X43z2vbZTDk7fVTaWZfB8u826nTmmy23P+sZ
        L2E8WCaXnxwv1ezA/HWZm6CE7LhQbFVWYEZbH2kXVRztHAUFOGkZrXy/rtbRWHXN
        /mhVySczaKYMuC92TF7rZD6C6H9g7HE+C8zCWCJFQn7AZ0HAUn7KHd/Ot1FZ+ldQ
        tXMmA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yang Shi <shy828301@gmail.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ryan Roberts <ryan.roberts@arm.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, Zach O'Keefe <zokeefe@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

Hi all,

File folio supports any order and people would like to support flexible ord=
ers
for anonymous folio[1] too. Currently, split_huge_page() only splits a huge
page to order-0 pages, but splitting to orders higher than 0 is also useful.
This patchset adds support for splitting a huge page to any lower order pag=
es
and uses it during folio truncate operations.

The patchset is on top of mm-everything-2023-03-27-21-20.

Changelog from v1
=3D=3D=3D
1. Changed split_page_memcg() and split_page_owner() parameter to use order
2. Used folio_test_pmd_mappable() in place of the equivalent code

Details
=3D=3D=3D

* Patch 1 changes split_page_memcg() to use order instead of nr_pages
* Patch 2 changes split_page_owner() to use order instead of nr_pages
* Patch 3 and 4 add new_order parameter split_page_memcg() and
  split_page_owner() and prepare for upcoming changes.
* Patch 5 adds split_huge_page_to_list_to_order() to split a huge page
  to any lower order. The original split_huge_page_to_list() calls
  split_huge_page_to_list_to_order() with new_order =3D 0.
* Patch 6 uses split_huge_page_to_list_to_order() in large pagecache folio
  truncation instead of split the large folio all the way down to order-0.
* Patch 7 adds a test API to debugfs and test cases in
  split_huge_page_test selftests.

Comments and/or suggestions are welcome.

[1] https://lore.kernel.org/linux-mm/Y%2FblF0GIunm+pRIC@casper.infradead.or=
g/

Zi Yan (7):
  mm/memcg: use order instead of nr in split_page_memcg()
  mm/page_owner: use order instead of nr in split_page_owner()
  mm: memcg: make memcg huge page split support any order split.
  mm: page_owner: add support for splitting to any order in split
    page_owner.
  mm: thp: split huge page to any lower order pages.
  mm: truncate: split huge page cache page to a non-zero order if
    possible.
  mm: huge_memory: enable debugfs to split huge pages to any order.

 include/linux/huge_mm.h                       |  10 +-
 include/linux/memcontrol.h                    |   4 +-
 include/linux/page_owner.h                    |  10 +-
 mm/huge_memory.c                              | 137 ++++++++---
 mm/memcontrol.c                               |  10 +-
 mm/page_alloc.c                               |   8 +-
 mm/page_owner.c                               |  10 +-
 mm/truncate.c                                 |  21 +-
 .../selftests/mm/split_huge_page_test.c       | 225 +++++++++++++++++-
 9 files changed, 366 insertions(+), 69 deletions(-)

--=20
2.39.2

