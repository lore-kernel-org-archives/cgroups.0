From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH] mm, oom: cgroup-aware OOM-killer
Date: Thu, 18 May 2017 15:22:40 -0400
Message-ID: <20170518192240.GA29914@cmpxchg.org>
References: <1495124884-28974-1-git-send-email-guro@fb.com>
 <20170518173002.GC30148@dhcp22.suse.cz>
 <CAKTCnzkBNV9bsQSg4kzhxY=i=-y3x78StbbXfV9mvXLsJhGHig@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FRwOI+KiByHR0mcpoNvJFbKdXbz/GZuappuKMcUM2TM=; b=U5kn6n+4G1WG3pyyT0PhS1WpUc
        +TkGwDw5j2nqApgqDdm71Qe0flGN1lAMYoXjbyRuXAPpdH8o8e+OkrKTFqEPj4sAB7Lo76JPhBndk
        Fiq2YLuNe324CO5JpSfanD2ea+AiRXZLPQzXiuzTD0sqhSk5Z0nhF7duFUPqYhtx7XOo=;
Content-Disposition: inline
In-Reply-To: <CAKTCnzkBNV9bsQSg4kzhxY=i=-y3x78StbbXfV9mvXLsJhGHig@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Balbir Singh <bsingharora@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, kernel-team@fb.com, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>

On Fri, May 19, 2017 at 04:37:27AM +1000, Balbir Singh wrote:
> On Fri, May 19, 2017 at 3:30 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Thu 18-05-17 17:28:04, Roman Gushchin wrote:
> >> Traditionally, the OOM killer is operating on a process level.
> >> Under oom conditions, it finds a process with the highest oom score
> >> and kills it.
> >>
> >> This behavior doesn't suit well the system with many running
> >> containers. There are two main issues:
> >>
> >> 1) There is no fairness between containers. A small container with
> >> a few large processes will be chosen over a large one with huge
> >> number of small processes.
> >>
> >> 2) Containers often do not expect that some random process inside
> >> will be killed. So, in general, a much safer behavior is
> >> to kill the whole cgroup. Traditionally, this was implemented
> >> in userspace, but doing it in the kernel has some advantages,
> >> especially in a case of a system-wide OOM.
> >>
> >> To address these issues, cgroup-aware OOM killer is introduced.
> >> Under OOM conditions, it looks for a memcg with highest oom score,
> >> and kills all processes inside.
> >>
> >> Memcg oom score is calculated as a size of active and inactive
> >> anon LRU lists, unevictable LRU list and swap size.
> >>
> >> For a cgroup-wide OOM, only cgroups belonging to the subtree of
> >> the OOMing cgroup are considered.
> >
> > While this might make sense for some workloads/setups it is not a
> > generally acceptable policy IMHO. We have discussed that different OOM
> > policies might be interesting few years back at LSFMM but there was no
> > real consensus on how to do that. One possibility was to allow bpf like
> > mechanisms. Could you explore that path?
> 
> I agree, I think it needs more thought. I wonder if the real issue is something
> else. For example
> 
> 1. Did we overcommit a particular container too much?
> 2. Do we need something like https://lwn.net/Articles/604212/ to solve
> the problem?

The occasional OOM kill is an unavoidable reality on our systems (and
I bet on most deployments). If we tried not to overcommit, we'd waste
a *lot* of memory.

The problem is when OOM happens, we really want the biggest *job* to
get killed. Before cgroups, we assumed jobs were processes. But with
cgroups, the user is able to define a group of processes as a job, and
then an individual process is no longer a first-class memory consumer.

Without a patch like this, the OOM killer will compare the sizes of
the random subparticles that the jobs in the system are composed of
and kill the single biggest particle, leaving behind the incoherent
remains of one of the jobs. That doesn't make a whole lot of sense.

If you want to determine the most expensive car in a parking lot, you
can't go off and compare the price of one car's muffler with the door
handle of another, then point to a wind shield and yell "This is it!"

You need to compare the cars as a whole with each other.

> 3. We have oom notifiers now, could those be used (assuming you are interested
> in non memcg related OOM's affecting a container

Right now, we watch for OOM notifications and then have userspace kill
the rest of a job. That works - somewhat. What remains is the problem
that I described above, that comparing individual process sizes is not
meaningful when the terminal memory consumer is a cgroup.

> 4. How do we determine limits for these containers? From a fariness
> perspective

How do you mean?
