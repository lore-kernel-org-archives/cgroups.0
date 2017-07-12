From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Wed, 12 Jul 2017 10:00:34 -0400
Message-ID: <0f531185-4d39-ff50-8a48-067d6d209673@redhat.com>
References: <20170612123150.scopfxela7v26dct@hirez.programming.kicks-ass.net>
 <20170612212753.GN19206@htj.duckdns.org> <20170627070143.GB4114@worktop>
 <20170630132324.GA18669@htj.duckdns.org>
 <20170710083200.poevcjo7x47hy5ni@hirez.programming.kicks-ass.net>
 <8f9c83d7-cadf-3a41-8e56-5828d5abfa26@redhat.com>
 <20170711121527.imshmmoe4cj7dkig@hirez.programming.kicks-ass.net>
 <a554d16c-af40-756e-a611-a453451c40a9@redhat.com>
 <20170711165233.xx6wko4pdxk4rb72@hirez.programming.kicks-ass.net>
 <0659619a-067d-b542-918c-e468c51feb23@redhat.com>
 <20170712074555.slefkebvdpfjse34@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 380A83D972
In-Reply-To: <20170712074555.slefkebvdpfjse34-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On 07/12/2017 03:45 AM, Peter Zijlstra wrote:
> On Tue, Jul 11, 2017 at 05:12:39PM -0400, Waiman Long wrote:
>> On 07/11/2017 12:52 PM, Peter Zijlstra wrote:
>>> On Tue, Jul 11, 2017 at 10:14:42AM -0400, Waiman Long wrote:
>>>
>>>> The "join" was a special op for the children of cgroup root to join the
>>>> root as part of a threaded subtree. The children can instead use the
>>>> "enable" option to become a thread root which was the configuration
>>>> shown above.  This behavior applied only to children of root. Down the
>>>> hierarchy, you can't have configuration like:
>>>>
>>>>      R (t=0)
>>>>     / \
>>>>        D (t=1)
>>>>       / \
>>>>      T   D (t=1)
>>> Why not?
>>>
>>> First you create:
>>>
>>>       R (t=0)
>>>      / \
>>>         D (t=1)
>>>        / \
>>>       T   T (t=1)
>>>
>>> Then you flip t=0 like:
>>>
>>>       R (t=0)
>>>      / \
>>>         D (t=1)
>>>        / \
>>>       T   D (t=0)
>>>
>>> And then you flip t=1 again:
>>>
>>>       R (t=0)
>>>      / \
>>>         D (t=1)
>>>        / \
>>>       T   D (t=1)
>> Tejun's thread mode patch has constraints on what operations are allowed
>> and what aren't. For a threaded subtree, thread mode cannot be disabled
>> in the middle of the tree.
> Where in that scenario did I change anything in the middle? All
> operations were on a leaf group.

What I mean is that you can't disable thread mode if not at the thread
root with no children left.

Cheers,
Longman
