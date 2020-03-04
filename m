From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v9 04/20] mm/thp: move lru_add_page_tail func to
 huge_memory.c
Date: Wed, 4 Mar 2020 10:47:19 +0300
Message-ID: <20200304074719.e6unbgdop2r3jhk2@box>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
 <1583146830-169516-5-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=90yR+U0yyx88muPof9ELq5RmjD8lTcfReEz4WNGCuAs=;
        b=J+9ttkkL3U2tfSixpLp40ZevGJY6w7+oKgo008s4LmmMoFaX+aoXETJoaT3XHhKDxJ
         O99zq+b1QV2fGPwaPM77i9ENNzpQtrCIRt5R21GLOLzITiMTWACJMz8qhybe6oOkE8up
         TbA8azSnt3BipfJBXIH3cuIX5SlSCjH2aCtokjd4WKtCcXzp4Lp7lexqYWRUTZ9T3syY
         lVJ7kMvEepib4Y7C55YIt9sc7BcTRMqQnwgBEkyT+HQIBDXBZj427rqWevhU/LgSowOt
         P4Ou049Cmky7WSmt5pj8TZP7cNAKUECUqOKtPEPKf8f1NgZn3PuZsvxevrcgxVbZGCJ/
         cTvA==
Content-Disposition: inline
In-Reply-To: <1583146830-169516-5-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Mon, Mar 02, 2020 at 07:00:14PM +0800, Alex Shi wrote:
> The func is only used in huge_memory.c, defining it in other file with a
> CONFIG_TRANSPARENT_HUGEPAGE macro restrict just looks weird.
> 
> Let's move it close user.

I don't think it's strong enough justification. I would rather keep all
lru helpers in one place.

-- 
 Kirill A. Shutemov
