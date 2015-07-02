From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 22/51] writeback: add {CONFIG|BDI_CAP|FS}_CGROUP_WRITEBACK
Date: Wed, 1 Jul 2015 21:10:56 -0400
Message-ID: <20150702011056.GC26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-23-git-send-email-tj@kernel.org>
 <20150630093751.GH7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QrlXM2R9juojSuaNJcMhj3+JnqEuSicFu3VKaQv+Gug=;
        b=XtfAz8od6Rfss1Qa9FFSBQ1Wlp0aUc/mI848CdMLHTMePPc3I8hhW6S43blo/R/PoC
         0Av4Ait95K4NYJiQilStqUfbc7+XwvXe2EHp4kP3XUG7Egw1aG0FWNG+KLsoq4RFvlK7
         L4NSNMZDS59UJvHpQQ3Nvl4H1Te6YLYTG0JdL9cmne9gIlIM8KcP08w7hbnKdXwZ6gsn
         HfGd8KxL7adn+LbkmUMDxo8nGj9xKHLuvSJN/RQloOjb+jCJAmZvUvzRKBSXi5DAdfsP
         x9MbxNqwHy8BkDBGu/xjnOMryPXcJeLj/3JIO77aH9Y/AacN41GTX/v675ehCZj+Gb60
         9Ktw==
Content-Disposition: inline
In-Reply-To: <20150630093751.GH7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello, Jan.

On Tue, Jun 30, 2015 at 11:37:51AM +0200, Jan Kara wrote:
> Hum, you later changed this to use a per-sb flag instead of a per-fs-type
> flag, right? We could do it as well here but OK.

The commits were already in stable branch at that point and landed in
mainline during this merge window, so I'm afraid the review points
will have to be addressed as additional patches.

> One more question - what does prevent us from supporting CGROUP_WRITEBACK
> for all bdis capable of writeback? I guess the reason is that currently
> blkcgs are bound to request_queue and we have to have blkcg(s) for
> CGROUP_WRITEBACK to work, am I right? But in principle tracking writeback
> state and doing writeback per memcg doesn't seem to be bound to any device
> properties so we could do that right?

The main issue is that cgroup should somehow know how the processes
are mapped to the underlying IO layer - the IO domain should somehow
be defined.  We can introduce an intermediate abstraction which maps
to blkcg and whatever other cgroup controllers which may define cgroup
IO domains but given that such cases would be fairly niche, I think
we'd be better off making those corner cases represent themselves
using blkcg rather than introducing an additional layer.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
