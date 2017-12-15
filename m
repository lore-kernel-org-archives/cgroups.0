From: Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Sat, 16 Dec 2017 00:36:33 +0530
Message-ID: <b50d7b64-121f-9a4c-5269-aec9a73787ba@codeaurora.org>
References: <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <4e63b5e9-1696-910f-16ac-4d4d7eb98725@codeaurora.org>
 <40968aea-cd73-5ce4-d559-962d91e315c5@codeaurora.org>
 <20171211153258.GI2421075@devbig577.frc2.facebook.com>
 <c54d904e-13bc-8e2b-c9c1-8bf9cb8a33a3@codeaurora.org>
 <20171213154041.GP3919388@devbig577.frc2.facebook.com>
 <c282b638-95ef-b688-9249-f23a733c0a43@codeaurora.org>
 <20171215132222.GF3919388@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513364798;
        bh=yF7nB3b6+IpkNmsmICM0qU8Wi6nwbNkS5E0RYLRz8eM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TkEtkAjenKMx3ajLWyC5rN5qBXbBImhkOBAPfrvg1GmOx1XNsUayBR/hsT5HlGScU
         HTUZ80S767IpBPJa5u8Cr4S3jZTWo9Czz9cxHJZM2KXEMKxcM9ATZLb2TbbB4of95w
         ZV7yNHLJjAnOFtk70iT4HmmSZoR5p+aB+0M9RJY4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513364798;
        bh=yF7nB3b6+IpkNmsmICM0qU8Wi6nwbNkS5E0RYLRz8eM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TkEtkAjenKMx3ajLWyC5rN5qBXbBImhkOBAPfrvg1GmOx1XNsUayBR/hsT5HlGScU
         HTUZ80S767IpBPJa5u8Cr4S3jZTWo9Czz9cxHJZM2KXEMKxcM9ATZLb2TbbB4of95w
         ZV7yNHLJjAnOFtk70iT4HmmSZoR5p+aB+0M9RJY4=
In-Reply-To: <20171215132222.GF3919388@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

On 12/15/2017 06:52 PM, Tejun Heo wrote:
> Hello, Prateek.
> 
> On Fri, Dec 15, 2017 at 02:24:55PM +0530, Prateek Sood wrote:
>> Following are two ways to improve cgroup_transfer_tasks(). In
>> both cases task in PF_EXITING state would be left in source
>> cgroup. It would be removed from cgroup_exit() in exit path.
>>
>> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
>> index 024085d..e2bdcdb 100644
>> --- a/kernel/cgroup/cgroup-v1.c
>> +++ b/kernel/cgroup/cgroup-v1.c
>> @@ -123,7 +123,10 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
>>          */
>>         do {
>>                 css_task_iter_start(&from->self, 0, &it);
>> -               task = css_task_iter_next(&it);
>> +               do {
>> +                       task = css_task_iter_next(&it);
>> +               } while (task && (task & PF_EXITING))
>> +
> 
> Yeah, this looks good to me.  We can't just make a single pass as in
> the other one because we can race aginst fork.  And PF_EXITING being
> left behind is what was happening previously too anyway.  They can't
> be moved.
> 
> Thanks.
> 

Thanks TJ for reviewing.

I will send a formal patch with the above approved approach.


-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
