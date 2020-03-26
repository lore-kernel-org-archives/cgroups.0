From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Thu, 26 Mar 2020 15:57:11 -0400
Message-ID: <972a5c1b-6721-ac20-cec5-617af67e617d@redhat.com>
References: <20200326191623.129285-1-joel@joelfernandes.org>
 <20200326192035.GO162390@mtj.duckdns.org>
 <20200326194448.GA133524@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585252649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+HcwVk5VdvJ1LeKecVY6pFDWmsucvzIVlRkfrm9XQWo=;
        b=BmWaLXH+/vRVPPM6LB3TVTtZosaMA9utLxpyFd/A6iZjyIPIUUOj49OLi5sFurI9HG9R1s
        O0sbqeYtLkK+1zUV687FPdHD8DZP80y8PYIZ9TQxrxJIDBxJdmRZH1g6nyQN+br7wndZhE
        /g/+3gC8fFlWSzilH9HezckX5msoe4s=
In-Reply-To: <20200326194448.GA133524@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joel Fernandes <joel@joelfernandes.org>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>, Amit Pundir <amit.pundir@linaro.org>, kernel-team@android.com, jsbarnes@google.com, sonnyrao@google.com, vpillai@digitalocean.com, peterz@infradead.org, Guenter Roeck <groeck@chromium.org>, Greg Kerr <kerrnel@google.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>

On 3/26/20 3:44 PM, Joel Fernandes wrote:
> Hi Tejun,
>
> On Thu, Mar 26, 2020 at 03:20:35PM -0400, Tejun Heo wrote:
>> On Thu, Mar 26, 2020 at 03:16:23PM -0400, Joel Fernandes (Google) wrote:
>>> This deliberately changes the behavior of the per-cpuset
>>> cpus file to not be effected by hotplug. When a cpu is offlined,
>>> it will be removed from the cpuset/cpus file. When a cpu is onlined,
>>> if the cpuset originally requested that that cpu was part of the cpuset,
>>> that cpu will be restored to the cpuset. The cpus files still
>>> have to be hierachical, but the ranges no longer have to be out of
>>> the currently online cpus, just the physically present cpus.
>> This is already the behavior on cgroup2 and I don't think we want to
>> introduce this big a behavior change to cgroup1 cpuset at this point.
> It is not really that big a change. Please go over the patch, we are not
> changing anything with how ->cpus_allowed works and interacts with the rest
> of the system and the scheduler. We have just introduced a new mask to keep
> track of which CPUs were requested without them being affected by hotplug. On
> CPU onlining, we restore the state of ->cpus_allowed as not be affected by
> hotplug.
>
> There's 3 companies that have this issue so that should tell you something.
> We don't want to carry this patch forever. Many people consider the hotplug
> behavior to be completely broken.
>
I think Tejun is concerned about a change in the default behavior of
cpuset v1.

There is a special v2 mode for cpuset that is enabled by the mount
option "cpuset_v2_mode". This causes the cpuset v1 to adopt some of the
v2 behavior. I introduced this v2 mode a while back to address, I think,
a similar concern. Could you try that to see if it is able to address
your problem? If not, you can make some code adjustment within the
framework of the v2 mode. As long as it is an opt-in, I think we are
open to further change.

Cheers,
Longman

