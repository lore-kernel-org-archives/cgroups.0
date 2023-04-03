From: Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org>
Subject: [PATCH v3 0/7] Split a folio to any lower order folios
Date: Mon,  3 Apr 2023 16:18:32 -0400
Message-ID: <20230403201839.4097845-1-zi.yan@sent.com>
Reply-To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680553143; x=1680639543; bh=Pt
        E34Mi5e7fcyqY/yn1ZOTjs4FeBAcshGnyuLTQZvAU=; b=B9s/caMaukwcV+M6dZ
        kL9rfGdE67qmnEh6DZ+AUJ55B1lwYnKkiaFZvFvxWifT6Qeb1s+1Qzsdmuhybud9
        yEJBjwhl17/yloWHzzlfAv0RE9u/jJDvDsBPxlC3V/+RtFzChmK/Iew9OQXh+BnW
        vTvWyK6zGm2BkJ3cYwL/+pUM0bq2Q/612wWE9WO7Y8w7gx1bxVRfySjBY8ffm+2S
        ouTUAk1Df/BVj5cSdbAM3AJY67x4h7boC1NsLkdywmHS5e/oU/GBeCPrrA795zDu
        mVP7OA8dK3cDuGuXOCDx9ca+E4uiXThMzuwRIeF+5edpSmRg7vFYqsxfu4jyB/j7
        HY4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; t=1680553143; x=1680639543; bh=P
        tE34Mi5e7fcyqY/yn1ZOTjs4FeBAcshGnyuLTQZvAU=; b=hdQl9dH6VQ/26IqYX
        DLyWdDnhElnsE5R5dMTtqP9vEPsjctti3fMutSNYYpRDF6z4WAhpyOlLdqQR/y5Z
        xko0rDzCgzEgEh/VJwcwic9W9BvKECkYWUtgNXga7PhLmmQUFPmi0LC5kx6zvKlX
        1q18Xnd7DIGG0EupwueU/TfD14QpewPnBuxdDStvScTEMTYwylClaaoqhqvvJ/o2
        9rLR0o+Q1ksTidiE0O+b+/7jCIzNyYaI/CLOfG5Gt6AJaT+HqXYBkhxzxzPOSGrU
        gE+Kd3Bjs59c9LjTGyD/ArDHxMJ9XS4JJwvMONKrytkBORXYOG7b4UYyTpZGs09T
        c9qqA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

Hi all,

File folio supports any order and people would like to support flexible ord=
ers
for anonymous folio[1] too. Currently, split_huge_page() only splits a huge
page to order-0 pages, but splitting to orders higher than 0 is also useful.
This patchset adds support for splitting a huge page to any lower order pag=
es
and uses it during file folio truncate operations.

The patchset is on top of mm-everything-2023-03-27-21-20.

Changelog=20
=3D=3D=3D
Since v2
---
1. Fixed an issue in __split_page_owner() introduced during my rebase

Since v1
---
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

[1] https://lore.kernel.org/linux-mm/Y%2FblF0GIunm+pRIC-FZi0V3Vbi30CUdFEqe4BFym6D+HspMUB@public.gmane.org=
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
 mm/page_owner.c                               |   8 +-
 mm/truncate.c                                 |  21 +-
 .../selftests/mm/split_huge_page_test.c       | 225 +++++++++++++++++-
 9 files changed, 365 insertions(+), 68 deletions(-)

--=20
2.39.2

