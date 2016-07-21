From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Fri, 22 Jul 2016 01:07:13 +1000
Message-ID: <4bc13b20-9e8f-f43c-27aa-df5ec981762e@suse.de>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-4-asarai@suse.de>
 <20160720155147.GG4574@htj.duckdns.org>
 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
 <20160720230228.GA19588@mtj.duckdns.org>
 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
 <20160720231949.GB19588@mtj.duckdns.org>
 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
 <20160721143330.GA5751@mail.hallyn.com>
 <1469112709.2331.11.camel@HansenPartnership.com>
 <20160721145905.GC22680@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160721145905.GC22680-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

>> I have heard
>>
>>  * it would give power to move other tasks to more rigid constraints.
>>     To which the answer is only to allow movememnt of tasks in the
>>    current cgroupns
>>  * It violates the permissions delegation model.  This one doesn't
>>    really make too much sense to me: in the same way the userns is root
>>    in its own domain, cgroups ns is effective root for the restricted
>>    cgroups (and only for processes within its ns).
>>
>> Perhaps the question should be asked the other way around:  if we were
>> explicitly delegating permission to every user in the system to set up
>> their own sub cgroups, how would you advise it be done?
>
> Coordinate in userspace.  Request whatever is managing the cgroup
> hierarchy to set up delegation.  It's not like permission model is
> fully contained in kernel on modern systems anyway.

My experience with certain systemdaemons' cgroup handling doesn't 
inspire confidence :/ (from the runC side, we've had nothing but 
issues). Also, how do you even boot into a cgroupv2 system with systemd 
(I started backporting patches to openSUSE, but it's still not booting)?

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
