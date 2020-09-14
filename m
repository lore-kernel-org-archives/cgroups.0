From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: Fix out-of-bounds on the
 buf returned by memory_stat_format
Date: Mon, 14 Sep 2020 20:05:03 +0800
Message-ID: <CAMZfGtUBAO8AApzuDZZviCUpPyy4-JTCpXTRSzimq=K9aG467g@mail.gmail.com>
References: <20200912155100.25578-1-songmuchun@bytedance.com>
 <20200912174241.eeaa771755915f27babf9322@linux-foundation.org>
 <CAMZfGtXNg31+8QLbUMj7f61Yg1Jgt0rPB7VTDE7qoopGCANGjA@mail.gmail.com>
 <20200914091844.GE16999@dhcp22.suse.cz> <CAMZfGtXd3DNrW5BPjDosHsz-FUYACGZEOAfAYLwyHdRSpOsqhQ@mail.gmail.com>
 <20200914103205.GI16999@dhcp22.suse.cz> <CAMZfGtWBSCFWw7QN66-ZLTb8oT7UALkyaGONjcjB93DyeeXXTA@mail.gmail.com>
 <20200914115724.GO16999@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GsOIVPKx7/GKwttOx4gkrBI8E8JMmQp3RWxUAc5wfcY=;
        b=G1oJRVfApka43Z3M51QifLTqy6wQ/iKgboQET0cTsUGhqa2VvUp8zDM8KlmGoMSTn2
         4Nrv8KQBR0s4z0UdeuHvXlON0PxsuBLT2bR5RsbPH5Ds+0mk4ZSITL47v4bUSSrYxRf+
         3JbtyFmqXOdHv5OcDFVVpHHmldqYsBpLMfDiqL+XHgcz8n+Rw6WA48PDWy7xI28TERZO
         OX3Ivrdkp571bX+Qwd4tBKr+MUvOr2dhIor2S9JPGrGrcy3jqr9YXy3I4nvalNuVLHrq
         pXLybs29hC36HQhOnDUctrx6f05OvpzbtddhDB62gOnd0DXz75rX20WGUGWvRC2TiNCL
         7h3g==
In-Reply-To: <20200914115724.GO16999-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Sep 14, 2020 at 7:57 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 14-09-20 19:46:36, Muchun Song wrote:
> > On Mon, Sep 14, 2020 at 6:32 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Mon 14-09-20 17:43:42, Muchun Song wrote:
> > > > On Mon, Sep 14, 2020 at 5:18 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > >
> > > > > On Mon 14-09-20 12:02:33, Muchun Song wrote:
> > > > > > On Sun, Sep 13, 2020 at 8:42 AM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > > > > > >
> > > > > > > On Sat, 12 Sep 2020 23:51:00 +0800 Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> > > > > > >
> > > > > > > > The memory_stat_format() returns a format string, but the return buf
> > > > > > > > may not including the trailing '\0'. So the users may read the buf
> > > > > > > > out of bounds.
> > > > > > >
> > > > > > > That sounds serious.  Is a cc:stable appropriate?
> > > > > > >
> > > > > >
> > > > > > Yeah, I think we should cc:stable.
> > > > >
> > > > > Is this a real problem? The buffer should contain 36 lines which makes
> > > > > it more than 100B per line. I strongly suspect we are not able to use
> > > > > that storage up.
> > > >
> > > > Before memory_stat_format() return, we should call seq_buf_putc(&s, '\0').
> > > > Otherwise, the return buf string has no trailing null('\0'). But users treat buf
> > > > as a string(and read the string oob). It is wrong. Thanks.
> > >
> > > I am not sure I follow you. vsnprintf which is used by seq_printf will
> > > add \0 if there is a room for that. And I argue there is a lot of room
> > > in the buffer so a corner case where the buffer gets full doesn't happen
> > > with the current code.
> >
> > Thanks for your explanation. Yeah, seq_printf will add \0 if there is a
> > room for that. So I agree with you that the "Fixes" tag is wrong. There
> > is nothing to fix. Sorry for the noise.
> >
> > I think that if someone uses seq_buf_putc(maybe in the feature) at the
> > end of memory_stat_format(). It will break the rule and there is no \0.
> > So this patch can just make the code robust but need to change the
> > commit log and remove the Fixes tag.
>
> Please see my other reply. Adding \0 is not really sufficient. If we
> want to have a robust code to handle the small buffer then we need to
> make sure that all counters will make it to the userspace. Short output
> is simply a broken result. Implementing this properly is certainly
> possible, the question is whether this is worth addressing. It is not
> like we are adding a lot of output into this file and it is quite likely
> that the code is good as it is.

Got it. Thanks.

> --
> Michal Hocko
> SUSE Labs



-- 
Yours,
Muchun
