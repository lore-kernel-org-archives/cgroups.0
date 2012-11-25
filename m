From: "azurIt" <azurit-Rm0zKEqwvD4@public.gmane.org>
Subject: =?utf-8?q?Re=3A_memory=2Dcgroup_bug?=
Date: Sun, 25 Nov 2012 14:27:09 +0100
Message-ID: <20121125142709.19F4E8C2@pobox.sk>
References: <20121122152441.GA9609@dhcp22.suse.cz>, <20121122190526.390C7A28@pobox.sk>, <20121122214249.GA20319@dhcp22.suse.cz>, <20121122233434.3D5E35E6@pobox.sk>, <20121123074023.GA24698@dhcp22.suse.cz>, <20121123102137.10D6D653@pobox.sk>, <20121123100438.GF24698@dhcp22.suse.cz>, <20121123155904.490039C5@pobox.sk>, <20121125101707.GA10623@dhcp22.suse.cz>, <20121125133953.AD1B2F0A@pobox.sk> <20121125130208.GC10623@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121125130208.GC10623-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?utf-8?q?cgroups_mailinglist?= <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

>> Thank you very much, i will install it ASAP (probably this night).
>
>Please don't. If my analysis is correct which I am almost 100% sure it
>is then it would cause excessive logging. I am sorry I cannot come up
>with something else in the mean time.


Ok then. I will, meanwhile, try to contact Andrea Righi (author of cgroup-task etc.) and ask him to send here his opinion about relation between freezes and his patches. Maybe it's some kind of a bug in memcg which don't appear in current vanilla code and is triggered by conditions created by, for example, cgroup-task. I noticed that there is always the exact number of freezed processes as the limit set for number of tasks by cgroup-task (i already tried to raise this limit AFTER the cgroup was freezed, didn't change anything). I'm sure it's not the problem with cgroup-task alone, it's 100% related also to memcg (but maybe there must be the combination of both of them).

Thank you so far for your time!

azur
