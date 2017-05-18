From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RFC PATCH] mm, oom: cgroup-aware OOM-killer
Date: Fri, 19 May 2017 04:37:27 +1000
Message-ID: <CAKTCnzkBNV9bsQSg4kzhxY=i=-y3x78StbbXfV9mvXLsJhGHig@mail.gmail.com>
References: <1495124884-28974-1-git-send-email-guro@fb.com> <20170518173002.GC30148@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=2io6QN7phSNOr3V1c/S3zKvs5Qo1aQrA9bncru0SeyQ=;
        b=R+D+TJ2MoSchfAdU0l3mJUZhkC8rmu9HAnG4ACJEW8TPMPFl0b0ziPJpeXN5OZ1QEs
         DtSg+LvZVVEuB43StMIZSAmjWxihhDuTATOS6oUvanvdUCH5WyzXvxaBZEdqRHljja5O
         QhcXYDBBeXUAx32zgf0s5sXHvsHrpg6jwD3wVsP1neSkfSoB01elG0Axw3ELqFPpNwLQ
         +K2LF7mKFVFZ29xAibZvZ//0m10gOPWM9IzERfJHoKogLFOcLqiiyzECE9VZeuZtLEsv
         wlyvZK6fb/CBXtCcixwrSEvZ7IgtT8U22OPKj6buiIaiS9npFHmlTKuXfwnyXlAoQmGC
         JkHA==
In-Reply-To: <20170518173002.GC30148@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, kernel-team@fb.com, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>

On Fri, May 19, 2017 at 3:30 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Thu 18-05-17 17:28:04, Roman Gushchin wrote:
>> Traditionally, the OOM killer is operating on a process level.
>> Under oom conditions, it finds a process with the highest oom score
>> and kills it.
>>
>> This behavior doesn't suit well the system with many running
>> containers. There are two main issues:
>>
>> 1) There is no fairness between containers. A small container with
>> a few large processes will be chosen over a large one with huge
>> number of small processes.
>>
>> 2) Containers often do not expect that some random process inside
>> will be killed. So, in general, a much safer behavior is
>> to kill the whole cgroup. Traditionally, this was implemented
>> in userspace, but doing it in the kernel has some advantages,
>> especially in a case of a system-wide OOM.
>>
>> To address these issues, cgroup-aware OOM killer is introduced.
>> Under OOM conditions, it looks for a memcg with highest oom score,
>> and kills all processes inside.
>>
>> Memcg oom score is calculated as a size of active and inactive
>> anon LRU lists, unevictable LRU list and swap size.
>>
>> For a cgroup-wide OOM, only cgroups belonging to the subtree of
>> the OOMing cgroup are considered.
>
> While this might make sense for some workloads/setups it is not a
> generally acceptable policy IMHO. We have discussed that different OOM
> policies might be interesting few years back at LSFMM but there was no
> real consensus on how to do that. One possibility was to allow bpf like
> mechanisms. Could you explore that path?

I agree, I think it needs more thought. I wonder if the real issue is something
else. For example

1. Did we overcommit a particular container too much?
2. Do we need something like https://lwn.net/Articles/604212/ to solve
the problem?
3. We have oom notifiers now, could those be used (assuming you are interested
in non memcg related OOM's affecting a container
4. How do we determine limits for these containers? From a fariness
perspective

Just trying to understand what leads to the issues you are seeing

Balbir
