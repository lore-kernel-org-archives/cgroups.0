From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH-cgroup 5/6] cgroup: Skip dying css in
 cgroup_apply_control_{enable,disable}
Date: Wed, 21 Jun 2017 18:19:53 -0400
Message-ID: <dbf6fb6f-1a99-2fbb-b449-1e08946d8c15@redhat.com>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-6-git-send-email-longman@redhat.com>
 <20170621214216.GE14720@htj.duckdns.org>
 <81c62822-8bb6-ae68-112a-dad49414e3f1@redhat.com>
 <20170621220438.GB18600@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com B3F3E7F3F2
In-Reply-To: <20170621220438.GB18600-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On 06/21/2017 06:04 PM, Tejun Heo wrote:
> Hello,
>
> On Wed, Jun 21, 2017 at 06:01:56PM -0400, Waiman Long wrote:
>> I do think that it can happen with existing code because CSS killing is
>> asynchronous, I think. So the command can complete before the CSS is
>> actually gone. If the next command to reactivate it happens fast enough,
>> we can trigger that. When I added more checking to my test script
>> essentially increasing the latency between successive tests, I couldn't
>> trigger it anymore.
> While disabling is asynchronous, there's a flushing logic before
> starting reenabling things, so the existing code shouldn't trigger
> that condition.  But then there's should and the reality. :)
>
> Thanks.
>
I actually got errors from cgroup_addrm_files() complaining about
creating existing sysfs files because of the css_populate_dir() call
when the css was dying but not gone yet. I added code in the patch just
to sidestep that. Maybe I should just force the call to css_create()
when the old one is dying to see if that will work out.

Cheers,
Longman

