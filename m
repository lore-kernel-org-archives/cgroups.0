From: Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org>
Subject: [RFC PATCH 0/5] Split a huge page to any lower order pages
Date: Mon, 21 Mar 2022 10:21:23 -0400
Message-ID: <20220321142128.2471199-1-zi.yan@sent.com>
Reply-To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=pSy3YPBu+/Cd5RMyqASVwEfmerfJzG0+Vw1/6k
        t87sA=; b=q6QxiZEU+ohV+10FvyUKIjGnTSRoSHlpvgwfEjwGOEAoXLK4/5BGA8
        m5isDzhoavsFa5mTRfFhuqpiaK0YU2MEap8p+gijWkWV5gZPsackzZxZrNqYQN0u
        WrOusrwDGmnpIyYT5bH4G5B1mJcIdnLuVOfj2FgFezdTazAc/ybeah5MOZoCxMUa
        OqYSjAMVUlWz0xA76X07Dnyytc1bJoi4BEcnuATbU2qcb665cPKm8ZwplkCjwh2/
        fwCfScohXyloR60UCfhWwhhDflV2Lln3XbnbrPGPkLTjrUnU6S9aqMrt/zhf/1nd
        RV/Q7cGtRIzVELUCYqnPo15SqGHIDhdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:reply-to
        :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm3; bh=pSy3YPBu+/Cd5RMyqASVwEfmerfJz
        G0+Vw1/6kt87sA=; b=LC8/kYesZQOQYQx9X9RDewurhSgCk8hOaVNhxzXVC+nSO
        7IViV8GgubEILjRSAD0WpdYGrzQCq0oyaY8C58B4jZfabDntJ3Bgkur8ivD/SW+X
        g0IzzdzcUMnYYfdRQPqNiWJo9uHfK0i3dl8uy7mxIw3Hj56kh7wqGh9h1nYpaKri
        izkSqQyLhFoq4yt9z0dCrC7rCKLHLDA1G+MZpAPBlXppyrG17MeeUIQcrRAFJq/u
        fVXfQtTWLlMPRXhktgY4w9BJKqimG2jL8Ax35dHwW78GaScamlP39Rgu3XNGGyCs
        Y6kxwK6DC5tpeT9xyrrbszqJKPZy/vVyB0wY+BTnQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

Hi all,

With Matthew's huge pagecache page patches merged, we are able to handle any
size pagecache pages, but currently split_huge_page can only split a huge p=
age
to order-0 pages. This can easily erase the benefit of having huge pagecache
pages, when operations like truncate might want to keep pages larger than
order-0. In response, here is the patches to add support for splitting a hu=
ge
page to any lower order pages.

The patchset is on top of mmotm-2022-03-16-17-42.

* Patch 1 and 2 add new_order parameter split_page_memcg() and
  split_page_owner() and prepare for upcoming changes.
* Patch 3 adds split_huge_page_to_list_to_order() to split a huge page
  to any lower order. The original split_huge_page_to_list() calls
  split_huge_page_to_list_to_order() with new_order =3D 0.
* Patch 4 uses split_huge_page_to_list_to_order() in huge pagecache page
  truncation instead of split the huge page all the way down to order-0.
* Patch 5 adds a test API to debugfs and test cases in
  split_huge_page_test selftests.

Comments and/or suggestions are welcome.

Zi Yan (5):
  mm: memcg: make memcg huge page split support any order split.
  mm: page_owner: add support for splitting to any order in split
    page_owner.
  mm: thp: split huge page to any lower order pages.
  mm: truncate: split huge page cache page to a non-zero order if
    possible.
  mm: huge_memory: enable debugfs to split huge pages to any order.

 include/linux/huge_mm.h                       |   8 +
 include/linux/memcontrol.h                    |   2 +-
 include/linux/page_owner.h                    |  12 +-
 mm/huge_memory.c                              | 139 +++++++----
 mm/memcontrol.c                               |  10 +-
 mm/page_alloc.c                               |   4 +-
 mm/page_owner.c                               |  13 +-
 mm/truncate.c                                 |  33 ++-
 .../selftests/vm/split_huge_page_test.c       | 219 +++++++++++++++---
 9 files changed, 347 insertions(+), 93 deletions(-)

--=20
2.35.1

