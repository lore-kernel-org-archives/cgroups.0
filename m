From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5 03/11] cgroup, sched: let cpu serve the same files
 as cpuacct
Date: Tue, 15 Jan 2013 09:52:01 -0800
Message-ID: <50F59741.7010002@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com> <1357731938-8417-4-git-send-email-glommer@parallels.com> <CAFj3OHW5J8ypLZdW16AfiYR5y2S54mQxm5qka4m_3qsoGdD11A@mail.gmail.com> <50F41C50.6090000@parallels.com> <CAFj3OHWB8GF9UYcLdObptrY+BfB=EEwbBtsf17M1=6qfZt+k6g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFj3OHWB8GF9UYcLdObptrY+BfB=EEwbBtsf17M1=6qfZt+k6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>

On 01/15/2013 02:19 AM, Sha Zhengju wrote:
> On Mon, Jan 14, 2013 at 10:55 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>> On 01/14/2013 12:34 AM, Sha Zhengju wrote:
>>>> +               struct kernel_cpustat *kcpustat = this_cpu_ptr(ca->cpustat);
>>>>> +
>>>>>                 kcpustat = this_cpu_ptr(ca->cpustat);
>>> Is this reassignment unnecessary?
>>>
>>>
>> No.
>>
> 
> No?  No!
> 
I misread your question as "is this reassignment necessary".
For which the answer is no: there is no reason to do it, it is just a
bad chunk.
