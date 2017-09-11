From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Mon, 11 Sep 2017 13:44:39 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=1k3aVCvxHxyn94nvcEmm3tTubjsk174oBz410rzv/ZI=;
        b=Oi+OJEYqaVwYAEgUpgL0IA1jTYUKGYbFbgpPswHIeaJ7c4tWxkXpbBPjFNut3tN/TL
         dJ1Xjozqt7u4c/CCM+BztGBC6VxaocytyJUKoQW1qxG0VNrF9ySDa6nej1EPhDPxPd3C
         53m5RrWxQJkEH+rhAuGYHzgEJXrl+ORh2nxiqF1OSh/fTGPpjB2DrWRx8uyKviwctuUG
         2vFgAWqcVrzWUWp+iryjdc3WJALMOIY5dEK0eavX7pPugolqsj3SNGPwI5vFoBtkHiPr
         DISZsbSqfsuc0PEGMep5doPcSMB5o9ymkeP2SssnXtQlHhn+/1djFvlzEv+hDKpfzw7V
         d4pw==
In-Reply-To: <20170911131742.16482-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 11 Sep 2017, Roman Gushchin wrote:

> This patchset makes the OOM killer cgroup-aware.
> 
> v8:
>   - Do not kill tasks with OOM_SCORE_ADJ -1000
>   - Make the whole thing opt-in with cgroup mount option control
>   - Drop oom_priority for further discussions

Nack, we specifically require oom_priority for this to function correctly, 
otherwise we cannot prefer to kill from low priority leaf memcgs as 
required.  v8 appears to implement new functionality that we want, to 
compare two memcgs based on usage, but without the ability to influence 
that decision to protect important userspace, so now I'm in a position 
where (1) nothing has changed if I don't use the new mount option or (2) I 
get completely different oom kill selection with the new mount option but 
not the ability to influence it.  I was much happier with the direction 
that v7 was taking, but since v8 causes us to regress without the ability 
to change memcg priority, this has to be nacked.

>   - Kill the whole cgroup if oom_group is set and it's
>     memory.max is reached
>   - Update docs and commit messages

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
