From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v20 05/20] mm/thp: Simplify lru_add_page_tail()
Date: Thu, 29 Oct 2020 10:00:20 -0400
Message-ID: <20201029140020.GF599825@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-6-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7lEvOV/HbcXu0PIxvGw2SLLt11jclvnvIAXpPg76WxU=;
        b=rSU47uiN+XY2DRlhPzcq7v3YHqplBYOB704H2vL/6EQS4gR1nu2YF0tQlpFXM42713
         yrahp6CxpAQIS8TroyeGlfDKA/pr43mbGZP9oDd5M6l+D/oAqhYPBYXjXrrENK692Arp
         bnWtQ6za577s/l7Q5EnfMS5ZqHUJGgec+jX1GHu3KXuVe1wF/TUg56hZvEjzlMznn7yp
         +TQXPOZExcoFGZSHf/DmCHrgf2QoYaQ3XEQMunoriLbnJydl+ePxI2MHyRETfRoOiRxn
         /iWEftMTCrfnResNfZnGKtPARBxXPEMrQdrejIfFHSnF9dGNMJF33nSuTu+G4qLqSscq
         udoA==
Content-Disposition: inline
In-Reply-To: <1603968305-8026-6-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>

On Thu, Oct 29, 2020 at 06:44:50PM +0800, Alex Shi wrote:
> Simplify lru_add_page_tail(), there are actually only two cases possible:
> split_huge_page_to_list(), with list supplied and head isolated from lru
> by its caller; or split_huge_page(), with NULL list and head on lru -
> because when head is racily isolated from lru, the isolator's reference
> will stop the split from getting any further than its page_ref_freeze().
>=20
> So decide between the two cases by "list", but add VM_WARN_ON()s to
> verify that they match our lru expectations.
>=20
> [Hugh Dickins: rewrite commit log]
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Mika Penttil=E4 <mika.penttila@nextfour.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
