From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch] mm: memcontrol: lockless page counters
Date: Fri, 19 Sep 2014 09:29:19 -0400
Message-ID: <20140919132919.GA16184@cmpxchg.org>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Dave,

this patch removes the lock you saw with will-it-scale/page_fault2
entirely, is there a chance you could give it a spin?  It's based on
v3.17-rc4-mmots-2014-09-12-17-13-4 and that memcg THP fix.  That
kernel also includes the recent root-memcg revert, so you'd have to
run it in a memcg; which is as easy as:

mkdir /sys/fs/cgroup/memory/foo
echo $$ >/sys/fs/cgroup/memory/foo/tasks
perf record -g -a ./runtest.py page_fault2

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
