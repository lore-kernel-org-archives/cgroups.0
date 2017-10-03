From: Roman Gushchin <guro@fb.com>
Subject: Re: [v9 2/5] mm: implement mem_cgroup_scan_tasks() for the root
 memory cgroup
Date: Tue, 3 Oct 2017 13:50:27 +0100
Message-ID: <20171003125027.GB28904@castle.DHCP.thefacebook.com>
References: <20170927130936.8601-1-guro@fb.com>
 <20170927130936.8601-3-guro@fb.com>
 <20171003104939.vm7pezgef7bqxe2v@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=QLYls2buLQABB4KmaIwSR7mAjnGopRnovHOeQKrMJdQ=;
 b=DM78uQkhJ7bpz/ffik948AP0ZNi+tWmnfl2cm5TRpK5MWJ+o0RftRWnurv8x1HhEGHuV
 MEHv6E3n83iBR8LNxwsalAt/GuCT+My63isnPVzW34iFAX6bA+37lF3CtDQkwzbQV5KC
 dYwjCrSk5OFqi7Inq96FJcOZK5GNpZ/+KiQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QLYls2buLQABB4KmaIwSR7mAjnGopRnovHOeQKrMJdQ=;
 b=WEDunxXUyQibfpWf2JUIjLUSSZjJIT1Ho3nknVymZVXlZzMzYHACMudS+7qJZfaiOCfvY+19n1LvbT689x4Ita+B3o+8hGsInNoaTcID+2iVmAy/F6tiW3w3aMj/JOClJC6DjSa9n1Clrw5dEXNqmd73Pik6o20tfw3UuUowPls=
Content-Disposition: inline
In-Reply-To: <20171003104939.vm7pezgef7bqxe2v@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 12:49:39PM +0200, Michal Hocko wrote:
> On Wed 27-09-17 14:09:33, Roman Gushchin wrote:
> > Implement mem_cgroup_scan_tasks() functionality for the root
> > memory cgroup to use this function for looking for a OOM victim
> > task in the root memory cgroup by the cgroup-ware OOM killer.
> > 
> > The root memory cgroup should be treated as a leaf cgroup,
> > so only tasks which are directly belonging to the root cgroup
> > should be iterated over.
> 
> I would only add that this patch doesn't introduce any functionally
> visible change because we never trigger oom killer with the root memcg
> as the root of the hierarchy. So this is just a preparatory work for
> later changes.

Sure, thanks!

> 
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: kernel-team@fb.com
> > Cc: cgroups@vger.kernel.org
> > Cc: linux-doc@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-mm@kvack.org
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
