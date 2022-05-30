From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Mon, 30 May 2022 14:17:11 -0700
Message-ID: <20220530141711.6cf70dcf200e28aa40407f6e@linux-foundation.org>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653945432;
        bh=aXsj1AN3iBU3BXc0wD+tbUHvcr/SpDhRS0i5ip2Fcl8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q3B/aOrqXsxw/hc5+6ZVsej/3uJqaMiGaW+7fR+NImiQeu4ORuUaQQE8mOE9NDECH
         lxW5h+8c7Rqvbtz53LzjdCSZ9LK4CMcNT8D5zIlUOxI2ybjChjYcFYfpFtbYpQYSJn
         Gyi9yVtiJxVuHdQBYMqy4NfacbOFu1m7vQ/NURxw=
In-Reply-To: <20220530074919.46352-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Muchun Song <songmuchun@bytedance.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com, longman@redhat.com

On Mon, 30 May 2022 15:49:08 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> This version is rebased on v5.18.

Not a great choice of base, really.  mm-stable or mm-unstable or
linux-next or even linus-of-the-day are all much more up to date.

Although the memcg reviewer tags are pretty thin, I was going to give
it a run.  But after fixing a bunch of conflicts I got about halfway
through then gave up on a big snarl in get_obj_cgroup_from_current().

> RFC v1: https://lore.kernel.org/all/20210330101531.82752-1-songmuchun@bytedance.com/

Surprising, that was over a year ago.  Why has is taken so long?

