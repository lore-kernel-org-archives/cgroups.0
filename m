From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v2 12/17] cgroup: Remove cgroup v2 no internal process
 constraint
Date: Wed, 24 May 2017 14:19:12 -0400
Message-ID: <97996c22-57c3-aea4-c06a-5a57e8520f36@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-13-git-send-email-longman@redhat.com>
 <20170519203824.GC15279@wtj.duckdns.org>
 <93a69664-4ba6-9ee8-e4ea-ce76b6682c77@redhat.com>
 <20170524170527.GH24798@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 899AA7F6AA
In-Reply-To: <20170524170527.GH24798-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org

On 05/24/2017 01:05 PM, Tejun Heo wrote:
> Hello,
>
> On Mon, May 22, 2017 at 12:56:08PM -0400, Waiman Long wrote:
>> All controllers can use the special sub-directory if userland chooses to
>> do so. The problem that I am trying to address in this patch is to allow
>> more natural hierarchy that reflect a certain purpose, like the task
>> classification done by systemd. Restricting tasks only to leaf nodes
>> makes the hierarchy unnatural and probably difficult to manage.
> I see but how is this different from userland just creating the leaf
> cgroup?  I'm not sure what this actually enables in terms of what can
> be achieved with cgroup.  I suppose we can argue that this is more
> convenient but I'd like to keep the interface orthogonal as much as
> reasonably possible.
>
> Thanks.
>
I am just thinking that it is a bit more natural with the concept of the
special resource domain sub-directory. You are right that the same
effect can be achieved by proper placement of tasks and enabling of
controllers.

A (cpu,memory) [T1] - B(cpu,memory) [T2]
                                  \ cgroups.resource_domain (memory)

A (cpu,memory)  - B(cpu,memory) [T2]
                            \ C (memory) [T1]

With respect to the tasks T1 and T2, the above 2 configurations are the
same.

I am OK to drop this patch. However, I still think the current
no-internal process constraint is too restricting. I will suggest either

 1. Allow internal processes and document the way to avoid internal
    process competition as shown above from the userland, or
 2. Mark only certain controllers as not allowing internal processes
    when they are enabled.

What do you think about this?

Cheers,
Longman
