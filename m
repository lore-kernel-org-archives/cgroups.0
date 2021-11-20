From: Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v4 2/4] mm/oom: handle remote ooms
Date: Fri, 19 Nov 2021 21:31:34 -0800
Message-ID: <CAHS8izNJ7-7EKsfFancHw3iNJzBWdHT_GwcJUaMU1_2LQMwX9g@mail.gmail.com>
References: <20211120045011.3074840-1-almasrymina@google.com>
 <20211120045011.3074840-3-almasrymina@google.com> <YZiCgrTzcl/QQC+N@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vnmw4S1Oo24l/mBbjqvIPUjrCN4SWt+nkM7iPySscsw=;
        b=Is6GD84hBb9QY3j8VzxArUzIWg27YUxT7W2u8JsLG3BXkUJFEhtGH+/3LaqHJ5lj/u
         JzOdhu6c+qD1Xp46nfqUBMqM5YcXolH3Cm0gWBAhTvrL0U9Sok39SsnwM/M2fwM+giyC
         b2mttp9GnYCE5IXirYkv7ApZasb6lnRTh/4SvBkwmuuRhjox12DYv/wiXsJzFyxaUtGk
         uFkheaWF/Y6auNhbt4lN5qsa4bH56/C5qdfXXV9rqxo89VHFtgoxWLBWBqz2HwwYGX43
         ZM+LFt1omvXDOHm9TfIFtQhEIiZpdGzRiDJ/sbcSz0UqKLsNZpP+biDAuPXg8bW6HMzh
         5O2w==
In-Reply-To: <YZiCgrTzcl/QQC+N@casper.infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>, Shuah Khan <shuah@kernel.org>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Dave Chinner <david@fromorbit.com>, Roman Gushchin <guro@fb.com>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Fri, Nov 19, 2021 at 9:07 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Nov 19, 2021 at 08:50:08PM -0800, Mina Almasry wrote:
> > On remote ooms (OOMs due to remote charging), the oom-killer will attempt
> > to find a task to kill in the memcg under oom. The oom-killer may be
> > unable to find a process to kill if there are no killable processes in
> > the remote memcg. In this case, the oom-killer (out_of_memory()) will return
> > false, and depending on the gfp, that will generally get bubbled up to
> > mem_cgroup_charge_mapping() as an ENOMEM.
>
> Why doesn't it try to run the shrinkers to get back some page cache /
> slab cache memory from this memcg?  I understand it might not be able
> to (eg if the memory is mlocked), but surely that's rare.
>

Please correct me if I'm wrong, but AFAICT I haven't disabled any
shrinkers from running or disabled any reclaim mechanism on remote
charges. What I see in the code is that when the remote memcg runs out
of memory is that try_to_free_mem_cgroup_pages() gets called as normal
and we do the MAX_RECLAIM_RETRIES as normal.

It's only in the (rare as you point out) case where the kernel is
completely unable to find memory in the remote memcg that we need to
do the special handling that's described in this patch. Although this
situation is probably quite rare in real-world scenarios, it's easily
reproducible (and the attached test in the series does so), so my
feeling is that it needs some sane handling, which I'm attempting to
do in this patch.
