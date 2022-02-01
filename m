From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 3/3] mm/page_owner: Dump memcg information
Date: Tue, 1 Feb 2022 11:41:19 -0500
Message-ID: <268a8bdf-4c70-b967-f34c-2293b54186f0@redhat.com>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-4-longman@redhat.com>
 <YfeuK5j7cbgM+Oo+@dhcp22.suse.cz> <YfgT/9tEREQNiiAN@cmpxchg.org>
 <YfgnUZQBRkqhrEIb@carbon.dhcp.thefacebook.com>
 <Yfgpknwr1tMnPkqh@dhcp22.suse.cz>
 <12686956-612d-d89b-5641-470d5e913090@redhat.com>
 <YfkQJ4QhfY0dICB9@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643733687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PC8NZ8lG/hbKxyQngU3kWuHlJ5Tl5ht+lJl5+tMvXcM=;
        b=B7hNIJLRf1rknpzQE3GYo2p6w/JVO5Gl7gLZ355ox5uncd+RTUsnfsqQsWhXMVx6gUlYQ8
        LTGaiG5+tufi9/5kYjuSgTGAS9Kq/2/Vw6gAMXKAyQ85dtabgs6Y76sGjRcd3VdKzXaBbu
        qvsU9Jr/tlMahM7HCVb3E1Q3SwH4o04=
Content-Language: en-US
In-Reply-To: <YfkQJ4QhfY0dICB9@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Rafael Aquini <aquini@redhat.com>


On 2/1/22 05:49, Michal Hocko wrote:
> On Mon 31-01-22 13:38:28, Waiman Long wrote:
> [...]
>> Of course, it is also possible to have a debugfs interface to list those
>> dead memcg information, displaying more information about the page that pins
>> the memcg will be hard without using the page owner tool.
> Yes, you will need page owner or hook into the kernel by other means
> (like already mentioned drgn). The question is whether scanning all
> existing pages to get that information is the best we can offer.
The page_owner tool records the page information at allocation time. 
There are some slight performance overhead, but it is the memory 
overhead that is the major drawback of this approach as we need one 
page_owner structure for each physical page. Page scanning is only done 
when users read the page_owner debugfs file. Yes, I agree that scanning 
all the pages is not the most efficient way to get these dead memcg 
information, but it is what the page_owner tool does. I would argue that 
this is the most efficient coding-wise to get this information.
>> Keeping track of
>> the list of dead memcg's may also have some runtime overhead.
> Could you be more specific? Offlined memcgs are still part of the
> hierarchy IIRC. So it shouldn't be much more than iterating the whole
> cgroup tree and collect interesting data about dead cgroups.

What I mean is that without piggybacking on top of page_owner, we will 
to add a lot more code to collect and display those information which 
may have some overhead of its own.

Cheers,
Longman

