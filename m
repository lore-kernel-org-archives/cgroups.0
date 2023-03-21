From: Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org>
Subject: [PATCH 0/5] Split a folio to any lower order folios
Date: Mon, 20 Mar 2023 20:48:24 -0400
Message-ID: <20230321004829.2012847-1-zi.yan@sent.com>
Reply-To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1679359729; x=1679446129; bh=oG
        kjK2TbqrODiZ27bwpufFy80dPhzmLH1tKePfQCcsg=; b=v2FnbI7Rk9K6GPSwoV
        xTFz47m9B3DRkVgQxdK6L5tpwV54Pkk7nXPDW8hO9SqjDMl1ZpssfT6uEk2Yrbnj
        95keebwa6R3FM4Pf/+d9dgLdWAhDmVitG2jRZLxpi4Fj9X2ICuP9iusyKQv0yjdV
        vy6xo2bGVmW2P9VxdwPsscbPDhoLYU4CrDQS9TRgNrj1bs+YmyjAYIfVFNyHwbdN
        PTjHUe5eyOqJdy5/nDUl2mESU2Nj5bSt8b7fGgACtHwaf+DfXEeltmX7FpBE23oS
        GF6nRFzvAOu0tobGk2qS0ijszzwi7x63ONxjyyVMfRQUr1ZGxwmrJfkEaoum/gBk
        EJgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; t=1679359729; x=1679446129; bh=o
        GkjK2TbqrODiZ27bwpufFy80dPhzmLH1tKePfQCcsg=; b=DzX6tcpSYSk9j7QHV
        +EMwBA/10OxE8TVWLr6K+huXm9MJ53Bi6IxUgPIubvFX74ivmSImfisv3iXPZAIs
        uVJo45bg4cO2YTOSRzkZXiBSFQkiuPYjDsuJORjml0Bs/fO+u16RAic6UHbGuIK8
        BkW333wARlfN/fCdjK1KeJS4UPSDYszqbsUqyVNcOBm47PQqJt5HQ5R5oQ0k9DYJ
        PQi1X64ymp6bOKP4HS60cIr/T/k1jeklixqZaPsRpz3ERurcT93fmsn/uPNkRrp6
        g1aKzOcYnI9aUdBrHnAqfYGDjCz8DWeeaAA3vEqEzL0U1fyFK9/gNbyplQlRoCOl
        HIjEA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

Hi all,

File folio supports any order and people would like to support flexible ord=
ers
for anonymous folio[1] too. Currently, split_huge_page() only splits a huge
page to order-0 pages, but splitting to orders higher than 0 is also useful.
This patchset adds support for splitting a huge page to any lower order pag=
es
and uses it during folio truncate operations.

The patchset is on top of mm-everything-2023-03-19-21-50.

* Patch 1 and 2 add new_order parameter split_page_memcg() and
  split_page_owner() and prepare for upcoming changes.
* Patch 3 adds split_huge_page_to_list_to_order() to split a huge page
  to any lower order. The original split_huge_page_to_list() calls
  split_huge_page_to_list_to_order() with new_order =3D 0.
* Patch 4 uses split_huge_page_to_list_to_order() in large pagecache folio
  truncation instead of split the large folio all the way down to order-0.
* Patch 5 adds a test API to debugfs and test cases in
  split_huge_page_test selftests.

Comments and/or suggestions are welcome.

[1] https://lore.kernel.org/linux-mm/Y%2FblF0GIunm+pRIC-FZi0V3Vbi30CUdFEqe4BFym6D+HspMUB@public.gmane.org=
g/

Zi Yan (5):
  mm: memcg: make memcg huge page split support any order split.
  mm: page_owner: add support for splitting to any order in split
    page_owner.
  mm: thp: split huge page to any lower order pages.
  mm: truncate: split huge page cache page to a non-zero order if
    possible.
  mm: huge_memory: enable debugfs to split huge pages to any order.

 include/linux/huge_mm.h                       |  10 +-
 include/linux/memcontrol.h                    |   5 +-
 include/linux/page_owner.h                    |  12 +-
 mm/huge_memory.c                              | 138 ++++++++---
 mm/memcontrol.c                               |   8 +-
 mm/page_alloc.c                               |   8 +-
 mm/page_owner.c                               |  11 +-
 mm/truncate.c                                 |  21 +-
 .../selftests/mm/split_huge_page_test.c       | 225 +++++++++++++++++-
 9 files changed, 368 insertions(+), 70 deletions(-)

--=20
2.39.2

