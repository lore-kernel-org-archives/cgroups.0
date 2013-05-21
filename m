From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v7 00/34] kmemcg shrinkers
Date: Tue, 21 May 2013 11:27:17 +0400
Message-ID: <519B21D5.9090109@parallels.com>
References: <1368994047-5997-1-git-send-email-glommer@openvz.org> <519B1C45.5090201@parallels.com> <20130521071800.GN24543@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130521071800.GN24543@dastard>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On 05/21/2013 11:18 AM, Dave Chinner wrote:
> On Tue, May 21, 2013 at 11:03:33AM +0400, Glauber Costa wrote:
>> On 05/20/2013 12:06 AM, Glauber Costa wrote:
>>> Initial notes:
>>> ==============
>>>
>>> Please pay attention to new patches that are debuting in this series. Patch1
>>> changes our unused countries for int to long, since Dave noticed that it wasn't
>>> being enough in some cases. Aside from that, the major change is that we now
>>> compute and keep deferred work per-node (Patch13). The biggest effect of this,
>>> is that to avoid storing a new nodemask in the stack, I am passing only the
>>> node id down to the API. This means that the lru API *does not* take a nodemask
>>> any longer, which in turn, makes it simpler.
>>>
>>> I deeply considered this matter, and decided this would be the best way to go.
>>> It is not different from what I have already done for memcgs: Only a single one
>>> is passed down, and the complexity of scanning them is moved upwards to the
>>> caller, where all the scanning logic should belong anyway.
>>>
>>> If you want, you can also grab from branch "kmemcg-lru-shrinker" at:
>>>
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/glommer/memcg.git
>>>
>>> I hope the performance problems are all gone. My testing now shows a smoother
>>> and steady state for the objects during the lifetime of the workload, and
>>> postmark numbers are closer to base, although we do deviate a bit.
>>>
>>
>> Mel, Dave, et. al.
>>
>> I have applied some more fixes for things I have found here and there as
>> a result of a new round of testing. I won't post the result here until
>> Thursday or Friday, to avoid patchbombing you guys. In the meantime I
>> will be merging comments I receive from this version.
>>
>> My git tree is up to date, so if you want to test it further, please
>> pick that up.
> 
> Will do. I hope to do some testing of it tommorrow.
> 
>> I am attaching the result of my postmark run. I think the results look
>> really good now.
> 
> What's version and command line you are using - I'll see if i can
> reproduce the same results on my test system....
> 

I am using Mel's mmtest. So I cloned it, changed to config to run the
postmark benchmark set TEST_PARTITION to my disk, TEST_FILESYSTEM to
ext3 (specially that fsmark was already running xfs with your script),
and then ./run-mmtests.sh <name_of_test>


