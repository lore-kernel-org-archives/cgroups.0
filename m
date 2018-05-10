From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2] mm: fix oom_kill event handling
Date: Thu, 10 May 2018 13:12:56 +0100
Message-ID: <20180510121251.GA6762@castle.DHCP.thefacebook.com>
References: <20180508124637.29984-1-guro@fb.com>
 <20180510114147.GB5325@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=Qu6GGk2SwrfQeR4We7227oEC1LRwCQTPUVUM/92qr3o=;
 b=ZkTmLeNW3Q4gN+aQjXkdG91Jq95+CiJDlHxCTgBEPxbZlUkbpTumDiPrLiAHZsU/OLSn
 qafO20BHeiVTe2Gxxm+Zj9GLL/GdwXJ8haewJrXDqYIRnqNoTEnQh7f8nPValnk7LJfo
 M1JJiyV60vBfyFH4rSO1BAq2raZj7Q8p6i0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Qu6GGk2SwrfQeR4We7227oEC1LRwCQTPUVUM/92qr3o=;
 b=CdhTNtxdHCLUSYKcbpCNR8ez2hN59g5ATunHn4keOBe9OmioHjh/ZsnTYXNtgFPFU/nmCFIYchn/sa+n9jnNIPufIrjvc16rRJ+964KOIOIAc65hTkjlXaKuuO1tdvRg1mAeGGG+fY2ZNYtm/LHo5zd+r7fq0ltmUR0hvmJ+W+o=
Content-Disposition: inline
In-Reply-To: <20180510114147.GB5325@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu, May 10, 2018 at 01:41:47PM +0200, Michal Hocko wrote:
> On Tue 08-05-18 13:46:37, Roman Gushchin wrote:
> > Commit e27be240df53 ("mm: memcg: make sure memory.events is
> > uptodate when waking pollers") converted most of memcg event
> > counters to per-memcg atomics, which made them less confusing
> > for a user. The "oom_kill" counter remained untouched, so now
> > it behaves differently than other counters (including "oom").
> > This adds nothing but confusion.
> > 
> > Let's fix this by adding the MEMCG_OOM_KILL event, and follow
> > the MEMCG_OOM approach. This also removes a hack from
> > count_memcg_event_mm(), introduced earlier specially for the
> > OOM_KILL counter.
> 
> I agree that the current OOM_KILL is confusing. But do we really need
> another memcg_memory_event_mm helper used for only one counter rather
> than reuse memcg_memory_event. __oom_kill_process doesn't have the memcg
> but nothing should really prevent us from adding the context
> (oom_control) there, no?

Not sure, that I follow. oom_control has memcg pointer,
but it's a pointer to a cgroup, where OOM happened.
In particular, it's NULL for a system-wide OOM.

And we do send the OOM_KILL event to the cgroup,
which actually contains the process.
