From: Roman Gushchin <guro@fb.com>
Subject: Re: [patch -mm 0/4] mm, memcg: introduce oom policies
Date: Wed, 17 Jan 2018 11:46:03 +0000
Message-ID: <20180117114554.GA10523@castle.DHCP.thefacebook.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=YzQdAmhVMM1VBob7HzX8y1etKxrP/WU3Hm/TgCsYE9w=;
 b=ONYY00zNu4KbI+mwBEv8dWj+P+w56cRgJphFgCWxNwjXmDWJPoiWWtG+D0TPvmcimUi+
 evLtvWNv7oREv7DdP+QTUm/37m3IzejiHhmsykY36dFbbE3RLSEckhAY1IfPxV0DNE/n
 T5g71LI5cQ5R9PzU4Sv7BpbbtIA2a6eBo5Y= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YzQdAmhVMM1VBob7HzX8y1etKxrP/WU3Hm/TgCsYE9w=;
 b=f2VVI14qr3LJtsIcrT+Hg1ii8f/IBFFedYp0yIh311S+r+K64PgE1uqy6DbZwOvCnQGJ2rEeP8W/bR7a0yCVc0RPqhNezklUOUuI/KBF+L6VKHnKUNRce/Wh9ga3ssk8P+qkc/aEAZadG5yOKNq1UWCZDktmlhUVUJzKx8ssbP4=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Tue, Jan 16, 2018 at 06:14:58PM -0800, David Rientjes wrote:
> There are three significant concerns about the cgroup aware oom killer as
> it is implemented in -mm:
> 
>  (1) allows users to evade the oom killer by creating subcontainers or
>      using other controllers since scoring is done per cgroup and not
>      hierarchically,
> 
>  (2) does not allow the user to influence the decisionmaking, such that
>      important subtrees cannot be preferred or biased, and
> 
>  (3) unfairly compares the root mem cgroup using completely different
>      criteria than leaf mem cgroups and allows wildly inaccurate results
>      if oom_score_adj is used.
> 
> This patchset aims to fix (1) completely and, by doing so, introduces a
> completely extensible user interface that can be expanded in the future.
> 
> It eliminates the mount option for the cgroup aware oom killer entirely
> since it is now enabled through the root mem cgroup's oom policy.
> 
> It eliminates a pointless tunable, memory.oom_group, that unnecessarily
> pollutes the mem cgroup v2 filesystem and is invalid when cgroup v2 is
> mounted with the "groupoom" option.

You're introducing a new oom_policy knob, which has two separate sets
of possible values for the root and non-root cgroups. I don't think
it aligns with the existing cgroup v2 design.

For the root cgroup it works exactly as mount option, and both "none"
and "cgroup" values have no meaning outside of the root cgroup. We can
discuss if a knob on root cgroup is better than a mount option, or not
(I don't think so), but it has nothing to do with oom policy as you
define it for non-root cgroups.

For non-root cgroups you're introducing "all" and "tree", and the _only_
difference is that in the "all" mode all processes will be killed, rather
than the biggest in the "tree". I find these names confusing, in reality
it's more "evaluate together and kill all" and "evaluate together and
kill one".

So, it's not really the fully hierarchical approach, which I thought,
you were arguing for. You can easily do the same with adding the third
value to the memory.groupoom knob, as I've suggested earlier (say, "disable,
"kill" and "evaluate"), and will be much less confusing.

Thanks!

Roman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
