From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: Fix out-of-bounds on the
 buf returned by memory_stat_format
Date: Mon, 14 Sep 2020 12:32:05 +0200
Message-ID: <20200914103205.GI16999@dhcp22.suse.cz>
References: <20200912155100.25578-1-songmuchun@bytedance.com>
 <20200912174241.eeaa771755915f27babf9322@linux-foundation.org>
 <CAMZfGtXNg31+8QLbUMj7f61Yg1Jgt0rPB7VTDE7qoopGCANGjA@mail.gmail.com>
 <20200914091844.GE16999@dhcp22.suse.cz>
 <CAMZfGtXd3DNrW5BPjDosHsz-FUYACGZEOAfAYLwyHdRSpOsqhQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMZfGtXd3DNrW5BPjDosHsz-FUYACGZEOAfAYLwyHdRSpOsqhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 14-09-20 17:43:42, Muchun Song wrote:
> On Mon, Sep 14, 2020 at 5:18 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Mon 14-09-20 12:02:33, Muchun Song wrote:
> > > On Sun, Sep 13, 2020 at 8:42 AM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > > >
> > > > On Sat, 12 Sep 2020 23:51:00 +0800 Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> > > >
> > > > > The memory_stat_format() returns a format string, but the return buf
> > > > > may not including the trailing '\0'. So the users may read the buf
> > > > > out of bounds.
> > > >
> > > > That sounds serious.  Is a cc:stable appropriate?
> > > >
> > >
> > > Yeah, I think we should cc:stable.
> >
> > Is this a real problem? The buffer should contain 36 lines which makes
> > it more than 100B per line. I strongly suspect we are not able to use
> > that storage up.
> 
> Before memory_stat_format() return, we should call seq_buf_putc(&s, '\0').
> Otherwise, the return buf string has no trailing null('\0'). But users treat buf
> as a string(and read the string oob). It is wrong. Thanks.

I am not sure I follow you. vsnprintf which is used by seq_printf will
add \0 if there is a room for that. And I argue there is a lot of room
in the buffer so a corner case where the buffer gets full doesn't happen
with the current code.
-- 
Michal Hocko
SUSE Labs
