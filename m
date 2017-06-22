From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH-cgroup 4/6] cgroup: Introduce subtree root mode
Date: Thu, 22 Jun 2017 16:27:14 -0400
Message-ID: <7e59ea28-76df-9c9f-02f5-e2847216f1dc@redhat.com>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-5-git-send-email-longman@redhat.com>
 <20170621213807.GC14720@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 48FE47A17D
In-Reply-To: <20170621213807.GC14720-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On 06/21/2017 05:38 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Wed, Jun 14, 2017 at 11:05:35AM -0400, Waiman Long wrote:
>> Subtree root mode is a new cgroup mode which applies the following
>> restrictions when turned on:
>>
>>  1) Controllers are only allowed to be passed to the children in
>>     bypass mode except those with the "enable_on_root" flag on.
>>  2) Only 1 child cgroup is allowed.
>>
>> That lone child can be used as the pseudo root of a container cgroup
>> hierarchy.  All the resources, if controlled, are in the parent
>> cgroup. There will be no control knobs in the child. That makes it
>> look and feel like a root.
> I'm not sure not having the control files in the child makes that much
> difference.

It is more a look and feel thing than being useful. The sole purpose is
to make the container root looks like a real root as much as possible.

>> That pseudo root is also considered to be mixable and so can become
>> root of a mixed threaded subtree. The no internal process constraint
>> also does not apply.
> Heh, you can't just declare a non-root cgroup to be a mixed root but
> if you're special casing this and making the kernel play a masquerade
> with special node, you can make cgroup provide a mixed root while
> hosting the internal processes in a dedicated leaf cgroup which isn't
> visible to the nested root, right?

That is true.

> It's all a game of masquerading tho and doesn't actually enable
> anything which isn't possible now.  This would definitely be useful
> for testing.
You are right about that. As mentioned in another email, having bypass
mode in subtree_control is useful, I think. The concept of subtree root
mode, however, is more toward satisfying PeterZ's idea of container
invariant. I won't mind leaving it out if others have no objection to that.

Cheers,
Longman


