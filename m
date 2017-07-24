From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/4] cgroup: Allow bypass mode in subtree_control
Date: Mon, 24 Jul 2017 14:20:59 -0400
Message-ID: <3cf09046-7eac-82fe-8bd2-6aef1125b10c@redhat.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
 <1500669293-21792-3-git-send-email-longman@redhat.com>
 <20170722135030.GC3329631@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com B0AFB7F7B9
In-Reply-To: <20170722135030.GC3329631-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On 07/22/2017 09:50 AM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Fri, Jul 21, 2017 at 04:34:51PM -0400, Waiman Long wrote:
>> The special prefix '#' attached to a controller name can now be written
>> into the cgroup.subtree_control file to set that controller in bypass
>> mode in all the child cgroups. The controller will show up in the
>> children's cgroup.controllers file, but the corresponding control knobs
>> will be absent. However, that controller can be enabled or bypassed
>> in its children by writing to their respective subtree_control files.
>>
>> This mode can be useful to non-domain controllers or controllers where
>> there are costs to each additional layer of hierarchy. This mode will
>> also allow more freedom in how each controller can shape its effective
>> hierarchy independent of each others.
> While this continues to be an interesting idea.  I'm still having a
> bit of hard time with the change.  The biggest blocks are
>
> * As raised a couple times before, how would this work in terms of
>   resource ownership and delegation?  The last time we spoke about
>   this, I felt that we were mostly talking past each other.  I think
>   it'd really help to think about / explain how this would work with
>   delegation to clarify who owns what.

As said in patch 3, enabling bypass mode at subtree_control delegate the
authority of enabling controllers to the children. The children own the
resource control files directly. It will be more straight forward to
explain if bypass mode can only be used consistently from the root down.
Having a mix of regular enable and bypass down the tree will be more
tricky to talk about.

> * While the idea is interesting, I think we need more concrete
>   usecases to justify the addition and make sure that we aren't doing
>   something misguided.  Can you please illustrate / give examples of
>   how this would be useful?

Bypass mode targets mainly non-domain controllers and controllers that
have cost associated with each additional level of hierarchy (e.g. cpu).
I believe the end goal of cgroup v2 is to have all controllers migrated
to it eventually. Consider the following:

    A
   / \
  B   C
 / \ / \
D  E F G

Controller X may want (A, B, C) to be controlled as one group with one
set of control files whereas D, E, F, G will have their own control
files. Controller Y may want all of them have their own control files.
Bypass mode allows us to do that. With more and more controllers enabled
in v2, the chance of this kind of configuration conflicts is going up.

I am willing to take a more limited form of bypass mode that have to be
either enabled (+) or bypass (#) only from the root down for the time
being and then consider allowing their mixing later on if you think it
is more acceptable to you.

Cheers,
Longman
