From: Ivan Zahariev <famzah@icdsoft.com>
Subject: Re: Cgroups "pids" controller does not update "pids.current" count
 immediately
Date: Fri, 15 Jun 2018 20:40:02 +0300
Message-ID: <6c2c9bfb-3175-b9ec-cf39-c9d4ebf654b2@icdsoft.com>
References: <77af3805-e912-2664-f347-e30c0919d0c4@icdsoft.com>
 <20180614150650.GU1351649@devbig577.frc2.facebook.com>
 <7860105c-553a-534b-57fc-222d931cb972@icdsoft.com>
 <20180615154140.GV1351649@devbig577.frc2.facebook.com>
 <1d635d1d-6152-ecfc-d235-147ff1fe7c95@icdsoft.com>
 <20180615161647.GW1351649@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615161647.GW1351649@devbig577.frc2.facebook.com>
Content-Language: en-bg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On 15.6.2018 г. 19:16 ч., Tejun Heo wrote:
> On Fri, Jun 15, 2018 at 07:07:27PM +0300, Ivan Zahariev wrote:
>> I understand all concerns and design decisions. However, having
>> RLIMIT_NPROC support combined with "cgroups" hierarchy would be very
>> handy.
>>
>> Does it make sense that you introduce "nproc.current" and
>> "nproc.max" metrics which work in the same atomic, real-time way
>> like RLIMIT_NPROC? Or make this in a new "nproc" controller?
> I'm skeptical for two reasons.
>
> 1. That doesn't sound much like a resource control problem but more of
>     a policy enforcement problem.
>
> 2. and it's difficult to see why such policies would need to be that
>     strict.  Where is the requirement coming from?
>

The lazy pids accounting + modern fast CPUs makes the "pids.current" 
metric practically unusable for resource limiting in our case. For a 
test, when we started and ended one single process very quickly, we saw 
"pids.current" equal up to 185 (while the correct value at all time is 
either 0 or 1). If we want that a "cgroup" can spawn maximum 50 
processes, we should use some high value like 300 for "pids.max", in 
order to compensate the pids uncharge lag (and this depends on the speed 
of the CPU and how busy the system is).

Our use-case is for a shared web hosting service. Our customers start a 
CGI process for each PHP web request and therefore process start/end 
happens at a very high rate. We don't want customers to be able to 
launch too many CGI processes (NPROC limit) because this exhausts the 
web & database servers, and probably obsesses Linux kernel resources 
(like total "opened files" per user). Furthermore, some users are 
malicious and launch fork-bombs and other resource-exhaustion attacks.

You may be right that we enforce a policy rather than resource control. 
This has worked for us for 15+ years now. The motivation is that a 
global RLIMIT_NPROC easily let's us limit all system and Linux kernel 
resources "per customer" ("cgroups" allows us to limit only certain 
system resources). Additionally, not all user-space daemons allow for a 
granular "per user" limit or proper grouping (for example, MySQL has 
only users, and no "per customer" groups support). Now we want to have 
different "cgroups" hierarchies for a customer (SSH, CGI, Crond), each 
with their own RLIMIT_NPROC, and a total RLIMIT_NPROC for the parent 
"per customer" cgroup.

Excuse me for the lengthy post :-)

--
Ivan


