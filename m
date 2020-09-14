From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: Fix out-of-bounds on the
 buf returned by memory_stat_format
Date: Mon, 14 Sep 2020 17:43:42 +0800
Message-ID: <CAMZfGtXd3DNrW5BPjDosHsz-FUYACGZEOAfAYLwyHdRSpOsqhQ@mail.gmail.com>
References: <20200912155100.25578-1-songmuchun@bytedance.com>
 <20200912174241.eeaa771755915f27babf9322@linux-foundation.org>
 <CAMZfGtXNg31+8QLbUMj7f61Yg1Jgt0rPB7VTDE7qoopGCANGjA@mail.gmail.com> <20200914091844.GE16999@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OGDsMtjT75Ugek6NrpYH7erjKE1iSP2qJww8COSquYg=;
        b=HhMdSpnkADQbF2sSvs3sIX8fhooLzGiLBz161wSqKDCUNcYonR4wNaLeWxZnCWXHaY
         rjpxg6mYbaTGCHJstqUMJnjKWERUBNehqsiRQaw6ft+IyndVXaUmEpljumQZINJq7P/u
         Lq6Sgw63X7gxlg2/d5Nrq8YkwmlT1u3NwckogBa9s1PUv5tvzoYfXjmT2BtxsvC1qIeL
         FOKcCh0i9AqESKney8bXcS+c7GdGeu5MiDtDERDa2wPyXcXEexz+P0r4OffDlM7z5cUv
         ZVrwVQrtZc4aRfUUDLyBdHxB9C9N/n4+bwwb2xspLrq8/TE5UJgjCN7NEiu6XSmzXCRR
         h/+Q==
In-Reply-To: <20200914091844.GE16999-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Sep 14, 2020 at 5:18 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 14-09-20 12:02:33, Muchun Song wrote:
> > On Sun, Sep 13, 2020 at 8:42 AM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > >
> > > On Sat, 12 Sep 2020 23:51:00 +0800 Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> > >
> > > > The memory_stat_format() returns a format string, but the return buf
> > > > may not including the trailing '\0'. So the users may read the buf
> > > > out of bounds.
> > >
> > > That sounds serious.  Is a cc:stable appropriate?
> > >
> >
> > Yeah, I think we should cc:stable.
>
> Is this a real problem? The buffer should contain 36 lines which makes
> it more than 100B per line. I strongly suspect we are not able to use
> that storage up.

Before memory_stat_format() return, we should call seq_buf_putc(&s, '\0').
Otherwise, the return buf string has no trailing null('\0'). But users treat buf
as a string(and read the string oob). It is wrong. Thanks.

> --
> Michal Hocko
> SUSE Labs



-- 
Yours,
Muchun
