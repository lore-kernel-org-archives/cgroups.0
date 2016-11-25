From: Marat Khalili <mkh-CePww0+mnY4@public.gmane.org>
Subject: cgroups and nice
Date: Fri, 25 Nov 2016 17:34:37 +0300
Message-ID: <8e909b7a-ad0f-431c-4981-3cafe2690da1@rqc.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I have a question as a cgroup cpu limits user: how does it interact with 
nice? Documentation creates the impression that, as long as number of 
processes demanding the cpu time exceeds number of available cores, time 
allocated will be proportional to configured cpu.shares. However, in 
practice I observe that group with niced processes significantly under 
perform.

For example, suppose on a 6-core box /cgroup/cpu/group1/cpu.shares is 
400, and /cgroup/cpu/group2/cpu.shares is 200.
1) If I run `stress -c 6` in both groups, I should see approximately 
400% of cpu time in group1 and 200% in group2 in top output, regardless 
of their relative nice value.
2) If I run `nice -n 19 stress -c 1` in cgroup1 and `stress -c 24` in 
group2, I should see at least 100% of cpu time in group1.

What I see is significantly less cpu time in group1 if group1 processes 
happen to have greater nice value, and especially if group2 have greater 
number of processes involved: cpu load of group1 in example 2 can be as 
low as 20%. It may create tensions among users in my case; how can this 
be avoided except by renicing all processes to the same value?

> $ uname -a
> Linux redacted 2.6.32-642.11.1.el6.x86_64 #1 SMP Fri Nov 18 19:25:05 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

> $ lsb_release -a
> LSB Version:	:base-4.0-amd64:base-4.0-noarch:core-4.0-amd64:core-4.0-noarch:graphics-4.0-amd64:graphics-4.0-noarch:printing-4.0-amd64:printing-4.0-noarch
> Distributor ID:	CentOS
> Description:	CentOS release 6.8 (Final)
> Release:	6.8
> Codename:	Final

(My apologies if I'm posting to incorrect list.)

--

With Best Regards,
Marat Khalili
