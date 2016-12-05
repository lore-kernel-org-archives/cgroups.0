From: Marat Khalili <mkh-CePww0+mnY4@public.gmane.org>
Subject: Re: How to avoid rebuilding cgroup quotas after moving VPS to a
 different hypervisor
Date: Mon, 5 Dec 2016 15:07:48 +0300
Message-ID: <a4a22ceb-6606-350a-e881-c0bd9d8bc5e6@rqc.ru>
References: <1A3D5B84-0ECC-4EBA-8FC4-E3B291787DDA@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1A3D5B84-0ECC-4EBA-8FC4-E3B291787DDA-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Generally, I do not think it is possible or will ever be possible by 
using cgroup parameters only, because:

a) Kernel does not care much about CPU frequency, it often determines it 
incorrectly, and the frequency itself changes often in a live system 
because of power management and various other technologies. Even with 
special tests it is not easy to determine exact frequency the CPU is 
capable of sustaining.

b) Frequency does not define performance in real tasks. Your 3 GHz CPU 
is not necessary 1.5 faster than your old 2 GHz one, and this figure 
depends very much on your task.

That said, I think it is possible to solve your problem indirectly, by 
rewriting configs automatically on boot based on bogomips or some other 
benchmark.


--

With Best Regards,
Marat Khalili
