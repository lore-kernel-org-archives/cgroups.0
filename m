From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH-cgroup 1/6] cgroup: Relax the no internal process
 constraint
Date: Wed, 21 Jun 2017 17:50:09 -0400
Message-ID: <6c115cf4-e229-413c-f63f-26fb8fd870d9@redhat.com>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-2-git-send-email-longman@redhat.com>
 <20170621204050.GA14720@htj.duckdns.org>
 <0c752151-f4aa-cda0-ba36-77cdc7dc25c6@redhat.com>
 <20170621213905.GD14720@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 5AF2861D24
In-Reply-To: <20170621213905.GD14720-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On 06/21/2017 05:39 PM, Tejun Heo wrote:
> Hello,
>
> On Wed, Jun 21, 2017 at 05:37:00PM -0400, Waiman Long wrote:
>>> What happens when we add domain handling to CPU so that it is both a
>>> domain and resource controller?  Even if that somehow can be resolved,
>>> wouldn't that come with a rather surprising userland behavior changes?
>>> Also, I'm not sure what we're achieving by doing this.  It doesn't
>>> really relax the restriction.  It just turns it off implicitly when
>>> certain conditions are met, which doesn't really allow any real
>>> capabilities and at least to me the behaviors feel more subtle and
>>> complicated than before.
>> I think CPU isn't a good example for that.
> Can you please elaborate?

CPU is probably the most prominent controller where deep hierarchy has a
performance cost. So I can't envision that it will forbid internal
process competition.
 
>> Another alternative is to treat no internal process as a controller
>> attribute. Then we don't need to worry about this intricate question and
>> let the  controllers decide if they will allow internal processes.
> Isn't that what "threaded" is?
>

That is exactly what this patch intends to do. However, you raised
concern that threaded may not be equivalent to the need of allowing
internal process. That is why I propose that. If your concern is only
about the documentation change, we can certainly fix that.

Cheers,
Longman
