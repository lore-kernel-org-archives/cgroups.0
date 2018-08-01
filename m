From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v13 0/7] cgroup-aware OOM killer
Date: Wed, 1 Aug 2018 15:55:40 -0700
Message-ID: <20180801225539.GB32269@castle.DHCP.thefacebook.com>
References: <0d018c7e-a3de-a23a-3996-bed8b28b1e4a@i-love.sakura.ne.jp>
 <20180716220918.GA3898@castle.DHCP.thefacebook.com>
 <201807170055.w6H0tHn5075670@www262.sakura.ne.jp>
 <ede70c6a-620b-f835-d66c-b4608fe0ef54@i-love.sakura.ne.jp>
 <20180801163718.GA23539@castle>
 <de9a2bad-d80d-98a0-e155-613a34c0b7be@i-love.sakura.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=q+I4Lotj8vM7zyt0xOvFM2hn5WPkYOqX2wqKYahZlUE=;
 b=NP8MMCf3rIQgKgLGRkbsTUaHqPSDjNF0uovoR3ngLV4ty/QZft3bk9oYONBdfjjc3WBQ
 SlxC4JI+FZKKZmk6psKaPI3bNAH6Vq021I4kKe63qrsY1riAo/4dicbfDeBNDTpWJU1A
 2LbQPBF7qSe74xHOtEbF8EFB83uY7vonbts= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+I4Lotj8vM7zyt0xOvFM2hn5WPkYOqX2wqKYahZlUE=;
 b=fOPqrVZgfdJEviQ8dAcasx04wEE4ePYUxpjtc7TMUA05P0C7TPio2Hd7uDT60i/MfrJ7ET0ko3Ag8xZAhf/8Gc0IyikCmKQYkqJ2xkBNBUOY2YVdtjipzgv8Gmq0oDv9ZY8qLLXklm5+lbc5DBC1LFGnqmDPKDIYDVKjCyTR8i4=
Content-Disposition: inline
In-Reply-To: <de9a2bad-d80d-98a0-e155-613a34c0b7be@i-love.sakura.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Thu, Aug 02, 2018 at 07:01:28AM +0900, Tetsuo Handa wrote:
> On 2018/08/02 1:37, Roman Gushchin wrote:
> > On Tue, Jul 31, 2018 at 11:14:01PM +0900, Tetsuo Handa wrote:
> >> Can we temporarily drop cgroup-aware OOM killer from linux-next.git and
> >> apply my cleanup patch? Since the merge window is approaching, I really want to
> >> see how next -rc1 would look like...
> > 
> > Hi Tetsuo!
> > 
> > Has this cleanup patch been acked by somebody?
> 
> Not yet. But since Michal considers this cleanup as "a nice shortcut"
> ( https://marc.info/?i=20180607112836.GN32433@dhcp22.suse.cz ), I assume that
> I will get an ACK regarding this cleanup.
> 
> > Which problem does it solve?
> 
> It simplifies tricky out_of_memory() return value decision, and
> it also fixes a bug in your series which syzbot is pointing out.
> 
> > Dropping patches for making a cleanup (if it's a cleanup) sounds a bit strange.
> 
> What I need is a git tree which I can use as a baseline for making this cleanup.
> linux.git is not suitable because it does not include Michal's fix, but
> linux-next.git is not suitable because Michal's fix is overwritten by your series.
> I want a git tree which includes Michal's fix and does not include your series.
> 
> > 
> > Anyway, there is a good chance that current cgroup-aware OOM killer
> > implementation will be replaced by a lightweight version (memory.oom.group).
> > Please, take a look at it, probably your cleanup will not conflict with it
> > at all.
> 
> Then, please drop current cgroup-aware OOM killer implementation from linux-next.git .
> I want to see how next -rc1 would look like (for testing purpose) and want to use
> linux-next.git as a baseline (for making this cleanup).

I'll post memory.oom.group v2 later today, and if there will be no objections,
I'll ask Andrew to drop current memcg-aware OOM killer and replace it
with lightweight memory.oom.group.

These changes will be picked by linux-next in few days.

Thanks!
