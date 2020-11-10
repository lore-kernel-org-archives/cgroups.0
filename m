From: Roman Gushchin <guro@fb.com>
Subject: Re: [External] Re: [PATCH 4/5] mm: memcg/slab: Fix root memcg vmstats
Date: Mon, 9 Nov 2020 17:32:36 -0800
Message-ID: <20201110013236.GB2612097@carbon.dhcp.thefacebook.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
 <20201027080256.76497-5-songmuchun@bytedance.com>
 <20201027184835.GB827280@carbon.dhcp.thefacebook.com>
 <CAMZfGtU1aViokYk1hkHbYEiqW5QNi49UTd-QTrkycLqj6Q+-8g@mail.gmail.com>
 <20201029001408.GF827280@carbon.dhcp.thefacebook.com>
 <CAMZfGtW9wa=S7+OQw_R+4LU5VzcN0H0OUPw-2XfTAJFniQN3TA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=cCJ0/HQAoNBZeouMYSTI5E8ztU8ysZWj9Hljs5jus7w=;
 b=SJfauKtFjHsPzBdfj5C43dWLw61xffN1rgnGfAnLnq2oh854QXbBUQ3HmjDdMFIvTAOC
 TbFizYyJAEIcw526ZMd5t/d+/hTNycgMXKr3fcwzSvykmgIKpfwSO4l7twqih4T+QjOj
 00O0JclBDKCoTokftQgo0E86CKs35SVck2g= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCJ0/HQAoNBZeouMYSTI5E8ztU8ysZWj9Hljs5jus7w=;
 b=EKpf91nk5Zbc+st2+CvEAOMmqX80DMPiB6SrqYZtj8jwPTvhfHeiZUSS5gOPyGMl1TQLJrbuC30rH8mlsUvk3oKSPeZFxQqe0QC4EkNhUHX9W0AprxUHVluEOu8ivIqW+OFr608bT4ksH6S6F9U8QZndFX0dbon+Byqk+Ttaj3w=
Content-Disposition: inline
In-Reply-To: <CAMZfGtW9wa=S7+OQw_R+4LU5VzcN0H0OUPw-2XfTAJFniQN3TA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, laoar.shao@gmail.com, Chris Down <chris@chrisdown.name>, Christian Brauner <christian.brauner@ubuntu.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, Suren Baghdasaryan <surenb@google.com>, areber@redhat.com, Marco Elver <elver@google.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>

On Thu, Oct 29, 2020 at 02:15:43PM +0800, Muchun Song wrote:
> On Thu, Oct 29, 2020 at 8:14 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Wed, Oct 28, 2020 at 10:56:20AM +0800, Muchun Song wrote:
> > > On Wed, Oct 28, 2020 at 2:48 AM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > > > On Tue, Oct 27, 2020 at 04:02:55PM +0800, Muchun Song wrote:
> > > > > If we reparent the slab objects to the root memcg, when we free
> > > > > the slab object, we need to update the per-memcg vmstats to keep
> > > > > it correct for the root memcg. Now this at least affects the vmstat
> > > > > of NR_KERNEL_STACK_KB for !CONFIG_VMAP_STACK when the thread stack
> > > > > size is smaller than the PAGE_SIZE.
> > > > >
> > > > > Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
> > > > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > >
> > > > Can you, please, drop this patch for now?
> > > >
> > > > I'm working on a bigger cleanup related to the handling of the root memory
> > > > cgroup (I sent a link earlier in this thread), which already does a similar change.
> > > > There are several issues like this one, so it will be nice to fix them all at once.
> > >
> > > I have read the patch of https://lkml.org/lkml/2020/10/14/869. You
> > > mean this patch
> > > fixes this issue? It chooses to uncharge the root memcg. But here we may need to
> > > uncharge the root memcg to keep root vmstats correct. If we do not do
> > > this, we can
> > > see the wrong vmstats via root memory.stat(e.g. NR_KERNEL_STACK_KB).
> >
> > I pointed at a different patch in the same thread (it looks like you read the first one):
> > https://lkml.org/lkml/2020/10/21/612

Hi Muchun!

Can you please, resend your patch? The planned cleanup of the root memory cgroup
is more complex than expected, so I think it makes sense to merge your patch without
waiting for it. I'm sorry for delaying it initially.

Please, feel free to add
Acked-by: Roman Gushchin <guro@fb.com>

Thank you!

Roman
