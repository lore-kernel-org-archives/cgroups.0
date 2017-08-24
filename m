From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cpuset: Fix incorrect memory_pressure control file
 mapping
Date: Thu, 24 Aug 2017 13:51:18 -0400
Message-ID: <df066c62-931f-df9f-c1e9-7ea1afa4a205@redhat.com>
References: <1503590669-16601-1-git-send-email-longman@redhat.com>
 <20170824164524.GR491396@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170824164524.GR491396@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 08/24/2017 12:45 PM, Tejun Heo wrote:
> On Thu, Aug 24, 2017 at 12:04:29PM -0400, Waiman Long wrote:
>> The memory_pressure control file was incorrectly set up without
>> a private value (0, by default). As a result, this control
>> file was treated like memory_migrate on read. By adding back the
>> FILE_MEMORY_PRESSURE private value, the correct memory pressure value
>> will be returned.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
> Oops, applied to cgroup/for-4.13-fixes w/ stable cc'd.  I broke it way
> back in v4.4 which makes me wonder whether anybody is actually using
> it.

Probably not.

Cheers,
Longman
