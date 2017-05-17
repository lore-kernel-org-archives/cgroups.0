From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v2 07/17] cgroup: Prevent kill_css() from being called
 more than once
Date: Wed, 17 May 2017 16:24:32 -0400
Message-ID: <c541638f-b302-8c96-0dcd-f4b758a4a81f@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-8-git-send-email-longman@redhat.com>
 <20170517192357.GC942@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 353C37F4A5
In-Reply-To: <20170517192357.GC942-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org

On 05/17/2017 03:23 PM, Tejun Heo wrote:
> Hello,
>
> On Mon, May 15, 2017 at 09:34:06AM -0400, Waiman Long wrote:
>> The kill_css() function may be called more than once under the condition
>> that the css was killed but not physically removed yet followed by the
>> removal of the cgroup that is hosting the css. This patch prevents any
>> harmm from being done when that happens.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> So, this is a bug fix which isn't really related to this patchset.
> I'm applying it to cgroup/for-4.12-fixes w/ stable cc'd.
>
> Thanks.
>
Actually, this bug can be easily triggered with the resource domain
patch later in the series. I guess it can also happen in the current
code base, but I don't have a test that can reproduce it.

Regards,
Longman
