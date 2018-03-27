From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] mm, memcontrol: Implement memory.swap.events
Date: Tue, 27 Mar 2018 06:52:17 -0700
Message-ID: <20180327135217.GI1840639@devbig577.frc2.facebook.com>
References: <20180324165127.701194-1-tj@kernel.org>
 <20180326143931.41a15320fd4d4af26c86d42e@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jvBLufNHtsJN7gVep4Cc01h2j7HbBjg6ebHaI7m3jcs=;
        b=XSvLU5SjszhwgN0B4tCDZeze+IsYvIa6qxvH9AG74x8v7kX7MFyeI8V4jp9GPBdcBw
         ZPjs9yQW1QscETyxW11//2qato57OSIlu7H9tPRSPnyCBT7tfLOmhIWzCOdtOgoi/aK0
         9O1pE1u5Q67yQzBgKV5U5zsHWg87JeuTWtqNT6FXeB0Z7exJi+n69BbGQLFv82myI6Og
         HrdF1UHz7DahknbYN5DQGN/2kFx1lqFGCgV/ku9GBKEDcwYYe57Le0iF7u2z/WfCUSQQ
         Bd/lk7nZ0Acvljrn55gC9lyQgJBJJLMhIrQodthUbPz6QhjFzQfubzlASCBK0+9tjVyg
         SnZg==
Content-Disposition: inline
In-Reply-To: <20180326143931.41a15320fd4d4af26c86d42e@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, guro@fb.com, riel@surriel.com, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

On Mon, Mar 26, 2018 at 02:39:31PM -0700, Andrew Morton wrote:
> On Sat, 24 Mar 2018 09:51:25 -0700 Tejun Heo <tj@kernel.org> wrote:
> 
> > This patchset implements memory.swap.events which contains max and
> > fail events so that userland can monitor and respond to swap running
> > out.  It contains the following two patches.
> > 
> >  0001-mm-memcontrol-Move-swap-charge-handling-into-get_swa.patch
> >  0002-mm-memcontrol-Implement-memory.swap.events.patch
> > 
> > This patchset is on top of the "cgroup/for-4.17: Make cgroup_rstat
> > available to controllers" patchset[1] and "mm, memcontrol: Make
> > cgroup_rstat available to controllers" patchset[2] and also available
> > in the following git branch.
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-memcg-swap.events
> 
> This doesn't appear to be in linux-next yet.  It should be by now if it's
> targeted at 4.17?

You're right.  It's too late for 4.17.  Let's aim for 4.18.

Thanks.

-- 
tejun
