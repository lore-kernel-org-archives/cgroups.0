From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Thu, 27 Aug 2020 00:01:00 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org> <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=dlLginyZpxCAkGKRMWKhKVlveqMIe3fj5HCC0Huvfao=;
        b=iTzlBDK5N3vB0kF0mheFhzDF2e7u55djSMT2skp+BdTo976XWc/TZRw+elYMkw+ThD
         xrMz1T2uj6T7cVjjPvp6ViASakvAdlKSJumMNJ7KzgC7zjBrlK1XlUw+4SEvs3m0byaj
         NIgxVuTZTlbifu/LYJseaO8d9o6Pg7fmw338E6SQUmE+CJ3LKfHJTb5bGYWLpsx76gH6
         OTCoNd52vkU+sscAfruhgy/dsQmR3rhtgPxNpJec5T/YFWRBM8QFWDnWX7FbNAcf3KUi
         uWrEOhYMNYmM1URuoxqtXIRn0+7yv8Kc0ScIGL7o9zhfK9Tecg+ZI9Ae+tegdhmuMcBL
         XVvg==
In-Reply-To: <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, mgorman@techsingularity.net, tj@kernel.org, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, cai@lca.pw

On Mon, 24 Aug 2020, Hugh Dickins wrote:
> On Mon, 24 Aug 2020, Andrew Morton wrote:
> > On Mon, 24 Aug 2020 20:54:33 +0800 Alex Shi <alex.shi@linux.alibaba.com> wrote:
> > 
> > > The new version which bases on v5.9-rc2.
> 
> Well timed and well based, thank you Alex.  Particulary helpful to me,
> to include those that already went into mmotm: it's a surer foundation
> to test on top of the -rc2 base.
> 
> > > the first 6 patches was picked into
> > > linux-mm, and add patch 25-32 that do some further post optimization.
> > 
> > 32 patches, version 18.  That's quite heroic.  I'm unsure whether I
> > should merge it up at this point - what do people think?
> 
> I'd love for it to go into mmotm - but not today.
> 
> Version 17 tested out well.  I've only just started testing version 18,
> but I'm afraid there's been a number of "improvements" in between,
> which show up as warnings (lots of VM_WARN_ON_ONCE_PAGE(!memcg) -
> I think one or more of those are already in mmotm and under discussion
> on the list, but I haven't read through yet, and I may have caught
> more cases to examine; a per-cpu warning from munlock_vma_page();

Alex already posted the fix for that one.

> something else flitted by at reboot time before I could read it).

That one still eludes me, but I'm not giving it high priority.

> No crashes so far, but I haven't got very far with it yet.
> 
> I'll report back later in the week.

Just a quick report for now: I have some fixes, not to Alex's patchset
itself, but to things it revealed - a couple of which I knew of already,
but better now be fixed.  Once I've fleshed those out with comments and
sent them in, I'll get down to review.

Testing held up very well, no other problems seen in the patchset,
and the 1/27 discovered something useful.

I was going to say, no crashes observed at all, but one did crash
this afternoon.  But like before, I think it's something unrelated
to Alex's work, just revealed now that I hammer harder on compaction
(knowing that to be the hardest test for per-memcg lru_lock).

It was a crash from checking PageWaiters on a Tail in wake_up_page(),
called from end_page_writeback(), from ext4_finish_bio(): yet the
page a tail of a shmem huge page.  Linus's wake_up_page_bit() changes?
No, I don't think so.  It seems to me that once end_page_writeback()
has done its test_clear_page_writeback(), it has no further hold on
the struct page, which could be reused as part of a compound page
by the time of wake_up_page()'s PageWaiters check.  But I probably
need to muse on that for longer.

(I'm also kind-of-worried because Alex's patchset should make no
functional difference, yet appears to fix some undebugged ZONE_DMA=y
slow leak of memory that's been plaguing my testing for months.
I mention that in case those vague words are enough to prompt an
idea from someone, but cannot afford to spend much time on it.)

Hugh
