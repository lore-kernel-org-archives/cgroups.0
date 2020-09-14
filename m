From: Michal Hocko <mhocko@suse.com>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: Fix out-of-bounds on the
 buf returned by memory_stat_format
Date: Mon, 14 Sep 2020 13:57:24 +0200
Message-ID: <20200914115724.GO16999@dhcp22.suse.cz>
References: <20200912155100.25578-1-songmuchun@bytedance.com>
 <20200912174241.eeaa771755915f27babf9322@linux-foundation.org>
 <CAMZfGtXNg31+8QLbUMj7f61Yg1Jgt0rPB7VTDE7qoopGCANGjA@mail.gmail.com>
 <20200914091844.GE16999@dhcp22.suse.cz>
 <CAMZfGtXd3DNrW5BPjDosHsz-FUYACGZEOAfAYLwyHdRSpOsqhQ@mail.gmail.com>
 <20200914103205.GI16999@dhcp22.suse.cz>
 <CAMZfGtWBSCFWw7QN66-ZLTb8oT7UALkyaGONjcjB93DyeeXXTA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMZfGtWBSCFWw7QN66-ZLTb8oT7UALkyaGONjcjB93DyeeXXTA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Mon 14-09-20 19:46:36, Muchun Song wrote:
> On Mon, Sep 14, 2020 at 6:32 PM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Mon 14-09-20 17:43:42, Muchun Song wrote:
> > > On Mon, Sep 14, 2020 at 5:18 PM Michal Hocko <mhocko@suse.com> wrote:
> > > >
> > > > On Mon 14-09-20 12:02:33, Muchun Song wrote:
> > > > > On Sun, Sep 13, 2020 at 8:42 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > >
> > > > > > On Sat, 12 Sep 2020 23:51:00 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
> > > > > >
> > > > > > > The memory_stat_format() returns a format string, but the return buf
> > > > > > > may not including the trailing '\0'. So the users may read the buf
> > > > > > > out of bounds.
> > > > > >
> > > > > > That sounds serious.  Is a cc:stable appropriate?
> > > > > >
> > > > >
> > > > > Yeah, I think we should cc:stable.
> > > >
> > > > Is this a real problem? The buffer should contain 36 lines which makes
> > > > it more than 100B per line. I strongly suspect we are not able to use
> > > > that storage up.
> > >
> > > Before memory_stat_format() return, we should call seq_buf_putc(&s, '\0').
> > > Otherwise, the return buf string has no trailing null('\0'). But users treat buf
> > > as a string(and read the string oob). It is wrong. Thanks.
> >
> > I am not sure I follow you. vsnprintf which is used by seq_printf will
> > add \0 if there is a room for that. And I argue there is a lot of room
> > in the buffer so a corner case where the buffer gets full doesn't happen
> > with the current code.
> 
> Thanks for your explanation. Yeah, seq_printf will add \0 if there is a
> room for that. So I agree with you that the "Fixes" tag is wrong. There
> is nothing to fix. Sorry for the noise.
> 
> I think that if someone uses seq_buf_putc(maybe in the feature) at the
> end of memory_stat_format(). It will break the rule and there is no \0.
> So this patch can just make the code robust but need to change the
> commit log and remove the Fixes tag.

Please see my other reply. Adding \0 is not really sufficient. If we
want to have a robust code to handle the small buffer then we need to
make sure that all counters will make it to the userspace. Short output
is simply a broken result. Implementing this properly is certainly
possible, the question is whether this is worth addressing. It is not
like we are adding a lot of output into this file and it is quite likely
that the code is good as it is.
-- 
Michal Hocko
SUSE Labs
