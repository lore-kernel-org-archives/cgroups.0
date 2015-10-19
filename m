From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-4.4] cgroup: make zombies retain cgroup
 membership and fix pids controller
Date: Mon, 19 Oct 2015 16:48:22 +0800
Message-ID: <5624AE56.3010407@huawei.com>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
 <20151015013809.GC20884@htj.duckdns.org>
 <20151015204114.GA3788@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151015204114.GA3788-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hi Tejun,

On 2015/10/16 4:41, Tejun Heo wrote:
> On Wed, Oct 14, 2015 at 09:38:09PM -0400, Tejun Heo wrote:
>> Hello,
>>
>> On Fri, Oct 09, 2015 at 11:29:27PM -0400, Tejun Heo wrote:
>>> The patchset is pretty lightly tested and I need to verify that the
>>> corner cases behave as expected.
>>
>> Fixed several bugs while testing.  Updated patches posted.  Seems to
>> work fine now.  git branch has been refreshed with the updated
>> patches.
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-zombies
>>
>> Li, can you please go over the changes?
>
> I want this series to be in -next at least for a couple weeks before
> the merge window opens, so I'm applying it to cgroup/for-4.4 now.
> Please let me know if you spot something wrong.  Let's fix it up
> incrementally.
>

Sorry for the late reply. I was travelling last week. I'll review those
changes within this week.
