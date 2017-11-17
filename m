From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm/shmem: set default tmpfs size according to memcg limit
Date: Fri, 17 Nov 2017 15:55:16 +0000
Message-ID: <20171117155509.GA920@castle>
References: <1510888199-5886-1-git-send-email-laoar.shao@gmail.com>
 <CALvZod7AY=J3i0NL-VuWWOxjdVmWh7VnpcQhdx7+Jt-Hnqrk+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=BWTdkExsIfW5OXX7ejrEsjveBvzIvfYW4WKn3itSu60=;
 b=Ph3ov8kJHEqxv3gHaQNW7lzqmLCruD4UNnP10YkgZMjrd4dU0eY5lpoQvnUUffC8nQFe
 VQsMGodO3fKPqfeUY2XrRTrT3j4E344BsKqQwt8ezr/HB2iZ9/PTZsSf4Gze6Rsxf0gG
 mXfjoobxASbwrRdalUlEomcFpVqwsrVoCps= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BWTdkExsIfW5OXX7ejrEsjveBvzIvfYW4WKn3itSu60=;
 b=dMkXx7UOFFUjw5APUdbneaS5irH/P16HowuexDNqBx0xhzgQyHvX+8ZG+O21zAdLrDg9vePUfM6MGL/Fl/1pAgbtVd8gwYQ4elPUW+Mx8bmhbRumrmfDPaXYoFVXWchJ8lenipm04kdeA7Q0cxaxm/TwyjWF/RwANHXXEjZlpMQ=
Content-Disposition: inline
In-Reply-To: <CALvZod7AY=J3i0NL-VuWWOxjdVmWh7VnpcQhdx7+Jt-Hnqrk+g@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, khlebnikov@yandex-team.ru, mka@chromium.org, Hugh Dickins <hughd@google.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, Nov 16, 2017 at 08:43:17PM -0800, Shakeel Butt wrote:
> On Thu, Nov 16, 2017 at 7:09 PM, Yafang Shao <laoar.shao@gmail.com> wrote:
> > Currently the default tmpfs size is totalram_pages / 2 if mount tmpfs
> > without "-o size=XXX".
> > When we mount tmpfs in a container(i.e. docker), it is also
> > totalram_pages / 2 regardless of the memory limit on this container.
> > That may easily cause OOM if tmpfs occupied too much memory when swap is
> > off.
> > So when we mount tmpfs in a memcg, the default size should be limited by
> > the memcg memory.limit.
> >
> 
> The pages of the tmpfs files are charged to the memcg of allocators
> which can be in memcg different from the memcg in which the mount
> operation happened. So, tying the size of a tmpfs mount where it was
> mounted does not make much sense.

Also, memory limit is adjustable, and using a particular limit value
at a moment of tmpfs mounting doesn't provide any warranties further.

Is there a reason why the userspace app which is mounting tmpfs can't
set the size based on memory.limit?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
