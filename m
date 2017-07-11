From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Tue, 11 Jul 2017 17:12:39 -0400
Message-ID: <0659619a-067d-b542-918c-e468c51feb23@redhat.com>
References: <20170610140351.10703-1-tj@kernel.org>
 <20170612123150.scopfxela7v26dct@hirez.programming.kicks-ass.net>
 <20170612212753.GN19206@htj.duckdns.org> <20170627070143.GB4114@worktop>
 <20170630132324.GA18669@htj.duckdns.org>
 <20170710083200.poevcjo7x47hy5ni@hirez.programming.kicks-ass.net>
 <8f9c83d7-cadf-3a41-8e56-5828d5abfa26@redhat.com>
 <20170711121527.imshmmoe4cj7dkig@hirez.programming.kicks-ass.net>
 <a554d16c-af40-756e-a611-a453451c40a9@redhat.com>
 <20170711165233.xx6wko4pdxk4rb72@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com D626BC04B31C
In-Reply-To: <20170711165233.xx6wko4pdxk4rb72-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On 07/11/2017 12:52 PM, Peter Zijlstra wrote:
> On Tue, Jul 11, 2017 at 10:14:42AM -0400, Waiman Long wrote:
>
>> The "join" was a special op for the children of cgroup root to join the
>> root as part of a threaded subtree. The children can instead use the
>> "enable" option to become a thread root which was the configuration
>> shown above.  This behavior applied only to children of root. Down the
>> hierarchy, you can't have configuration like:
>>
>>      R (t=0)
>>     / \
>>        D (t=1)
>>       / \
>>      T   D (t=1)
> Why not?
>
> First you create:
>
>       R (t=0)
>      / \
>         D (t=1)
>        / \
>       T   T (t=1)
>
> Then you flip t=0 like:
>
>       R (t=0)
>      / \
>         D (t=1)
>        / \
>       T   D (t=0)
>
> And then you flip t=1 again:
>
>       R (t=0)
>      / \
>         D (t=1)
>        / \
>       T   D (t=1)

Tejun's thread mode patch has constraints on what operations are allowed
and what aren't. For a threaded subtree, thread mode cannot be disabled
in the middle of the tree. You have to remove all the child cgroups in
the subtree before you can disable thread mode at the thread root level.
So the second step will not be allowed. We can certainly argue if it is
a good thing or not. What I am talking about is the current behavior of
the patch.

>> With Tejun's v3 patch, the "join" operation was removed and "enable"
> I've no clue what 'enable' is... :-(

The keywords to turn on and off thread mode are:

enable: t=1
disable: t=0

As discussed above, there are constraints on when that transition is
allowed to happen.

>> behaved like "join" in joining the threaded subtree of the root. I was
>> wrong in saying that the configuration listed in your example was not
>> possible. It was, but it depends on the order of activating the thread
>> mode. If we enables thread mode on a child of root first followed by the
>> root itself, we can have your configuration, but not in the reverse
>> order. It was possible in the reverse order in the previous patch.
> Just create a T child, then flip t=0 to convert it to D, then flip it to
> 1 again to create a new thread-root, no?

The constraints are there to make it easier to code and observe
guidelines like no internal process constraint. So what you said above
is not current allowed.

>>> And this is detection by inference, which breaks the moment you disable
>>> all resource domain controllers, because at that point those files will
>>> not be present.
>> It is true that there is no external marker to find out if a threaded
>> cgroup is a root or not when the parent of a thread root is also a
>> thread root of a separate threaded subtree if the domain controller
>> files are not present. However, we can always add a status file to
>> indicate the state of threaded-ness of a cgroup if we want to.
> Why add status files when a simple change in marker can readily provide
> this information?

For thread mode, the only way to find out if a cgroup is in that mode is
to dump out the content of the cgroup.procs and cgroup.threads files.
Reading cgroup.threads will return error if thread mode is not enabled.
Reading cgroup.procs is allowed in the thread root, but not in the rest
of the threaded subtree. So there is a way to find out, but kind of
indirect.


>> Tejun's patch makes resource domain the default and threaded-ness as an
>> additional attribute that needs to be specified. Your proposal make
>> non-resource domain where threads can exist as the default and resource
>> domain as something that needs to be explicitly specified.
> Not so. My proposal has resource domains as the default (remember, root
> _MUST_ be a resource domain, therefore we must start start with
> root.d=1). Therefore, any new subgroup will be a resource domain by
> default and if you ignore the new attribute it will work exactly like
> cgroup-v2 does today.
>
> Only if you clear the new attribute do you get a thread subgroup.

OK.

>> They are just
>> different ways of partitioning a cgroup hierarchy into different
>> domains. Tejun's patch has a well defined boundary for threaded subtree
>> where threads can be migrated from one part of a subtree to another.
>> Your proposal is less clear-cut on how to handle thread migration. 
> Disagree again. We have the exact same boundaries. Just ensure the
> migration doesn't escape the resource domain.
>
Agreed.

Cheers,
Longman

