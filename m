From: Ivan Zahariev <famzah@icdsoft.com>
Subject: Re: Cgroups "pids" controller does not update "pids.current" count
 immediately
Date: Fri, 15 Jun 2018 22:38:04 +0300
Message-ID: <d2c7a301-1d89-7019-8fca-3f34c853ce1a@icdsoft.com>
References: <77af3805-e912-2664-f347-e30c0919d0c4@icdsoft.com>
 <20180614150650.GU1351649@devbig577.frc2.facebook.com>
 <7860105c-553a-534b-57fc-222d931cb972@icdsoft.com>
 <20180615154140.GV1351649@devbig577.frc2.facebook.com>
 <1d635d1d-6152-ecfc-d235-147ff1fe7c95@icdsoft.com>
 <20180615161647.GW1351649@devbig577.frc2.facebook.com>
 <6c2c9bfb-3175-b9ec-cf39-c9d4ebf654b2@icdsoft.com>
 <20180615190724.GX1351649@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615190724.GX1351649@devbig577.frc2.facebook.com>
Content-Language: en-bg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,


On 15.6.2018 г. 22:07 ч., Tejun Heo wrote:
> On Fri, Jun 15, 2018 at 08:40:02PM +0300, Ivan Zahariev wrote:
>> The lazy pids accounting + modern fast CPUs makes the "pids.current"
>> metric practically unusable for resource limiting in our case. For a
>> test, when we started and ended one single process very quickly, we
>> saw "pids.current" equal up to 185 (while the correct value at all
>> time is either 0 or 1). If we want that a "cgroup" can spawn maximum
>> 50 processes, we should use some high value like 300 for "pids.max",
>> in order to compensate the pids uncharge lag (and this depends on
>> the speed of the CPU and how busy the system is).
> Yeah, that actually makes a lot of sense.  We can't keep everything
> synchronous for obvious performance reasons but we definitely can wait
> for RCU grace period before failing.  Forking might become a bit
> slower while pids are draining but shouldn't fail and that shouldn't
> incur any performance overhead in normal conditions when pids aren't
> constrained.

I lack expertise to comment on this. As a system administrator, I can 
only remind that nowadays machines with 80+ CPU cores are something 
usual. I don't know how the RCU grace period scales with an increasing 
number of CPUs.

If you develop a patch for this, we can try it in production and give 
you feedback. Just send me an email notification.

Thank you for your time and attention!

--
Ivan
