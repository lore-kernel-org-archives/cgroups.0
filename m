From: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Subject: [PATCH 0/5] mm: Some .text savings
Date: Tue,  3 Feb 2015 00:50:11 +0100
Message-ID: <1422921016-27618-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zJT473c2NrEJWcJe5nFTvTLWRtOueBweDpdqvjAVoEs=;
        b=Keq6Gex4d07cSpYvYzGf9U/4NYi4VukhkNzJ/Gj7UrYRg0vomvF5S0hbHnIp/J3x/X
         TACrDa2FV7ALAenjjISLnshpJESVJ112p7WAj5aUUctY5RP+y9dCiTGAnWQAjh2TGTyT
         t1UI/a4xWKy/VK680SRAa2+qk97hNaEV++vvg=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Only compile-tested, but I think these should be ok. Net saving aroung
450 bytes of .text.

Rasmus Villemoes (5):
  mm/internal.h: Don't split printk call in two
  mm/page_alloc.c: Pull out init code from build_all_zonelists
  mm/mm_init.c: Mark mminit_verify_zonelist as __init
  mm/mm_init.c: Mark mminit_loglevel __meminitdata
  kernel/cpuset.c: Mark cpuset_init_current_mems_allowed as __init

 kernel/cpuset.c |  2 +-
 mm/internal.h   |  6 ++++--
 mm/mm_init.c    |  4 ++--
 mm/page_alloc.c | 17 ++++++++++++++---
 4 files changed, 21 insertions(+), 8 deletions(-)

-- 
2.1.3
