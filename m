From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3 0/4] Change the return value for page isolation functions
Date: Wed, 15 Feb 2023 12:14:27 -0800
Message-ID: <CAHk-=wjG+MD3JBJ1qN8tD_di9K+kV0_PSe+DE9MRGd8Vco9CNA@mail.gmail.com>
References: <cover.1676424378.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PGQ2Tjph2raaiJJrHEWHFU5AYzV1uv01WttFdbl8X1E=;
        b=V4bh0Fv36Oc96JTrtwDRSTpRRhi4LZ/kX4qEbvP6JqRfZk1/DM5jUVx5Kyj39yoIhi
         aq33fcQOTI5PPoku2ND7mukiujbjW4a1bQG4ZzuMpv6Onpj3W8XzL9y6VaGZ/XlDqAxd
         MWIEni88bTVGzfFSjBMo33x9Bj5G7hovJOQRw=
In-Reply-To: <cover.1676424378.git.baolin.wang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, sj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, naoya.horiguchi@nec.com, linmiaohe@huawei.com, david@redhat.com, osalvador@suse.de, mike.kravetz@oracle.com, willy@infradead.org, damon@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

This v3 series looks like it's making things more readable, so ack as
far as I'm concerned.

But it looks like it's firmly in the "Andrew's mm tree" category, so
I'll leave it up to him to decide.

                   Linus
