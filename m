From: Ivan Zahariev <famzah@icdsoft.com>
Subject: Re: Cgroups "pids" controller does not update "pids.current" count
 immediately
Date: Fri, 15 Jun 2018 17:26:04 +0300
Message-ID: <7860105c-553a-534b-57fc-222d931cb972@icdsoft.com>
References: <77af3805-e912-2664-f347-e30c0919d0c4@icdsoft.com>
 <20180614150650.GU1351649@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180614150650.GU1351649@devbig577.frc2.facebook.com>
Content-Language: en-bg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 14.6.2018 г. 18:06 ч., Tejun Heo wrote:
> On Thu, Jun 14, 2018 at 02:56:00PM +0300, Ivan Zahariev wrote:
>> I posted a kernel bug about this a month ago but it did not receive
>> any attention: https://bugzilla.kernel.org/show_bug.cgi?id=199713
>>
>> Here is a copy of the bug report and I hope that this is the correct
>> place to discuss this:
> Well, for now at least, that's the expected behavior.  It's not
> supposed to be able to account all changes immediately (the kernel
> doesn't free a lot of things immediately for performance and other
> reasons).  The intended use is setting up a reasonable upperbound with
> some buffer space.

If that's by design, it's a bit disappointing and at least the docs 
should mention it.

The standard RLIMIT_NPROC does not suffer from such accounting 
discrepancies at any time. The "memory" cgroups controller also does not 
suffer from any discrepancies -- it accounts memory usage in real time 
without any lag on process start or exit. The "tasks" file list is also 
always up-to-date.

Is it really technically not possible to make "pids.current" do 
accounting properly like RLIMIT_NPROC does? We were hoping to replace 
RLIMIT_NPROC with the "pids" controller.

--Ivan
