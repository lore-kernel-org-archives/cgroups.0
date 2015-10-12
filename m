From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 14/14] cgroup: add cgroup_subsys->free() method and use
 it to fix pids controller
Date: Mon, 12 Oct 2015 11:25:52 -0400
Message-ID: <20151012152552.GA23399@mtj.duckdns.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
 <1444570210-15640-4-git-send-email-tj@kernel.org>
 <CAOviyaj_xi1h0m1Os6FjR4DTY-qs049eGauJUL6nhbfeaaZk8w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=BuAhHqxAlI9SHUi3gX5nneV2T/dIOG8VRx/hgIONawg=;
        b=mBjUc2HqlHjLUDBQsS9p/1KxsRQKOVJGhg0bqWpNLYvLnK90qi+tnHeTLsEpJkxdox
         iAeiDGFgRRg17oGdbPG/8NpXPW5NTXsEhMBqA+82FGAzVUqPEXm4ZDQyzUPgpMaHery4
         8SwJmKdoA6zx7OYBqUx/pIWdBeUdZKj9hIqQ45hj3SBDcRQYb1Lr+nHRqqpzTAIkaC0G
         PglqaKcBzQyBpscAhqmW4gkSGfIuva2n7Ws16Ti+bVK7PAyO5yziY7FhtmKwkF6uu/mX
         qpsSZ0MJ7QvEyrHQUoVt2H23N5Eu6x21Gxb7Ykdk7EvUDr0qwQ4HOL1cAu6vO08uRYEJ
         afgw==
Content-Disposition: inline
In-Reply-To: <CAOviyaj_xi1h0m1Os6FjR4DTY-qs049eGauJUL6nhbfeaaZk8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello,

On Mon, Oct 12, 2015 at 09:29:14PM +1100, Aleksa Sarai wrote:
> > pids controller is completely broken in that it uncharges when a task
> > exits allowing zombies to escape resource control.  With the recent
> > updates, cgroup core now maintains cgroup association till task free
> > and pids controller can be fixed by uncharging on free instead of
> > exit.
> 
> Looks good to me. Out of interest, is there any reason why we still
> have ->exit(), given the zombie process edge case? Surely the zombie
> process edge case would cause issues with kmemcg and similar
> controllers, if they use ->exit() and not ->free()?

No, pids was the only broken one.  ->exit() is no longer used but
let's see how it goes for a while before getting rid of it.

Thanks.

-- 
tejun
