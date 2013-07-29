From: Holger Brunck <holger.brunck-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Subject: Re: cgroups and SCHED_IDLE
Date: Mon, 29 Jul 2013 14:25:33 +0200
Message-ID: <51F65F3D.1080503@keymile.com>
References: <51CC7392.8080701@keymile.com> <51D139B4.8070407@keymile.com> <20130723155634.GD18458@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130723155634.GD18458-9pTldWuhBndy/B6EtB590w@public.gmane.org>
In-Reply-To: 20130723155634.GD18458-9pTldWuhBndy/B6EtB590w@public.gmane.org
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Germs, Frits (extern)" <Frits.Germs-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 07/23/2013 05:56 PM, Tejun Heo wrote:
>> On 06/27/2013 07:17 PM, Holger Brunck wrote:
>>
>> On a single ARM CPU (kirkwood) I see the same confusing results similar to the
>> results of the above powerpc example:
>>
>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>   232 root      20   0  1924  492  420 R 99.9  0.4   0:29.15 dd
>>   234 root      20   0  1924  492  420 R  0.3  0.4   0:00.13 dd
>>
>> I doublechecked this on my local host x86_64 multicore and here it works fine
>> even if I force both dd processes to run on the same CPU:
>>
>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>> 32046 root      20   0  102m  516  432 R 49.4  0.0   0:32.49 dd
>> 32049 root      20   0  102m  516  432 R 49.4  0.0   0:13.39 dd
>>
>> So either it's a problem for single CPUs or it's not allowed at all and works
>> only by chance.
> 
> Can you please boot with maxcpus=1 and see whether that makes the
> issue reproducible on x86?
> 

I retested this with maxcpus=0 to disable SMP completely and it works, both
processes share 50% of the CPU. But I have to admit that I currently have only a
3.4 setup for my x86_64 PC.

My setup for an arm kirkwood board and a board with a powerpc 8247 runs latest
3.10 kernel where I see the problem that one process is starving.  But the
problem was already present in a 3.0.x kernel. So it seems to be a architecture
dependent problem.

Regards
Holger
