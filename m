From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: fix oom_kill event handling
Date: Tue, 8 May 2018 13:49:16 +0100
Message-ID: <20180508124743.GA26112@castle.DHCP.thefacebook.com>
References: <20180508120402.3159-1-guro@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=Hw7B30KOr+T55L/mwVNOiI9jHMTT3DDyk894CmHkuQI=;
 b=SyLegr9BFj5MsId1u2PA7NdEHYhPL0NyBTJyjPC8QYbNEWUKL2zsJVCmL7k66q0xcBLq
 7wcuiOH1Xs+tWhP8vWoW9k/5TsV4n55CxEASt1xcJBQNI8AyhwmkhGsS6qNubK/30082
 qGHLik4wu1HyLYO5Dj+gxirIqewsq8A5q+I= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Hw7B30KOr+T55L/mwVNOiI9jHMTT3DDyk894CmHkuQI=;
 b=PIN5m0BIH2CRB0uYOuTnAU62x6j1XRrws41EHOti/mRcoBR4d2kS0jTNIs3guB4WQqutdLMSIdC2KbQG7chDfOCNbwpDjEJEiSoJWH7xnVjIRqCQH1aRSd8APcUw0BKvmZh0ONX+Wm1ZeRQVkYcew4mrznX3FbMFsvD/jCfAvtY=
Content-Disposition: inline
In-Reply-To: <20180508120402.3159-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Tue, May 08, 2018 at 01:04:02PM +0100, Roman Gushchin wrote:
> Commit e27be240df53 ("mm: memcg: make sure memory.events is
> uptodate when waking pollers") converted most of memcg event
> counters to per-memcg atomics, which made them less confusing
> for a user. The "oom_kill" counter remained untouched, so now
> it behaves differently than other counters (including "oom").
> This adds nothing but confusion.

Please, ignore this one. Version 2 is properly rebased on top
of the mm tree.

Thanks!
