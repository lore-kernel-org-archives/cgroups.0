From: Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH kselftest-next] Add cgroup core selftests
Date: Tue, 24 Jul 2018 10:47:53 -0600
Message-ID: <5fa20088-3797-7252-43b1-c7ede9e142f8@kernel.org>
References: <20180718173358.14007-1-claudiozumbo@gmail.com>
 <20180719170829.GB21770@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180719170829.GB21770@castle.DHCP.thefacebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>, Claudio <claudiozumbo@gmail.com>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Claudio Zumbo <claudioz@fb.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, Shuah Khan <shuah@kernel.org>

On 07/19/2018 11:08 AM, Roman Gushchin wrote:
> On Wed, Jul 18, 2018 at 07:33:58PM +0200, Claudio wrote:
>> This commit adds tests for some of the core functionalities
>> of cgroups v2.
>>
>> The commit adds tests for some core principles of croup V2 API:
>>
>> - test_cgcore_internal_process_constraint
>>
>>   Tests internal process constraint.
>>   You can't add a pid to a domain parent if a controller is enabled.
>>
>> - test_cgcore_top_down_constraint_enable
>>
>>    Tests that you can't enable a controller on a child if it's not enabled
>>    on the parent.
>>
>> - test_cgcore_top_down_constraint_disable
>>
>>   Tests that you can't disable a controller on a parent if it's
>>   enabled in a child.
>>
>> - test_cgcore_no_internal_process_constraint_on_threads
>>
>>   Tests that there's no internal process constrain on threaded cgroups.
>>   You can add threads/processes on a parent with a controller enabled.
>>
>> - test_cgcore_parent_becomes_threaded
>>
>>   Tests that when a child becomes threaded the parent type becomes
>>   domain threaded.
>>
>> - test_cgcore_invalid_domain
>>
>>   In a situation like:
>>
>>   A (domain threaded) - B (threaded) - C (domain)
>>
>>   it tests that C can't be used until it is turned into a threaded cgroup.
>>   The "cgroup.type" file will report "domain (invalid)" in these cases.
>>   Operations which fail due to invalid topology use EOPNOTSUPP as the errno.
>>
>> - test_cgcore_populated
>>
>>   In a situation like:
>>
>>   A(0) - B(0) - C(1)
>>          \ D(0)
>>
>>   It tests that A, B and C's "populated" fields would be 1 while D's 0.
>>   It tests that after the one process in C is moved to root, A,B and C's
>>   "populated" fields would flip to "0" and file modified events will
>>   be generated on the "cgroup.events" files of both cgroups.
>>
>> Signed-off-by: Claudio Zumbo <claudioz@fb.com>
>> Cc: Shuah Khan <shuah@kernel.org>
>> Cc: Roman Gushchin <guro@fb.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: kernel-team@fb.com
> 
> Looks good to me!
> 
> Reviewed-by: Roman Gushchin <guro@fb.com>
> 
> Thank you!
> 

Thanks for the new test. I will queue this up for 4.19-rc1

-- Shuah
