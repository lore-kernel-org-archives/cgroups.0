From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [PATCH v2] mm: memcg/slab: Fix return child memcg
 objcg for root memcg
Date: Fri, 30 Oct 2020 00:32:26 +0800
Message-ID: <CAMZfGtUCXAzvjQ60VUEdOj1OocqUxGNZkikr-Lch2w-dkmQTwg@mail.gmail.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com>
 <CALvZod6p_y2fTEK5fzAL=JfPsguqYbttgWC4_GPc=rF1PsN6TQ@mail.gmail.com>
 <CAMZfGtW38sFcdpnx3Xx+RgRL37WzpQsq8qvfdnmhbh4H9Ex0cg@mail.gmail.com> <CALvZod68HooK_bnaxFLEBL_neVybVRECkHJyb6r8LHWqwTOe5Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CNp60uz7U6o1WyBX9AAMogQVRcPxcfAiqCLR+bSZ8wY=;
        b=f6D+/uNPO6HW47eS+XdsuzOWR1OMKIbf1tDWGNa/eHlbdNS1fFyq73++vFXANcz6x2
         ytHLCE17oAxpQhTZeiOQrmqhH4JsQDnMKEzIq5jZmBroArNr7f6GsZp52FWH2KkhY3sM
         H8KsLn2uIX0lXXKFtXSbrA4roiZkm9N/rx+aLZ7Z/aAg0vhgc/QNYZtvX+naxEa054tr
         J0G6xItBIlWQ5zhq1bPzfF1wq31Xu/yYiQL3OtYyEzqwyevlKs28VqyQLH4Vw4YcJ7ti
         8EQJyl5qnkFrglTZQ6jMXOEWKksSQAolyC8ztjX4eIQqPqjYVEB+NEeUU6DztL2Vnx9B
         0Pjg==
In-Reply-To: <CALvZod68HooK_bnaxFLEBL_neVybVRECkHJyb6r8LHWqwTOe5Q@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Yafang Shao <laoar.shao@gmail.com>, Chris Down <chris@chrisdown.name>, Christian Brauner <christian.brauner@ubuntu.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, Suren Baghdasaryan <surenb@google.com>, areber@redhat.com, Marco Elver <elver@google.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On Fri, Oct 30, 2020 at 12:18 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Thu, Oct 29, 2020 at 9:09 AM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > On Thu, Oct 29, 2020 at 11:48 PM Shakeel Butt <shakeelb@google.com> wrote:
> > >
> > > On Tue, Oct 27, 2020 at 8:50 PM Muchun Song <songmuchun@bytedance.com> wrote:
> > > >
> > > > Consider the following memcg hierarchy.
> > > >
> > > >                     root
> > > >                    /    \
> > > >                   A      B
> > > >
> > > > If we get the objcg of memcg A failed,
> > >
> > > Please fix the above statement.
> >
> > Sorry, could you be more specific, I don't quite understand.
>
> Fix the grammar. Something like "If we failed to get the reference on
> objcg of memcg A..."

Got it. Sorry for my poor English, Thanks.

-- 
Yours,
Muchun
