From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: upstream boot error: WARNING in mem_cgroup_css_alloc
Date: Thu, 13 Aug 2020 11:26:34 -0400
Message-ID: <20200813152634.GB701678@cmpxchg.org>
References: <00000000000019317f05acbf31bd@google.com>
 <20200813104416.GE9477@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G9xj0y6YeO21IlkG6XCM+8OPoUpTIPBGk2H9BHdLfSg=;
        b=HG4WQqEJcLlVKhUoZ+ZzL2ku31xqzCdktta2BUIcGHOHeXS2x+Z+bpSKozf/uKsSU6
         nH7FjwY8wREbLLxUQ0XutkdGbEKbrqq2maifB1FgpRjn0gi4ASzmNZTkeAoeONFbjGSK
         AMrXPvoE5cT0o0gmAciyEZSK5xawGLw+Qq7J6orOfK2N8RSPMApEKs3SQ6RnOIxcXOPO
         yJESYqBLxp2AeIhjY9Khe6Xzs/ORGoGruEctyh3JEfGl8DGxJk/Xe6vxtlES6FOFF7uD
         7L6Df9CYLSzw/igPnf62aobisTPa7qmceeUvn5HRLK8QZwqNHxCHgcSZtMeO6prczf3v
         GFJQ==
Content-Disposition: inline
In-Reply-To: <20200813104416.GE9477@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: syzbot <syzbot+35d35ef677516d65bdda@syzkaller.appspotmail.com>, Roman Gushchin <guro@fb.com>, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

On Thu, Aug 13, 2020 at 12:44:16PM +0200, Michal Hocko wrote:
> This smells like 3e38e0aaca9e ("mm: memcg: charge memcg percpu memory to
> the parent cgroup").

I just replied to the other thread on this issue here:

https://lore.kernel.org/lkml/20200813152033.GA701678@cmpxchg.org/
