From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
Date: Thu, 13 Jun 2019 12:13:05 -0700
Message-ID: <72856150-d678-42bd-0377-82dbee6513ba@csail.mit.edu>
References: <8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu>
 <FC24E25F-4578-454D-AE2B-8D8D352478D8@linaro.org>
 <0e3fdf31-70d9-26eb-7b42-2795d4b03722@csail.mit.edu>
 <F5E29C98-6CC4-43B8-994D-0B5354EECBF3@linaro.org>
 <686D6469-9DE7-4738-B92A-002144C3E63E@linaro.org>
 <01d55216-5718-767a-e1e6-aadc67b632f4@csail.mit.edu>
 <CA8A23E2-6F22-4444-9A20-E052A94CAA9B@linaro.org>
 <cc148388-3c82-d7c0-f9ff-8c31bb5dc77d@csail.mit.edu>
 <6FE0A98F-1E3D-4EF6-8B38-2C85741924A4@linaro.org>
 <2A58C239-EF3F-422B-8D87-E7A3B500C57C@linaro.org>
 <a04368ba-f1d5-8f2c-1279-a685a137d024@csail.mit.edu>
 <E270AD92-943E-4529-8158-AB480D6D9DF8@linaro.org>
 <5b71028c-72f0-73dd-0cd5-f28ff298a0a3@csail.mit.edu>
 <FFA44D26-75FF-4A8E-A331-495349BE5FFC@linaro.org>
 <0d6e3c02-1952-2177-02d7-10ebeb133940@csail.mit.edu>
 <7B74A790-BD98-412B-ADAB-3B513FB1944E@linaro.org>
 <6a6f4aa4-fc95-f132-55b2-224ff52bd2d8@csail.mit.edu>
 <7c5e9d11-4a3d-7df4-c1e6-7c95919522ab@csail.mit.edu>
 <43486E4F-2237-4E40-BDFE-07CFCCFFFA25@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <43486E4F-2237-4E40-BDFE-07CFCCFFFA25@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: linux-fsdevel@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-ext4@vger.kernel.org, cgroups@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>

On 6/12/19 10:46 PM, Paolo Valente wrote:
> 
>> Il giorno 12 giu 2019, alle ore 00:34, Srivatsa S. Bhat <srivatsa@csail.mit.edu> ha scritto:
>>
[...]
>>
>> Hi Paolo,
>>
> 
> Hi
> 
>> Hope you are doing great!
>>
> 
> Sort of, thanks :)
> 
>> I was wondering if you got a chance to post these patches to LKML for
>> review and inclusion... (No hurry, of course!)
>>
> 
> 
> I'm having troubles testing these new patches on 5.2-rc4.  As it
> happened with the first release candidates for 5.1, the CPU of my test
> machine (Intel Core i7-2760QM@2.40GHz) is so slowed down that results
> are heavily distorted with every I/O scheduler.
> 

Oh, that's unfortunate!

> Unfortunately, I'm not competent enough to spot the cause of this
> regression in a feasible amount of time.  I hope it'll go away with
> next release candidates, or I'll test on 5.1.
> 

Sounds good to me!

>> Also, since your fixes address the performance issues in BFQ, do you
>> have any thoughts on whether they can be adapted to CFQ as well, to
>> benefit the older stable kernels that still support CFQ?
>>
> 
> I have implanted my fixes on the existing throughput-boosting
> infrastructure of BFQ.  CFQ doesn't have such an infrastructure.
> 
> If you need I/O control with older kernels, you may want to check my
> version of BFQ for legacy block, named bfq-sq and available in this
> repo:
> https://github.com/Algodev-github/bfq-mq/
>

Great! Thank you for sharing this!
 
> I'm willing to provide you with any information or help if needed.
> 
Thank you!

Regards,
Srivatsa
VMware Photon OS
