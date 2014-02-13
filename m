From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/2] cgroup: bring back kill_cnt to order css
 destruction
Date: Wed, 12 Feb 2014 16:38:25 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1402121636290.5728@eggly.anvils>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils> <20140207164321.GE6963@cmpxchg.org> <alpine.LSU.2.11.1402121417230.5029@eggly.anvils> <alpine.LSU.2.11.1402121504150.5029@eggly.anvils> <20140213002853.GC2916@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=RQBE9byUU74N/uyWGwa8yXi3aenunHpYkvD0w+Tktcs=;
        b=e2ifjUQzDPrvU0eeYpZBQj0a3cy6XOcn2ecgwnAdQ7QQiuGmypbw85ghq2uMTJA9BE
         IGsja6n5Y/+o9lMLO/bSJvo3k8lUZe4q3wcD6xhyUka5X+fQT7T/eKO856/MjVPEndw9
         9hYA8pjwRAwPs1ZqC8X12BqNx8o7K80TsgF+lFDY9o1S1h6e4i+0HxO0g0HxWhIsLwZs
         CxsMdBFq2YZ3QAseyGWusDZ7VG3+dLZ2AKsSzHDj11cQBxE4Kyg/s12NC/Rw1mmWS9+d
         qQsWfp4hBu/F5rsmjbSnWFJ8EMh4mxn1x7m45vGtuR8UkLyHdtnWopTpl9ulqI6w9vsi
         A+YQ==
In-Reply-To: <20140213002853.GC2916@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Filipe Brandenburger <filbranden@google.com>, Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, Markus Blank-Burian <burian@muenster.de>, Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Wed, 12 Feb 2014, Tejun Heo wrote:
> 
> Not that your implementation is bad or anything but the patch itself
> somehow makes me cringe a bit.  It's probably just because it has to
> add to the already overly complicated offline path.  Guaranteeing
> strict offline ordering might be a good idea but at least for the
> immediate bug fix, I agree that the memcg specific fix seems better
> suited.  Let's apply that one and reconsider this one if it turns out
> we do need strict offline reordering.

Yes, I agree completely - thanks.

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
