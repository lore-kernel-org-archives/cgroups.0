From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v4 1/4] lib/vsprintf: Avoid redundant work with 0 size
Date: Tue, 8 Feb 2022 11:08:18 +0100
Message-ID: <YgJBEgYUuu/b8ZER@alley>
References: <20220131192308.608837-5-longman@redhat.com>
 <20220202203036.744010-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644314900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ePNInOzC6B5yJASGd/cwztAJV06U48l5tV+fyrVP+Cs=;
        b=UUqjWtY9SCXAhFmVatTniPu2rGbqj9soOjeMqZZUKgqY0wGYEx99UAcgCBeWBfXuqinAUR
        CuI6xMeqwBDeZyaUWLf68hyGwMFwu0aZZSiHHYuq5MyqmyaTx8PSttFuah16OymkTYBciv
        2ub3JHIEYPTnLJ9em/aYA989OP2dRbY=
Content-Disposition: inline
In-Reply-To: <20220202203036.744010-2-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Mike Rapoport <rppt@kernel.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <guro@fb.com>, Rafael Aquini <aquini@redhat.com>

On Wed 2022-02-02 15:30:33, Waiman Long wrote:
> For *scnprintf(), vsnprintf() is always called even if the input size is
> 0. That is a waste of time, so just return 0 in this case.
> 
> Note that vsnprintf() will never return -1 to indicate an error. So
> skipping the call to vsnprintf() when size is 0 will have no functional
> impact at all.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Acked-by: Roman Gushchin <guro@fb.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
