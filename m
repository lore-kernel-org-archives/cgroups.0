From: David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH v2 1/7] mm, oom: refactor select_bad_process() to
 take memcg as an argument
Date: Tue, 6 Jun 2017 13:42:29 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1706061339410.23608@chino.kir.corp.google.com>
References: <1496342115-3974-1-git-send-email-guro@fb.com> <1496342115-3974-2-git-send-email-guro@fb.com> <alpine.DEB.2.10.1706041550290.24226@chino.kir.corp.google.com> <20170606162007.GB752@castle>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Piw/WR7JjjQ9u5sucm9+U1pYagvKiTvstddvBF+Qzho=;
        b=d4vrw2JO5K1z5mk4iKAKZXcb9iDwoG3pCMXSU7uq8Jb0k+SOA3zncir1WHEpI5M8eF
         n1yRhFsNQuYTYG5VDO3G05OscMld8o85JVeStL1dkBuvqA/bwY7aa2gljIFfXbTh9PCw
         FxJTzEWDX78oUfWCpNGPgpoWdOFxsPlnI5OEEGLIqdG+ldyXugW8rGJf9umOB03SuoAJ
         3HduBUnRQCIsOY6IqsedGUYlktsJZXAnCosf1sCU8TBsVjo8dChtJdPiYf9ZHUfe81V9
         Ts83bkjxe3ZYeobx3VqQsMrIsa2Mhe5W3X9+GLRNKm/7wIlnm9uFYJwy8/P5UN+C3DIo
         5E6A==
In-Reply-To: <20170606162007.GB752@castle>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 6 Jun 2017, Roman Gushchin wrote:

> Hi David!
> 
> Thank you for sharing this!
> 
> It's very interesting, and it looks like,
> it's not that far from what I've suggested.
> 
> So we definitily need to come up with some common solution.
> 

Hi Roman,

Yes, definitely.  I could post a series of patches to do everything that 
was listed in my email sans the fully inclusive kmem accounting, which may 
be pursued at a later date, if it would be helpful to see where there is 
common ground?

Another question is what you think about userspace oom handling?  We 
implement our own oom kill policies in userspace for both the system and 
for user-controlled memcg hierarchies because it often does not match the 
kernel implementation and there is some action that can be taken other 
than killing a process.  Have you tried to implement functionality to do 
userspace oom handling, or are you considering it?  This is the main 
motivation behind allowing an oom delay to be configured.
