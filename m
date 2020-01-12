From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [Patch v2] mm: thp: grab the lock before manipulation defer list
Date: Mon, 13 Jan 2020 01:57:18 +0300
Message-ID: <20200112225718.5vqzezfclacujyx3@box>
References: <20200109143054.13203-1-richardw.yang@linux.intel.com>
 <20200111000352.efy6krudecpshezh@box>
 <20200112022858.GA17733@richard>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YhEnPWc7hBMgzTi8jrnUahHh/j3JJLesjhzD86DLwCs=;
        b=17mnMprWe4+SB2cTaLQImgJbVUQMzsjRXuwdjTe6KETCHH94Zi6GGwUo5/WsHFRbJL
         /NAoOp0F4Dj8T562fMLT2GENv5UucZ+oCPCg5+TMX0LVwjxzaxeNMIfdloCgKwLQ6QYs
         +aw6FaoTAN1olVQlSVat6zHRBfOtwJH4EV0K9WdxN9TvaTkUxjahKqF3aEHkUp4DgWjE
         ISIP32ImjX7TZHNBYrb04W84s7tWZ6Sr56cznaStx43sgf33DhEwl8jkvJd2ZBZ8vHkN
         2Kck6f7sk1Y0y5vqhxkc+AODNs15YZjkIJf6xKEGBk1k6iBEWZkEVuqS6cyWL9xrpjCD
         7BWQ==
Content-Disposition: inline
In-Reply-To: <20200112022858.GA17733@richard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, alexander.duyck@gmail.com, rientjes@google.com

On Sun, Jan 12, 2020 at 10:28:58AM +0800, Wei Yang wrote:
> On Sat, Jan 11, 2020 at 03:03:52AM +0300, Kirill A. Shutemov wrote:
> >On Thu, Jan 09, 2020 at 10:30:54PM +0800, Wei Yang wrote:
> >> As all the other places, we grab the lock before manipulate the defer list.
> >> Current implementation may face a race condition.
> >> 
> >> For example, the potential race would be:
> >> 
> >>     CPU1                      CPU2
> >>     mem_cgroup_move_account   split_huge_page_to_list
> >>       !list_empty
> >>                                 lock
> >>                                 !list_empty
> >>                                 list_del
> >>                                 unlock
> >>       lock
> >>       # !list_empty might not hold anymore
> >>       list_del_init
> >>       unlock
> >
> >I don't think this particular race is possible. Both parties take page
> >lock before messing with deferred queue, but anytway:
> 
> I am afraid not. Page lock is per page, while defer queue is per pgdate or
> memcg.
> 
> It is possible two page in the same pgdate or memcg grab page lock
> respectively and then access the same defer queue concurrently.

Look closer on the list_empty() argument. It's list_head local to the
page. Too different pages can be handled in parallel without any problem
in this particular scenario. As long as we as we modify it under the lock.

Said that, page lock here was somewhat accidential and I still belive we
need to move the check under the lock anyway.

-- 
 Kirill A. Shutemov
