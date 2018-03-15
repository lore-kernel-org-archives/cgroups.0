From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm v3 0/3] mm, memcg: introduce oom policies
Date: Thu, 15 Mar 2018 13:54:09 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803151351140.55261@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=SDcibDM1IQ+fHSLvCSbRY5CU7+nOXmQWXTxOk9PuF28=;
        b=ayjK/SxRTB094RLbZCiw9rySo4WS7QIlZK+jmg6x+jm40pXD0fDJWw+oCv/V0ASxyV
         JktpHsY9F8p/V/TgNHYv7btE/dPfJkCrKLSBWXZ4Fud5PeuqkUPSJYfvMrNeqAaN0idL
         Tib2U1Fj6fkFq2+7iBKH49C0tcEIPhDTcPgelUbe4hFcPDOEwbVHPn2Ptun7ct3Y1LH7
         AaTfohCeIJrZw47uEpnKZH75oPqV9rS5iFXGlrJA5lLVLInuTZktEgOiYyRvnbBfQxV4
         x8omuXNQ3DdiqvH6Sh3Zr6Bgyu3MOK0ZvAOmKaBMSC/Oby3sHJ0d0Gvbf1gdSaqkqFJ9
         hGsg==
In-Reply-To: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Mon, 12 Mar 2018, David Rientjes wrote:

> There are three significant concerns about the cgroup aware oom killer as
> it is implemented in -mm:
> 
>  (1) allows users to evade the oom killer by creating subcontainers or
>      using other controllers since scoring is done per cgroup and not
>      hierarchically,
> 
>  (2) unfairly compares the root mem cgroup using completely different
>      criteria than leaf mem cgroups and allows wildly inaccurate results
>      if oom_score_adj is used, and
> 
>  (3) does not allow the user to influence the decisionmaking, such that
>      important subtrees cannot be preferred or biased.
> 
> This patchset aims to fix (1) completely and, by doing so, introduces a
> completely extensible user interface that can be expanded in the future.
> 
> It preserves all functionality that currently exists in -mm and extends
> it to be generally useful outside of very specialized usecases.
> 
> It eliminates the mount option for the cgroup aware oom killer entirely
> since it is now enabled through the root mem cgroup's oom policy.

There are currently six patches in this series since additional patches on 
top of it have been proposed to fix the several issues with the current 
implementation in -mm.  The six patches address (1) and (2) above, as well 
as a couple other minor tweaks.  I believe (3) can be subsequently 
addressed after the feature has been merged since it builds upon what is 
already here and shouldn't hold it back from being merged itself.

I plan on sending out the entire series once feedback is received for the 
patches already sent.

Thanks.
