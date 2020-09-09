From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 31/32] mm: Add explicit page decrement in exception
 path for isolate_lru_pages
Date: Wed, 9 Sep 2020 14:05:20 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009091349100.9747@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <1598273705-69124-32-git-send-email-alex.shi@linux.alibaba.com> <20200909010118.GB6583@casper.infradead.org> <CAKgT0UcjNx=00OgAQNWezc7UjLmF2NcDH0p7kzZ5D23PaFrFXA@mail.gmail.com>
 <alpine.LSU.2.11.2009091100280.9020@eggly.anvils> <20200909201530.GM6583@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=jknzGmoqJw1EY5KNXFDJSNgXqjt2RuOtc/p1w7k0/AY=;
        b=qENp4mbYweCT8tAiqEN3O3TLh+thuG3dwWPJLgqJgRNAryhOqmBvIevkwDDtq/X+Cq
         IU2OoPp9i+zLhxB0W9Fliq1WToqWvbjwKfMcK+QyHwjV9Mj2DAFUOA/yqwhW7ZOJtXu/
         RwzgtlZTJIrzbFikLUMtDM+lR30uPVWwKKjYziRPi2gbMVfyaOvlu8i4qiJ92OCBrMvv
         4SOEUcUjqDmB42cQ3lWF+lINiNnPIcnQiNmmFVanyRhkZryZdbB3DQhd7yF9sCvlu1rZ
         vEhRhA1II2U3kVSRo3OH275fqPurXhxu3LWIjtb/aqeqWFFVpXs/RN9z9ZoE/mCEu44a
         s4XQ==
In-Reply-To: <20200909201530.GM6583-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev@gmail.c>

On Wed, 9 Sep 2020, Matthew Wilcox wrote:
> On Wed, Sep 09, 2020 at 11:24:14AM -0700, Hugh Dickins wrote:
> > After overnight reflection, my own preference would be simply to
> > drop this patch.  I think we are making altogether too much of a
> > fuss here over what was simply correct as plain put_page()
> > (and further from correct if we change it to leak the page in an
> > unforeseen circumstance).
> > 
> > And if Alex's comment was not quite grammatically correct, never mind,
> > it said as much as was worth saying.  I got more worried by his
> > placement of the "busy:" label, but that does appear to work correctly.
> > 
> > There's probably a thousand places where put_page() is used, where
> > it would be troublesome if it were the final put_page(): this one
> > bothered you because you'd been looking at isolate_migratepages_block(),
> > and its necessary avoidance of lru_lock recursion on put_page();
> > but let's just just leave this put_page() as is.
> 
> My problem with put_page() is that it's no longer the simple
> decrement-and-branch-to-slow-path-if-zero that it used to be.  It has the
> awful devmap excrement in it so it really expands into a lot of code.
> I really wish that "feature" could be backed out again.  It clearly
> wasn't ready for merge.

And I suppose I should thank you for opening my eyes to that.
I knew there was "dev" stuff inside __put_page(), but didn't
realize that the inline put_page() has now been defiled.
Yes, I agree, that is horrid and begs to be undone.

But this is not the mail thread for discussing that, and we should
not use strange alternatives to put_page(), here or elsewhere,
just to avoid that (surely? hopefully?) temporary excrescence.

Hugh
