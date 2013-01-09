From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v5 11/11] sched: introduce cgroup file stat_percpu
Date: Thu, 10 Jan 2013 01:10:02 +0400
Message-ID: <50EDDCAA.6070004@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com> <1357731938-8417-12-git-send-email-glommer@parallels.com> <20130109124220.ad9f1a54.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130109124220.ad9f1a54.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>

On 01/10/2013 12:42 AM, Andrew Morton wrote:
> On Wed,  9 Jan 2013 15:45:38 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>> The file cpu.stat_percpu will show various scheduler related
>> information, that are usually available to the top level through other
>> files.
>>
>> For instance, most of the meaningful data in /proc/stat is presented
>> here. Given this file, a container can easily construct a local copy of
>> /proc/stat for internal consumption.
>>
>> The data we export is comprised of:
>> * all the tick information, previously available only through cpuacct,
>>   like user time, system time, etc.
>>
>> * wait time, which can be used to construct analogous information to
>>   steal time in hypervisors,
>>
>> * nr_switches and nr_running, which are cgroup-local versions of
>>   their global counterparts.
>>
>> The file includes a header, so fields can come and go if needed.
> 
> Please update this changelog to fully describe the proposed userspace
> interfaces.  That means full pathnames and example output. 
> Understanding these interfaces is the most important part of reviewing
> this patchset, so this info should be prominent.
> 
> Also, this patchset appears to alter (or remove?) existing userspace
> interfaces?  If so, please clearly describe those alterations and also
> share your thinking on the back-compatibility issues.
> 
> Also, I'm not seeing any changes to Docmentation/ in this patchset. 
> How do we explain the interface to our users?
> 
> 
> From a quick read, it appears that the output will be something along
> the lines of:
> 
> user nice system irq softirq guest guest_nice wait nr_switches nr_running
> cpu0 nn nn nn nn nn ...
> cpu1 nn nn nn nn nn ...
> 
> which looks pretty terrible.  Apart from being very hard to read, it
> means that we can never remove fields.  A nicer and more extensible
> interface would be
> 
> cpu:0 nice:nn system:nn irq:nn ...
> 

Ok.

The actual output format is what matters the least to me, so I can
change to whatever pleases you guys.

I just don't how is it that we can never remove fields. My very
motivation for adding a header in the first place, was to give us
ability to extend this.

For a next round, I will include a Documentation file as you requested.
I could, for instance, explicitly mention that people parsing this
should first query the first line, which constitutes a header.

The main advantage I see in this approach, is that there is way less
data to be written using a header. Although your way works, it means we
will write the strings "nice", "system", etc. #cpu times. Quite a waste.

> 
