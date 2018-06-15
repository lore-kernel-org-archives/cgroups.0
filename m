From: Ivan Zahariev <famzah@icdsoft.com>
Subject: Re: Cgroups "pids" controller does not update "pids.current" count
 immediately
Date: Fri, 15 Jun 2018 19:07:27 +0300
Message-ID: <1d635d1d-6152-ecfc-d235-147ff1fe7c95@icdsoft.com>
References: <77af3805-e912-2664-f347-e30c0919d0c4@icdsoft.com>
 <20180614150650.GU1351649@devbig577.frc2.facebook.com>
 <7860105c-553a-534b-57fc-222d931cb972@icdsoft.com>
 <20180615154140.GV1351649@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615154140.GV1351649@devbig577.frc2.facebook.com>
Content-Language: en-bg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

Thank you for the quick and insightful reply. I have one suggestion below:

On 15.6.2018 г. 18:41 ч., Tejun Heo wrote:
> On Fri, Jun 15, 2018 at 05:26:04PM +0300, Ivan Zahariev wrote:
>> The standard RLIMIT_NPROC does not suffer from such accounting
>> discrepancies at any time.
> They seem equivalent but serve a bit different purposes.  RLIMIT_NPROC
> is primarily about limiting what the user can do and doesn't guarantee
> that that actually matches resource (pid here) consumption.
>
>> Is it really technically not possible to make "pids.current" do
>> accounting properly like RLIMIT_NPROC does? We were hoping to
>> replace RLIMIT_NPROC with the "pids" controller.
> It is of course possible but at a cost.  The cost (getting rid of lazy
> release optimizations) is just not justifiable for most cases.

I understand all concerns and design decisions. However, having 
RLIMIT_NPROC support combined with "cgroups" hierarchy would be very handy.

Does it make sense that you introduce "nproc.current" and "nproc.max" 
metrics which work in the same atomic, real-time way like RLIMIT_NPROC? 
Or make this in a new "nproc" controller?

--
Ivan
--
