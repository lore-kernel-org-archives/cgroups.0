From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup: Add pids controller event when fork fails
 because of pid limit
Date: Tue, 21 Jun 2016 12:34:02 -0400
Message-ID: <20160621163402.GI3262@mtj.duckdns.org>
References: <20160621044429.GA19501@cmpxchg.org>
 <1466524894-3303517-1-git-send-email-kennyyu@fb.com>
 <CAOviyaic6iwon=OavFhR21fYA30ND7nQwAyQ9xFQ5U=0q6Rk+g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QDY+z/sSO8KVWwVQB5GhOEXgfwhTtgoEX0kKK68/kZQ=;
        b=gWUHHsgoZVQgoeZ/m2di4jFltG741rOJ4LCM9xEJqJJOJv0rWZlImkd3VS6xItDxMk
         pF13sIHf/bsaeXvqW4uUw3gSG7qNrXJUTOo2GTonycTShS7zm98gsJ21WUvPfel3E6wE
         4RT8ePj0Uh308CePa5kEqmZRIn9+dbOCVpOY/iV22umW1KFSZwCGMuUSchtoWqDY5WY9
         C9B61fbvNEjAvL6Z0YgrZoJ7xmtNWFTGec05yo4UGnzu+lEjDoAC+RHJZF125LfZt4Rp
         3boLP0pSW33V+uzYX7cYgwJgxY1AjpL2FU5Eto1hVMjZ6gSo69a97F0mQ7gtlmZ0GRS1
         wjPQ==
Content-Disposition: inline
In-Reply-To: <CAOviyaic6iwon=OavFhR21fYA30ND7nQwAyQ9xFQ5U=0q6Rk+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Kenny Yu <kennyyu@fb.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello,

On Wed, Jun 22, 2016 at 02:07:09AM +1000, Aleksa Sarai wrote:
> Why are we logging this? Isn't the pids.events file enough
> information? I feel like you could remove a lot of logic if you don't
> log this.

I think logging it is a good idea.  People aren't used to think about
the pids controller when fork fails and I've seen people getting
royally confused by it.  Also, if fork is being rejected on the right
(or wrong) cgroup, investigating why that's happening can be extremely
challenging (e.g. can't login).

> And even if we do end up logging it, why have the boolean flag (the
> counter always increases, just log if the counter is currently 0 and
> you're incrementing it).

Ah, that's true.  I like the fact that the warning message will be
printed after each change to the limit but yeah going off of zero
events_limit count should be fine too.

Thanks.

-- 
tejun
