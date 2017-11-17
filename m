From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm/shmem: set default tmpfs size according to memcg limit
Date: Fri, 17 Nov 2017 16:45:48 +0000
Message-ID: <20171117164531.GA23745@castle>
References: <1510888199-5886-1-git-send-email-laoar.shao@gmail.com>
 <CALvZod7AY=J3i0NL-VuWWOxjdVmWh7VnpcQhdx7+Jt-Hnqrk+g@mail.gmail.com>
 <20171117155509.GA920@castle>
 <CALOAHbAWvYKve4eB9+zissgi24cNKeFih1=avfSi_dH5upQVOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=XAkyKyCW/kChb+IycSS2zaJhl2Y32I1nwASlOuJAiYc=;
 b=gClfWQcLpW4em1x/f+c7uRyHssWyZXxj+gcrKUruu0+qsfHV85WKbC4nX87qMNyrs/lV
 EOhKWYGKGGwm6zqXTuDfaMhslYrbjAxKTdZS7qDTSXRT6rwMFkBHkwfBe+NInmQorymP
 S4CpfG2/hloboMufwMpqUqtiN77rIk8g2Yg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XAkyKyCW/kChb+IycSS2zaJhl2Y32I1nwASlOuJAiYc=;
 b=jqo0ErmMWogqOpQUbXypVYJvvFy1ItWnbT/L8rjF6jCQBpCPDoZOidOThW+HKQb/xIFwfPyrVW4q7HLv8bootpTOltLvIirx2rB+ekEd7P76wkT2aluLgtNCWtg7/CVxcVhAwrZIHwZzydcaedUbtRff7y5CigE0AWDEgr8axaI=
Content-Disposition: inline
In-Reply-To: <CALOAHbAWvYKve4eB9+zissgi24cNKeFih1=avfSi_dH5upQVOg@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, khlebnikov@yandex-team.ru, mka@chromium.org, Hugh Dickins <hughd@google.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Sat, Nov 18, 2017 at 12:20:40AM +0800, Yafang Shao wrote:
> 2017-11-17 23:55 GMT+08:00 Roman Gushchin <guro@fb.com>:
> > On Thu, Nov 16, 2017 at 08:43:17PM -0800, Shakeel Butt wrote:
> >> On Thu, Nov 16, 2017 at 7:09 PM, Yafang Shao <laoar.shao@gmail.com> wrote:
> >> > Currently the default tmpfs size is totalram_pages / 2 if mount tmpfs
> >> > without "-o size=XXX".
> >> > When we mount tmpfs in a container(i.e. docker), it is also
> >> > totalram_pages / 2 regardless of the memory limit on this container.
> >> > That may easily cause OOM if tmpfs occupied too much memory when swap is
> >> > off.
> >> > So when we mount tmpfs in a memcg, the default size should be limited by
> >> > the memcg memory.limit.
> >> >
> >>
> >> The pages of the tmpfs files are charged to the memcg of allocators
> >> which can be in memcg different from the memcg in which the mount
> >> operation happened. So, tying the size of a tmpfs mount where it was
> >> mounted does not make much sense.
> >
> > Also, memory limit is adjustable,
> 
> Yes. But that's irrelevant.
> 
> > and using a particular limit value
> > at a moment of tmpfs mounting doesn't provide any warranties further.
> >
> 
> I can not agree.
> The default size of tmpfs is totalram / 2, the reason we do this is to
> provide any warranties further IMHO.
> 
> > Is there a reason why the userspace app which is mounting tmpfs can't
> > set the size based on memory.limit?
> 
> That's because of misuse.
> The application should set size with "-o size=" when mount tmpfs, but
> not all applications do this.
> As we can't guarantee that all applications will do this, we should
> give them a proper default value.

The value you're suggesting is proper only if an app which is mounting
tmpfs resides in the same memcg and the memory limit will not be adjusted
significantly later. Otherwise you can end up with a default value, which
is worse than totalram/2, for instance, if tmpfs is mounted by some helper,
which is located in a separate and very limited memcg.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
