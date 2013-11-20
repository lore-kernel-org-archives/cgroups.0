From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blkcg: have bh disable for 32bit UP system reading 64bit
 stats
Date: Wed, 20 Nov 2013 10:31:31 -0700
Message-ID: <528CF1F3.7020106@kernel.dk>
References: <1383736484-393-1-git-send-email-zhiguohong@tencent.com> <20131120172413.GN28946@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131120172413.GN28946@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Hong Zhiguo <honkiko@gmail.com>
Cc: vgoyal@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>

On 11/20/2013 10:24 AM, Tejun Heo wrote:
> On Wed, Nov 06, 2013 at 07:14:44PM +0800, Hong Zhiguo wrote:
>> From: Hong Zhiguo <zhiguohong@tencent.com>
>>
>> Update of blkg_stat and blkg_rwstat may happen in bh context.
>> While u64_stats_fetch_retry is only preempt_disable on 32bit
>> UP system. This is not enough to avoid preemption by bh and
>> may read strange 64 bit value.
>>
>> Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Jens, can you please pick this one up?  This probably needs to be
> tagged for stable too.

Yeah will do, thanks.

-- 
Jens Axboe
