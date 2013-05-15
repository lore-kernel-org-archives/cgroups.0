From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH V2 0/3] memcg: simply lock of page stat accounting
Date: Wed, 15 May 2013 16:35:08 +0400
Message-ID: <519380FC.1040504@openvz.org>
References: <1368421410-4795-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=cfArMqbqEyWeQVebjOkQdlm3q5hPKKYkzRKWL8GFNaw=;
        b=dVs6f2fNae4E23D9PeCoE34dFrKC+GlkCj40EOxqAarB9TsHmRvL3h3Q4WPDpu4AhG
         C397ySm9mHDjBYOlGx9n7AZg4XPbF45WBIkyssH6wVcC8CG6wOM2I56hTITbxBvpaS3l
         EslM2HrytH6/u8+bF69WprXduaZ0CWTH2YEKs9xzVirStY95yFvv5rZWWlwHVufotWhO
         P5YFdT1GC8PNvFBTObmMWFXSXbZr4Staxy3oTYAP1YpGP5UK+BcjnGgWF82ShvRACPMY
         TVjK+RtSoyYbTz/LaXdKmeZgQA5yCp43rke+0qXW5ZZpSzw/g4GO2ZZJAPu7C0Si3/5a
         iC1A==
In-Reply-To: <1368421410-4795-1-git-send-email-handai.szj@taobao.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sha Zhengju <handai.szj@gmail.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, hughd@google.com, gthelen@google.com, Sha Zhengju <handai.szj@taobao.com>

Sha Zhengju wrote:
> Hi,
>
> This is my second attempt to make memcg page stat lock simpler, the
> first version: http://www.spinics.net/lists/linux-mm/msg50037.html.
>
> In this version I investigate the potential race conditions among
> page stat, move_account, charge, uncharge and try to prove it race
> safe of my proposing lock scheme. The first patch is the basis of
> the patchset, so if I've made some stupid mistake please do not
> hesitate to point it out.

I have a provocational question. Who needs these numbers? I mean per-cgroup
nr_mapped and so on. It's too hard to maintain them carefully and I don't know
any clear usage for them. I have written several implementations of this stuff
for openvz kernel. But at the end I have decided to just remove it.
Do anybody knows really useful use cases for these nr_mapped counters?


In our kernel we have per-container nr_dirty and nr_writeback counters. Bit they are
implemented on top of radix-tree tags, and their owners are stored on inode/mapping.
So, this is completely different story.

I definitely have missed some discussions about these questions. Or not?
I hope it's a good time to return.

>
> Change log:
> v2<- v1:
>     * rewrite comments on race condition
>     * split orignal large patch to two parts
>     * change too heavy try_get_mem_cgroup_from_page() to rcu_read_lock
>       to hold memcg alive
>
> Sha Zhengju (3):
>     memcg: rewrite the comment about race condition of page stat accounting
>     memcg: alter mem_cgroup_{update,inc,dec}_page_stat() args to memcg pointer
>     memcg: simplify lock of memcg page stat account	
>
>   include/linux/memcontrol.h |   14 ++++++-------
>   mm/memcontrol.c            |   16 ++++++---------
>   mm/rmap.c                  |   49 +++++++++++++++++++++++++++++++++-----------
>   3 files changed, 50 insertions(+), 29 deletions(-)
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
