From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v4 2/4] mm/page_owner: Use scnprintf() to avoid excessive
 buffer overrun check
Date: Tue, 8 Feb 2022 11:51:42 +0100
Message-ID: <YgJLPpUqkTaA298Y@alley>
References: <20220131192308.608837-5-longman@redhat.com>
 <20220202203036.744010-3-longman@redhat.com>
 <5c03fa31-35a5-4cbc-6b0e-872d5db82a41@suse.cz>
 <42cca916-d4c8-daa1-4a91-60738c499c89@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644317503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xfvi4t6v0E3o8m/BrX7OSyshdoPR/okbuDAi6c9K9Rc=;
        b=By/NatfU9q5/32V4vpdjlTTwvMuHnRPEfjJni8g4r2EgT6xLl48+zn+/fJ0VU9xgEr9zWa
        HW1oGFPuTLIoHd7m+IShMeqYSY+XUU/aeUGXBT7k6ly/qyW/AEaS0oJmdcMw4fMrG/xB0W
        iJ9ZbifzVS3EPlo+CS0nhO3K00YBGWc=
Content-Disposition: inline
In-Reply-To: <42cca916-d4c8-daa1-4a91-60738c499c89@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Mike Rapoport <rppt@kernel.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <guro@fb.com>, Rafael Aquini <aquini@redhat.com>

On Thu 2022-02-03 13:49:02, Waiman Long wrote:
> On 2/3/22 10:46, Vlastimil Babka wrote:
> > On 2/2/22 21:30, Waiman Long wrote:
> > > The snprintf() function can return a length greater than the given
> > > input size. That will require a check for buffer overrun after each
> > > invocation of snprintf(). scnprintf(), on the other hand, will never
> > > return a greater length. By using scnprintf() in selected places, we
> > > can avoid some buffer overrun checks except after stack_depot_snprint()
> > > and after the last snprintf().
> > > 
> > > Signed-off-by: Waiman Long <longman@redhat.com>
> > > Acked-by: David Rientjes <rientjes@google.com>
> > > Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Looks like this will work, but note that if the purpose of patch 1/4 was
> > that after the first scnprintf() that overflows the following calls will be
> > short-cut thanks to passing the size as 0, AFAICS that won't work. Because
> > scnprintf() returns the number without trailing zero, 'ret' will be 'count -
> > 1' after the overflow, so 'count - ret' will be 1, never 0.
> 
> Yes, I am aware of that. Patch 1 is just a micro-optimization for the very
> rare case.

In theory, we might micro-optimize also the case when "size == 1".

Well, I am not sure if it is worth it. After all, the primary use-case
is to print the message into a big-enough buffer. Lost information is
a bigger problem than the speed ;-)

Best Regards,
Petr
