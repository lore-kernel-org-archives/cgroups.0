From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Mon, 24 Aug 2020 15:50:10 -0400
Message-ID: <20200824195009.GE4337@lca.pw>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=85LkKtijLyN/OhxDFk0kAql1huZBkB94f5RcTYwHk5c=;
        b=XfSHPkEj7U77O4jChB1IJFQGHGtpuZzQ3plVs8yYXSH65jQSvMg9341yheyQPiyvhB
         S5HYsSz00oW1qLer36HFmSCxaNybFL5PGZt90u4gzDdJkBQ40kR5bTOjPkMCUkGx+z9u
         jfFfDwhBlPnlJRfH7EAtNc8Sj76JItvg6J+b8+R4tsiaGIuocAEVUsalHYuzNEW7371e
         lIKnkY2wygcg4XGhAxgyxk/wI/I4z70UkIrzaDIXOy77WWjZzQ3r9Z4hPYDQ7oqG5pXL
         wqb7o9im19kkoReuLpksU8HeNSxXUMsohLOVAzBfqGqS88Qgomhe1U17o5WG3jw4IiqS
         ikCQ==
Content-Disposition: inline
In-Reply-To: <20200824114204.cc796ca182db95809dd70a47-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, Aug 24, 2020 at 11:42:04AM -0700, Andrew Morton wrote:
> On Mon, 24 Aug 2020 20:54:33 +0800 Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
> 
> > The new version which bases on v5.9-rc2. The first 6 patches was picked into
> > linux-mm, and add patch 25-32 that do some further post optimization.
> 
> 32 patches, version 18.  That's quite heroic.  I'm unsure whether I
> should merge it up at this point - what do people think?

I certainly hope not given how buggy the previous reversion and Alex's other
patchset are. There is really no room for the shortcut this time.

> 
> > 
> > Following Daniel Jordan's suggestion, I have run 208 'dd' with on 104
> > containers on a 2s * 26cores * HT box with a modefied case:
> > https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice
> > With this patchset, the readtwice performance increased about 80%
> > in concurrent containers.
> 
> That's rather a slight amount of performance testing for a huge
> performance patchset!  Is more detailed testing planned?
> 
> 
